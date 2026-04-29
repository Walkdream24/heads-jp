import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 位置情報の権限状態を監視するプロバイダ
final locationPermissionProvider = StateNotifierProvider<LocationPermissionNotifier, bool>((ref) {
  return LocationPermissionNotifier();
});

class LocationPermissionNotifier extends StateNotifier<bool> {
  // 初期状態は権限なし（false）
  LocationPermissionNotifier() : super(false) {
    // 初期化時に権限状態を確認
    _initPermissionStatus();
  }

  // SharedPreferences のキー
  static const String _permissionKey = 'location_permission_granted';

  // 初期化処理
  Future<void> _initPermissionStatus() async {
    await checkAndUpdatePermissionStatus();
  }

  // 権限状態を確認して更新
  Future<bool> checkAndUpdatePermissionStatus() async {
  // 位置情報サービスが有効かどうかを確認
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  debugPrint("Location service enabled: $serviceEnabled");
  
  if (!serviceEnabled) {
    debugPrint("Setting locationPermission state to false (service disabled)");
    state = false;
    return false;
  }

  // 位置情報の権限状態を確認
  LocationPermission permission = await Geolocator.checkPermission();
  debugPrint("Location permission status: $permission");
  
  final prefs = await SharedPreferences.getInstance();
  
  if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
    // 権限が許可されている場合
    debugPrint("Setting locationPermission state to true (permission granted)");
    await prefs.setBool(_permissionKey, true);
    state = true;
    return true;
  } else {
    // 権限が許可されていない場合
    debugPrint("Setting locationPermission state to false (permission denied)");
    await prefs.setBool(_permissionKey, false);
    state = false;
    return false;
  }
}

  // 権限リクエスト処理
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      // 権限が許可された場合
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_permissionKey, true);
      state = true;
      return true;
    }
    
    // 権限が拒否された場合
    state = false;
    return false;
  }

  // 権限状態をリセット（テスト用）
  Future<void> resetPermission() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionKey, false);
    state = false;
  }
}