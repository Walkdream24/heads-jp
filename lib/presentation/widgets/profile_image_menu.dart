import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/util/resize_image.dart';

class ProfileImageMenu extends StatelessWidget {
  final void Function(String) onImageSelected; // 画像が選択されたときに呼ばれるコールバック

  const ProfileImageMenu({
    super.key,
    required this.onImageSelected,
  });

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // 画像をクロップ
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // 正方形にクロップ
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '画像をクロップ',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: '画像をクロップ',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      if (croppedFile != null) {
        // クロップされた画像のパスを返す
        final resizedFile = await resizeImage(croppedFile.path);
        // リサイズされた画像のパスを返す
        onImageSelected(resizedFile.path);
        // final optimizedFile = await optimizeProfileImage(croppedFile.path);
        // onImageSelected(optimizedFile.path);
      }
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
            leading: Icon(Icons.camera_alt),
            title: Text('写真を撮る'),
            onTap: () async {
              Navigator.pop(context); // メニューを閉じる
              await _pickImage(ImageSource.camera); // カメラを起動
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('ライブラリから選択'),
            onTap: () async {
              Navigator.pop(context); // メニューを閉じる
              await _pickImage(ImageSource.gallery); // ギャラリーを起動
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('写真を削除'),
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