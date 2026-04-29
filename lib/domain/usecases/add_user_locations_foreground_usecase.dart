import 'package:flutter/foundation.dart';
import '../entities/user_locations_entity.dart';
import '../repositories/user_locations_repository.dart';

class AddUserLocationsForegroundUseCase {
  final UserLocationsRepository repository;

  AddUserLocationsForegroundUseCase({required this.repository});

  Future<void> execute(
    AddUserLocationInput input
  ) async {
    try {
      await repository.addUserLocationsForeground(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("AddUserLocationsForegroundUseCase Error: $e");
      rethrow;
    }
  }
  
}
