import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';


class LocationUtil {
  // 位置情報の権限とサービスのチェック
  static Future<void> checkAndRequestPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception("位置情報サービスが無効です。");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception("位置情報の許可が得られませんでした");
      }
    }
  }

  // 現在地の取得
  static Future<Position> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw Exception("現在地の取得に失敗しました: $e");
    }
  }

  // 位置情報の継続的な取得
  static Stream<Position> watchPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    try {
        debugPrint("位置情報watchPositionStream");
      return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          distanceFilter: distanceFilter,
        ),
      );
    } catch (e) {
      return Stream.error("位置情報ストリームの取得に失敗しました: $e");
    }
  }

  // 位置情報が有効かどうかをチェック
  static bool isValidPosition(Position position) {
    return position.latitude != 0.0 && position.longitude != 0.0;
  }

   // 向きを取得するメソッド
  static Stream<double> getHeading() {
    return FlutterCompass.events?.map((event) => event.heading ?? 0.0) ?? 
           Stream.value(0.0);
  }
}
