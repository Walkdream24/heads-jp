import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/util/date_time_utils.dart';
import '../providers/events_provider.dart';
import '../../domain/entities/combined_event_entity.dart';
import '../widgets/loading_all_today_event_grid.dart';
import '../../core/util/error_helper.dart';
import '../widgets/custom_native_ad_widget.dart';
import '../../domain/entities/event_entity.dart';
import '../widgets/event_add_banner.dart';
import '../widgets/event_detail_modal.dart';
import '../pages/event_search_page.dart';

class AllTodayEventGrid extends ConsumerWidget {
  const AllTodayEventGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'イベント',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const EventSearchPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final todayEventsAsync = ref.watch(fetchTodayEventsProvider);
          final weekEventsAsync = ref.watch(fetchWeekEventsProvider);

          // 両方のプロバイダーの状態を組み合わせる
          return todayEventsAsync.when(
            loading: () => const EventGridLoading(),
            error: (error, stack) => Center(
              child: Text(
                getLocalizedErrorMessage(error),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            data: (todayEvents) => weekEventsAsync.when(
              loading: () => const EventGridLoading(),
              error: (error, stack) => Center(
                child: Text(
                  getLocalizedErrorMessage(error),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              data: (weekEvents) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // EventAddBannerを追加
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
                      child: EventAddBanner(),
                    ),

                    // 本日のイベントセクション
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "本日開催のイベント",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (todayEvents.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            '本日開催のイベントはありません',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildEventGrid(context, todayEvents),
                      ),

                    // バナー広告を挿入
                    const Center(
                      child: CustomBannerAdWidget(
                        width: double.infinity,
                        adSize: AdSize.largeBanner, 
                        margin: EdgeInsets.only(
                          bottom: 24, 
                          left: 16.0,
                          right: 16.0,
                        ),
                      ),
                    ),

                    // 今週のイベントセクション
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "今週開催のイベント",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (weekEvents.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            '今週開催のイベントはありません',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildEventGrid(context, weekEvents),
                      ),
                    // バナー広告を挿入
                    const Center(
                      child: CustomBannerAdWidget(
                        width: double.infinity,
                        adSize: AdSize.largeBanner, 
                        margin: EdgeInsets.only(
                          bottom: 24, 
                          left: 16.0,
                          right: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventGrid(BuildContext context, List<CombinedEventEntity> events) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.53,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return GestureDetector(
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return EventDetailModal(event: event.event);
              }
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: event.event.flyerPhotoUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // ジャンルタグの表示
                  if (event.event.genre != null && event.event.genre!.isNotEmpty)
                    Positioned(
                      left: 4,
                      bottom: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 最大2つのジャンルを表示
                          ...event.event.genre!
                              .where((genre) => genre != EventGenre.NONE)
                              .take(2)
                              .map((genre) => Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      genre.displayName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )),
                          // 3つ以上の場合は「...」を表示
                          if (event.event.genre!.where((genre) => genre != EventGenre.NONE).length > 2)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'etc...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                event.event.eventName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatDate(event.event.date),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                event.clubName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}