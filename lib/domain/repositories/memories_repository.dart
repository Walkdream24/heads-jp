import '../entities/memories_entity.dart';

abstract class MemoriesRepository {
  Future<void> addMemory(
    MemoryEntity input
  );
  Future<List<MemoryEntity>> fetchMemories(String userId);
  Future<List<MemoryEntity>> fetchEventMemories(String eventId);
  Future<void> archiveMemory(MemoryEntity input);
  Future<List<MemoryEntity>> fetchHomeMemories();
}
