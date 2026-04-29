import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/sign_in_progress_bar.dart';
import '../providers/user_registration_provider.dart';
import '../pages/email_input_page.dart';
import '../providers/check_heads_id_provider.dart';


class IdInputPage extends ConsumerStatefulWidget {
  const IdInputPage({super.key});

  @override
  ConsumerState<IdInputPage> createState() => _IdInputPageState();
}

class _IdInputPageState extends ConsumerState<IdInputPage> {
  late TextEditingController _controller;
  bool _isValid = false;
  static const int _maxLength = 20;
  final _validCharRegex = RegExp(r'^[a-z0-9._]*$');
  String? _errorText;
  bool _isCheckingId = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_validateInput);
  }

  void _validateInput() {
    final text = _controller.text;
    
    setState(() {
      _isValid = false; // Reset validity
      
      if (text.isEmpty) {
        _errorText = null;
      } else if (text.length > _maxLength) {
        _errorText = '20文字以内で入力してください';
      } else if (!_validCharRegex.hasMatch(text)) {
        _errorText = '半角英小文字、数字、ドット(.)、\nアンダーバー(_)のみ使用可能です';
      } else {
        _errorText = null;
        _isCheckingId = true;
        // Trigger the ID check
        ref.read(headsIdValidationProvider.notifier).checkIdExists(text);
      }
    });
  }

  void _goToNextPage() {
    if (_isValid) {
      ref.read(userRegistrationProvider.notifier).setHeadsId(_controller.text.trim());
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const EmailInputPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the ID validation state
    ref.listen<AsyncValue<bool>>(
      headsIdValidationProvider,
      (previous, current) {
        current.whenData((exists) {
          setState(() {
            _isCheckingId = false;
            if (exists) {
              _errorText = 'このIDは既に使用されています';
              _isValid = false;
            } else if (_controller.text.isNotEmpty && 
                      _controller.text.length <= _maxLength && 
                      _validCharRegex.hasMatch(_controller.text)) {
              _errorText = null;
              _isValid = true;
            }
          });
        });
      },
    );

    // Rest of the build method remains the same...
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;
    final double buttonBottomPosition = keyboardPadding > 0 ? keyboardPadding + 16 : 16;

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
                  const SignInProgressBar(progressValue: 0.50),
                  const SizedBox(height: 150),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'あなたのidを決めてください',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'あなたを表すオリジナルidです',
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
                            counterStyle: TextStyle(
                              color: _controller.text.length > _maxLength 
                                  ? Colors.red 
                                  : Colors.grey[600]
                            ),
                            filled: true,
                            fillColor: const Color(0xFF222222),
                            hintText: '例: heads_taro',
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
                            suffixIcon: _isCheckingId
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
                              '半角英小文字、数字、ドット(.)、\nアンダーバー(_)で入力してください',
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
                  onPressed: (_isValid && !_isCheckingId) ? _goToNextPage : null,
                  backgroundColor: (_isValid && !_isCheckingId)
                      ? Colors.white 
                      : Colors.grey.withOpacity(0.3),
                  child: Icon(
                    Icons.arrow_forward,
                    color: (_isValid && !_isCheckingId) ? Colors.black : Colors.grey,
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