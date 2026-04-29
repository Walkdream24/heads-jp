import 'package:flutter/foundation.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class FetchCurrentUserUseCase {
  final UserRepository repository;

  FetchCurrentUserUseCase({required this.repository});

  Future<UserEntity> execute() async {
    try {
      debugPrint("FetchCurrentUserUseCase: Fetching user from repository...");
      final user = await repository.fetchCurrentUser();
      final imageurl = user.profilePhotoUrl;
      debugPrint("FetchCurrentUserUseCase: Fetched imageUrl: $imageurl");
      return user;
    } catch (e, stackTrace) {
      debugPrint("FetchCurrentUserUseCase: Error occurred: $e");
      debugPrint("FetchCurrentUserUseCase: StackTrace: $stackTrace");
      rethrow;
    }
  }
}
