class BookmarkClubsEntity {
  final String bookmarkClubId;
  final String userId;
  final String clubId;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  BookmarkClubsEntity({
    required this.bookmarkClubId,
    required this.userId,
    required this.clubId,
    // required this.createdAt,
    // required this.updatedAt,
  });
}

class BookmarkClubsByIds {
  final String userId;
  final String clubId;

  BookmarkClubsByIds({
    required this.userId,
    required this.clubId,
  });
}