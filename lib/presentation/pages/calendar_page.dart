import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'add_memory_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _currentDate;
  late DateTime _selectedDate;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ja');
    _currentDate = DateTime.now();
    _selectedDate = _currentDate;
    _scrollController = ScrollController(
      initialScrollOffset: _calculateInitialScrollOffset(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'カレンダー',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // 戻るボタンを非表示
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              // TODO: シェア機能の実装
              debugPrint('シェアボタンがタップされました');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // 2025年1月から現在の月までのカレンダーを縦に並べて表示
            ...List.generate(8, (index) {
              final monthDate = DateTime(2025, 1 + index, 1);
              return _buildMonthCalendar(monthDate);
            }),
          ],
        ),
      ),
    );
  }



  // 月別カレンダー表示
  Widget _buildMonthCalendar(DateTime monthDate) {
    final firstDayOfMonth = DateTime(monthDate.year, monthDate.month, 1);
    final lastDayOfMonth = DateTime(monthDate.year, monthDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 月と年の表示
          Text(
            DateFormat('M月 yyyy', 'ja').format(monthDate),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // 曜日ヘッダー
          Row(
            children: ['日', '月', '火', '水', '木', '金', '土'].map((day) {
              return Expanded(
                child: Container(
                  height: 40,
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 8),
          
          // 日付グリッド
          SizedBox(
            height: 300, // 固定の高さを設定
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.2,
              ),
              itemCount: 42, // 6週分
              itemBuilder: (context, index) {
                final dayOffset = index - (firstWeekday - 1);
                final day = dayOffset + 1;
                
                if (dayOffset < 0 || day > daysInMonth) {
                  // 空のセル
                  return Container();
                }
                
                final date = DateTime(monthDate.year, monthDate.month, day);
                final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
                final isToday = _isToday(date);
                final isSelected = _isSameDate(date, _selectedDate);
                final isFuture = date.isAfter(DateTime.now());
                
                return GestureDetector(
                  onTap: (isPast || isToday) ? () => _onDateTapped(date) : null,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(25), // 完全な円形に
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: isSelected 
                              ? Colors.black 
                              : isFuture 
                                  ? Colors.grey[600] 
                                  : Colors.white,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }



  // 日付が今日かどうかチェック
  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  // 2つの日付が同じ日かどうかチェック
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  // 初期スクロール位置を計算（今月が表示されるように）
  double _calculateInitialScrollOffset() {
    // 2025年1月から現在の月までの高さを計算
    // 各月のカレンダーの高さは約400px（月表示24px + スペース24px + 曜日ヘッダー40px + スペース8px + グリッド300px + パディング32px）
    final currentMonthIndex = (_currentDate.year - 2025) * 12 + (_currentDate.month - 1);
    return currentMonthIndex * 400.0;
  }

  // 日付タップ時の処理
  void _onDateTapped(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    
    // メモリー追加画面に遷移
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => AddMemoryPage(source: 'calendar', selectedDate: date),
      ),
    );
  }
}
