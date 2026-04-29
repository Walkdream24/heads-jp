// profile_edit_notifier.dart
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile_header_entity.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../providers/user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ローカルの画像パスを保持するための状態を追加
final profileImagePathProvider = StateProvider<String?>((ref) => null);

final profileEditProvider = StateNotifierProvider.family<ProfileEditNotifier, ProfileHeaderEntity, ProfileHeaderEntity>(
  (ref, initial) => ProfileEditNotifier(
    initial,
    ref.watch(updateUserProfileUseCaseProvider),
  ),
);

class ProfileEditNotifier extends StateNotifier<ProfileHeaderEntity> {
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  // 変更があるかどうかを管理するフラグ
  bool _hasChanges = false;

  ProfileEditNotifier(
    super.initial,
    this._updateUserProfileUseCase,
  );

  String? _tempImagePath;
  bool _isImageDeleted = false;

  // 変更があるかどうかを返すゲッター
  bool get hasChanges => _hasChanges;

  // 変更状態を更新するメソッド
  void setHasChanges(bool value) {
    _hasChanges = value;
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
    _hasChanges = true; // 変更があったことを記録
  }

  void updateHeadsId(String headsId) {
    state = state.copyWith(headsId: headsId);
    _hasChanges = true; // 変更があったことを記録
  }

  void updateBio(String bio) {
    state = state.copyWith(bio: bio);
    _hasChanges = true; // 変更があったことを記録
  }

  void updateBioLink(String bioLink) {
    state = state.copyWith(bioLink: bioLink);
    _hasChanges = true; // 変更があったことを記録
  }

  void updateInstagramId(String instagramId) {
    state = state.copyWith(instagramId: instagramId);
    _hasChanges = true; // 変更があったことを記録
  }

  void updateXId(String xId) {
    state = state.copyWith(xId: xId);
    _hasChanges = true; // 変更があったことを記録
  }

  void updateYoutubeId(String youtubeId) {
    state = state.copyWith(youtubeId: youtubeId);
    _hasChanges = true; // 変更があったことを記録
  }

  void updateSoundcloudId(String soundcloudId) {
    state = state.copyWith(soundcloudId: soundcloudId);
    _hasChanges = true; // 変更があったことを記録
  }

  void updateProfilePhotoUrl(String? imagePath) {
    if (imagePath == null) {
      debugPrint("画像追加されてない");
      // 画像を削除する場合
      _tempImagePath = null;
      _isImageDeleted = true;
      state = state.copyWith(profilePhotoUrl: null);
    } else {
      debugPrint("画像追加された");
      // 新しい画像を選択した場合
      _tempImagePath = imagePath;
      _isImageDeleted = false;
      state = state.copyWith(profilePhotoUrl: imagePath);
    }
    _hasChanges = true; // 変更があったことを記録
  }

  Future<String?> _uploadImageToFireStorage(
  String imagePath,
  String userId,
) async {
  try {
    // 1. File validation with detailed logging
    final file = File(imagePath);
    debugPrint('Checking file at path: $imagePath');
    
    if (!file.existsSync()) {
      debugPrint('Error: File does not exist: ${file.path}');
      return null;
    }

    // 2. Check file size and content
    final fileSize = await file.length();
    debugPrint('File size: $fileSize bytes');
    
    if (fileSize == 0) {
      debugPrint('Error: File is empty');
      return null;
    }

    // 3. Create storage reference with proper path
    final storageRef = FirebaseStorage.instance.ref();
    final destination = 'users/$userId/profile/profileIcon.png';
    final fileRef = storageRef.child(destination);
    
    // 4. Upload with retry mechanism
    int retryCount = 0;
    const maxRetries = 3;
    
    while (retryCount < maxRetries) {
      try {
        // Upload with minimal metadata
        final metadata = SettableMetadata(
          contentType: 'image/png',
        );
        
        // Use putData instead of putFile
        final bytes = await file.readAsBytes();
        await fileRef.putData(bytes, metadata);
        
        // Get download URL
        final downloadUrl = await fileRef.getDownloadURL();
        debugPrint('Upload successful: $downloadUrl');
        return downloadUrl;
        
      } on FirebaseException catch (e) {
        retryCount++;
        debugPrint('Upload attempt $retryCount failed: ${e.message}');
        
        if (retryCount >= maxRetries) {
          throw e;
        }
        
        // Wait before retry
        await Future<void>.delayed(Duration(seconds: 1));
      }
    }
    
    return null;

  } on FirebaseException catch (e) {
    debugPrint('Firebase Storage Error: ${e.code} - ${e.message}');
    return null;
  } catch (e) {
    debugPrint('Unexpected error during upload: $e');
    return null;
  }
}

  Future<ProfileHeaderEntity> saveProfile(String userId) async {
  try {
    String? finalProfilePhotoUrl;
    
    if (_isImageDeleted) {
      finalProfilePhotoUrl = null;
      debugPrint('Image deleted, setting URL to null');
    } else if (_tempImagePath != null) {
      debugPrint('Uploading new image from path: $_tempImagePath');
      // リトライロジックを追加
      for (int i = 0; i < 3; i++) {
        finalProfilePhotoUrl = await _uploadImageToFireStorage(_tempImagePath!, userId);
        if (finalProfilePhotoUrl != null) break;
        await Future<void>.delayed(Duration(seconds: 1));
      }
      
      if (finalProfilePhotoUrl == null) {
        throw Exception('Failed to upload image after retries');
      }
    } else {
      finalProfilePhotoUrl = state.profilePhotoUrl;
      debugPrint('No image changes, keeping existing URL: $finalProfilePhotoUrl');
    }

    debugPrint("Final profile photo URL: $finalProfilePhotoUrl");
    
    // Update state
    state = state.copyWith(profilePhotoUrl: finalProfilePhotoUrl);
    
    // Save profile and wait for completion
    await _updateUserProfileUseCase.execute(state);
    
    // Reset temporary states
    _tempImagePath = null;
    _isImageDeleted = false;
    _hasChanges = false;
    
    // Return the updated state
    return state;
    
  } catch (e) {
    debugPrint('Error in saveProfile: $e');
    rethrow;
  }
}
}