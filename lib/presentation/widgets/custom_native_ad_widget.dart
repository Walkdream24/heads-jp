import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/util/admob_manager.dart';

class CustomNativeAdWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const CustomNativeAdWidget({
    Key? key,
    this.width,
    this.height,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<CustomNativeAdWidget> createState() => _CustomNativeAdWidgetState();
}

class _CustomNativeAdWidgetState extends State<CustomNativeAdWidget> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  // AdMobManagerから広告ユニットIDを取得
  String get _adUnitId => AdMobManager.instance.nativeAdUnitId;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    // AdMobが初期化されているかチェック
    if (!AdMobManager.instance.isInitialized) {
      debugPrint('AdMob is not initialized yet');
      return;
    }

    _nativeAd = NativeAd(
      adUnitId: _adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('$NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
      request: AdMobManager.instance.createAdRequest(),
      // smallテンプレートを使用して正方形に近い広告を表示
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: widget.backgroundColor ?? Colors.white,
        cornerRadius: widget.borderRadius?.topLeft.x ?? 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.blue,
          style: NativeTemplateFontStyle.monospace,
          size: 14.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black87,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.bold,
          size: 14.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black54,
          backgroundColor: Colors.transparent,  
          style: NativeTemplateFontStyle.italic,
          size: 12.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black45,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 10.0,
        ),
      ),
    );
    _nativeAd!.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center( // 中央配置のためにCenterでラップ
      child: Container(
        width: widget.width ?? 300, // MediaViewの最小サイズを考慮してサイズを大きく
        height: widget.height ?? 300, // MediaViewの最小サイズを考慮してサイズを大きく
        // margin: widget.margin ?? const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.grey[100],
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _nativeAdIsLoaded && _nativeAd != null
            ? ClipRRect(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
                child: AdWidget(ad: _nativeAd!),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}


// バナー広告ウィジェット
class CustomBannerAdWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final AdSize adSize;

  const CustomBannerAdWidget({
    Key? key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.adSize = AdSize.banner, // デフォルトはbanner (320x50)
  }) : super(key: key);

  @override
  State<CustomBannerAdWidget> createState() => _CustomBannerAdWidgetState();
}

class _CustomBannerAdWidgetState extends State<CustomBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  final String _adUnitId = AdMobManager.instance.bannerAdUnitId;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    // AdMobが初期化されているかチェック
    if (!AdMobManager.instance.isInitialized) {
      debugPrint('AdMob is not initialized yet');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: widget.adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded.');
          setState(() {
            _bannerAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (ad) {
          debugPrint('Banner ad opened.');
        },
        onAdClosed: (ad) {
          debugPrint('Banner ad closed.');
        },
      ),
      request: AdMobManager.instance.createAdRequest(),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? widget.adSize.width.toDouble(),
      height: widget.height ?? widget.adSize.height.toDouble(),
      padding: widget.padding,
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 16.0),
      decoration: widget.decoration ??
          BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
      child: _bannerAdIsLoaded && _bannerAd != null
          ? Center(
              child: SizedBox(
                width: widget.adSize.width.toDouble(),
                height: widget.adSize.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            )
          : Container(
              color: Colors.grey[200],
              child: const Center(
                child: Text(
                  '広告を読み込み中...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
    );
  }
}