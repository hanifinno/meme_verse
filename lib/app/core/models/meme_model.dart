class MemeModel {
  String? id;
  String? title;
  String? imageUrl;
  String? uploadedBy;
  DateTime? createdAt;
  int? likeCount;
  int? commentCount;
  List<String>? hashtags;

  MemeModel({
    this.id,
    this.title,
    this.imageUrl,
    this.uploadedBy,
    this.createdAt,
    this.likeCount = 0,
    this.commentCount = 0,
    this.hashtags,
  });

  factory MemeModel.fromMap(Map<String, dynamic> map, String id) {
    return MemeModel(
      id: id,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      // createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      likeCount: map['likeCount'] ?? 0,
      commentCount: map['commentCount'] ?? 0,
      hashtags: List<String>.from(map['hashtags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'uploadedBy': uploadedBy,
      // 'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'hashtags': hashtags ?? [],
    };
  }
}
