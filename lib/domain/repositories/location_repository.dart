import '../entities/current_user_location_entity.dart';

abstract class LocationRepository {
  Future<CurrentUserLocation> getCurrentLocation();
  Stream<CurrentUserLocation> watchCurrentLocation();
}
