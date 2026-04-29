import 'package:flutter/material.dart';

/// ローディング中のフォローリストUI
class LoadingFollowList extends StatefulWidget {
  const LoadingFollowList({super.key});

  @override
  State<LoadingFollowList> createState() => _LoadingFollowListState();
}

class _LoadingFollowListState extends State<LoadingFollowList> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xFF1F1F1F),
      end: const Color(0xFF2C2C2C),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // ローディング中のアイテム数
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
          child: ListTile(
            leading: LoadingAvatar(colorAnimation: _colorAnimation),
            title: LoadingText(colorAnimation: _colorAnimation),
            subtitle: LoadingText(colorAnimation: _colorAnimation, width: 100),
          ),
        );
      },
    );
  }
}

/// ローディング中のアバター
class LoadingAvatar extends StatelessWidget {
  final Animation<Color?> colorAnimation;

  const LoadingAvatar({
    super.key,
    required this.colorAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorAnimation,
      builder: (context, child) {
        return CircleAvatar(
          radius: 24,
          backgroundColor: colorAnimation.value,
        );
      },
    );
  }
}

/// ローディング中のテキスト
class LoadingText extends StatelessWidget {
  final Animation<Color?> colorAnimation;
  final double width;

  const LoadingText({
    super.key,
    required this.colorAnimation,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorAnimation,
      builder: (context, child) {
        return Container(
          width: width,
          height: 16,
          decoration: BoxDecoration(
            color: colorAnimation.value,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}