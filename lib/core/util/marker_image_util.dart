import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'image_processor.dart';
import '../../domain/entities/marker_entity.dart';
import '../../domain/entities/user_summary_entity.dart';

class MarkerImageUtil {
  static final Map<String, Uint8List> _memoryCache = {};
  
  /// キャッシュされた画像を取得する
  static Future<Uint8List?> _getCachedImage(String url) async {
    // メモリキャッシュをまず確認
    if (_memoryCache.containsKey(url)) {
      return _memoryCache[url];
    }

    try {
      // URLからファイル名を生成
      final String fileName = md5.convert(utf8.encode(url)).toString();
      final Directory cacheDir = await getTemporaryDirectory();
      final File cacheFile = File('${cacheDir.path}/marker_images/$fileName');

      // ディスクキャッシュを確認
      if (await cacheFile.exists()) {
        final Uint8List imageData = await cacheFile.readAsBytes();
        _memoryCache[url] = imageData; // メモリキャッシュに保存
        return imageData;
      }
    } catch (e) {
      debugPrint("キャッシュ読み込みエラー: $e");
    }
    return null;
  }

  /// 画像をキャッシュに保存
  static Future<void> _cacheImage(String url, Uint8List imageData) async {
    try {
      // メモリキャッシュに保存
      _memoryCache[url] = imageData;

      // ディスクキャッシュに保存
      final String fileName = md5.convert(utf8.encode(url)).toString();
      final Directory cacheDir = await getTemporaryDirectory();
      final Directory markerDir = Directory('${cacheDir.path}/marker_images');
      if (!await markerDir.exists()) {
        await markerDir.create(recursive: true);
      }
      
      final File cacheFile = File('${markerDir.path}/$fileName');
      await cacheFile.writeAsBytes(imageData);
    } catch (e) {
      debugPrint("キャッシュ保存エラー: $e");
    }
  }

  /// クラブマーカー画像をスタイルに追加
  static Future<void> addClubImagesToStyle(MapboxMap mapboxMap, List<ClubMarkerEntity> clubMarkers) async {
    try {
      const imageId = 'red_marker.png';
      final image = await _getImage('assets/red_marker.png');
      await mapboxMap.style.addStyleImage(
        imageId,
        1.0,
        image,
        false,
        [],
        [],
        null,
      );
      debugPrint("クラブマーカー画像が正常に追加されました");
    } catch (e) {
      debugPrint("クラブ画像の追加中にエラーが発生しました: $e");
    }
  }

  static Future<void> addClusteredImagesToStyle(MapboxMap mapboxMap) async {
    try {
      // クラスターアイコンの定義
      final clusterIcons = [
        {'id': 'small-cluster-icon', 'path': 'assets/small_cluster.jpg'},
        {'id': 'medium-cluster-icon', 'path': 'assets/medium_cluster.jpg'},
        {'id': 'large-cluster-icon', 'path': 'assets/large_cluster.jpg'}
      ];

      for (var icon in clusterIcons) {
        final image = await _getImage(icon['path']!);
        await mapboxMap.style.addStyleImage(
          icon['id']!,
          1.0,
          image,
          false,
          [],
          [],
          null,
        );
      }
      debugPrint("クラスターマーカー画像が正常に追加されました");
    } catch (e) {
      debugPrint("クラスターマーカー画像の追加中にエラーが発生しました: $e");
    }
  }

  /// ユーザーマーカー画像をスタイルに追加
  static Future<void> addUserImagesToStyle(MapboxMap mapboxMap, List<UserMarkerEntity> userMarkers) async {
    final imagePaths = userMarkers.map((marker) => marker.imagePath).toSet();

    try {
      for (var path in imagePaths) {
        final imageId = path.split('/').last;
        final image = await _getImage(path);
        await mapboxMap.style.addStyleImage(
          imageId,
          1.0,
          image,
          false,
          [],
          [],
          null,
        );
      }
      debugPrint("ユーザーマーカー画像が正常に追加されました");
    } catch (e) {
      debugPrint("ユーザー画像の追加中にエラーが発生しました: $e");
    }
  }

