import '../entities/user_entity.dart';
import '../entities/profile_header_entity.dart';

abstract class UserRepository {
  Future<UserEntity> fetchCurrentUser();
  Future<UserEntity> fetchUserProfile(String userId);
  Future<void> updateUserProfile(ProfileHeaderEntity input);
  Future<bool> checkheadsIdExists(String inputId);
  Future<bool> checkEmailExists(String inputEmail);
  Future<LocationVisibilitySettingType> fetchLocationVisibilitySetting(
    String userId
  );
  Future<void> updateLocationVisibilitySetting(
    LocationSettingParams input,
  );
}
