import '../entities/notifications_entity.dart';

abstract class NotificationsRepository {
  Future<List<NotificationEntity>> fetchNotifications(String userId);
  Future<bool> checkUnreadNotifications(String userId);
  Future<void> readNotifications(List<String>notificationIds);
}