  /// 現在地アイコンをスタイルに追加
  static Future<void> addCurrentUserIconToStyle(
    MapboxMap mapboxMap,
    String imagePath, {
    Color outerColor = Colors.blue,
    Color innerColor = const Color.fromARGB(255, 113, 188, 249),
    double strokeWidth = 6.0,
    double radius = 20.0,
    bool useGradient = true,
  }) async {
    try {
      debugPrint("現在地アイコンを生成: $imagePath");
      final File imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found at path: $imagePath');
      }
      
      final Uint8List originalImage = await imageFile.readAsBytes();

      final processedImage = await ImageProcessor.processMarkerImage(
        originalImage,
        targetSize: 80,
        outerColor: outerColor,
        innerColor: innerColor,
        strokeWidth: strokeWidth,
        radius: radius,
        useGradient: useGradient,
      );

      final parsedImage = await decodeImageFromList(processedImage);

      debugPrint("Mapboxに現在地アイコン追加: current-user-icon");
      await mapboxMap.style.addStyleImage(
        'current-user-icon',
        1.0,
        MbxImage(
          width: parsedImage.width,
          height: parsedImage.height,
          data: processedImage,
        ),
        false,
        [],
        [],
        null,
      );
      debugPrint("現在地アイコンの追加完了");
    } catch (e) {
      debugPrint("現在地アイコンの追加中にエラー: $e");
    }
  }

  /// 画像データを生成
  static Future<MbxImage> _getImage(String path) async {
    final ByteData bytes = await rootBundle.load(path);
    final Uint8List originalImage = bytes.buffer.asUint8List();

    if (path.contains('red_marker.png')) {
      return MbxImage(
        width: 1024,
        height: 1024,
        data: originalImage,
      );
    }

    final processedImage = await ImageProcessor.processMarkerImage(
      originalImage,
      targetSize: 100,
      outerColor: Colors.black,
      innerColor: Colors.white,
      strokeWidth: 4.0,
      radius: 25.0,
      useGradient: false,
    );

    return MbxImage(
      width: 1024,
      height: 1024,
      data: processedImage,
    );
  }

  /// ネットワーク画像をダウンロードして Mapbox のスタイルに追加（キャッシュ対応）
  static Future<void> addNetworkImageToStyle(
    MapboxMap mapboxMap,
    String imageUrl, {
    required String imageId,
    Color outerColor = Colors.blue,
    Color innerColor = const Color.fromARGB(255, 113, 188, 249),
    double strokeWidth = 6.0,
    double cornerRadius = 20.0,
    bool useGradient = false
  }) async {
    try {
      debugPrint("画像の取得開始: $imageUrl");
      
      // キャッシュから画像を取得を試みる
      Uint8List? imageData = await _getCachedImage(imageUrl);
      
      // キャッシュにない場合はダウンロード
      if (imageData == null) {
        debugPrint("キャッシュミス - ネットワークからダウンロード: $imageUrl");
        final response = await http.get(Uri.parse(imageUrl));
        
        if (response.statusCode == 200) {
          imageData = response.bodyBytes;
          // キャッシュに保存
          await _cacheImage(imageUrl, imageData);
        } else {
          throw Exception('Failed to download image: ${response.statusCode}');
        }
      } else {
        debugPrint("キャッシュヒット: $imageUrl");
      }

      // 画像の加工処理
      final processedImage = await ImageProcessor.processMarkerImage(
        imageData,
        targetSize: 100,
        outerColor: outerColor,
        innerColor: innerColor,
        strokeWidth: strokeWidth,
        radius: cornerRadius,
        useGradient: useGradient
      );

      debugPrint("Mapboxに加工済み画像追加: $imageId");
      final parsedImage = await decodeImageFromList(processedImage);
      await mapboxMap.style.addStyleImage(
        imageId,
        1.0,
        MbxImage(
          width: parsedImage.width,
          height: parsedImage.height,
          data: processedImage,
        ),
        false,
        [],
        [],
        null,
      );
      debugPrint("画像追加完了: $imageId");
    } catch (e) {
      debugPrint("画像処理中のエラー: $e");
    }
  }

  static Future<void> addUsersImagesToStyle(
    MapboxMap mapboxMap,
    List<UserSummaryEntity> usersSummary,
  ) async {
    try {
      for (final userSummary in usersSummary) {
        final imageUrl = userSummary.profilePhotoUrl;
        final imageId = imageUrl.split('/').last;
        await addNetworkImageToStyle(
          mapboxMap,
          imageUrl,
          imageId: imageId,
          outerColor: Colors.white,
          innerColor: Colors.black,
          strokeWidth: 6.0,
          cornerRadius: 20.0,
          useGradient: false,
        );
      }
      debugPrint("ユーザーマーカー画像が正常に追加されました");
    } catch (e) {
      debugPrint("ユーザー画像の追加中にエラーが発生しました: $e");
    }
  }
  
}