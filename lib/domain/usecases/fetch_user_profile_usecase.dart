import 'package:flutter/foundation.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class FetchUserProfileUseCase {
  final UserRepository repository;

  FetchUserProfileUseCase({required this.repository});

  Future<UserEntity> execute(String userId) async {
    try {
      // リポジトリからリストを取得
      final user = await repository.fetchUserProfile(userId);
      return user;
    } catch (e) {
      // エラーログ
      debugPrint("FetchUserProfileUseCase Error: $e");
      rethrow;
    }
  }
}
