/// Mapbox マップ上で使用するソースID・レイヤーID・設定値の定数定義
library;

// ──────────────────────────────────────────────
// Source IDs
// ──────────────────────────────────────────────
const kClubSourceId = 'club-source';
const kUserClusterSourceId = 'user-cluster-source';
const kCurrentUserSourceId = 'current-user-source';

// ──────────────────────────────────────────────
// Layer IDs
// ──────────────────────────────────────────────
const kClubIconOnlyLayerId = 'club-icon-only-layer';
const kClubIconWithTextLayerId = 'club-icon-with-text-layer';
const kCurrentUserLayerId = 'current-user-symbol-layer';
const kUnclusteredUserLayerId = 'unclustered-user-symbol-layer';

// ──────────────────────────────────────────────
// Image IDs
// ──────────────────────────────────────────────
const kClubMarkerImageId = 'red_marker.png';
const kCurrentUserImageId = 'current-user-icon';

// ──────────────────────────────────────────────
// Icon sizes
// ──────────────────────────────────────────────
const kClubIconSize = 0.35;
const kUnclusteredUserIconSize = 0.38;

// ──────────────────────────────────────────────
// Cluster tier configuration
// ──────────────────────────────────────────────

/// ユーザークラスターの段階設定
class UserClusterTier {
  const UserClusterTier({
    required this.name,
    required this.iconId,
    required this.iconSize,
    required this.badgeRadius,
    required this.badgeOffset,
    required this.textSize,
    required this.minCount,
    this.maxCount,
  });

  final String name;
  final String iconId;
  final double iconSize;
  final double badgeRadius;

  /// バッジの X/Y オフセット（右上に表示: [offset, -offset]）
  final double badgeOffset;
  final double textSize;

  /// この段階が適用される最小人数（この値より大きい場合に適用）
  final int minCount;

  /// この段階が適用される最大人数（null = 上限なし）
  final int? maxCount;

  /// Mapbox Expression フィルター
  List<Object> get filter {
    final conditions = <Object>['all', ['has', 'point_count']];
    if (minCount > 0) conditions.add(['>', 'point_count', minCount]);
    if (maxCount != null) conditions.add(['<=', 'point_count', maxCount!]);
    return conditions;
  }
}

/// ユーザークラスターの段階一覧（小 → 中 → 大）
const kUserClusterTiers = [
  UserClusterTier(
    name: 'small',
    iconId: 'small-cluster-icon',
    iconSize: 0.45,
    badgeRadius: 12,
    badgeOffset: 26,
    textSize: 13,
    minCount: 0,
    maxCount: 6,
  ),
  UserClusterTier(
    name: 'medium',
    iconId: 'medium-cluster-icon',
    iconSize: 0.50,
    badgeRadius: 14,
    badgeOffset: 30,
    textSize: 14,
    minCount: 6,
    maxCount: 12,
  ),
  UserClusterTier(
    name: 'large',
    iconId: 'large-cluster-icon',
    iconSize: 0.55,
    badgeRadius: 16,
    badgeOffset: 34,
    textSize: 15,
    minCount: 12,
  ),
];
