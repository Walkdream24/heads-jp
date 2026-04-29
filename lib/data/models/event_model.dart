import 'package:flutter/foundation.dart';
import '../../domain/entities/event_entity.dart';

class EventModel {
  final String eventId;
  final String clubId;
  final String eventName;
  final String flyerPhotoUrl;
  final String description;
  final DateTime date;
  final DateTime startDatetime;
  final DateTime endDatetime;
  final int entranceFee;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<EventGenre>? genre;

  EventModel({
    required this.eventId,
    required this.clubId,
    required this.eventName,
    required this.flyerPhotoUrl,
    required this.description,
    required this.date,
    required this.startDatetime,
    required this.endDatetime,
    required this.entranceFee,
    required this.createdAt,
    required this.updatedAt,
    this.genre,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    List<EventGenre>? parseGenreList(dynamic genreData) {
      if (genreData == null) return null;
      
      try {
        final List<dynamic> genreList = genreData as List<dynamic>;
        return genreList
            .map((item) => EventGenreExtension.fromApiValue(item.toString()))
            .where((genre) => genre != null)
            .cast<EventGenre>()
            .toList();
      } catch (e) {
        debugPrint('ジャンル解析エラー: $e, データ: $genreData');
        return null;
      }
    }

    return EventModel(
      eventId: json['eventId'] as String,
      clubId: json['clubId'] as String,
      eventName: json['eventName'] as String,
      flyerPhotoUrl: json['flyerPhotoUrl'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String).toLocal(),
      startDatetime: DateTime.parse(json['startDatetime'] as String).toLocal(),
      endDatetime: DateTime.parse(json['endDatetime'] as String).toLocal(),
      entranceFee: json['entranceFee'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
      genre: parseGenreList(json['genre']),
    );
  }
}


// class RegisterEventModel {
//   final String eventId;
//   final String clubId;
//   final String eventName;
//   final String flyerPhotoUrl;
//   final String description;
//   final Timestamp date;
//   final Timestamp startDatetime;
//   final Timestamp endDatetime;
//   final int entranceFee;
//   final Timestamp createdAt;
//   final Timestamp updatedAt;

//   RegisterEventModel({
//     required this.eventId,
//     required this.clubId,
//     required this.eventName,
//     required this.flyerPhotoUrl,
//     required this.description,
//     required this.date,
//     required this.startDatetime,
//     required this.endDatetime,
//     required this.entranceFee,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory RegisterEventModel.fromJson(Map<String, dynamic> json) {
//     return RegisterEventModel(
//       eventId: json['eventId'] as String,
//       clubId: json['clubId'] as String,
//       eventName: json['eventName'] as String,
//       flyerPhotoUrl: json['flyerPhotoUrl'] as String,
//       description: json['description'] as String,
//       date: json['date'] as Timestamp,
//       startDatetime: json['startDatetime'] as Timestamp,
//       endDatetime: json['endDatetime'] as Timestamp,
//       entranceFee: json['entranceFee'] as int,
//       createdAt: json['createdAt'] as Timestamp,
//       updatedAt: json['updatedAt'] as Timestamp,
//     );
//   }
// }
