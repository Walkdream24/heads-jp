import 'package:flutter/foundation.dart';
import '../entities/device_token_entity.dart';
import '../repositories/device_token_repository.dart';

class UpsertDeviceTokenUseCase {
  final DeviceTokenRepository repository;

  UpsertDeviceTokenUseCase({required this.repository});

  Future<void> execute(
    DeviceTokenInput input
  ) async {
    try {
      await repository.upsertDeviceToken(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("UpsertDeviceTokenUseCase Error: $e");
      rethrow;
    }
  }
  
}
