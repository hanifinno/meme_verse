import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyModel {
  String id;
  String userId;
  String userName;
  String? userAvatarUrl;
  String text;
  DateTime createdAt;

  ReplyModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.text,
    required this.createdAt,
  });

  factory ReplyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReplyModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      userAvatarUrl: data['userAvatarUrl'],
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  factory ReplyModel.fromMap(Map<String, dynamic> map) {
    return ReplyModel(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      userAvatarUrl: map['userAvatarUrl'],
      text: map['text'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
