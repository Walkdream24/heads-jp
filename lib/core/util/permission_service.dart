// lib/core/util/permission_service.dart
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // 位置情報の権限をリクエストし、結果を返す
  static Future<bool> requestLocationPermission() async {
    debugPrint("PermissionService: 位置情報の権限をリクエスト中");
    
    // 現在の権限状態をチェック
    PermissionStatus status = await Permission.location.status;
    
    // すでに許可されている場合
    if (status.isGranted) {
      debugPrint("PermissionService: 既に許可されています");
      return true;
    }
    
    // 権限リクエスト - ユーザーの選択を待つ
    status = await Permission.location.request();
    debugPrint("PermissionService: リクエスト完了、結果: $status");
    
    // 結果を返す
    return status.isGranted;
  }
  
  // アプリ設定画面を開く
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }
}