import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../domain/repositories/user_repository.dart';
import '../providers/api_client_provider.dart';

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRemoteDataSource(apiClient: apiClient);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userRemoteDataSource = ref.watch(userRemoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource: userRemoteDataSource);
});
