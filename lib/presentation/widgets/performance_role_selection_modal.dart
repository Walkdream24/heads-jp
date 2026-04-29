import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../providers/event_performers_provider.dart';
import '../providers/user_events_guest_provider.dart';
import '../../domain/entities/event_performer_entity.dart';
import 'custom_snackbar.dart'; 
import '../../core/util/error_helper.dart';

class PerformanceRoleSelectionModal extends ConsumerStatefulWidget {
  final String eventId;

  const PerformanceRoleSelectionModal({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<PerformanceRoleSelectionModal> createState() =>
      _PerformanceRoleSelectionPModalState();
}

class _PerformanceRoleSelectionPModalState
    extends ConsumerState<PerformanceRoleSelectionModal> {
  EventPerformerRole? selectedRole;
  bool isLoading = false;
  bool isClosing = false;

  Future<void> _handleSubmit(BuildContext context) async {
    if (selectedRole == null || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final user = await ref.watch(currentUserProvider.future);
      final input = RegisterPerfomerInput(
        eventId: widget.eventId,
        userId: user.uid,
        role: selectedRole!,
      );
      await ref.read(registerEventPerformerProvider(input).future);

      if (mounted) {
        ref.invalidate(fetchEventPerformersProvider(widget.eventId));
        ref.invalidate(fetchUserEventsPerformerProvider(user.uid));
        // カスタムスナックバーの成功メッセージを表示
        CustomSnackBar.show(
          context: context,
          message: '出演登録が完了しました！',
          isSuccess: true,
        );
         Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        // カスタムスナックバーのエラーメッセージを表示
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          if (notification.extent <0.2 && !isClosing) {
            setState(() {
              isClosing = true;
            });
            if (context.mounted) {
              Navigator.of(context).maybePop();
            }
          }
          return true;
        },
        child: Stack(
          children: [
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0,
              maxChildSize: 0.6,
              snap: true,
              snapSizes: const [0.6],
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
                          const Text(
                            '出演形態の選択',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'あなたが出演する役割を選択してください',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '出演形態',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRole = EventPerformerRole.LIVE;
                              });
                            },
                            child: _buildRoleButton('LIVE', selectedRole == EventPerformerRole.LIVE),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRole = EventPerformerRole.DJ;
                              });
                            },
                            child: _buildRoleButton('DJ', selectedRole == EventPerformerRole.DJ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRole = EventPerformerRole.OTHERS;
                              });
                            },
                            child: _buildRoleButton('VJ・主催者等、イベント関係者', selectedRole == EventPerformerRole.OTHERS),
                          ),
                          const SizedBox(height: 50),
                          GestureDetector(
                            onTap: selectedRole != null && !isLoading
                                ? () => _handleSubmit(context)
                                : null,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              decoration: BoxDecoration(
                                gradient: selectedRole != null && !isLoading
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFF6C5EE3),
                                          Color(0xFF2F83EC),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                                color: selectedRole == null || isLoading
                                    ? const Color(0xFF444444)
                                    : null,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  '出演登録',
                                  style: TextStyle(
                                    color: selectedRole != null && !isLoading
                                        ? Colors.white
                                        : Colors.grey,
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
                );
              },
            ),
            if (isLoading) ...[
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(String title, bool isSelected) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [
                  Color(0xFF6C5EE3),
                  Color(0xFF2F83EC),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isSelected ? null : const Color(0xFF222222),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}