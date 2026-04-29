// lib/features/widgets/image_picker_section.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'flyer_image_menu.dart';

class ImagePickerSection extends StatefulWidget {
  final void Function(String?) onImagePathChanged; // コールバック関数

  const ImagePickerSection({Key? key, required this.onImagePathChanged}) : super(key: key);

  @override
  _ImagePickerSectionState createState() => _ImagePickerSectionState();
}

class _ImagePickerSectionState extends State<ImagePickerSection> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = null; // _imagePathを初期化
    Future.delayed(Duration.zero, () { // Future.delayed でラップ
      widget.onImagePathChanged(_imagePath); // 親ウィジェットを初期化 (nullパスで)
    });
  }


  void _onImageSelected(String path) {
    setState(() {
      _imagePath = path;
      widget.onImagePathChanged(_imagePath); // コールバック関数を呼び出す
    });
  }

  void _showImagePickerMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return FlyerImageMenu(onImageSelected: _onImageSelected);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'フライヤー写真',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showImagePickerMenu,
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(8),
            color: Colors.grey,
            strokeWidth: 1,
            dashPattern: const [6, 3],
            child: Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: _imagePath != null
                  ? Image.file(
                      File(_imagePath!),
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.add,
                      color: Colors.grey,
                      size: 30,
                    ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}