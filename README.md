# HEADS

クラブイベントに特化した音楽仲間と繋がるアプリ。

## アーキテクチャ

UseCase / Domain / Repository の3層 Clean Architecture を採用。UI から Firebase を直接呼ばず Repository 層を経由することで、変更の影響範囲を限定し保守性を向上。

- **状態管理:** Flutter Riverpod + Freezed（イミュータブルモデル）
- **バックエンド:** Cloud Functions v2（Node.js 20 / TypeScript）
- **地図:** Mapbox（クラスタリング・近傍計算に Turf.js）
- **外部連携:** Firebase（Auth / Firestore / Storage / FCM）、AppsFlyer、AdMob、Slack Events API

詳細はポートフォリオを参照: https://nksg-portfolio.vercel.app/mobile/ichi-joho-club
