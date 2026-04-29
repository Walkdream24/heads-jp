import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/bookmark_clubs_remote_data_source.dart';
import '../../data/repositories/bookmark_clubs_repository_impl.dart';
import '../../domain/repositories/bookmark_clubs_repository.dart';
import '../providers/api_client_provider.dart';

final bookmarkClubsDataSourceProvider = Provider<BookmarkClubsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BookmarkClubsRemoteDataSource(apiClient: apiClient);
});

final bookmarkClubsRepositoryProvider = Provider<BookmarkClubsRepository>((ref) {
  final remoteDataSource = ref.watch(bookmarkClubsDataSourceProvider);
  return BookmarkClubsRepositoryImpl(remoteDataSource: remoteDataSource);
});
