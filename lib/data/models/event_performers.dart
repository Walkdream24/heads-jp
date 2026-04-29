import '../../domain/entities/event_performer_entity.dart';

class EventPerformersModel {
  final String eventPerformerId;
  final String eventId;
  final String userId;
  final EventPerformerRole role;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  EventPerformersModel({
    required this.eventPerformerId,
    required this.eventId,
    required this.userId,
    required this.role,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory EventPerformersModel.fromJson(Map<String, dynamic> json) {
    return EventPerformersModel(
      eventPerformerId: json['eventPerformerId'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      role: EventPerformerRoleExtension.fromApiValue(json['role'] as String)
          ?? (throw FormatException('Invalid role value: ${json['role']}')), // roleをEnumに変換
      // createdAt: DateTime.parse(json['createdAt']).toLocal(),
      // updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
    );
  }
}
