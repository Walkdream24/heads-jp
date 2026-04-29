import 'package:flutter/material.dart';
import '../widgets/settings_modal.dart';
import '../widgets/notification_list_modal.dart';
import '../widgets/friend_search_modal.dart'; // 追加
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/push_notification_state.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import '../pages/event_register_page.dart';

class TopButtons extends ConsumerWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(notificationProvider).unreadCount;

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 友達検索ボタンを一番上に追加
            _TopButton.friendSearch(
              onPressed: () => _showModal(context, const FriendSearchModal()),
            ),
            const SizedBox(height: 16),
            _TopButton.addEvent(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (context) => const EventRegisterPage()),
              ),
            ),
            const SizedBox(height: 16),
            _TopButton.settings(
              onPressed: () => _showModal(context, const SettingsModal()),
            ),
            const SizedBox(height: 16),
            _TopButton.notification(
              unreadCount: unreadCount,
              onPressed: () async {
                ref.read(notificationProvider.notifier).clearUnreadCount();
                await FlutterAppBadger.removeBadge();
                _showModal(context, const NotificationListModal());
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showModal(BuildContext context, Widget modal) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => modal,
    );
  }
}

class _TopButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool hasGradient;
  final int? unreadCount;
  final Color? backgroundColor;
  final Color? iconColor;

  const _TopButton({
    required this.icon,
    required this.onPressed,
    this.hasGradient = false,
    this.unreadCount,
    this.backgroundColor,
    this.iconColor,
  });

  // 友達検索ボタン（新規追加）
  factory _TopButton.friendSearch({required VoidCallback onPressed}) {
    return _TopButton(
      icon: Icons.group_add,
      onPressed: onPressed,
    );
  }

  // イベント追加ボタン
  factory _TopButton.addEvent({required VoidCallback onPressed}) {
    return _TopButton(
      icon: Icons.edit_calendar,
      onPressed: onPressed,
    );
  }

  // 設定ボタン
  factory _TopButton.settings({required VoidCallback onPressed}) {
    return _TopButton(
      icon: Icons.settings,
      onPressed: onPressed,
    );
  }

  // 通知ボタン
  factory _TopButton.notification({
    required VoidCallback onPressed,
    required int unreadCount,
  }) {
    return _TopButton(
      icon: Icons.notifications,
      onPressed: onPressed,
      unreadCount: unreadCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hasGradient) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3CED6D), Color(0xFF527DE2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          shape: BoxShape.circle,
        ),
        child: _buildIconButton(color: Colors.white),
      );
    }

    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: _buildIconButton(color: Colors.white),
        ),
        if (unreadCount != null && unreadCount! > 0)
          _buildBadge(unreadCount!),
      ],
    );
  }

  Widget _buildIconButton({Color? color}) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 24,
      color: color ?? Colors.white,
      onPressed: onPressed,
    );
  }

  Widget _buildBadge(int count) {
    return Positioned(
      right: -2,
      top: -2,
      child: Container(
        padding: const EdgeInsets.all(2),
        constraints: const BoxConstraints(
          minWidth: 22,
          minHeight: 22,
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}