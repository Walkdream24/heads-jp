# HEADS

クラブイベントに特化した音楽仲間と繋がるアプリ。

## アーキテクチャ

UseCase / Domain / Repository の3層 Clean Architecture を採用。UI から Firebase を直接呼ばず Repository 層を経由することで、変更の影響範囲を限定し保守性を向上。

```
Presentation（Widget + Riverpod Provider）
    ↓
Domain（UseCase・Entity・Repository Interface）
    ↓
Data（Repository 実装・DataSource・Firebase）
```

## 技術スタック

| カテゴリ | 技術 |
|---|---|
| フレームワーク | Flutter |
| 状態管理 | Riverpod + Freezed（イミュータブルモデル） |
| データベース | Cloud Firestore |
| 認証 | Firebase Authentication |
| ストレージ | Firebase Storage |
| プッシュ通知 | Firebase Cloud Messaging (FCM) |
| バックエンド | Cloud Functions v2（Node.js 20 / TypeScript） |
| 地図 | Mapbox（クラスタリング・近傍計算に Turf.js） |
| 外部連携 | AppsFlyer、AdMob、Slack Events API |

## 関連

詳細はポートフォリオを参照: https://nksg-portfolio.vercel.app/mobile/ichi-joho-club
