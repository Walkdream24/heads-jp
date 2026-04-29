// lib/presentation/providers/app_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// アプリの状態を管理するためのStateProvider
final deepLinkEventIdProvider = StateProvider<String?>((ref) => null);

// ディープリンク処理状態を管理
final deepLinkProcessedProvider = StateProvider<bool>((ref) => false);