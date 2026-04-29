import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile_header_entity.dart';
import '../../domain/entities/follows_entity.dart';
import '../../domain/entities/user_summary_entity.dart';
import '../../domain/entities/blocked_users_entity.dart';
import '../providers/follows_state.dart';
import '../providers/profile_header_state.dart';
import '../pages/follow_list_page.dart';
import '../pages/common_follow_list_page.dart';
import '../pages/edit_my_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'custom_snackbar.dart';
import '../../core/util/error_helper.dart';

class ProfileHeader extends ConsumerWidget {
  final String profileHeaderProviderKey;
  final bool isMyPage;
  final FollowsInput? input;
  final List<UserSummaryEntity>? commonFollowers;
  // 追加: ブロック関係の状態
  final BlockRelationshipType? blockRelationship;

  const ProfileHeader({
    super.key,
    required this.profileHeaderProviderKey,
    required this.isMyPage,
    this.input,
    this.commonFollowers,
    // ブロック関係を受け取るパラメータを追加
    this.blockRelationship,
  });

  String? _getSnsUrl(String? id, String type) {
    if (id == null || id.isEmpty) return null;

    switch (type) {
      case 'instagram':
        return 'https://www.instagram.com/$id';
      case 'x':
        return 'https://x.com/$id';
      case 'soundcloud':
        return 'https://soundcloud.com/$id';
      case 'youtube':
        return 'https://youtube.com/$id';
      default:
        return null;
    }
  }

