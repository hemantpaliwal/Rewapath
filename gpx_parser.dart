import 'package:latlong2/latlong.dart';

class GPXParser {
  static Future<List<LatLng>> parseRoute() async {
    // Hardcoded for now
    return [
      LatLng(22.6686, 81.7757),
      LatLng(22.5167, 80.3667),
      LatLng(23.1815, 79.9864),
      LatLng(22.2497, 76.2738),
      LatLng(20.9667, 72.7667),
      LatLng(22.6686, 81.7757),
    ];
  }
}
