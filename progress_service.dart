import 'package:geolocator/geolocator.dart';

class RewaPathProgressService {
  static Future<double> getDailyProgress() async => 5.0; // Placeholder

  static Future<double> getTotalProgress() async {
    final pos = await Geolocator.getCurrentPosition();
    return 25.0; // Placeholder
  }

  static Future<void> shareJourney(double daily, double total, Position pos) async {
    await Share.share('Daily: $daily km, Total: $total%');
  }
}
