// lib/presentation/pages/full_map_page.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../widgets/club_detail_modal.dart';
import '../../domain/entities/marker_entity.dart';
import '../widgets/top_buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/util/location_util.dart';
import '../../core/util/user_default_icon_util.dart';
import '../providers/current_user_animation_provider.dart';
import '../../core/util/marker_image_util.dart';
import '../../core/util/map_constants.dart';
import '../../domain/entities/current_user_location_entity.dart';
import '../../domain/entities/user_locations_entity.dart';
import '../../domain/entities/user_summary_entity.dart';
import '../providers/current_location_provider.dart';
import '../providers/user_provider.dart';
import '../providers/clubs_provider.dart';
import '../providers/user_locations_provider.dart';
import '../providers/users_summary_provider.dart';
import '../providers/profile_header_state.dart';
import '../providers/notifications_provider.dart';
import '../providers/push_notification_state.dart';
import 'package:HEADS/domain/entities/profile_header_entity.dart';
import '../../core/util/firebase_messaging_service.dart';
import '../widgets/location_settings_modal.dart';
import '../widgets/nearby_event_modal.dart';
import '../providers/nearby_events_modal_state.dart';
import '../widgets/current_location_button.dart';


class FullMapPage extends ConsumerStatefulWidget {
  const FullMapPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FullMapPageState();
}

class _FullMapPageState extends ConsumerState<FullMapPage> {
  MapboxMap? mapboxMap;
  Timer? animationTimer;
  double currentIconSize = 0.35;
  bool isGrowing = true; // 拡大中か縮小中かを追跡
  List<ClubMarkerEntity> clubMarkers = [];
  List<UserLocationsEntity> userLocations = [];
  List<UserSummaryEntity> userSummaries = [];
  // ローディング状態の管理
  bool _isInitialLoadingComplete = false;  // 初期ローディング（自分の位置情報など）
  bool _isLoadingClubs = false;            // クラブ情報のローディング
  bool _isLoadingUsers = false;            // ユーザー情報のローディング
  CurrentUserLocation? _initialLocation; 

  @override
  void initState() {
    super.initState();
    debugPrint("FullMapPage内");
    _initializeMessaging();
  }

