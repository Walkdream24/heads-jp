class ClubEntity {
  final String clubId;
  final String clubName;
  final String description;
  final String clubPhotoUrl;
  final String address;
  final double latitude;
  final double longitude;

  ClubEntity({
    required this.clubId,
    required this.clubName,
    required this.description,
    required this.clubPhotoUrl,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class ClubInfoEntity {
  final String clubId;
  final String clubName;
  final String address;

  ClubInfoEntity({
    required this.clubId,
    required this.clubName,
    required this.address,
  });
}