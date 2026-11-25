import 'package:material_ui/material_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  static const LatLng _initialLocation = LatLng(
    13.0827,
    80.2707,
  );

  LatLng? _currentLocation;
  bool _isLoadingLocation = false;

  Future<void> _getCurrentLocation() async {
    if (_isLoadingLocation) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('Please enable your phone location.');
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission was denied.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission is permanently denied. '
          'Enable it in app settings.',
        );
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final location = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _currentLocation = location;
      });

      _mapController.move(location, 16);

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Road Map',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _getCurrentLocation,
            tooltip: 'My Location',
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),

      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _initialLocation,
              initialZoom: 12,
              minZoom: 5,
              maxZoom: 18,
            ),

            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.dodgeit',
              ),

              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      width: 55,
                      height: 55,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 38,
                      ),
                    ),
                ],
              ),

              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            right: 16,
            bottom: 25,
            child: FloatingActionButton(
              heroTag: 'currentLocationButton',
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF16A36A),
              onPressed: _getCurrentLocation,
              child: _isLoadingLocation
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
