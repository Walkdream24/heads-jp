// lib/services/firebase_messaging_service.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  Future<void> initialize() async {
    // 通知権限のリクエスト
    await requestNotificationPermission();
    
    // FCMトークンの取得
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token'); // 実際のアプリではトークンを保存・管理する必要があります
    
    // Android用の通知チャンネル設定
    if (Platform.isAndroid) {
      await setupNotificationChannel();
    }
    
    // バックグラウンド・フォアグラウンドでの通知ハンドリング設定
    setupNotificationHandlers();
  }

  Future<void> requestNotificationPermission() async {
    if (Platform.isIOS) {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      // Android 13以上の場合
      if (await _isAndroid13OrHigher()) {
        await Permission.notification.request();
      }
    }
  }

  Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 33;
    }
    return false;
  }

  Future<void> setupNotificationChannel() async {
   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
   
   // 初期化設定
   const initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_notification');
   const initializationSettingsIOS = DarwinInitializationSettings();
   const initializationSettings = InitializationSettings(
     android: initializationSettingsAndroid,
     iOS: initializationSettingsIOS,
   );
   
   await flutterLocalNotificationsPlugin.initialize(
     initializationSettings,
     onDidReceiveNotificationResponse: (NotificationResponse response) {
       // 通知がタップされた時の処理
       debugPrint('Notification clicked: ${response.payload}');
     },
   );

   // 通知チャンネルの作成
   const androidNotificationChannel = AndroidNotificationChannel(
     'high_importance_channel',
     'Important Notifications',
     description: 'This channel is used for important notifications.',
     importance: Importance.high,
   );

   await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
  }

  void setupNotificationHandlers() {
    // フォアグラウンドでメッセージを受信したときの処理
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      // 通知の処理
    });

    // バックグラウンドからアプリを開いたときの処理
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from background notification');
      // 通知タップ時の処理
    });
  }
}