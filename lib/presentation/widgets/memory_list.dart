import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';
import 'memory_detail_modal.dart';
import '../../domain/entities/memories_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../pages/add_memory_page.dart';

class MemoryList extends ConsumerWidget {
  final List<MemoryEntity> memories;
  final bool isMyPage;

  const MemoryList({
    super.key,
    required this.memories,
    this.isMyPage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: isMyPage ? memories.length + 1 : memories.length,
        itemBuilder: (context, index) {
          if (isMyPage && index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const AddMemoryPage()
                    ),
                  );
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: const [5, 5],
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          final memory = memories[isMyPage ? index - 1 : index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true, // これにより全画面表示が可能になります
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return MemoryDetailModal(
                      memory: memory,
                      isMyPage: isMyPage,
                    );
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: memory.photoUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}