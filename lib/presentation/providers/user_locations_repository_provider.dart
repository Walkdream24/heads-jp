import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/user_locations_remote_data_source.dart';
import '../../data/repositories/user_locations_repository_impl.dart';
import '../../domain/repositories/user_locations_repository.dart';
import '../providers/api_client_provider.dart';

final userLocationsRemoteDataSourceProvider = Provider<UserLocationsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserLocationsRemoteDataSource(apiClient: apiClient);
});


final userLocationsRepositoryProvider = Provider<UserLocationsRepository>((ref) {
  final remoteDataSource = ref.watch(userLocationsRemoteDataSourceProvider);
  return UserLocationsRepositoryImpl(remoteDataSource: remoteDataSource);
});
