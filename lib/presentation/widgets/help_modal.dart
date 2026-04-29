import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/util/error_helper.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import 'custom_snackbar.dart';

class HelpModal extends ConsumerWidget {
  const HelpModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isClosing = false;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent < 0.2 && !isClosing) {
          isClosing = true;
          if (context.mounted) {
            Navigator.of(context).maybePop();
          }
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [1.0],
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // ドラッグハンドル
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildLogoutButton(context, ref),
                        _buildDeleteAccountButton(context, ref),
                        const SizedBox(height: 100), // Add some padding at the bottom
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () async {
          try {
            // すべての画面をポップしてルート画面に戻る
            Navigator.of(context).popUntil((route) => route.isFirst);
            
            // ログアウト処理
            final authNotifier = ref.read(authProvider.notifier);
            await authNotifier.logout();
            
            // ユーザー情報もクリア
            ref.invalidate(currentUserProvider);
            
            // 注意: ここでのナビゲーション操作は不要。authProviderの変更を
            // RootPageが検知して自動的にLandingPageに切り替える
          } catch (error) {
            CustomSnackBar.show(
              context: context,
              message: getLocalizedErrorMessage(error),
              isSuccess: false,
            );
          }
        },
        child: const Row(
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 16),
            Text(
              "ログアウト",
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // 退会ボタンのウィジェット
  Widget _buildDeleteAccountButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GestureDetector(
        onTap: () {
          _showDeleteAccountConfirmDialog(context, ref);
        },
        child: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.white),
            SizedBox(width: 16),
            Text(
              "アカウントを削除する",
              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // 退会確認ダイアログ
  void _showDeleteAccountConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('アカウント削除の確認'),
          content: const Text('アカウントを削除します。削除したアカウントは復旧できません。よろしいですか？'),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('はい'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // ダイアログを閉じる
                
                // アカウント削除処理
                await _deleteUserAccount(context, ref);
              },
            ),
          ],
        );
      },
    );
  }

  // アカウント削除処理
  Future<void> _deleteUserAccount(BuildContext context, WidgetRef ref) async {
    try {
      // 現在のユーザーIDを取得
      final currentUser = ref.watch(authProvider);
      if (currentUser == null || currentUser.id.isEmpty) {
        throw Exception('ユーザー情報が見つかりません');
      }
      
      // ローディングダイアログを表示
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('アカウントを削除しています...'),
              ],
            ),
          );
        },
      );
      
      // アカウント削除処理を実行
      await ref.read(deleteUserAccountProvider(currentUser.id).future);
      
      // ローディングダイアログを閉じる
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      // 成功メッセージを表示
      if (context.mounted) {
        CustomSnackBar.show(
          context: context,
          message: 'アカウントが削除されました',
          isSuccess: true,
        );
      }
      // ログアウト処理 - authProvider状態をリセット
      ref.read(authProvider.notifier).logout();
      
      // ユーザー情報もクリア
      ref.invalidate(currentUserProvider);
      
      // すべての画面をポップしてルート画面に戻る
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
      
    } catch (error) {
      // エラーが発生した場合はローディングダイアログを閉じる
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      // エラーメッセージを表示
      if (context.mounted) {
        CustomSnackBar.show(
          context: context,
          message: getLocalizedErrorMessage(error),
          isSuccess: false,
        );
      }
    }
  }
}