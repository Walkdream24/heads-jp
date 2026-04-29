import 'package:flutter/foundation.dart';
import '../entities/bookmark_clubs_entity.dart';
import '../repositories/bookmark_clubs_repository.dart';

class CheckBookmarkClubUseCase {
  final BookmarkClubsRepository repository;

  CheckBookmarkClubUseCase({required this.repository});

  Future<bool> execute(
    BookmarkClubsByIds input
  ) async {
    try {
      return await repository.checkBookMarkClub(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("CheckBookmarkClubUseCase Error: $e");
      rethrow;
    }
  }
}
