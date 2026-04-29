import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../../domain/entities/memories_entity.dart';
import '../models/memories_model.dart';


class MemoriesRemoteDataSource {
  final ApiClient apiClient;

  MemoriesRemoteDataSource({required this.apiClient});

  Future<void> addMemory(
    MemoryEntity input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'addMemory',
        params: {
          'memoryId': input.memoryId,
          'userId': input.userId,
          'eventId': input.eventId,
          'photoUrl': input.photoUrl,
          'caption': input.caption,
          'isArchived': input.isArchived,
          //バックエンド側で登録、リクエスト段階ではnull送ってる...
          'createdAt': null,
          'updatedAt': null,
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("addMemory エラー: $e");
      rethrow;
    }
  }

  Future<List<MemoryModel>> fetchMemories(String userId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchMemories',
        params: {'userId': userId},
      );
      debugPrint("fetchMemoriesのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? memoriesData = result['data'] as List<dynamic>?;
      if (memoriesData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      final List<MemoryModel> memories = memoriesData.map((memoryJson) {
        final Map<String, dynamic> memoriesMap = Map<String, dynamic>.from(memoryJson as Map);
        return MemoryModel.fromJson(memoriesMap);
      }).toList();

      debugPrint('データ変換後: $memories');
      return memories;
    } catch (e) {
      debugPrint("fetchMemories エラー: $e");
      rethrow;
    }
  }

  Future<List<MemoryModel>> fetchEventMemories(String eventId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchEventMemories',
        params: {'eventId': eventId},
      );
      debugPrint("fetchEventMemoriesのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? memoriesData = result['data'] as List<dynamic>?;
      if (memoriesData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      final List<MemoryModel> memories = memoriesData.map((memoryJson) {
        final Map<String, dynamic> memoriesMap = Map<String, dynamic>.from(memoryJson as Map);
        return MemoryModel.fromJson(memoriesMap);
      }).toList();

      debugPrint('データ変換後: $memories');
      return memories;
    } catch (e) {
      debugPrint("fetchEventMemories エラー: $e");
      rethrow;
    }
  }

  Future<void> archiveMemory(
    MemoryEntity input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'archiveMemory',
        params: {
          'memoryId': input.memoryId,
          'userId': input.userId,
          'eventId': input.eventId,
          'photoUrl': input.photoUrl,
          'caption': input.caption,
          'isArchived': input.isArchived,
          'createdAt': null,
          'updatedAt': null,
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("archiveMemory エラー: $e");
      rethrow;
    }
  }

  Future<List<MemoryModel>> fetchHomeMemories() async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchHomeMemories',
        params: {},
      );
      debugPrint("fetchHomeMemoriesのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("イベント情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キーをリストとして取得
      final List<dynamic>? memoriesData = result['data'] as List<dynamic>?;
      if (memoriesData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      final List<MemoryModel> memories = memoriesData.map((memoryJson) {
        final Map<String, dynamic> memoriesMap = Map<String, dynamic>.from(memoryJson as Map);
        return MemoryModel.fromJson(memoriesMap);
      }).toList();

      debugPrint('データ変換後: $memories');
      return memories;
    } catch (e) {
      debugPrint("fetchHomeMemories エラー: $e");
      rethrow;
    }
  }
}
