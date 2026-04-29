import '../entities/device_token_entity.dart';

abstract class DeviceTokenRepository {
  Future<void> upsertDeviceToken(DeviceTokenInput input);
}
