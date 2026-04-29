import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/api_client.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.firebaseAuth,required this.apiClient});

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  String? getCurrentUserId() {
    return firebaseAuth.currentUser?.uid;
  }

  Stream<User?> authStateChanges() {
    return firebaseAuth.authStateChanges();
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<User?> signIn(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }
  
  Future<String> signUp({
    required String username,
    required String headsId,
    required String email,
    required String password,
  }) async {
    final functionResult = await apiClient.call(
      apiName: 'signUpUserAccount',
      params: {
        'username': username,
        'headsId': headsId,
        'email': email,
        'password': password,
      },
    );
    debugPrint("リザルト$functionResult");
    return functionResult['token'] as String;
  }

  Future<void> deleteUserAccount(
    String userId,
    ) async {
    try {
      final result = await apiClient.call(
        apiName: 'deleteUserAccount',
        params: {
          'userId': userId,
        },
      );

      // 成功フラグを確認
      if (result['success'] != true) {
        throw Exception("デバイストークン登録に失敗しました: ${result['message']}");
      }
    } catch (e) {
      debugPrint("deleteUserAccount エラー: $e");
      rethrow;
    }
  }

  Future<void> resetPassword(
    String email,
    ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("resetPassword エラー: $e");
      rethrow;
    }
  }
}
