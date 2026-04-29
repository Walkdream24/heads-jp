import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/event_performer_entity.dart';
import '../../domain/entities/event_guest_entity.dart';
import '../../core/util/date_time_utils.dart';
import '../providers/event_performers_provider.dart';
import '../providers/users_summary_provider.dart';
import '../providers/event_guest_provider.dart';
import '../providers/clubs_provider.dart';
import '../widgets/loading_user_avatar_category.dart';
import '../pages/heads_detail_page.dart';
import '../../core/util/error_helper.dart';
import '../widgets/event_share_modal.dart';
import '../widgets/club_detail_modal.dart';
import 'event_participation_buttons.dart'; 

class EventCard extends ConsumerWidget {
  final EventEntity event;
  final bool showParticipationButtons; // 参加ボタンを表示するかどうかのフラグ
  final VoidCallback? onParticipationChanged; // 参加状況変更のコールバック

  const EventCard({
    super.key, 
    required this.event,
    this.showParticipationButtons = true, // デフォルトでは表示
    this.onParticipationChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Firestoreから出演者データを取得
    final performersAsyncValue = ref.watch(fetchEventPerformersProvider(event.eventId));
    final guestsAsyncValue = ref.watch(fetchEventGuestsProvider(event.eventId));
    // クラブ情報を取得
    final clubAsyncValue = ref.watch(fetchClubByIdProvider(event.clubId));

    return Card(
      color: const Color(0xFF1F1F1F),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // イベント基本情報（変更なし）
            Text(
              event.eventName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                _showFlyerDialog(context, event.flyerPhotoUrl);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: event.flyerPhotoUrl,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 会場情報を追加
            const Text(
              "会場",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            clubAsyncValue.when(
              data: (club) => _ClubChip(
                clubName: club.clubName,
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      debugPrint('ModalBottomSheet builder called');
                      return ClubDetailModal(clubId: club.clubId);
                    },
                  );
                },
              ),
              loading: () => const SizedBox(
                height: 36,
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              error: (error, stack) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'クラブ情報を取得できませんでした',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '開始時間: ${formatDateTime(event.startDatetime)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '終了時間: ${formatDateTime(event.endDatetime)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '料金: ¥${event.entranceFee.toStringAsFixed(0)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            // ジャンル表示を追加
            if (event.genre != null && event.genre!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                "ジャンル",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: event.genre!
                    .where((genre) => genre != EventGenre.NONE)
                    .map((genre) => _GenreChip(genre: genre))
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              event.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            // パフォーマー情報の表示を別ウィジェットに分離
            performersAsyncValue.when(
              data: (performers) => PerformersList(performers: performers),
              loading: () => const Center(
                child: LoadingUserAvatarCategory(),
              ),
              error: (error, stack) => Text(
                getLocalizedErrorMessage(error),
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            guestsAsyncValue.when(
              data: (guests) => GuestsList(guests: guests),
              loading: () => const Center(
                child: LoadingUserAvatarCategory(),
              ),
              error: (error, stack) => Text(
                getLocalizedErrorMessage(error),
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 24),
            
            // 参加ボタンセクション（新規追加）
            if (showParticipationButtons) ...[
              EventParticipationButtons(
                event: event,
                onParticipationChanged: onParticipationChanged,
              ),
              const SizedBox(height: 16),
            ],
            
            // シェアテキスト (iOSの場合のみ表示)
            if (Platform.isIOS) ...[
              Center( // この行を追加
                child: GestureDetector(
                  onTap: () {
                    // シェアモーダルを表示
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return EventShareModal(event: event);
                      },
                    );
                  },
                  child: const Text(
                    'このイベントをシェアする',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ), // Center()を閉じる
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  // フライヤー画像をダイアログで表示する関数
  void _showFlyerDialog(BuildContext context, String imageUrl) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              // 画像を中央に配置
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain, // 本来のアスペクト比を維持
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
              // 左上の閉じるボタン
              Positioned(
                top: 0,
                left: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// クラブチップを表示するウィジェット
class _ClubChip extends StatelessWidget {
  final String clubName;
  final VoidCallback onTap;

  const _ClubChip({
    required this.clubName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.blue,
            width: 1,
          ),
        ),
        child: Text(
          clubName,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ジャンルチップを表示するウィジェット
class _GenreChip extends StatelessWidget {
  final EventGenre genre;

  const _GenreChip({
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 69, 75, 86),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        genre.displayName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// パフォーマーリストを表示する専用のウィジェット
class PerformersList extends ConsumerWidget {
  final List<EventPerformerEntity> performers;

  const PerformersList({
    super.key,
    required this.performers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveUserIds = performers
        .where((p) => p.role == EventPerformerRole.LIVE)
        .map((p) => p.userId)
        .toSet()
        .toList();
    final djUserIds = performers
        .where((p) => p.role == EventPerformerRole.DJ)
        .map((p) => p.userId)
        .toSet()
        .toList();
    final othersUserIds = performers
        .where((p) => p.role == EventPerformerRole.OTHERS)
        .map((p) => p.userId)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatarCategory(title: "Live", userIds: liveUserIds),
        UserAvatarCategory(title: "DJ", userIds: djUserIds),
        UserAvatarCategory(title: "VJ・主催者等、イベント関係者", userIds: othersUserIds),
      ],
    );
  }
}

// 各カテゴリー（Live/DJ/heads）のパフォーマーを表示するウィジェット
class UserAvatarCategory extends ConsumerWidget {
  final String title;
  final List<String> userIds;

  const UserAvatarCategory({
    super.key,
    required this.title,
    required this.userIds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ユーザー情報を一度だけ取得
    final usersSummaryAsyncValue = ref.watch(usersSummaryProvider(userIds));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: usersSummaryAsyncValue.when(
            data: (users) => users.isEmpty
                ? const Center(
                    child: Text(
                      'まだ登録されていません',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            debugPrint('Tapped on user: ${user.username}');
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return HeadsDetailPage(userId:user.uid);
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: CachedNetworkImageProvider(user.profilePhotoUrl),
                          ),
                        ),
                      );
                    },
                  ),
            loading: () => const Center(
              child: LoadingUserAvatarCategory(),
            ),
            error: (error, stack) => Text(
              getLocalizedErrorMessage(error),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}

// 参加者リストを表示する専用のウィジェット
class GuestsList extends ConsumerWidget {
  final List<EventGuestEntity> guests;

  const GuestsList({
    super.key,
    required this.guests,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guestUserIds = guests
      .map((p) => p.userId)
      .toSet()
      .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatarCategory(title: "参加中ヘッズ", userIds: guestUserIds),
      ],
    );
  }
}