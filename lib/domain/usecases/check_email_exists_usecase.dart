import 'package:flutter/foundation.dart';
import '../repositories/user_repository.dart';

class CheckEmailExistsUseCase {
  final UserRepository repository;

  CheckEmailExistsUseCase({required this.repository});

  Future<bool> execute(String inputEmail) async {
    try {
      final exists = await repository.checkEmailExists(inputEmail);
      return exists;
    } catch (e) {
      // エラーログ
      debugPrint("CheckEmailExistsUseCase Error: $e");
      rethrow;
    }
  }
}
