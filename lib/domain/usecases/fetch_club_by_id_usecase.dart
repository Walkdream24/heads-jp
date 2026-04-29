import 'package:flutter/foundation.dart';
import '../entities/club_entity.dart';
import '../repositories/clubs_repository.dart';

class FetchClubByIdUseCase {
  final ClubsRepository repository;

  FetchClubByIdUseCase({required this.repository});

  Future<ClubEntity> execute(String clubId) async {
    try {
      final club = await repository.fetchClubById(clubId);
      return club;
    } catch (e) {
      // エラーログ
      debugPrint("FetchClubByIdUseCase Error: $e");
      rethrow;
    }
  }
}
