import 'package:flutter/foundation.dart';
import '../repositories/event_guest_repository.dart';

class CancelRegisterGuestUseCase {
  final EventGuestRepository repository;

  CancelRegisterGuestUseCase({required this.repository});

  Future<void> execute(
    String eventGuestId
  ) async {
    try {
      await repository.cancelRegisterGuest(eventGuestId);
    } catch (e) {
      // エラーログ
      debugPrint("CancelRegisterGuestUseCase Error: $e");
      rethrow;
    }
  }
}
