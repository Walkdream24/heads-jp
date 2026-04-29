import 'package:flutter/foundation.dart';
import '../../domain/entities/event_performer_entity.dart';
import '../../domain/repositories/event_performers_repository.dart';
import '../datasources/event_performers_remote_data_source.dart';

class EventPerformersRepositoryImpl implements EventPerformersRepository {
  final EventPerformersRemoteDataSource remoteDataSource;

  EventPerformersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> registerEventPerformer(
    RegisterPerfomerInput input
    ) async {
    try {
      await remoteDataSource.registerEventPerformer(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("EventPerformersRepositoryImpl Error: $e");
      rethrow;
    }
  }
  
  @override
  Future<List<EventPerformerEntity>> fetchEventPerformers(
    String eventId
  ) async {
    try {
      // Remote DataSourceからPerformersModelリストを取得
      final performersModels = await remoteDataSource.fetchEventPerformers(eventId);

      // PerformersModelをEventPerformerEntityに変換
      final performers = performersModels.map((model) => EventPerformerEntity(
        eventPerformerId: model.eventPerformerId,
        eventId: model.eventId,
        userId: model.userId,
        role: model.role,
      )).toList();

      return performers;
    } catch (e) {
      // エラーログ
      debugPrint("EventPerformersRepositoryImpl Error: $e");
      rethrow;
    }
  }
  
  @override
  Future<void> cancelRegisterPerformer(String eventPerformerId) async {
    await remoteDataSource.cancelRegisterPerformer(eventPerformerId);
  }
}
