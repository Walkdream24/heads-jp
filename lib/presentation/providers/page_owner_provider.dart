import 'package:flutter_riverpod/flutter_riverpod.dart';

/// マイページ or 他ユーザーのプロフィールページどちらかを判断管理する Provider
final isMyPageProvider = StateProvider<bool>((ref) => false);
