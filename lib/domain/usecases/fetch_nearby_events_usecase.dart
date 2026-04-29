import 'package:flutter/foundation.dart';
import '../entities/combined_event_entity.dart';
import '../repositories/events_repository.dart';
import '../entities/user_locations_entity.dart';

class FetchNearbyEventsUseCase {
  final EventsRepository repository;

  FetchNearbyEventsUseCase({required this.repository});

  Future<List<CombinedEventEntity>> execute(
    AddUserLocationInput input
  ) async {
    try {
      // リポジトリからイベントリストを取得
      final events = await repository.fetchNearbyEvents(input);
      return events;
    } catch (e) {
      // エラーログ
      debugPrint("FetchNearbyEventsUseCase Error: $e");
      rethrow;
    }
  }
}
