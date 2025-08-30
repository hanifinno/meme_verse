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
  String? userReaction; // Current user's reaction
  int totalReactionCount; // Total number of reactions
  final RxList<ReplyModel> replies;
  final RxBool areRepliesLoading;
  final RxBool areRepliesVisible;

  CommentModel({
    required this.id,
    required this.memeId,
    required this.text,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.createdAt,
    Map<String, List<String>>? reactions,
    this.replyCount = 0,
    this.userReaction,
    this.totalReactionCount = 0,
    List<ReplyModel>? replies,
    bool areRepliesLoading = false,
    bool areRepliesVisible = false,
  }) : reactions = reactions ?? {},
       replies = RxList<ReplyModel>(replies ?? []),
       areRepliesLoading = RxBool(areRepliesLoading),
       areRepliesVisible = RxBool(areRepliesVisible);

  factory CommentModel.fromMap(
    Map<String, dynamic> data,
    String id,
    String currentUserId,
  ) {
    final reactionsData = data['reactions'] as Map<String, dynamic>? ?? {};
    final reactions = reactionsData.map(
      (key, value) => MapEntry(key, List<String>.from(value as List? ?? [])),
    );
    final totalReactionCount = reactions.values.fold(
      0,
      (sum, list) => sum + list.length,
    );
    String? userReaction;
    reactions.forEach((key, value) {
      if (value.contains(currentUserId)) userReaction = key;
    });

    return CommentModel(
      id: id,
      memeId: data['memeId'] as String? ?? '',
      text: data['text'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? 'Unknown',
      userAvatarUrl: data['userAvatarUrl'] as String?,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.parse(
              data['createdAt'] as String? ?? DateTime.now().toIso8601String(),
            ),
      reactions: reactions,
      replyCount: data['replyCount'] as int? ?? 0,
      userReaction: userReaction,
      totalReactionCount: totalReactionCount,
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
      'reactions': reactions,
      'replyCount': replyCount,
    };
  }

  String? getUserReaction(String userId) {
    for (var entry in reactions.entries) {
      if (entry.value.contains(userId)) return entry.key;
    }
    return null;
  }
}
