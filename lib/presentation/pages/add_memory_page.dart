import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../widgets/profile_image_menu.dart';
import '../widgets/gradient_button.dart';
import '../widgets/event_selector_modal.dart';
import '../providers/events_provider.dart';
import '../widgets/atomic_event_card_widget.dart';
import '../providers/memory_post_notifier.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_snackbar.dart';

class AddMemoryPage extends ConsumerStatefulWidget {
  final String? source;
  final DateTime? selectedDate;

  const AddMemoryPage({super.key, this.source, this.selectedDate});

  @override
  ConsumerState<AddMemoryPage> createState() => _AddMemoryPageState();
}

class _AddMemoryPageState extends ConsumerState<AddMemoryPage> {
  bool _isLoading = false;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _handlePost() async {
    final currentUser = ref.read(getCurrentUserProvider);
    final userId = currentUser.call()?.id;

    if (userId == null) {
      if (!mounted) return;
      CustomSnackBar.show(
        context: context,
        message: 'ユーザー情報の取得に失敗しました',
        isSuccess: false,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final eventId = ref.read(selectedEventProvider)?.eventId;
      await ref.read(memoryPostProvider.notifier).submitPost(userId, eventId);

      if (!mounted) return;
      CustomSnackBar.show(
        context: context,
        message: 'メモリーを追加しました',
        isSuccess: true,
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      CustomSnackBar.show(
        context: context,
        message: 'メモリーの投稿に失敗しました',
        isSuccess: false,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showImageMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => ProfileImageMenu(
        onImageSelected: (imagePath) {
          if (imagePath.isNotEmpty) {
            ref.read(memoryPostProvider.notifier).updateImage(imagePath);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvent = ref.watch(selectedEventProvider);
    final memoryState = ref.watch(memoryPostProvider);
    final currentUser = ref.watch(getCurrentUserProvider);
    final userId = currentUser.call()?.id;

    // capionが外部から変更された場合のみ同期
    if (_textController.text != memoryState.caption) {
      _textController.text = memoryState.caption;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        leading: SizedBox(
          width: 100,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'キャンセル',
              style: TextStyle(color: Colors.white, fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        title: Text(
          widget.source == 'calendar' && widget.selectedDate != null
              ? DateFormat('M月d日', 'ja').format(widget.selectedDate!)
              : 'メモリーを追加',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: memoryState.isValid ? _handlePost : null,
            child: Text(
              '投稿',
              style: TextStyle(
                color: memoryState.isValid ? Colors.white : Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: _showImageMenu,
                    child: Center(
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        color: Colors.grey,
                        strokeWidth: 1,
                        dashPattern: const [6, 3],
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: memoryState.imagePath == null
                              ? const Icon(Icons.add, color: Colors.grey, size: 40)
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(memoryState.imagePath!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Focus(
                    onFocusChange: (hasFocus) {
                      if (!hasFocus) {
                        ref.read(memoryPostProvider.notifier).updateCaption(_textController.text);
                      }
                    },
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'ひとことを入力（任意）',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (widget.source != 'calendar') ...[
                    const SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '行ったイベント（任意）',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              if (userId == null) return;
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => EventSelectorModal(userId: userId),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                selectedEvent != null
                                    ? selectedEvent.eventName
                                    : 'タップしてイベントを選択',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        if (selectedEvent != null) ...[
                          const SizedBox(height: 32),
                          AtomicEventCard(event: selectedEvent),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 60),
                  GradientButton(
                    onPressed: memoryState.isValid ? _handlePost : null,
                    text: '投稿する',
                    height: 50.0,
                    borderRadius: 8.0,
                    isEnabled: memoryState.isValid,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
