import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event_guest_entity.dart';
import '../../domain/usecases/register_event_guest_usecase.dart';
import '../../domain/usecases/fetch_event_guests_usecase.dart';
import '../../domain/usecases/cancel_register_guest_usecase.dart';
import 'event_guest_repository_provider.dart';

// RegisterEventGuestUseCaseプロバイダー
final registerEventGuestUseCaseProvider = Provider<RegisterEventGuestUseCase>((ref) {
  final repository = ref.watch(eventGuestRepositoryProvider);
  return RegisterEventGuestUseCase(repository: repository);
});

// ゲストの登録を行うFutureProvider.family
final registerEventGuestProvider = FutureProvider.family<void, RegisterGuestInput>((ref, input) async {
  final registerEventGuestUseCase = ref.watch(registerEventGuestUseCaseProvider);
  await registerEventGuestUseCase.execute(input);
});

///イベントゲスト取得 
//FetchEventPerformersUseCaseプロバイダー
final fetchEventGuestsUseCaseProvider = Provider<FetchEventGuestsUseCase>((ref) {
  final repository = ref.watch(eventGuestRepositoryProvider);
  return FetchEventGuestsUseCase(repository: repository);
});

//ゲストを取得するFutureProvider.family
final fetchEventGuestsProvider = FutureProvider.family<List<EventGuestEntity>, String>((ref, eventId) async {
  final fetchEventGuestsUseCase = ref.watch(fetchEventGuestsUseCaseProvider);
  return await fetchEventGuestsUseCase.execute(eventId);
});

// RegisterEventGuestUseCaseプロバイダー
final cancelRegisterGuestUseCaseProvider = Provider<CancelRegisterGuestUseCase>((ref) {
  final repository = ref.watch(eventGuestRepositoryProvider);
  return CancelRegisterGuestUseCase(repository: repository);
});

// ゲストの登録キャンセル行うFutureProvider.family
final cancelRegisterGuestProvider = FutureProvider.family<void, String>((ref, eventGuestId) async {
  final cancelRegisterGuestUseCase = ref.watch(cancelRegisterGuestUseCaseProvider);
  await cancelRegisterGuestUseCase.execute(eventGuestId);
});