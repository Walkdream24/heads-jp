import 'package:flutter/foundation.dart';
import '../entities/club_entity.dart';
import '../repositories/clubs_repository.dart';

class FetchClubsUseCase {
  final ClubsRepository repository;

  FetchClubsUseCase({required this.repository});

  Future<List<ClubEntity>> execute() async {
    try {
      // クラブ情報を取得
      return await repository.fetchClubs();
    } catch (e) {
      debugPrint("FetchCurrentClubsUseCaseでエラー: $e");
      rethrow;
    }
  }
}
