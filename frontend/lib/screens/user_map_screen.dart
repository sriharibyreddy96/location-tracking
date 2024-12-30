import 'package:flutter/material.dart';
import 'package:frontend/services/background_location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:frontend/services/location_service.dart'; // Import LocationService
import 'package:shared_preferences/shared_preferences.dart';

class UserMapScreen extends StatefulWidget {
  @override
  _UserMapScreenState createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  late GoogleMapController mapController;
  Location _location = Location();
  late LocationData _currentLocation;
  bool _isLocationReady = false; // Flag to indicate location is ready

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    startPeriodicLocationUpdates(); // Start periodic updates
    BackgroundLocationService.initBackgroundLocation();
  }

  // Get current location and store it
  _getCurrentLocation() async {
    try {
      // Fetch current location using the Location package
      _currentLocation = await _location.getLocation();
      setState(() {
        _isLocationReady = true; // Location is now ready
      });

      // Print latitude and longitude to the console
      print(
          "Latitude: ${_currentLocation.latitude}, Longitude: ${_currentLocation.longitude}");

      // Fetch userId from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId =
          prefs.getString('userId'); // Fetch the userId from SharedPreferences

      if (userId != null) {
        // Send the location data to the backend
        await LocationService.storeLocation(
          userId,
          _currentLocation.latitude!,
          _currentLocation.longitude!,
        );
      } else {
        print('Error: User ID not found in SharedPreferences.');
      }
    } catch (e) {
      // Handle any errors that occur while fetching the location
      print("Error getting location: $e");
    }
  }

  // Function to periodically update the user's location every hour
  void startPeriodicLocationUpdates() {
    Future.delayed(Duration(hours: 1), () async {
      await _getCurrentLocation();
      startPeriodicLocationUpdates(); // Repeat every hour
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Location')),
      body: !_isLocationReady
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentLocation.latitude!, _currentLocation.longitude!),
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('user_location'),
                  position: LatLng(
                      _currentLocation.latitude!, _currentLocation.longitude!),
                ),
              },
            ),
    );
  }
}
