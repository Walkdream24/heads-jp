import 'package:flutter/foundation.dart';
import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class FetchEventByIdUseCase {
  final EventsRepository repository;

  FetchEventByIdUseCase({required this.repository});

  Future<EventEntity> execute(String eventId) async {
    try {
      // リポジトリからイベントリストを取得
      final event = await repository.fetchEventById(eventId);
      return event;
    } catch (e) {
      // エラーログ
      debugPrint("FetchEventByIdUseCase Error: $e");
      rethrow;
    }
  }
}
