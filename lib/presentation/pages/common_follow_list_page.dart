import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/heads_detail_page.dart';
import '../../domain/entities/user_summary_entity.dart';

class CommonFollowListPage extends ConsumerWidget {
  final List<UserSummaryEntity>? commonFollowers;

  const CommonFollowListPage({
    super.key,
    this.commonFollowers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          '共通の友達',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: commonFollowers == null || commonFollowers!.isEmpty
          ? const Center(
              child: Text(
                '共通の友達はいません',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: commonFollowers!.length,
              itemBuilder: (context, index) {
                final user = commonFollowers![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(user.profilePhotoUrl),
                      radius: 24,
                    ),
                    title: Text(
                      user.username,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    subtitle: Text(
                      user.headsId ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (BuildContext context) {
                          return HeadsDetailPage(userId: user.uid);
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}