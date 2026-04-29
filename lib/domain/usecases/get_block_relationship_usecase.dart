import 'package:flutter/foundation.dart';
import '../entities/blocked_users_entity.dart';
import '../repositories/blocked_users_repository.dart';

class GetBlockRelationshipUseCase {
  final BlockedUsersRepository repository;

  GetBlockRelationshipUseCase({required this.repository});

  Future<BlockRelationshipType> execute(
    BlockedUsersInput input
  ) async {
    try {
      return await repository.getBlockRelationship(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("GetBlockRelationshipUseCase Error: $e");
      rethrow;
    }
  }
}
