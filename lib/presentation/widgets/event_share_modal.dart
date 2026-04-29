import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/util/appsflyer_helper.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/event_share_story.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/share_to_instagram_stories.dart';

class EventShareModal extends StatefulWidget {
  final EventEntity event;

  const EventShareModal({
    super.key,
    required this.event,
  });

  @override
  State<EventShareModal> createState() => _EventShareModalState();
}

class _EventShareModalState extends State<EventShareModal> {
  bool _isSharing = false;

  /// クリップボードにディープリンクをコピー
void _copyToClipboard(BuildContext context) async {
  if (_isSharing) return;
  
  setState(() {
    _isSharing = true;
  });
  
  try {
    // AppsFlyerを使用してシェア用のディープリンクを生成
    final appsFlyerHelper = AppsFlyerHelper();
    final String deepLinkUrl = await appsFlyerHelper.generateEventShareLink(widget.event);
    
    // リンクが生成できたかチェック
    if (deepLinkUrl.isNotEmpty) {
      // クリップボードに設定
      await Clipboard.setData(ClipboardData(text: deepLinkUrl));
      
      // 完了メッセージを表示
      CustomSnackBar.show(
        context: context,
        message: 'リンクをコピーしました',
        isSuccess: true,
      );
    } else {
      // リンク生成失敗時のエラーメッセージ
      CustomSnackBar.show(
        context: context,
        message: 'リンクの生成に失敗しました',
        isSuccess: false,
      );
    }
  } catch (e) {
    debugPrint("シェアリンク生成エラー: $e");
    // エラーメッセージ表示
    CustomSnackBar.show(
      context: context,
      message: 'リンクの生成に失敗しました',
      isSuccess: false,
    );
  } finally {
    setState(() {
      _isSharing = false;
    });
    
    // モーダルを閉じる
    Navigator.pop(context);
  }
}

  /// インスタグラムストーリーに共有
  void _shareToInstagramStories(BuildContext modalContext) async {
    // 多重実行防止
    if (_isSharing) return;
    setState(() {
      _isSharing = true;
    });

    // ダイアログ表示用のコンテキスト
    BuildContext? dialogContext;

    try {
      // AppsFlyerを使用してシェア用のディープリンクを生成
      final appsFlyerHelper = AppsFlyerHelper();
      final String deepLinkUrl = await appsFlyerHelper.generateEventShareLink(widget.event);

      // ローディングダイアログを表示
      showDialog<void>(
        context: modalContext,
        barrierDismissible: false,
        builder: (BuildContext dCtx) {
          dialogContext = dCtx;
          return const Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('ストーリー画像を準備中...'),
                ],
              ),
            ),
          );
        },
      );

      // ストーリー用の画像を生成
      final shareHelper = EventShareStory(
        event: widget.event,
        deepLinkUrl: deepLinkUrl,
      );

      // この時点で既にローディングダイアログが表示されているので、
      // captureImageメソッドには直接modalContextを渡す
      final imagePath = await shareHelper.captureImage(modalContext);

      // ローディングダイアログがまだ表示されていれば閉じる
      if (dialogContext != null && Navigator.of(dialogContext!).canPop()) {
        Navigator.of(dialogContext!).pop();
      }
      dialogContext = null; // コンテキストをクリア

      // モーダルを閉じる（Instagramに遷移する前に）
      if (modalContext.mounted) {
        Navigator.pop(modalContext);
      }

      // 少し待ってからInstagramに共有（UIの更新を確実にするため）
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Instagramに共有
      final shareToInstagramStories = ShareToInstagramStoriesUseCase();
      await shareToInstagramStories.share(
        backgroundImagePath: imagePath,
        webUrl: deepLinkUrl,
      );

    } catch (e, stackTrace) {
      debugPrint('インスタグラムストーリーズ共有エラー: $e');
      debugPrintStack(label: 'ShareToInstagramStoriesUseCase Error StackTrace', stackTrace: stackTrace);

      // エラー時にローディングダイアログを閉じる
      if (dialogContext != null && Navigator.of(dialogContext!).canPop()) {
        Navigator.of(dialogContext!).pop();
      }

      // エラーメッセージを表示
      if (mounted && modalContext.mounted) {
        CustomSnackBar.show(
          context: modalContext,
          message: 'ストーリーの共有に失敗しました',
          isSuccess: false,
        );
      }
    } finally {
      // 共有処理のステータスをリセット
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ハンドル部分
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20.0),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          // シェアボタンのコンテナ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // リンクコピーボタン
                _buildShareButton(
                  context: context,
                  icon: Icons.copy,
                  label: 'Copy link',
                  onTap: () => _copyToClipboard(context),
                ),
                const SizedBox(width: 24.0),
                // Instagramストーリーズボタン
                _buildShareButton(
                  context: context,
                  label: 'Stories',
                  onTap: _isSharing ? null : () => _shareToInstagramStories(context),
                  isInstagram: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }

  /// シェアボタンのウィジェットを構築
  Widget _buildShareButton({
    required BuildContext context,
    IconData? icon,
    required String label,
    required VoidCallback? onTap,
    bool isInstagram = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // アイコン部分
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isInstagram ? null : Colors.grey[800],
              gradient: isInstagram
                  ? const LinearGradient(
                      colors: [
                        Color(0xFFFAE14B),
                        Color(0xFFFF5F66),
                        Color(0xFFCD41FF),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    )
                  : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isInstagram
                  ? SvgPicture.asset(
                      'assets/instagram_logo.svg',
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
            ),
          ),
          // ラベル部分
          const SizedBox(height: 8.0),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}