import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/follows_entity.dart';
import '../../domain/usecases/follow_request_usecase.dart';
import 'follow_request_repository_provider.dart';

// FollowRequestUseCaseプロバイダー
final followRequestUseCaseProvider = Provider<FollowRequestUseCase>((ref) {
  final repository = ref.watch(followsRepositoryProvider);
  return FollowRequestUseCase(repository: repository);
});

// 演者の登録を行うFutureProvider.family
final followRequestProvider = FutureProvider.family<void, FollowsInput>((ref, input) async {
  final followRequestProviderUseCase = ref.watch(followRequestUseCaseProvider);
  await followRequestProviderUseCase.execute(input);
});
