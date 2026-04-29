
class UserSummaryModel {
  final String uid;
  final String username;
  final String profilePhotoUrl;
  final String? headsId;

  UserSummaryModel({
    required this.uid,
    required this.username,
    required this.profilePhotoUrl,
    this.headsId,
  });

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserSummaryModel(
      uid: json['uid'] as String,
      username: json['username'] as String,
      profilePhotoUrl: json['profilePhotoUrl'] as String,
      headsId: (json['headsId'] as String?) ?? '',
    );
  }
}
