import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/pages/landing_page.dart';
import './presentation/pages/permissions_request_page.dart';
import './presentation/providers/location_permission_provider.dart';
import './presentation/providers/auth_provider.dart';
import './presentation/widgets/event_detail_modal.dart';
import './presentation/providers/events_provider.dart';
import './presentation/providers/app_state_provider.dart';
import './presentation/widgets/bottom_navigation_widget.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  @override
  ConsumerState createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  bool _isProcessingDeepLink = false; // 処理中フラグを追加

  @override
  void initState() {
    super.initState();
    
    // アプリ起動時にディープリンクがあればチェック
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("RootPage initState: addPostFrameCallback で _checkForDeepLink を呼び出します。");
      _checkForDeepLink();
    });

    // eventId の変更監視
    ref.listenManual(deepLinkEventIdProvider, (previous, next) {
      debugPrint("deepLinkEventIdProvider が変更されました: $previous -> $next");
      if (next != null) {
        // アプリ起動中のディープリンク処理用
        // main.dart で eventId がセットされた時点で自動的に processed フラグを false に設定
        debugPrint("新しい eventId を検出。processed フラグを強制的に false に設定します。");
        ref.read(deepLinkProcessedProvider.notifier).state = false;
        _checkForDeepLink();
      }
    });
  }

  void _checkForDeepLink() {
    // 既に処理中の場合は二重処理を防止
    if (_isProcessingDeepLink) {
      debugPrint("別のディープリンク処理が実行中です。処理をスキップします。");
      return;
    }

    final eventId = ref.read(deepLinkEventIdProvider);
    final processed = ref.read(deepLinkProcessedProvider);

    debugPrint("_checkForDeepLink 呼び出し。eventId: $eventId, processed: $processed");

    if (eventId != null && !processed) {
      debugPrint("未処理のディープリンクイベントID: $eventId を検知。処理を開始します。");

      final isAuthenticated = ref.read(authProvider) != null;
      final hasPermissions = ref.read(locationPermissionProvider);

      if (isAuthenticated && hasPermissions) {
        debugPrint("認証済みかつ権限あり。イベント詳細表示処理を実行します。");
        
        // 処理中フラグをセット
        _isProcessingDeepLink = true;

        // processed フラグを先に設定して他の処理からの呼び出しを防止
        ref.read(deepLinkProcessedProvider.notifier).state = true;
        debugPrint("ディープリンク処理済みフラグを true に設定しました。");
        
        _showEventDetail(eventId);
      } else {
        debugPrint("未認証または権限なし。イベント詳細は表示しません。isAuthenticated: $isAuthenticated, hasPermissions: $hasPermissions");
      }
    } else {
      if (eventId == null) {
        debugPrint("_checkForDeepLink: eventId が null です。");
      }
      if (processed) {
        debugPrint("_checkForDeepLink: eventId ($eventId) は既に処理済みです。");
      }
    }
  }

  void _showEventDetail(String eventId) {
    debugPrint("_showEventDetail 呼び出し。eventId: $eventId");
    
    // 少し遅延させてイベント詳細モーダルを表示
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) {
        debugPrint("_showEventDetail: Widget is not mounted. Aborting modal display.");
        _isProcessingDeepLink = false; // 処理中フラグを解除
        return;
      }
      
      debugPrint("_showEventDetail: 遅延後、イベント($eventId)の詳細データを取得開始。");

      // キャッシュをクリアして確実に最新データを取得
      ref.invalidate(fetchEventByIdProvider(eventId));
      
      // watch ではなく read().when を使用して同期的に処理
      ref.read(fetchEventByIdProvider(eventId)).when(
        data: (event) {
          _isProcessingDeepLink = false; // 処理中フラグを解除
          
          debugPrint("イベント($eventId)の詳細データを取得成功。モーダルを表示します。");

          // モーダル表示前に少し遅延を入れる
          Future.microtask(() {
            if (mounted) {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => EventDetailModal(event: event),
              ).then((_) {
                debugPrint("イベント詳細モーダルが閉じられました。");
              });
            }
          });
        },
        loading: () {
          debugPrint("イベント($eventId)の詳細データを読み込み中です...");
          // ローディング中は少し待ってから再試行
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _showEventDetail(eventId); // 再帰呼び出しで再試行
            } else {
              _isProcessingDeepLink = false; // 処理中フラグを解除
            }
          });
        },
        error: (error, stackTrace) {
          _isProcessingDeepLink = false; // 処理中フラグを解除
          
          debugPrint("イベント($eventId)の詳細データ取得に失敗しました: $error");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('イベント情報の取得に失敗しました: $error'))
            );
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final hasLocationPermission = ref.watch(locationPermissionProvider);
    
    // ディープリンク関連のプロバイダーを監視
    final eventId = ref.watch(deepLinkEventIdProvider);
    final processed = ref.watch(deepLinkProcessedProvider);
    
    // デバッグ情報
    debugPrint("RootPage build: eventId=$eventId, processed=$processed");

    // authProviderの状態変更を監視
    ref.listen(authProvider, (previous, next) {
      debugPrint("authProvider が変更されました: $previous -> $next");
      if (next != null && ref.read(locationPermissionProvider)) {
        debugPrint("authProvider 変更: ログイン済みかつ権限あり。_checkForDeepLink を呼び出します。");
        _checkForDeepLink();
      }
    });

    // locationPermissionProviderの状態変更を監視
    ref.listen(locationPermissionProvider, (previous, next) {
      debugPrint("locationPermissionProvider が変更されました: $previous -> $next");
      if (next && ref.read(authProvider) != null) {
        debugPrint("locationPermissionProvider 変更: 権限ありかつログイン済み。_checkForDeepLink を呼び出します。");
        _checkForDeepLink();
      }
    });

    if (authState == null) {
      debugPrint("RootPage build: LandingPage を表示します (認証状態がnull)。");
      return const LandingPage();
    }

    if (hasLocationPermission) {
      debugPrint("RootPage build: FullMapPage を表示します (認証済み、位置情報権限あり)。");
      // FullMapPage が表示される直後（次のフレーム）でディープリンクをチェック
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint("RootPage build (FullMapPage表示時): addPostFrameCallback で _checkForDeepLink を呼び出します。");
        _checkForDeepLink();
      });
      return const BottomNavigationWidget();
    } else {
      debugPrint("RootPage build: PermissionsRequestPage を表示します (認証済み、位置情報権限なし)。");
      return const PermissionsRequestPage();
    }
  }
}