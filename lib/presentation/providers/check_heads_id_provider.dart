import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_repository_provider.dart';
import '../../domain/usecases/check_heads_id_exists_usecase.dart';

final checkHeadsIdUseCaseProvider = Provider<CheckHeadsIdExistsUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return CheckHeadsIdExistsUseCase(repository: repository);
});

class HeadsIdValidationNotifier extends StateNotifier<AsyncValue<bool>> {
  final CheckHeadsIdExistsUseCase usecase;
  Timer? _debounceTimer;

  HeadsIdValidationNotifier({required this.usecase}) : super(const AsyncValue.data(false));

  Future<void> checkIdExists(String id) async {
    _debounceTimer?.cancel();

    if (id.isEmpty) {
      state = const AsyncValue.data(false);
      return;
    }

    _debounceTimer = Timer(const Duration(seconds: 1), () async {
      try {
        final exists = await usecase.execute(id);
        if (!mounted) return;
        state = AsyncValue.data(exists);
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

final headsIdValidationProvider = StateNotifierProvider<HeadsIdValidationNotifier, AsyncValue<bool>>((ref) {
  final usecase = ref.watch(checkHeadsIdUseCaseProvider);
  return HeadsIdValidationNotifier(usecase: usecase);
});