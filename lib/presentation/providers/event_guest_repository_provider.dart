import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/event_guest_remote_data_source.dart';
import '../../data/repositories/event_guest_repository_impl.dart';
import '../../domain/repositories/event_guest_repository.dart';
import '../providers/api_client_provider.dart';

// EventGuestRemoteDataSourceプロバイダー
final eventGuestRemoteDataSourceProvider = Provider<EventGuestRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EventGuestRemoteDataSource(apiClient: apiClient);
});

// EventGuestRepositoryプロバイダー
final eventGuestRepositoryProvider = Provider<EventGuestRepository>((ref) {
  final remoteDataSource = ref.watch(eventGuestRemoteDataSourceProvider);
  return EventGuestRepositoryImpl(remoteDataSource: remoteDataSource);
});
