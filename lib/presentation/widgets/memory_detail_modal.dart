import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/memories_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/events_provider.dart';
import '../providers/memories_provider.dart';
import '../widgets/atomic_event_card_widget.dart';
import '../widgets/loading_event_list.dart';
import '../widgets/custom_snackbar.dart';
import '../providers/memory_post_notifier.dart';
import '../../core/util/error_helper.dart';

class MemoryDetailModal extends ConsumerStatefulWidget {
  final MemoryEntity memory;
  final bool isMyPage;

  const MemoryDetailModal({
    super.key,
    required this.memory,
    required this.isMyPage,
  });

  @override
  ConsumerState<MemoryDetailModal> createState() => _MemoryDetailModalState();
}

class _MemoryDetailModalState extends ConsumerState<MemoryDetailModal> {
  bool _isLoading = false;

  Future<void> _handleDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('削除の確認'),
          backgroundColor: Colors.grey[900],
          content: const Text(
            '投稿を削除してもよろしいですか？',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'キャンセル',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
            ),
            TextButton(
              child: const Text(
                '削除',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // アーカイブ処理を実行
      await ref.read(archiveMemoryProvider(widget.memory).future);
      await ref.read(memoriesProvider(widget.memory.userId).notifier)
          .fetchMemories(widget.memory.userId);
      
      if (!mounted) return;

      // ModalBottomSheetを閉じる
      Navigator.of(context).pop();
      
      // カスタムSnackBarを表示
      if (mounted) {
        Future.microtask(() {
          CustomSnackBar.show(
            context: context,
            message: 'メモリーを削除しました',
            isSuccess: true,
          );
        });
      }
    } catch (error) {
      if (!mounted) return;
      
      CustomSnackBar.show(
        context: context,
        message: 'メモリーの削除に失敗しました',
        isSuccess: false,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsyncValue = widget.memory.eventId != null 
        ? ref.watch(fetchEventByIdProvider(widget.memory.eventId!))
        : null;
    
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
        initialChildSize: 1.0,
        minChildSize: 0,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [1.0],
        builder: (context, scrollController) {
          return Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                // 背景のオーバーレイ
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                // メインコンテンツ
                SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(6),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.memory.photoUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Center(
                                  child: Text(
                                    widget.memory.caption ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                if (widget.memory.eventId != null) ...[
                                  const SizedBox(height: 16),
                                  const Text(
                                    '参加したイベント',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  eventAsyncValue?.when(
                                    data: (event) => AtomicEventCard(
                                      event: event,
                                      width: 120,
                                      imageHeight: 150,
                                    ),
                                    loading: () => const LoadingEventList(itemCount: 1),
                                    error: (error, stack) => Text(
                                      getLocalizedErrorMessage(error),
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ) ?? const SizedBox(),
                                ],
                                // if (widget.isMyPage) ...[
                                //   const SizedBox(height: 16),
                                //   Center(
                                //     child: GestureDetector(
                                //       onTap: () async {
                                //         // Instagram共有のロジック
                                //       },
                                //       child: Container(
                                //         width: 50,
                                //         height: 50,
                                //         margin: const EdgeInsets.only(bottom: 20),
                                //         decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(15),
                                //           gradient: const LinearGradient(
                                //             colors: [
                                //               Color(0xFFF89058),
                                //               Color(0xFFE22C5E),
                                //               Color(0xFF8334C0),
                                //             ],
                                //             stops: [0.0, 0.27, 1.0],
                                //             begin: Alignment.topLeft,
                                //             end: Alignment.bottomRight,
                                //           ),
                                //         ),
                                //         child: Center(
                                //           child: SvgPicture.asset(
                                //             'assets/instagram_logo.svg',
                                //             width: 24,
                                //             height: 24,
                                //             colorFilter: const ColorFilter.mode(
                                //               Colors.white,
                                //               BlendMode.srcIn,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ],
                              ],
                            ),
                            // メニューボタン
                            if (widget.isMyPage)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                  onSelected: (String value) {
                                    if (value == 'delete') {
                                      _handleDelete(context);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('削除'),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}