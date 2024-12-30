import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  static const String baseUrl =
      'http://192.168.137.58:5000/api/location'; // Replace with your API endpoint

  // Store location to backend (with user ID, latitude, longitude, and timestamp)
  static Future<void> storeLocation(
      String userId, double latitude, double longitude) async {
    try {
      // Prepare the data to be sent to the backend
      final response = await http.post(
        Uri.parse(
            '$baseUrl/store-location'), // Your backend endpoint to store location
        body: json.encode({
          'userId': userId,
          'latitude': latitude,
          'longitude': longitude,
          'timestamp':
              DateTime.now().toIso8601String(), // Timestamp of the location
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        print('Location stored successfully');
        print('Response Body: ${response.body}');
      } else {
        throw Exception('Failed to store location');
      }
    } catch (error) {
      print('Error storing location: $error');
    }
  }

  // Fetch location for a user by their userId
  static Future<Map<String, dynamic>> getUserLocation(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/get-location/$userId'), // Backend API to fetch user location
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load location');
      }
    } catch (error) {
      print('Error fetching user location: $error');
      throw error;
    }
  }
}
