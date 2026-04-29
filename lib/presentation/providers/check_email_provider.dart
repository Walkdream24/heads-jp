import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_repository_provider.dart';
import '../../domain/usecases/check_email_exists_usecase.dart';

final checkEmailUseCaseProvider = Provider<CheckEmailExistsUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return CheckEmailExistsUseCase(repository: repository);
});

class EmailValidationNotifier extends StateNotifier<AsyncValue<bool>> {
  final CheckEmailExistsUseCase usecase;
  Timer? _debounceTimer;

  EmailValidationNotifier({required this.usecase}) : super(const AsyncValue.data(false));

  Future<void> checkEmailExists(String email) async {
    _debounceTimer?.cancel();

    if (email.isEmpty) {
      state = const AsyncValue.data(false);
      return;
    }

    _debounceTimer = Timer(const Duration(seconds: 1), () async {
      try {
        final exists = await usecase.execute(email);
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

final emailValidationProvider = StateNotifierProvider<EmailValidationNotifier, AsyncValue<bool>>((ref) {
  final usecase = ref.watch(checkEmailUseCaseProvider);
  return EmailValidationNotifier(usecase: usecase);
});