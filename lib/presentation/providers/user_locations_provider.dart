import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_locations_entity.dart';
import '../../domain/usecases/add_user_locations_foreground_usecase.dart';
import '../../domain/usecases/fetch_user_locations_usecase.dart';
import 'user_locations_repository_provider.dart';

final addUserLocationsForegroundUseCaseProvider = Provider<AddUserLocationsForegroundUseCase>((ref) {
  final repository = ref.watch(userLocationsRepositoryProvider);
  return AddUserLocationsForegroundUseCase(repository: repository);
});

final addUserLocationsForegroundProvider = FutureProvider.family<void, AddUserLocationInput>((ref, input) async {
  debugPrint("addUserLocationsPerformerProvider");
  final addUserLocationsForegroundUseCase = ref.watch(addUserLocationsForegroundUseCaseProvider);
  await addUserLocationsForegroundUseCase.execute(input);
});



final fetchUserLocationsUseCaseProvider = Provider<FetchUserLocationsUseCase>((ref) {
  final repository = ref.watch(userLocationsRepositoryProvider);
  return FetchUserLocationsUseCase(repository: repository);
});

//NOTE
//StreamProvider or StateNotifierProviderにした方が良い
//一旦FutureProviderにしてる
final userLocationsProvider = FutureProvider.family<List<UserLocationsEntity>, String>((ref, userId) async {
  final fetchUserLocationsUseCase = ref.watch(fetchUserLocationsUseCaseProvider);
  return await fetchUserLocationsUseCase.execute(userId);
});
