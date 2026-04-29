import 'package:HEADS/data/models/event_model.dart';
import '../../domain/entities/event_entity.dart';

// データソース層の例外
class EventRegistrationDataSourceException implements Exception {
  final bool success;
  final String message;
  final List<EventModel> duplicateEvents; // データソース層ではモデルのまま

  EventRegistrationDataSourceException({
    required this.success,
    required this.message,
    required this.duplicateEvents,
  });
}

class EventRegistrationException implements Exception {
  final bool success;
  final String message;
  final List<EventEntity> duplicateEvents; // データソース層ではモデルのまま

  EventRegistrationException({
    required this.success,
    required this.message,
    required this.duplicateEvents,
  });
}
