import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/blocked_users_remote_data_source.dart';
import '../../data/repositories/blocked_users_repository_impl.dart';
import '../../domain/repositories/blocked_users_repository.dart';
import '../providers/api_client_provider.dart';

final blockedUsersDataSourceProvider = Provider<BlockedUsersRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BlockedUsersRemoteDataSource(apiClient: apiClient);
});

final blockedUsersRepositoryProvider = Provider<BlockedUsersRepository>((ref) {
  final remoteDataSource = ref.watch(blockedUsersDataSourceProvider);
  return BlockedUsersRepositoryImpl(remoteDataSource: remoteDataSource);
});
