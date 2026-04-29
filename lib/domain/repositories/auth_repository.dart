import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  AuthUserEntity? getCurrentUser();
  Stream<AuthUserEntity?> authStateChanges();
  Future<void> signOut();
  Future<AuthUserEntity?> signIn(String email, String password);
  Future<String> signUp({
    required String username,
    required String headsId,
    required String email,
    required String password,
  });
  Future<void> deleteUserAccount(String userId);
  Future<void> resetPassword(String email);
}
