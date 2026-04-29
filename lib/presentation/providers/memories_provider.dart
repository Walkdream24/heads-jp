import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/memories_entity.dart';
import '../../domain/usecases/add_memory_usecase.dart';
import '../../domain/usecases/fetch_memories_usecase.dart';
import '../../domain/usecases/fetch_event_memories_usecase.dart';
import '../../domain/usecases/archive_memory_usecase.dart';
import '../../domain/usecases/fetch_home_memories_usecase.dart';
import 'memories_repository_provider.dart';


final addMemoryUseCaseProvider = Provider<AddMemoryUseCase>((ref) {
  final repository = ref.watch(memoriesRepositoryProvider);
  return AddMemoryUseCase(repository: repository);
});

// //メモリー（写真）追加
// final addMemoryProvider = FutureProvider.family<void, MemoryEntity>((ref, input) async {
//   final addMemoryUseCase = ref.watch(addMemoryUseCaseProvider);
//   await addMemoryUseCase.execute(input);
// });

final fetchMemoriesUseCaseProvider = Provider<FetchMemoriesUseCase>((ref) {
  final repository = ref.watch(memoriesRepositoryProvider);
  return FetchMemoriesUseCase(repository: repository);
});

// メモリーズ取得用のFutureProvider
final fetchMemoriesProvider = FutureProvider.family<List<MemoryEntity>, String>((ref, userId) async {
  final fetchMemoriesUseCase = ref.watch(fetchMemoriesUseCaseProvider);
  return await fetchMemoriesUseCase.execute(userId);
});

final fetchEventMemoriesUseCaseProvider = Provider<FetchEventMemoriesUseCase>((ref) {
  final repository = ref.watch(memoriesRepositoryProvider);
  return FetchEventMemoriesUseCase(repository: repository);
});

// イベントid元に参加者のメモリーズ一覧
final fetchEventMemoriesProvider = FutureProvider.family<List<MemoryEntity>, String>((ref, eventId) async {
  final fetchEventMemoriesUseCase = ref.watch(fetchEventMemoriesUseCaseProvider);
  return await fetchEventMemoriesUseCase.execute(eventId);
});


final archiveMeomoryUseCaseProvider = Provider<ArchiveMemoryUseCase>((ref) {
  final repository = ref.watch(memoriesRepositoryProvider);
  return ArchiveMemoryUseCase(repository: repository);
});

final archiveMemoryProvider = FutureProvider.family<void, MemoryEntity>((ref, memory) async {
  final archiveMemoryUseCase = ref.watch(archiveMeomoryUseCaseProvider);
  return await archiveMemoryUseCase.execute(memory);
});

final fetchHomeMemoriesUseCaseProvider = Provider<FetchHomeMemoriesUseCase>((ref) {
  final repository = ref.watch(memoriesRepositoryProvider);
  return FetchHomeMemoriesUseCase(repository: repository);
});

// メモリーズ取得用のFutureProvider
final fetchHomeMemoriesProvider = FutureProvider<List<MemoryEntity>>((ref) async {
  final fetchHomeMemoriesUseCase = ref.watch(fetchHomeMemoriesUseCaseProvider);
  return await fetchHomeMemoriesUseCase.execute();
});



// // StateNotifierProviderの定義（memories_provider.dartに追加）
// final homeMemoriesNotifierProvider = StateNotifierProvider<HomeMemoriesNotifier, AsyncValue<List<MemoryEntity>>>((ref) {
//   return HomeMemoriesNotifier(ref);
// });

class HomeMemoriesState {
  final List<MemoryEntity> memories;
  final bool isLoading;
  final String? error;

  const HomeMemoriesState({
    this.memories = const [],
    this.isLoading = false,
    this.error,
  });

  HomeMemoriesState copyWith({
    List<MemoryEntity>? memories,
    bool? isLoading,
    String? error,
  }) {
    return HomeMemoriesState(
      memories: memories ?? this.memories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class HomeMemoriesStateNotifier extends StateNotifier<HomeMemoriesState> {
  final FetchHomeMemoriesUseCase fetchHomeMemoriesUseCase;

  HomeMemoriesStateNotifier({
    required this.fetchHomeMemoriesUseCase,
  }) : super(const HomeMemoriesState());

  Future<void> fetchMemories() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final memories = await fetchHomeMemoriesUseCase.execute();
      state = state.copyWith(
        memories: memories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 必要に応じて、他のメモリー関連メソッドをここに追加
  // 例：リフレッシュ、フィルター、更新などのメソッド
}

// プロバイダーの定義
final homeMemoriesStateProvider = StateNotifierProvider<HomeMemoriesStateNotifier, HomeMemoriesState>(
  (ref) => HomeMemoriesStateNotifier(
    fetchHomeMemoriesUseCase: ref.watch(fetchHomeMemoriesUseCaseProvider),
  ),
);