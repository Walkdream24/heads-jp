import 'package:flutter/foundation.dart';
import 'package:HEADS/domain/entities/event_entity.dart';

import '../../domain/entities/combined_event_entity.dart';
import '../../domain/repositories/user_events_guest_repository.dart';
import '../datasources/user_events_guest_remote_data_source.dart';

class UserEventsGuestRepositoryImpl implements UserEventsGuestRepository {
  final UserEventsGuestRemoteDataSource remoteDataSource;

  UserEventsGuestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CombinedEventEntity>> fetchUserEventsGuest(String userId) async {
    try {
      // DataSourceからModelリストを取得
      final eventModels = await remoteDataSource.fetchUserEventsGuest(userId);

      // ModelをEntityに変換
      final events = eventModels.map((model) => CombinedEventEntity(
        event: EventEntity(
          eventId: model.eventId, 
          clubId: model.clubId, 
          eventName: model.eventName,
          flyerPhotoUrl: model.flyerPhotoUrl, 
          description: model.description, 
          date: model.date, 
          startDatetime: model.startDatetime, 
          endDatetime: model.endDatetime, 
          entranceFee: model.entranceFee
        ),
        clubName: model.clubName,
        clubAddress: model.clubAddress
      )).toList();

      return events;
    } catch (e) {
      // エラーログ
      debugPrint("UserEventsGuestRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<CombinedEventEntity>> fetchUserEventsPerformer(String userId) async {
    try {
      // DataSourceからModelリストを取得
      final eventModels = await remoteDataSource.fetchUserEventsPerformer(userId);

      // ModelをEntityに変換
      final events = eventModels.map((model) => CombinedEventEntity(
        event: EventEntity(
          eventId: model.eventId, 
          clubId: model.clubId, 
          eventName: model.eventName,
          flyerPhotoUrl: model.flyerPhotoUrl, 
          description: model.description, 
          date: model.date, 
          startDatetime: model.startDatetime, 
          endDatetime: model.endDatetime, 
          entranceFee: model.entranceFee
        ),
        clubName: model.clubName,
        clubAddress: model.clubAddress
      )).toList();

      return events;
    } catch (e) {
      // エラーログ
      debugPrint("UserEventsGuestRepositoryImpl Error: $e");
      rethrow;
    }
  }
}
