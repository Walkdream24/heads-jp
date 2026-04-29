import 'package:flutter/foundation.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateLocationVisibilitySettingUseCase {
  final UserRepository repository;

  UpdateLocationVisibilitySettingUseCase({required this.repository});

  Future<void> execute(LocationSettingParams input) async {
    try {
      await repository.updateLocationVisibilitySetting(input);
    } catch (e) {
      // エラーログ
      debugPrint("UpdateLocationVisibilitySettingUseCase Error: $e");
      rethrow;
    }
  }
}
