// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

/// API接続を行う場合はrepository内にて使用すること
class ApiClient {
  Future<dynamic> call({
    /// APIの名前
    required String apiName,

    /// リクエストパラメータ
    required Map<String, dynamic>? params,
  }) async {
    final callable = FirebaseFunctions.instanceFor(region:'asia-northeast1')
        .httpsCallable(
          apiName,
          options:
                HttpsCallableOptions(timeout: const Duration(seconds: 30)));
    final funcionResult = await callable.call<void>(params ?? {});
    // データベース書き込みの時間を考慮するため、100ms待機する
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return funcionResult.data;
  }
}
