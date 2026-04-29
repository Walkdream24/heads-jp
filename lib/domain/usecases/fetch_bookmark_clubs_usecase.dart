import 'package:flutter/foundation.dart';
import '../entities/club_entity.dart';
import '../repositories/clubs_repository.dart';

class FetchBookmarkClubsUseCase {
  final ClubsRepository repository;

  FetchBookmarkClubsUseCase({required this.repository});

  Future<List<ClubInfoEntity>> execute(String userId) async {
    try {
      // クラブ情報を取得
      return await repository.fetchBookmarkClubs(userId);
    } catch (e) {
      debugPrint("FetchBookmarkClubsUseCaseでエラー: $e");
      rethrow;
    }
  }
}
