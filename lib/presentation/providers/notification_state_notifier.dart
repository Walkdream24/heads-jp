import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notifications_entity.dart';
import '../../domain/usecases/fetch_notifications_usecase.dart';
import '../../domain/usecases/read_notifications_usecase.dart';
import '../providers/notifications_provider.dart';
import '../../core/util/error_helper.dart';

class NotificationState {
  final List<NotificationEntity> notifications;
  final bool isLoading;
  final String? error;
  final int unreadCount;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    List<NotificationEntity>? notifications,
    bool? isLoading,
    String? error,
    int? unreadCount,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationStateNotifier extends StateNotifier<NotificationState> {
  final FetchNotificationsUseCase fetchNotificationsUseCase;
  final ReadNotificationsUseCase readNotificationsUseCase;
  final String userId;

  NotificationStateNotifier({
    required this.fetchNotificationsUseCase,
    required this.readNotificationsUseCase,
    required this.userId,
  }) : super(const NotificationState()) {
    // 初期データの取得
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final notifications = await fetchNotificationsUseCase.execute(userId);
      state = state.copyWith(
        notifications: notifications,
        isLoading: false,
      );

      // 取得した通知を既読にする
      if (notifications.isNotEmpty) {
        final notificationIds = notifications.map((n) => n.notificationId).toList();
        await markAsRead(notificationIds);
      }
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: getLocalizedErrorMessage(error),
      );
    }
  }

  Future<void> markAsRead(List<String> notificationIds) async {
    try {
      await readNotificationsUseCase.execute(notificationIds);
      // 必要に応じて、ローカルの通知状態も更新できます
      // 例: 既読状態をローカルでも反映させる場合
      final updatedNotifications = state.notifications.map((notification) {
        return notification;
      }).toList();
      
      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      // 既読処理に失敗した場合のエラーハンドリング
      // エラーを表示するかどうかは要件次第です
      debugPrint('既読処理に失敗しました: $e');
    }
  }

  // 他のメソッドは変更なし
  void incrementUnreadCount() {
    state = state.copyWith(unreadCount: state.unreadCount + 1);
    fetchNotifications();
  }

  void clearUnreadCount() {
    state = state.copyWith(unreadCount: 0);
  }
}

// Providerの定義を更新
final notificationStateProvider = StateNotifierProvider.family<NotificationStateNotifier, NotificationState, String>(
  (ref, userId) => NotificationStateNotifier(
    fetchNotificationsUseCase: ref.watch(fetchNotificationsUseCaseProvider),
    readNotificationsUseCase: ref.watch(readNotificationsUseCaseUseCaseProvider),
    userId: userId,
  ),
);