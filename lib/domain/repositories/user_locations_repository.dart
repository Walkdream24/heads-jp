
import '../entities/user_locations_entity.dart';

abstract class UserLocationsRepository {
  Future<void> addUserLocationsForeground(AddUserLocationInput input);
  Future<List<UserLocationsEntity>> fetchUserLocations(String userId);
}
