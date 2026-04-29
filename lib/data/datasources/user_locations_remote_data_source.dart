import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../../domain/entities/user_locations_entity.dart';
import '../models/user_locations_model.dart';


class UserLocationsRemoteDataSource {
  final ApiClient apiClient;

  UserLocationsRemoteDataSource({required this.apiClient});

  Future<void> addUserLocationsForeground(
    AddUserLocationInput input,
    ) async {
    try {
      debugPrint("UserLocationsRemoteDataSource$input");
      final result = await apiClient.call(
        apiName: 'addUserLocationsForeground',
        params: {
          'userId': input.userId,
          'currentLatitude': input.latitude,
          'currentLongitude': input.longitude,
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("位置情報の更新に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("addUserLocationsForeground エラー: $e");
      rethrow;
    }
  }
  Future<List<UserLocationsModel>> fetchUserLocations(String userId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchUserLocations',
        params: {'userId': userId},
      );
      debugPrint("fetchUserLocationsのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("fetchUserLocations情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? locationsData = result['data'] as List<dynamic>?;
      if (locationsData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をModelに変換
      final List<UserLocationsModel> locations = locationsData.map((locationsJson) {
        final Map<String, dynamic> locationsMap = Map<String, dynamic>.from(locationsJson as Map);
        return UserLocationsModel.fromJson(locationsMap);
      }).toList();

      debugPrint('データ変換後: $locations');
      return locations;
    } catch (e) {
      debugPrint("locationsエラー: $e");
      rethrow;
    }
  }
}
