// events_search_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/combined_event_entity.dart';
import '../../domain/usecases/fetch_events_by_date_usecase.dart';
import 'events_repository_provider.dart';

// 検索状態を管理するクラス
class EventSearchState {
  final bool isLoading;
  final List<CombinedEventEntity> events;
  final String? errorMessage;
  final String? searchedDate; // 検索した日付を保持

  const EventSearchState({
    this.isLoading = false,
    this.events = const [],
    this.errorMessage,
    this.searchedDate,
  });

  EventSearchState copyWith({
    bool? isLoading,
    List<CombinedEventEntity>? events,
    String? errorMessage,
    String? searchedDate,
  }) {
    return EventSearchState(
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      errorMessage: errorMessage,
      searchedDate: searchedDate ?? this.searchedDate,
    );
  }
}

// StateNotifier for event search
class EventSearchNotifier extends StateNotifier<EventSearchState> {
  final FetchEventsByDateUseCase _fetchEventsByDateUseCase;
  bool _isDisposed = false;

  EventSearchNotifier(this._fetchEventsByDateUseCase) : super(const EventSearchState());

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> searchEventsByDate(String dateString) async {
    // Disposed状態チェック
    if (_isDisposed) return;
    
    // 入力検証
    if (dateString.isEmpty) {
      _updateState(
        isLoading: false,
        events: [],
        errorMessage: '日付が指定されていません',
      );
      return;
    }

    // 既に同じ日付で検索中の場合は重複実行を防ぐ
    if (state.isLoading && state.searchedDate == dateString) {
      debugPrint('Already searching for date: $dateString, skipping...');
      return;
    }

    debugPrint('Starting search for date: $dateString');

    _updateState(
      isLoading: true,
      errorMessage: null,
      searchedDate: dateString,
    );

    try {
      final events = await _fetchEventsByDateUseCase.execute(dateString);
      
      debugPrint('Search completed for date: $dateString, found ${events.length} events');
      
      // Disposed状態チェック & 検索中に別の日付で検索された場合は結果を無視
      if (!_isDisposed && state.searchedDate == dateString) {
        _updateState(
          isLoading: false,
          events: events,
          errorMessage: null,
        );
      }
    } catch (error) {
      debugPrint('Search failed for date: $dateString, error: $error');
      
      // Disposed状態チェック & エラーが発生した検索が最新の検索である場合のみエラーを設定
      if (!_isDisposed && state.searchedDate == dateString) {
        _updateState(
          isLoading: false,
          events: [],
          errorMessage: error.toString(),
        );
      }
    }
  }

  void clearSearch() {
    if (_isDisposed) return;
    
    debugPrint('Clearing search');
    state = const EventSearchState();
  }

  // 状態更新のヘルパーメソッド
  void _updateState({
    bool? isLoading,
    List<CombinedEventEntity>? events,
    String? errorMessage,
    String? searchedDate,
  }) {
    if (_isDisposed) return;
    
    state = state.copyWith(
      isLoading: isLoading,
      events: events,
      errorMessage: errorMessage,
      searchedDate: searchedDate,
    );
  }
}

// Provider定義
final fetchEventsByDateUseCaseProvider = Provider((ref) {
  final repository = ref.watch(eventsRepositoryProvider);
  return FetchEventsByDateUseCase(repository: repository);
});

final eventSearchProvider = StateNotifierProvider<EventSearchNotifier, EventSearchState>((ref) {
  final fetchEventsByDateUseCase = ref.watch(fetchEventsByDateUseCaseProvider);
  return EventSearchNotifier(fetchEventsByDateUseCase);
});