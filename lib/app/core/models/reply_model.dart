import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyModel {
  String id;
  String userId;
  String userName;
  String? userAvatarUrl;
  String text;
  DateTime createdAt;
  Map<String, List<String>> reactions;

  ReplyModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.text,
    required this.createdAt,
    this.reactions = const {},
  });

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

  factory ReplyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final reactionsData = data['reactions'] as Map<String, dynamic>? ?? {};
    final Map<String, List<String>> reactions = {};
    reactionsData.forEach((key, value) {
      if (value is List) {
        reactions[key] = List<String>.from(value.map((e) => e.toString()));
      }
    });
    return ReplyModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      userAvatarUrl: data['userAvatarUrl'],
      text: data['text'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      reactions: reactions,
    );
  }
  factory ReplyModel.fromMap(Map<String, dynamic> map) {
    final reactionsData = map['reactions'] as Map<String, dynamic>? ?? {};
    final Map<String, List<String>> reactions = {};
    reactionsData.forEach((key, value) {
      if (value is List) {
        reactions[key] = List<String>.from(value.map((e) => e.toString()));
      }
    });
    return ReplyModel(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'],
      userAvatarUrl: map['userAvatarUrl'],
      text: map['text'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      reactions: reactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'reactions': reactions,
    };
  }
}
