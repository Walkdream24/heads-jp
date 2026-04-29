import '../../data/models/notification_model.dart';

class NotificationEntity {
  final String notificationId;
  final String userId;
  final NotificationType type;
  final String message;
  final String createdAt;
  final String updatedAt;
  final bool isRead;
  final NotificationData data;

  NotificationEntity({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.isRead,
    required this.data,
  });
}

enum NotificationType {
  FOLLOW,
  ADD_EVENT,
  JOIN_ARTIST,
  JOIN_HEADS,
}

extension NotificationTypeExtension on NotificationType {
  String toApiValue() {
    switch (this) {
      case NotificationType.FOLLOW:
        return "follow";
      case NotificationType.ADD_EVENT:
        return "add_event";
      case NotificationType.JOIN_ARTIST:
        return "join_artist";
      case NotificationType.JOIN_HEADS:
        return "join_heads";
    }
  }

  static NotificationType fromApiValue(String value) {
    switch (value) {
      case "follow":
        return NotificationType.FOLLOW;
      case "add_event":
        return NotificationType.ADD_EVENT;
      case "join_artist":
        return NotificationType.JOIN_ARTIST;
      case "join_heads":
      default:
        return NotificationType.JOIN_HEADS;
    }
  }
}