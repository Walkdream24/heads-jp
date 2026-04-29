import 'package:flutter/foundation.dart';
import '../entities/event_entity.dart'; // EventEntity をインポート (RegisterEventEntity ではなく)
import '../repositories/events_repository.dart';

class RegisterEventUseCase {
  final EventsRepository repository;

  RegisterEventUseCase({required this.repository});

  Future<void> execute(
    EventEntity input // 引数の型は EventEntity のまま
  ) async {
    try {
      final dateISO = input.date.toUtc().toIso8601String();
      final startDatetimeISO = input.startDatetime.toUtc().toIso8601String();
      final endDatetimeISO = input.endDatetime.toUtc().toIso8601String();

      RegisterEventEntity event = RegisterEventEntity(
        eventId: input.eventId, 
        clubId: input.clubId,
        eventName: input.eventName,
        flyerPhotoUrl: input.flyerPhotoUrl,
        description: input.description,
        date: dateISO, // ISO 文字列をセット
        startDatetime: startDatetimeISO, // ISO 文字列をセット
        endDatetime: endDatetimeISO, // ISO 文字列をセット
        entranceFee: input.entranceFee,
        genre: input.genre,
      );
      await repository.registerEvent(
        event 
      );
    } catch (e) {
      // エラーログ
      debugPrint("RegisterEventUseCase Error: $e");
      rethrow;
    }
  }
}