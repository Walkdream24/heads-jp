import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushNotificationState {
  final int unreadCount;
  
  const PushNotificationState({this.unreadCount = 0});
  
  PushNotificationState copyWith({int? unreadCount}) {
    return PushNotificationState(
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class PushNotificationStateNotifier extends StateNotifier<PushNotificationState> {
  PushNotificationStateNotifier() : super(const PushNotificationState());
  
  void setUnreadCount(int count) {
    state = state.copyWith(unreadCount: count);
  }
  
  void clearUnreadCount() {
    state = state.copyWith(unreadCount: 0);
  }
  
  void incrementUnreadCount() {
    state = state.copyWith(unreadCount: state.unreadCount + 1);
  }
}

final notificationProvider = StateNotifierProvider<PushNotificationStateNotifier, PushNotificationState>(
  (ref) => PushNotificationStateNotifier(),
);