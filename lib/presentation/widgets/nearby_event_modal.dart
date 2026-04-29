import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/util/date_time_utils.dart';
import '../widgets/event_detail_modal.dart';
import '../../domain/entities/user_locations_entity.dart';
import '../providers/events_provider.dart';
import '../../domain/entities/event_entity.dart';

class NearbyEventsModal extends ConsumerStatefulWidget {
  final double currentLatitude;
  final double currentLongitude;
  final VoidCallback? onClose; // 閉じる時のコールバック追加


  const NearbyEventsModal({
    super.key,
    required this.currentLatitude,
    required this.currentLongitude,
    this.onClose,
  });

  @override
  ConsumerState<NearbyEventsModal> createState() =>
      _NearbyEventsModalState();
}

class _NearbyEventsModalState
    extends ConsumerState<NearbyEventsModal> {
  bool isClosing = false;

  @override
  Widget build(BuildContext context) {
    final input = AddUserLocationInput(
      userId: "",
      latitude: widget.currentLatitude,
      longitude: widget.currentLongitude,
    );

    final nearbyEventsAsync = ref.watch(fetchNearbyEventsProvider(input));

 return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        // モーダルが完全に閉じられた時（extent が 0 に近い時）
        if (notification.extent < 0.05 && !isClosing) {
          setState(() {
            isClosing = true;
          });
          
          // onCloseコールバックを呼び出し
          widget.onClose?.call();
          
          return true;
        }
        return false;
      },
        child: DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0,
          maxChildSize: 0.5,
          snap: true,
          snapSizes: const [0.3],
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF282829),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ハンドルバー
                      Center(
                        child: Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // タイトル
                      const Text(
                        '近くのイベント',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // イベントリスト
                      nearbyEventsAsync.when(
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, stackTrace) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'エラーが発生しました',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  error.toString(),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        data: (events) {
                          if (events.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.event_busy,
                                      color: Colors.grey[400],
                                      size: 48,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '近くにイベントがありません',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          
                          return SizedBox(
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                final event = events[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return EventDetailModal(event: event.event);
                                        },
                                      );
                                    },
                                    child: SizedBox(
                                      width: 100,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  imageUrl: event.event.flyerPhotoUrl,
                                                  width: 100,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Container(
                                                    width: 150,
                                                    height: 200,
                                                    color: Colors.grey[800],
                                                    child: const Center(
                                                      child: CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    width: 100,
                                                    height: 150,
                                                    color: Colors.grey[800],
                                                    child: const Icon(
                                                      Icons.error,
                                                      color: Colors.grey,
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
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            event.clubName,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text(
                                            '${(event.distanceKm! * 100).floor() / 100}km',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
}