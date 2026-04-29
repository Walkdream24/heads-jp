import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/util/resize_image.dart';

class FlyerImageMenu extends StatelessWidget {
  final void Function(String) onImageSelected; // 画像が選択されたときに呼ばれるコールバック

  const FlyerImageMenu({
    super.key,
    required this.onImageSelected,
  });

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // リサイズのみを実行（クロップなし）
      final resizedFile = await resizeFlyer(
        pickedFile.path, 
      );

      // リサイズされた画像のパスを返す
      onImageSelected(resizedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('写真を撮る'),
            onTap: () async {
              Navigator.pop(context); // メニューを閉じる
              await _pickImage(ImageSource.camera); // カメラを起動
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('ライブラリから選択'),
            onTap: () async {
              Navigator.pop(context); // メニューを閉じる
              await _pickImage(ImageSource.gallery); // ギャラリーを起動
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('写真を削除'),
            onTap: () {
              Navigator.pop(context); // メニューを閉じる
              onImageSelected(''); // 空のパスを渡して写真を削除
            },
          ),
        ],
      ),
    );
  }
}