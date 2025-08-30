import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme_verse/app/core/models/comment_model.dart';
import 'package:meme_verse/app/core/models/user_model.dart';

class MemeModel {
  String? id;
  String? title;
  String? imageUrl;
  String? uploaderId; // Renamed from uploadedBy for clarity
  String? uploaderName; // Stored in Firestore for efficiency
  String? uploaderAvatar; // Stored in Firestore for efficiency
  DateTime? createdAt;
  int? commentCount;
  int? shareCount;
  int? saveCount;
  int? views;
  List<String>? hashtags;
  bool? isTrending;
  bool? isSaved;
  bool? isRecommendedForYou;
  Map<String, List<String>> reactions; // Reaction type -> List of user IDs
  String? userReaction; // Current user's reaction
  int totalReactionCount; // Total number of reactions
  List<CommentModel>?
  comments; // Optional, for cases where comments are pre-fetched
  int? userFollowerCount; // Optional, populated via withUserData

  MemeModel({
    this.id,
    this.title,
    this.imageUrl,
    this.uploaderId,
    this.uploaderName,
    this.uploaderAvatar,
    this.createdAt,
    this.commentCount = 0,
    this.shareCount = 0,
    this.saveCount = 0,
    this.views = 0,
    this.hashtags,
    this.isTrending = false,
    this.isSaved = false,
    this.isRecommendedForYou = false,
    this.reactions = const {},
    this.userReaction,
    this.totalReactionCount = 0,
    this.comments,
    this.userFollowerCount,
  });

  factory MemeModel.fromMap(
    Map<String, dynamic> map,
    String id,
    String currentUserId,
  ) {
    final reactionsData = map['reactions'] as Map<String, dynamic>? ?? {};
    final reactions = reactionsData.map(
      (key, value) => MapEntry(key, List<String>.from(value as List)),
    );
    final totalReactionCount = reactions.values.fold(
      0,
      (sum, list) => sum + list.length,
    );
    String? userReaction;
    reactions.forEach((key, value) {
      if (value.contains(currentUserId)) userReaction = key;
    });

    return MemeModel(
      id: id,
      title: map['title'] as String?,
      imageUrl: map['imageUrl'] as String?,
      uploaderId: map['uploaderId'] as String?,
      uploaderName: map['uploaderName'] as String? ?? 'Anonymous Memer',
      uploaderAvatar: map['uploaderAvatar'] as String?,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is Timestamp
                ? (map['createdAt'] as Timestamp).toDate()
                : DateTime.tryParse(map['createdAt'].toString()))
          : null,
      commentCount: map['commentCount'] as int? ?? 0,
      shareCount: map['shareCount'] as int? ?? 0,
      saveCount: map['saveCount'] as int? ?? 0,
      views: map['views'] as int? ?? 0,
      hashtags: List<String>.from(map['hashtags'] ?? []),
      isTrending: map['isTrending'] as bool? ?? false,
      isSaved: map['isSaved'] as bool? ?? false,
      isRecommendedForYou: map['isRecommendedForYou'] as bool? ?? false,
      reactions: reactions,
      userReaction: userReaction,
      totalReactionCount: totalReactionCount,
      userFollowerCount: map['userFollowerCount'] as int?,
    );
  }

  factory MemeModel.fromFirestore(
    DocumentSnapshot doc,
    String currentUserId,
    Set<String> savedMemeIds,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    final reactionsData = data['reactions'] as Map<String, dynamic>? ?? {};
    final reactions = reactionsData.map(
      (key, value) => MapEntry(key, List<String>.from(value as List)),
    );
    final totalReactionCount = reactions.values.fold(
      0,
      (sum, list) => sum + list.length,
    );
    String? userReaction;
    reactions.forEach((key, value) {
      if (value.contains(currentUserId)) userReaction = key;
    });

    return MemeModel(
      id: doc.id,
      title: data['title'] as String?,
      imageUrl: data['imageUrl'] as String?,
      uploaderId: data['uploaderId'] as String?,
      uploaderName: data['uploaderName'] as String? ?? 'Anonymous Memer',
      uploaderAvatar: data['uploaderAvatar'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      commentCount: data['commentCount'] as int? ?? 0,
      shareCount: data['shareCount'] as int? ?? 0,
      saveCount: data['saveCount'] as int? ?? 0,
      views: data['views'] as int? ?? 0,
      hashtags: List<String>.from(data['hashtags'] ?? []),
      isTrending: data['isTrending'] as bool? ?? false,
      isSaved: savedMemeIds.contains(doc.id),
      isRecommendedForYou: data['isRecommendedForYou'] as bool? ?? false,
      reactions: reactions,
      userReaction: userReaction,
      totalReactionCount: totalReactionCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'uploaderId': uploaderId,
      'uploaderName': uploaderName,
      'uploaderAvatar': uploaderAvatar,
      'createdAt': createdAt?.toIso8601String(),
      'commentCount': commentCount,
      'shareCount': shareCount,
      'saveCount': saveCount,
      'views': views,
      'hashtags': hashtags ?? [],
      'isTrending': isTrending,
      'isRecommendedForYou': isRecommendedForYou,
      'reactions': reactions,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'uploaderId': uploaderId,
      'uploaderName': uploaderName,
      'uploaderAvatar': uploaderAvatar,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'commentCount': commentCount,
      'shareCount': shareCount,
      'saveCount': saveCount,
      'views': views,
      'hashtags': hashtags ?? [],
      'isTrending': isTrending,
      'isRecommendedForYou': isRecommendedForYou,
      'reactions': reactions,
    };
  }

  MemeModel withUserData(UserModel user) {
    return MemeModel(
      id: id,
      title: title,
      imageUrl: imageUrl,
      uploaderId: uploaderId,
      uploaderName: user.name,
      uploaderAvatar: user.photoUrl,
      createdAt: createdAt,
      commentCount: commentCount,
      shareCount: shareCount,
      saveCount: saveCount,
      views: views,
      hashtags: hashtags,
      isTrending: isTrending,
      isSaved: isSaved,
      isRecommendedForYou: isRecommendedForYou,
      reactions: reactions,
      userReaction: userReaction,
      totalReactionCount: totalReactionCount,
      comments: comments,
      userFollowerCount: user.followerCount,
    );
  }
}
