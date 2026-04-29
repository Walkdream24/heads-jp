// 修正されたEventSearchPage
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import '../../core/util/date_time_utils.dart';
import '../providers/event_search_state.dart';
import '../../domain/entities/combined_event_entity.dart';
import '../widgets/loading_all_today_event_grid.dart';
import '../../domain/entities/event_entity.dart';
import '../widgets/event_detail_modal.dart';
import '../widgets/gradient_button.dart';

class EventSearchPage extends ConsumerStatefulWidget {
  const EventSearchPage({super.key});

  @override
  ConsumerState<EventSearchPage> createState() => _EventSearchPageState();
}

class _EventSearchPageState extends ConsumerState<EventSearchPage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    // StateNotifierProviderから状態を取得
    final searchState = ref.watch(eventSearchProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'イベント検索',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 日付選択セクション
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '日付を選択',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                
                // 日付選択バー
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[700]!,
                      width: 1,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: _showDatePicker,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getDateDisplayText(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // 検索ボタン - GradientButtonを使用
                SizedBox(
                  width: double.infinity,
                  child: searchState.isLoading
                      ? Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF444444),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        )
                      : GradientButton(
                          onPressed: _canSearch(searchState.isLoading) ? _performSearch : null,
                          text: '検索',
                          height: 50,
                          borderRadius: 12,
                          isEnabled: _canSearch(searchState.isLoading),
                        ),
                ),
              ],
            ),
          ),
          
          // 検索結果セクション
          Expanded(
            child: _buildSearchResults(searchState),
          ),
        ],
      ),
    );
  }

  String _getDateDisplayText() {
    if (selectedDate == null) {
      return '日付を選択してください';
    }
    return DateFormat('yyyy年MM月dd日').format(selectedDate!);
  }

  bool _canSearch(bool isLoading) {
    return selectedDate != null && !isLoading;
  }

  void _showDatePicker() {
    picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2010, 1, 1),
      maxTime: DateTime.now().add(const Duration(days: 365)),
      theme: const picker.DatePickerTheme(
        backgroundColor: Colors.black,
        containerHeight: 210.0,
        itemStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        doneStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        cancelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        headerColor: Colors.black,
        titleHeight: 45,
      ),
      onConfirm: (date) {
        setState(() {
          selectedDate = date;
        });
      },
      currentTime: selectedDate ?? DateTime.now(),
      locale: picker.LocaleType.jp,
    );
  }

void _performSearch() async {
  if (!_canSearch(ref.read(eventSearchProvider).isLoading)) return;
  
  final dateString = DateFormat('yyyy-MM-dd').format(selectedDate!);
  debugPrint('Searching with date string: $dateString'); // デバッグログ
  
  // 日付形式の検証
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateString)) {
    debugPrint('Invalid date format: $dateString');
    return;
  }
  
  await ref.read(eventSearchProvider.notifier).searchEventsByDate(dateString);
}

  Widget _buildSearchResults(EventSearchState searchState) {
    if (searchState.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                searchState.errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // エラー後の再検索
                  if (selectedDate != null) {
                    _performSearch();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('再検索'),
              ),
            ],
          ),
        ),
      );
    }
    
    if (searchState.events.isEmpty && !searchState.isLoading && searchState.searchedDate == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '日付を選択して検索してください',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    
    if (searchState.isLoading) {
      return const Center(
        child: EventGridLoading(),
      );
    }
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (searchState.searchedDate != null) ...[
              Text(
                '検索結果 (${searchState.events.length}件)',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildEventGrid(searchState.events),
          ],
        ),
      ),
    );
  }

  Widget _buildEventGrid(List<CombinedEventEntity> events) {
    if (events.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            '該当するイベントが見つかりませんでした',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.53,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return GestureDetector(
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return EventDetailModal(event: event.event);
              }
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: event.event.flyerPhotoUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // ジャンルタグの表示
                  if (event.event.genre != null && event.event.genre!.isNotEmpty)
                    Positioned(
                      left: 4,
                      bottom: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 最大2つのジャンルを表示
                          ...event.event.genre!
                              .where((genre) => genre != EventGenre.NONE)
                              .take(2)
                              .map((genre) => Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      genre.displayName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )),
                          // 3つ以上の場合は「...」を表示
                          if (event.event.genre!.where((genre) => genre != EventGenre.NONE).length > 2)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'etc...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                event.event.eventName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatDate(event.event.date),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                event.clubName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}