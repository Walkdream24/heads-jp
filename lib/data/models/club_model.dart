import '../../domain/entities/club_entity.dart';

class ClubModel extends ClubEntity {
  ClubModel({
    required String clubId,
    required String clubName,
    required String description,
    required String clubPhotoUrl,
    required String address,
    required double latitude,
    required double longitude,
  }) : super(
          clubId: clubId,
          clubName: clubName,
          description: description,
          clubPhotoUrl: clubPhotoUrl,
          address: address,
          latitude: latitude,
          longitude: longitude,
        );

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      clubId: json['clubId'] as String,
      clubName: json['clubName'] as String,
      description: json['description'] as String,
      clubPhotoUrl: json['clubPhotoUrl'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class ClubInfoModel {
  final String clubId;
  final String clubName;
  final String address;

  ClubInfoModel({
    required this.clubId,
    required this.clubName,
    required this.address,
  });

  factory ClubInfoModel.fromJson(Map<String, dynamic> json) {
    return ClubInfoModel(
      clubId: json['clubId'] as String,
      clubName: json['clubName'] as String,
      address: json['address'] as String,
    );
  }
}

