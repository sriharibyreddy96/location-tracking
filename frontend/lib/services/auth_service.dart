// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   static const String baseUrl = 'http://192.168.137.58:5000/api/auth';

//   // Login method
//   static Future<Map<String, dynamic>?> login(
//       String email, String password) async {
//     try {
//       // Debugging: Print the request being sent
//       print('Login Request: email: $email, password: $password');

//       final response = await http.post(
//         Uri.parse('$baseUrl/login'),
//         body: json.encode({'email': email, 'password': password}),
//         headers: {'Content-Type': 'application/json'},
//       );

//       // Debugging: Print the response status and body
//       print('Response Status: ${response.statusCode}');
//       print('Response Body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         // Check if the response contains both the token and user object
//         if (data['token'] != null && data['user'] != null) {
//           // Save token, role, userId, and name in SharedPreferences
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setString('token', data['token']);
//           prefs.setString('role', data['user']['role']);
//           prefs.setString('userId', data['user']['id']); // Store the userId
//           prefs.setString(
//               'name', data['user']['name']); // Optionally store the user's name

//           // Return token, role, and userId
//           return {
//             'token': data['token'],
//             'role': data['user']['role'],
//             'userId': data['user']['id'], // Return userId here
//             'name': data['user']['name'], // Optionally return the user's name
//           };
//         } else {
//           throw Exception(
//               'Invalid response from server. Token or User missing.');
//         }
//       } else {
//         final error = json.decode(response.body)['message'] ?? 'Login failed';
//         throw Exception(error);
//       }
//     } catch (error) {
//       print('Error during login: $error');
//       return null;
//     }
//   }

//   // Signup method
//   static Future<String?> signup(
//       String name, String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/signup'),
//         body: json.encode({'name': name, 'email': email, 'password': password}),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 201) {
//         final data = json.decode(response.body);
//         return data['token'];
//       } else {
//         final error = json.decode(response.body)['message'] ??
//             'Signup failed due to server error';
//         throw Exception(error);
//       }
//     } catch (error) {
//       print('Error during signup: $error');
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'package:frontend/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.137.58:5000/api/auth';

  // Login method
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: json.encode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Save login details locally
        if (data['token'] != null && data['user'] != null) {
          await SharedPreferencesService.saveUserDetails(
            token: data['token'],
            role: data['user']['role'],
            userId: data['user']['id'],
            name: data['user']['name'],
            email: email,
          );

          return {
            'token': data['token'],
            'role': data['user']['role'],
            'userId': data['user']['id'],
            'name': data['user']['name'],
          };
        } else {
          throw Exception(
              'Invalid response from server. Token or user missing.');
        }
      } else {
        final error = json.decode(response.body)['message'] ?? 'Login failed';
        throw Exception(error);
      }
    } catch (error) {
      print('Error during login: $error');
      return null;
    }
  }

  // Signup method
  static Future<bool> signup(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        body: json.encode({'name': name, 'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        final error = json.decode(response.body)['message'] ??
            'Signup failed due to server error';
        throw Exception(error);
      }
    } catch (error) {
      print('Error during signup: $error');
      return false;
    }
  }

  // Logout method
  static Future<void> logout() async {
    await SharedPreferencesService.clearAll();
  }
}
