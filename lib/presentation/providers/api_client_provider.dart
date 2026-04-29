import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api_client.dart';

// ApiClientプロバイダー
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(); // 必要に応じて初期化コードを追加
});
