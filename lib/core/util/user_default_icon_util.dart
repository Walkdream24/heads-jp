import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDefaultIconUtil {
  // 背景色として使用する色のリスト
  static final List<Color> _backgroundColors = [
    Colors.blue,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.deepPurple,
    Colors.cyan,
    Colors.pink,
    Colors.deepOrange,
    Colors.green,
    Colors.blueGrey,
    Colors.yellow,
    Colors.black,
  ];

  // ランダムな背景色を取得
  static Color _getRandomBackgroundColor() {
    final random = Random();
    return _backgroundColors[random.nextInt(_backgroundColors.length)];
  }

  /// アイコン画像を生成し、ローカルパスを返す
  static Future<String> getOrGenerateUserIcon({
    required String userName,
  }) async {
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
    final image = await _generateIconImage(initial);
    
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$initial.png';
    
    final pngData = await _imageToPngData(image);
    final file = File(filePath);
    await file.writeAsBytes(pngData);
    
    return filePath;
  }

  /// Firebase Storageに画像を非同期でアップロードし、FirestoreにURLを登録
  static Future<String> uploadToStorageAndRegisterInFirestore({
    required String filePath,
    required String userId,
  }) async {
    final file = File(filePath);
    final storageRef = FirebaseStorage.instance.ref();
    final firestore = FirebaseFirestore.instance;
    
    final destination = 'users/$userId/profile/defaultIcon.png';
    final fileRef = storageRef.child(destination);
    
    try {
      await fileRef.putFile(file);
      final downloadUrl = await fileRef.getDownloadURL();
      
      await firestore.collection('users').doc(userId).update({
        'profilePhotoUrl': downloadUrl,
      });
      
      debugPrint('Successfully registered profilePhotoUrl in Firestore for user: $userId');
      return downloadUrl;
    } catch (e) {
      throw Exception("Failed to upload image or update Firestore: $e");
    }
  }

  /// アイコン画像を生成する
  static Future<ui.Image> _generateIconImage(String initial) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(1024, 1024);
    
    // ランダムな背景色を使用
    final bgPaint = Paint()..color = _getRandomBackgroundColor();
    canvas.drawRect(Offset.zero & size, bgPaint);
    
    // テキスト描画
    final textPainter = TextPainter(
      text: TextSpan(
        text: initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 512,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    return recorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
  }

  /// 画像をPNGデータに変換
  static Future<List<int>> _imageToPngData(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) throw Exception("Failed to encode image");
    return byteData.buffer.asUint8List();
  }
}