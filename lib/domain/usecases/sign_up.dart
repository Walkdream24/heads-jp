import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<String> execute({
    required String username,
    required String headsId,
    required String email,
    required String password,
  }) {
    return repository.signUp(
      username: username,
      headsId: headsId,
      email: email,
      password: password,
    );
  }
}
