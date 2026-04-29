import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/club_entity.dart';
import '../../domain/usecases/fetch_clubs_usecase.dart';
import '../../domain/usecases/fetch_all_clubs_info_usecase.dart';
import '../../domain/usecases/fetch_bookmark_clubs_usecase.dart';
import '../../domain/usecases/fetch_club_by_id_usecase.dart';
import 'clubs_repository_provider.dart';

// FetchClubsUseCaseプロバイダー
final fetchClubsUseCaseProvider = Provider<FetchClubsUseCase>((ref) {
  final repository = ref.watch(clubsRepositoryProvider);
  return FetchClubsUseCase(repository: repository);
});

// クラブリスト取得用のFutureProvider
final clubsProvider = FutureProvider<List<ClubEntity>>((ref) async {
  final fetchClubsUseCase = ref.watch(fetchClubsUseCaseProvider);
  return await fetchClubsUseCase.execute();
});

// FetchClubByIdUseCaseプロバイダー
final fetchClubByIdUseCaseProvider = Provider<FetchClubByIdUseCase>((ref) {
  final repository = ref.watch(clubsRepositoryProvider);
  return FetchClubByIdUseCase(repository: repository);
});

// クラブIDを指定してクラブを取得するFutureProvider
final fetchClubByIdProvider = FutureProvider.family<ClubEntity, String>((ref, clubId) async {
  final fetchClubByIdUseCase = ref.watch(fetchClubByIdUseCaseProvider);
  return await fetchClubByIdUseCase.execute(clubId);
});

final fetchAllClubsInfoUseCaseProvider = Provider<FetchAllClubsInfoUseCase>((ref) {
  final repository = ref.watch(clubsRepositoryProvider);
  return FetchAllClubsInfoUseCase(repository: repository);
});

final fetchAllClubsInfoProvider = FutureProvider<List<ClubInfoEntity>>((ref) async {
  final fetchAllClubsInfoUseCase = ref.watch(fetchAllClubsInfoUseCaseProvider);
  return await fetchAllClubsInfoUseCase.execute();
});

final fetchBookmarkClubsUseCaseProvider = Provider<FetchBookmarkClubsUseCase>((ref) {
  final repository = ref.watch(clubsRepositoryProvider);
  return FetchBookmarkClubsUseCase(repository: repository);
});


class BookmarkClubsStateNotifier extends StateNotifier<AsyncValue<List<ClubInfoEntity>>> { 
  final FetchBookmarkClubsUseCase _fetchBookmarkClubsUseCase;
  final String userId;

  BookmarkClubsStateNotifier({
    required FetchBookmarkClubsUseCase fetchBookmarkClubsUseCase,
    required this.userId,
  })  : _fetchBookmarkClubsUseCase = fetchBookmarkClubsUseCase,
        super(const AsyncLoading()) { // 初期状態を AsyncLoading に
    fetchBookmarkClubs();
  }

  Future<void> fetchBookmarkClubs() async {
    state = const AsyncLoading(); // ローディング状態を開始

    try {
      final clubs = await _fetchBookmarkClubsUseCase.execute(userId);
      state = AsyncData(clubs); // データ取得成功で AsyncData に
    } catch (e, stackTrace) {
      debugPrint("BookmarkClubsStateNotifierでエラー: $e");
      state = AsyncError(e, stackTrace); // エラー発生で AsyncError に
    }
  }

  Future<void> refetchClubs() async {
    await fetchBookmarkClubs();
  }
}

final bookmarkClubsStateNotifierProvider = StateNotifierProvider.family<
  BookmarkClubsStateNotifier, 
  AsyncValue<List<ClubInfoEntity>>, 
  String>((ref, userId) { 
    final fetchBookmarkClubsUseCase = ref.watch(fetchBookmarkClubsUseCaseProvider);
    return BookmarkClubsStateNotifier(
      fetchBookmarkClubsUseCase: fetchBookmarkClubsUseCase,
      userId: userId,
    );
});

