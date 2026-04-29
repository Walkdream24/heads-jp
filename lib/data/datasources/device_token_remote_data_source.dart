import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../../domain/entities/device_token_entity.dart';


class DeviceTokenRemoteDataSource {
  final ApiClient apiClient;

  DeviceTokenRemoteDataSource({required this.apiClient});

  Future<void> upsertDeviceToken(
    DeviceTokenInput input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'upsertDeviceToken',
        params: {
          'userId': input.userId,
          'token': input.token,
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("デバイストークン登録に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("upsertDeviceToken エラー: $e");
      rethrow;
    }
  }
}
