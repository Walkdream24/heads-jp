import 'dart:convert';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../domain/entities/marker_entity.dart';

class AddClusteredMarkersUseCase {

  AddClusteredMarkersUseCase();

  Future<void> execute({
    required MapboxMap mapboxMap,
    required List<MarkerEntity> markers,
    required String sourceId,
    required String layerId,
    required String clusterImageId,
    required double clusterRadius,
    required double clusterMaxZoom,
    required double iconSize,
  }) async {
    // GeoJSONデータを生成
    final geoJsonData = {
      "type": "FeatureCollection",
      "features": markers.map((marker) {
        return {
          "type": "Feature",
          "geometry": {
            "type": "Point",
            "coordinates": [marker.position.lng, marker.position.lat],
          },
          "properties": {
            "name": marker.name,
            "icon": marker is ClubMarkerEntity ? 'red_marker.png' : marker.imagePath.split('/').last,
          },
        };
      }).toList(),
    };

    // GeoJSONソースを追加
    await mapboxMap.style.addSource(GeoJsonSource(
      id: sourceId,
      data: jsonEncode(geoJsonData),
      cluster: true,
      clusterRadius: clusterRadius,
      clusterMaxZoom: clusterMaxZoom,
    ));

    // クラスター用SymbolLayerを追加
    await mapboxMap.style.addLayer(SymbolLayer(
      id: layerId,
      sourceId: sourceId,
      iconImage: clusterImageId,
      iconSize: iconSize,
      iconAllowOverlap: true,
    ));
  }
}
