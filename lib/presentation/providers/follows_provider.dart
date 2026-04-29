import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/follows_entity.dart';
import '../../domain/entities/user_summary_entity.dart';
import '../../domain/usecases/follow_request_usecase.dart';
import '../../domain/usecases/check_follows_status_usecase.dart';
import '../../domain/usecases/fetch_request_follows_usecase.dart';
import '../../domain/usecases/un_follow_user_usecase.dart';
import '../../domain/usecases/follow_return_usecase.dart';
import '../../domain/usecases/fetch_common_followers_usecase.dart';
import '../../domain/usecases/fetch_follower_list_usecase.dart';
import '../../domain/usecases/fetch_following_list_usecase.dart';
import 'follows_repository_provider.dart';

// FollowRequestUseCaseプロバイダー
final followRequestUseCaseProvider = Provider<FollowRequestUseCase>((ref) {
  final repository = ref.watch(followsRepositoryProvider);
  return FollowRequestUseCase(repository: repository);
});

// FollowReturnUseCaseプロバイダー
final followReturnUseCaseProvider = Provider<FollowReturnUseCase>((ref) {
  final repository = ref.watch(followsRepositoryProvider);
  return FollowReturnUseCase(repository: repository);
});

final unFollowUserUseCaseProvider = Provider<UnFollowUserUseCase>((ref) {
   final repository = ref.watch(followsRepositoryProvider);
   return UnFollowUserUseCase(repository: repository);
});

// CheckFollowsStatusUseCaseプロバイダー
final checkFollowsStatusUseCaseProvider = Provider<CheckFollowsStatusUseCase>((ref) {
  final repository = ref.watch(followsRepositoryProvider);
  return CheckFollowsStatusUseCase(repository: repository);
});

// FetchRequestFollowsUseCaseプロバイダー
final fetchRequestFollowsUseCaseProvider = Provider<FetchRequestFollowsUseCase>((ref) {
  final repository = ref.watch(followsRepositoryProvider);
  return FetchRequestFollowsUseCase(repository: repository);
});

// userIdを渡してフォローリクエストを送ったユーザーを取得するFutureProvider
final fetchRequestFollowsProvider = FutureProvider
.family<List<UserSummaryEntity>, String>(
  (ref, userId) async {
    final fetchRequestFollowsUseCase = ref.watch(fetchRequestFollowsUseCaseProvider);
    return await fetchRequestFollowsUseCase.execute(userId);
});

// FetchCommonFollowersUseCaseプロバイダー
final fetchCommonFollowersUseCaseProvider = Provider<FetchCommonFollowersUseCase>((ref) {
  final repository = ref.watch(followsRepositoryProvider);
  return FetchCommonFollowersUseCase(repository: repository);
});

final fetchCommonFollowersProvider = FutureProvider
.family<List<UserSummaryEntity>, FollowsInput>(
  (ref, input) async {
    final fetchCommonFollowersUseCase = ref.watch(fetchCommonFollowersUseCaseProvider);
    return await fetchCommonFollowersUseCase.execute(input);
});

// FetchFollowerListUseCaseプロバイダー
final fetchFollowerListUseCaseProvider = Provider<FetchFollowerListUseCase>((ref) {
  final repository = ref.watch(followsRepositoryProvider);
  return FetchFollowerListUseCase(repository: repository);
});

final fetchFollowerListProvider = FutureProvider
.family<List<UserSummaryEntity>, String>(
  (ref, userId) async {
    final fetchFollowerListUseCase = ref.watch(fetchFollowerListUseCaseProvider);
    return await fetchFollowerListUseCase.execute(userId);
});

// FetchFollowingListUseCaseプロバイダー
final fetchFollowingListUseCaseProvider = Provider<FetchFollowingListUseCase>((ref) {
  final repository = ref.watch(followsRepositoryProvider);
  return FetchFollowingListUseCase(repository: repository);
});


final fetchFollowingListProvider = FutureProvider
.family<List<UserSummaryEntity>, String>(
  (ref, userId) async {
    final fetchFollowingListUseCase = ref.watch(fetchFollowingListUseCaseProvider);
    return await fetchFollowingListUseCase.execute(userId);
});