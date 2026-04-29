class MemoryModel {
  final String memoryId;
  final String userId;
  final String? eventId;
  final String photoUrl;
  final String? caption;
  final bool isArchived;
  // final Timestamp createdAt;
  // final Timestamp updatedAt;


  MemoryModel({
    required this.memoryId,
    required this.userId,
    this.eventId,
    required this.photoUrl,
    this.caption,
    required this.isArchived,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      memoryId: json['memoryId'] as String,
      userId: json['userId'] as String,
      eventId: json['eventId'] != null ? json['eventId'] as String : null,
      photoUrl: json['photoUrl'] as String,
      caption: json['caption'] != null ? json['caption'] as String : null,
      isArchived: json['isArchived'] as bool,
    );
  }
}
