import 'package:flutter/foundation.dart';
import '../entities/user_summary_entity.dart';
import '../entities/follows_entity.dart';
import '../repositories/follows_repository.dart';

class FetchCommonFollowersUseCase {
  final FollowsRepository repository;

  FetchCommonFollowersUseCase({required this.repository});

  Future<List<UserSummaryEntity>> execute(FollowsInput input) async {
    try {
      // リポジトリからリストを取得
        debugPrint("FetchCommonFollowersUseCase");
      final users = await repository.fetchCommonFollowers(input);
      return users;
    } catch (e) {
      // エラーログ
      debugPrint("FetchCommonFollowersUseCase Error: $e");
      rethrow;
    }
  }
}
