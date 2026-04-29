import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../providers/auth_provider.dart';
import '../providers/user_registration_provider.dart';
import '../widgets/sign_in_progress_bar.dart';
import '../widgets/custom_snackbar.dart';
import '../../core/util/error_helper.dart';

class PasswordInputPage extends ConsumerStatefulWidget {
  const PasswordInputPage({super.key});

  @override
  ConsumerState<PasswordInputPage> createState() => _PasswordInputPageState();
}

class _PasswordInputPageState extends ConsumerState<PasswordInputPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  bool _isValid = false;
  bool _isLoading = false;
  bool _showSuccessAnimation = false;
  late AnimationController _animationController;
  bool _isPasswordVisible = false;
  String? _errorText;

  final _passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_validatePassword);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  void _validatePassword() {
    final password = _controller.text;
    
    setState(() {
      if (password.isEmpty) {
        _errorText = null;
        _isValid = false;
      } else if (password.length < 8) {
        _errorText = '8文字以上で入力してください';
        _isValid = false;
      } else if (!password.contains(RegExp(r'[A-Za-z]'))) {
        _errorText = '英字を含めてください';
        _isValid = false;
      } else if (!password.contains(RegExp(r'[0-9]'))) {
        _errorText = '数字を含めてください';
        _isValid = false;
      } else if (!_passwordRegex.hasMatch(password)) {
        _errorText = '英数字のみを使用してください';
        _isValid = false;
      } else {
        _errorText = null;
        _isValid = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_isValid || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userRegistration = ref.read(userRegistrationProvider);
      final authNotifier = ref.read(authProvider.notifier);
      
      // アニメーション完了まで認証状態の更新を遅延させる
      authNotifier.setDelayNotification(true);

      // サインアップ処理
      await authNotifier.register(
        username: userRegistration.username!,
        headsId: userRegistration.headsId!,
        email: userRegistration.email!,
        password: _controller.text.trim(),
      );

      // 登録成功後、成功アニメーションを表示
      setState(() {
        _isLoading = false;
        _showSuccessAnimation = true;
      });
      
      // Lottieアニメーションを再生
      await _animationController.forward();
      
      // アニメーション完了後に遅延を解除
      authNotifier.setDelayNotification(false);

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

    } catch (error) {
      // エラー発生時は遅延を解除
      ref.read(authProvider.notifier).setDelayNotification(false);
      
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        CustomSnackBar.show(
          context: context,
          message: getLocalizedErrorMessage(error),
          isSuccess: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final double buttonBottomPosition = keyboardPadding > 0 ? keyboardPadding + 16 : 16;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SignInProgressBar(progressValue: 1.0),
                  const SizedBox(height: 150),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ログイン時にパスワードが必要です',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '8桁以上の英数字を入力してください',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _controller,
                          obscureText: !_isPasswordVisible,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF222222),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            errorText: _errorText,
                            errorStyle: const TextStyle(
                              color: Colors.red,
                              height: 0.8,
                            ),
                            errorMaxLines: 2,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        if (_errorText == null)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              '英字と数字を含む8文字以上で入力してください',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                height: 1.2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: buttonBottomPosition,
            right: 16,
            child: FloatingActionButton(
              onPressed: _isValid && !_isLoading ? _signUp : null,
              backgroundColor: _isValid && !_isLoading
                  ? Colors.white
                  : Colors.grey.withOpacity(0.3),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Icon(
                      Icons.arrow_forward,
                      color: _isValid ? Colors.black : Colors.grey,
                    ),
            ),
          ),
          if (_showSuccessAnimation)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Lottie.asset(
                  'assets/Animation - 1733401495297.json',
                  controller: _animationController,
                  onLoaded: (composition) {
                    _animationController.duration = composition.duration;
                  },
                ),
              ),
            ),
          if (_isLoading && !_showSuccessAnimation)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator()
              ),
            ),
        ],
      ),
    );
  }
}