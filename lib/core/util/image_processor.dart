import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImageProcessor {
  /// マーカー画像を加工するユーティリティ関数
  /// 内側と外側に別々のグラデーションを適用
  static Future<Uint8List> processMarkerImage(
    Uint8List originalImage, {
    int targetSize = 100,
    Color outerColor = Colors.black, // 外側の色（デフォルト: 黒）
    Color innerColor = Colors.white, // 内側の色（デフォルト: 白）
    double strokeWidth = 4.0, // ストロークの太さ（デフォルト: 4.0）
    double radius = 25.0, // 角の丸み（デフォルト: 25.0）
    bool useGradient = true, // グラデーションを使用するかどうか
  }) async {
    final codec = await ui.instantiateImageCodec(originalImage);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    // 全体の描画サイズを計算
    final totalSize = targetSize + (strokeWidth * 2).toInt();
    final center = Offset(totalSize / 2, totalSize / 2);

    // Canvasの準備
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    if (useGradient) {
      // 外側のグラデーション円を描画
      final outerPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..shader = ui.Gradient.radial(
          center,
          (totalSize / 2),
          [outerColor.withOpacity(0.9), outerColor.withOpacity(0.7)],
          [0.7, 1.0],
        );

      // 外側の円
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, totalSize.toDouble(), totalSize.toDouble()),
          Radius.circular(radius + strokeWidth),
        ),
        outerPaint,
      );

      // 内側のグラデーション円を描画
      final innerPaint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..shader = ui.Gradient.linear(
          Offset(strokeWidth, strokeWidth),
          Offset(totalSize - strokeWidth, totalSize - strokeWidth),
          [innerColor, innerColor.withOpacity(0.7)],
          [0.0, 1.0],
        );

      // 内側の円
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            strokeWidth,
            strokeWidth,
            totalSize - (strokeWidth * 2),
            totalSize - (strokeWidth * 2),
          ),
          Radius.circular(radius),
        ),
        innerPaint,
      );
    } else {
      // 通常の描画（グラデーションなし）
      final paint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill;
        
      // 外側
      paint.color = outerColor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, totalSize.toDouble(), totalSize.toDouble()),
          Radius.circular(radius + strokeWidth),
        ),
        paint,
      );

      // 内側
      paint.color = innerColor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            strokeWidth,
            strokeWidth,
            totalSize - (strokeWidth * 2),
            totalSize - (strokeWidth * 2),
          ),
          Radius.circular(radius),
        ),
        paint,
      );
    }

    // アイコン画像用の領域を計算
    final imageRect = Rect.fromLTWH(
      strokeWidth * 2,
      strokeWidth * 2,
      totalSize - (strokeWidth * 4),
      totalSize - (strokeWidth * 4),
    );

    // 画像をクリップして描画
    final clipRRect = RRect.fromRectAndRadius(
      imageRect,
      Radius.circular(radius - strokeWidth),
    );
    canvas.clipRRect(clipRRect);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      imageRect,
      Paint()..isAntiAlias = true,
    );

    // 描画した画像を生成
    final picture = pictureRecorder.endRecording();
    final finalImage = await picture.toImage(totalSize, totalSize);
    final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);

    // リソースを解放
    image.dispose();
    finalImage.dispose();

    return byteData!.buffer.asUint8List();
  }

  /// さらに明確なグラデーション効果を持つ別バージョン
  static Future<Uint8List> processMarkerImageWithStrongGradient(
    Uint8List originalImage, {
    int targetSize = 100,
    double strokeWidth = 4.0,
    double radius = 25.0,
  }) async {
    final codec = await ui.instantiateImageCodec(originalImage);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    // 全体の描画サイズを計算
    final totalSize = targetSize + (strokeWidth * 2).toInt();
    final center = Offset(totalSize / 2, totalSize / 2);

    // Canvasの準備
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // 外側のグラデーション（青から水色へ）
    final outerPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.radial(
        center,
        totalSize / 2,
        [
          Colors.blue.shade800,
          Colors.blue.shade500,
        ],
        [0.6, 1.0],
      );

    // 外側の円
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, totalSize.toDouble(), totalSize.toDouble()),
        Radius.circular(radius + strokeWidth),
      ),
      outerPaint,
    );

    // 内側のグラデーション（水色から明るい青へ）
    final innerPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(strokeWidth, strokeWidth),
        Offset(totalSize - strokeWidth, totalSize - strokeWidth),
        [
          const Color.fromARGB(255, 113, 188, 249),
          Colors.lightBlueAccent,
        ],
        [0.0, 1.0],
      );

    // 内側の円
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          strokeWidth,
          strokeWidth,
          totalSize - (strokeWidth * 2),
          totalSize - (strokeWidth * 2),
        ),
        Radius.circular(radius),
      ),
      innerPaint,
    );

    // アイコン画像用の領域を計算
    final imageRect = Rect.fromLTWH(
      strokeWidth * 2,
      strokeWidth * 2,
      totalSize - (strokeWidth * 4),
      totalSize - (strokeWidth * 4),
    );

    // 画像をクリップして描画
    final clipRRect = RRect.fromRectAndRadius(
      imageRect,
      Radius.circular(radius - strokeWidth),
    );
    canvas.clipRRect(clipRRect);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      imageRect,
      Paint()..isAntiAlias = true,
    );

    // 描画した画像を生成
    final picture = pictureRecorder.endRecording();
    final finalImage = await picture.toImage(totalSize, totalSize);
    final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);

    // リソースを解放
    image.dispose();
    finalImage.dispose();

    return byteData!.buffer.asUint8List();
  }
}