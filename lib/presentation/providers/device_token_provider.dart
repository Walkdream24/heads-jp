import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/device_token_entity.dart';
import '../../domain/usecases/upsert_device_token_usecase.dart';
import 'device_token_repository_provider.dart';


final upsertDeviceTokenUseCaseProvider = Provider<UpsertDeviceTokenUseCase>((ref) {
  final repository = ref.watch(deviceTokenRepositoryProvider);
  return UpsertDeviceTokenUseCase(repository: repository);
});

final upsertDeviceTokenProvider = FutureProvider.family<void, DeviceTokenInput>((ref, input) async {
  final upsertDeviceTokenUseCase = ref.watch(upsertDeviceTokenUseCaseProvider);
  await upsertDeviceTokenUseCase.execute(input);
});
