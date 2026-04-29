import '../entities/user_summary_entity.dart';

abstract class UserSummaryRepository {
  Future<UserSummaryEntity> fetchUserSummary(String userId);
  Future<List<UserSummaryEntity>> fetchUsers(List<String> userIds);
  Future<List<UserSummaryEntity>> searchUsersByHeadsId(String query);
}
