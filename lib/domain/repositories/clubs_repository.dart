import '../entities/club_entity.dart';

abstract class ClubsRepository {
  Future<List<ClubEntity>> fetchClubs();
  Future<ClubEntity> fetchClubById(String clubId); 
  Future<List<ClubInfoEntity>> fetchAllClubsInfo();
  Future<List<ClubInfoEntity>> fetchBookmarkClubs(String userId);
}
