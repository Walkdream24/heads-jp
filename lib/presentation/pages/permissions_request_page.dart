import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/location_permission_provider.dart';
import '../widgets/gradient_button.dart';

class PermissionsRequestPage extends ConsumerStatefulWidget {
  const PermissionsRequestPage({super.key});

  @override
  ConsumerState<PermissionsRequestPage> createState() => _PermissionsRequestPageState();
}

class _PermissionsRequestPageState extends ConsumerState<PermissionsRequestPage> with WidgetsBindingObserver {
  bool _isLoading = true;
  bool _isPermanentlyDenied = false;
  bool _isLocationServiceDisabled = false;
  bool _shouldShowCustomUI = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 画面が描画された後に権限確認を行う
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestPermission();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndRequestPermission();
    }
  }

  Future<void> _checkAndRequestPermission() async {
    setState(() {
      _isLoading = true;
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return;
    if (!serviceEnabled) {
      setState(() {
        _isLocationServiceDisabled = true;
        _shouldShowCustomUI = true;
        _isLoading = false;
      });
      return;
    }

    final permission = await Geolocator.checkPermission();
    if (!mounted) return;

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      await ref.read(locationPermissionProvider.notifier).checkAndUpdatePermissionStatus();
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    } else if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isPermanentlyDenied = true;
        _shouldShowCustomUI = true;
        _isLoading = false;
      });
      return;
    }

    try {
      final requested = await Geolocator.requestPermission();
      if (!mounted) return;

      if (requested == LocationPermission.always || requested == LocationPermission.whileInUse) {
        await ref.read(locationPermissionProvider.notifier).checkAndUpdatePermissionStatus();
        return;
      } else if (requested == LocationPermission.denied) {
        setState(() => _shouldShowCustomUI = true);
      } else if (requested == LocationPermission.deniedForever) {
        setState(() {
          _isPermanentlyDenied = true;
          _shouldShowCustomUI = true;
        });
      }
    } catch (e) {
      debugPrint('権限リクエストエラー: $e');
      if (!mounted) return;
      setState(() => _shouldShowCustomUI = true);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _requestPermission() async {
    setState(() => _isLoading = true);

    try {
      final permission = await Geolocator.requestPermission();
      if (!mounted) return;

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        await ref.read(locationPermissionProvider.notifier).checkAndUpdatePermissionStatus();
        return;
      } else if (permission == LocationPermission.deniedForever) {
        setState(() => _isPermanentlyDenied = true);
      }
    } catch (e) {
      debugPrint('権限リクエストエラー: $e');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _openSettings() => Geolocator.openAppSettings();

  Future<void> _openLocationSettings() => Geolocator.openLocationSettings();

  void _denyPermission() {
    setState(() => _isPermanentlyDenied = true);
  }

  @override
  Widget build(BuildContext context) {
    // locationPermissionProviderの状態変化を監視する
    ref.listen(locationPermissionProvider, (previous, current) {
      // 権限状態が変わった場合（falseからtrueになった場合）
      if (previous == false && current == true) {
        // 何もしない - RootPageで自動的に処理される
      }
    });

    if (!_shouldShowCustomUI && !_isLoading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/dummyMapImg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.7),
          ),
          Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : _buildPermissionCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(16),
      ),
      child:  Padding( 
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 位置情報アイコンとタイトル部分
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '位置情報設定',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // タイトルと説明文の間のスペース
            // 説明文
            const Text(
              '位置情報が拒否されています。設定から許可してください。周辺のクラブ情報を表示するために位置情報の許可が必要です',
              // _isLocationServiceDisabled
              //     ? '位置情報サービスが無効です。設定から有効にしてください。'
              //     : _isPermanentlyDenied
              //         ? '位置情報が拒否されています。設定から許可してください。周辺のクラブ情報を表示するために位置情報の許可が必要です'
              //         : '周辺のクラブ情報を表示するために位置情報の許可が必要です',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20), // 説明文とボタンの間のスペース
            // ボタン
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                onPressed: _isLocationServiceDisabled
                    ? _openLocationSettings
                    : _isPermanentlyDenied
                        ? _openSettings
                        : _requestPermission,
                text: _isLocationServiceDisabled
                    ? '位置情報設定を開く'
                    : _isPermanentlyDenied
                        ? '設定を開く'
                        : '許可する',
                height: 45,
                borderRadius: 25,
              ),
            ),
            if (!_isPermanentlyDenied && !_isLocationServiceDisabled) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _denyPermission,
                  child: const Text(
                    '拒否する',
                    style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}