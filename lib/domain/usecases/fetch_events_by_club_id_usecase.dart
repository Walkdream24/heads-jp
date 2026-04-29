import 'package:flutter/foundation.dart';
import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class FetchEventsByClubIdUseCase {
  final EventsRepository repository;

  FetchEventsByClubIdUseCase({required this.repository});

  Future<List<EventEntity>> execute(String clubId) async {
    try {
      // リポジトリからイベントリストを取得
      final events = await repository.fetchEventsByClubId(clubId);
      return events;
    } catch (e) {
      // エラーログ
      debugPrint("FetchEventsByClubIdUseCase Error: $e");
      rethrow;
    }
  }
}
