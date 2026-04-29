import 'package:flutter/foundation.dart';
import 'package:HEADS/domain/entities/event_entity.dart';
import '../models/combined_event_model.dart';
import '../../core/api_client.dart';
import '../models/event_model.dart';
import '../../core/util/exceptions.dart';
import '../../domain/entities/user_locations_entity.dart';

class EventsRemoteDataSource {
  final ApiClient apiClient;

  EventsRemoteDataSource({required this.apiClient});

  Future<List<EventModel>> fetchEventsByClubId(String clubId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchEventsByClubId',
        params: {'clubId': clubId},
      );
      debugPrint("fetchEventsByClubIdのレスポンス: $result");

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
      final List<EventModel> events = eventsData.map((eventJson) {
        final Map<String, dynamic> eventMap = Map<String, dynamic>.from(eventJson as Map);
        return EventModel.fromJson(eventMap);
      }).toList();

      debugPrint('データ変換後: $events');
      return events;
    } catch (e) {
      debugPrint("fetchEventsByClubId エラー: $e");
      rethrow;
    }
  }

  Future<List<EventModel>> fetchEventsByUserId(String userId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchEventsByUserId',
        params: {'userId': userId},
      );
      debugPrint("fetchEventsByUserIdのレスポンス: $result");

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
      final List<EventModel> events = eventsData.map((eventJson) {
        final Map<String, dynamic> eventMap = Map<String, dynamic>.from(eventJson as Map);
        return EventModel.fromJson(eventMap);
      }).toList();

      debugPrint('データ変換後: $events');
      return events;
    } catch (e) {
      debugPrint("fetchEventsByUserId エラー: $e");
      rethrow;
    }
  }

  Future<EventModel> fetchEventById(String eventId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchEventById',
        params: {'eventId': eventId},
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }
      // 'data'キー内のデータを取得
      final eventData = result['data'];
      if (eventData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 明示的に型変換
      final Map<String, dynamic> eventDataMap = Map<String, dynamic>.from(eventData as Map);

      // Modelに変換
      final eventDataModel = EventModel.fromJson(eventDataMap);
      return eventDataModel;
    } catch (e) {
      debugPrint("fetchEventById エラー: $e");
      rethrow;
    }
  }

  Future<void> registerEvent(
    RegisterEventEntity input,
    ) async {
    try {
      final List<String>? genreStrings = input.genre?.map((genre) => genre.toApiValue()).toList();
      final result = await apiClient.call(
        apiName: 'registerEvent',
        params: {
          'eventId': input.eventId,
          'clubId': input.clubId,
          'eventName': input.eventName,
          'flyerPhotoUrl': input.flyerPhotoUrl,
          'description': input.description,
          'date': input.date,
          'startDatetime': input.startDatetime,
          'endDatetime': input.endDatetime,
          'entranceFee': input.entranceFee,
          'genre': genreStrings,
        },
      );

      if (result['duplicateFound'] == true) {  
        final List<dynamic>? eventsData = result['duplicateEvents'] as List<dynamic>?;
        if (eventsData != null && eventsData.isNotEmpty) {
          final List<EventModel> duplicateEvents = eventsData
            .map((eventJson) => EventModel.fromJson(Map<String, dynamic>.from(eventJson as Map)))
            .toList();
          throw EventRegistrationDataSourceException(
            success: false,
            message: (result['message'] as String?) ?? 'イベント登録に失敗しました',
            duplicateEvents: duplicateEvents,
          );
        }
      }

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント登録に失敗しました: ${result['message']}");
      }

    } catch (e) {
      debugPrint("registerEvent エラー: $e");
      rethrow;
    }
  }

  Future<List<CombinedEventModel>> fetchTodayEvents() async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchTodayEvents',
        params: {},
      );
      debugPrint("fetchTodayEventsのレスポンス: $result");

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
      debugPrint("fetchTodayEvents エラー: $e");
      rethrow;
    }
  }

  Future<List<CombinedEventModel>> fetchWeekEvents() async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchWeekEvents',
        params: {},
      );
      debugPrint("fetchWeekEventsのレスポンス: $result");

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
      debugPrint("fetchWeekEvents エラー: $e");
      rethrow;
    }
  }

  Future<List<CombinedEventModel>> fetchNearbyEvents(
    AddUserLocationInput input,
  ) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchNearbyEvents',
        params: {
          'currentLatitude': input.latitude,
          'currentLongitude': input.longitude,
        },
      );
      debugPrint("fetchNearbyEventsのレスポンス: $result");

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
      debugPrint("fetchNearbyEvents エラー: $e");
      rethrow;
    }
  }

  Future<List<CombinedEventModel>> fetchEventsByDate(String dateString) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchEventsByDate',
        params: {'dateString': dateString},
      );
      debugPrint("fetchEventsByDateのレスポンス: $result");

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
      debugPrint("fetchEventsByDate エラー: $e");
      rethrow;
    }
  }
}