  Future<void> _launchUrl(BuildContext context, String? url) async {
    if (url == null) return;

    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(
          context: context,
          message: 'URLを開けませんでした',
          isSuccess: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileHeader = ref.watch(profileHeaderProvider(profileHeaderProviderKey));

    if (isMyPage) {
      return _buildProfileHeader(
        context,
        profileHeader: profileHeader!,
        followResult: null,
        onButtonPressed: () => _navigateToEditPage(context, profileHeader),
        commonFollowers: commonFollowers,
        blockRelationship: blockRelationship, // 追加
      );
    }

    if (input == null) {
      return const Center(
        child: Text(
          "エラーが発生しました"),
      );
    }

    final followState = ref.watch(followStateProvider(input!));

    Future<void> handleFollowToggle() async {
      try {
        await ref.read(followStateProvider(input!).notifier).toggleFollow();
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                getLocalizedErrorMessage(error),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return followState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildProfileHeader(
        context,
        profileHeader: profileHeader!,
        followResult: const FollowCheckResult(
          isFollowing: false,
          isFollowedBy: false,
          status: FollowStatus.NONE,
        ),
        onButtonPressed: handleFollowToggle,
        commonFollowers: commonFollowers,
        blockRelationship: blockRelationship, // 追加
      ),
      data: (followResult) => _buildProfileHeader(
        context,
        profileHeader: profileHeader!,
        followResult: followResult,
        onButtonPressed: handleFollowToggle,
        commonFollowers: commonFollowers,
        blockRelationship: blockRelationship, // 追加
      ),
    );
  }

  void _navigateToEditPage(
    BuildContext context,
    ProfileHeaderEntity profileHeader,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => EditMyPage(
          user: profileHeader
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context, {
    required ProfileHeaderEntity profileHeader,
    required FollowCheckResult? followResult,
    required VoidCallback onButtonPressed,
    required List<UserSummaryEntity>? commonFollowers,
    BlockRelationshipType? blockRelationship, // 追加
  }) {
    // ブロック関係がある場合は簡易表示にする
    final bool isBlocked = blockRelationship == BlockRelationshipType.USER_BLOCKED_TARGET || 
                           blockRelationship == BlockRelationshipType.TARGET_BLOCKED_USER;
    
    final displayedFollowers = commonFollowers?.take(2).toList();
    final remainingCount = commonFollowers != null ? commonFollowers.length - (displayedFollowers?.length ?? 0) : 0;

    // SNSアイコンのリストを作成
    final snsIcons = <Widget>[];

    if (profileHeader.instagramId?.isNotEmpty == true) {
      snsIcons.addAll([
        GestureDetector(
          onTap: () => _launchUrl(
            context,
            _getSnsUrl(profileHeader.instagramId, 'instagram'),
          ),
          child: SvgPicture.asset(
            'assets/instagram_logo.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ]);
    }

    if (profileHeader.xId?.isNotEmpty == true) {
      snsIcons.addAll([
        GestureDetector(
          onTap: () => _launchUrl(
            context,
            _getSnsUrl(profileHeader.xId, 'x'),
          ),
          child: SvgPicture.asset(
            'assets/x_logo.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ]);
    }

    if (profileHeader.soundcloudId?.isNotEmpty == true) {
      snsIcons.addAll([
        GestureDetector(
          onTap: () => _launchUrl(
            context,
            _getSnsUrl(profileHeader.soundcloudId, 'soundcloud'),
          ),
          child: SvgPicture.asset(
            'assets/soundcloud.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ]);
    }

    if (profileHeader.youtubeId?.isNotEmpty == true) {
      snsIcons.add(
        GestureDetector(
          onTap: () => _launchUrl(
            context,
            _getSnsUrl(profileHeader.youtubeId, 'youtube'),
          ),
          child: SvgPicture.asset(
            'assets/youtube.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: profileHeader.profilePhotoUrl ??
                "https://via.placeholder.com/600x400?text=Default+Header",
            width: double.infinity,
            height: 520,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade800,
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade800,
              child: const Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
        Container(
          height: 660,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.9),
                Colors.black,
              ],
              stops: const [0.0, 0.5, 0.7, 1.0],
            ),
          ),
        ),
        Positioned(
          top: 380,
          left: 16,
          right: 16,
          // ブロックされている場合はスペースを縮小
          bottom: isBlocked ? 16 : 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ユーザー名とIDは常に表示
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileHeader.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '@${profileHeader.headsId}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 198, 198, 198),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // ブロックされていない場合のみ、以下の情報を表示
              if (!isBlocked) ...[
                const SizedBox(height: 8),
                
                // SNSアイコンとボタンの行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: snsIcons),
                    OutlinedButton(
                      onPressed: onButtonPressed,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ).copyWith(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                          if (followResult == null || followResult.isFollowing) {
                            return const Color(0xFF242930);
                          }
                          return Colors.transparent;
                        }),
                        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
                          return Colors.transparent;
                        }),
                      ),
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
                        decoration: followResult != null && !followResult.isFollowing
                            ? const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF6C5EE3),
                                    Color(0xFF2F83EC),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              )
                            : null,
                        child: (followResult == null)
                            ? const Text(
                                '編集',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    followResult.isFollowing ? 'フォロー中' : 'フォローする',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (followResult.isFollowing)
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // フォロワー情報
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => FollowListPage(
                              userId: profileHeader.uid,
                              isFollowers: true,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        '${profileHeader.followersCount} Followers',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => FollowListPage(
                              userId: profileHeader.uid,
                              isFollowers: false,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        '${profileHeader.followingCount} Following',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // プロフィールテキスト
                Text(
                  profileHeader.bio ?? "",
                  style: const TextStyle(color: Colors.white),
                ),
                
                // リンク
                if (profileHeader.bioLink != null && profileHeader.bioLink!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchUrl(context, profileHeader.bioLink),
                    child: Text(
                      profileHeader.bioLink!,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // 共通フォロワー
                if (commonFollowers != null && commonFollowers.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => CommonFollowListPage(
                            commonFollowers: commonFollowers,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        for (var follower in displayedFollowers!)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey,
                              backgroundImage: CachedNetworkImageProvider(follower.profilePhotoUrl),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            '${displayedFollowers.map((e) => e.headsId).join("、")}${remainingCount > 0 ? " と他$remainingCount人" : ""}がフォロー中',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}