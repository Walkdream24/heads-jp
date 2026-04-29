import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/events_provider.dart';
import '../providers/users_summary_provider.dart';
import '../widgets/atomic_event_card_widget.dart';
import '../widgets/loading_event_list.dart';
import '../widgets/loading_user_summary_widget.dart';
import '../pages/heads_detail_page.dart';
import '../../domain/entities/memories_entity.dart';
import '../../core/util/error_helper.dart';
import '../widgets/event_detail_modal.dart';

// ダイアログを表示する関数
void showCombinedMemoryDialog(BuildContext context, MemoryEntity memory) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container(); // pageBuilder needs to return something, but we don't use it
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
          child: CombinedMemoryDetailWidget(memory: memory), // Now CombinedMemoryDetailWidget itself is the dialog content
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black87,
  );
}

class CombinedMemoryDetailWidget extends ConsumerStatefulWidget { 
  final MemoryEntity memory;

  const CombinedMemoryDetailWidget({
    super.key,
    required this.memory,
  });

  @override
  ConsumerState<CombinedMemoryDetailWidget> createState() => _CombinedMemoryDetailWidgetState();
}

class _CombinedMemoryDetailWidgetState extends ConsumerState<CombinedMemoryDetailWidget> {
  bool isClosing = false;

  @override
  Widget build(BuildContext context) {
    final userSummaryAsyncValue = ref.watch(userSummaryProvider(widget.memory.userId));
    final eventAsyncValue = widget.memory.eventId != null
        ? ref.watch(fetchEventByIdProvider(widget.memory.eventId!))
        : null;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent < 0.2 && !isClosing) {
          isClosing = true;
          if (mounted) { // Use mounted check
            Navigator.of(context).maybePop();
          }
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [1.0], 
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              controller: scrollController, 
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: widget.memory.photoUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => AspectRatio(
                          aspectRatio: 1.0,
                          child: Container(color: Colors.grey[800]),
                        ),
                        errorWidget: (context, url, error) => AspectRatio(
                          aspectRatio: 1.0,
                          child: Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.error, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // キャプション
                  if (widget.memory.caption != null && widget.memory.caption!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: Text(
                          widget.memory.caption!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],

                  // ユーザー情報
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: userSummaryAsyncValue.when(
                      data: (userSummary) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // 現在のダイアログを閉じる
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return HeadsDetailPage(userId: widget.memory.userId);
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
                                placeholder: (context, url) => Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey[800],
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.error, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // ユーザー名とID
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      error: (error, stackTrace) => const Text(
                        'ユーザー情報の取得に失敗しました',
                        style: TextStyle(color: Colors.red),
                      ),
                      loading: () => const LoadingUserSummaryWidget(),
                    ),
                  ),

                  // 参加したイベント
                  if (widget.memory.eventId != null) ...[
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '参加したイベント',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: eventAsyncValue?.when(
                        data: (event) => AtomicEventCard(
                          event: event,
                          width: 120,
                          imageHeight: 150,
                          onTap: () async {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return EventDetailModal(event: event);
                              },
                            );
                          },
                        ),
                        loading: () => const LoadingEventList(itemCount: 1),
                        error: (error, stack) => Text(
                          getLocalizedErrorMessage(error),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ) ?? const SizedBox(),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}