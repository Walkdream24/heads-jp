// follows_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'follows_entity.freezed.dart';

@freezed
class FollowsEntity with _$FollowsEntity {
  const factory FollowsEntity({
    required String followId,
    required String followerId,
    required String followedId,
    required FollowStatus status,
  }) = _FollowsEntity;
}

@freezed
class FollowCheckResult with _$FollowCheckResult {
  const factory FollowCheckResult({
    required bool isFollowing,
    required bool isFollowedBy,
    required FollowStatus status,
  }) = _FollowCheckResult;
}

@freezed
class FollowsInput with _$FollowsInput {
  const factory FollowsInput({
    required String userId,
    required String targetUserId,
  }) = _FollowsInput;
}

enum FollowStatus {
  ACCEPTED,
  REQUESTED,
  BLOCKED,
  NONE
}

extension FollowStatusExtension on FollowStatus {
  String toApiValue() {
    switch (this) {
      case FollowStatus.ACCEPTED:
        return "accepted";
      case FollowStatus.REQUESTED:
        return "requested";
      case FollowStatus.BLOCKED:
        return "blocked";
      case FollowStatus.NONE:
        return "none";
    }
  }

  static FollowStatus fromApiValue(String value) {
    switch (value) {
      case "accepted":
        return FollowStatus.ACCEPTED;
      case "requested":
        return FollowStatus.REQUESTED;
      case "blocked":
        return FollowStatus.BLOCKED;
      case "none":
      default:
        return FollowStatus.NONE;
    }
  }
}