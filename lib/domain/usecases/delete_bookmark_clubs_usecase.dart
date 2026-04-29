import 'package:flutter/foundation.dart';
import '../entities/bookmark_clubs_entity.dart';
import '../repositories/bookmark_clubs_repository.dart';

class DeleteBookmarkClubsUseCase {
  final BookmarkClubsRepository repository;

  DeleteBookmarkClubsUseCase({required this.repository});

  Future<void> execute(
    BookmarkClubsByIds input
  ) async {
    try {
      await repository.deleteBookmarkClubs(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("DeleteBookmarkClubsUseCase Error: $e");
      rethrow;
    }
  }
}
