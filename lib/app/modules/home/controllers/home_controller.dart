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
import 'package:meme_verse/app/core/theme/color/app_colors.dart';
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
        'likeCount': 0,
        'commentCount': 0,
        'shareCount': 0,
        'saveCount': 0,
        'likedBy': [],
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

  Future<void> toggleLike(String memeId) async {
    if (userId.isEmpty) return;

    final memeRef = firestore.collection('memes').doc(memeId);

    // Optimistic UI update
    _updateLocalMeme(memeId, (meme) {
      meme.isLikedByUser = !(meme.isLikedByUser ?? false);
      meme.likeCount = (meme.likeCount ?? 0) + (meme.isLikedByUser! ? 1 : -1);
    });

    // Backend update
    try {
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(memeRef);
        if (!snapshot.exists) throw Exception("Meme does not exist!");

        final List<dynamic> likedBy = snapshot.data()?['likedBy'] ?? [];
        final isCurrentlyLiked = likedBy.contains(userId);

        if (isCurrentlyLiked) {
          transaction.update(memeRef, {
            'likedBy': FieldValue.arrayRemove([userId]),
            'likeCount': FieldValue.increment(-1),
          });
        } else {
          transaction.update(memeRef, {
            'likedBy': FieldValue.arrayUnion([userId]),
            'likeCount': FieldValue.increment(1),
          });
        }
      });
    } catch (e) {
      debugPrint("Failed to toggle like: $e");
      // Revert optimistic update on error
      _updateLocalMeme(memeId, (meme) {
        meme.isLikedByUser = !(meme.isLikedByUser ?? false);
        meme.likeCount = (meme.likeCount ?? 0) + (meme.isLikedByUser! ? 1 : -1);
      });
      Get.snackbar('Error', 'Could not update like status.');
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
