import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/combined_event_entity.dart';
import '../../domain/usecases/fetch_user_events_guest_usecase.dart';
import '../../domain/usecases/fetch_user_events_performer_usecase.dart';
import 'user_events_guest_repository_provider.dart';


//FetchUserEventsGuestUseCaseプロバイダー
final fetchUserEventsGuestUseCaseProvider = Provider<FetchUserEventsGuestUseCase>((ref) {
  final repository = ref.watch(userEventsGuestRepositoryProvider);
  return FetchUserEventsGuestUseCase(repository: repository);
});

//マイページのイベント（ゲスト参加）を取得するFutureProvider.family
final fetchUserEventsGuestProvider = FutureProvider.family<List<CombinedEventEntity>, String>((ref, userId) async {
  final fetchUserEventsGuestUseCase = ref.watch(fetchUserEventsGuestUseCaseProvider);
  return await fetchUserEventsGuestUseCase.execute(userId);
});

//FetchUserEventsPerformerUseCaseプロバイダー
final fetchUserEventsPerformerUseCaseProvider = Provider<FetchUserEventsPerformerUseCase>((ref) {
  final repository = ref.watch(userEventsGuestRepositoryProvider);
  return FetchUserEventsPerformerUseCase(repository: repository);
});

//マイページのイベント（演者参加）を取得するFutureProvider.family
final fetchUserEventsPerformerProvider = FutureProvider.family<List<CombinedEventEntity>, String>((ref, userId) async {
  final fetchUserEventsPerformerUseCase = ref.watch(fetchUserEventsPerformerUseCaseProvider);
  return await fetchUserEventsPerformerUseCase.execute(userId);
});