import 'package:HEADS/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/loading_profile_header.dart';
import '../widgets/my_page_sections.dart';
import '../providers/profile_header_state.dart';
import '../../core/util/error_helper.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(currentUserProvider);

    ref.listen<AsyncValue<UserEntity>>(currentUserProvider, (previous, next) {
      next.whenData((user) {
        debugPrint("プロフィール画像のurl${user.profilePhotoUrl}");
        ref.read(profileHeaderProvider(user.uid).notifier)
          .initialize(user.toProfileHeaderEntity());
      });
    });

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userAsyncValue.when(
                data: (user) {
                  return Column(
                    children: [
                      ProfileHeader(
                        profileHeaderProviderKey: user.uid,
                        isMyPage: true,
                      ),
                      const SizedBox(height: 8),
                      MyPageSections(userId: user.uid, isMyPage: true),
                      const SizedBox(height: 100),
                    ],
                  );
                },
                loading: () => const LoadingProfileHeader(),
                error: (error, stack) => Text(
                  getLocalizedErrorMessage(error),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}