import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/services/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveLocationScreen extends StatefulWidget {
  final String userId; // User ID passed from the AdminDashboard
  const LiveLocationScreen({super.key, required this.userId});

  @override
  _LiveLocationScreenState createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {
  late GoogleMapController _mapController;
  LatLng _initialLocation =
      LatLng(37.7749, -122.4194); // Default to San Francisco
  bool _isLoading = true;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Fetch the live location of the user here based on widget.userId
    _fetchUserLocation();
  }

  // Fetch user location from the backend
  Future<void> _fetchUserLocation() async {
    try {
      final location = await LocationService.getUserLocation(widget.userId);

      // Get latitude and longitude from the response
      double latitude = location['latitude'];
      double longitude = location['longitude'];

      setState(() {
        _initialLocation = LatLng(latitude, longitude);
        _markers.add(
          Marker(
            markerId: MarkerId("user_location"),
            position: _initialLocation,
            infoWindow: InfoWindow(title: "User Location"),
          ),
        );
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching user location: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialLocation,
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              markers: _markers, // Display the markers on the map
            ),
    );
  }
}
