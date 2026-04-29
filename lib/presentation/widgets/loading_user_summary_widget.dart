import 'package:flutter/material.dart';

class LoadingUserSummaryWidget extends StatefulWidget {
  const LoadingUserSummaryWidget({super.key});

  @override
  State<LoadingUserSummaryWidget> createState() => _LoadingUserSummaryWidgetState();
}

class _LoadingUserSummaryWidgetState extends State<LoadingUserSummaryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
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
        return Row(
          children: [
            ClipOval(
              child: Container( // Shimmer適用
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container( // Shimmer適用
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                  ),
                ),
                const SizedBox(height: 4),
                Container( // Shimmer適用
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}