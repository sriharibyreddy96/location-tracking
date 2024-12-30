import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = 'http://192.168.137.58:5000/api/users';

  // Fetch all users (admin only)
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('token'); // Get token from SharedPreferences

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      print(
          "Fetched users from API: $decodedResponse"); // Debugging line to see API response
      return List<Map<String, dynamic>>.from(
          decodedResponse); // Convert the response into a list of maps
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid token');
    } else if (response.statusCode == 403) {
      throw Exception('Forbidden: Admin access required');
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  // Fetch user by ID (for details, if needed)
  static Future<Map<String, dynamic>> getUserById(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('token'); // Get token from SharedPreferences

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include token in the header
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return the user details
    } else {
      throw Exception('Failed to fetch user details');
    }
  }
}
