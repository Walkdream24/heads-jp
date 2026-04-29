import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/memories_remote_data_source.dart';
import '../../data/repositories/memories_repository_impl.dart';
import '../../domain/repositories/memories_repository.dart';
import '../providers/api_client_provider.dart';


final memoriesRemoteDataSourceProvider = Provider<MemoriesRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MemoriesRemoteDataSource(apiClient: apiClient);
});

final memoriesRepositoryProvider = Provider<MemoriesRepository>((ref) {
  final remoteDataSource = ref.watch(memoriesRemoteDataSourceProvider);
  return MemoriesRepositoryImpl(remoteDataSource: remoteDataSource);
});
