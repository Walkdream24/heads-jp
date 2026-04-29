import '../entities/follows_entity.dart';
import '../entities/user_summary_entity.dart';


abstract class FollowsRepository {
  Future<FollowCheckResult> checkFollowStatus(
    FollowsInput input
  );
  Future<void> followRequest(
    FollowsInput input
  );
  Future<void> followReturn(
    FollowsInput input
  );
  Future<void> unFollowUser(
    FollowsInput input
  );
  Future<List<UserSummaryEntity>> fetchRequestFollows(
    String userId
  );
  Future<List<UserSummaryEntity>> fetchCommonFollowers(
    FollowsInput input
  );
  Future<List<UserSummaryEntity>> fetchFollowerList(
    String userId
  );
  Future<List<UserSummaryEntity>> fetchFollowingList(
    String userId
  );
}
