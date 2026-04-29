import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// AdMob テスト用ユニットID（AdMob公式）
const _kTestNativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';
const _kTestBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

class AdMobManager {
  static AdMobManager? _instance;

  AdMobManager._internal();

  static AdMobManager get instance => _instance ??= AdMobManager._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// AdMobの初期化
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('AdMob initialized successfully');
    } catch (e) {
      debugPrint('AdMob initialization failed: $e');
    }
  }

  /// ネイティブ広告ユニットID
  /// - デバッグ: AdMob公式テストID
  /// - 本番: .env の ADMOB_{PLATFORM}_NATIVE_AD_UNIT_ID
  String get nativeAdUnitId {
    if (kDebugMode) return _kTestNativeAdUnitId;
    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_ANDROID_NATIVE_AD_UNIT_ID'] ?? _kTestNativeAdUnitId;
    }
    if (Platform.isIOS) {
      return dotenv.env['ADMOB_IOS_NATIVE_AD_UNIT_ID'] ?? _kTestNativeAdUnitId;
    }
    return _kTestNativeAdUnitId;
  }

  /// バナー広告ユニットID
  /// - デバッグ: AdMob公式テストID
  /// - 本番: .env の ADMOB_{PLATFORM}_BANNER_AD_UNIT_ID
  String get bannerAdUnitId {
    if (kDebugMode) return _kTestBannerAdUnitId;
    if (Platform.isAndroid) {
      return dotenv.env['ADMOB_ANDROID_BANNER_AD_UNIT_ID'] ?? _kTestBannerAdUnitId;
    }
    if (Platform.isIOS) {
      return dotenv.env['ADMOB_IOS_BANNER_AD_UNIT_ID'] ?? _kTestBannerAdUnitId;
    }
    return _kTestBannerAdUnitId;
  }

  AdRequest createAdRequest() => const AdRequest();
}
