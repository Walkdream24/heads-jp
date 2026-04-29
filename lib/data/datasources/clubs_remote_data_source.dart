import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../models/club_model.dart';

class ClubsRemoteDataSource {
  final ApiClient apiClient;
  ClubsRemoteDataSource({required this.apiClient});

  Future<List<ClubModel>> fetchClubs() async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchClubs',
        params: {},
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("クラブ情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? clubsData = result['data'] as List<dynamic>?;
      if (clubsData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をClubModelに変換
      final List<ClubModel> clubs = clubsData.map((clubJson) {
        final Map<String, dynamic> clubMap = Map<String, dynamic>.from(clubJson as Map);
        return ClubModel.fromJson(clubMap);
      }).toList();

      return clubs;
    } catch (e) {
      debugPrint("fetchClubs エラー: $e");
      rethrow;
    }
  }

  Future<ClubModel> fetchClubById(String clubId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchClubById',
        params: {'clubId': clubId},
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("クラブ情報の取得に失敗しました: ${result['message']}");
      }
      // 'data'キー内のデータを取得
      final clubData = result['data'];
      if (clubData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 明示的に型変換
      final Map<String, dynamic> clubDataMap = Map<String, dynamic>.from(clubData as Map);

      // Modelに変換
      final clubDataModel = ClubModel.fromJson(clubDataMap);
      return clubDataModel;
    } catch (e) {
      debugPrint("fetchClubById エラー: $e");
      rethrow;
    }
  }

  Future<List<ClubInfoModel>> fetchAllClubsInfo() async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchAllClubsInfo',
        params: {},
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("クラブ情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? clubsData = result['data'] as List<dynamic>?;
      if (clubsData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をClubModelに変換
      final List<ClubInfoModel> clubs = clubsData.map((clubJson) {
        final Map<String, dynamic> clubMap = Map<String, dynamic>.from(clubJson as Map);
        return ClubInfoModel.fromJson(clubMap);
      }).toList();

      return clubs;
    } catch (e) {
      debugPrint("fetchAllClubsInfo エラー: $e");
      rethrow;
    }
  }

  Future<List<ClubInfoModel>> fetchBookmarkClubs(
    String userId,
  ) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchBookmarkClubs',
        params: {
          'userId': userId
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("クラブ情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? clubsData = result['data'] as List<dynamic>?;
      if (clubsData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をClubModelに変換
      final List<ClubInfoModel> clubs = clubsData.map((clubJson) {
        final Map<String, dynamic> clubMap = Map<String, dynamic>.from(clubJson as Map);
        return ClubInfoModel.fromJson(clubMap);
      }).toList();

      return clubs;
    } catch (e) {
      debugPrint("fetchBookmarkClubs エラー: $e");
      rethrow;
    }
  }
}
