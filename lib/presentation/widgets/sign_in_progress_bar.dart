import 'package:flutter/material.dart';

class SignInProgressBar extends StatelessWidget {
  final double progressValue; // 進捗率（0.0～1.0）

  const SignInProgressBar({Key? key, required this.progressValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Stack(
        children: [
          // 背景バー
          Container(
            height: 8.0,
            decoration: BoxDecoration(
              color: Colors.grey[800], // 背景色
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          // 進捗バー
          FractionallySizedBox(
            widthFactor: progressValue, // 横幅を進捗率に応じて設定
            child: Container(
              height: 8.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF6C5EE3), // 開始色
                    Color(0xFF2F83EC), // 終了色
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
