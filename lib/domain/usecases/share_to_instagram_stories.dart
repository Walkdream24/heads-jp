import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_share/social_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';

class ShareToInstagramStoriesUseCase {
  /// Instagramストーリーズに画像をシェアする
  /// 
  /// [backgroundImagePath] - 背景画像のファイルパス（必須）
  /// [webUrl] - シェア時に含めるウェブURL（オプション）
  /// [stickerImagePath] - スティッカー画像のファイルパス（オプション、現在未使用）
  Future<void> share({
    required String backgroundImagePath, 
    String? webUrl,
    String? stickerImagePath,
  }) async {
    // METAのアプリIDを環境変数から取得
    final appId = dotenv.env['META_APP_ID'] ?? '';
    
    try {
      // 1. まず元の画像ファイルの存在確認
      final File originalImageFile = File(backgroundImagePath);
      if (!originalImageFile.existsSync()) {
        throw Exception('共有する画像ファイルが見つかりません: $backgroundImagePath');
      }
      
      final fileStats = await originalImageFile.stat();
      debugPrint('元の画像ファイル情報: サイズ=${fileStats.size}bytes, 最終更新=${fileStats.modified}');
      
      if (fileStats.size == 0) {
        throw Exception('共有する画像ファイルが空です');
      }

      // 2. アセットの背景画像をロード
      final random = math.Random();
      final int bgIndex = random.nextInt(5) + 1; //背景ランダム
      final String bgPath = 'assets/shareBg/sharebg$bgIndex.png';
      
      final ByteData backgroundAssetData = await rootBundle.load(bgPath);
            final ui.Codec backgroundCodec = await ui.instantiateImageCodec(
        backgroundAssetData.buffer.asUint8List(),
      );
      final ui.FrameInfo backgroundFrame = await backgroundCodec.getNextFrame();
      final ui.Image backgroundImage = backgroundFrame.image;

      // 3. 元のイベント画像をロード
      final Uint8List originalBytes = await originalImageFile.readAsBytes();
      final ui.Codec originalCodec = await ui.instantiateImageCodec(originalBytes);
      final ui.FrameInfo originalFrame = await originalCodec.getNextFrame();
      final ui.Image originalImage = originalFrame.image;

      // 4. Instagram Storiesのサイズを指定（9:16のアスペクト比、1080x1920など）
      final int storyWidth = 1080;
      final int storyHeight = 1920;

      // 5. 新しい画像を作成して背景とオリジナル画像を合成
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // 背景画像をストーリー全体に広げるためのペイント設定
      final Paint backgroundPaint = Paint()..filterQuality = FilterQuality.high;
      
      // 背景画像をストーリー全体に引き伸ばす
      canvas.drawImageRect(
        backgroundImage,
        Rect.fromLTWH(0, 0, backgroundImage.width.toDouble(), backgroundImage.height.toDouble()),
        Rect.fromLTWH(0, 0, storyWidth.toDouble(), storyHeight.toDouble()),
        backgroundPaint,
      );
      
      // 元の画像を中央に描画（必要に応じてサイズ調整）
      final double scale = 0.8; // 元の画像のサイズを調整（必要に応じて）
      final double originalWidth = originalImage.width.toDouble() * scale;
      final double originalHeight = originalImage.height.toDouble() * scale;
      
      // 中央に配置するための計算
      final double centerX = (storyWidth - originalWidth) / 2;
      final double centerY = (storyHeight - originalHeight) / 2;
      
      canvas.drawImageRect(
        originalImage,
        Rect.fromLTWH(0, 0, originalImage.width.toDouble(), originalImage.height.toDouble()),
        Rect.fromLTWH(centerX, centerY, originalWidth, originalHeight),
        Paint()..filterQuality = FilterQuality.high,
      );
      
      final picture = recorder.endRecording();
      final mergedImage = await picture.toImage(storyWidth, storyHeight);
      
      final ByteData? mergedByteData = await mergedImage.toByteData(
        format: ui.ImageByteFormat.png
      );
      
      if (mergedByteData == null) {
        throw Exception('画像の合成に失敗しました');
      }
      
      final Uint8List mergedBytes = mergedByteData.buffer.asUint8List();

      // 5. 合成した画像を一時ファイルとして保存
      final directory = await _getShareDirectory();
      final mergedImagePath = '${directory.path}/instagram_share_merged_${DateTime.now().millisecondsSinceEpoch}.png';
      
      final File mergedFile = File(mergedImagePath);
      await mergedFile.writeAsBytes(mergedBytes);
      
      debugPrint('合成済み画像を保存しました: $mergedImagePath');

      // 6. SocialShareプラグインで合成済み画像をインスタグラムストーリーに共有
      final result = await SocialShare.shareInstagramStory(
        appId: appId,
        imagePath: mergedImagePath, // 合成済み画像のパスを使用
        attributionURL: webUrl,
      );
      
      debugPrint('インスタグラムストーリーズ共有結果: $result');
      
      if (result == false) {
        throw Exception('インスタグラムストーリーズの共有に失敗しました');
      }
      
      // 7. 後処理（一時ファイルの削除など、必要に応じて）
      try {
        await mergedFile.delete();
        debugPrint('一時ファイルを削除しました: $mergedImagePath');
      } catch (e) {
        debugPrint('一時ファイル削除エラー: $e');
      }
      
    } catch (e, stackTrace) {
      debugPrint('Instagramストーリーズのシェアに失敗しました: $e');
      debugPrintStack(label: 'ShareToInstagramStoriesUseCase Error StackTrace', stackTrace: stackTrace);
      throw Exception('Instagramストーリーズのシェアに失敗しました: $e');
    }
  }

  // プラットフォームに応じた共有用ディレクトリを取得
  Future<Directory> _getShareDirectory() async {
    Directory directory;
    
    if (Platform.isIOS) {
      // iOSではApplicationDocumentsDirectoryを使用
      directory = await getApplicationDocumentsDirectory();
    } else {
      // Androidではexternalディレクトリを試し、失敗したらドキュメントディレクトリ
      try {
        directory = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      } catch (e) {
        directory = await getApplicationDocumentsDirectory();
      }
    }
    
    return directory;
  }
}