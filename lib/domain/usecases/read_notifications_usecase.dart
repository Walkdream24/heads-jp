import 'package:flutter/foundation.dart';
import '../repositories/notifications_repository.dart';

class ReadNotificationsUseCase {
  final NotificationsRepository repository;

  ReadNotificationsUseCase({required this.repository});

  Future<void> execute(
    List<String> notificationIds
  ) async {
    try {
      await repository.readNotifications(
        notificationIds
      );
    } catch (e) {
      // エラーログ
      debugPrint("ReadNotificationsUseCase Error: $e");
      rethrow;
    }
  }
  
}
