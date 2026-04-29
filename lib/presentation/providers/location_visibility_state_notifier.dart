import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/fetch_location_visibility_setting_usecase.dart';
import '../../domain/usecases/update_location_visibility_setting_usecase.dart';
import '../providers/user_provider.dart';

// location_visibility_state.dart
class LocationVisibilityState {
  final LocationVisibilitySettingType setting;
  final bool isLoading;

  LocationVisibilityState({
    required this.setting,
    this.isLoading = false,
  });

  LocationVisibilityState copyWith({
    LocationVisibilitySettingType? setting,
    bool? isLoading,
  }) {
    return LocationVisibilityState(
      setting: setting ?? this.setting,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// location_visibility_state_notifier.dart
class LocationVisibilityStateNotifier extends StateNotifier<LocationVisibilityState> {
  final FetchLocationVisibilitySettingUseCase fetchUseCase;
  final UpdateLocationVisibilitySettingUseCase updateUseCase;

  LocationVisibilityStateNotifier({
    required this.fetchUseCase,
    required this.updateUseCase,
  }) : super(LocationVisibilityState(setting: LocationVisibilitySettingType.NONE));

  // 初期値取得
  Future<void> fetchSetting(String userId) async {
    try {
      final setting = await fetchUseCase.execute(userId);
      state = state.copyWith(setting: setting);
    } catch (e) {
      debugPrint('Error fetching location visibility setting: $e');
      rethrow;
    }
  }

  void updateSelectedSetting(LocationVisibilitySettingType setting) {
    state = state.copyWith(setting: setting);
  }

  // API呼び出しを伴う更新
  Future<void> saveSettings(String userId) async {
    try {
      state = state.copyWith(isLoading: true);
      await updateUseCase.execute(
        LocationSettingParams(
          userId: userId,
          locationType: state.setting,
        ),
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint('Error updating location visibility setting: $e');
      rethrow;
    }
  }
}

// StateNotifierのプロバイダー
final locationVisibilityStateNotifierProvider = Provider<LocationVisibilityStateNotifier>((ref) {
  final fetchUseCase = ref.watch(fetchLocationVisibilitySettingUseCaseProvider);
  final updateUseCase = ref.watch(updateLocationVisibilitySettingUseCaseProvider);
  
  return LocationVisibilityStateNotifier(
    fetchUseCase: fetchUseCase,
    updateUseCase: updateUseCase,
  );
});

// 状態を管理するStateNotifierProvider
final locationVisibilityProvider = StateNotifierProvider<LocationVisibilityStateNotifier, LocationVisibilityState>((ref) {
  return ref.watch(locationVisibilityStateNotifierProvider);
});