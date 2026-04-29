import 'package:flutter/foundation.dart';
import '../repositories/notifications_repository.dart';

class CheckUnreadNotificationsUseCase {
  final NotificationsRepository repository;

  CheckUnreadNotificationsUseCase({required this.repository});

  Future<bool> execute(
    String userId
  ) async {
    try {
      return await repository.checkUnreadNotifications(
        userId
      );
    } catch (e) {
      // エラーログ
      debugPrint("CheckUnreadNotificationsUseCase Error: $e");
      rethrow;
    }
  }
}
