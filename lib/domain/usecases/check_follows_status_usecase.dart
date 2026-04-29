import 'package:flutter/foundation.dart';
import '../entities/follows_entity.dart';
import '../repositories/follows_repository.dart';

class CheckFollowsStatusUseCase {
  final FollowsRepository repository;

  CheckFollowsStatusUseCase({required this.repository});

  Future<FollowCheckResult> execute(FollowsInput input) async {
    try {
      // リポジトリからリストを取得
      final status = await repository.checkFollowStatus(input);
      return status;
    } catch (e) {
      // エラーログ
      debugPrint("CheckFollowsStatusUseCase Error: $e");
      rethrow;
    }
  }
}
