import '../entities/event_entity.dart';
import '../entities/combined_event_entity.dart';
import '../entities/user_locations_entity.dart';

abstract class EventsRepository {
  Future<List<EventEntity>> fetchEventsByClubId(String clubId);
  Future<List<EventEntity>> fetchEventsByUserId(String userId);
  Future<EventEntity> fetchEventById(String eventId);
  Future<void> registerEvent(RegisterEventEntity input);
  Future<List<CombinedEventEntity>> fetchTodayEvents();
  Future<List<CombinedEventEntity>> fetchWeekEvents();
  Future<List<CombinedEventEntity>> fetchNearbyEvents(
    AddUserLocationInput input
  ) ;
  Future<List<CombinedEventEntity>> fetchEventsByDate(String dateString);
}
