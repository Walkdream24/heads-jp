import 'package:flutter/foundation.dart';
import '../../domain/entities/memories_entity.dart';
import '../../domain/repositories/memories_repository.dart';
import '../datasources/memories_remote_data_source.dart';

class MemoriesRepositoryImpl implements MemoriesRepository {
  final MemoriesRemoteDataSource remoteDataSource;

  MemoriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addMemory(
    MemoryEntity input
    ) async {
    try {
      await remoteDataSource.addMemory(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("MemoriesRepositoryImpl Error: $e");
      rethrow;
    }
  }
  
  @override
  Future<List<MemoryEntity>> fetchMemories(
    String userId
  ) async {
    try {
      // Remote DataSourceからModelリストを取得
      final memoryModels = await remoteDataSource.fetchMemories(userId);

      // ModelをEntityに変換
      final memories = memoryModels.map((model) => MemoryEntity(
        memoryId: model.memoryId,
        eventId: model.eventId,
        userId: model.userId,
        photoUrl: model.photoUrl,
        caption: model.caption,
        isArchived: model.isArchived,
      )).toList();

      return memories;
    } catch (e) {
      // エラーログ
      debugPrint("MemoriesRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<MemoryEntity>> fetchEventMemories(
    String eventId
  ) async {
    try {
      // Remote DataSourceからModelリストを取得
      final memoryModels = await remoteDataSource.fetchEventMemories(eventId);

      // ModelをEntityに変換
      final memories = memoryModels.map((model) => MemoryEntity(
        memoryId: model.memoryId,
        eventId: model.eventId,
        userId: model.userId,
        photoUrl: model.photoUrl,
        caption: model.caption,
        isArchived: model.isArchived,
      )).toList();

      return memories;
    } catch (e) {
      // エラーログ
      debugPrint("MemoriesRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<void> archiveMemory(
    MemoryEntity input
    ) async {
    try {
      await remoteDataSource.archiveMemory(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("MemoriesRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<MemoryEntity>> fetchHomeMemories() async {
    try {
      // Remote DataSourceからModelリストを取得
      final memoryModels = await remoteDataSource.fetchHomeMemories();

      // ModelをEntityに変換
      final memories = memoryModels.map((model) => MemoryEntity(
        memoryId: model.memoryId,
        eventId: model.eventId,
        userId: model.userId,
        photoUrl: model.photoUrl,
        caption: model.caption,
        isArchived: model.isArchived,
      )).toList();

      return memories;
    } catch (e) {
      // エラーログ
      debugPrint("MemoriesRepositoryImpl Error: $e");
      rethrow;
    }
  }
}
