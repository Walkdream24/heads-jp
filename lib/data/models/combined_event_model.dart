import 'package:flutter/foundation.dart';
import '../../domain/entities/event_entity.dart';

class CombinedEventModel {
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
  final String clubName;
  final String clubAddress;
  final List<EventGenre>? genre;
  final double? distanceKm;


  CombinedEventModel({
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
    required this.clubName,
    required this.clubAddress,
    this.genre,
    this.distanceKm,
  });

  

  /// APIのJSONデータをモデルに変換
  factory CombinedEventModel.fromJson(Map<String, dynamic> json) {

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

    double? parseDistanceKm(dynamic distanceData) {
      if (distanceData == null) return null;
      
      try {
        if (distanceData is double) {
          return distanceData;
        } else if (distanceData is int) {
          return distanceData.toDouble();
        } else if (distanceData is String) {
          return double.parse(distanceData);
        }
        return null;
      } catch (e) {
        debugPrint('距離解析エラー: $e, データ: $distanceData');
        return null;
      }
    }

    return CombinedEventModel(
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
      clubName: json['clubName'] as String,
      clubAddress: json['clubAddress'] as String,
      genre: parseGenreList(json['genre']),
      distanceKm: parseDistanceKm(json['distanceKm']),
    );
  }
}