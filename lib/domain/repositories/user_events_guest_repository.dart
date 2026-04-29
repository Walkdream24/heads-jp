import '../entities/combined_event_entity.dart';

abstract class UserEventsGuestRepository {
  Future<List<CombinedEventEntity>> fetchUserEventsGuest(String userId);
  Future<List<CombinedEventEntity>> fetchUserEventsPerformer(String userId);
}
