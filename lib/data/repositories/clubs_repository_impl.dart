import 'package:flutter/foundation.dart';
import '../../domain/entities/club_entity.dart';
import '../../domain/repositories/clubs_repository.dart';
import '../datasources/clubs_remote_data_source.dart';

class ClubsRepositoryImpl implements ClubsRepository {
  final ClubsRemoteDataSource remoteDataSource;

  ClubsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ClubEntity>> fetchClubs() async {
    try {
      // データソースからクラブ情報を取得
      final clubModels = await remoteDataSource.fetchClubs();

      // `ClubModel` を `ClubEntity` に変換
      return clubModels.map((model) => ClubEntity(
        clubId: model.clubId,
        clubName: model.clubName,
        description: model.description,
        clubPhotoUrl: model.clubPhotoUrl,
        address: model.address,
        latitude: model.latitude,
        longitude: model.longitude,
      )).toList();
    } catch (e) {
      debugPrint("ClubsRepositoryImplでエラー: $e");
      rethrow;
    }
  }

  @override
  Future<ClubEntity> fetchClubById(String clubId) async {
    try {
      final clubModels = await remoteDataSource.fetchClubById(clubId);

      return ClubEntity(
        clubId: clubModels.clubId,
        clubName: clubModels.clubName,
        description: clubModels.description,
        clubPhotoUrl: clubModels.clubPhotoUrl,
        address: clubModels.address,
        latitude: clubModels.latitude,
        longitude: clubModels.longitude,
      );

    } catch (e) {
      // エラーログ
      debugPrint("ClubsRepositoryImplでエラー: $e");
      rethrow;
    }
  }

  @override
  Future<List<ClubInfoEntity>> fetchAllClubsInfo() async {
    try {
      // データソースからクラブ情報を取得
      final models = await remoteDataSource.fetchAllClubsInfo();

      return models.map((model) => ClubInfoEntity(
        clubId: model.clubId,
        clubName: model.clubName,
        address: model.address,
      )).toList();
    } catch (e) {
      debugPrint("ClubsRepositoryImplでエラー: $e");
      rethrow;
    }
  }

  @override
  Future<List<ClubInfoEntity>> fetchBookmarkClubs(String userId) async {
    try {
      // データソースからクラブ情報を取得
      final models = await remoteDataSource.fetchBookmarkClubs(userId);

      return models.map((model) => ClubInfoEntity(
        clubId: model.clubId,
        clubName: model.clubName,
        address: model.address,
      )).toList();
    } catch (e) {
      debugPrint("ClubsRepositoryImplでエラー: $e");
      rethrow;
    }
  }
}
