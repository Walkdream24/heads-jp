import 'package:flutter/foundation.dart';
import '../../domain/entities/device_token_entity.dart';
import '../../domain/repositories/device_token_repository.dart';
import '../datasources/device_token_remote_data_source.dart';

class DeviceTokenRepositoryImpl implements DeviceTokenRepository {
  final DeviceTokenRemoteDataSource remoteDataSource;

  DeviceTokenRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> upsertDeviceToken(
    DeviceTokenInput input
    ) async {
    try {
      await remoteDataSource.upsertDeviceToken(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("DeviceTokenRepositoryImpl Error: $e");
      rethrow;
    }
  }
}
