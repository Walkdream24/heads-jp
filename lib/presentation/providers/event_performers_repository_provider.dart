import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/event_performers_remote_data_source.dart';
import '../../data/repositories/event_performers_repository_impl.dart';
import '../../domain/repositories/event_performers_repository.dart';
import '../providers/api_client_provider.dart';

// EventPerformersRemoteDataSourceプロバイダー
final eventPerformersRemoteDataSourceProvider = Provider<EventPerformersRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EventPerformersRemoteDataSource(apiClient: apiClient);
});

// EventPerformersRepositoryプロバイダー
final eventPerformersRepositoryProvider = Provider<EventPerformersRepository>((ref) {
  final remoteDataSource = ref.watch(eventPerformersRemoteDataSourceProvider);
  return EventPerformersRepositoryImpl(remoteDataSource: remoteDataSource);
});
