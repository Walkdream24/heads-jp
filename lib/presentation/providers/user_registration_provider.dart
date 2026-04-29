import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRegistrationState {
  final String? username;
  final String? headsId;
  final String? email;
  final String? password;

  UserRegistrationState({
    this.username,
    this.headsId,
    this.email,
    this.password,
  });

  UserRegistrationState copyWith({
    String? username,
    String? headsId,
    String? email,
    String? password,
  }) {
    return UserRegistrationState(
      username: username ?? this.username,
      headsId: headsId ?? this.headsId,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

class UserRegistrationNotifier extends StateNotifier<UserRegistrationState> {
  UserRegistrationNotifier() : super(UserRegistrationState());

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setHeadsId(String headsId) {
    state = state.copyWith(headsId: headsId);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  UserRegistrationState get userData => state;
}

final userRegistrationProvider =
    StateNotifierProvider<UserRegistrationNotifier, UserRegistrationState>(
        (ref) => UserRegistrationNotifier());
