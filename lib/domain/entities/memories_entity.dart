// import 'package:cloud_firestore/cloud_firestore.dart';

class MemoryEntity {
  final String memoryId;
  final String userId;
  final String? eventId;
  final String photoUrl;
  final String? caption;
  final bool isArchived;
  // final Timestamp createdAt;
  // final Timestamp updatedAt;

  MemoryEntity({
    required this.memoryId,
    required this.userId,
    this.eventId,
    required this.photoUrl,
    this.caption,
    required this.isArchived,
    // required this.createdAt,
    // required this.updatedAt,
  });
}

class MemoryPostState {
  final String? imagePath;
  final String caption;
  final bool isValid;

  MemoryPostState({
    this.imagePath,
    this.caption = '',
    this.isValid = false,
  });

  MemoryPostState copyWith({
    String? imagePath,
    String? caption,
    bool? isValid,
  }) {
    return MemoryPostState(
      imagePath: imagePath ?? this.imagePath,
      caption: caption ?? this.caption,
      isValid: isValid ?? this.isValid,
    );
  }
}