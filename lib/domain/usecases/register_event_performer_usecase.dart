import 'package:flutter/foundation.dart';
import '../entities/event_performer_entity.dart';
import '../repositories/event_performers_repository.dart';

class RegisterEventPerformerUseCase {
  final EventPerformersRepository repository;

  RegisterEventPerformerUseCase({required this.repository});

  Future<void> execute(
    RegisterPerfomerInput input
  ) async {
    try {
      await repository.registerEventPerformer(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("RegisterEventPerformerUseCase Error: $e");
      rethrow;
    }
  }
  
}
