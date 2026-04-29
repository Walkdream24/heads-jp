import 'package:flutter/material.dart';
import '../pages/event_register_page.dart';

class EventAddBanner extends StatelessWidget {
  final VoidCallback? onClose;
  final bool showCloseButton;

  const EventAddBanner({
    super.key,
    this.onClose,
    this.showCloseButton = false,
  });

  // EventRegisterPageに遷移するメソッド
  void _navigateToEventRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const EventRegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 閉じるボタン（showCloseButtonがtrueの場合のみ表示）
          if (showCloseButton)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          
          // バナー画像 - タップでEventRegisterPageに遷移
          GestureDetector(
            onTap: () => _navigateToEventRegister(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/event_recruitment_banner.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}