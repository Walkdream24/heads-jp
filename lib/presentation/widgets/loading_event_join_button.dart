import 'package:flutter/material.dart';

class LoadingJoinEventButton extends StatefulWidget {
  const LoadingJoinEventButton({super.key});

  @override
  _LoadingJoinEventButtonState createState() => _LoadingJoinEventButtonState();
}

class _LoadingJoinEventButtonState extends State<LoadingJoinEventButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // アニメーションコントローラーを初期化
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // アニメーションの時間
    )..repeat(reverse: true); // アニメーションを繰り返し

    // 色のアニメーションを定義
    _colorAnimation = ColorTween(
      begin: const Color(0xFF444444), // 暗い色
      end: const Color(0xFF555555),   // 明るい色
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: null, // ローディング中はタップ不可
          child: SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _colorAnimation.value, // アニメーションした色を適用
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    '読み込み中...', // ローディング中のテキスト
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
