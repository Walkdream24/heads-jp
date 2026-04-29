import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
// import '../../domain/entities/profile_header_entity.dart';
import '../../domain/usecases/fetch_current_user_usecase.dart';
import '../../domain/usecases/fetch_user_profile_usecase.dart';
import 'user_repository_provider.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../domain/usecases/fetch_location_visibility_setting_usecase.dart';
import '../../domain/usecases/update_location_visibility_setting_usecase.dart';

final fetchCurrentUserUseCaseProvider = Provider<FetchCurrentUserUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return FetchCurrentUserUseCase(repository: userRepository);
});

final currentUserProvider = FutureProvider<UserEntity>((ref) async {
  final fetchCurrentUserUseCase = ref.watch(fetchCurrentUserUseCaseProvider);
  return await fetchCurrentUserUseCase.execute();
});


final fetchUserProfileUseCaseProvider = Provider<FetchUserProfileUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return FetchUserProfileUseCase(repository: userRepository);
});

final fetchUserProfileProvider = FutureProvider.family<UserEntity, String>((ref, userId) async {
  final fetchUserProfileUseCase = ref.watch(fetchUserProfileUseCaseProvider);
  return await fetchUserProfileUseCase.execute(userId);
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UpdateUserProfileUseCase(repository: userRepository);
});

// final updateUserProfileProvider = FutureProvider.family<void, ProfileHeaderEntity>((ref, input) async {
//   final updateUserProfileProviderUseCase = ref.watch(updateUserProfileUseCaseProvider);
//   await updateUserProfileProviderUseCase.execute(input);
// });

final fetchLocationVisibilitySettingUseCaseProvider = Provider<FetchLocationVisibilitySettingUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return FetchLocationVisibilitySettingUseCase(repository: repository);
});

final updateLocationVisibilitySettingUseCaseProvider = Provider<UpdateLocationVisibilitySettingUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateLocationVisibilitySettingUseCase(repository: repository);
});
