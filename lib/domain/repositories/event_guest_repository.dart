
import '../entities/event_guest_entity.dart';

abstract class EventGuestRepository {
  Future<void> registerEventGuest(
    RegisterGuestInput input
  );

  Future<List<EventGuestEntity>> fetchEventGuests(
    String eventId
  );

  Future<void> cancelRegisterGuest(
    String eventGuestId,
  );
}
