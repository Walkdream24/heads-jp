import 'package:flutter/foundation.dart';
import '../entities/memories_entity.dart';
import '../repositories/memories_repository.dart';

class ArchiveMemoryUseCase {
  final MemoriesRepository repository;

  ArchiveMemoryUseCase({required this.repository});

  Future<void> execute(
    MemoryEntity input
  ) async {
    try {
      await repository.archiveMemory(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("ArchiveMemoryUseCase Error: $e");
      rethrow;
    }
  }
}
