import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/follows_remote_data_source.dart';
import '../../data/repositories/follows_repository_impl.dart';
import '../../domain/repositories/follows_repository.dart';
import '../providers/api_client_provider.dart';

// FollowsRemoteDataSourceプロバイダー
final followsRemoteDataSourceProvider = Provider<FollowsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FollowsRemoteDataSource(apiClient: apiClient);
});

// EventsRepositoryプロバイダー
final followsRepositoryProvider = Provider<FollowsRepository>((ref) {
  final remoteDataSource = ref.watch(followsRemoteDataSourceProvider);
  return FollowsRepositoryImpl(remoteDataSource: remoteDataSource);
});
