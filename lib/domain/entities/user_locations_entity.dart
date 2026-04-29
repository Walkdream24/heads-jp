class UserLocationsEntity {
  final String locationId;
  final String userId;
  final String eventId;
  final double latitude;
  final double longitude;
  final bool isBackground;
  final bool isActive;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  UserLocationsEntity({
    required this.locationId,
    required this.userId,
    required this.eventId,
    required this.latitude,
    required this.longitude,
    required this.isBackground,
    required this.isActive,
    // required this.createdAt,
    // required this.updatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserLocationsEntity &&
        other.locationId == locationId &&
        other.userId == userId &&
        other.eventId == eventId &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.isBackground == isBackground &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(
      locationId,
      userId,
      eventId,
      latitude,
      longitude,
      isBackground,
      isActive,
    );
  }

  @override
  String toString() {
    return 'UserLocationsEntity(locationId: $locationId, userId: $userId, eventId: $eventId, latitude: $latitude, longitude: $longitude, isBackground: $isBackground, isActive: $isActive)';
  }
}

class AddUserLocationInput {
  final String userId;
  final double latitude;
  final double longitude;

  AddUserLocationInput({
    required this.userId,
    required this.latitude,
    required this.longitude,
  });

  // 重要: Riverpodが同じパラメータを識別できるようにequalsとhashCodeを実装
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddUserLocationInput &&
        other.userId == userId &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return Object.hash(userId, latitude, longitude);
  }

  @override
  String toString() {
    return 'AddUserLocationInput(userId: $userId, latitude: $latitude, longitude: $longitude)';
  }
}