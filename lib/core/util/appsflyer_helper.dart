import 'dart:async';
import 'dart:convert';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/event_entity.dart';
import '../../core/util/date_time_utils.dart';

class AppsFlyerHelper {
  // シングルトンパターン
  static final AppsFlyerHelper _instance = AppsFlyerHelper._internal();
  factory AppsFlyerHelper() => _instance;
  AppsFlyerHelper._internal();

  // AppsFlyerのインスタンス
  late AppsflyerSdk _appsflyerSdk;

  // 環境変数からキーを取得
  final String _afDevKey = dotenv.env['APPSFLYER_DEV_KEY'] ?? '';
  final String _appId = dotenv.env['APPLE_APP_ID'] ?? ''; 

  // AppsFlyerのOneLink情報
  final String _oneLinkPrefix = '9pwp';

  // コールバック関数の型定義
  void Function(String?)? onEventIdExtracted;

  // AppsFlyerの初期化
  Future<void> init({void Function(String?)? eventIdCallback}) async {
    // コールバック関数を設定
    onEventIdExtracted = eventIdCallback;

    final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: _afDevKey,
      appId: _appId,
      showDebug: kDebugMode,
      timeToWaitForATTUserAuthorization: 30,
    );

    _appsflyerSdk = AppsflyerSdk(options);

    // インストール時のコンバージョンデータ処理
    _appsflyerSdk.onInstallConversionData((Map<String, dynamic> data) {
      debugPrint("onInstallConversionData: $data");
      // 必要に応じてインストール時のコンバージョンデータを処理
    });

    // ディープリンクのリスナー設定
    _appsflyerSdk.onDeepLinking((DeepLinkResult deepLinkResult) {
      debugPrint("onDeepLink status: ${deepLinkResult.status}");
      debugPrint("onDeepLink data: ${deepLinkResult.toString()}");

      if (deepLinkResult.status == Status.FOUND) {
        // DeepLinkから eventId を抽出
        debugPrint("ディープリンクあり");
        final String? eventId = extractEventIdFromDeepLinkResult(deepLinkResult);
        debugPrint("イベントID $eventId");
        
        // コールバック関数が設定されていれば呼び出す
        if (eventId != null && onEventIdExtracted != null) {
          onEventIdExtracted!(eventId);
        }
      }
    });

    // SDKの初期化
    await _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: false, // UDLを使用するため false に設定
      registerOnDeepLinkingCallback: true,
    );

    debugPrint("AppsFlyerSDK initialized");
  }

  // DeepLinkResultからeventIdを抽出するメソッド（シンプル化）
  String? extractEventIdFromDeepLinkResult(DeepLinkResult deepLinkResult) {
    try {
      // ログアウトプットからの確認：deep_link_valueプロパティが直接アクセス可能
      if (deepLinkResult.deepLink?.deepLinkValue != null) {
        final dynamic value = deepLinkResult.deepLink?.deepLinkValue;
        debugPrint("deepLinkValue: $value");
        return value?.toString();
      }
      
      // バックアップとして、JSONとしてパースできる場合はそこから抽出
      final String resultStr = deepLinkResult.toString();
      try {
        // JSON形式の文字列からエスケープシーケンスを処理
        final regexJson = RegExp(r'DeepLinkResult:(.*)', multiLine: true);
        final match = regexJson.firstMatch(resultStr);
        
        if (match != null && match.groupCount >= 1) {
          final String jsonStr = match.group(1) ?? "{}";
          final Map<String, dynamic> resultMap = jsonDecode(jsonStr) as Map<String, dynamic>;

          // deepLinkオブジェクトの確認
          if (resultMap.containsKey('deepLink') && resultMap['deepLink'] is Map) {
            final Map<String, dynamic> deepLink = resultMap['deepLink'] as Map<String, dynamic>;
            
            // deep_link_valueの確認
            if (deepLink.containsKey('deep_link_value')) {
              return deepLink['deep_link_value']?.toString();
            }
          }
        }
      } catch (e) {
        debugPrint("JSON parsing error: $e");
      }
      
      return null;
    } catch (e) {
      debugPrint("Error extracting eventId: $e");
      return null;
    }
  }

  Future<String> generateEventShareLink(EventEntity event) async {
    final Completer<String> completer = Completer<String>();
    await _appsflyerSdk.setAppInviteOneLinkID(_oneLinkPrefix, (dynamic res) {
      debugPrint("setAppInviteOneLinkID callback: $res");

      String doubleEncodeFirebaseUrl(String url) {
        return url.replaceAll('%2F', '%252F');
      }

      _appsflyerSdk.generateInviteLink(
        AppsFlyerInviteLinkParams(
          customParams: {
            "af_og_image": doubleEncodeFirebaseUrl(event.flyerPhotoUrl),
            "af_og_title": event.eventName,
            "af_og_description": formatDateTime(event.startDatetime),
            "deep_link_value": event.eventId,
            "af_force_deeplink": "true",
          }
        ),
        (Map<String, dynamic> result) async {
          debugPrint("Link generation result: $result");
          if (result['status'] == "success") {
            final url = result['payload']['userInviteURL'];
            debugPrint("生成されたURL: $url");
            if (!completer.isCompleted) {
              completer.complete(url as String);
            }
          } else {
            if (!completer.isCompleted) {
              completer.complete("");
            }
          }
        },
        (dynamic error) async {
          debugPrint("エラー: $error");
          if (!completer.isCompleted) {
            completer.complete("");
          }
        }
      );
    });
    return completer.future;
  }

  // カスタムイベントを送信するメソッド
  Future<bool?> logEvent(String eventName, Map<String, dynamic> eventValues) async {
    return await _appsflyerSdk.logEvent(eventName, eventValues);
  }
}