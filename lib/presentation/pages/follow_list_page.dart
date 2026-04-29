import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/follows_provider.dart';
import '../pages/heads_detail_page.dart';
import '../widgets/loading_follow_list.dart';
import '../../core/util/error_helper.dart';

class FollowListPage extends ConsumerWidget {
  final String userId;
  final bool isFollowers;

  const FollowListPage({
    super.key,
    required this.userId,
    required this.isFollowers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(
      isFollowers
          ? fetchFollowerListProvider(userId)
          : fetchFollowingListProvider(userId),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          isFollowers ? 'フォロワー' : 'フォロー',
          style: const TextStyle(
            color: Colors.white, 
            fontSize: 15, 
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: asyncUsers.when(
        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
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
          );
        },
        loading: () => const Center(
          child: LoadingFollowList(),
        ),
        error: (error, stack) => Center(
          child: Text(
            getLocalizedErrorMessage(error),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}