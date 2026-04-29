import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/event_card.dart';
import '../widgets/memories_grid.dart';
import '../widgets/memory_detail_dialog.dart';
import '../../domain/entities/event_entity.dart';

class EventDetailModal extends ConsumerWidget {
  final EventEntity event;

  const EventDetailModal({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isClosing = false;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent < 0.2 && !isClosing) {
          isClosing = true;
          if (context.mounted) {
            Navigator.of(context).maybePop();
          }
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 0,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [1.0],
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF000000),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                // イベントカードセクション
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        EventCard(event: event),
                        const SizedBox(height: 16),
                        const Text(
                          'みんなのメモリー',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // メモリーグリッドセクション
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: MemoriesGrid(
                    eventId: event.eventId,
                    onMemoryTap: (memory) {
                      showMemoryDialog(
                        context,
                        memory
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 40.0), 
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}