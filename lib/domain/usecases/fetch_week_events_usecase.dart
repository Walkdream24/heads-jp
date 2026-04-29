import 'package:flutter/foundation.dart';
import '../entities/combined_event_entity.dart';
import '../repositories/events_repository.dart';

class FetchWeekEventsUseCase {
  final EventsRepository repository;

  FetchWeekEventsUseCase({required this.repository});

  Future<List<CombinedEventEntity>> execute() async {
    try {
      // リポジトリからイベントリストを取得
      final events = await repository.fetchWeekEvents();
      return events;
    } catch (e) {
      // エラーログ
      debugPrint("FetchWeekEventsUseCase Error: $e");
      rethrow;
    }
  }
}
