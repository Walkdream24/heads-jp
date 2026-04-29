import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/events_remote_data_source.dart';
import '../../data/repositories/events_repository_impl.dart';
import '../../domain/repositories/events_repository.dart';
import '../providers/api_client_provider.dart';

// EventsRemoteDataSourceプロバイダー
final eventsRemoteDataSourceProvider = Provider<EventsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EventsRemoteDataSource(apiClient: apiClient);
});

// EventsRepositoryプロバイダー
final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  final remoteDataSource = ref.watch(eventsRemoteDataSourceProvider);
  return EventsRepositoryImpl(remoteDataSource: remoteDataSource);
});
