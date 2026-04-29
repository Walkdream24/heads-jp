import 'package:flutter/foundation.dart';
import '../entities/user_summary_entity.dart';
import '../repositories/follows_repository.dart';

class FetchRequestFollowsUseCase {
  final FollowsRepository repository;

  FetchRequestFollowsUseCase({required this.repository});

  Future<List<UserSummaryEntity>> execute(String userId) async {
    try {
      // リポジトリからリストを取得
        debugPrint("FetchRequestFollowsUseCase内");
      final users = await repository.fetchRequestFollows(userId);
      return users;
    } catch (e) {
      // エラーログ
      debugPrint("FetchRequestFollowsUseCase Error: $e");
      rethrow;
    }
  }
}
