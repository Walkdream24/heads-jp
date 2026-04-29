import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/user_events_guest_remote_data_source.dart';
import '../../data/repositories/user_events_guest_repository_impl.dart';
import '../../domain/repositories/user_events_guest_repository.dart';
import '../providers/api_client_provider.dart';

// UserEventsGuestRemoteDataSourceプロバイダー
final userEventsGuestRemoteDataSourceProvider = Provider<UserEventsGuestRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserEventsGuestRemoteDataSource(apiClient: apiClient);
});

// UserEventsGuestRepositoryプロバイダー
final userEventsGuestRepositoryProvider = Provider<UserEventsGuestRepository>((ref) {
  final remoteDataSource = ref.watch(userEventsGuestRemoteDataSourceProvider);
  return UserEventsGuestRepositoryImpl(remoteDataSource: remoteDataSource);
});
