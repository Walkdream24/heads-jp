import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/auth_state_changes.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/delete_user_account_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'auth_repository_provider.dart';
import 'auth_notifier.dart';

final getCurrentUserProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final authStateChangesProvider = Provider<AuthStateChangesUseCase>((ref) {
  return AuthStateChangesUseCase(ref.watch(authRepositoryProvider));
});

final signInProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

final signUpProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

final signOutProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

final deleteUserAccountUseCaseProvider = Provider<DeleteUserAccountUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return DeleteUserAccountUseCase(repository: repository);
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResetPasswordUseCase(repository: repository);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthUserEntity?>((ref) {
  final getCurrentUser = ref.watch(getCurrentUserProvider);
  final authStateChanges = ref.watch(authStateChangesProvider);
  final signIn = ref.watch(signInProvider);
  final signUp = ref.watch(signUpProvider);
  final signOut = ref.watch(signOutProvider);

  return AuthNotifier(
    getCurrentUser,
    authStateChanges,
    signIn,
    signUp,
    signOut,
  );
});

final deleteUserAccountProvider = FutureProvider.family<void, String>((ref, userId) async {
  final deleteUserAccountUseCase = ref.watch(deleteUserAccountUseCaseProvider);
  await deleteUserAccountUseCase.execute(userId);
});

final resetPasswordProvider = FutureProvider.family<void, String>((ref, email) async {
  final resetPasswordUseCase = ref.watch(resetPasswordUseCaseProvider);
  await resetPasswordUseCase.execute(email);
});
