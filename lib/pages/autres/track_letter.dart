import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackMyLetterScreen extends StatefulWidget {
  @override
  _TrackMyLetterScreenState createState() => _TrackMyLetterScreenState();
}

class _TrackMyLetterScreenState extends State<TrackMyLetterScreen> {
  late GoogleMapController mapController;
  bool _hasError = false;

  final LatLng _center = const LatLng(45.4215, -75.6972);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track My Letter"),
      ),
      body: _hasError
          ? Center(
        child: Text(
          'Error loading Google Maps. Please check API Key.',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      )
          : GoogleMap(
        onMapCreated: (controller) {
          try {
            _onMapCreated(controller);
          } catch (e) {
            setState(() {
              _hasError = true;
            });
            print("Error initializing Google Maps: $e");
          }
        },
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
