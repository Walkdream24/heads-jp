import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../models/notification_model.dart';

class NotificationsRemoteDataSource {
  final ApiClient apiClient;

  NotificationsRemoteDataSource({required this.apiClient});

  Future<List<NotificationModel>> fetchNotifications(
    String userId
  ) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchNotifications',
        params: {'userId': userId},
      );

      debugPrint("fetchNotificationsのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("fetchNotifications情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? notificationsData = result['data'] as List<dynamic>?;
      if (notificationsData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をModelに変換（ここを修正）
      final List<NotificationModel> notifications = notificationsData.map((notificationJson) {
        // まず、Map<Object?, Object?>をMap<String, dynamic>に安全に変換
        final Map<String, dynamic> notificationJsonMap = {};
        (notificationJson as Map<Object?, Object?>).forEach((key, value) {
          if (key is String) {
            // データオブジェクトの特別な処理
            if (key == 'data' && value is Map<Object?, Object?>) {
              final dataMap = <String, dynamic>{};
              value.forEach((dataKey, dataValue) {
                if (dataKey is String) {
                  dataMap[dataKey] = dataValue;
                }
              });
              notificationJsonMap[key] = dataMap;
            } else {
              notificationJsonMap[key] = value;
            }
          }
        });
        return NotificationModel.fromJson(notificationJsonMap);
      }).toList();

      return notifications;

    } catch (e) {
      debugPrint("fetchNotifications エラー: $e");
      rethrow;
    }
  }

  Future<bool> checkUnreadNotifications(String userId) async {
    try {
      final result = await apiClient.call(
        apiName: 'checkUnreadNotifications',
        params: {
          'userId': userId,
        },
      );
  
        // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("unReadの確認に失敗しました: ${result['message']}");
      }
  
      // 'data'キー内のデータを取得
      final unRead = result['data'];
      if (unRead == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }
  
      // boolean値として返す
      return unRead as bool;
  
    } catch (e) {
      debugPrint("checkUnreadNotifications エラー: $e");
      rethrow;
    }
  }

  Future<void> readNotifications(List<String>notificationIds) async {
    try {
      final result = await apiClient.call(
        apiName: 'readNotifications',
        params: {
          'notificationIds': notificationIds,
        },
      );
        // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("readNotifications失敗しました: ${result['message']}");
      }
  
    } catch (e) {
      debugPrint("readNotifications エラー: $e");
      rethrow;
    }
  }



}

