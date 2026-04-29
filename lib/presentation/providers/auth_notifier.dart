import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_user_entity.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/auth_state_changes.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async'; // StreamSubscriptionを使用するために追加

class AuthNotifier extends StateNotifier<AuthUserEntity?> {
  final GetCurrentUserUseCase _getCurrentUser;
  final AuthStateChangesUseCase _authStateChanges;
  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final SignOutUseCase _signOut;
  
  // 遅延通知用の変数
  bool _delayNotification = false;
  StreamSubscription<AuthUserEntity?>? _authStateSubscription;

  AuthNotifier(
    this._getCurrentUser,
    this._authStateChanges,
    this._signIn,
    this._signUp,
    this._signOut,
  ) : super(null) {
    _init();
  }

  void _init() {
    state = _getCurrentUser();
    // StreamSubscriptionを保持して後でコントロールできるようにする
    _authStateSubscription = _authStateChanges().listen((user) {
      if (!_delayNotification) {
        state = user;
      }
    });
  }
  
  // 通知遅延を設定するメソッド
  void setDelayNotification(bool delay) {
    _delayNotification = delay;
    // 遅延が解除されたら現在のユーザー状態を反映
    if (!delay) {
      state = _getCurrentUser();
    }
  }

  Future<void> login(String email, String password) async {
    state = await _signIn(email, password);
  }

  Future<void> register({
    required String username,
    required String headsId,
    required String email,
    required String password,
  }) async {
    final customToken = await _signUp.execute(
      username: username,
      headsId: headsId,
      email: email,
      password: password,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCustomToken(customToken);
    final user = userCredential.user;

    // 遅延フラグがセットされていない場合のみ状態を更新
    if (user != null && !_delayNotification) {
      state = AuthUserEntity(id: user.uid, email: user.email!);
    }
  }

  Future<void> logout() async {
    await _signOut();
    state = null;
  }
  
  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}