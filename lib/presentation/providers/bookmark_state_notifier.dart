import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/bookmark_clubs_entity.dart';
import '../../domain/usecases/check_bookmark_club_usecase.dart';
import '../providers/bookmark_clubs_provider.dart';

class BookmarkStateNotifier extends StateNotifier<bool> {
  final CheckBookmarkClubUseCase checkBookmarkClubUseCase;
  
  BookmarkStateNotifier({
    required this.checkBookmarkClubUseCase,
  }) : super(false);  // 初期状態は未ブックマーク

  Future<void> checkBookmarkStatus(BookmarkClubsByIds input) async {
    try {
      final isBookmarked = await checkBookmarkClubUseCase.execute(input);
      state = isBookmarked;
    } catch (e) {
      debugPrint('Error checking bookmark status: $e');
      // エラー時の処理
    }
  }
  
  // 即時反応のためのトグルメソッドを追加
  void toggleBookmark() {
    state = !state;
  }
}

// Provider定義
final bookmarkStateNotifierProvider = StateNotifierProvider.family<BookmarkStateNotifier, bool, String>((ref, clubId) {
  final checkBookmarkUseCase = ref.watch(checkBookmarkClubUseCaseProvider);
  return BookmarkStateNotifier(
    checkBookmarkClubUseCase: checkBookmarkUseCase,
  );
});