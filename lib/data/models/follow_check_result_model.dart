import '../../domain/entities/follows_entity.dart';

class FollowCheckResultModel {
  final bool isFollowing;
  final bool isFollowedBy;
  final FollowStatus status;

  FollowCheckResultModel({
    required this.isFollowing,
    required this.isFollowedBy,
    required this.status,
  });

  factory FollowCheckResultModel.fromJson(Map<String, dynamic> json) {
    return FollowCheckResultModel(
      isFollowing: json['isFollowing'] as bool,
      isFollowedBy: json['isFollowedBy'] as bool,
      status: FollowStatusExtension.fromApiValue(json['status'] as String),
    );
  }
}
