import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../../domain/entities/follows_entity.dart';
import '../models/follow_check_result_model.dart';
import '../models/user_summary_model.dart';

class FollowsRemoteDataSource {
  final ApiClient apiClient;

  FollowsRemoteDataSource({required this.apiClient});

  Future<FollowCheckResultModel> checkFollowStatus(FollowsInput input) async {
    try {
      final result = await apiClient.call(
        apiName: 'checkFollowStatus',
        params: {
          'followerId': input.userId,
          'followedId': input.targetUserId
        },
      );

      debugPrint("checkFollowStatusのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("checkFollowStatus情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キー内のデータを取得
      final followStatusData = result['data'];
      if (followStatusData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 明示的に型変換
      final Map<String, dynamic> followStatusDataMap = Map<String, dynamic>.from(followStatusData as Map);

      // Modelに変換
      final followStatusModel = FollowCheckResultModel.fromJson(followStatusDataMap);
      return followStatusModel;
    } catch (e) {
      debugPrint("checkFollowStatus エラー: $e");
      rethrow;
    }
  }

  Future<void> followRequest(
    FollowsInput input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'followRequest',
        params: {
          'followerId': input.userId,
          'followedId': input.targetUserId
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("フォローに失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("followRequest エラー: $e");
      rethrow;
    }
  }

  Future<void> followReturn(
    FollowsInput input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'followReturn',
        params: {
          'followerId': input.userId,
          'followedId': input.targetUserId
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("フォローに失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("followReturn エラー: $e");
      rethrow;
    }
  }

  Future<void> unFollowUser(
    FollowsInput input,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'unFollowUser',
        params: {
          'followerId': input.userId,
          'followedId': input.targetUserId
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("アンフォローに失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("unFollowUser エラー: $e");
      rethrow;
    }
  }

  Future<List<UserSummaryModel>> fetchRequestFollows(
    String userId
  ) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchRequestFollows',
        params: {'userId': userId},
      );

      debugPrint("fetchRequestFollowsのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("fetchRequestFollows情報の取得に失敗しました: ${result['message']}");
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

      return users;

    } catch (e) {
      debugPrint("fetchRequestFollows エラー: $e");
      rethrow;
    }
  }

  Future<List<UserSummaryModel>> fetchCommonFollowers(
    FollowsInput input
  ) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchCommonFollowers',
        params: {
          'followerId': input.userId,
          'followedId': input.targetUserId
        },
      );

      debugPrint("fetchCommonFollowersのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("fetchCommonFollowers情報の取得に失敗しました: ${result['message']}");
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

      return users;

    } catch (e) {
      debugPrint("fetchCommonFollowers エラー: $e");
      rethrow;
    }
  }

  Future<List<UserSummaryModel>> fetchFollowerList(
    String userId
  ) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchFollowerList',
        params: {'userId': userId},
      );

      debugPrint("fetchFollowerListのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("fetchFollowerList情報の取得に失敗しました: ${result['message']}");
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

      return users;

    } catch (e) {
      debugPrint("fetchFollowerList エラー: $e");
      rethrow;
    }
  }

  Future<List<UserSummaryModel>> fetchFollowingList(
    String userId
  ) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchFollowingList',
        params: {'userId': userId},
      );

      debugPrint("fetchFollowingListのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("fetchFollowingList情報の取得に失敗しました: ${result['message']}");
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

      return users;

    } catch (e) {
      debugPrint("fetchFollowingList エラー: $e");
      rethrow;
    }
  }
}

