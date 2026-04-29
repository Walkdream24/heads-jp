import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/memories_entity.dart';
import '../providers/memories_provider.dart';
import '../../core/util/error_helper.dart';

class MemoriesGrid extends ConsumerWidget {
  final String eventId;
  final void Function(MemoryEntity memory)? onMemoryTap;
  
  const MemoriesGrid({
    Key? key,
    required this.eventId,
    this.onMemoryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoriesAsync = ref.watch(fetchEventMemoriesProvider(eventId));

    return memoriesAsync.when(
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Center(child: Text(
          getLocalizedErrorMessage(error),
        )),
      ),
      data: (memories) {
        if (memories.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('メモリーがありません')),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverMasonryGrid(
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final memory = memories[index];
                final double heightFactor = (index % 5 == 0 || index % 3 == 0) ? 1.5 : 1.0;
                
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: InkWell(
                    onTap: () => onMemoryTap?.call(memory),
                    child: CachedNetworkImage(
                      imageUrl: memory.photoUrl,
                      height: 200 * heightFactor,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 200 * heightFactor,
                        color: Colors.grey[800],
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200 * heightFactor,
                        color: Colors.grey[800],
                        child: const Icon(Icons.error, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
              childCount: memories.length,
            ),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
          ),
        );
      },
    );
  }
}