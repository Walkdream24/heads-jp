import 'package:flutter/foundation.dart';
import '../entities/follows_entity.dart';
import '../repositories/follows_repository.dart';

class FollowRequestUseCase {
  final FollowsRepository repository;

  FollowRequestUseCase({required this.repository});

  Future<void> execute(
    FollowsInput input
  ) async {
    try {
      await repository.followRequest(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("FollowRequestUseCase Error: $e");
      rethrow;
    }
  }
  
}
