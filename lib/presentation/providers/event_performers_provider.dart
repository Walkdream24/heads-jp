import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event_performer_entity.dart';
import '../../domain/usecases/register_event_performer_usecase.dart';
import '../../domain/usecases/fetch_event_performers_usecase.dart';
import '../../domain/usecases/cancel_register_performer_usecase.dart';
import 'event_performers_repository_provider.dart';

// RegisterEventPerformerUseCaseプロバイダー
final registerEventPerformerUseCaseProvider = Provider<RegisterEventPerformerUseCase>((ref) {
  final repository = ref.watch(eventPerformersRepositoryProvider);
  return RegisterEventPerformerUseCase(repository: repository);
});

// 演者の登録を行うFutureProvider.family
final registerEventPerformerProvider = FutureProvider.family<void, RegisterPerfomerInput>((ref, input) async {
  final registerEventPerformerUseCase = ref.watch(registerEventPerformerUseCaseProvider);
  await registerEventPerformerUseCase.execute(input);
});

///イベント演者取得 
//FetchEventPerformersUseCaseプロバイダー
final fetchEventPerformersUseCaseProvider = Provider<FetchEventPerformersUseCase>((ref) {
  final repository = ref.watch(eventPerformersRepositoryProvider);
  return FetchEventPerformersUseCase(repository: repository);
});

//演者を取得するFutureProvider.family
final fetchEventPerformersProvider = FutureProvider.family<List<EventPerformerEntity>, String>((ref, eventId) async {
  final fetchEventPerformersUseCase = ref.watch(fetchEventPerformersUseCaseProvider);
  return await fetchEventPerformersUseCase.execute(eventId);
});

// CancelRegisterPerformerUseCaseプロバイダー
final cancelRegisterPerformerUseCaseProvider = Provider<CancelRegisterPerformerUseCase>((ref) {
  final repository = ref.watch(eventPerformersRepositoryProvider);
  return CancelRegisterPerformerUseCase(repository: repository);
});

// 演者の登録をキャンセルするFutureProvider.family
final cancelRegisterPerformerProvider = FutureProvider.family<void, String>((ref, eventPerformerId) async {
  final cancelRegisterPerformerUseCase = ref.watch(cancelRegisterPerformerUseCaseProvider);
  await cancelRegisterPerformerUseCase.execute(eventPerformerId);
});