  @override
  void dispose() {
    // タイマーを解放
    animationTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeMessaging() async {
    final user = await ref.read(currentUserProvider.future);
    await ref.read(firebaseMessagingServiceProvider).initialize(user.uid);
    final hasUnread = await ref.read(checkUnReadNotificationsProvider(user.uid).future);
    if (hasUnread) {
      ref.read(notificationProvider.notifier).setUnreadCount(1);
    }
  }

  Future<void> _initializeClubMarkers() async {
    setState(() => _isLoadingClubs = true);
    try {
      // 1. クラブデータの取得と変換
      final clubs = await ref.read(clubsProvider.future);
      debugPrint("initializeClubMarkers内でclubsProvider呼び出し$clubs");

      clubMarkers = clubs.map((club) {
        debugPrint("clubMarkerModelに変換${club.clubName}");
        return ClubMarkerEntity(
          Position(club.longitude, club.latitude),
          club.clubName,
          'red_marker.png',
          club.clubId,
        );
      }).toList();

      if (mapboxMap != null) {
        // 2. まずアイコン画像をスタイルに追加
        await MarkerImageUtil.addClubImagesToStyle(mapboxMap!, clubMarkers);

        // 3. その後でマーカーを地図に追加
        await _addClubMarkersToMap();
      }

      // 4. ユーザー関連データの取得（必要な場合）
      // 現在のユーザーIDを取得
      final currentUser = await ref.read(currentUserProvider.future);
      userLocations = await ref.read(userLocationsProvider(currentUser.uid).future);
      final userIds = userLocations.map((location) => location.userId).toList();
      userSummaries = await ref.read(usersSummaryProvider(userIds).future);

    } catch (e) {
      debugPrint('Error initializing club markers: $e');
    } finally {
      setState(() => _isLoadingClubs = false);
    }
  }

  Future<void> _addClubMarkersToMap() async {
    if (mapboxMap == null) return;

    final geoJsonString = jsonEncode(_buildClubGeoJson());

    try {
      final sourceExists = await mapboxMap!.style.styleSourceExists(kClubSourceId);
      if (sourceExists) {
        await mapboxMap!.style.setStyleSourceProperty(kClubSourceId, 'data', geoJsonString);
      } else {
        await mapboxMap!.style.addSource(GeoJsonSource(
          id: kClubSourceId,
          data: geoJsonString,
        ));
      }

      // アイコンのみ表示するレイヤー（低ズームレベル用）
      await mapboxMap!.style.addLayer(SymbolLayer(
        id: kClubIconOnlyLayerId,
        sourceId: kClubSourceId,
        iconImage: kClubMarkerImageId,
        iconSize: kClubIconSize,
        iconAllowOverlap: true,
        maxZoom: 11.99999999,
        symbolSortKey: 20,
      ));

      // アイコン＋テキスト表示レイヤー（高ズームレベル用）
      await mapboxMap!.style.addLayer(SymbolLayer(
        id: kClubIconWithTextLayerId,
        sourceId: kClubSourceId,
        iconImage: kClubMarkerImageId,
        iconSize: kClubIconSize,
        iconAllowOverlap: true,
        textField: '{name}',
        textSize: 12,
        textOffset: [0, -1.5],
        textColor: 0xFF000000,
        textHaloColor: 0xFFFFFFFF,
        textHaloWidth: 2.0,
        textAllowOverlap: true,
        textIgnorePlacement: false,
        textVariableAnchor: ['top', 'bottom', 'left', 'right', 'top-left', 'top-right', 'bottom-left', 'bottom-right'],
        symbolSortKey: 1,
        textMaxWidth: 12,
        textJustify: TextJustify.CENTER,
        textOpacity: 1.0,
        minZoom: 12,
      ));
    } catch (e) {
      debugPrint('Error adding club markers to map: $e');
    }
  }

  Map<String, dynamic> _buildClubGeoJson() {
    return {
      'type': 'FeatureCollection',
      'features': clubMarkers.map((marker) => {
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          'coordinates': [marker.position.lng, marker.position.lat],
        },
        'properties': {
          'name': marker.name,
          'id': marker.clubId,
          'icon': kClubMarkerImageId,
        },
      }).toList(),
    };
  }

