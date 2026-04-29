import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentUserAnimationProvider extends StateNotifier<double> {
  CurrentUserAnimationProvider() : super(0.35);

  bool isGrowing = true;

  void animate() {
    if (isGrowing) {
      state += 0.004;
      if (state >= 0.45) isGrowing = false;
    } else {
      state -= 0.004;
      if (state <= 0.35) isGrowing = true;
    }
  }
}

// プロバイダー
final animationProvider = StateNotifierProvider<CurrentUserAnimationProvider, double>(
  (ref) => CurrentUserAnimationProvider(),
);
