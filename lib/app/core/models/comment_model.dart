import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:meme_verse/app/core/models/reply_model.dart';

class CommentModel {
  String id;
  String memeId;
  String text;
  String userId;
  String userName;
  String? userAvatarUrl;
  DateTime createdAt;
  Map<String, List<String>> reactions;
  int replyCount;

  // --- UI State (not stored in Firestore) ---
  // This property will hold the current user's reaction to the comment.
  // It is populated at read-time and not saved back to Firestore.
  String? userReaction;
  final RxList<ReplyModel> replies = <ReplyModel>[].obs;
  final RxBool areRepliesLoading = false.obs;
  final RxBool areRepliesVisible = false.obs;

  CommentModel({
    required this.id,
    required this.memeId,
    required this.text,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.createdAt,
    this.reactions = const {},
    this.replyCount = 0,
    this.userReaction,
  });

  factory CommentModel.fromMap(
    Map<String, dynamic> data,
    String id,
    String currentUserId,
  ) {
    final reactionsData = data['reactions'] as Map<String, dynamic>? ?? {};
    final reactions = reactionsData.map(
      (key, value) => MapEntry(key, List<String>.from(value as List)),
    );

    // Determine the current user's reaction based on the provided userId.
    String? userReaction;
    for (var entry in reactions.entries) {
      if (entry.value.contains(currentUserId)) {
        userReaction = entry.key;
        break;
      }
    }

    return CommentModel(
      id: id,
      memeId: data['memeId'] ?? '',
      text: data['text'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      userAvatarUrl: data['userAvatarUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      reactions: reactions,
      replyCount: data['replyCount'] ?? 0,
      userReaction: userReaction,
    );
  }

  factory CommentModel.fromFirestore(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel.fromMap(data, doc.id, currentUserId);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'memeId': memeId,
      'text': text,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'replyCount': replyCount,
      'reactions': reactions,
    };
  }

  int get totalReactionCount {
    if (reactions.isEmpty) return 0;
    return reactions.values.fold(0, (sum, list) => sum + list.length);
  }

  String? getUserReaction(String userId) {
    for (var entry in reactions.entries) {
      if (entry.value.contains(userId)) {
        return entry.key;
      }
    }
    return null;
  }
}
