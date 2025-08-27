import 'package:meme_verse/app/core/models/reply_model.dart';

class CommentModel {
  String? id;
  String? memeId;
  String? userId;
  String? userName;
  String? userAvatarUrl;
  String? text;
  DateTime? createdAt;
  int? likeCount;
  bool? isReactedByUser;
  List<ReplyModel>? replies;

  CommentModel({
    this.id,
    this.memeId,
    this.userId,
    this.userName,
    this.userAvatarUrl,
    this.text,
    this.createdAt,
    this.likeCount = 0,
    this.isReactedByUser = false,
    this.replies,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map, String id) {
    return CommentModel(
      id: id,
      memeId: map['memeId'],
      userId: map['userId'],
      userName: map['userName'],
      userAvatarUrl: map['userAvatarUrl'],
      text: map['text'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      likeCount: map['likeCount'] ?? 0,
      isReactedByUser: map['isReactedByUser'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'memeId': memeId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'text': text,
      'createdAt': createdAt?.toIso8601String(),
      'likeCount': likeCount,
    };
  }
}
