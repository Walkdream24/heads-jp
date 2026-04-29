import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notifications_entity.dart';
import '../../domain/usecases/fetch_notifications_usecase.dart';
import '../../domain/usecases/check_unread_notifications_usecase.dart';
import '../../domain/usecases/read_notifications_usecase.dart';
import 'notifications_repository_provider.dart';


final fetchNotificationsUseCaseProvider = Provider<FetchNotificationsUseCase>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return FetchNotificationsUseCase(repository: repository);
});

//お知らせリスト（通知一覧）を取得するFutureProvider.family
final fetchNotificationsProvider = FutureProvider.family<List<NotificationEntity>, String>((ref, userId) async {
  final fetchNotificationsUseCase = ref.watch(fetchNotificationsUseCaseProvider);
  return await fetchNotificationsUseCase.execute(userId);
});

final checkUnreadNotificationsUseCaseProvider = Provider<CheckUnreadNotificationsUseCase>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return CheckUnreadNotificationsUseCase(repository: repository);
});

//未読があるか
final checkUnReadNotificationsProvider = FutureProvider.family<bool, String>((ref, userId) async {
  final checkUnreadNotificationsUseCase = ref.watch(checkUnreadNotificationsUseCaseProvider);
  return await checkUnreadNotificationsUseCase.execute(userId);
});



final readNotificationsUseCaseUseCaseProvider = Provider<ReadNotificationsUseCase>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return ReadNotificationsUseCase(repository: repository);
});

//isReadをtureにする
final readNotificationsProvider = FutureProvider.family<void, List<String>>((ref, notificationIds) async {
  final readNotificationsUseCase = ref.watch(readNotificationsUseCaseUseCaseProvider);
  return await readNotificationsUseCase.execute(notificationIds);
});