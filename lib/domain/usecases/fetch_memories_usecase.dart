import 'package:flutter/foundation.dart';
import '../entities/memories_entity.dart';
import '../repositories/memories_repository.dart';

class FetchMemoriesUseCase {
  final MemoriesRepository repository;

  FetchMemoriesUseCase({required this.repository});

  Future<List<MemoryEntity>> execute(String userId) async {
    try {
      // リポジトリからリストを取得
        debugPrint("FetchMemoriesUseCase");
      final memories = await repository.fetchMemories(userId);
      return memories;
    } catch (e) {
      // エラーログ
      debugPrint("FetchMemoriesUseCase Error: $e");
      rethrow;
    }
  }
}
