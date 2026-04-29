import '../entities/profile_header_entity.dart';

class UserEntity {
  final String uid;
  final String username;
  final String headsId;
  final String email;
  final int followersCount;
  final int followingCount;
  final String? bio;
  final String? bioLink;
  final String? profilePhotoUrl;
  final String? instagramId;
  final String? xId;
  final String? youtubeId;
  final String? soundcloudId;
  final bool isPrivate;
  final LocationVisibilitySettingType locationVisibilitySetting;

  UserEntity({
    required this.uid,
    required this.username,
    required this.headsId,
    required this.email,
    required this.followersCount,
    required this.followingCount,
    this.bio,
    this.bioLink,
    this.profilePhotoUrl,
    this.instagramId,
    this.xId,
    this.youtubeId,
    this.soundcloudId,
    required this.isPrivate,
    required this.locationVisibilitySetting,
  });
}

extension UserEntityExtension on UserEntity {
  ProfileHeaderEntity toProfileHeaderEntity() {
    return ProfileHeaderEntity(
      uid: uid,
      username: username,
      headsId: headsId,
      followersCount: followersCount,
      followingCount: followingCount,
      bio: bio,
      bioLink: bioLink,
      profilePhotoUrl: profilePhotoUrl,
      instagramId: instagramId,
      xId: xId,
      youtubeId: youtubeId,
      soundcloudId: soundcloudId,
      isPrivate: isPrivate,
    );
  }
}

enum LocationVisibilitySettingType {
  EVERYONE,
  FOLLOWERS,
  CLOSE_FRIENDS,
  NONE,
}

extension LocationVisibilitySettingTypeExtension on LocationVisibilitySettingType {
  String toApiValue() {
    switch (this) {
      case LocationVisibilitySettingType.EVERYONE:
        return "everyone";
      case LocationVisibilitySettingType.FOLLOWERS:
        return "followers";
      case LocationVisibilitySettingType.CLOSE_FRIENDS:
        return "close_friends";
      case LocationVisibilitySettingType.NONE:
        return "none";
    }
  }

  static LocationVisibilitySettingType fromApiValue(String value) {
    switch (value) {
      case "everyone":
        return LocationVisibilitySettingType.EVERYONE;
      case "followers":
        return LocationVisibilitySettingType.FOLLOWERS;
      case "close_friends":
        return LocationVisibilitySettingType.CLOSE_FRIENDS;
      case "none":
      default:
        return LocationVisibilitySettingType.NONE;
    }
  }
}

class LocationSettingParams {
  final String userId;
  final LocationVisibilitySettingType locationType;

  LocationSettingParams({
    required this.userId,
    required this.locationType,
  });
}

