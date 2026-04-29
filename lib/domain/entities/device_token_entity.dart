
class DeviceTokenEntity {
  final String deviceTokenId;
  final String userId;
  final String token;
  final bool isActive;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  DeviceTokenEntity({
    required this.deviceTokenId,
    required this.userId,
    required this.token,
    required this.isActive,
    // required this.createdAt,
    // required this.updatedAt,
  });
}

class DeviceTokenInput {
  final String userId;
  final String token;

  DeviceTokenInput({
    required this.userId,
    required this.token,
  });
}
