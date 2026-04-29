import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/user_summary_remote_data_source.dart';
import '../../data/repositories/user_summary_repository_impl.dart';
import '../../domain/repositories/user_summary_repository.dart';
import '../providers/api_client_provider.dart';

// DataSourceプロバイダー
final userSummaryRemoteDataSourceProvider = Provider<UserSummaryRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserSummaryRemoteDataSource(apiClient: apiClient);
});

// Repositoryプロバイダー
final userSummaryRepositoryProvider = Provider<UserSummaryRepository>((ref) {
  final remoteDataSource = ref.watch(userSummaryRemoteDataSourceProvider);
  return UserSummaryRepositoryImpl(remoteDataSource: remoteDataSource);
});
