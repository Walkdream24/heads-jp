import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/usecases/share_to_instagram_stories.dart';
import 'custom_snackbar.dart';
import '../../core/util/error_helper.dart';

class MemoryShareStory extends StatelessWidget {
  final String imagePath; // MemoryDetailModalの画像パス
  final GlobalKey _boundaryKey = GlobalKey();
   MemoryShareStory({Key? key, required this.imagePath}) : super(key: key);

  Future<String> _captureWidgetToImage() async {
    try {
      // レンダリングが完了するのを待つ
      await Future<void>.delayed(const Duration(milliseconds: 100));
      
      final boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('RenderRepaintBoundaryが見つかりません');
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('画像データを取得できません');
      }

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/memory_share_image.png';
      final file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file.path;
    } catch (e) {
      throw Exception('ウィジェットキャプチャに失敗しました');
    }
  }

  Future<void> _shareToInstagram(BuildContext context) async {
    try {
      final imagePath = await _captureWidgetToImage();
      final shareToInstagramStories = ShareToInstagramStoriesUseCase();
      await shareToInstagramStories.share(
        backgroundImagePath: imagePath,
      );
      // シェア完了後にモーダルを閉じる
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      CustomSnackBar.show(
        context: context,
        message: getLocalizedErrorMessage(error),
        isSuccess: false,
      );
       // エラー時もモーダルを閉じる
        Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ウィジェットが表示された後に自動でシェアを開始
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _shareToInstagram(context);
    });

    return RepaintBoundary(
      key: _boundaryKey,
      child: Stack(
        children: [
          // バックグラウンド画像
          Positioned.fill(
            child: Image.asset(
              'assets/izakaya.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // 真ん中の角丸画像
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 下部のブランドロゴ
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: SvgPicture.asset(
                'assets/heads.svg',
                width: 120,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
