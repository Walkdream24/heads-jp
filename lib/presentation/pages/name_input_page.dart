import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/id_input_page.dart';
import '../widgets/sign_in_progress_bar.dart';
import '../providers/user_registration_provider.dart';

class NameInputPage extends ConsumerStatefulWidget {
  const NameInputPage({super.key});

  @override
  ConsumerState<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends ConsumerState<NameInputPage> {
  late final TextEditingController _controller;
  bool _isExceedingLimit = false;
  static const int _maxLength = 20;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      _validateInput();
      ref.read(userRegistrationProvider.notifier).setUsername(_controller.text);
      setState(() {});
    });
  }

  void _validateInput() {
    setState(() {
      _isExceedingLimit = _controller.text.length > _maxLength;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_controller.text.isNotEmpty && !_isExceedingLimit) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const IdInputPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final double buttonBottomPosition =
        keyboardPadding > 0 ? keyboardPadding + 16 : 16;
    final isTextValid = _controller.text.isNotEmpty && !_isExceedingLimit;

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
                  const SignInProgressBar(progressValue: 0.25),
                  const SizedBox(height: 150),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'こんにちは！',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'あなたの名前を教えてください',
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
                          decoration: InputDecoration(
                            counterText: '${_controller.text.length}/$_maxLength',
                            counterStyle: TextStyle(color: Colors.grey[600]),
                            filled: true,
                            fillColor: const Color(0xFF222222),
                            hintText: '例: ヘッズ太郎',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => FocusScope.of(context).unfocus(),
                        ),
                        if (_isExceedingLimit)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              '文字数制限を超えています。20文字以内にしてください',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.0,
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
                  onPressed: isTextValid ? _goToNextPage : null,
                  backgroundColor: isTextValid
                      ? Colors.white
                      : Colors.grey.withOpacity(0.3),
                  child: Icon(
                    Icons.arrow_forward,
                    color: isTextValid ? Colors.black : Colors.grey,
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