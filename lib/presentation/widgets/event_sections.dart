import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event_entity.dart';
import '../widgets/all_live_event_list.dart';
import '../widgets/all_live_event_grid.dart';
import '../providers/events_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/loading_event_card.dart';
import '../../core/util/error_helper.dart';
import '../widgets/custom_native_ad_widget.dart';

class EventSections extends ConsumerStatefulWidget {
  final String clubId;

  const EventSections({super.key, required this.clubId});

  @override
  ConsumerState<EventSections> createState() => _EventSectionsState();
}

class _EventSectionsState extends ConsumerState<EventSections> {
  String? selectedEventId;

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(currentUserProvider);

    return userAsyncValue.when(
      data: (currentUser) {
        final eventsAsyncValue = ref.watch(eventsByClubIdProvider(widget.clubId));

        return eventsAsyncValue.when(
          data: (events) {
            // イベントのフィルタリング
            final ongoingEvents = _filterOngoingEvents(events);
            final otherEvents = _filterOtherEvents(events);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '本日開催のイベント',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ongoingEvents.isNotEmpty
                    ? AllLiveEventList(liveEvents: ongoingEvents)
                    : const Text(
                        '本日開催中のイベントはありません。',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '他日程のイベント',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return AllLiveEventGrid(events: otherEvents);
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
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AllLiveEventList(liveEvents: otherEvents),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomNativeAdWidget(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
          loading: () => const LoadingCard(),
          error: (error, stack) => Text(
            getLocalizedErrorMessage(error),
            style: const TextStyle(color: Colors.red),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text(
        getLocalizedErrorMessage(error),
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildNativeAd(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // 最小幅と最大幅を設定してバリデーションエラーを防ぐ
    final adWidth = (screenWidth - 32.0).clamp(300.0, 400.0);
    
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: CustomNativeAdWidget(
        width: adWidth,
        height: 250,
        backgroundColor: Colors.white,
      ),
    );
  }


  // 開催イベントのフィルタリング
  List<EventEntity> _filterOngoingEvents(List<EventEntity> events) {
    final now = DateTime.now();
    return events.where((event) {
      final isOngoing = event.startDatetime.isBefore(now) && event.endDatetime.isAfter(now); // 開催中
      final isFutureTodayEvent =
          event.startDatetime.day == now.day &&
          event.startDatetime.isAfter(now) &&
          event.endDatetime.isAfter(now); // 今日でこれから開催かつ終了時間が現在時刻より後
      return isOngoing || isFutureTodayEvent; // どちらかの条件を満たす場合に表示
    }).toList();
  }

  // 他日程のイベントのフィルタリング
  List<EventEntity> _filterOtherEvents(List<EventEntity> events) {
    final now = DateTime.now();

    return events.where((event) {
      // 開催中または今日これから始まるイベントを除外
      final isOngoingOrFutureToday =
          (event.startDatetime.isBefore(now) && event.endDatetime.isAfter(now)) || // 開催中
          (event.startDatetime.day == now.day &&
           event.startDatetime.isAfter(now) &&
           event.endDatetime.isAfter(now)); // 今日これから開催かつ終了時刻が未来

      // 開催イベントでないものを取得
      return !isOngoingOrFutureToday;
    }).toList();
  }
}