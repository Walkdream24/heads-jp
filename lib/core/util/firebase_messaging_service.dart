import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/device_token_entity.dart';
import '../../presentation/providers/device_token_provider.dart';
import '../../presentation/providers/push_notification_state.dart';

final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>((ref) {
  return FirebaseMessagingService(ref);
});

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final Ref _ref;
  String? _userId;

  FirebaseMessagingService(this._ref);

  Future<void> initialize(String userId) async {
    try {
      _userId = userId;
      // 通知権限のリクエスト
      await _requestNotificationPermission();
      
      // 初期FCMトークンの登録
      await _registerToken();

      // トークン更新時の処理
      _messaging.onTokenRefresh.listen(_handleTokenRefresh);

      // フォアグラウンドでの通知設定
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // バックグラウンドからの復帰時
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      // アプリが完全に終了状態から起動された場合の通知処理
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _handleInitialMessage(initialMessage);
      }
    } catch (e) {
      debugPrint('FCMの初期化中にエラーが発生しました: $e');
    }
  }

  Future<void> _requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('プッシュ通知が許可されました');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('プロビジョナル通知が許可されました');
    } else {
      debugPrint('プッシュ通知が拒否されました');
    }
  }

  Future<void> _registerToken() async {
    if (_userId == null) return;
    
    final token = await _messaging.getToken();
    if (token != null) {
      await _ref.read(upsertDeviceTokenProvider(
        DeviceTokenInput(
          userId: _userId!,
          token: token,
        ),
      ).future);
      debugPrint('FCMトークンを登録しました: $token');
    }
  }

  Future<void> _handleTokenRefresh(String newToken) async {
    if (_userId == null) return;

    try {
      await _ref.read(upsertDeviceTokenProvider(
        DeviceTokenInput(
          userId: _userId!,
          token: newToken,
        ),
      ).future);
      debugPrint('FCMトークンを更新しました: $newToken');
    } catch (e) {
      debugPrint('トークン更新中にエラーが発生しました: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('フォアグラウンドで受信: ${message.notification?.title}');
    _incrementUnreadCount();
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    debugPrint('バックグラウンドから復帰: ${message.notification?.title}');
    _incrementUnreadCount();
  }

  void _handleInitialMessage(RemoteMessage message) {
    debugPrint('初期メッセージを処理: ${message.notification?.title}');
    _incrementUnreadCount();
  }

  void _incrementUnreadCount() {
    _ref.read(notificationProvider.notifier).incrementUnreadCount();
  }

}