import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';

class DeleteUserAccountUseCase {
  final AuthRepository repository;

  DeleteUserAccountUseCase({required this.repository});

  Future<void> execute(
    String userId
  ) async {
    try {
      await repository.deleteUserAccount(
        userId
      );
    } catch (e) {
      // エラーログ
      debugPrint("DeleteUserAccountUseCase Error: $e");
      rethrow;
    }
  }
}
