import 'package:flutter/foundation.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/combined_event_entity.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_remote_data_source.dart';
import '../../core/util/exceptions.dart';
import '../../domain/entities/user_locations_entity.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;

  EventsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<EventEntity>> fetchEventsByClubId(String clubId) async {
    try {
      // Remote DataSourceからEventModelリストを取得
      final eventModels = await remoteDataSource.fetchEventsByClubId(clubId);

      // EventModelをEventEntityに変換
      final events = eventModels.map((model) => EventEntity(
        eventId: model.eventId,
        clubId: model.clubId,
        eventName: model.eventName,
        flyerPhotoUrl: model.flyerPhotoUrl,
        description: model.description,
        date: model.date,
        startDatetime: model.startDatetime,
        endDatetime: model.endDatetime,
        entranceFee: model.entranceFee,
        genre: model.genre,
      )).toList();

      return events;
    } catch (e) {
      // エラーログ
      debugPrint("EventsRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<EventEntity>> fetchEventsByUserId(String userId) async {
    try {
      // Remote DataSourceからEventModelリストを取得
      final eventModels = await remoteDataSource.fetchEventsByUserId(userId);

      // EventModelをEventEntityに変換
      final events = eventModels.map((model) => EventEntity(
        eventId: model.eventId,
        clubId: model.clubId,
        eventName: model.eventName,
        flyerPhotoUrl: model.flyerPhotoUrl,
        description: model.description,
        date: model.date,
        startDatetime: model.startDatetime,
        endDatetime: model.endDatetime,
        entranceFee: model.entranceFee,
        genre: model.genre,
      )).toList();

      return events;
    } catch (e) {
      // エラーログ
      debugPrint("EventsRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<EventEntity> fetchEventById(
    String eventId
    ) async {
    try {
      final result = await remoteDataSource.fetchEventById(
        eventId
      );
      return EventEntity(
        eventId: result.eventId,
        clubId: result.clubId,
        eventName: result.eventName,
        flyerPhotoUrl: result.flyerPhotoUrl,
        description: result.description,
        date: result.date,
        startDatetime: result.startDatetime,
        endDatetime: result.endDatetime,
        entranceFee: result.entranceFee,
        genre: result.genre,
      );
    } catch (e) {
      // エラーログ
      debugPrint("EventsRepositoryImpl fetchEventById Error: $e");
      rethrow;
    }
  }
  
  @override
  Future<void> registerEvent(
    RegisterEventEntity input,
  ) async {
     try {
      await remoteDataSource.registerEvent(input);
    } catch (e) {
      if (e is EventRegistrationDataSourceException) {
        // モデルからエンティティへの変換
        final entityDuplicates = e.duplicateEvents.map((model) => EventEntity(
          eventId: model.eventId,
          clubId: model.clubId,
          eventName: model.eventName,
          flyerPhotoUrl: model.flyerPhotoUrl,
          description: model.description,
          date: model.date,
          startDatetime: model.startDatetime,
          endDatetime: model.endDatetime,
          entranceFee: model.entranceFee,
        )).toList();
        
        // ドメイン層の例外に変換して再スロー
        throw EventRegistrationException(
          success: e.success,
          message: e.message,
          duplicateEvents: entityDuplicates,
        );
      }
      // エラーログ
      debugPrint("EventsRepositoryImpl registerEvent Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<CombinedEventEntity>> fetchTodayEvents() async {
    try {
      // Remote DataSourceからEventModelリストを取得
      final eventModels = await remoteDataSource.fetchTodayEvents();

      // EventModelをEventEntityに変換
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
          entranceFee: model.entranceFee,
          genre: model.genre,
        ),
        clubName: model.clubName,
        clubAddress: model.clubAddress
      )).toList();

      return events;
    } catch (e) {
      // エラーログ
      debugPrint("EventsRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<CombinedEventEntity>> fetchWeekEvents() async {
    try {
      // Remote DataSourceからEventModelリストを取得
      final eventModels = await remoteDataSource.fetchWeekEvents();

      // EventModelをEventEntityに変換
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
          entranceFee: model.entranceFee,
          genre: model.genre,
        ),
        clubName: model.clubName,
        clubAddress: model.clubAddress
      )).toList();

      return events;
    } catch (e) {
      // エラーログ
      debugPrint("EventsRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<CombinedEventEntity>> fetchNearbyEvents(
    AddUserLocationInput input
  ) async {
    try {
      final eventModels = await remoteDataSource.fetchNearbyEvents(
        input
      );
      // EventModelをEventEntityに変換
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
          entranceFee: model.entranceFee,
          genre: model.genre,
        ),
        clubName: model.clubName,
        clubAddress: model.clubAddress,
        distanceKm: model.distanceKm,
      )).toList();
      return events;
    } catch (e) {
       // エラーログ
      debugPrint("EventsRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<CombinedEventEntity>> fetchEventsByDate(String dateString) async {
    try {
      final eventModels = await remoteDataSource.fetchEventsByDate(dateString);
      // EventModelをEventEntityに変換
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
          entranceFee: model.entranceFee,
          genre: model.genre,
        ),
        clubName: model.clubName,
        clubAddress: model.clubAddress,
        distanceKm: model.distanceKm,
      )).toList();
      return events;

    } catch (e) {
      debugPrint("EventsRepositoryImpl Error: $e");
      rethrow;
    }
  }

}
