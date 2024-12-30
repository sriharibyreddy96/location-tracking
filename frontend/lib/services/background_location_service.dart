import 'package:frontend/services/location_service.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundLocationService {
  static final Location _location = Location();

  static Future<void> initBackgroundLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.enableBackgroundMode(enable: true);
    _location.onLocationChanged.listen((LocationData currentLocation) async {
      await _updateLocationInDatabase(currentLocation);
    });
  }

  static Future<void> _updateLocationInDatabase(LocationData location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      await LocationService.storeLocation(
        userId,
        location.latitude!,
        location.longitude!,
      );
    }
  }
}
