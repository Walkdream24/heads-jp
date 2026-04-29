import 'package:flutter/foundation.dart';
import '../entities/memories_entity.dart';
import '../repositories/memories_repository.dart';

class FetchEventMemoriesUseCase {
  final MemoriesRepository repository;

  FetchEventMemoriesUseCase({required this.repository});

  Future<List<MemoryEntity>> execute(String eventId) async {
    try {
      // リポジトリからリストを取得
        debugPrint("FetchMemoriesUseCase");
      final memories = await repository.fetchEventMemories(eventId);
      return memories;
    } catch (e) {
      // エラーログ
      debugPrint("FetchEventMemoriesUseCase Error: $e");
      rethrow;
    }
  }
}
