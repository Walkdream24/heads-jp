import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/current_user_location_entity.dart';
import '../../data/repositories/location_repository_impl.dart';

final currentLocationProvider = FutureProvider<CurrentUserLocation>((ref) {
  final repository = LocationRepositoryImpl();
  return repository.getCurrentLocation();
});

final locationStreamProvider = StreamProvider<CurrentUserLocation>((ref) {
  final repository = LocationRepositoryImpl();
  return repository.watchCurrentLocation();
});
