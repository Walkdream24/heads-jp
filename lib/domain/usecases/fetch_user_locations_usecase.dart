import 'package:flutter/foundation.dart';
import '../entities/user_locations_entity.dart';
import '../repositories/user_locations_repository.dart';

class FetchUserLocationsUseCase {
  final UserLocationsRepository repository;

  FetchUserLocationsUseCase({required this.repository});

  Future<List<UserLocationsEntity>> execute(String userId) async {
    try {
      // リポジトリからリストを取得
      final locations = await repository.fetchUserLocations(userId);
      return locations;
    } catch (e) {
      // エラーログ
      debugPrint("FetchUserLocationsUseCase Error: $e");
      rethrow;
    }
  }
}
