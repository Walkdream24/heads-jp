import 'package:flutter/foundation.dart';

import '../../domain/entities/notifications_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> fetchNotifications(String userId) async {
    try {
      // DataSourceからModelリストを取得
      final notificationsModel = await remoteDataSource.fetchNotifications(userId);

      // ModelをEntityに変換
      final notifications = notificationsModel.map((model) {
        return NotificationEntity(
          notificationId: model.notificationId,
          userId: model.userId,
          type: model.type,
          message: model.message,
          createdAt: model.createdAt,
          updatedAt: model.updatedAt,
          isRead: model.isRead,
          data: model.data
        );
      }).toList();

      return notifications;
    } catch (e) {
      // エラーログ
      debugPrint("NotificationsRepositoryImpl Error: $e");
      rethrow;
    }
  }
  
  @override
  Future<bool> checkUnreadNotifications(String userId) async {
    try {
      return await remoteDataSource.checkUnreadNotifications(userId);
    } catch (e) {
      // エラーログ
      debugPrint("NotificationsRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<void> readNotifications(List<String> notificationIds) async {
    try {
      return await remoteDataSource.readNotifications(notificationIds);
    } catch (e) {
      // エラーログ
      debugPrint("NotificationsRepositoryImpl Error: $e");
      rethrow;
    }
  }

}
