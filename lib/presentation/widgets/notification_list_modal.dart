import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/notifications_entity.dart';
import '../providers/auth_provider.dart';
import '../pages/heads_detail_page.dart';
import '../widgets/event_detail_modal.dart';
import '../providers/events_provider.dart';
import '../../core/util/date_time_utils.dart';
import '../providers/notification_state_notifier.dart';

class NotificationListModal extends ConsumerWidget {
  const NotificationListModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authProvider);
    bool isClosing = false;

    if (currentUser == null) {
      return const Center(
        child: Text(
          'ユーザー情報が取得できません',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final notificationState = ref.watch(notificationStateProvider(currentUser.id));

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
        initialChildSize: 0.9,
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
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "お知らせ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: () {
                            ref.read(notificationStateProvider(currentUser.id).notifier)
                                .fetchNotifications();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (notificationState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (notificationState.error != null)
                      Center(
                        child: Text(
                          'エラーが発生しました: ${notificationState.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    else if (notificationState.notifications.isEmpty)
                      const Center(
                        child: Text(
                          'お知らせはありません',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: notificationState.notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notificationState.notifications[index];
                          return NotificationListItem(
                            notification: notification,
                            onTap: () {},
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NotificationListItem extends StatefulWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationListItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  State<NotificationListItem> createState() => _NotificationListItemState();
}

class _NotificationListItemState extends State<NotificationListItem> {
  bool _isLoading = false;

  bool get _isEventRelatedNotification =>
      widget.notification.type == NotificationType.ADD_EVENT ||
      widget.notification.type == NotificationType.JOIN_ARTIST ||
      widget.notification.type == NotificationType.JOIN_HEADS;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return InkWell(
          onTap: _isLoading
              ? null
              : () async {
                  switch (widget.notification.type) {
                    case NotificationType.FOLLOW:
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return HeadsDetailPage(userId: widget.notification.data.followerId!);
                        },
                      );
                      break;

                    case NotificationType.ADD_EVENT:
                    case NotificationType.JOIN_ARTIST:
                    case NotificationType.JOIN_HEADS:
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final eventAsync = await ref.read(
                          fetchEventByIdProvider(widget.notification.data.eventId!).future
                        );
                        if (context.mounted) {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return EventDetailModal(event: eventAsync);
                            },
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('イベントの取得に失敗しました'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                      break;
                  }
                },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.notification.data.leftImageUrl != null)
                      Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: widget.notification.data.leftImageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.notification.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            getTimeAgo(widget.notification.createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.notification.data.rightImageUrl != null)
                      Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(left: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: widget.notification.data.rightImageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (_isLoading && _isEventRelatedNotification)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}