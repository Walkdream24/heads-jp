import 'package:flutter/material.dart';

class LoadingCard extends StatefulWidget {
  const LoadingCard({super.key});

  @override
  _LoadingCardState createState() => _LoadingCardState();
}

class _LoadingCardState extends State<LoadingCard> with SingleTickerProviderStateMixin {
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
      begin: const Color(0xFF1F1F1F), // 暗い色
      end: const Color(0xFF2C2C2C),   // 明るい色
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
        return Card(
          color: const Color(0xFF1F1F1F),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                  width: 200,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _colorAnimation.value, // アニメーションした色を適用
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: _colorAnimation.value, // アニメーションした色を適用
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
