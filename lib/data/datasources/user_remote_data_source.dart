import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../models/user_model.dart';
import '../../domain/entities/profile_header_entity.dart';
import '../../domain/entities/user_entity.dart';

class UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSource({required this.apiClient});

  Future<UserModel> fetchCurrentUser() async {
    try {
      final result = await apiClient.call(
        apiName: 'getCurrentUser',
        params: {}, 
      );
      // userキー内のデータを取得
      final userData = result['user'];
      if (userData == null) {
        throw Exception("レスポンスに'user'キーが存在しません: $result");
      }
      // 明示的に型変換
      final Map<String, dynamic> userDataMap = Map<String, dynamic>.from(userData as Map);
      
      // UserModelに変換
      final userModel = UserModel.fromJson(userDataMap);
      return userModel;
    } catch (e) {
      debugPrint("fetchCurrentUser エラー: $e");
      rethrow;
    }
  }

  Future<UserModel> fetchUserProfile(String userId) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchUserProfile',
        params: {'userId': userId},
      );

      debugPrint("fetchUserProfileのレスポンス: $result");

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("ユーザープロファイル情報の取得に失敗しました: ${result['message']}");
      }

      // 'data'キー内のデータを取得
      final userData = result['data'];
      if (userData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }

      // 明示的に型変換
      final Map<String, dynamic> userDataMap = Map<String, dynamic>.from(userData as Map);

      // UserModelに変換
      final userModel = UserModel.fromJson(userDataMap);
      return userModel;
    } catch (e) {
      debugPrint("fetchUserProfile エラー: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfile(
    ProfileHeaderEntity input,
    ) async {
    try {
      final Map<String, dynamic> params = {
      'uid': input.uid,
      'username': input.username,
      'headsId': input.headsId,
      'bio': input.bio,
      'bioLink': input.bioLink,
      'profilePhotoUrl': input.profilePhotoUrl,
      'instagramId': input.instagramId,
      'xId': input.xId,
      'youtubeId': input.youtubeId,
      'soundcloudId': input.soundcloudId,
      'isPrivate': input.isPrivate,
    };

    debugPrint("updateUserProfile${params}");

    // APIを呼び出す
    final result = await apiClient.call(
      apiName: 'updateUserProfile',
      params: params,
    );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("アップデートに失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("updateUserProfile エラー: $e");
      rethrow;
    }
  }

  Future<bool> checkheadsIdExists(String inputId) async {
    try {
      final result = await apiClient.call(
        apiName: 'checkheadsIdExists',
        params: {'inputId': inputId},
      );
  
      debugPrint("checkheadsIdExistsのレスポンス: $result");
  
      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("headsIdの重複確認に失敗しました: ${result['message']}");
      }
  
      // 'data'キー内のデータを取得
      final exists = result['data'];
      if (exists == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }
  
      // boolean値として返す
      return exists as bool;
  
    } catch (e) {
      debugPrint("checkheadsIdExists エラー: $e");
      rethrow;
    }
  }

  Future<bool> checkEmailExists(String inputEmail) async {
    try {
      final result = await apiClient.call(
        apiName: 'checkEmailExists',
        params: {'inputEmail': inputEmail},
      );
  
      debugPrint("checkEmailExistsのレスポンス: $result");
  
      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("emailの重複確認に失敗しました: ${result['message']}");
      }
  
      // 'data'キー内のデータを取得
      final exists = result['data'];
      if (exists == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }
  
      // boolean値として返す
      return exists as bool;
  
    } catch (e) {
      debugPrint("checkEmailExists エラー: $e");
      rethrow;
    }
  }

  Future<LocationVisibilitySettingType> fetchLocationVisibilitySetting(
    String userId
  ) async {
    try {
      final result = await apiClient.call(
        apiName: 'fetchLocationVisibilitySetting',
        params: {'userId': userId},
      );
  
      debugPrint("fetchLocationVisibilitySettingのレスポンス: $result");
  
      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("ユーザープロファイル情報の取得に失敗しました: ${result['message']}");
      }
  
      // 'data'キー内のデータを取得
      final locationData = result['data'];
      if (locationData == null) {
        throw Exception("レスポンスに'data'キーが存在しません: $result");
      }
  
      // APIからの文字列値を取得
      String locationTypeStr;
      if (locationData is String) {
        locationTypeStr = locationData;
      } else if (locationData is Map<String, dynamic> && 
                 locationData.containsKey('locationVisibilitySetting')) {
        locationTypeStr = locationData['locationVisibilitySetting'] as String;
      } else {
        throw Exception("不正なデータ形式です: $locationData");
      }
  
      // 文字列からenumに変換
      return LocationVisibilitySettingTypeExtension.fromApiValue(locationTypeStr);
      
    } catch (e) {
      debugPrint("fetchLocationVisibilitySetting エラー: $e");
      rethrow;
    }
  }

  Future<void> updateLocationVisibilitySetting(
    LocationSettingParams input,
    ) async {
    try {
    // APIを呼び出す
    final result = await apiClient.call(
      apiName: 'updateLocationVisibilitySetting',
      params: {
        'userId': input.userId,
        'locationType': input.locationType.toApiValue(),
      },
    );
      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("アップデートに失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("updateLocationVisibilitySetting エラー: $e");
      rethrow;
    }
  }
}
