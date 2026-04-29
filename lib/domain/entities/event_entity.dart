
class EventEntity {
  final String eventId;
  final String clubId;
  final String eventName;
  final String flyerPhotoUrl;
  final String description;
  final DateTime date;
  final DateTime startDatetime; 
  final DateTime endDatetime; 
  final int entranceFee;
  final List<EventGenre>? genre;

  EventEntity({
    required this.eventId,
    required this.clubId,
    required this.eventName,
    required this.flyerPhotoUrl,
    required this.description,
    required this.date,
    required this.startDatetime,
    required this.endDatetime,
    required this.entranceFee,
    this.genre,
  });

  //   Map<String, dynamic> toJson() {
  //   return {
  //     'eventId': eventId,
  //     'clubId': clubId,
  //     'eventName': eventName,
  //     'flyerPhotoUrl': flyerPhotoUrl,
  //     'description': description,
  //     'date': date.toIso8601String(), // Convert to ISO string in toJson()
  //     'startDatetime': startDatetime.toIso8601String(), // Convert to ISO string in toJson()
  //     'endDatetime': endDatetime.toIso8601String(), // Convert to ISO string in toJson()
  //     'entranceFee': entranceFee,
  //   };
  // }
}

class RegisterEventEntity {
  final String eventId;
  final String clubId;
  final String eventName;
  final String flyerPhotoUrl;
  final String description;
  final String date;
  final String startDatetime; 
  final String endDatetime; 
  final int entranceFee;
  final List<EventGenre>? genre;

  RegisterEventEntity({
    required this.eventId,
    required this.clubId,
    required this.eventName,
    required this.flyerPhotoUrl,
    required this.description,
    required this.date,
    required this.startDatetime,
    required this.endDatetime,
    required this.entranceFee,
    this.genre,
  });
}


enum EventGenre {
  NONE,
  HIP_HOP,
  RNB,
  TECHNO,
  HOUSE,
  REGGAE,
  EDM,
  POP,
  HYPER_POP,
  ROCK,
  JAZZ,
  TRAP,
  AMBIENT,
  INDUSTRIAL,
  GLITCH,
  BREAKCORE,
}

extension EventGenreExtension on EventGenre {
  String toApiValue() {
    switch (this) {
      case EventGenre.NONE:
        return "none";
      case EventGenre.HIP_HOP:
        return "hip-hop";
      case EventGenre.RNB:
        return "r&b";
      case EventGenre.TECHNO:
        return "techno";
      case EventGenre.HOUSE:
        return "house";
      case EventGenre.REGGAE:
        return "reggae";
      case EventGenre.EDM:
        return "edm";
      case EventGenre.POP:
        return "pop";
      case EventGenre.HYPER_POP:
        return "hyper-pop";
      case EventGenre.ROCK:
        return "rock";
      case EventGenre.JAZZ:
        return "jazz";
      case EventGenre.TRAP:
        return "trap";
      case EventGenre.AMBIENT:
        return "ambient";
      case EventGenre.INDUSTRIAL:
        return "industrial";
      case EventGenre.GLITCH:
        return "glitch";
      case EventGenre.BREAKCORE:
        return "breakcore";
    }
  }

  static EventGenre? fromApiValue(String value) {
    switch (value) {
      case "none":
        return EventGenre.NONE;
      case "hip-hop":
        return EventGenre.HIP_HOP;
      case "r&b":
        return EventGenre.RNB;
      case "techno":
        return EventGenre.TECHNO;
      case "house":
        return EventGenre.HOUSE;
      case "reggae":
        return EventGenre.REGGAE;
      case "edm":
        return EventGenre.EDM;
      case "pop":
        return EventGenre.POP;
      case "hyper-pop":
        return EventGenre.HYPER_POP;
      case "rock":
        return EventGenre.ROCK;
      case "jazz":
        return EventGenre.JAZZ;
      case "trap":
        return EventGenre.TRAP;
      case "ambient":
        return EventGenre.AMBIENT;
      case "industrial":
        return EventGenre.INDUSTRIAL;
      case "glitch":
        return EventGenre.GLITCH;
      case "breakcore":
        return EventGenre.BREAKCORE;
      default:
        return null;
    }
  }

  // 表示用の名前を取得
  String get displayName {
    switch (this) {
      case EventGenre.NONE:
        return "None";
      case EventGenre.HIP_HOP:
        return "Hip-Hop";
      case EventGenre.RNB:
        return "R&B";
      case EventGenre.TECHNO:
        return "Techno";
      case EventGenre.HOUSE:
        return "House";
      case EventGenre.REGGAE:
        return "Reggae";
      case EventGenre.EDM:
        return "EDM";
      case EventGenre.POP:
        return "Pop";
      case EventGenre.HYPER_POP:
        return "Hyper-Pop";
      case EventGenre.ROCK:
        return "Rock";
      case EventGenre.JAZZ:
        return "Jazz";
      case EventGenre.TRAP:
        return "Trap";
      case EventGenre.AMBIENT:
        return "Ambient";
      case EventGenre.INDUSTRIAL:
        return "Industrial";
      case EventGenre.GLITCH:
        return "Glitch";
      case EventGenre.BREAKCORE:
        return "Breakcore";
    }
  }
}




