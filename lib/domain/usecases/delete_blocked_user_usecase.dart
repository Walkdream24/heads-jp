import 'package:flutter/foundation.dart';
import '../entities/blocked_users_entity.dart';
import '../repositories/blocked_users_repository.dart';

class DeleteBlockedUserUseCase {
  final BlockedUsersRepository repository;

  DeleteBlockedUserUseCase({required this.repository});

  Future<void> execute(
    BlockedUsersParams input
  ) async {
    try {
      await repository.deleteBlcokedUser(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("DeleteBlockedUserUseCase Error: $e");
      rethrow;
    }
  }
}
