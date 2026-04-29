import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/profile_header_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> fetchCurrentUser() async {
    try {
      final result = await remoteDataSource.fetchCurrentUser();
      return UserEntity(
        uid: result.uid,
        username: result.username,
        headsId: result.headsId,
        email: result.email,
        followersCount: result.followersCount,
        followingCount: result.followingCount,
        bio: result.bio,
        bioLink: result.bioLink,
        profilePhotoUrl: result.profilePhotoUrl,
        instagramId: result.instagramId,
        xId: result.xId,
        youtubeId: result.youtubeId,
        soundcloudId: result.soundcloudId,
        isPrivate: result.isPrivate,
        locationVisibilitySetting: result.locationVisibilitySetting,
      );
    } catch (e) {
      debugPrint("UserRepositoryImplでエラー$e");
      rethrow;
    }
  }

  @override
  Future<UserEntity> fetchUserProfile(String userId) async {
    try {
      final result = await remoteDataSource.fetchUserProfile(userId);
      return UserEntity(
        uid: result.uid,
        username: result.username,
        headsId: result.headsId,
        email: result.email,
        followersCount: result.followersCount,
        followingCount: result.followingCount,
        bio: result.bio,
        bioLink: result.bioLink,
        profilePhotoUrl: result.profilePhotoUrl,
        instagramId: result.instagramId,
        xId: result.xId,
        youtubeId: result.youtubeId,
        soundcloudId: result.soundcloudId,
        isPrivate: result.isPrivate,
        locationVisibilitySetting: result.locationVisibilitySetting,
      );
    } catch (e) {
      debugPrint("UserRepositoryImplでエラー$e");
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile(ProfileHeaderEntity input) async {
    try {
      await remoteDataSource.updateUserProfile(input);
    } catch (e) {
      debugPrint("UserRepositoryImplでエラー$e");
      rethrow;
    }
  }
  
  @override
  Future<bool> checkheadsIdExists(String inputId) async {
    try {
      return await remoteDataSource.checkheadsIdExists(inputId);
    } catch (e) {
      debugPrint("UserRepositoryImplでエラー$e");
      rethrow;
    }
  }

  @override
  Future<bool> checkEmailExists(String inputEmail) async {
    try {
      return await remoteDataSource.checkEmailExists(inputEmail);
    } catch (e) {
      debugPrint("UserRepositoryImplでエラー$e");
      rethrow;
    }
  }

  @override
  Future<LocationVisibilitySettingType> fetchLocationVisibilitySetting(
    String userId
  ) async {
    try {
      return await remoteDataSource.fetchLocationVisibilitySetting(userId);
    } catch (e) {
      debugPrint("UserRepositoryImplでエラー$e");
      rethrow;
    }
  }

  @override
  Future<void> updateLocationVisibilitySetting(
    LocationSettingParams input
  ) async {
    try {
      return await remoteDataSource.updateLocationVisibilitySetting(input);
    } catch (e) {
      debugPrint("UserRepositoryImplでエラー$e");
      rethrow;
    }
  }

}
