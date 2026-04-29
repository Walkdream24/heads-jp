import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_summary_entity.dart';
import '../../domain/usecases/fetch_users_summary_usecase.dart';
import '../../domain/usecases/fetch_user_summary_usecase.dart';
import 'users_summary_repository_provider.dart';

// UseCaseプロバイダー
final fetchUsersSummaryUseCaseProvider = Provider<FetchUsersSummaryUseCase>((ref) {
  final repository = ref.watch(userSummaryRepositoryProvider);
  return FetchUsersSummaryUseCase(repository: repository);
});

// userIdsを渡して簡易的なユーザー情報を取得するFutureProvider
final usersSummaryProvider = FutureProvider
.family<List<UserSummaryEntity>, List<String>>(
  (ref, userIds) async {
    final fetchUsersSummaryUseCase = ref.watch(fetchUsersSummaryUseCaseProvider);
    return await fetchUsersSummaryUseCase.execute(userIds);
});

final fetchUserSummaryUseCaseProvider = Provider<FetchUserSummaryUseCase>((ref) {
  final repository = ref.watch(userSummaryRepositoryProvider);
  return FetchUserSummaryUseCase(repository: repository);
});

final userSummaryProvider = FutureProvider.family<UserSummaryEntity, String>((ref, userId) async {
  final fetchUserSummaryUseCase = ref.watch(fetchUserSummaryUseCaseProvider);
  return await fetchUserSummaryUseCase.execute(userId);
});