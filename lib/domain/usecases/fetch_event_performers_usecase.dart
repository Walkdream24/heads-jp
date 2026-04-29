import 'package:flutter/foundation.dart';
import '../entities/event_performer_entity.dart';
import '../repositories/event_performers_repository.dart';

class FetchEventPerformersUseCase {
  final EventPerformersRepository repository;

  FetchEventPerformersUseCase({required this.repository});

  Future<List<EventPerformerEntity>> execute(String eventId) async {
    try {
      // リポジトリからイベントリストを取得
      final performers = await repository.fetchEventPerformers(eventId);
      return performers;
    } catch (e) {
      // エラーログ
      debugPrint("FetchEventPerformersUseCase Error: $e");
      rethrow;
    }
  }
}
