import 'package:flutter/material.dart';

class SharedDialogs {
  // プライベートコンストラクタでインスタンス化を防ぐ
  SharedDialogs._();

  static Future<void> showComingSoon(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "公開準備中",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "閉じる",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

//レビュー機能タブをタップした時に
    static Future<void> reviewComingSoon(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "イベント感想・レビュー機能公開準備中（7月中旬〜）",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "閉じる",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}