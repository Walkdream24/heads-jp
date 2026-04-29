import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../models/combined_event_model.dart';

class UserEventsGuestRemoteDataSource {
  final ApiClient apiClient;

  UserEventsGuestRemoteDataSource({required this.apiClient});

  Future<List<CombinedEventModel>> fetchUserEventsGuest(String userId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchUserEventsGuest',
        params: {'userId': userId},
      );
      debugPrint("fetchUserEventsGuestのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? eventsData = result['data'] as List<dynamic>?;
      if (eventsData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をEventModelに変換
      final List<CombinedEventModel> events = eventsData.map((eventJson) {
        final Map<String, dynamic> eventMap = Map<String, dynamic>.from(eventJson as Map);
        return CombinedEventModel.fromJson(eventMap);
      }).toList();

      debugPrint('データ変換後: $events');
      return events;
    } catch (e) {
      debugPrint("fetchUserEventsGuestd エラー: $e");
      rethrow;
    }
  }

  Future<List<CombinedEventModel>> fetchUserEventsPerformer(String userId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchUserEventsPerformer',
        params: {'userId': userId},
      );
      debugPrint("fetchUserEventsPerformerのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? eventsData = result['data'] as List<dynamic>?;
      if (eventsData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をEventModelに変換
      final List<CombinedEventModel> events = eventsData.map((eventJson) {
        final Map<String, dynamic> eventMap = Map<String, dynamic>.from(eventJson as Map);
        return CombinedEventModel.fromJson(eventMap);
      }).toList();

      debugPrint('データ変換後: $events');
      return events;
    } catch (e) {
      debugPrint("fetchUserEventsPerformer エラー: $e");
      rethrow;
    }
  }
}
