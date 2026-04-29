
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

abstract class MarkerEntity {
  final Position position;
  final String name;
  final String imagePath;

  MarkerEntity(this.position, this.name, this.imagePath);
}

class ClubMarkerEntity extends MarkerEntity {
  final String clubId; 

  ClubMarkerEntity(
    Position position,
    String name,
    String imagePath,
    this.clubId
  ) : super(position, name, imagePath);
}

class UserMarkerEntity extends MarkerEntity {
  UserMarkerEntity(Position position, String name, String imagePath)
      : super(position, name, imagePath);
}
