import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RewaPathLocationService {
  static Future<void> startTracking() async {
    await Geolocator.requestPermission();
    Geolocator.getPositionStream(distanceFilter: 25).listen((pos) {
      Supabase.instance.client.from('locations').upsert({
        'user_id': Supabase.instance.client.auth.currentUser?.id,
        'lat': pos.latitude,
        'lng': pos.longitude,
      });
    });
  }

  static Future<void> stopTracking() async {}

  static Future<void> sendSOS() async {
    final pos = await Geolocator.getCurrentPosition();
    Supabase.instance.client.from('sos_alerts').insert({
      'user_id': Supabase.instance.client.auth.currentUser?.id,
      'lat': pos.latitude,
      'lng': pos.longitude,
    });
  }
}
