import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event_entity.dart';
import '../providers/event_performers_provider.dart';
import '../providers/event_guest_provider.dart';
import '../providers/user_provider.dart';
import '../providers/user_events_guest_provider.dart';
import '../widgets/join_event_button.dart';
import '../widgets/join_guest_live_modal.dart';
import '../widgets/performance_role_selection_modal.dart';
import '../widgets/loading_event_join_button.dart';
import '../../core/util/error_helper.dart';
import 'custom_snackbar.dart';

class EventParticipationButtons extends ConsumerStatefulWidget {
  final EventEntity event;
  final VoidCallback? onParticipationChanged; // 参加状況が変更された時のコールバック

  const EventParticipationButtons({
    super.key,
    required this.event,
    this.onParticipationChanged,
  });

  @override
  ConsumerState<EventParticipationButtons> createState() => _EventParticipationButtonsState();
}

class _EventParticipationButtonsState extends ConsumerState<EventParticipationButtons> {
  // ローディング状態を管理
  bool _isGuestCancelling = false;
  bool _isPerformerCancelling = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isEventActive = widget.event.endDatetime.isAfter(now);
    
    return Consumer(
      builder: (context, ref, child) {
        final userAsyncValue = ref.watch(currentUserProvider);
        
        return userAsyncValue.when(
          data: (currentUser) {
            final currentUserId = currentUser.uid;

            return ref.watch(fetchEventGuestsProvider(widget.event.eventId)).when(
              data: (guests) {
                // ユーザーが登録済みのゲストか確認
                final isRegisteredGuest = guests.any((guest) => guest.userId == currentUserId);
                String? eventGuestId;
                
                if (isRegisteredGuest) {
                  final guest = guests.firstWhere((guest) => guest.userId == currentUserId);
                  eventGuestId = guest.eventGuestId;
                }

                return ref.watch(fetchEventPerformersProvider(widget.event.eventId)).when(
                  data: (performers) {
                    // ユーザーが登録済みのパフォーマーか確認
                    final isRegisteredPerformer = performers.any(
                      (performer) => performer.userId == currentUserId,
                    );
                    
                    // パフォーマーIDを取得
                    String? eventPerformerId;
                    if (isRegisteredPerformer) {
                      final performer = performers.firstWhere((performer) => performer.userId == currentUserId);
                      eventPerformerId = performer.eventPerformerId;
                    }

                    return Column(
                      children: [
                        // ゲスト参加ボタン
                        _buildGuestButton(
                          context, 
                          ref, 
                          currentUser.uid,
                          isRegisteredGuest, 
                          eventGuestId, 
                          isEventActive
                        ),
                        const SizedBox(height: 16),
                        // パフォーマー参加ボタン
                        _buildPerformerButton(
                          context, 
                          ref, 
                          currentUser.uid,
                          isRegisteredPerformer, 
                          eventPerformerId, 
                          isEventActive
                        ),
                      ],
                    );
                  },
                  loading: () => _buildLoadingButtons(),
                  error: (error, stack) => Text(
                    getLocalizedErrorMessage(error),
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
              loading: () => _buildLoadingButtons(),
              error: (error, stack) => Text(
                getLocalizedErrorMessage(error),
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
          loading: () => _buildLoadingButtons(),
          error: (error, stack) => Text(
            getLocalizedErrorMessage(error),
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  Widget _buildLoadingButtons() {
    return const Column(
      children: [
        LoadingJoinEventButton(),
        SizedBox(height: 16),
        LoadingJoinEventButton(),
      ],
    );
  }

  // ゲスト参加ボタン
  Widget _buildGuestButton(
    BuildContext context, 
    WidgetRef ref, 
    String userId,
    bool isRegisteredGuest, 
    String? eventGuestId, 
    bool isEventActive
  ) {
    // 登録済みの場合はキャンセルボタンを表示
    if (isRegisteredGuest && eventGuestId != null) {
      return _buildCancelGuestButton(context, ref, eventGuestId, userId);
    }
    
    // 過去イベントか現在進行中/未来のイベントかで表記を変更
    final buttonTitle = isEventActive ? 'イベントに参戦する（お客さん）' : '当日このイベントに参戦した（お客さん）';
    
    return JoinEventButton(
      title: buttonTitle,
      isEnabled: true,
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return JoinGuestLiveModal(
              eventId: widget.event.eventId,
            );
          },
        );
      },
    );
  }

  // パフォーマー参加ボタン
  Widget _buildPerformerButton(
    BuildContext context, 
    WidgetRef ref, 
    String userId,
    bool isRegisteredPerformer, 
    String? eventPerformerId, 
    bool isEventActive
  ) {
    // 登録済みの場合はキャンセルボタンを表示
    if (isRegisteredPerformer && eventPerformerId != null) {
      return _buildCancelPerformerButton(context, ref, eventPerformerId, userId);
    }
    
    // 過去イベントか現在進行中/未来のイベントかで表記を変更
    final buttonTitle = isEventActive ? '出演・イベント関係者の方はこちら' : '出演・イベント関係者として参加した';
    
    return JoinEventButton(
      title: buttonTitle,
      isEnabled: true,
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return PerformanceRoleSelectionModal(
              eventId: widget.event.eventId,
            );
          },
        );
      },
    );
  }

  // ゲストキャンセルボタン
  Widget _buildCancelGuestButton(BuildContext context, WidgetRef ref, String eventGuestId, String userId) {
    // ローディング中はローディングボタンを表示
    if (_isGuestCancelling) {
      return const LoadingJoinEventButton();
    }

    return JoinEventButton(
      title: '参加をキャンセルする',
      isEnabled: true,
      onPressed: () async {
        final bool? result = await _showCancelConfirmDialog(
          context, 
          'イベント参加のキャンセル', 
          'このイベントへの参加をキャンセルしますか？'
        );

        if (result == true && mounted) {
          setState(() {
            _isGuestCancelling = true;
          });

          try {
            await ref.read(cancelRegisterGuestProvider(eventGuestId).future);
            
            if (mounted) {
              ref.invalidate(fetchEventGuestsProvider(widget.event.eventId));
              ref.invalidate(fetchUserEventsGuestProvider(userId));
              
              CustomSnackBar.show(
                context: context,
                message: 'イベント参加をキャンセルしました',
                isSuccess: true,
              );
              
              // 参加状況変更を通知
              widget.onParticipationChanged?.call();
            }
          } catch (e) {
            if (mounted) {
              CustomSnackBar.show(
                context: context,
                message: getLocalizedErrorMessage(e),
                isSuccess: false,
              );
            }
          } finally {
            if (mounted) {
              setState(() {
                _isGuestCancelling = false;
              });
            }
          }
        }
      },
    );
  }

  // パフォーマーキャンセルボタン
  Widget _buildCancelPerformerButton(BuildContext context, WidgetRef ref, String eventPerformerId, String userId) {
    // ローディング中はローディングボタンを表示
    if (_isPerformerCancelling) {
      return const LoadingJoinEventButton();
    }

    return JoinEventButton(
      title: '出演をキャンセルする',  
      isEnabled: true,
      onPressed: () async {
        final bool? result = await _showCancelConfirmDialog(
          context, 
          '出演のキャンセル', 
          'このイベントへの出演をキャンセルしますか？'
        );

        if (result == true && mounted) {
          setState(() {
            _isPerformerCancelling = true;
          });

          try {
            await ref.read(cancelRegisterPerformerProvider(eventPerformerId).future);
            
            if (mounted) {
              ref.invalidate(fetchEventPerformersProvider(widget.event.eventId));
              ref.invalidate(fetchUserEventsPerformerProvider(userId));
              
              CustomSnackBar.show(
                context: context,
                message: '出演をキャンセルしました',
                isSuccess: true,
              );
              
              // 参加状況変更を通知
              widget.onParticipationChanged?.call();
            }
          } catch (e) {
            if (mounted) {
              CustomSnackBar.show(
                context: context,
                message: getLocalizedErrorMessage(e),
                isSuccess: false,
              );
            }
          } finally {
            if (mounted) {
              setState(() {
                _isPerformerCancelling = false;
              });
            }
          }
        }
      },
    );
  }

  // 確認ダイアログを表示する共通メソッド
  Future<bool?> _showCancelConfirmDialog(BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF222222),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            content,
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('いいえ', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('はい', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}