import 'package:flutter/material.dart';
import '../../domain/entities/event_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/util/date_time_utils.dart';
import '../widgets/event_detail_modal.dart';

class AllLiveEventList extends StatelessWidget {
  final List<EventEntity> liveEvents;

  const AllLiveEventList({
    super.key,
    required this.liveEvents,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: liveEvents.length,
        itemBuilder: (context, index) {
          final event = liveEvents[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return EventDetailModal(event: event);
                  },
                );
              },
              child: SizedBox(
                width: 150, // アイテムの幅を固定
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: event.flyerPhotoUrl,
                        width: 150,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.eventName,
                      maxLines: 1, // 最大行数を1に設定
                      overflow: TextOverflow.ellipsis, // 長すぎる場合は省略
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formatDate(event.date),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
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
  }
}
