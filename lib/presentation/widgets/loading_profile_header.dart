import 'package:flutter/material.dart';

class LoadingProfileHeader extends StatefulWidget {
  const LoadingProfileHeader({super.key});

  @override
  _LoadingProfileHeaderState createState() => _LoadingProfileHeaderState();
}

class _LoadingProfileHeaderState extends State<LoadingProfileHeader> with SingleTickerProviderStateMixin {
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
    return Stack(
      children: [
        // ヘッダー画像のローディング部分
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: 440,
              color: _colorAnimation.value,
            );
          },
        ),
        // グラデーションオーバーレイ
        Container(
          height: 440,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.9),
                Colors.black,
              ],
              stops: const [0.0, 0.4, 0.6, 1.0],
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 名前のローディング部分
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 200,
                    height: 28,
                    color: _colorAnimation.value,
                  );
                },
              ),
              const SizedBox(height: 16),
              // ボタンのローディング部分
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 左側のアイコン
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.only(right: 10),
                            color: _colorAnimation.value,
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Container(
                            width: 20,
                            height: 20,
                            color: _colorAnimation.value,
                          );
                        },
                      ),
                    ],
                  ),
                  // ボタンのローディング部分
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Container(
                        width: 100,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _colorAnimation.value,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // フォロワー情報のローディング部分
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Container(
                    width: 150,
                    height: 14,
                    color: _colorAnimation.value,
                  );
                },
              ),
              const SizedBox(height: 16),
              // 紹介文のローディング部分
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          width: double.infinity,
                          height: 14,
                          color: _colorAnimation.value,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // フォロワーのアバター部分
              Row(
                children: List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CircleAvatar(
                          radius: 12,
                          backgroundColor: _colorAnimation.value,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
