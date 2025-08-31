import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meme_verse/app/core/config/app_constant.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';
import 'package:meme_verse/app/core/models/comment_model.dart';
import 'package:meme_verse/app/core/models/reply_model.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';
import 'package:meme_verse/app/data/login_credentials.dart';
import 'package:meme_verse/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var currentIndex = 0.obs;
  var feedList = <MemeModel>[].obs;
  var trendingList = <MemeModel>[].obs;
  var recommendations = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final Rx<String?> replyingToCommentId = Rx<String?>(null);
  final Rx<String?> replyingToUsername = Rx<String?>(null);
  final LoginCredential loginCredential = LoginCredential();

  // Available reactions and their corresponding emojis
  final Map<String, String> reactionEmojis = {
    'like': '👍',
    'love': '❤️',
    'laugh': '😂',
    'wow': '😮',
    'sad': '😢',
    'angry': '😠',
  };
  // For comments section
  final RxList<CommentModel> currentMemeComments = <CommentModel>[].obs;
  final RxBool isCommentsLoading = false.obs;
  final RxBool isPostingComment = false.obs;

  final firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  final titleController = TextEditingController();
  var pickedFile = Rx<File?>(null);
  var newList = <MemeModel>[].obs;
  late TabController tabController;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void onInit() async {
    super.onInit();
    // Fetch feeds and recommendations on initialization
    tabController = TabController(length: 3, vsync: this);

    await refreshFeed();
    await refreshTrending();
    // await fetchRecommendations();
  }

  @override
  void onClose() {
    tabController.dispose(); // Dispose of the TabController
    super.onClose();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> refreshFeed() async {
    try {
      isLoading.value = true;
      // Fetch memes that are not trending, ordered by creation date
      final snapshot = await firestore
          .collection('memes')
          .where('isTrending', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .limit(20) // Basic pagination
          .get();

      // Fetch user's saved memes to determine `isSaved` status
      final savedMemes = await _getSavedMemeIds();

      final memes = snapshot.docs
          .map((doc) => MemeModel.fromFirestore(doc, userId, savedMemes))
          .toList();
      feedList.assignAll(memes);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load feed: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTrending() async {
    try {
      isLoading.value = true;
      // Fetch memes that are trending, ordered by creation date
      final snapshot = await firestore
          .collection('memes')
          .where('isTrending', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(20) // Basic pagination
          .get();

      final savedMemes = await _getSavedMemeIds();

      final memes = snapshot.docs
          .map((doc) => MemeModel.fromFirestore(doc, userId, savedMemes))
          .toList();

      trendingList.assignAll(memes);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load trending memes: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<Set<String>> _getSavedMemeIds() async {
    if (userId.isEmpty) return {};
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data()!.containsKey('savedMemes')) {
        final List<dynamic> savedIds = userDoc.data()!['savedMemes'];
        return Set<String>.from(savedIds);
      }
    } catch (e) {
      debugPrint("Could not fetch saved memes: $e");
    }
    return {};
  }

  Future<void> fetchRecommendations() async {
    try {
      isLoading.value = true;

      // Replace with your Supabase function URL
      final supabaseFunctionUrl =
          'https://cicipihemdigpsthnibk.functions.supabase.co/recommendMemes?userId=$userId';

      final response = await http.get(
        Uri.parse(supabaseFunctionUrl),
        headers: {'Authorization': 'Bearer ${AppConstant.SUPABASE_ANON_KEY}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        recommendations.assignAll(data.cast<Map<String, dynamic>>());
      } else {
        Get.snackbar(
          'Error',
          'Failed to load recommendations: ${response.statusCode}',
          backgroundColor: AppColors.RED_COLOR,
          colorText: AppColors.WHITE_COLOR,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error fetching recommendations: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final permissionStatus = await Permission.photos.request();
      if (!permissionStatus.isGranted) {
        Get.snackbar(
          'Error',
          'Gallery permission denied',
          backgroundColor: AppColors.RED_COLOR,
          colorText: AppColors.WHITE_COLOR,
        );
        return;
      }
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        pickedFile.value = File(picked.path);
      } else {
        Get.snackbar(
          'Info',
          'No image selected',
          backgroundColor: AppColors.GREY_TEXT_COLOR,
          colorText: AppColors.WHITE_COLOR,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error picking image: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    }
  }

  Future<void> generateCaptionsForImage() async {
    if (pickedFile.value == null) {
      Get.snackbar(
        'Error',
        'Please pick an image first.',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
      return;
    }

    isLoading.value = true;

    try {
      // 1. Create a multipart request to send the file directly
      // IMPORTANT: Replace with your actual deployed function URL from the prerequisite step.
      final functionUrl =
          'https://us-central1-memeverse-2bc9f.cloudfunctions.net/generateMemeCaption';
      final request = http.MultipartRequest('POST', Uri.parse(functionUrl));

      // 2. Attach the file to the request
      final file = pickedFile.value!;
      final mimeType = lookupMimeType(file.path);
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // This fieldname must match what the backend expects
          file.path,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      );

      // 3. Send the request and get the response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // 4. Handle the response from the AI function (same as before)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final captions = List<String>.from(data['captions']);

        if (captions.isEmpty) {
          Get.snackbar(
            'Info',
            'AI could not generate captions for this image.',
          );
          return;
        }

        // 5. Show a bottom sheet for the user to select a caption
        await Get.bottomSheet(
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E), // Example color
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: captions.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  captions[index],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  titleController.text = captions[index];
                  Get.back(); // Close the bottom sheet
                },
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        );
      } else {
        // Improved error handling to show more details from the server
        String errorMessage =
            "Server error with status code: ${response.statusCode}";
        try {
          // Try to parse the error as JSON, which is the expected format
          final errorData = jsonDecode(response.body);
          errorMessage = 'Failed to generate captions: ${errorData['error']}';
        } catch (_) {
          // If parsing fails, the response was not JSON. Show the raw text.
          errorMessage += "\nRaw response: ${response.body}";
          debugPrint('Error :::::::::::::::$errorMessage');
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error :::::::::::::::$e');

      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadMeme() async {
    if (pickedFile.value == null || titleController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select an image and add a title',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
      return;
    }
    try {
      isLoading.value = true;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = pickedFile.value!;
      await supabase.storage.from('memes').upload(fileName, file);
      final publicUrl = supabase.storage.from('memes').getPublicUrl(fileName);

      // Create a new document in the 'memes' collection with an auto-generated ID
      final docRef = firestore.collection('memes').doc();

      await docRef.set({
        'id': docRef.id,
        'imageUrl': publicUrl,
        'title': titleController.text,
        'uploaderId': userId,
        'uploaderName':
            FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous',
        'uploaderAvatar': FirebaseAuth.instance.currentUser?.photoURL,
        'commentCount': 0,
        'shareCount': 0,
        'saveCount': 0,
        'reactions': {},
        'isTrending': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar(
        'Success',
        'Meme uploaded successfully!',
        backgroundColor: AppColors.PRIMARY_COLOR,
        colorText: AppColors.BUTTON_TEXT_COLOR,
      );
      titleController.clear();
      pickedFile.value = null;
      await refreshFeed(); // Refresh feed after upload
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error uploading meme: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleMemeReaction(String memeId, String reactionType) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;

    final memeRef = firestore.collection('memes').doc(memeId);

    // --- Optimistic UI Update ---
    _updateLocalMeme(memeId, (meme) {
      final newReactions = Map<String, List<String>>.from(
        meme.reactions.map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      );
      final currentReaction = meme.userReaction;

      if (currentReaction != null) {
        newReactions[currentReaction]?.remove(userId);
        if (newReactions[currentReaction]?.isEmpty ?? false) {
          newReactions.remove(currentReaction);
        }
      }

      if (currentReaction != reactionType) {
        newReactions.putIfAbsent(reactionType, () => []).add(userId);
      }

      meme.reactions = newReactions;
      meme.userReaction = null;
      meme.reactions.forEach((key, value) {
        if (value.contains(userId)) meme.userReaction = key;
      });
      meme.totalReactionCount = meme.reactions.values.fold(
        0,
        (sum, list) => sum + list.length,
      );
    });

    // --- End of Optimistic UI Update ---

    // Backend update using a transaction for safety
    try {
      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(memeRef);
        if (!doc.exists) return;

        final data = doc.data() as Map<String, dynamic>;
        final reactions = (data['reactions'] as Map<String, dynamic>? ?? {})
            .map(
              (key, value) =>
                  MapEntry(key, List<String>.from(value.cast<String>())),
            );

        String? userPreviousReaction;
        reactions.forEach((key, value) {
          if (value.contains(userId)) userPreviousReaction = key;
        });

        if (userPreviousReaction != null) {
          reactions[userPreviousReaction]?.remove(userId);
          if (reactions[userPreviousReaction]?.isEmpty ?? false) {
            reactions.remove(userPreviousReaction);
          }
        }

        if (userPreviousReaction != reactionType) {
          reactions.putIfAbsent(reactionType, () => []).add(userId);
        }

        transaction.update(memeRef, {'reactions': reactions});
      });
    } catch (e) {
      debugPrint("Failed to toggle meme reaction: $e");
      Get.snackbar('Error', 'Could not update reaction.');
      // Revert optimistic update
      _updateLocalMeme(memeId, (meme) {
        // To revert, would need to store previous state, but for simplicity, refetch or skip
      });
    }
  }

  Future<void> toggleSave(String memeId) async {
    if (userId.isEmpty) return;

    final userRef = firestore.collection('users').doc(userId);
    final memeRef = firestore.collection('memes').doc(memeId);

    // Optimistic UI update
    _updateLocalMeme(memeId, (meme) {
      meme.isSaved = !(meme.isSaved ?? false);
      meme.saveCount = (meme.saveCount ?? 0) + (meme.isSaved! ? 1 : -1);
    });

    // Backend update
    try {
      final userDoc = await userRef.get();
      final isCurrentlySaved =
          userDoc.exists &&
          (userDoc.data()?['savedMemes'] as List? ?? []).contains(memeId);

      final batch = firestore.batch();

      if (isCurrentlySaved) {
        batch.update(userRef, {
          'savedMemes': FieldValue.arrayRemove([memeId]),
        });
        batch.update(memeRef, {'saveCount': FieldValue.increment(-1)});
      } else {
        batch.set(userRef, {
          'savedMemes': FieldValue.arrayUnion([memeId]),
        }, SetOptions(merge: true));
        batch.update(memeRef, {'saveCount': FieldValue.increment(1)});
      }
      await batch.commit();
    } catch (e) {
      debugPrint("Failed to toggle save: $e");
      _updateLocalMeme(memeId, (meme) {
        meme.isSaved = !(meme.isSaved ?? false);
        meme.saveCount = (meme.saveCount ?? 0) + (meme.isSaved! ? 1 : -1);
      });
      Get.snackbar('Error', 'Could not save meme.');
    }
  }

  Future<void> shareMeme(MemeModel meme) async {
    // In a real app, you'd use a package like `share_plus` here.
    // e.g., await Share.share('Check out this meme from MemeVerse! ${meme.imageUrl}');

    // Optimistic UI update
    _updateLocalMeme(meme.id ?? '', (m) {
      m.shareCount = (m.shareCount ?? 0) + 1;
    });

    // For now, we just increment the share count on the backend.
    try {
      await firestore.collection('memes').doc(meme.id).update({
        'shareCount': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint("Failed to increment share count: $e");
      // Revert on error
      _updateLocalMeme(meme.id ?? '', (m) {
        m.shareCount = (m.shareCount ?? 0) - 1;
      });
    }
  }

  Future<void> getCommentsForMeme(String memeId) async {
    try {
      isCommentsLoading.value = true;
      currentMemeComments.clear();
      final commentsSnapshot = await firestore
          .collection('memes')
          .doc(memeId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      final comments = commentsSnapshot.docs
          .map((doc) => CommentModel.fromFirestore(doc, userId))
          .toList();
      currentMemeComments.assignAll(comments);
    } catch (e) {
      debugPrint("Failed to get comments: $e");
      Get.snackbar('Error', 'Could not load comments.');
    } finally {
      isCommentsLoading.value = false;
    }
  }

  Future<void> postComment(String memeId, String text) async {
    if (text.trim().isEmpty || isPostingComment.value) return;

    try {
      isPostingComment.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'You must be logged in to comment.');
        return;
      }

      final memeRef = firestore.collection('memes').doc(memeId);
      final commentRef = memeRef.collection('comments').doc();

      final newComment = CommentModel(
        id: commentRef.id,
        memeId: memeId,
        text: text.trim(),
        userId: user.uid,
        userName: user.displayName ?? 'Anonymous Memer',
        userAvatarUrl: user.photoURL,
        createdAt: DateTime.now(),
      );

      final batch = firestore.batch();
      batch.set(commentRef, newComment.toFirestore());
      batch.update(memeRef, {'commentCount': FieldValue.increment(1)});
      await batch.commit();

      currentMemeComments.insert(0, newComment);
      _updateLocalMeme(
        memeId,
        (meme) => meme.commentCount = (meme.commentCount ?? 0) + 1,
      );
    } catch (e) {
      debugPrint("Error posting comment: $e");
      Get.snackbar('Error', 'Failed to post comment.');
    } finally {
      isPostingComment.value = false;
    }
  }

  void _updateLocalMeme(String memeId, Function(MemeModel meme) updateFn) {
    final feedIndex = feedList.indexWhere((m) => m.id == memeId);
    if (feedIndex != -1) {
      updateFn(feedList[feedIndex]);
    }

    final trendingIndex = trendingList.indexWhere((m) => m.id == memeId);
    if (trendingIndex != -1) {
      updateFn(trendingList[trendingIndex]);
    }

    // This triggers a UI update for Obx/GetX listeners on these lists.
    // Modifying an object inside an RxList doesn't automatically trigger an update,
    // so we need to call refresh() on the list itself.
    feedList.refresh();
    trendingList.refresh();
  }

  Future<void> postReply(String memeId, String commentId, String text) async {
    if (text.trim().isEmpty || isPostingComment.value) return;

    try {
      isPostingComment.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'You must be logged in to reply.');
        return;
      }

      final newReply = ReplyModel(
        id: '', // Firestore will generate
        userId: user.uid,
        userName: user.displayName ?? 'Anonymous Memer',
        userAvatarUrl: user.photoURL,
        text: text.trim(),
        createdAt: DateTime.now(),
      );

      final commentRef = firestore
          .collection('memes')
          .doc(memeId)
          .collection('comments')
          .doc(commentId);
      final replyDocRef = commentRef.collection('replies').doc();
      newReply.id = replyDocRef.id;

      // Use a batch write for atomicity
      final batch = firestore.batch();
      batch.set(replyDocRef, newReply.toMap());
      batch.update(commentRef, {'replyCount': FieldValue.increment(1)});
      await batch.commit();

      // Optimistic UI update
      final commentIndex = currentMemeComments.indexWhere(
        (c) => c.id == commentId,
      );
      if (commentIndex != -1) {
        final comment = currentMemeComments[commentIndex];
        comment.replies.insert(0, newReply);
        comment.replyCount++;
        comment.areRepliesVisible.value = true;
        currentMemeComments.refresh();
      }
    } catch (e) {
      debugPrint("Error posting reply: $e");
      Get.snackbar('Error', 'Failed to post reply.');
    } finally {
      isPostingComment.value = false;
    }
  }

  Future<void> getRepliesForComment(String memeId, CommentModel comment) async {
    if (comment.areRepliesLoading.value) return;
    try {
      comment.areRepliesLoading.value = true;
      final repliesSnapshot = await firestore
          .collection('memes')
          .doc(memeId)
          .collection('comments')
          .doc(comment.id)
          .collection('replies')
          .orderBy('createdAt', descending: false) // Show oldest first
          .get();

      final replies = repliesSnapshot.docs
          .map((doc) => ReplyModel.fromFirestore(doc))
          .toList();
      comment.replies.assignAll(replies);
    } catch (e) {
      debugPrint("Error getting replies: $e");
    } finally {
      comment.areRepliesLoading.value = false;
    }
  }

  Future<void> toggleCommentReaction(
    String memeId,
    String commentId,
    String reactionType,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;

    final commentRef = firestore
        .collection('memes')
        .doc(memeId)
        .collection('comments')
        .doc(commentId);

    // --- Optimistic UI Update ---
    final commentIndex = currentMemeComments.indexWhere(
      (c) => c.id == commentId,
    );
    if (commentIndex != -1) {
      final comment = currentMemeComments[commentIndex];
      final newReactions = Map<String, List<String>>.from(
        comment.reactions.map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      );
      final currentReaction = comment.getUserReaction(userId);

      if (currentReaction != null) {
        // Remove existing reaction
        newReactions[currentReaction]?.remove(userId);
        if (newReactions[currentReaction]?.isEmpty ?? false) {
          newReactions.remove(currentReaction);
        }
      }

      if (currentReaction != reactionType) {
        // Add new reaction
        newReactions.putIfAbsent(reactionType, () => []).add(userId);
      }

      // Update local CommentModel
      comment.reactions = newReactions;
      comment.userReaction = comment.getUserReaction(userId);
      comment.totalReactionCount = newReactions.values.fold(
        0,
        (sum, list) => sum + list.length,
      );
      currentMemeComments[commentIndex] =
          comment; // Replace the comment to ensure reactivity
      currentMemeComments.refresh();
    }
    // --- End of Optimistic UI Update ---

    // Backend update using a transaction for safety
    try {
      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(commentRef);
        if (!doc.exists) return;

        final data = doc.data() as Map<String, dynamic>;
        final reactions = (data['reactions'] as Map<String, dynamic>? ?? {})
            .map(
              (key, value) =>
                  MapEntry(key, List<String>.from(value.cast<String>())),
            );

        String? userPreviousReaction;
        reactions.forEach((key, value) {
          if (value.contains(userId)) userPreviousReaction = key;
        });

        if (userPreviousReaction != null) {
          reactions[userPreviousReaction]?.remove(userId);
          if (reactions[userPreviousReaction]?.isEmpty ?? false) {
            reactions.remove(userPreviousReaction);
          }
        }

        if (userPreviousReaction != reactionType) {
          reactions.putIfAbsent(reactionType, () => []).add(userId);
        }

        transaction.update(commentRef, {'reactions': reactions});
      });
    } catch (e) {
      debugPrint("Failed to toggle comment reaction: $e");
      Get.snackbar('Error', 'Could not update reaction.');
      // Revert optimistic update on failure
      if (commentIndex != -1) {
        await getCommentsForMeme(
          memeId,
        ); // Re-fetch comments to restore correct state
      }
    }
  }

  Future<void> editComment(
    String memeId,
    String commentId,
    String newText,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in to edit a comment.');
      return;
    }
    final userId = user.uid;

    final commentRef = firestore
        .collection('memes')
        .doc(memeId)
        .collection('comments')
        .doc(commentId);

    // --- Optimistic UI Update ---
    final commentIndex = currentMemeComments.indexWhere(
      (c) => c.id == commentId,
    );
    String? oldText;
    if (commentIndex != -1) {
      final comment = currentMemeComments[commentIndex];
      if (comment.userId != userId) {
        Get.snackbar('Error', 'You can only edit your own comments.');
        return;
      }
      oldText = comment.text; // Store old text for revert
      comment.text = newText; // Update text locally
      comment.createdAt = DateTime.now(); // Update timestamp
      currentMemeComments[commentIndex] = comment; // Replace comment
      currentMemeComments.refresh();
    }

    // Backend update
    try {
      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(commentRef);
        if (!doc.exists) {
          throw Exception('Comment does not exist.');
        }
        final data = doc.data() as Map<String, dynamic>;
        if (data['userId'] != userId) {
          throw Exception('Unauthorized: You can only edit your own comments.');
        }
        transaction.update(commentRef, {
          'text': newText,
          'createdAt': Timestamp.fromDate(DateTime.now()),
        });
      });
    } catch (e) {
      debugPrint("Failed to edit comment: $e");
      Get.snackbar('Error', 'Could not edit comment: $e');
      // Revert optimistic update on failure
      if (commentIndex != -1 && oldText != null) {
        final comment = currentMemeComments[commentIndex];
        comment.text = oldText;
        currentMemeComments[commentIndex] = comment;
        currentMemeComments.refresh();
      }
    }
  }

  Future<void> deleteComment(String memeId, String commentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in to delete a comment.');
      return;
    }
    final userId = user.uid;

    final commentRef = firestore
        .collection('memes')
        .doc(memeId)
        .collection('comments')
        .doc(commentId);
    final memeRef = firestore.collection('memes').doc(memeId);

    // --- Optimistic UI Update ---
    final commentIndex = currentMemeComments.indexWhere(
      (c) => c.id == commentId,
    );
    CommentModel? deletedComment;
    if (commentIndex != -1) {
      final comment = currentMemeComments[commentIndex];
      if (comment.userId != userId) {
        Get.snackbar('Error', 'You can only delete your own comments.');
        return;
      }
      deletedComment = comment; // Store for revert
      currentMemeComments.removeAt(commentIndex); // Remove locally
      // Update meme's comment count
      final memeIndex = feedList.indexWhere((m) => m.id == memeId);
      if (memeIndex != -1) {
        feedList[memeIndex].commentCount =
            (feedList[memeIndex].commentCount ?? 1) - 1;
        feedList.refresh();
      }
      currentMemeComments.refresh();
    }

    // Backend update
    try {
      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(commentRef);
        if (!doc.exists) {
          throw Exception('Comment does not exist.');
        }
        final data = doc.data() as Map<String, dynamic>;
        if (data['userId'] != userId) {
          throw Exception(
            'Unauthorized: You can only delete your own comments.',
          );
        }

        // Delete replies subcollection
        final repliesQuery = await commentRef.collection('replies').get();
        for (var replyDoc in repliesQuery.docs) {
          transaction.delete(replyDoc.reference);
        }

        // Delete comment
        transaction.delete(commentRef);

        // Update meme's comment count
        transaction.update(memeRef, {'commentCount': FieldValue.increment(-1)});
      });
    } catch (e) {
      debugPrint("Failed to delete comment: $e");
      Get.snackbar('Error', 'Could not delete comment: $e');
      // Revert optimistic update on failure
      if (deletedComment != null && commentIndex != -1) {
        currentMemeComments.insert(commentIndex, deletedComment);
        final memeIndex = feedList.indexWhere((m) => m.id == memeId);
        if (memeIndex != -1) {
          feedList[memeIndex].commentCount =
              (feedList[memeIndex].commentCount ?? 0) + 1;
          feedList.refresh();
        }
        currentMemeComments.refresh();
      }
    }
  }

  Future<void> editReply(
    String memeId,
    String commentId,
    String replyId,
    String newText,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in to edit a reply.');
      return;
    }
    final userId = user.uid;

    final replyRef = firestore
        .collection('memes')
        .doc(memeId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc(replyId);

    // --- Optimistic UI Update ---
    final commentIndex = currentMemeComments.indexWhere(
      (c) => c.id == commentId,
    );
    String? oldText;
    if (commentIndex != -1) {
      final comment = currentMemeComments[commentIndex];
      final replyIndex = comment.replies.indexWhere((r) => r.id == replyId);
      if (replyIndex != -1) {
        final reply = comment.replies[replyIndex];
        if (reply.userId != userId) {
          Get.snackbar('Error', 'You can only edit your own replies.');
          return;
        }
        oldText = reply.text; // Store old text for revert
        reply.text = newText; // Update text locally
        reply.createdAt = DateTime.now(); // Update timestamp
        comment.replies[replyIndex] = reply; // Replace reply
        comment.replies.refresh();
        currentMemeComments.refresh();
      }
    }

    // Backend update
    try {
      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(replyRef);
        if (!doc.exists) {
          throw Exception('Reply does not exist.');
        }
        final data = doc.data() as Map<String, dynamic>;
        if (data['userId'] != userId) {
          throw Exception('Unauthorized: You can only edit your own replies.');
        }
        transaction.update(replyRef, {
          'text': newText,
          'createdAt': Timestamp.fromDate(DateTime.now()),
        });
      });
    } catch (e) {
      debugPrint("Failed to edit reply: $e");
      Get.snackbar('Error', 'Could not edit reply: $e');
      // Revert optimistic update on failure
      if (commentIndex != -1 && oldText != null) {
        final comment = currentMemeComments[commentIndex];
        final replyIndex = comment.replies.indexWhere((r) => r.id == replyId);
        if (replyIndex != -1) {
          final reply = comment.replies[replyIndex];
          reply.text = oldText;
          comment.replies[replyIndex] = reply;
          comment.replies.refresh();
          currentMemeComments.refresh();
        }
      }
    }
  }

  Future<void> deleteReply(
    String memeId,
    String commentId,
    String replyId,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in to delete a reply.');
      return;
    }
    final userId = user.uid;

    final replyRef = firestore
        .collection('memes')
        .doc(memeId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc(replyId);
    final commentRef = firestore
        .collection('memes')
        .doc(memeId)
        .collection('comments')
        .doc(commentId);

    // --- Optimistic UI Update ---
    final commentIndex = currentMemeComments.indexWhere(
      (c) => c.id == commentId,
    );
    ReplyModel? deletedReply;
    if (commentIndex != -1) {
      final comment = currentMemeComments[commentIndex];
      final replyIndex = comment.replies.indexWhere((r) => r.id == replyId);
      if (replyIndex != -1) {
        final reply = comment.replies[replyIndex];
        if (reply.userId != userId) {
          Get.snackbar('Error', 'You can only delete your own replies.');
          return;
        }
        deletedReply = reply; // Store for revert
        comment.replies.removeAt(replyIndex); // Remove locally
        comment.replyCount = (comment.replyCount > 0)
            ? comment.replyCount - 1
            : 0;
        comment.replies.refresh();
        currentMemeComments.refresh();
      }
    }

    // Backend update
    try {
      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(replyRef);
        if (!doc.exists) {
          throw Exception('Reply does not exist.');
        }
        final data = doc.data() as Map<String, dynamic>;
        if (data['userId'] != userId) {
          throw Exception(
            'Unauthorized: You can only delete your own replies.',
          );
        }

        // Delete reply
        transaction.delete(replyRef);

        // Update comment's reply count
        transaction.update(commentRef, {
          'replyCount': FieldValue.increment(-1),
        });
      });
    } catch (e) {
      debugPrint("Failed to delete reply: $e");
      Get.snackbar('Error', 'Could not delete reply: $e');
      // Revert optimistic update on failure
      if (deletedReply != null && commentIndex != -1) {
        final comment = currentMemeComments[commentIndex];
        final replyIndex = comment.replies.indexWhere((r) => r.id == replyId);
        if (replyIndex == -1) {
          comment.replies.add(deletedReply);
          comment.replyCount = comment.replyCount + 1;
          comment.replies.refresh();
          currentMemeComments.refresh();
        }
      }
    }
  }

  Future<void> toggleReplyReaction(
    String memeId,
    String commentId,
    String replyId,
    String reactionType,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;

    final replyRef = firestore
        .collection('memes')
        .doc(memeId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc(replyId);

    // --- Optimistic UI Update ---
    final commentIndex = currentMemeComments.indexWhere(
      (c) => c.id == commentId,
    );
    if (commentIndex != -1) {
      final comment = currentMemeComments[commentIndex];
      final replyIndex = comment.replies.indexWhere((r) => r.id == replyId);

      if (replyIndex != -1) {
        final reply = comment.replies[replyIndex];
        final newReactions = Map<String, List<String>>.from(
          reply.reactions.map(
            (key, value) => MapEntry(key, List<String>.from(value)),
          ),
        );
        final currentReaction = reply.getUserReaction(userId);

        if (currentReaction != null) {
          newReactions[currentReaction]?.remove(userId);
          if (newReactions[currentReaction]?.isEmpty ?? false) {
            newReactions.remove(currentReaction);
          }
        }

        if (currentReaction != reactionType) {
          newReactions.putIfAbsent(reactionType, () => []).add(userId);
        }

        reply.reactions = newReactions;
        currentMemeComments.refresh();
      }
    }
    // --- End of Optimistic UI Update ---

    try {
      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(replyRef);
        if (!doc.exists) return;

        final data = doc.data() as Map<String, dynamic>;
        final reactions = (data['reactions'] as Map<String, dynamic>? ?? {})
            .map(
              (key, value) =>
                  MapEntry(key, List<String>.from(value.cast<String>())),
            );

        String? userPreviousReaction;
        reactions.forEach((key, value) {
          if (value.contains(userId)) userPreviousReaction = key;
        });

        if (userPreviousReaction != null) {
          reactions[userPreviousReaction]?.remove(userId);
          if (reactions[userPreviousReaction]?.isEmpty ?? false) {
            reactions.remove(userPreviousReaction);
          }
        }

        if (userPreviousReaction != reactionType) {
          reactions.putIfAbsent(reactionType, () => []).add(userId);
        }

        transaction.update(replyRef, {'reactions': reactions});
      });
    } catch (e) {
      debugPrint("Failed to toggle reply reaction: $e");
      Get.snackbar('Error', 'Could not update reaction.');
    }
  }

  GoogleSignIn googleSignIn = GoogleSignIn.instance;
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar(
        'Success',
        'Signed out successfully',
        backgroundColor: AppColors.PRIMARY_COLOR,
        colorText: AppColors.BUTTON_TEXT_COLOR,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error signing out: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    }
  }
}
