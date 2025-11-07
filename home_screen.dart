import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/location_service.dart';
import '../services/gpx_parser.dart';
import '../services/progress_service.dart';
import '../utils/language.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LatLng> _routePoints = [];
  bool _isTracking = false;
  MapController _mapController = MapController();
  double? _dailyProgress, _totalProgress;

  @override void initState() {
    super.initState();
    LanguageHelper.load().then((_) => setState(() {}));
    _loadRoute();
    _updateProgress();
  }

  Future<void> _loadRoute() async {
    _routePoints = await GPXParser.parseRoute();
    setState(() {});
  }

  Future<void> _updateProgress() async {
    final daily = await RewaPathProgressService.getDailyProgress();
    final total = await RewaPathProgressService.getTotalProgress();
    setState(() {
      _dailyProgress = daily;
      _totalProgress = total;
    });
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageHelper.t('RewaPath', 'रेवापथ')),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () async {
              await LanguageHelper.toggle();
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(LanguageHelper.t('Daily', 'दैनिक'), style: GoogleFonts.notoSansDevanagari()),
                  Text('${_dailyProgress?.toStringAsFixed(1) ?? 0} km'),
                  LinearProgressIndicator(value: (_dailyProgress ?? 0) / 20),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(LanguageHelper.t('Total', 'कुल'), style: GoogleFonts.notoSansDevanagari()),
                  Text('${_totalProgress?.toStringAsFixed(1) ?? 0}%'),
                  LinearProgressIndicator(value: (_totalProgress ?? 0) / 100),
                ],
              ),
            ),
          ),
          ElevatedButton(onPressed: _updateProgress, child: const Text('Update Progress')),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(initialCenter: const LatLng(22.6686, 81.7757), initialZoom: 6.0),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                PolylineLayer(polylines: [Polyline(points: _routePoints, color: Colors.green, strokeWidth: 4)]),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(onPressed: () async {
                if (!_isTracking) {
                  await RewaPathLocationService.startTracking();
                  setState(() => _isTracking = true);
                } else {
                  await RewaPathLocationService.stopTracking();
                  setState(() => _isTracking = false);
                }
              }, child: Text(_isTracking ? 'Pause' : 'Start')),
              ElevatedButton(onPressed: RewaPathLocationService.sendSOS, child: const Text('SOS')),
              ElevatedButton(onPressed: () async {
                final pos = await Geolocator.getCurrentPosition();
                await RewaPathProgressService.shareJourney(_dailyProgress ?? 0, _totalProgress ?? 0, pos);
              }, child: const Text('Share')),
            ],
          ),
        ],
      ),
    );
  }
}
