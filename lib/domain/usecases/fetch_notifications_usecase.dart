import 'package:flutter/foundation.dart';
import '../entities/notifications_entity.dart';
import '../repositories/notifications_repository.dart';

class FetchNotificationsUseCase {
  final NotificationsRepository repository;

  FetchNotificationsUseCase({required this.repository});

  Future<List<NotificationEntity>> execute(String userId) async {
    try {
      // リポジトリからリストを取得
        debugPrint("FetchNotificationsUseCase");
      final notifications = await repository.fetchNotifications(userId);
      return notifications;
    } catch (e) {
      // エラーログ
      debugPrint("FetchNotificationsUseCase Error: $e");
      rethrow;
    }
  }
}