  Map<String, dynamic> _buildCurrentUserGeoJson(double longitude, double latitude) {
    return {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [longitude, latitude],
          },
          'properties': {'currentUser': true},
        },
      ],
    };
  }

  Future<void> _addClusteredUserMarkers() async {
    if (mapboxMap == null) return;

    // ソースが既に存在する場合はスキップ（重複追加防止）
    final sourceExists = await mapboxMap!.style.styleSourceExists(kUserClusterSourceId);
    if (sourceExists) return;

    await Future.wait([
      MarkerImageUtil.addClusteredImagesToStyle(mapboxMap!),
      MarkerImageUtil.addUsersImagesToStyle(mapboxMap!, userSummaries),
    ]);

    final geoJsonString = jsonEncode(_buildUserClusterGeoJson());
    await mapboxMap!.style.addSource(GeoJsonSource(
      id: kUserClusterSourceId,
      data: geoJsonString,
      cluster: true,
      clusterMaxZoom: 14,
      clusterRadius: 50,
    ));

    // ユーザーが存在する場合のみレイヤーを追加
    final hasUsers = userSummaries.any((s) => s.profilePhotoUrl.isNotEmpty);
    if (!hasUsers) return;

    await _addUserClusterLayers();

    // 非クラスターユーザーアイコンレイヤー
    await mapboxMap!.style.addLayer(SymbolLayer(
      id: kUnclusteredUserLayerId,
      sourceId: kUserClusterSourceId,
      filter: ['!', ['has', 'point_count']],
      iconImage: '{icon}',
      iconSize: kUnclusteredUserIconSize,
      iconAllowOverlap: true,
      symbolSortKey: 50,
    ));
  }

  /// クラスター段階ごとにアイコン・バッジ・カウントの3レイヤーを追加
  Future<void> _addUserClusterLayers() async {
    for (final tier in kUserClusterTiers) {
      // クラスターアイコンレイヤー
      await mapboxMap!.style.addLayer(SymbolLayer(
        id: 'user-cluster-symbol-layer-${tier.name}',
        sourceId: kUserClusterSourceId,
        filter: tier.filter,
        iconImage: tier.iconId,
        iconSize: tier.iconSize,
        iconAllowOverlap: true,
        symbolSortKey: 40,
      ));

      // カウントバッジ背景（円）レイヤー
      await mapboxMap!.style.addLayer(CircleLayer(
        id: 'user-cluster-count-bg-${tier.name}',
        sourceId: kUserClusterSourceId,
        filter: tier.filter,
        circleRadius: tier.badgeRadius,
        circleColor: 0xFF000000,
        circleTranslate: [tier.badgeOffset, -tier.badgeOffset],
      ));

      // カウント数字レイヤー
      await mapboxMap!.style.addLayer(SymbolLayer(
        id: 'user-cluster-count-${tier.name}',
        sourceId: kUserClusterSourceId,
        filter: tier.filter,
        textField: '{point_count}',
        textSize: tier.textSize,
        textFont: ['Open Sans Bold'],
        textColor: 0xFFFFFFFF,
        textTranslate: [tier.badgeOffset, -tier.badgeOffset],
        textAllowOverlap: true,
        textIgnorePlacement: true,
      ));
    }
  }

  Map<String, dynamic> _buildUserClusterGeoJson() {
    final features = <Map<String, dynamic>>[];

    for (final location in userLocations) {
      final summary = userSummaries.firstWhere(
        (s) => s.uid == location.userId,
        orElse: () => UserSummaryEntity(uid: '', username: '', profilePhotoUrl: '', headsId: ''),
      );
      if (summary.profilePhotoUrl.isEmpty) continue;

      features.add({
        'type': 'Feature',
        'geometry': {
          'type': 'Point',
          'coordinates': [location.longitude, location.latitude],
        },
        'properties': {
          'name': summary.headsId,
          'icon': summary.profilePhotoUrl.split('/').last,
        },
      });
    }

    return {'type': 'FeatureCollection', 'features': features};
  }

  Future<void> _updateCurrentUserMarkerRotation() async {
    if (mapboxMap == null) return;
    try {
      await mapboxMap!.style.updateLayer(SymbolLayer(
        id: kCurrentUserLayerId,
        sourceId: kCurrentUserSourceId,
        iconImage: kCurrentUserImageId,
        iconSize: currentIconSize,
        iconAllowOverlap: true,
        iconIgnorePlacement: true,
        symbolSortKey: 10,
      ));
    } catch (e) {
      debugPrint('Error updating marker rotation: $e');
    }
  }

  Future<void> _onMapTap(MapContentGestureContext mapContentGestureContext) async {
    if (mapboxMap == null) return;

    try {
      final List<QueriedRenderedFeature?> features = await mapboxMap!.queryRenderedFeatures(
        RenderedQueryGeometry.fromScreenCoordinate(mapContentGestureContext.touchPosition),
        RenderedQueryOptions(layerIds: [
          kClubIconOnlyLayerId,
          kClubIconWithTextLayerId,
          kCurrentUserLayerId,
        ]),
      );

      if (features.isNotEmpty) {
        final feature = features.first!;

        // プロパティを取得し、型をキャスト
        final properties = (feature.queriedFeature.feature['properties'] as Map?)?.cast<String, dynamic>();

        // クラブマーカーの場合
        if (properties != null && properties.containsKey('name')) {
          debugPrint("クラブマーカータップ1");
          _onClubMarkerTapped(feature);
        }
        // 現在地マーカーの場合
        else if (properties != null && properties.containsKey('currentUser')) {
          if (!mounted) return;
          unawaited(showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const LocationSettingsModal(),
          ));
        }
      }
    } catch (e) {
      debugPrint('Error in _onMapTap: $e');
    }
  }

  void _onClubMarkerTapped(QueriedRenderedFeature feature) {
    final properties = feature.queriedFeature.feature["properties"] as Map?;
    final clubId = properties?['id'] as String?; // clubIdを取得

    if (clubId != null) {
      _showClubModal(context, clubId);
    }
  }

  Future<void> _onCurrentUserMarkerTapped() async {
    if (mapboxMap == null) return;

    try {
      final position = await LocationUtil.getCurrentPosition();

      await mapboxMap!.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(position.longitude, position.latitude)),
          zoom: 18.0,
          pitch: 0,
        ),
        MapAnimationOptions(duration: 2000, startDelay: 0),
      );

      // _updateCurrentUserMarker に処理を委譲（GeoJSON構築の重複を排除）
      await _updateCurrentUserMarker(CurrentUserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      debugPrint('Error in _onCurrentUserMarkerTapped: $e');
    }
  }

  void _showClubModal(BuildContext context, String clubId) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ClubDetailModal(clubId: clubId),
    );
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    try {
      // 1. 必須の初期処理
      await _initializeEssentials(mapboxMap);

      // 2. 非同期でその他のコンテンツを読み込み（完了待ちは不要）
      unawaited(_loadSecondaryContent(mapboxMap));

    } catch (e) {
      debugPrint('マップ初期化エラー: $e');
    }
  }

  Future<void> _initializeEssentials(MapboxMap mapboxMap) async {
    setState(() => _isInitialLoadingComplete = false);

    try {
      // 位置情報の許可後、現在地を取得
      await LocationUtil.checkAndRequestPermission();
      final position = await LocationUtil.getCurrentPosition();

      if (mounted) {
        setState(() {
          _initialLocation = CurrentUserLocation(
            latitude: position.latitude,
            longitude: position.longitude,
          );
        });
      }

      // カメラ位置の設定
      unawaited(mapboxMap.setCamera(CameraOptions(
        center: Point(coordinates: Position(position.longitude, position.latitude)),
        zoom: 14,
        pitch: 0,
      )));

      // 現在のユーザー情報の取得と現在地マーカーの追加を並列処理
      await Future.wait([
        _addCurrentUserLocation(mapboxMap),
      ]);

      // UI要素の無効化
      unawaited(mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false)));
      unawaited(mapboxMap.compass.updateSettings(CompassSettings(enabled: false)));

    } finally {
      setState(() => _isInitialLoadingComplete = true);
    }
  }

  Future<void> _loadSecondaryContent(MapboxMap mapboxMap) async {
    // クラブ情報の読み込み
    setState(() => _isLoadingClubs = true);
    try {
      await _initializeClubMarkers();
    } finally {
      setState(() => _isLoadingClubs = false);
    }

    // ユーザー情報の読み込み
    setState(() => _isLoadingUsers = true);
    try {
      await _addClusteredUserMarkers();
      await mapboxMap.style.moveStyleLayer(kCurrentUserLayerId, null);
    } finally {
      setState(() => _isLoadingUsers = false);
    }
  }



  Future<void> _addCurrentUserLocation(MapboxMap mapboxMap) async {
    // 現在地の取得
    final position = await LocationUtil.getCurrentPosition();

    // プロフィール画像を取得 (RiverpodのcurrentUserProviderを使用)
    final userAsyncValue = await ref.watch(currentUserProvider.future);

    String currentUserIconPath = await UserDefaultIconUtil.getOrGenerateUserIcon(
        userName: userAsyncValue.username
    );
    const imageId = kCurrentUserImageId;

    ref.read(addUserLocationsForegroundProvider(
      AddUserLocationInput(
        userId: userAsyncValue.uid,
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    ));

    debugPrint("プロフィール画像取得開始: ${userAsyncValue.profilePhotoUrl}");

    if (userAsyncValue.profilePhotoUrl != null && userAsyncValue.profilePhotoUrl!.isNotEmpty) {
      currentUserIconPath = userAsyncValue.profilePhotoUrl!;
      debugPrint("使用するプロフィール画像URL: $currentUserIconPath");

      // ネットワーク画像を使用して Mapbox スタイルに追加
      try {
        debugPrint("ネットワーク画像をスタイルに追加開始: $imageId");
        await MarkerImageUtil.addNetworkImageToStyle(
          mapboxMap,
          currentUserIconPath,
          imageId: imageId,
        );
        debugPrint("ネットワーク画像をスタイルに追加成功: $imageId");

      } catch (e) {
        debugPrint("ネットワーク画像追加中のエラー: $e");
      }
    } else {
      debugPrint("デフォルト画像を使用: $currentUserIconPath");
      // 2. Firebase Storageにアップロード（非同期）
      // デフォルトアイコンをStorage非同期アップロード（完了待ちは不要）
      unawaited(
        UserDefaultIconUtil.uploadToStorageAndRegisterInFirestore(
          filePath: currentUserIconPath,
          userId: userAsyncValue.uid,
        ).then((downloadUrl) {
          ref.read(profileHeaderProvider(userAsyncValue.uid).notifier).forceUpdate();
        }).catchError((Object error) {
          debugPrint('デフォルトアイコンのアップロードエラー: $error');
        }),
      );
      try {
        // ローカル画像を使用して Mapbox スタイルに追加
        debugPrint("ローカル画像をスタイルに追加開始: $currentUserIconPath");
        await MarkerImageUtil.addCurrentUserIconToStyle(
          mapboxMap,
          currentUserIconPath, // デフォルト画像
          outerColor: Colors.blue,
          innerColor: const Color.fromARGB(255, 113, 188, 249),
          strokeWidth: 6.0,
          radius: 20.0,
        );
        debugPrint("ローカル画像をスタイルに追加成功: $currentUserIconPath");
      } catch (e) {
        debugPrint("ローカル画像追加中のエラー: $e");
      }
    }

    // 現在地GeoJSONソースを追加
    await mapboxMap.style.addSource(GeoJsonSource(
      id: kCurrentUserSourceId,
      data: jsonEncode(_buildCurrentUserGeoJson(position.longitude, position.latitude)),
    ));

    // 現在地専用SymbolLayerを追加
    await mapboxMap.style.addLayer(SymbolLayer(
      id: kCurrentUserLayerId,
      sourceId: kCurrentUserSourceId,
      iconImage: imageId,
      iconSize: currentIconSize,
      iconAllowOverlap: true,
      iconIgnorePlacement: true,
      symbolSortKey: 100,
    ));

    _startAnimation();
  }

  Future<void> _updateCurrentUserMarker(CurrentUserLocation location) async {
    if (mapboxMap == null) return;

    try {
      final geoJsonString = jsonEncode(
        _buildCurrentUserGeoJson(location.longitude, location.latitude),
      );

      final sourceExists = await mapboxMap!.style.styleSourceExists(kCurrentUserSourceId);
      if (sourceExists) {
        await mapboxMap!.style.setStyleSourceProperty(kCurrentUserSourceId, 'data', geoJsonString);
      } else {
        await mapboxMap!.style.addSource(GeoJsonSource(
          id: kCurrentUserSourceId,
          data: geoJsonString,
        ));

        if (!(await mapboxMap!.style.styleLayerExists(kCurrentUserLayerId))) {
          await mapboxMap!.style.addLayer(SymbolLayer(
            id: kCurrentUserLayerId,
            sourceId: kCurrentUserSourceId,
            iconImage: kCurrentUserImageId,
            iconSize: currentIconSize,
            iconAllowOverlap: true,
            iconIgnorePlacement: true,
            symbolSortKey: 100,
          ));
        }
      }
    } catch (e) {
      debugPrint('Error updating current user marker: $e');
    }
  }

  void _startAnimation() {
    // 既存のタイマーをキャンセルしてから新しいタイマーを作成
    animationTimer?.cancel();
    animationTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // アニメーションプロバイダーを更新
      ref.read(animationProvider.notifier).animate();

      // Mapbox の SymbolLayer を更新 (レイヤー全体を再作成するのではなくプロパティを更新)
      final newIconSize = ref.read(animationProvider);
      unawaited(mapboxMap?.style.updateLayer(SymbolLayer(
        id: kCurrentUserLayerId,
        sourceId: kCurrentUserSourceId,
        iconImage: kCurrentUserImageId,
        iconSize: newIconSize,
        iconAllowOverlap: true,
        iconIgnorePlacement: true,
        symbolSortKey: 10,
      )));
    });
  }
  Future<void> _updateCurrentUserMarkerWithNewProfile(String? newProfilePhotoUrl) async {
    if (mapboxMap == null) return;

    try {
      // 現在地の取得
      final position = await LocationUtil.getCurrentPosition();

      // 新しいプロフィール画像を使用してアイコンを更新
      const imageId = kCurrentUserImageId;
      if (newProfilePhotoUrl != null && newProfilePhotoUrl.isNotEmpty) {
        await MarkerImageUtil.addNetworkImageToStyle(
          mapboxMap!,
          newProfilePhotoUrl,
          imageId: imageId,
        );
      } else {
        //マイページ編集で画像を消した時の対応
      }

      // 現在地マーカーを再描画
      await _updateCurrentUserMarker(CurrentUserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      ));
    } catch (e) {
      debugPrint('Error updating current user marker with new profile: $e');
    }
  }

  // build メソッドでのローディング表示
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<CurrentUserLocation>>(locationStreamProvider, (_, next) {
      next.whenData((location) {
        _updateCurrentUserMarker(location);
      });
    });

    final userId = ref.watch(currentUserProvider).value?.uid ?? '';
    ref.listen<ProfileHeaderEntity?>(profileHeaderProvider(userId), (previous, next) {
      if (previous?.profilePhotoUrl != next?.profilePhotoUrl) {
        _updateCurrentUserMarkerWithNewProfile(next?.profilePhotoUrl);
      }
    });

    // NearbyEventsModalの表示状態を監視
    final isNearbyEventsModalVisible = ref.watch(nearbyEventsModalVisibilityProvider);

    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            styleUri: "mapbox://styles/walkdream24/cmc31yizz00d201so6t4cdz1f",
            onMapCreated: _onMapCreated,
            onTapListener: _onMapTap,
          ),
          // 初期ローディング中のみフルスクリーンのローディング表示
          if (!_isInitialLoadingComplete)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'ユーザー情報を読み込んでいます...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // 二次的なコンテンツのローディング表示（小さめのインジケータ）
          if (_isLoadingClubs || _isLoadingUsers)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isLoadingClubs ? 'クラブ情報を読み込み中...' :
                      _isLoadingUsers ? 'ユーザー情報を読み込み中...' : '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          // MenuButtons(onLocationTapped: _onCurrentUserMarkerTapped),
          const TopButtons(),
                // NearbyEventsModalが表示されている場合
          if (isNearbyEventsModalVisible && _initialLocation != null)
            NearbyEventsModal(
              currentLatitude: _initialLocation!.latitude,
              currentLongitude: _initialLocation!.longitude,
              onClose: () {
                // モーダルが閉じられた時の処理
                ref.read(nearbyEventsModalVisibilityProvider.notifier).hide();
              },
            ),
          // 全画面表示解除ボタン（モーダルが非表示の時のみ表示）
        if (!isNearbyEventsModalVisible)
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 全画面表示解除ボタン
                  GestureDetector(
                    onTap: () {
                      // モーダルを再表示
                      ref.read(nearbyEventsModalVisibilityProvider.notifier).show();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF282829),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.expand_less,
                            color: Colors.blue,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '全画面表示を解除',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ボタン間のスペース
                  const SizedBox(width: 12),
                  CurrentLocationButton(
                    onPressed: () {
                      _onCurrentUserMarkerTapped();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}