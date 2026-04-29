import 'package:flutter/foundation.dart';
import '../../domain/entities/user_summary_entity.dart';
import '../../domain/repositories/user_summary_repository.dart';
import '../datasources/user_summary_remote_data_source.dart';

class UserSummaryRepositoryImpl implements UserSummaryRepository {
  final UserSummaryRemoteDataSource remoteDataSource;

  UserSummaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserSummaryEntity> fetchUserSummary(
    String userId
    ) async {
    try {
      final model = await remoteDataSource.fetchUserSummary(
        userId
      );
      return UserSummaryEntity(
        uid: model.uid,
        username: model.username,
        profilePhotoUrl: model.profilePhotoUrl,
        headsId: model.headsId,
      );
    } catch (e) {
      // エラーログ
      debugPrint("UserSummaryRepositoryImpl fetchUserSummary Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<UserSummaryEntity>> fetchUsers(List<String> userIds) async {
    try {
      // Remote DataSourceからEventModelリストを取得
      debugPrint("UserSummaryRepositoryImpl内");
      final userSummaryModel = await remoteDataSource.fetchUsers(userIds);

      // ModelをEntityに変換
      final users = userSummaryModel.map((model) => UserSummaryEntity(
        uid: model.uid,
        username: model.username,
        profilePhotoUrl: model.profilePhotoUrl
      )).toList();

      return users;
    } catch (e) {
      // エラーログ
      debugPrint("UserSummaryRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<UserSummaryEntity>> searchUsersByHeadsId(String query) async {
    try {
      final userSummaryModel = await remoteDataSource.searchUsersByHeadsId(query);

      // ModelをEntityに変換
      final users = userSummaryModel.map((model) => UserSummaryEntity(
        uid: model.uid,
        username: model.username,
        profilePhotoUrl: model.profilePhotoUrl,
        headsId: model.headsId,
      )).toList();

      return users;
    } catch (e) {
      // エラーログ
      debugPrint("UserSummaryRepositoryImpl Error: $e");
      rethrow;
    }
  }
}
