import 'package:flutter/foundation.dart';
import '../../domain/entities/bookmark_clubs_entity.dart';
import '../../domain/repositories/bookmark_clubs_repository.dart';
import '../datasources/bookmark_clubs_remote_data_source.dart';

class BookmarkClubsRepositoryImpl implements BookmarkClubsRepository {
  final BookmarkClubsRemoteDataSource remoteDataSource;

  BookmarkClubsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addBookmarkClubs(
    BookmarkClubsByIds input
    ) async {
    try {
      await remoteDataSource.addBookmarkClubs(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("BookmarkClubsRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteBookmarkClubs(
    BookmarkClubsByIds input
    ) async {
    try {
      await remoteDataSource.deleteBookmarkClubs(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("BookmarkClubsRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<bool> checkBookMarkClub(
    BookmarkClubsByIds input
    ) async {
    try {
      return await remoteDataSource.checkBookMarkClub(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("BookmarkClubsRepositoryImpl Error: $e");
      rethrow;
    }
  }
}
