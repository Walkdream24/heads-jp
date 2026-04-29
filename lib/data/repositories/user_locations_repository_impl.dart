import 'package:flutter/foundation.dart';
import '../../domain/entities/user_locations_entity.dart';
import '../../domain/repositories/user_locations_repository.dart';
import '../datasources/user_locations_remote_data_source.dart';

class UserLocationsRepositoryImpl implements UserLocationsRepository {
  final UserLocationsRemoteDataSource remoteDataSource;

  UserLocationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addUserLocationsForeground(
    AddUserLocationInput input
    ) async {
    try {
      await remoteDataSource.addUserLocationsForeground(
        input
      );
    } catch (e) {
      // エラーログ
      debugPrint("UserLocationsRepositoryImpl Error: $e");
      rethrow;
    }
  }

  @override
  Future<List<UserLocationsEntity>> fetchUserLocations(String userId) async {
    try {
      debugPrint("UserLocationsRepositoryImpl内");
      final userLocationsModel = await remoteDataSource.fetchUserLocations(userId);

      // ModelをEntityに変換
      final locations = userLocationsModel.map((model) => UserLocationsEntity(
        locationId: model.locationId,
        userId: model.userId,
        eventId: model.eventId,
        latitude: model.latitude,
        longitude: model.longitude,
        isBackground: model.isBackground,
        isActive: model.isActive,
      )).toList();

      return locations;
    } catch (e) {
      // エラーログ
      debugPrint("UserLocationsRepositoryImpl Error: $e");
      rethrow;
    }
  }
}
