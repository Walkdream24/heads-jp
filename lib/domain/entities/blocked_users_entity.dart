class BlockedUsersEntity {
  final String blockId;
  final String blockerId;
  final String blockedId;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  BlockedUsersEntity({
    required this.blockId,
    required this.blockerId,
    required this.blockedId,
    // required this.createdAt,
    // required this.updatedAt,
  });
}

class BlockedUsersParams {
  final String blockerId;
  final String blockedId;

  BlockedUsersParams({
    required this.blockerId,
    required this.blockedId,
  });
}

class BlockedUsersInput {
  final String userId;
  final String targetUserId;

  BlockedUsersInput({
    required this.userId,
    required this.targetUserId,
  });
}

enum BlockRelationshipType {
  TARGET_BLOCKED_USER,
  USER_BLOCKED_TARGET,
  NONE
}

extension BlockRelationshipTypeExtension on BlockRelationshipType {
  String toApiValue() {
    switch (this) {
      case BlockRelationshipType.TARGET_BLOCKED_USER:
        return "targetBlockedUser";
      case BlockRelationshipType.USER_BLOCKED_TARGET:
        return "userBlockedTarget";
      case BlockRelationshipType.NONE:
        return "none";
    }
  }

  static BlockRelationshipType fromApiValue(String value) {
    switch (value) {
      case "targetBlockedUser":
        return BlockRelationshipType.TARGET_BLOCKED_USER;
      case "userBlockedTarget":
        return BlockRelationshipType.USER_BLOCKED_TARGET;
      case "none":
      default:
        return BlockRelationshipType.NONE;
    }
  }
}
