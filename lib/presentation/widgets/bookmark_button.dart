import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bookmark_state_notifier.dart';
import '../providers/bookmark_clubs_provider.dart';
import '../../domain/entities/bookmark_clubs_entity.dart';
import '../widgets/custom_snackbar.dart';
import '../providers/clubs_provider.dart';

class BookmarkButton extends ConsumerStatefulWidget {
  final String userId;
  final String clubId;

  const BookmarkButton({
    Key? key,
    required this.userId,
    required this.clubId,
  }) : super(key: key);

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends ConsumerState<BookmarkButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    // 初期状態を確認
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bookmarkData = BookmarkClubsByIds(
        userId: widget.userId,
        clubId: widget.clubId,
      );
      ref.read(bookmarkStateNotifierProvider(widget.clubId).notifier)
         .checkBookmarkStatus(bookmarkData);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkStateProvider = bookmarkStateNotifierProvider(widget.clubId);
    final isBookmarked = ref.watch(bookmarkStateProvider);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: _isProcessing ? null : () => _handleBookmarkTap(isBookmarked),
              child: Icon(
                isBookmarked ? Icons.favorite : Icons.favorite_border,
                color: isBookmarked ? Colors.red : Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      }
    );
  }

  Future<void> _handleBookmarkTap(bool currentIsBookmarked) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    // アニメーション開始
    _controller.forward();

    // すぐに状態を反転させて即時フィードバックを提供
    final bookmarkStateProvider = bookmarkStateNotifierProvider(widget.clubId);
    ref.read(bookmarkStateProvider.notifier).toggleBookmark();

    final bookmarkData = BookmarkClubsByIds(
      userId: widget.userId,
      clubId: widget.clubId,
    );

    try {
      // バックグラウンドで実際の処理を行う
      if (currentIsBookmarked) {
        await ref.read(deleteBookmarkClubsProvider(bookmarkData).future);
      } else {
        await ref.read(addBookmarkClubsProvider(bookmarkData).future);
      }
      ref.invalidate(bookmarkClubsStateNotifierProvider(widget.userId));
    } catch (e) {
      // エラーが発生した場合、状態を元に戻す
      ref.read(bookmarkStateProvider.notifier).toggleBookmark();
      
      if (mounted) {
        CustomSnackBar.show(
          context: context,
          message: 'ブックマークの更新に失敗しました。',
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}