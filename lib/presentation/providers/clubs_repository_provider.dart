import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/clubs_remote_data_source.dart';
import '../../data/repositories/clubs_repository_impl.dart';
import '../../domain/repositories/clubs_repository.dart';
import '../providers/api_client_provider.dart';

// ClubsRemoteDataSourceプロバイダー
final clubsRemoteDataSourceProvider = Provider<ClubsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ClubsRemoteDataSource(apiClient: apiClient);
});

// ClubsRepositoryプロバイダー
final clubsRepositoryProvider = Provider<ClubsRepository>((ref) {
  final remoteDataSource = ref.watch(clubsRemoteDataSourceProvider);
  return ClubsRepositoryImpl(remoteDataSource: remoteDataSource);
});
