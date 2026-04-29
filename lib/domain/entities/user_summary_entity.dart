
class UserSummaryEntity {
  final String uid;
  final String username;
  final String profilePhotoUrl;
  final String? headsId;

  UserSummaryEntity({
    required this.uid,
    required this.username,
    required this.profilePhotoUrl,
    this.headsId,
  });

}
