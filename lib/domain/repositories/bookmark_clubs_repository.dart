import '../entities/bookmark_clubs_entity.dart';

abstract class BookmarkClubsRepository {
  Future<void> addBookmarkClubs(BookmarkClubsByIds input);
  Future<void> deleteBookmarkClubs(BookmarkClubsByIds input); 
  Future<bool> checkBookMarkClub(BookmarkClubsByIds input);
}
