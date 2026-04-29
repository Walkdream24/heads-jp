import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile_header_entity.dart';
import 'package:HEADS/domain/entities/user_entity.dart';
import '../providers/user_provider.dart';



// profile_header_state.dart
final profileHeaderProvider = StateNotifierProvider.family<
    ProfileHeaderNotifier, ProfileHeaderEntity?, String>(
  (ref, userId) => ProfileHeaderNotifier(ref, userId),
);

class ProfileHeaderNotifier extends StateNotifier<ProfileHeaderEntity?> {
  final Ref ref;
  final String userId;

  ProfileHeaderNotifier(this.ref, this.userId) : super(null) {
    // 初期化時にユーザー情報を取得
    _initializeFromCurrentUser();
  }

  Future<void> _initializeFromCurrentUser() async {
    final userAsyncValue = await ref.read(currentUserProvider.future);
    if (userAsyncValue.uid == userId) {
      initialize(userAsyncValue.toProfileHeaderEntity());
    }
  }

  void initialize(ProfileHeaderEntity profileHeader) {
    if (mounted) {
      state = profileHeader;
    }
  }

  // フォロワー数を増加
  void incrementFollowers() {
    _updateFollowersCount(1);
  }

  // フォロワー数を減少
  void decrementFollowers() {
    _updateFollowersCount(-1);
  }

  // フォロー数を増加
  void incrementFollowing() {
    _updateFollowingCount(1);
  }

  // フォロー数を減少
  void decrementFollowing() {
    _updateFollowingCount(-1);
  }

  // フォロワー数を更新（内部メソッド）
  void _updateFollowersCount(int delta) {
    if (state != null && mounted) {
      state = state!.copyWith(
        followersCount: state!.followersCount + delta,
      );
    }
  }

  // フォロー数を更新（内部メソッド）
  void _updateFollowingCount(int delta) {
    if (state != null && mounted) {
      state = state!.copyWith(
        followingCount: state!.followingCount + delta,
      );
    }
  }

  // プロフィール情報を強制的に更新
  Future<void> forceUpdate() async {
    await _initializeFromCurrentUser();
  }
}
