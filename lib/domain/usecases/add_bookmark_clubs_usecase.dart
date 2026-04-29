import 'package:flutter/foundation.dart';
import '../entities/bookmark_clubs_entity.dart';
import '../repositories/bookmark_clubs_repository.dart';

class AddBookmarkClubsUseCase {
  final BookmarkClubsRepository repository;

  AddBookmarkClubsUseCase({required this.repository});

  Future<void> execute(
    BookmarkClubsByIds input
  ) async {
    try {
      await repository.addBookmarkClubs(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("AddBookmarkClubsUseCase Error: $e");
      rethrow;
    }
  }
}
