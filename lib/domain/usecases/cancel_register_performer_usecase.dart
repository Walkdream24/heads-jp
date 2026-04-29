import 'package:flutter/foundation.dart';
import '../repositories/event_performers_repository.dart';

class CancelRegisterPerformerUseCase {
  final EventPerformersRepository repository;

  CancelRegisterPerformerUseCase({required this.repository});

  Future<void> execute(
    String eventPerformerId
  ) async {
    try {
      await repository.cancelRegisterPerformer(eventPerformerId);
    } catch (e) {
      // エラーログ
      debugPrint("CancelRegisterPerformerUseCase Error: $e");
      rethrow;
    }
  }
}
