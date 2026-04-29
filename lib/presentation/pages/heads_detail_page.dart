import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:HEADS/domain/entities/user_entity.dart';
import '../widgets/profile_header.dart';
import '../widgets/loading_profile_header.dart';
import '../widgets/my_page_sections.dart';
import '../providers/user_provider.dart';
import '../providers/follows_state.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_snackbar.dart';
import '../../domain/entities/follows_entity.dart';
import '../../domain/entities/blocked_users_entity.dart';
import '../providers/profile_header_state.dart';
import '../providers/follows_provider.dart';
import '../providers/blocked_relationship_notifier.dart';
import '../../core/util/error_helper.dart';

class HeadsDetailPage extends ConsumerWidget {
  final String userId;

  const HeadsDetailPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isClosing = false;
    
    // 1. ログイン中ユーザーの情報を取得
    final currentUser = ref.watch(getCurrentUserProvider);
    final myUserId = currentUser.call()?.id;

    // 2. 閲覧対象のユーザープロフィールを取得
    final userProfileAsyncValue = ref.watch(fetchUserProfileProvider(userId));

    // 3. フォロー状態を監視
    final followState = ref.watch(
      followStateProvider(
        FollowsInput(
          userId: myUserId ?? "",
          targetUserId: userId,
        ),
      ),
    );
    
    // 4. ブロック関係を監視
    final blockRelationship = ref.watch(blockRelationshipProvider);
    
    // ブロック関係のチェックを行う（初回表示時）
    ref.listen<AsyncValue<UserEntity>>(
      fetchUserProfileProvider(userId),
      (previous, next) {
        next.whenData((_) {
          if (myUserId != null) {
            ref.read(blockRelationshipProvider.notifier).checkBlockRelationship(
              BlockedUsersInput(
                userId: myUserId,
                targetUserId: userId,
              ),
            );
          }
        });
      },
    );

    // 5. 共通フォロワーを取得 (isMyPage=false の場合のみ)
    final isMyPage = myUserId == userId;
    final commonFollowersAsyncValue = isMyPage
        ? null
        : ref.watch(
            fetchCommonFollowersProvider(
              FollowsInput(
                userId: myUserId ?? "",
                targetUserId: userId,
              ),
            ),
          );

    // 6. プロフィール初期化 (リスナー内で行う)
    ref.listen<AsyncValue<UserEntity>>(
      fetchUserProfileProvider(userId),
      (previous, next) {
        next.whenData((user) {
          ref
              .read(profileHeaderProvider(userId).notifier)
              .initialize(user.toProfileHeaderEntity());
        });
      },
    );

    // ブロックメッセージを表示するウィジェット
    Widget buildBlockMessage() {
      switch (blockRelationship) {
        case BlockRelationshipType.USER_BLOCKED_TARGET:
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            alignment: Alignment.center,
            child: const Text(
              'このユーザーをブロックしています',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        case BlockRelationshipType.TARGET_BLOCKED_USER:
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            alignment: Alignment.center,
            child: const Text(
              'このユーザーにブロックされています',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        default:
          return MyPageSections(userId: userId, isMyPage: isMyPage);
      }
    }

    // メニューを表示する関数
    void _showMenu(BuildContext context) {
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.grey[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          // ブロック状態に応じてメニュー項目を変更
          String blockMenuTitle;
          VoidCallback blockAction;
          
          switch (blockRelationship) {
            case BlockRelationshipType.USER_BLOCKED_TARGET:
              blockMenuTitle = 'ブロックを解除する';
              blockAction = () {
                if (myUserId != null) {
                  ref.read(blockRelationshipProvider.notifier).unblockUser(
                    BlockedUsersParams(
                      blockerId: myUserId,
                      blockedId: userId,
                    ),
                  );
                  Navigator.pop(context); // メニューを閉じる
                  // 成功メッセージを表示
                  CustomSnackBar.show(
                    context: context,
                    message: 'ブロックを解除しました',
                    isSuccess: true,
                  );
                }
              };
              break;
            default:
              blockMenuTitle = 'ブロックする';
              blockAction = () {
                if (myUserId != null) {
                  ref.read(blockRelationshipProvider.notifier).blockUser(
                    BlockedUsersParams(
                      blockerId: myUserId,
                      blockedId: userId,
                    ),
                  );
                  Navigator.pop(context); // メニューを閉じる
                  // 成功メッセージを表示
                  CustomSnackBar.show(
                    context: context,
                    message: 'ユーザーをブロックしました',
                    isSuccess: true,
                  );
                }
              };
          }
          
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: Text(
                    blockMenuTitle,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: blockAction,
                ),
                ListTile(
                  leading: const Icon(Icons.cancel, color: Colors.white),
                  title: const Text(
                    'キャンセル',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      );
    }

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
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: userProfileAsyncValue.when(
              loading: () => const LoadingProfileHeader(),
              error: (error, stack) {
                return Center(
                  child: Text(
                    getLocalizedErrorMessage(error),
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
              data: (user) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // プロフィールヘッダー - blockRelationship を追加
                          followState.when(
                            loading: () => const LoadingProfileHeader(),
                            error: (error, stack) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                CustomSnackBar.show(
                                  context: context,
                                  message: getLocalizedErrorMessage(error),
                                  isSuccess: false,
                                );
                              });
                              return ProfileHeader(
                                profileHeaderProviderKey: userId,
                                isMyPage: isMyPage,
                                input: FollowsInput(
                                  userId: myUserId ?? "",
                                  targetUserId: userId,
                                ),
                                commonFollowers: commonFollowersAsyncValue?.maybeWhen(
                                  data: (data) => data,
                                  orElse: () => [],
                                ),
                                blockRelationship: blockRelationship, // 追加
                              );
                            },
                            data: (followCheckResult) => ProfileHeader(
                              profileHeaderProviderKey: userId,
                              isMyPage: isMyPage,
                              input: FollowsInput(
                                userId: myUserId ?? "",
                                targetUserId: userId,
                              ),
                              commonFollowers: commonFollowersAsyncValue?.maybeWhen(
                                data: (data) => data,
                                orElse: () => [],
                              ),
                              blockRelationship: blockRelationship, // 追加
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // ブロック状態に応じてコンテンツを切り替え
                          buildBlockMessage(),
                          
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),

                    // バツボタン（丸いグレー背景付き）
                    Positioned(
                      top: 40,
                      left: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),

                    // メニューボタン（丸いグレー背景付き）
                    Positioned(
                      top: 40,
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz, color: Colors.white),
                          onPressed: () => _showMenu(context),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}