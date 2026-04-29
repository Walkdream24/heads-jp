import '../../domain/entities/user_entity.dart';
class UserModel {
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

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: (json['uid'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
      headsId: (json['headsId'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      followersCount: json['followersCount'] as int,
      followingCount: json['followingCount'] as int,
      bio: (json['bio'] as String?) ?? '',
      bioLink: (json['bioLink'] as String?) ?? '',
      profilePhotoUrl: (json['profilePhotoUrl'] as String?) ?? '',
      instagramId: (json['instagramId'] as String?) ?? '',
      xId: (json['xId'] as String?) ?? '',
      youtubeId: (json['youtubeId'] as String?) ?? '',
      soundcloudId: (json['soundcloudId'] as String?) ?? '',
      isPrivate: (json['isPrivate'] as bool?) ?? false,
      locationVisibilitySetting: LocationVisibilitySettingTypeExtension.fromApiValue(json['locationVisibilitySetting'] as String)
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, headsId: $headsId, email: $email, bio: $bio, bioLink: $bioLink, profilePhotoUrl: $profilePhotoUrl, instagramId: $instagramId, xId: $xId, youtubeId: $youtubeId, soundcloudId: $soundcloudId, isPrivate: $isPrivate, locationVisibilitySetting: $locationVisibilitySetting)';
  }
}
