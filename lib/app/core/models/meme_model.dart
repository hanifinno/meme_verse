import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme_verse/app/core/models/comment_model.dart';
import 'package:meme_verse/app/core/models/user_model.dart';

class MemeModel {
  String? id;
  String? title;
  String? imageUrl;
  String? uploadedBy; // userId
  DateTime? createdAt;
  int? likeCount;
  int? commentCount;
  int? shareCount;
  int? saveCount;
  int? views;
  List<String>? hashtags;
  bool? isReactedByUser;
  bool? isTrending;
  bool? isLikedByUser;
  bool? isSaved;
  bool? isRecommendedForYou;
  List<CommentModel>? comments;

  // User info (will be populated separately)
  String? username;
  String? userAvatar;
  int? userFollowerCount;

  MemeModel({
    this.id,
    this.title,
    this.imageUrl,
    this.uploadedBy,
    this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.saveCount = 0,
    this.views = 0,
    this.hashtags,
    this.isReactedByUser = false,
    this.isTrending = false,
    this.isLikedByUser = false,
    this.isSaved = false,
    this.isRecommendedForYou = false,
    this.comments,
    this.username,
    this.userAvatar,
    this.userFollowerCount,
  });

  factory MemeModel.fromMap(Map<String, dynamic> map, String id) {
    return MemeModel(
      id: id,
      title: map['title'],
      imageUrl: map['imageUrl'],
      uploadedBy: map['uploadedBy'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      shareCount: map['shareCount'] ?? 0,
      saveCount: map['saveCount'] ?? 0,
      views: map['views'] ?? 0,
      hashtags: List<String>.from(map['hashtags'] ?? []),
      isTrending: map['isTrending'] ?? false,
      isRecommendedForYou: map['isRecommendedForYou'] ?? false,
      isReactedByUser: map['isReactedByUser'] ?? false,
      isLikedByUser: map['isLikedByUser'] ?? false,
      isSaved: map['isSaved'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'uploadedBy': uploadedBy,
      'createdAt': createdAt?.toIso8601String(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'saveCount': saveCount,
      'views': views,
      'hashtags': hashtags ?? [],
      'isTrending': isTrending,
      'isRecommendedForYou': isRecommendedForYou,
      'isReactedByUser': isReactedByUser,
      'isLikedByUser': isLikedByUser,
      'isSaved': isSaved,
    };
  }

  // Helper method to populate user data
  MemeModel withUserData(UserModel user) {
    return MemeModel(
      id: id,
      title: title,
      imageUrl: imageUrl,
      uploadedBy: uploadedBy,
      createdAt: createdAt,
      likeCount: likeCount,
      commentCount: commentCount,
      shareCount: shareCount,
      saveCount: saveCount,
      views: views,
      hashtags: hashtags,
      isReactedByUser: isReactedByUser,
      isTrending: isTrending,
      isLikedByUser: isLikedByUser,
      isSaved: isSaved,
      isRecommendedForYou: isRecommendedForYou,
      comments: comments,
      username: user.name,
      userAvatar: user.photoUrl,
      userFollowerCount: user.followerCount,
    );
  }

  factory MemeModel.fromFirestore(
    DocumentSnapshot doc,
    String currentUserId,
    Set<String> savedMemeIds,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    final List<dynamic> likedBy = data['likedBy'] ?? [];

    return MemeModel(
      id: doc.id,
      imageUrl: data['imageUrl'],
      title: data['title'],
      uploadedBy: data['uploaderId'],
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      shareCount: data['shareCount'] ?? 0,
      saveCount: data['saveCount'] ?? 0,
      username: data['uploaderName'],
      userAvatar: data['uploaderAvatar'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      isLikedByUser: likedBy.contains(currentUserId),
      isSaved: savedMemeIds.contains(doc.id),
      isTrending: data['isTrending'] ?? false,
    );
  }
}
