import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/clubs_provider.dart';
import '../../core/util/error_helper.dart';

class VenueSelector extends ConsumerWidget {
  final String? selectedClubId;
  final String? selectedClubName;
  final void Function(String?, String?) onClubSelected;

  const VenueSelector({
    super.key,
    this.selectedClubId,
    this.selectedClubName,
    required this.onClubSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildVenueSelector(context, ref);
  }

  Widget _buildVenueSelector(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '会場',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showClubSelectionModal(context, ref),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  selectedClubName ?? 'タップして選択',
                  style: TextStyle(
                    color: selectedClubName != null ? Colors.white : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showClubSelectionModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '会場を選択',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final clubsAsync = ref.watch(fetchAllClubsInfoProvider);
                    return clubsAsync.when(
                      data: (clubs) => ListView.builder(
                        itemCount: clubs.length,
                        itemBuilder: (context, index) {
                          final club = clubs[index];
                          return ListTile(
                            title: Text(
                              club.clubName,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              club.address,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: selectedClubId == club.clubId
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                            onTap: () {
                              onClubSelected(club.clubId, club.clubName);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Text(
                          getLocalizedErrorMessage(error),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}