import 'package:flutter/foundation.dart';
import '../entities/club_entity.dart';
import '../repositories/clubs_repository.dart';

class FetchAllClubsInfoUseCase {
  final ClubsRepository repository;

  FetchAllClubsInfoUseCase({required this.repository});

  Future<List<ClubInfoEntity>> execute() async {
    try {
      // クラブ情報を取得
      return await repository.fetchAllClubsInfo();
    } catch (e) {
      debugPrint("FetchAllClubsInfoUseCaseでエラー: $e");
      rethrow;
    }
  }
}
