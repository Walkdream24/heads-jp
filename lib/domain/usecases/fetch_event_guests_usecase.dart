import 'package:flutter/foundation.dart';
import '../entities/event_guest_entity.dart';
import '../repositories/event_guest_repository.dart';

class FetchEventGuestsUseCase {
  final EventGuestRepository repository;

  FetchEventGuestsUseCase({required this.repository});

  Future<List<EventGuestEntity>> execute(String eventId) async {
    try {
      // リポジトリからイベントリストを取得
      final performers = await repository.fetchEventGuests(eventId);
      return performers;
    } catch (e) {
      // エラーログ
      debugPrint("FetchEventGuestsUseCase Error: $e");
      rethrow;
    }
  }
}
