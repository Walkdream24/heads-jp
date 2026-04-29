import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class AuthStateChangesUseCase {
  final AuthRepository repository;

  AuthStateChangesUseCase(this.repository);

  Stream<AuthUserEntity?> call() {
    return repository.authStateChanges();
  }
}
