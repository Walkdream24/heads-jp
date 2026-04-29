import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bookmark_clubs_entity.dart';
import '../../domain/usecases/add_bookmark_clubs_usecase.dart';
import '../../domain/usecases/delete_bookmark_clubs_usecase.dart';
import '../../domain/usecases/check_bookmark_club_usecase.dart';
import 'bookmark_clubs_repository_provider.dart';

final addBookmarkClubsUseCaseProvider = Provider<AddBookmarkClubsUseCase>((ref) {
  final repository = ref.watch(bookmarkClubsRepositoryProvider);
  return AddBookmarkClubsUseCase(repository: repository);
});

final addBookmarkClubsProvider = FutureProvider.family<void, BookmarkClubsByIds>((ref, input) async {
  final addBookmarkClubsUseCase = ref.watch(addBookmarkClubsUseCaseProvider);
  await addBookmarkClubsUseCase.execute(input);
});


final deleteBookmarkClubsUseCaseProvider = Provider<DeleteBookmarkClubsUseCase>((ref) {
  final repository = ref.watch(bookmarkClubsRepositoryProvider);
  return DeleteBookmarkClubsUseCase(repository: repository);
});

final deleteBookmarkClubsProvider = FutureProvider.family<void, BookmarkClubsByIds>((ref, input) async {
  final deleteBookmarkClubsUseCase = ref.watch(deleteBookmarkClubsUseCaseProvider);
  await deleteBookmarkClubsUseCase.execute(input);
});

final checkBookmarkClubUseCaseProvider = Provider<CheckBookmarkClubUseCase>((ref) {
  final repository = ref.watch(bookmarkClubsRepositoryProvider);
  return CheckBookmarkClubUseCase(repository: repository);
});