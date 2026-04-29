import 'package:flutter/foundation.dart';
import '../repositories/user_repository.dart';

class CheckHeadsIdExistsUseCase {
  final UserRepository repository;

  CheckHeadsIdExistsUseCase({required this.repository});

  Future<bool> execute(String inputId) async {
    try {
      final exists = await repository.checkheadsIdExists(inputId);
      return exists;
    } catch (e) {
      // エラーログ
      debugPrint("CheckHeadsIdExistsUseCase Error: $e");
      rethrow;
    }
  }
}
