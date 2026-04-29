import 'package:cloud_firestore/cloud_firestore.dart';

/// エラーメッセージを日本語に変換する関数
String getLocalizedErrorMessage(dynamic error) {
  // FirestoreのエラーをチェックするLogic
  if (error is FirebaseException) {
    switch (error.code) {
      case 'permission-denied':
        return 'アクセス権限がありません';
      case 'not-found':
        return 'データが見つかりませんでした';
      case 'unavailable':
        return 'サービスが一時的に利用できません。後ほど再試行してください';
      case 'unauthenticated':
        return '認証エラーが発生しました。再度ログインしてください';
      case 'network-request-failed':
        return 'ネットワーク接続エラーが発生しました。インターネット接続を確認してください';
      case 'deadline-exceeded':
        return '処理がタイムアウトしました。後ほど再試行してください';
      default:
        return 'データ取得中にエラーが発生しました';
    }
  }
  
  // ネットワーク関連のエラー
  if (error.toString().contains('SocketException') || 
      error.toString().contains('ConnectionFailed')) {
    return 'ネットワークに接続できません。インターネット接続を確認してください';
  }
  
  // タイムアウトエラー
  if (error.toString().contains('TimeoutException')) {
    return 'サーバーからの応答がありません。後ほど再試行してください';
  }
  
  // パース関連のエラー
  if (error.toString().contains('FormatException')) {
    return 'データの形式に問題があります';
  }
  
  // 特定できない場合は汎用メッセージ
  return '予期せぬエラーが発生しました。後ほど再試行してください';
}