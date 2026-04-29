import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/device_token_remote_data_source.dart';
import '../../data/repositories/device_token_repository_impl.dart';
import '../../domain/repositories/device_token_repository.dart';
import '../providers/api_client_provider.dart';

final deviceTokenRemoteDataSourceProvider = Provider<DeviceTokenRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DeviceTokenRemoteDataSource(apiClient: apiClient);
});

final deviceTokenRepositoryProvider = Provider<DeviceTokenRepository>((ref) {
  final remoteDataSource = ref.watch(deviceTokenRemoteDataSourceProvider);
  return DeviceTokenRepositoryImpl(remoteDataSource: remoteDataSource);
});
