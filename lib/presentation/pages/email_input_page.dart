import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/password_input_page.dart';
import '../widgets/sign_in_progress_bar.dart';
import '../providers/user_registration_provider.dart';
import '../providers/check_email_provider.dart';

class EmailInputPage extends ConsumerStatefulWidget {
  const EmailInputPage({super.key});

  @override
  ConsumerState<EmailInputPage> createState() => _EmailInputPageState();
}

class _EmailInputPageState extends ConsumerState<EmailInputPage> {
  late TextEditingController _controller;
  bool _isValid = false;
  String? _errorText;
  bool _isCheckingEmail = false;

  // メールアドレスの正規表現パターン
  final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    caseSensitive: false,
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_validateEmail);
  }

  void _validateEmail() {
    final email = _controller.text.trim();
    
    setState(() {
      _isValid = false; // Reset validity
      
      if (email.isEmpty) {
        _errorText = null;
      } else if (!_emailRegex.hasMatch(email)) {
        _errorText = '正しいメールアドレスの形式で入力してください';
      } else {
        _errorText = null;
        _isCheckingEmail = true;
        // Trigger the email check
        ref.read(emailValidationProvider.notifier).checkEmailExists(email);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_isValid && !_isCheckingEmail) {
      ref.read(userRegistrationProvider.notifier).setEmail(_controller.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const PasswordInputPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the email validation state
    ref.listen<AsyncValue<bool>>(
      emailValidationProvider,
      (previous, current) {
        current.whenData((exists) {
          setState(() {
            _isCheckingEmail = false;
            if (exists) {
              _errorText = 'このメールアドレスは既に登録されています';
              _isValid = false;
            } else if (_controller.text.isNotEmpty && 
                      _emailRegex.hasMatch(_controller.text.trim())) {
              _errorText = null;
              _isValid = true;
            }
          });
        });
      },
    );

    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final double buttonBottomPosition = keyboardPadding > 0
        ? keyboardPadding + 16
        : 16;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SignInProgressBar(progressValue: 0.75),
                  const SizedBox(height: 150),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '登録にはメールアドレスが必要です',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'あなたのメールアドレスを教えてください',
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
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF222222),
                            hintText: '例: example@gmail.com',
                            hintStyle: const TextStyle(color: Colors.grey),
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
                            suffixIcon: _isCheckingEmail
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        ),
                        if (_errorText == null)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'メールアドレスの形式で入力してください',
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
              Positioned(
                bottom: buttonBottomPosition,
                right: 16,
                child: FloatingActionButton(
                  onPressed: (_isValid && !_isCheckingEmail) ? _goToNextPage : null,
                  backgroundColor: (_isValid && !_isCheckingEmail)
                      ? Colors.white
                      : Colors.grey.withOpacity(0.3),
                  child: Icon(
                    Icons.arrow_forward,
                    color: (_isValid && !_isCheckingEmail) ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}