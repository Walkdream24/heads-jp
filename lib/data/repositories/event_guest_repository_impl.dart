import 'package:flutter/foundation.dart';
import '../../domain/entities/event_guest_entity.dart';
import '../../domain/repositories/event_guest_repository.dart';
import '../datasources/event_guest_remote_data_source.dart';

class EventGuestRepositoryImpl implements EventGuestRepository {
  final EventGuestRemoteDataSource remoteDataSource;

  EventGuestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> registerEventGuest(
    RegisterGuestInput input
    ) async {
    try {
      await remoteDataSource.registerEvenGuest(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("EventGuestRepositoryImpl Error: $e");
      rethrow;
    }
  }
  
  @override
  Future<List<EventGuestEntity>> fetchEventGuests(
    String eventId
  ) async {
    try {
      // Remote DataSourceからModelリストを取得
      final guestModels = await remoteDataSource.fetchEventGuests(eventId);

      // ModelをEntityに変換
      final performers = guestModels.map((model) => EventGuestEntity(
        eventGuestId: model.eventGuestId,
        eventId: model.eventId,
        userId: model.userId,
        guestName: model.guestName,
        targetArtistName: model.targetArtistName,
      )).toList();

      return performers;
    } catch (e) {
      // エラーログ
      debugPrint("EventGuestRepositoryImpl Error: $e");
      rethrow;
    }
  }
  
  @override
  Future<void> cancelRegisterGuest(String eventGuestId) async {
    try {
      await remoteDataSource.cancelRegisterGuest(eventGuestId);
    } catch (e) {
      // エラーログ
      debugPrint("EventGuestRepositoryImpl Error: $e");
      rethrow;
    }
  }
}
