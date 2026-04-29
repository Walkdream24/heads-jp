import 'package:flutter/foundation.dart';
import '../entities/user_summary_entity.dart';
import '../repositories/user_summary_repository.dart';

class FetchUserSummaryUseCase {
  final UserSummaryRepository repository;

  FetchUserSummaryUseCase({required this.repository});

  Future<UserSummaryEntity> execute(String userId) async {
    try {
      // リポジトリからイベントリストを取得
      final userSummary = await repository.fetchUserSummary(userId);
      return userSummary;
    } catch (e) {
      // エラーログ
      debugPrint("FetchUserSummaryUseCase Error: $e");
      rethrow;
    }
  }
}
