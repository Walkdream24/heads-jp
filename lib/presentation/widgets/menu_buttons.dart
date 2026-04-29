import 'package:flutter/material.dart';
import '../widgets/friend_search_modal.dart';
import '../widgets/all_today_event_grid.dart';
import '../widgets/home_memories_grid.dart';

class MenuButtons extends StatelessWidget {
  final Future<void> Function()? onLocationTapped;

  const MenuButtons({Key? key, this.onLocationTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconWithBackground(context, Icons.group_add),
            const SizedBox(width: 16),
            _buildColoredCalendarIconWithBackground(context), // Colored calendar icon
            const SizedBox(width: 16),
            _buildPhotoLibraryIconWithBackground(context),
            const SizedBox(width: 16),
            _buildLocationIconWithBackground(),
          ],
        ),
      ),
    );
  }

  // アイコンと下地を作成するウィジェット
  Widget _buildIconWithBackground(BuildContext context, IconData icon) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const FriendSearchModal(),
          );
        },
      ),
    );
  }

  // 位置情報アイコンのウィジェット
  Widget _buildLocationIconWithBackground() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: const Icon(Icons.location_on, color: Colors.white),
        onPressed: () async {
          if (onLocationTapped != null) {
            await onLocationTapped!(); // コールバックを呼び出し
          }
        },
      ),
    );
  }

  // 色付きのカレンダーアイコンと下地を作成するウィジェット
  Widget _buildColoredCalendarIconWithBackground(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3CED6D), Color(0xFF527DE2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: const Icon(Icons.calendar_month, color: Colors.white),
        iconSize: 28,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return const AllTodayEventGrid();
            },
          );
        },
      ),
    );
  }

  // フォトライブラリーアイコンと下地を作成するウィジェット
  Widget _buildPhotoLibraryIconWithBackground(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: const Icon(Icons.photo_library, color: Colors.white),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return const HomeMemoriesGrid();
            },
          );
        },
      ),
    );
  }
}