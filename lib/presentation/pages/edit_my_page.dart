import 'dart:io';
import 'package:HEADS/domain/entities/profile_header_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/profile_edit_notifier.dart';
import '../widgets/profile_image_menu.dart';
import '../widgets/custom_snackbar.dart';
import '../providers/profile_header_state.dart';
import '../providers/check_heads_id_provider.dart'; 

class EditMyPage extends ConsumerStatefulWidget {
  final ProfileHeaderEntity user;

  const EditMyPage({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<EditMyPage> createState() => _EditMyPageState();
}

class _EditMyPageState extends ConsumerState<EditMyPage> {
  late final Map<String, TextEditingController> controllers;
  bool _isLoading = false; // ローディング状態を管理するフラグ
  bool _isCheckingHeadsId = false; // headsId チェック中の状態を管理するフラグ
  bool _isValidHeadsId = true; // headsId の入力が有効かどうか
  String? _headsIdErrorText; // headsId のエラーテキスト

  static const int _maxLength = 20;
  final _validCharRegex = RegExp(r'^[a-z0-9._]*$');


  @override
  void initState() {
    super.initState();

    // コントローラーの初期化をMap化して簡潔に
    controllers = {
      'name': TextEditingController(text: widget.user.username),
      'headsId': TextEditingController(text: widget.user.headsId),
      'bio': TextEditingController(text: widget.user.bio),
      'link': TextEditingController(text: widget.user.bioLink),
      'instagram': TextEditingController(text: widget.user.instagramId),
      'twitter': TextEditingController(text: widget.user.xId),
      'youtube': TextEditingController(text: widget.user.youtubeId),
      'soundCloud': TextEditingController(text: widget.user.soundcloudId),
    };

    // リスナーの設定
    _setupControllerListeners();
  }

  void _setupControllerListeners() {
    final notifier = ref.read(profileEditProvider(widget.user).notifier);

    controllers['name']?.addListener(() {
      notifier.updateUsername(controllers['name']!.text);
      notifier.setHasChanges(true);
    });
    controllers['headsId']?.addListener(() {
      notifier.updateHeadsId(controllers['headsId']!.text);
      notifier.setHasChanges(true);
      _validateHeadsIdInput(); // headsId の入力変更時にバリデーションを実行
    });
    controllers['bio']?.addListener(() {
      notifier.updateBio(controllers['bio']!.text);
      notifier.setHasChanges(true);
    });
    controllers['link']?.addListener(() {
      notifier.updateBioLink(controllers['link']!.text);
      notifier.setHasChanges(true);
    });
    controllers['instagram']?.addListener(() {
      notifier.updateInstagramId(controllers['instagram']!.text);
      notifier.setHasChanges(true);
    });
    controllers['twitter']?.addListener(() {
      notifier.updateXId(controllers['twitter']!.text);
      notifier.setHasChanges(true);
    });
    controllers['youtube']?.addListener(() {
      notifier.updateYoutubeId(controllers['youtube']!.text);
      notifier.setHasChanges(true);
    });
    controllers['soundCloud']?.addListener(() {
      notifier.updateSoundcloudId(controllers['soundCloud']!.text);
      notifier.setHasChanges(true);
    });
  }

  // headsId のバリデーションを行う関数
  void _validateHeadsIdInput() {
    final text = controllers['headsId']!.text;

    setState(() {
      _isValidHeadsId = false; // Reset validity
      _headsIdErrorText = null; // Reset error text

      if (text.isEmpty) {
        _headsIdErrorText = null;
      } else if (text.length > _maxLength) {
        _headsIdErrorText = '20文字以内で入力してください';
      } else if (!_validCharRegex.hasMatch(text)) {
        _headsIdErrorText = '半角英小文字、数字、ドット(.)、\nアンダーバー(_)のみ使用可能です';
      } else {
        _headsIdErrorText = null;
        _isCheckingHeadsId = true;
        // Trigger the ID check
        ref.read(headsIdValidationProvider.notifier).checkIdExists(text);
      }
    });
  }


  @override
  void dispose() {
    controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _showImageMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => ProfileImageMenu(
        onImageSelected: (imagePath) {
          ref.read(profileEditProvider(widget.user).notifier)
              .updateProfilePhotoUrl(imagePath.isNotEmpty ? imagePath : null);
          ref.read(profileEditProvider(widget.user).notifier).setHasChanges(true);
        },
      ),
    );
  }

  Future<void> _onSavePressed() async {
    // 保存前に headsId のバリデーションが valid であるか確認
    if (!_isValidHeadsId) {
      CustomSnackBar.show(
        context: context,
        message: 'Heads IDにエラーがあります。修正してください。',
        isSuccess: false,
      );
      return;
    }

    setState(() {
      _isLoading = true; // ローディング開始
    });

    try {
      final updatedProfile = await ref
          .read(profileEditProvider(widget.user).notifier)
          .saveProfile(widget.user.uid);

      // ProfileHeaderProviderの状態を更新
      debugPrint("更新後のprofile${updatedProfile}");
      ref.read(profileHeaderProvider(widget.user.uid).notifier)
          .initialize(updatedProfile);

      if (!mounted) return;

      CustomSnackBar.show(
        context: context,
        message: 'プロフィールを更新しました',
        isSuccess: true,
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      CustomSnackBar.show(
        context: context,
        message: 'プロフィールの更新に失敗しました',
        isSuccess: false,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // ローディング終了
        });
      }
    }
  }

