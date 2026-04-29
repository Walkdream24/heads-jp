import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../../domain/entities/bookmark_clubs_entity.dart';


class BookmarkClubsRemoteDataSource {
  final ApiClient apiClient;

  BookmarkClubsRemoteDataSource({required this.apiClient});

  Future<void> addBookmarkClubs(
    BookmarkClubsByIds input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'addBookmarkClubs',
        params: {
          'userId': input.userId,
          'clubId': input.clubId,
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("デバイストークン登録に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("addBookmarkClubs エラー: $e");
      rethrow;
    }
  }

  Future<void> deleteBookmarkClubs(
    BookmarkClubsByIds input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'deleteBookmarkClubs',
        params: {
          'userId': input.userId,
          'clubId': input.clubId,
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("デバイストークン登録に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("deleteBookmarkClubs エラー: $e");
      rethrow;
    }
  }

  Future<bool> checkBookMarkClub(BookmarkClubsByIds input) async {
    try {
      final result = await apiClient.call(
        apiName: 'checkBookMarkClub',
        params: {
          'userId': input.userId,
          'clubId': input.clubId,
        },
      );
  
        // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("bookmarkの確認に失敗しました: ${result['message']}");
      }
  
      // 'data'キー内のデータを取得
      final exists = result['data'];
      if (exists == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }
  
      // boolean値として返す
      return exists as bool;
  
    } catch (e) {
      debugPrint("checkBookMarkClub エラー: $e");
      rethrow;
    }
  }
}
