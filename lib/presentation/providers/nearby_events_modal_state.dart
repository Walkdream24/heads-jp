import 'package:flutter_riverpod/flutter_riverpod.dart';

// NearbyEventsModalの表示状態を管理するプロバイダー
final nearbyEventsModalVisibilityProvider = StateNotifierProvider<NearbyEventsModalVisibilityNotifier, bool>((ref) {
  return NearbyEventsModalVisibilityNotifier();
});

class NearbyEventsModalVisibilityNotifier extends StateNotifier<bool> {
  NearbyEventsModalVisibilityNotifier() : super(true); // 初期状態は表示

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}