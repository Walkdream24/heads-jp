import 'package:flutter/foundation.dart';
import '../entities/user_summary_entity.dart';
import '../repositories/user_summary_repository.dart';

class FetchUsersSummaryUseCase {
  final UserSummaryRepository repository;

  FetchUsersSummaryUseCase({required this.repository});

  Future<List<UserSummaryEntity>> execute(List<String> userIds) async {
    try {
      // リポジトリからリストを取得
        debugPrint("FetchUsersSummaryUseCase内");
      final users = await repository.fetchUsers(userIds);
      return users;
    } catch (e) {
      // エラーログ
      debugPrint("FetchUsersSummaryUseCase Error: $e");
      rethrow;
    }
  }
}
