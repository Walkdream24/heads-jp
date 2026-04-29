import 'package:flutter/foundation.dart';
import '../entities/profile_header_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfileUseCase {
  final UserRepository repository;

  UpdateUserProfileUseCase({required this.repository});

  Future<void> execute(
    ProfileHeaderEntity input
  ) async {
    try {
      await repository.updateUserProfile(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("UpdateUserProfileUseCase Error: $e");
      rethrow;
    }
  }
  
}
