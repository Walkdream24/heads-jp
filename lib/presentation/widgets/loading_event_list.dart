import 'package:flutter/material.dart';

class LoadingEventList extends StatelessWidget {
  final int itemCount;
  const LoadingEventList({
    super.key,
    required this.itemCount
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, // リスト全体の高さ
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount, // ローディングアイテムの数
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 150, // ローディングカードの横幅
              child: LoadingCard(), // カスタムローディングカードを呼び出し
            ),
          );
        },
      ),
    );
  }
}

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
      duration: const Duration(seconds: 1), // アニメーションの持続時間
    )..repeat(reverse: true); // リバースでループ

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
          color: Colors.transparent, // カードの背景を透明に
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // イメージローディング
              SizedBox(
                height: 200,
                width: 150,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _colorAnimation.value, // アニメーションした色を適用
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 16,
                width: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _colorAnimation.value, // アニメーションした色を適用
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 16,
                width: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _colorAnimation.value, // アニメーションした色を適用
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
