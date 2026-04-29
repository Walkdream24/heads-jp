import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/clubs_provider.dart';
import '../widgets/event_sections.dart';
import '../providers/auth_provider.dart';
import '../providers/bookmark_state_notifier.dart';
import '../../domain/entities/bookmark_clubs_entity.dart';
import '../../core/util/error_helper.dart';
import '../widgets/bookmark_button.dart';
import '../../domain/entities/club_entity.dart';

class ClubDetailModal extends ConsumerWidget {
  final String clubId;

  const ClubDetailModal({
    super.key,
    required this.clubId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ClubDetailModal build called');
    final clubAsyncValue = ref.watch(clubsProvider);
    return clubAsyncValue.when(
      data: (clubs) {
        final club = clubs.firstWhere((club) => club.clubId == clubId);
        return _buildClubDetail(context, club, ref);
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(
         getLocalizedErrorMessage(error),
        ),
      ),
    );
  }
  
  Widget _buildClubDetail(BuildContext context, ClubEntity club, WidgetRef ref) {
    final currentUser = ref.watch(authProvider);
    final bookmarkStateProvider = bookmarkStateNotifierProvider(club.clubId);
    bool isClosing = false;
    
    ref.read(bookmarkStateProvider.notifier).checkBookmarkStatus(
      BookmarkClubsByIds(
        userId: currentUser!.id, 
        clubId: club.clubId
      )
    );

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
        initialChildSize: 0.9,
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
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: club.clubPhotoUrl,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                club.clubName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: BookmarkButton(
                                userId: currentUser.id,
                                clubId: club.clubId,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          club.address,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          club.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 24),
                        EventSections(clubId: club.clubId),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}