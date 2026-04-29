import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../../domain/entities/event_guest_entity.dart';
import '../models/event_guest_model.dart';


class EventGuestRemoteDataSource {
  final ApiClient apiClient;

  EventGuestRemoteDataSource({required this.apiClient});

  Future<void> registerEvenGuest(
    RegisterGuestInput input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'registerEventGuest',
        params: {
          'eventId': input.eventId,
          'userId': input.userId,
          'guestName': input.guestName,
          'targetArtistName': input.targetArtistName,
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("ゲスト登録に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("registerEventGuest エラー: $e");
      rethrow;
    }
  }

  Future<List<EventGuestModel>> fetchEventGuests(String eventId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchEventGuests',
        params: {'eventId': eventId},
      );
      debugPrint("fetchEventGuestsのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("ゲスト情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? guestsData = result['data'] as List<dynamic>?;
      if (guestsData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 各要素をModelに変換
      final List<EventGuestModel> guests = guestsData.map((guestJson) {
        final Map<String, dynamic> guestsMap = Map<String, dynamic>.from(guestJson as Map);
        return EventGuestModel.fromJson(guestsMap);
      }).toList();

      debugPrint('データ変換後: $guests');
      return guests;
    } catch (e) {
      debugPrint("fetchEventGuests エラー: $e");
      rethrow;
    }
  }

  Future<void> cancelRegisterGuest(
    String eventGuestId,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'cancelRegisterGuest',
        params: {
          'eventGuestId': eventGuestId,
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("ゲスト登録解除に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("cancelRegisterGuest エラー: $e");
      rethrow;
    }
  }
}
