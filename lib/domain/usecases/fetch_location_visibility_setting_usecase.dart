import 'package:flutter/foundation.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class FetchLocationVisibilitySettingUseCase {
  final UserRepository repository;

  FetchLocationVisibilitySettingUseCase({required this.repository});

  Future<LocationVisibilitySettingType> execute(String userId) async {
    try {
      final locationType = await repository.fetchLocationVisibilitySetting(userId);
      return locationType;
    } catch (e) {
      // エラーログ
      debugPrint("FetchLocationVisibilitySettingUseCase Error: $e");
      rethrow;
    }
  }
}
