
class UserLocationsModel {
  final String locationId;
  final String userId;
  final String eventId;
  final double latitude;
  final double longitude;
  final bool isBackground;
  final bool isActive;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  UserLocationsModel({
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

  factory UserLocationsModel.fromJson(Map<String, dynamic> json) {
    return UserLocationsModel(
      locationId: json['locationId'] as String,
      userId: json['userId'] as String,
      eventId: json['eventId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isBackground: json['isBackground'] as bool,
      isActive: json['isActive'] as bool,
    );
  }
}
