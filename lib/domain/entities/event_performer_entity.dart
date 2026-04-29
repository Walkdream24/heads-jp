enum EventPerformerRole {
  LIVE,
  DJ,
  OTHERS,
}

extension EventPerformerRoleExtension on EventPerformerRole {
  String toApiValue() {
    switch (this) {
      case EventPerformerRole.LIVE:
        return "live";
      case EventPerformerRole.DJ:
        return "dj";

      case EventPerformerRole.OTHERS:
        return "others";
    }
  }

  static EventPerformerRole? fromApiValue(String value) {
    switch (value) {
      case "live":
        return EventPerformerRole.LIVE;
      case "dj":
        return EventPerformerRole.DJ;
      case "others":
        return EventPerformerRole.OTHERS;
      default:
        return null;
    }
  }
}

class EventPerformerEntity {
  final String eventPerformerId;
  final String eventId;
  final String userId;
  final EventPerformerRole role;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  EventPerformerEntity({
    required this.eventPerformerId,
    required this.eventId,
    required this.userId,
    required this.role,
    // required this.createdAt,
    // required this.updatedAt,
  });
}

// RegisterPerformerInput型の定義
class RegisterPerfomerInput {
  final String eventId;
  final String userId;
  final EventPerformerRole role;

  RegisterPerfomerInput({
    required this.eventId,
    required this.userId,
    required this.role,
  });
}
