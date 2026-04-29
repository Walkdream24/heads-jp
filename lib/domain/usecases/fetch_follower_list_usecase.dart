import 'package:flutter/foundation.dart';
import '../entities/user_summary_entity.dart';
import '../repositories/follows_repository.dart';

class FetchFollowerListUseCase {
  final FollowsRepository repository;

  FetchFollowerListUseCase({required this.repository});

  Future<List<UserSummaryEntity>> execute(String userId) async {
    try {
      // リポジトリからリストを取得
        debugPrint("FetchFollowerListUseCase");
      final users = await repository.fetchFollowerList(userId);
      return users;
    } catch (e) {
      // エラーログ
      debugPrint("FetchFollowerListUseCase Error: $e");
      rethrow;
    }
  }
}
