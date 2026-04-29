import 'dart:io';
import 'package:image/image.dart' as img;

Future<File> resizeImage(String imagePath) async {
  // 画像を読み込む
  final imageFile = File(imagePath);
  final image = img.decodeImage(await imageFile.readAsBytes());

  if (image == null) {
    throw Exception('画像の読み込みに失敗しました');
  }

  final resizedImage = img.copyResize(image, width: 1024, height: 1024);

  // リサイズした画像を保存
  final resizedFile = File(imagePath);
  await resizedFile.writeAsBytes(img.encodePng(resizedImage));

  return resizedFile;
}

Future<File> resizeFlyer(String imagePath) async {
 final imageFile = File(imagePath);
 final image = img.decodeImage(await imageFile.readAsBytes());

 if (image == null) throw Exception('画像の読み込みに失敗しました');

 // アスペクト比を維持したまま width を 1024 に
 final ratio = 1024 / image.width;
 final newHeight = (image.height * ratio).round();
 
 final resizedImage = img.copyResize(
   image,
   width: 1024,
   height: newHeight,
 );

 final resizedFile = File(imagePath);
 await resizedFile.writeAsBytes(img.encodePng(resizedImage));

 return resizedFile;
}

// Future<File> optimizeProfileImage(String imagePath) async {
//   try {
//     // 1. 画像を読み込み（Uint8Listとして）
//     final File imageFile = File(imagePath);
//     final Uint8List imageBytes = await imageFile.readAsBytes();
//     final img.Image? originalImage = img.decodeImage(imageBytes);

//     if (originalImage == null) {
//       throw Exception('Failed to decode image');
//     }

//     // 2. リサイズ（長辺を500pxに）
//     final int targetSize = 512;
//     final double ratio = originalImage.width > originalImage.height 
//         ? targetSize / originalImage.width 
//         : targetSize / originalImage.height;
    
//     final img.Image resizedImage = img.copyResize(
//       originalImage,
//       width: (originalImage.width * ratio).round(),
//       height: (originalImage.height * ratio).round(),
//       interpolation: img.Interpolation.linear,
//     );

//     // 3. 画質を調整して圧縮（PNG）
//     final List<int> optimizedBytes = img.encodePng(
//       resizedImage,
//       level: 6, // 圧縮レベル（0-9, 9が最高圧縮）
//     );

//     // 4. 一時ファイルとして保存
//     final Directory tempDir = await getTemporaryDirectory();
//     final String targetPath = '${tempDir.path}/optimized_profile_${DateTime.now().millisecondsSinceEpoch}.png';
//     final File optimizedFile = File(targetPath);
//     await optimizedFile.writeAsBytes(Uint8List.fromList(optimizedBytes));

//     // ファイルサイズをログ出力
//     final int originalSize = await imageFile.length();
//     final int optimizedSize = await optimizedFile.length();
//     debugPrint('Original size: ${(originalSize / 1024).toStringAsFixed(2)}KB');
//     debugPrint('Optimized size: ${(optimizedSize / 1024).toStringAsFixed(2)}KB');

//     return optimizedFile;
//   } catch (e) {
//     debugPrint('Image optimization failed: $e');
//     throw e;
//   }
// }