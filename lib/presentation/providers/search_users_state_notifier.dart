import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_summary_entity.dart';
import '../../domain/usecases/search_users_by_heads_id_usecase.dart';
import 'users_summary_repository_provider.dart';
import 'dart:async';

// UseCaseプロバイダー
final searchUsersByHeadsIdUseCaseProvider = Provider<SearchUsersByHeadsIdUseCase>((ref) {
  final repository = ref.watch(userSummaryRepositoryProvider);
  return SearchUsersByHeadsIdUseCase(repository: repository);
});

class SearchUsersNotifier extends StateNotifier<AsyncValue<List<UserSummaryEntity>>> {
  final SearchUsersByHeadsIdUseCase usecase;
  Timer? _debounceTimer;

  SearchUsersNotifier({required this.usecase}) : super(const AsyncValue.data([]));

  Future<void> searchUsers(String query) async {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    _debounceTimer = Timer(const Duration(seconds: 1), () async {
      try {
        final users = await usecase.execute(query);
        if (!mounted) return;
        state = AsyncValue.data(users);
      } catch (e, stack) {
        if (!mounted) return;
        state = AsyncValue.error(e, stack);
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final searchUsersProvider = StateNotifierProvider<SearchUsersNotifier, AsyncValue<List<UserSummaryEntity>>>((ref) {
  final usecase = ref.watch(searchUsersByHeadsIdUseCaseProvider);
  return SearchUsersNotifier(usecase: usecase);
});