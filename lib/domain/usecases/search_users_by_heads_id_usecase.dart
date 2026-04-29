import 'package:flutter/foundation.dart';
import '../entities/user_summary_entity.dart';
import '../repositories/user_summary_repository.dart';

class SearchUsersByHeadsIdUseCase {
  final UserSummaryRepository repository;

  SearchUsersByHeadsIdUseCase({required this.repository});

  Future<List<UserSummaryEntity>> execute(String query) async {
    try {
      final usersSummary = await repository.searchUsersByHeadsId(query);
      return usersSummary;
    } catch (e) {
      // エラーログ
      debugPrint("SearchUsersByHeadsIdUseCase Error: $e");
      rethrow;
    }
  }
}
