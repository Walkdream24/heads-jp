import 'package:flutter/foundation.dart';
import '../entities/blocked_users_entity.dart';
import '../repositories/blocked_users_repository.dart';

class AddBlockedUserUseCase {
  final BlockedUsersRepository repository;

  AddBlockedUserUseCase({required this.repository});

  Future<void> execute(
    BlockedUsersParams input
  ) async {
    try {
      await repository.addBlockedUser(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("AddBlockedUserUseCase Error: $e");
      rethrow;
    }
  }
}
