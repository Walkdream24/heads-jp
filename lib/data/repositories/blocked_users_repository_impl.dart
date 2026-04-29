import 'package:flutter/foundation.dart';
import '../../domain/entities/blocked_users_entity.dart';
import '../../domain/repositories/blocked_users_repository.dart';
import '../datasources/blocked_users_remote_data_source.dart';

class BlockedUsersRepositoryImpl implements BlockedUsersRepository {
  final BlockedUsersRemoteDataSource remoteDataSource;

  BlockedUsersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BlockRelationshipType> getBlockRelationship(
    BlockedUsersInput input
  )async {
    try {
      return await remoteDataSource.getBlockRelationship(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("BlockedUsersRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<void> addBlockedUser(
    BlockedUsersParams input
  ) async {
    try {
      await remoteDataSource.addBlockedUser(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("BlockedUsersRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteBlcokedUser (
    BlockedUsersParams input
    ) async {
    try {
      await remoteDataSource.deleteBlcokedUser(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("BlockedUsersRepositoryImpl Error: $e");
      rethrow;
    }
  }
}
