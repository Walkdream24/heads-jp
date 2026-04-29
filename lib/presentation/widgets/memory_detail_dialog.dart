import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/memories_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/users_summary_provider.dart';
import '../pages/heads_detail_page.dart';
import '../widgets/loading_user_summary_widget.dart';

// ダイアログを表示する関数
void showMemoryDialog(BuildContext context, MemoryEntity memory) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      var curve = Curves.easeInOut;
      var curveTween = CurveTween(curve: curve);
      var tween = Tween<double>(begin: 0, end: 1).chain(curveTween);
      var fadeAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: animation.drive(
            Tween<double>(begin: 0.95, end: 1.0).chain(curveTween),
          ),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.zero,
            child: MemoryDetailDialog(memory: memory),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black87,
  );
}

class MemoryDetailDialog extends ConsumerWidget {
  final MemoryEntity memory;

  const MemoryDetailDialog({
    super.key,
    required this.memory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSummaryAsyncValue = ref.watch(userSummaryProvider(memory.userId));
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 閉じるボタン
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          
          // メイン画像
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: memory.photoUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          // ユーザー情報とキャプション
          Column(
              children: [
                // ユーザー情報
                userSummaryAsyncValue.when(
                  data: (userSummary) => Align(
                    alignment: Alignment.centerLeft,  // 左寄せに変更
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return HeadsDetailPage(userId: memory.userId);
                          },
                        );
                      },
                      child: Row(
                        children: [
                          // ユーザーアイコン
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: userSummary.profilePhotoUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // ユーザー名とID
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,  // 左寄せに変更
                            children: [
                              Text(
                                userSummary.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              if (userSummary.headsId != null)
                                Text(
                                  "@${userSummary.headsId}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  error: (error, stackTrace) => const Text(
                    'ユーザー情報の取得に失敗しました',
                    style: TextStyle(color: Colors.red),
                  ),
                  loading: () => const Center(
                    child:LoadingUserSummaryWidget(),
                  ),
                ),
                const SizedBox(height: 16),
                // キャプション
                Center(  // 中央揃えに変更
                  child: Text(
                    memory.caption ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,  // テキストも中央揃えに
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}