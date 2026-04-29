import 'package:flutter/foundation.dart';
import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class FetchEventsByUserIdUseCase {
  final EventsRepository repository;

  FetchEventsByUserIdUseCase({required this.repository});

  Future<List<EventEntity>> execute(String userId) async {
    try {
      // リポジトリからイベントリストを取得
      final events = await repository.fetchEventsByUserId(userId);
      return events;
    } catch (e) {
      // エラーログ
      debugPrint("FetchEventsByUserIdUseCase Error: $e");
      rethrow;
    }
  }
}
