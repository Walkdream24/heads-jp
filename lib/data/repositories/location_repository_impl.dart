import '../../domain/entities/current_user_location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../../core/util/location_util.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<CurrentUserLocation> getCurrentLocation() async {
    final position = await LocationUtil.getCurrentPosition();
    return CurrentUserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Stream<CurrentUserLocation> watchCurrentLocation() {
    return LocationUtil.watchPositionStream().map((position) {
      return CurrentUserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    });
  }
}
