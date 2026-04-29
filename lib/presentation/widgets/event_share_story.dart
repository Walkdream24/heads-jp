import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/event_entity.dart';

class EventShareStory {
  final EventEntity event;
  final String deepLinkUrl;
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  EventShareStory({
    required this.event,
    required this.deepLinkUrl,
  });

  // 外部から呼び出すメインメソッド：コンテキストを受け取り、キャプチャした画像パスを返す
  Future<String> captureImage(BuildContext context) async {
    try {
      // 1. イベントのフライヤー画像をダウンロード
      final flyerImageFile = await _downloadAndSaveImage(event.flyerPhotoUrl);
      
      // 2. キャプチャ用の一時的なダイアログを表示して、実際のウィジェットをレンダリング
      late String imagePath;
      
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          // この非同期処理でキャプチャを行う
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // 一度描画が完了した後でキャプチャ
            await Future<void>.delayed(const Duration(milliseconds: 100));
            
            try {
              final capturedPath = await _captureRenderedWidget();
              imagePath = capturedPath;
              // キャプチャ完了後にダイアログを閉じる
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            } catch (e) {
              debugPrint('キャプチャエラー: $e');
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              rethrow;
            }
          });
          
          // 実際に描画するウィジェット（非表示になるが実際にレンダリングされる）
          return Material(
            type: MaterialType.transparency,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: SizedBox(
                  width: 1080,
                  height: 1920,
                  child: _buildCaptureWidget(context, flyerImageFile),
                ),
              ),
            ),
          );
        },
      );
      
      return imagePath;
      
    } catch (e, stackTrace) {
      debugPrint('ストーリー画像作成エラー: $e');
      debugPrintStack(label: 'EventShareStory Error StackTrace', stackTrace: stackTrace);
      rethrow;
    }
  }

  // フライヤー画像をダウンロードして保存
  Future<File> _downloadAndSaveImage(String imageUrl) async {
    debugPrint('画像ダウンロード開始: $imageUrl');
    final http.Response response = await http.get(Uri.parse(imageUrl));
    
    if (response.statusCode != 200) {
      throw Exception('画像のダウンロードに失敗しました: ${response.statusCode}');
    }
    
    // アプリのキャッシュディレクトリを取得
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'flyer_${event.eventId}_${DateTime.now().millisecondsSinceEpoch}.png';
    final filePath = '${appDir.path}/$fileName';
    
    // ファイルを保存
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    
    debugPrint('画像を保存しました: $filePath (${response.bodyBytes.length} bytes)');
    return file;
  }

  // キャプチャ用のウィジェットを構築 - シンプル化（イベント名なし）
  Widget _buildCaptureWidget(BuildContext context, File imageFile) {
    return RepaintBoundary(
      key: _repaintBoundaryKey,
      child: Container(
        // ストーリーの標準的なアスペクト比（9:16）に合わせる
        width: 1080,
        height: 1920,
        color: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // イベント画像（中央に角丸で表示）
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  imageFile,
                  width: 1080 * 0.9, // より大きく表示
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('画像表示エラー: $error');
                    return Container(
                      width: 1080 * 0.9,
                      height: 1080 * 0.9,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Text(
                          '画像の読み込みエラー',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            decoration: TextDecoration.none
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 実際にレンダリングされたウィジェットをキャプチャ
  Future<String> _captureRenderedWidget() async {
    try {
      // レンダーオブジェクトを取得
      final boundary = _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) {
        throw Exception('RenderRepaintBoundaryが見つかりません');
      }
      
      // 少し待機してレンダリングを確実に
      await Future<void>.delayed(const Duration(milliseconds: 200));
      
      // キャプチャを実行
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        throw Exception('画像データを取得できません');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      
      // 保存先を取得
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'story_share_${event.eventId}_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${appDir.path}/$fileName';
      
      // ファイルを保存
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);
      
      debugPrint('キャプチャ画像を保存しました: $filePath (${pngBytes.length} bytes)');
      return filePath;
    } catch (e) {
      debugPrint('ウィジェットキャプチャエラー: $e');
      rethrow;
    }
  }
}