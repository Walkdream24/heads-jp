import 'package:flutter/foundation.dart';
import '../entities/combined_event_entity.dart';
import '../repositories/events_repository.dart';

class FetchEventsByDateUseCase {
  final EventsRepository repository;

  FetchEventsByDateUseCase({required this.repository});

  Future<List<CombinedEventEntity>> execute(String dateString) async {
    try {
      // リポジトリからイベントリストを取得
      final events = await repository.fetchEventsByDate(dateString);
      return events;
    } catch (e) {
      // エラーログ
      debugPrint("FetchEventsByDateUseCase Error: $e");
      rethrow;
    }
  }
}
