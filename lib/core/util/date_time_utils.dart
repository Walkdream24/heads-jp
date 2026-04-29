import 'package:intl/intl.dart';

// 日付と時間のフォーマット (yyyy-MM-dd HH:mm)
String formatDateTime(DateTime dateTime) {
  final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  return dateFormat.format(dateTime);
}

// 日付のみのフォーマット (yyyy-MM-dd)
String formatDate(DateTime dateTime) {
  final dateFormat = DateFormat('yyyy-MM-dd');
  return dateFormat.format(dateTime);
}

String getTimeAgo(String dateString) {
    // ISO 8601形式の文字列をDateTimeに変換
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date);

    // 1分未満
    if (difference.inMinutes < 1) {
      return 'たった今';
    }
    // 1時間未満
    else if (difference.inHours < 1) {
      return '${difference.inMinutes}分前';
    }
    // 24時間未満
    else if (difference.inDays < 1) {
      return '${difference.inHours}時間前';
    }
    // 7日未満
    else if (difference.inDays < 7) {
      return '${difference.inDays}日前';
    }
    // 4週間未満
    else if (difference.inDays < 28) {
      return '${(difference.inDays / 7).floor()}週間前';
    }
    // 12ヶ月未満
    else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}ヶ月前';
    }
    // それ以上
    else {
      return '${(difference.inDays / 365).floor()}年前';
    }
}