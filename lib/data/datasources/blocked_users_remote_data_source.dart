import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../../domain/entities/blocked_users_entity.dart';

class BlockedUsersRemoteDataSource {
  final ApiClient apiClient;

  BlockedUsersRemoteDataSource({required this.apiClient});

  Future<BlockRelationshipType> getBlockRelationship(BlockedUsersInput input) async {
    try {
      final result = await apiClient.call(
        apiName: 'getBlockRelationship',
        params: {
          'userId': input.userId,
          'targetUserId': input.targetUserId
        },
      );
  
      debugPrint("getBlockRelationshipのレスポンス: $result");
  
      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("ブロック関係情報の取得に失敗しました: ${result['message']}");
      }
  
      // 'data'キー内のデータを取得
      final blockData = result['data'];
      if (blockData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }
      return BlockRelationshipTypeExtension.fromApiValue(blockData as String);
    } catch (e) {
      debugPrint("getBlockRelationship エラー: $e");
      rethrow;
    }
  }  

  Future<void> addBlockedUser(
    BlockedUsersParams input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'addBlockedUser',
        params: {
          'blockerId': input.blockerId,
          'blockedId': input.blockedId
        },
      );
      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("ブロックに失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("addBlockedUser エラー: $e");
      rethrow;
    }
  }

  Future<void> deleteBlcokedUser(
    BlockedUsersParams input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'deleteBlcokedUser',
        params: {
          'blockerId': input.blockerId,
          'blockedId': input.blockedId
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("ブロック解除に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("deleteBlcokedUser エラー: $e");
      rethrow;
    }
  }
}

