class EventGuestModel {
  final String eventGuestId;
  final String eventId;
  final String userId;
  final String? guestName; // nullを許容
  final String? targetArtistName; // nullを許容
  // final DateTime createdAt;
  // final DateTime updatedAt;

  EventGuestModel({
    required this.eventGuestId,
    required this.eventId,
    required this.userId,
    this.guestName,
    this.targetArtistName,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory EventGuestModel.fromJson(Map<String, dynamic> json) {
    return EventGuestModel(
      eventGuestId: json['eventGuestId'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      guestName: json['guestName'] != null ? json['guestName'] as String : null,
      targetArtistName: json['targetArtistName'] != null ? json['targetArtistName'] as String : null,
      // createdAt: DateTime.parse(json['createdAt']).toLocal(),
      // updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
    );
  }
}
