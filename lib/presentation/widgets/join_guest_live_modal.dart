import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../providers/event_guest_provider.dart';
import '../providers/user_events_guest_provider.dart';
import '../../domain/entities/event_guest_entity.dart';
import 'custom_snackbar.dart';
import '../../core/util/error_helper.dart';

class JoinGuestLiveModal extends ConsumerStatefulWidget {
  final String eventId;

  const JoinGuestLiveModal({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<JoinGuestLiveModal> createState() => _JoinGuestLiveModalState();
}

class _JoinGuestLiveModalState extends ConsumerState<JoinGuestLiveModal> {
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _artistNameController = TextEditingController();
  bool isLoading = false;
  bool isClosing = false;

  @override
  void dispose() {
    _guestNameController.dispose();
    _artistNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context, WidgetRef ref) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final user = await ref.watch(currentUserProvider.future);
      final input = RegisterGuestInput(
        eventId: widget.eventId,
        userId: user.uid,
        guestName: _guestNameController.text.isNotEmpty
            ? _guestNameController.text
            : null,
        targetArtistName: _artistNameController.text.isNotEmpty
            ? _artistNameController.text
            : null,
      );

      await ref.read(registerEventGuestProvider(input).future);

      if (mounted) {
        ref.invalidate(fetchEventGuestsProvider(widget.eventId));
        ref.invalidate(fetchUserEventsGuestProvider(user.uid));
        CustomSnackBar.show(
          context: context,
          message: '参加登録が完了しました！',
          isSuccess: true,
        );
        Navigator.pop(context); // モーダルを閉じる
      }
    } catch (error) {
      if (mounted) {
        CustomSnackBar.show(
          context: context,
          message: getLocalizedErrorMessage(error),
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent <0.2 && !isClosing) {
          isClosing = true;
          if (context.mounted) {
            Navigator.of(context).maybePop();
          }
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0,
        maxChildSize: 0.7,
        snap: true,
        snapSizes: const [0.7],
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'ライブに参加する',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          title: 'ゲスト名（任意）',
                          hint: '例: HEADS太郎',
                          controller: _guestNameController,
                        ),
                        const SizedBox(height: 40),
                        _buildTextField(
                          title: '目的のアーティスト名（任意）',
                          hint: '例: HEADS太郎',
                          controller: _artistNameController,
                        ),
                        const SizedBox(height: 60),
                        GestureDetector(
                          onTap: !isLoading ? () => _handleSubmit(context, ref) : null,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            decoration: BoxDecoration(
                              gradient: !isLoading
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF6C5EE3),
                                        Color(0xFF2F83EC),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )
                                  : null,
                              color: isLoading ? const Color(0xFF444444) : null,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Center(
                              child: Text(
                                '参加登録',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black54,
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

  Widget _buildTextField({
    required String title,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF222222),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}