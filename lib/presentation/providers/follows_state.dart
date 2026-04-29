// providers/follows_state.dart

import 'package:HEADS/domain/usecases/un_follow_user_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/follows_entity.dart';
import '../../domain/usecases/follow_request_usecase.dart';
import '../../domain/usecases/check_follows_status_usecase.dart';
import '../../domain/usecases/follow_return_usecase.dart';
import './follows_provider.dart';
import './profile_header_state.dart';

final profileHeaderNotifierProvider = Provider.family<ProfileHeaderNotifier, String>(
  (ref, userId) => ref.read(profileHeaderProvider(userId).notifier),
);

// 新しいStateNotifierProvider
final followStateProvider = StateNotifierProvider.family<
  FollowStateNotifier,
  AsyncValue<FollowCheckResult>,
  FollowsInput
>(
  // familyで受け取る「input」は FollowsInput型
  (ref, input) => FollowStateNotifier(
    checkFollowsStatusUseCase: ref.watch(checkFollowsStatusUseCaseProvider),
    followRequestUseCase: ref.watch(followRequestUseCaseProvider),
    followReturnUseCase: ref.watch(followReturnUseCaseProvider),
    unFollowUserUseCase: ref.watch(unFollowUserUseCaseProvider),
    input: input, // コンストラクタへ渡す
    ref: ref,
  ),
);

class FollowStateNotifier extends StateNotifier<AsyncValue<FollowCheckResult>> {
  final CheckFollowsStatusUseCase checkFollowsStatusUseCase;
  final FollowRequestUseCase followRequestUseCase;
  final FollowReturnUseCase followReturnUseCase;
  final UnFollowUserUseCase unFollowUserUseCase;
  final Ref ref;

  final FollowsInput input;

  FollowStateNotifier({
    required this.checkFollowsStatusUseCase,
    required this.followRequestUseCase,
    required this.followReturnUseCase,
    required this.unFollowUserUseCase,
    required this.input,
    required this.ref,
  }) : super(const AsyncValue.loading()) {
    // コンストラクタでまずはフォロー状態チェック
    checkStatus();
  }

  Future<void> checkStatus() async {
    try {
      state = const AsyncValue.loading();

      // ここで input.userId, input.targetUserId の2つの情報が使える
      final result = await checkFollowsStatusUseCase.execute(
        FollowsInput(
          userId: input.userId,
          targetUserId: input.targetUserId,
        ),
      );
      state = AsyncValue.data(result);

    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // toggleFollowも同様に、input.userId / input.targetUserId が使える
  Future<void> toggleFollow() async {
    if (state is! AsyncData) return;
    final currentState = (state as AsyncData<FollowCheckResult>).value;
    final previousState = state;

    try {
      // 楽観的更新
      final newStatus = _determineNewStatus(currentState);
      state = AsyncValue.data(
        FollowCheckResult(
          isFollowing: !currentState.isFollowing,
          isFollowedBy: currentState.isFollowedBy,
          status: newStatus,
        ),
      );

      final profileNotifier = ref.read(profileHeaderProvider(input.targetUserId).notifier);
      if (!currentState.isFollowing) {
        // フォローする場合
        profileNotifier.incrementFollowers();
        ref.read(profileHeaderProvider(input.userId).notifier).incrementFollowing();
      } else {
        // フォロー解除する場合
        profileNotifier.decrementFollowers();
        ref.read(profileHeaderProvider(input.userId).notifier).decrementFollowing();
      }

      if (!currentState.isFollowing) {
        await followRequestUseCase.execute(input);
      } else {
        await unFollowUserUseCase.execute(input);
      }

      // 成功したら再度 checkStatus
      // await checkStatus();

    } catch (error) {
      // 失敗時は元に戻す
      state = previousState;
      // ProfileHeaderNotifierも元に戻す
      final profileNotifier = ref.read(profileHeaderProvider(input.targetUserId).notifier);
      if (!currentState.isFollowing) {
        profileNotifier.decrementFollowers();
        ref.read(profileHeaderProvider(input.userId).notifier).decrementFollowing();
      } else {
        profileNotifier.incrementFollowers();
        ref.read(profileHeaderProvider(input.userId).notifier).incrementFollowing();
      }
      rethrow;
    }
  }

  FollowStatus _determineNewStatus(FollowCheckResult currentState) {
    if (currentState.isFollowing) {
      return FollowStatus.NONE;
    } else {
      if (currentState.status == FollowStatus.NONE) {
        return FollowStatus.REQUESTED;
      } else if (currentState.status == FollowStatus.REQUESTED) {
        return FollowStatus.ACCEPTED;
      }
      return currentState.status;
    }
  }
}