
class EventGuestEntity {
  final String eventGuestId;
  final String eventId;
  final String userId;
  final String? guestName;
  final String? targetArtistName;

  EventGuestEntity({
    required this.eventGuestId,
    required this.eventId,
    required this.userId,
    this.guestName,
    this.targetArtistName,
  });
}

// RegisterGuestInput型の定義
class RegisterGuestInput {
  final String eventId;
  final String userId;
  final String? guestName;
  final String? targetArtistName;

  RegisterGuestInput({
    required this.eventId,
    required this.userId,
    this.guestName,
    this.targetArtistName,
  });
}