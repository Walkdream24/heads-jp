import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/live_event_list.dart';
import '../widgets/memory_list.dart';
import '../providers/user_events_guest_provider.dart';
// import '../providers/memories_provider.dart';
import '../providers/memory_post_notifier.dart';
import '../widgets/loading_event_list.dart';
import '../../core/util/error_helper.dart';
import '../widgets/all_live_event_grid.dart';
import '../widgets/gradient_button.dart'; 
import '../pages/event_register_page.dart';

class MyPageSections extends ConsumerWidget {
  final String userId;
  final bool isMyPage;

  const MyPageSections({
    super.key, 
    required this.userId,
    required this.isMyPage
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsGuestAsyncValue = ref.watch(fetchUserEventsGuestProvider(userId));
    final eventsPerformerAsyncValue = ref.watch(fetchUserEventsPerformerProvider(userId));
    final memoriesAsyncValue = ref.watch(memoriesProvider(userId));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 行ったライブセクション
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '行ったライブ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              eventsGuestAsyncValue.when(
                data: (events) {
                  final now = DateTime.now();
                  final pastEvents = events
                      .where((event) => event.event.endDatetime.isBefore(now))
                      .toList();
                  
                  // 表示するイベントがある場合のみ「もっと見る」を表示
                  if (pastEvents.isNotEmpty) {
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return AllLiveEventGrid(events: pastEvents.map((e) => e.event).toList());
                          },
                        );
                      },
                      child: const Text(
                        'もっと見る',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink(); // イベントがない場合は何も表示しない
                  }
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          eventsGuestAsyncValue.when(
            data: (events) {
              final now = DateTime.now();
              final pastEvents = events
                  .where((event) => event.event.endDatetime.isBefore(now)) // 終了時刻が現在より前
                  .toList();
              if (pastEvents.isEmpty) {
                return const Text(
                  '行ったライブはありません',
                  style: TextStyle(color: Colors.grey),
                );
              }
              return LiveEventList(liveEvents: pastEvents);
            },
            loading: () => const LoadingEventList(itemCount: 5,),
            error: (error, stack) => Text(
              getLocalizedErrorMessage(error),
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 24),
          // 参加予定ライブセクション
          const Text(
            '参加予定のライブ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          eventsGuestAsyncValue.when(
            data: (events) {
              final now = DateTime.now();
              final upcomingEvents = events
                  .where((event) => 
                      event.event.startDatetime.isAfter(now) || // 開始時刻が現在より後
                      (event.event.startDatetime.isBefore(now) && event.event.endDatetime.isAfter(now)) // 現在進行中
                  )
                  .toList();
              if (upcomingEvents.isEmpty) {
                return const Text(
                  '参加予定ライブはありません',
                  style: TextStyle(color: Colors.grey),
                );
              }
              return LiveEventList(liveEvents: upcomingEvents);
            },
            loading: () => const LoadingEventList(itemCount: 5,),
            error: (error, stack) => Text(
              getLocalizedErrorMessage(error),
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 24),
          // 出演予定ライブセクション
          const Text(
            '出演予定のライブ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          eventsPerformerAsyncValue.when(
            data: (events) {
              final now = DateTime.now();
              final upcomingPerformances = events
                  .where((event) => 
                      event.event.startDatetime.isAfter(now) || // 開始時刻が現在より後
                      (event.event.startDatetime.isBefore(now) && event.event.endDatetime.isAfter(now)) // 現在進行中
                  )
                  .toList();
              if (upcomingPerformances.isEmpty) {
                return const Text(
                  '出演予定ライブはありません',
                  style: TextStyle(color: Colors.grey),
                );
              }
              return LiveEventList(liveEvents: upcomingPerformances);
            },
            loading: () => const LoadingEventList(itemCount: 5,),
            error: (error, stack) => Text(
              getLocalizedErrorMessage(error),
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 24),
          // 出演済みライブセクション
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '出演済みのライブ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              eventsPerformerAsyncValue.when(
                data: (events) {
                  final now = DateTime.now();
                  final pastPerformances = events
                      .where((event) => event.event.endDatetime.isBefore(now))
                      .toList();
                  
                  // 表示するイベントがある場合のみ「もっと見る」を表示
                  if (pastPerformances.isNotEmpty) {
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return AllLiveEventGrid(events: pastPerformances.map((e) => e.event).toList());
                          },
                        );
                      },
                      child: const Text(
                        'もっと見る',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink(); // イベントがない場合は何も表示しない
                  }
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          eventsPerformerAsyncValue.when(
            data: (events) {
              final now = DateTime.now();
              final pastPerformances = events
                  .where((event) => event.event.endDatetime.isBefore(now)) // 終了時刻が現在より前
                  .toList();
              if (pastPerformances.isEmpty) {
                return const Text(
                  '出演済みライブはありません',
                  style: TextStyle(color: Colors.grey),
                );
              }
              return LiveEventList(liveEvents: pastPerformances);
            },
            loading: () => const LoadingEventList(itemCount: 5,),
            error: (error, stack) => Text(
              getLocalizedErrorMessage(error),
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 24),
          
          // 過去のイベントを追加するボタン（isMyPageがtrueの場合のみ表示）
          if (isMyPage) ...[
            GradientButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (context) => const EventRegisterPage()),
                );
              },
              text: '過去のイベントを追加',
            ),
            const SizedBox(height: 24),
          ],
          
          // メモリーズセクション
          const Text(
            'メモリーズ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          memoriesAsyncValue.when(
            data: (memories) {
              if (memories.isEmpty && !isMyPage) {
                return const Text(
                  'メモリーズはありません',
                  style: TextStyle(color: Colors.grey),
                );
              }
              return MemoryList(memories: memories,isMyPage: isMyPage,);
            },
            loading: () => const LoadingEventList(itemCount: 5,),
            error: (error, stack) => Text(
              getLocalizedErrorMessage(error),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}