import 'package:flutter/foundation.dart';
import '../entities/memories_entity.dart';
import '../repositories/memories_repository.dart';

class FetchHomeMemoriesUseCase {
  final MemoriesRepository repository;

  FetchHomeMemoriesUseCase({required this.repository});

  Future<List<MemoryEntity>> execute() async {
    try {
      final memories = await repository.fetchHomeMemories();
      return memories;
    } catch (e) {
      // エラーログ
      debugPrint("FetchHomeMemoriesUseCase Error: $e");
      rethrow;
    }
  }
}
