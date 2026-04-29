import 'package:flutter/foundation.dart';
import 'package:HEADS/domain/usecases/register_event_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/usecases/fetch_events_by_club_id_usecase.dart';
import '../../domain/usecases/fetch_events_by_user_id_usecase.dart';
import '../../domain/usecases/fetch_event_by_id_usecase.dart';
import '../../domain/usecases/fetch_today_events_usecase.dart';
import '../../domain/usecases/fetch_week_events_usecase.dart';
import 'events_repository_provider.dart';
import '../../domain/entities/combined_event_entity.dart';
import '../../domain/usecases/fetch_nearby_events_usecase.dart';
import '../../domain/entities/user_locations_entity.dart';

// FetchEventsByClubIdUseCaseプロバイダー
final fetchEventsByClubIdUseCaseProvider = Provider<FetchEventsByClubIdUseCase>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return FetchEventsByClubIdUseCase(repository: repository);
});

// クラブIDを指定してイベントリストを取得するFutureProvider
final eventsByClubIdProvider = FutureProvider.family<List<EventEntity>, String>((ref, clubId) async {
  final fetchEventsUseCase = ref.watch(fetchEventsByClubIdUseCaseProvider);
  return await fetchEventsUseCase.execute(clubId);
});



final fetchEventsByUserIdUseCaseProvider = Provider<FetchEventsByUserIdUseCase>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return FetchEventsByUserIdUseCase(repository: repository);
});

// userIDを指定してイベントリストを取得するFutureProvider
final eventsByUserIdProvider = FutureProvider.family<List<EventEntity>, String>((ref, userId) async {
  final fetchEventsUseCase = ref.watch(fetchEventsByUserIdUseCaseProvider);
  return await fetchEventsUseCase.execute(userId);
});

final selectedEventProvider = StateProvider<EventEntity?>((ref) => null);

final fetchEventByIdUseCaseProvider = Provider<FetchEventByIdUseCase>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return FetchEventByIdUseCase(repository: repository);
});

final fetchEventByIdProvider = FutureProvider.family<EventEntity, String>((ref, eventId) async {
  debugPrint("fetchEventByIdProvider");
  final fetchEventUseCase = ref.watch(fetchEventByIdUseCaseProvider);
  return await fetchEventUseCase.execute(eventId);
});

final registerEventUseCaseProvider = Provider<RegisterEventUseCase>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return RegisterEventUseCase(repository: repository);
});

final registerEventProvider = FutureProvider.family<void, EventEntity>((ref, input) async {
  final registerEventUseCase = ref.watch(registerEventUseCaseProvider);
  await registerEventUseCase.execute(input);
});


final fetchTodayEventsUseCaseProvider = Provider<FetchTodayEventsUseCase>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return FetchTodayEventsUseCase(repository: repository);
});

final fetchTodayEventsProvider = FutureProvider<List<CombinedEventEntity>>((ref) async {
  final fetchTodayEventsUseCase = ref.watch(fetchTodayEventsUseCaseProvider);
  return await fetchTodayEventsUseCase.execute();
});


final fetchWeekEventsUseCaseProvider = Provider<FetchWeekEventsUseCase>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return FetchWeekEventsUseCase(repository: repository);
});

final fetchWeekEventsProvider = FutureProvider<List<CombinedEventEntity>>((ref) async {
  final fetchWeekEventsUseCase = ref.watch(fetchWeekEventsUseCaseProvider);
  return await fetchWeekEventsUseCase.execute();
});

final fetchNearbyEventsUseCaseProvider = Provider<FetchNearbyEventsUseCase>((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return FetchNearbyEventsUseCase(repository: repository);
});


final fetchNearbyEventsProvider = FutureProvider.family<List<CombinedEventEntity>, AddUserLocationInput>((ref, input) async {
  final fetchNearbyEventsUseCase = ref.watch(fetchNearbyEventsUseCaseProvider);
  return await fetchNearbyEventsUseCase.execute(input);
});
