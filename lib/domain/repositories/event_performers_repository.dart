import '../entities/event_performer_entity.dart';

abstract class EventPerformersRepository {
  Future<void> registerEventPerformer(
    RegisterPerfomerInput input
  );

  Future<List<EventPerformerEntity>> fetchEventPerformers(
    String eventId
  );

  Future<void> cancelRegisterPerformer(
    String eventPerformerId,
  );
}
