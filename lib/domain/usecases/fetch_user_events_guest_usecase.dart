import 'package:flutter/foundation.dart';
import '../entities/combined_event_entity.dart';
import '../repositories/user_events_guest_repository.dart';

class FetchUserEventsGuestUseCase {
  final UserEventsGuestRepository repository;

  FetchUserEventsGuestUseCase({required this.repository});

  Future<List<CombinedEventEntity>> execute(String userId) async {
    try {
      // リポジトリからイベントリストを取得
      final events = await repository.fetchUserEventsGuest(userId);
      return events;
    } catch (e) {
      // エラーログ
      debugPrint("FetchUserEventsGuestUseCase Error: $e");
      rethrow;
    }
  }
}
