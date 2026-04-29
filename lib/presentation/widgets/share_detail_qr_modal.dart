import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/usecases/share_to_instagram_stories.dart';
import 'custom_snackbar.dart';
import '../../core/util/error_helper.dart';

class ShareDetailQrModal extends StatelessWidget {
  final String userName;
  final String userId;
  final String userIconUrl; // 修正: userIconUrl を CachedNetworkImage に対応
  final GlobalKey _boundaryKey = GlobalKey(); // キャプチャ用キー

  ShareDetailQrModal({
    Key? key,
    required this.userName,
    required this.userId,
    required this.userIconUrl,
  }) : super(key: key);

  Future<String> _captureWidgetToImage() async {
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint('エラー: RenderRepaintBoundaryが見つかりません');
        throw Exception('RenderRepaintBoundaryが見つかりません');
      }
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        debugPrint('エラー: 画像データを取得できません');
        throw Exception('画像データを取得できません');
      }

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/share_image.png';
      final file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      debugPrint('キャプチャした画像が保存されました: $filePath');
      return file.path;
    } catch (e) {
      debugPrint('ウィジェットキャプチャに失敗しました: $e');
      throw Exception('ウィジェットキャプチャに失敗しました: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // キャプチャ対象の RepaintBoundary
        RepaintBoundary(
          key: _boundaryKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 60),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  image: const DecorationImage(
                    image: AssetImage('assets/qr_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 60),
                      SvgPicture.asset(
                        'assets/heads.svg',
                        width: 200,
                      ),
                      const SizedBox(height: 60),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: QrImageView(
                          data: 'https://www.f1lthyware.com/?fbclid=PAZXh0bgNhZW0CMTEAAabllZojxiUFtUUJ0MsCgeQKwrBYFR40TKtmJczUtQBG3H448Lim07m2Zns_aem_MGs0LYJZ-8yOeAfY_CGoGw',
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                      const SizedBox(height: 100),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF242930),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(userIconUrl), // 修正: CachedNetworkImage
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                Text(
                                  'heads id: $userId',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.ios_share, color: Colors.white),
                              onPressed: () {
                                // 他のシェアアクション
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Instagramシェアボタンをキャプチャ対象の外に配置
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () async {
              final shareToInstagramStories = ShareToInstagramStoriesUseCase();
              try {
                final imagePath = await _captureWidgetToImage();
                await shareToInstagramStories.share(
                  backgroundImagePath: imagePath,
                );
              } catch (error) {
             CustomSnackBar.show(
        context: context,
        message: getLocalizedErrorMessage(error),
        isSuccess: false,
      );
              }
            },
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(bottom: 20), // アイコン位置を調整
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF89058),
                    Color(0xFFE22C5E),
                    Color(0xFF8334C0),
                  ],
                  stops: [0.0, 0.27, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/instagram_logo.svg',
                  width: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.close, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }
}
