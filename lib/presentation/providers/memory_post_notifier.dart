import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/memories_entity.dart';
import '../../domain/usecases/add_memory_usecase.dart';
import '../../domain/usecases/fetch_memories_usecase.dart';
import '../providers/memories_provider.dart';

// memory_post_notifier.dart
final memoryPostProvider = StateNotifierProvider<MemoryPostNotifier, MemoryPostState>((ref) {
  return MemoryPostNotifier(
    addMemoryUseCase: ref.watch(addMemoryUseCaseProvider),
    ref: ref,
  );
});

class MemoryPostNotifier extends StateNotifier<MemoryPostState> {
  final AddMemoryUseCase addMemoryUseCase;
  final Ref ref;
  String? _tempImagePath;

  MemoryPostNotifier({
    required this.addMemoryUseCase,
    required this.ref,
  }) : super(MemoryPostState());

  void updateImage(String? imagePath) {
    if (imagePath == null) {
      _tempImagePath = null;
      state = state.copyWith(
        imagePath: null,
        isValid: false,
      );
    } else {
      _tempImagePath = imagePath;
      state = state.copyWith(
        imagePath: imagePath,
        isValid: true,
      );
    }
  }

  void updateCaption(String caption) {
    state = state.copyWith(caption: caption);
  }

  Future<void> submitPost(String userId, String? eventId) async {
    if (!state.isValid) return;
    
    try {
      String? imageUrl;
      
      if (_tempImagePath != null) {
        debugPrint('Uploading new image from path: $_tempImagePath');
        imageUrl = await _uploadImageToFireStorage(_tempImagePath!, userId);
        
        if (imageUrl == null) {
          throw Exception('Failed to upload image after retries');
        }
      }

      final memory = MemoryEntity(
        memoryId: '', // バックエンド側で生成
        userId: userId,
        eventId: eventId,
        photoUrl: imageUrl!,
        caption: state.caption,
        isArchived: false,
      );

      // メモリーを保存
      await addMemoryUseCase.execute(memory);
      
      // メモリー一覧を更新
      await ref.read(memoriesProvider(userId).notifier).fetchMemories(userId);
      
      // 状態をリセット
      _tempImagePath = null;
      state = MemoryPostState();
      
    } catch (e) {
      debugPrint('Error in submitPost: $e');
      rethrow;
    }
  }

  Future<String?> _uploadImageToFireStorage(String imagePath, String userId) async {
    try {
      final file = File(imagePath);
      debugPrint('Checking file at path: $imagePath');
      
      if (!file.existsSync()) {
        debugPrint('Error: File does not exist: ${file.path}');
        return null;
      }
  
      final fileSize = await file.length();
      debugPrint('File size: $fileSize bytes');
      
      if (fileSize == 0) {
        debugPrint('Error: File is empty');
        return null;
      }
  
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storageRef = FirebaseStorage.instance.ref();
      final destination = 'memories/$userId/$timestamp';
      final fileRef = storageRef.child(destination);
      
      int retryCount = 0;
      const maxRetries = 3;
      
      while (retryCount < maxRetries) {
        try {
          final metadata = SettableMetadata(
            contentType: 'image/png',
          );
          
          final bytes = await file.readAsBytes();
          await fileRef.putData(bytes, metadata);
          
          final downloadUrl = await fileRef.getDownloadURL();
          debugPrint('Upload successful: $downloadUrl');
          return downloadUrl;
          
        } on FirebaseException catch (e) {
          retryCount++;
          debugPrint('Upload attempt $retryCount failed: ${e.message}');
          
          if (retryCount >= maxRetries) {
            throw e;
          }
          
          await Future<void>.delayed(Duration(seconds: 1));
        }
      }
      
      return null;
  
    } catch (e) {
      debugPrint('Unexpected error during upload: $e');
      return null;
    }
  }
}

// memories_notifier.dart
final memoriesProvider = StateNotifierProvider.family<MemoriesNotifier, AsyncValue<List<MemoryEntity>>, String>(
  (ref, userId) => MemoriesNotifier(
    fetchMemoriesUseCase: ref.watch(fetchMemoriesUseCaseProvider),
  )..fetchMemories(userId),
);

class MemoriesNotifier extends StateNotifier<AsyncValue<List<MemoryEntity>>> {
  final FetchMemoriesUseCase fetchMemoriesUseCase;

  MemoriesNotifier({
    required this.fetchMemoriesUseCase,
  }) : super(const AsyncValue.loading());

  Future<void> fetchMemories(String userId) async {
    state = const AsyncValue.loading();
    try {
      final memories = await fetchMemoriesUseCase.execute(userId);
      state = AsyncValue.data(memories);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}