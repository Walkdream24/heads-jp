import '../entities/event_entity.dart';
class CombinedEventEntity {
  final EventEntity event;
  final String clubName;
  final String clubAddress;
  final double? distanceKm;

  CombinedEventEntity({
    required this.event,
    required this.clubName,
    required this.clubAddress,
    this.distanceKm,
  });
}
