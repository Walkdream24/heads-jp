import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/blocked_users_entity.dart';
import '../../domain/usecases/get_block_relationship_usecase.dart';
import '../../domain/usecases/add_blocked_user_usecase.dart';
import '../../domain/usecases/delete_blocked_user_usecase.dart';
import '../providers/blocked_users_repository_provider.dart';

// ブロック関係の状態を管理するNotifier
class BlockRelationshipNotifier extends StateNotifier<BlockRelationshipType> {
  final GetBlockRelationshipUseCase getBlockRelationshipUseCase;
  final AddBlockedUserUseCase addBlockedUserUseCase;
  final DeleteBlockedUserUseCase deleteBlockedUserUseCase;
  
  BlockRelationshipNotifier({
    required this.getBlockRelationshipUseCase,
    required this.addBlockedUserUseCase,
    required this.deleteBlockedUserUseCase,
  }) : super(BlockRelationshipType.NONE);  // 初期状態はブロック関係なし

  // ブロック関係をチェックするメソッド
  Future<void> checkBlockRelationship(BlockedUsersInput input) async {
    try {
      final relationship = await getBlockRelationshipUseCase.execute(input);
      state = relationship;
    } catch (e) {
      debugPrint('Error checking block relationship: $e');
      // エラー時は状態を変更しない
    }
  }
  
  // ユーザーをブロックするメソッド
  Future<void> blockUser(BlockedUsersParams params) async {
    try {
      await addBlockedUserUseCase.execute(params);
      // ブロック成功後、状態を更新
      state = BlockRelationshipType.USER_BLOCKED_TARGET;
    } catch (e) {
      debugPrint('Error blocking user: $e');
      // エラー時は状態を変更しない
    }
  }
  
  // ブロック解除するメソッド
  Future<void> unblockUser(BlockedUsersParams params) async {
    try {
      await deleteBlockedUserUseCase.execute(params);
      // ブロック解除成功後、状態を更新
      state = BlockRelationshipType.NONE;
    } catch (e) {
      debugPrint('Error unblocking user: $e');
      // エラー時は状態を変更しない
    }
  }
}

// Providerの定義
final blockRelationshipProvider = StateNotifierProvider<BlockRelationshipNotifier, BlockRelationshipType>((ref) {
  final getBlockRelationshipUseCase = ref.watch(getBlockRelationshipUseCaseProvider);
  final addBlockedUserUseCase = ref.watch(addBlockedUserUseCaseProvider);
  final deleteBlockedUserUseCase = ref.watch(deleteBlockedUserUseCaseProvider);
  
  return BlockRelationshipNotifier(
    getBlockRelationshipUseCase: getBlockRelationshipUseCase,
    addBlockedUserUseCase: addBlockedUserUseCase,
    deleteBlockedUserUseCase: deleteBlockedUserUseCase,
  );
});

// 各UseCaseのProvider定義
final getBlockRelationshipUseCaseProvider = Provider<GetBlockRelationshipUseCase>((ref) {
  final repository = ref.watch(blockedUsersRepositoryProvider);
  return GetBlockRelationshipUseCase(repository: repository);
});

final addBlockedUserUseCaseProvider = Provider<AddBlockedUserUseCase>((ref) {
  final repository = ref.watch(blockedUsersRepositoryProvider);
  return AddBlockedUserUseCase(repository: repository);
});

final deleteBlockedUserUseCaseProvider = Provider<DeleteBlockedUserUseCase>((ref) {
  final repository = ref.watch(blockedUsersRepositoryProvider);
  return DeleteBlockedUserUseCase(repository: repository);
});