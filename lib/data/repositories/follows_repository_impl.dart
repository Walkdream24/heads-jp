import 'package:flutter/foundation.dart';

import '../../domain/entities/follows_entity.dart';
import '../../domain/repositories/follows_repository.dart';
import '../datasources/follows_remote_data_source.dart';
import '../../domain/entities/user_summary_entity.dart';

class FollowsRepositoryImpl implements FollowsRepository {
  final FollowsRemoteDataSource remoteDataSource;

  FollowsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FollowCheckResult> checkFollowStatus(
    FollowsInput input
    ) async {
    try {
      final result = await remoteDataSource.checkFollowStatus(
        input
      );
      return FollowCheckResult(
        isFollowing: result.isFollowing,
        isFollowedBy: result.isFollowedBy, 
        status: result.status
      );
    } catch (e) {
      // エラーログ
      debugPrint("FollowsRepositoryImpl checkFollowStatus Error: $e");
      rethrow;
    }
  }

  @override
  Future<void> followRequest(
    FollowsInput input
    ) async {
    try {
      await remoteDataSource.followRequest(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("FollowsRepositoryImpl followRequest Error: $e");
      rethrow;
    }
  }
  @override
  Future<void> followReturn(
    FollowsInput input
    ) async {
    try {
      await remoteDataSource.followReturn(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("FollowsRepositoryImpl followReturn Error: $e");
      rethrow;
    }
  }
  @override
  Future<void> unFollowUser(
    FollowsInput input
    ) async {
    try {
      await remoteDataSource.unFollowUser(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("FollowsRepositoryImpl unFollowUser Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<UserSummaryEntity>> fetchRequestFollows(
    String userId
  ) async {
    try {
      final userSummaryModel = await remoteDataSource.fetchRequestFollows(userId);

      // ModelをEntityに変換
      final users = userSummaryModel.map((model) => UserSummaryEntity(
        uid: model.uid,
        username: model.username,
        profilePhotoUrl: model.profilePhotoUrl
      )).toList();

      return users;
    } catch (e) {
      // エラーログ
      debugPrint("FollowsRepositoryImpl fetchRequestFollows Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<UserSummaryEntity>> fetchCommonFollowers(
    FollowsInput input
  ) async {
    try {
      final userSummaryModel = await remoteDataSource.fetchCommonFollowers(input);

      // ModelをEntityに変換
      final users = userSummaryModel.map((model) => UserSummaryEntity(
        uid: model.uid,
        username: model.username,
        profilePhotoUrl: model.profilePhotoUrl,
        headsId: model.headsId
      )).toList();

      return users;
    } catch (e) {
      // エラーログ
      debugPrint("FollowsRepositoryImpl fetchCommonFollowers Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<UserSummaryEntity>> fetchFollowerList(
    String userId
  ) async {
    try {
      final userSummaryModel = await remoteDataSource.fetchFollowerList(userId);

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
      debugPrint("FollowsRepositoryImpl fetchFollowerList Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<UserSummaryEntity>> fetchFollowingList(
    String userId
  ) async {
    try {
      final userSummaryModel = await remoteDataSource.fetchFollowingList(userId);

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
      debugPrint("FollowsRepositoryImpl fetchFollowingList Error: $e");
      rethrow;
    }
  }
}
