import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_snackbar.dart';
import '../../core/util/shared_dialogs.dart'; 
import '../widgets/location_settings_modal.dart';
import '../widgets/bookmark_clubs_list_modal.dart';
import '../widgets/event_add_banner.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/help_modal.dart';
import '../pages/event_register_page.dart';

class SettingsModal extends ConsumerWidget {
  const SettingsModal({super.key});

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
        maxChildSize: 0.8,
        snap: true,
        snapSizes: const [0.8],
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
                  // 招待カード - 画像に置き換え
                  const EventAddBanner(
                    showCloseButton: false
                  ),
                  const SizedBox(height: 30),
                  // 設定オプションリスト
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildSettingsItem(
                          context,
                          Icons.add_circle_outline,
                          "イベント追加",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(builder: (context) => const EventRegisterPage()),
                            );
                          },
                        ),
                        _buildSettingsItem(
                          context,
                          Icons.favorite,
                          "お気に入りしたクラブ",
                          () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const BookmarkClubsModal(),
                            );
                          },
                        ),
                        _buildSettingsItem(
                          context,
                          Icons.place,
                          "位置情報設定",
                          () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const LocationSettingsModal(),
                            );
                          },
                        ),
                        _buildSettingsItem(
                          context,
                          Icons.privacy_tip,
                          "プライバシー設定",
                          () {
                            SharedDialogs.showComingSoon(context);
                          },
                        ),
                        _buildSettingsItem(
                          context,
                          Icons.help,
                          "HEADSについて",
                          () {
                            launchWebUrl(context, 'https://headsapp.jp/');
                          },
                        ),
                        _buildSettingsItem(
                          context,
                          Icons.question_answer,
                          "よくある質問",
                          () {
                            launchWebUrl(context, 'https://headsapp.jp/%e3%82%88%e3%81%8f%e3%81%82%e3%82%8b%e8%b3%aa%e5%95%8f/');
                          },
                        ),
                        _buildSettingsItem(
                          context,
                          Icons.mail,
                          "ヘルプが必要ですか？",
                          () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const HelpModal(),
                            );
                          },
                        ),
                        _buildSettingsItem(
                          context,
                          Icons.lightbulb,
                          "ご意見箱",
                          () {
                            launchWebUrl(context, 'https://docs.google.com/forms/d/e/1FAIpQLScrwNO_Z7iWnHwiPARQ3umoWB__RqGugP6PuqGsOdgfFSoJbw/viewform?usp=header');
                          },
                        ),
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

  void launchWebUrl(BuildContext context, String url) async {
    final Uri parsedUrl = Uri.parse(url);
    try {
      if (await canLaunchUrl(parsedUrl)) {
        await launchUrl(parsedUrl, mode: LaunchMode.externalApplication);
      } else {
        // URLを開けない場合のエラーハンドリング
        CustomSnackBar.show(
          context: context,
          message: 'URLを開くことができませんでした',
          isSuccess: false,
        );
      }
    } catch (e) {
      // 例外発生時のエラーハンドリング
      CustomSnackBar.show(
        context: context,
        message: 'エラーが発生しました',
        isSuccess: false,
      );
    }
  }
}