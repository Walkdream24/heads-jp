import '../../domain/entities/notifications_entity.dart';

class NotificationModel {
  final String notificationId;
  final String userId;
  final NotificationType type;
  final String message;
  final String createdAt;
  final String updatedAt;
  final bool isRead;
  final NotificationData data;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.isRead,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] as String,
      userId: json['userId'] as String,
      type: NotificationTypeExtension.fromApiValue(json['type'] as String),
      message: json['message'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isRead: json['isRead'] as bool,
      data: NotificationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class NotificationData {
  final String title;
  final String? leftImageUrl;
  final String? rightImageUrl;
  final String? followerId;
  final String? clubId;
  final String? eventId;

  NotificationData({
    required this.title,
    this.leftImageUrl,
    this.rightImageUrl,
    this.followerId,
    this.clubId,
    this.eventId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: json['title'] as String,
      leftImageUrl: json['leftImageUrl'] as String?,
      rightImageUrl: json['rightImageUrl'] as String?,
      followerId: json['followerId'] as String?,
      clubId: json['clubId'] as String?,
      eventId: json['eventId'] as String?,
    );
  }
}