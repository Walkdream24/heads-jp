import 'package:flutter/material.dart';

class LoadingUserAvatarCategory extends StatefulWidget {
  const LoadingUserAvatarCategory({super.key});

  @override
  State<LoadingUserAvatarCategory> createState() => _LoadingUserAvatarCategoryState();
}

class _LoadingUserAvatarCategoryState extends State<LoadingUserAvatarCategory> with SingleTickerProviderStateMixin {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: LoadingAvatar(colorAnimation: _colorAnimation),
              );
            },
          ),
        ),
      ],
    );
  }
}

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
          radius: 30,
          backgroundColor: colorAnimation.value,
          child: SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorAnimation.value,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}