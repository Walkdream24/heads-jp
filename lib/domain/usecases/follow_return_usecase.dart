import 'package:flutter/foundation.dart';
import '../entities/follows_entity.dart';
import '../repositories/follows_repository.dart';

class FollowReturnUseCase {
  final FollowsRepository repository;

  FollowReturnUseCase({required this.repository});

  Future<void> execute(
    FollowsInput input
  ) async {
    try {
      await repository.followReturn(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("FollowRequestUseCase Error: $e");
      rethrow;
    }
  }
  
}