  Widget _buildProfileImage(ProfileHeaderEntity profile) {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: _showImageMenu,
            child: CircleAvatar(
              radius: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: _buildProfileImageContent(profile.profilePhotoUrl),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildCameraIcon(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImageContent(String? imageUrl) {
    if (imageUrl == null) {
      return _buildDefaultProfileImage();
    }

    return imageUrl.startsWith('http')
        ? _buildNetworkImage(imageUrl)
        : _buildLocalImage(imageUrl);
  }

  Widget _buildDefaultProfileImage() {
    return Container(
      color: Colors.grey[900],
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget _buildNetworkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: 80,
      height: 80,
      placeholder: (_, __) => _buildImagePlaceholder(),
      errorWidget: (_, __, ___) => _buildDefaultProfileImage(),
    );
  }

  Widget _buildLocalImage(String path) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      width: 80,
      height: 80,
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildCameraIcon() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: const Icon(
        Icons.camera_alt,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int? maxLength,
    int maxLines = 1,
    String? hintText,
    String? errorText, // errorText を追加
    Widget? suffixIcon, // suffixIcon を追加
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[600]),
            counterText: maxLength != null ? '${controller.text.length}/$maxLength' : '',
            counterStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[900],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: _buildTextFieldBorder(),
            enabledBorder: _buildTextFieldBorder(),
            focusedBorder: _buildTextFieldBorder(),
            errorText: errorText, // errorText を設定
            errorStyle: const TextStyle(
              color: Colors.red,
              height: 0.8,
            ),
            errorMaxLines: 2,
            suffixIcon: suffixIcon, // suffixIcon を設定
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  OutlineInputBorder _buildTextFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileEditProvider(widget.user));
    final hasChanges = ref.watch(profileEditProvider(widget.user).notifier).hasChanges;

    // headsIdValidationProvider をlisten
    ref.listen<AsyncValue<bool>>(
      headsIdValidationProvider,
          (previous, current) {
        current.whenData((exists) {
          setState(() {
            _isCheckingHeadsId = false;
            if (exists) {
              _headsIdErrorText = 'このIDは既に使用されています';
              _isValidHeadsId = false;
            } else if (controllers['headsId']!.text.isNotEmpty &&
                controllers['headsId']!.text.length <= _maxLength &&
                _validCharRegex.hasMatch(controllers['headsId']!.text)) {
              _headsIdErrorText = null;
              _isValidHeadsId = true;
            }
          });
        });
      },
    );


    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(hasChanges),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildProfileImage(profile),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: controllers['name']!,
                      label: '名前',
                      maxLength: 20,
                    ),
                    _buildTextField(
                      controller: controllers['headsId']!,
                      label: 'HEADS ID',
                      maxLength: 20,
                      errorText: _headsIdErrorText, // エラーテキストを設定
                      suffixIcon: _isCheckingHeadsId // チェック中はローディングアイコンを表示
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                          : null,
                    ),
                    _buildTextField(
                      controller: controllers['bio']!,
                      label: '自己紹介',
                      maxLength: 200,
                      maxLines: 4,
                    ),
                    _buildTextField(
                      controller: controllers['link']!,
                      label: 'リンク',
                    ),
                    _buildTextField(
                      controller: controllers['instagram']!,
                      label: 'Instagram',
                      hintText: '(例)heads_taro ※@は不要',
                    ),
                    _buildTextField(
                      controller: controllers['twitter']!,
                      label: 'X (旧Twitter)',
                      hintText: '(例)heads_taro ※@は不要',
                    ),
                    _buildTextField(
                      controller: controllers['youtube']!,
                      label: 'Youtube',
                      hintText: '(例)heads_taro ※@は不要', // YouTubeのヒントテキスト
                    ),
                    _buildTextField(
                      controller: controllers['soundCloud']!,
                      label: 'SoundCloud',
                      hintText: '(例)heads_taro ※@は不要', // SoundCloudのヒントテキスト
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                    child: CircularProgressIndicator()
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool hasChanges) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 100,
      leading: SizedBox(
        width: 100,
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'キャンセル',
            style: TextStyle(color: Colors.white, fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
      title: const Text(
        'プロフィールの編集',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      actions: [
        TextButton(
          // 保存ボタンの有効/無効を _isValidHeadsId で制御
          onPressed: (hasChanges && !_isLoading && _isValidHeadsId) ? _onSavePressed : null,
          child: Text(
            '保存',
            style: TextStyle(
              color: (hasChanges && _isValidHeadsId) ? Colors.white : Colors.grey,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}