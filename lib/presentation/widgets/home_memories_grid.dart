import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/show_combined_memory_dialog.dart';
import '../providers/memories_provider.dart';
import '../../core/util/error_helper.dart';
import '../widgets/gradient_button.dart';
import '../pages/add_memory_page.dart';

class HomeMemoriesGrid extends ConsumerStatefulWidget {
  const HomeMemoriesGrid({super.key});

  @override
  ConsumerState<HomeMemoriesGrid> createState() => _HomeMemoriesGridState();
}

class _HomeMemoriesGridState extends ConsumerState<HomeMemoriesGrid> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      ref.read(homeMemoriesStateProvider.notifier).fetchMemories()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'みんなのメモリー',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildMemoriesGrid(),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: GradientButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const AddMemoryPage()
                  ),
                );
              },
              text: 'メモリーを追加する',
              height: 50.0,
              borderRadius: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoriesGrid() {
    final memoriesState = ref.watch(homeMemoriesStateProvider);

    if (memoriesState.isLoading && memoriesState.memories.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (memoriesState.error != null) {
      return Center(
        child: Text(
          getLocalizedErrorMessage(memoriesState.error),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }

    if (memoriesState.memories.isEmpty) {
      return const Center(
        child: Text(
          'メモリーがありません',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 100.0),
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      itemCount: memoriesState.memories.length,
      itemBuilder: (context, index) {
        final memory = memoriesState.memories[index];
        final double heightFactor = (index % 5 == 0 || index % 3 == 0) ? 1.5 : 1.0;
        
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: InkWell(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => CombinedMemoryDetailWidget(memory: memory)
              );
            },
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
    );
  }
}