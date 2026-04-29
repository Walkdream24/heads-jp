import 'package:flutter/material.dart';
import '../pages/full_map_page.dart';
import '../widgets/all_today_event_grid.dart';
import '../widgets/home_memories_grid.dart';
import '../pages/calendar_page.dart';
import '../pages/my_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/nearby_events_modal_state.dart';


class BottomNavigationWidget extends StatefulWidget {
 const BottomNavigationWidget({super.key});

 @override
 State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FullMapPage(),       
    const AllTodayEventGrid(),       
    const CalendarPage(),          
    const HomeMemoriesGrid(),        
    const MyPage(), 
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // NearbyEventsModalの表示状態を監視
        final isNearbyEventsModalVisible = ref.watch(nearbyEventsModalVisibilityProvider);
        // FullMapPageでモーダルが非表示の場合、BottomNavigationBarを非表示
        final shouldHideBottomNav = _currentIndex == 0 && !isNearbyEventsModalVisible;
        
        return Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: shouldHideBottomNav ? null : BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: _onTabTapped, // 修正: 新しいメソッドを使用
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[400],
            selectedFontSize: 12,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 11,
            ),
            backgroundColor: const Color(0xFF282829),
            elevation: 8,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'トップ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'イベント',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'カレンダー',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_library),
                label: 'メモリー',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'マイページ',
              ),
            ],
          ),
        );
      },
    );
  }
}