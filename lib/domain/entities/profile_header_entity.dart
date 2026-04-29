class ProfileHeaderEntity {
  final String uid;
  final String username;
  final String headsId;
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

  ProfileHeaderEntity({
    required this.uid,
    required this.username,
    required this.headsId,
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
  });

  ProfileHeaderEntity copyWith({
    String? uid,
    String? username,
    String? headsId,
    int? followersCount,
    int? followingCount,
    String? bio,
    String? bioLink,
    String? profilePhotoUrl,
    String? instagramId,
    String? xId,
    String? youtubeId,
    String? soundcloudId,
    bool? isPrivate,
  }) {
    return ProfileHeaderEntity(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      headsId: headsId ?? this.headsId,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      bio: bio ?? this.bio,
      bioLink: bioLink ?? this.bioLink,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      instagramId: instagramId ?? this.instagramId,
      xId: xId ?? this.xId,
      youtubeId: youtubeId ?? this.youtubeId,
      soundcloudId: soundcloudId ?? this.soundcloudId,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}