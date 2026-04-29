import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../models/user_summary_model.dart';


class UserSummaryRemoteDataSource {
  final ApiClient apiClient;

  UserSummaryRemoteDataSource({required this.apiClient});

  Future<UserSummaryModel> fetchUserSummary(String userId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchUserSummary',
        params: {'userId': userId},
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }
      // 'data'キー内のデータを取得
      final userSummaryData = result['data'];
      if (userSummaryData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 明示的に型変換
      final Map<String, dynamic> userSummaryDataMap = Map<String, dynamic>.from(userSummaryData as Map);

      // Modelに変換
      final userSummaryDataModel = UserSummaryModel.fromJson(userSummaryDataMap);
      return userSummaryDataModel;
    } catch (e) {
      debugPrint("fetchUserSummary エラー: $e");
      rethrow;
    }
  }

  Future<List<UserSummaryModel>> fetchUsers(List<String> userIds) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchUsers',
        params: {'userIds': userIds},
      );
      debugPrint("fetchUsersのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("ユーザーズ情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? performersData = result['data'] as List<dynamic>?;
      if (performersData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をModelに変換
      final List<UserSummaryModel> users = performersData.map((userSummaryJson) {
        final Map<String, dynamic> usersSummaryMap = Map<String, dynamic>.from(userSummaryJson as Map);
        return UserSummaryModel.fromJson(usersSummaryMap);
      }).toList();

      debugPrint('データ変換後: $users');
      return users;
    } catch (e) {
      debugPrint("fetchUsersエラー: $e");
      rethrow;
    }
  }

  Future<List<UserSummaryModel>> searchUsersByHeadsId(String query) async {
    try {
      final result = await apiClient.call(
        apiName: 'searchUsersByHeadsId',
        params: {'query': query},
      );
      debugPrint("searchUsersByHeadsIdのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("ユーザーズ情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? usersData = result['data'] as List<dynamic>?;
      if (usersData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をModelに変換
      final List<UserSummaryModel> users = usersData.map((userSummaryJson) {
        final Map<String, dynamic> usersSummaryMap = Map<String, dynamic>.from(userSummaryJson as Map);
        return UserSummaryModel.fromJson(usersSummaryMap);
      }).toList();

      debugPrint('データ変換後: $users');
      return users;
    } catch (e) {
      debugPrint("searchUsersByHeadsIdエラー: $e");
      rethrow;
    }
  }
}
