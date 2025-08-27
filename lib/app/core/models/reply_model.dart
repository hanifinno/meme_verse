class ReplyModel {
  String? id;
  String? commentId;
  String? userId;
  String? userName;
  String? userAvatarUrl;
  String? text;
  DateTime? createdAt;
  int? likeCount;
  bool? isReactedByUser;

  ReplyModel({
    this.id,
    this.commentId,
    this.userId,
    this.userName,
    this.userAvatarUrl,
    this.text,
    this.createdAt,
    this.likeCount = 0,
    this.isReactedByUser = false,
  });

  factory ReplyModel.fromMap(Map<String, dynamic> map, String id) {
    return ReplyModel(
      id: id,
      commentId: map['commentId'],
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
      'commentId': commentId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'text': text,
      'createdAt': createdAt?.toIso8601String(),
      'likeCount': likeCount,
    };
  }
}
