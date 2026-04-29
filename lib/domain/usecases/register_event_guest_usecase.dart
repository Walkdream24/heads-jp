import 'package:flutter/foundation.dart';
import '../entities/event_guest_entity.dart';
import '../repositories/event_guest_repository.dart';

class RegisterEventGuestUseCase {
  final EventGuestRepository repository;

  RegisterEventGuestUseCase({required this.repository});

  Future<void> execute(
    RegisterGuestInput input
  ) async {
    try {
      await repository.registerEventGuest(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("RegisterEventGuestUseCase Error: $e");
      rethrow;
    }
  }
  
}
