import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../core/api_client.dart'; 

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ApiClient apiClient;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.apiClient
    });

  @override
  AuthUserEntity? getCurrentUser() {
    final user = remoteDataSource.getCurrentUser();
    if (user == null) return null;
    return AuthUserEntity(id: user.uid, email: user.email ?? "");
  }

  @override
  Stream<AuthUserEntity?> authStateChanges() {
    return remoteDataSource.authStateChanges().map((user) {
      if (user == null) return null;
      return AuthUserEntity(id: user.uid, email: user.email ?? "");
    });
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<AuthUserEntity?> signIn(String email, String password) async {
    final user = await remoteDataSource.signIn(email, password);
    if (user == null) return null;
    return AuthUserEntity(id: user.uid, email: user.email ?? "");
  }

  @override
  Future<String> signUp({
    required String username,
    required String headsId,
    required String email,
    required String password,
  }) {
    return remoteDataSource.signUp(
      username: username,
      headsId: headsId,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> deleteUserAccount(String userId) async {
    await remoteDataSource.deleteUserAccount(userId);
  }

  @override
  Future<void> resetPassword(String email) async {
    await remoteDataSource.resetPassword(email);
  }

}
