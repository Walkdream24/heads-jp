import 'package:flutter/foundation.dart';
import '../entities/user_summary_entity.dart';
import '../repositories/follows_repository.dart';

class FetchFollowingListUseCase {
  final FollowsRepository repository;

  FetchFollowingListUseCase({required this.repository});

  Future<List<UserSummaryEntity>> execute(String userId) async {
    try {
      // リポジトリからリストを取得
        debugPrint("FetchFollowingListUseCase");
      final users = await repository.fetchFollowingList(userId);
      return users;
    } catch (e) {
      // エラーログ
      debugPrint("FetchFollowingListUseCase Error: $e");
      rethrow;
    }
  }
}
