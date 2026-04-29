import 'package:flutter/foundation.dart';
import '../entities/combined_event_entity.dart';
import '../repositories/events_repository.dart';

class FetchTodayEventsUseCase {
  final EventsRepository repository;

  FetchTodayEventsUseCase({required this.repository});

  Future<List<CombinedEventEntity>> execute() async {
    try {
      // リポジトリからイベントリストを取得
      final events = await repository.fetchTodayEvents();
      return events;
    } catch (e) {
      // エラーログ
      debugPrint("FetchTodayEventsUseCase Error: $e");
      rethrow;
    }
  }
}
