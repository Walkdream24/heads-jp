import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../../domain/entities/event_performer_entity.dart';
import '../models/event_performers.dart';


class EventPerformersRemoteDataSource {
  final ApiClient apiClient;

  EventPerformersRemoteDataSource({required this.apiClient});

  Future<void> registerEventPerformer(
    RegisterPerfomerInput input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'registerEventPerformer',
        params: {
          'eventId': input.eventId,
          'userId': input.userId,
          'role': input.role.toApiValue(),
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("registerEventPerformer エラー: $e");
      rethrow;
    }
  }

  Future<List<EventPerformersModel>> fetchEventPerformers(String eventId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchEventPerformers',
        params: {'eventId': eventId},
      );
      debugPrint("fetchEventPerformersのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? performersData = result['data'] as List<dynamic>?;
      if (performersData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をEventModelに変換
      final List<EventPerformersModel> performers = performersData.map((performerJson) {
        final Map<String, dynamic> performersMap = Map<String, dynamic>.from(performerJson as Map);
        return EventPerformersModel.fromJson(performersMap);
      }).toList();

      debugPrint('データ変換後: $performers');
      return performers;
    } catch (e) {
      debugPrint("fetchEventPerformers エラー: $e");
      rethrow;
    }
  }

  Future<void> cancelRegisterPerformer(
    String eventPerformerId,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'cancelRegisterPerformer',
        params: {
          'eventPerformerId': eventPerformerId,
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("パフォーマー登録解除に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("cancelRegisterPerformer エラー: $e");
      rethrow;
    }
  }
}
