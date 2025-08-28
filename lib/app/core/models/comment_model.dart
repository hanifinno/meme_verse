import 'package:cloud_firestore/cloud_firestore.dart';
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

  // Factory constructor to create a CommentModel from a Firestore document
  factory CommentModel.fromFirestore(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final List<dynamic> likedBy = data['likedBy'] ?? [];
    return CommentModel(
      id: doc.id,
      memeId: data['memeId'],
      userId: data['userId'],
      userName: data['userName'] ?? 'Anonymous',
      userAvatarUrl: data['userAvatarUrl'],
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likeCount: data['likeCount'] ?? 0,
      isReactedByUser: likedBy.contains(currentUserId),
    );
  }

  // Method to convert a CommentModel instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'memeId': memeId,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
      'likeCount': likeCount ?? 0,
      'likedBy': [],
    };
  }
}
