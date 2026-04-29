import 'package:flutter/foundation.dart';
import '../entities/follows_entity.dart';
import '../repositories/follows_repository.dart';

class UnFollowUserUseCase {
  final FollowsRepository repository;

  UnFollowUserUseCase({required this.repository});

  Future<void> execute(
    FollowsInput input
  ) async {
    try {
      await repository.unFollowUser(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("UnFollowUserUseCase Error: $e");
      rethrow;
    }
  }
  
}
