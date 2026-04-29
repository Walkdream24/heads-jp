import 'package:flutter/foundation.dart';
import '../entities/memories_entity.dart';
import '../repositories/memories_repository.dart';

class AddMemoryUseCase {
  final MemoriesRepository repository;

  AddMemoryUseCase({required this.repository});

  Future<void> execute(
    MemoryEntity input
  ) async {
    try {
      await repository.addMemory(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("AddMemoryUseCase Error: $e");
      rethrow;
    }
  }
}
