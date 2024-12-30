// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesService {
//   static const String _tokenKey = 'token';
//   static const String _roleKey = 'role'; // Added key for role

//   // Check if the user is logged in
//   static Future<bool> isLoggedIn() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenKey) !=
//         null; // Return true if token exists, false otherwise
//   }

//   // Get the user's role
//   static Future<String> getUserRole() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_roleKey) ??
//         'user'; // Default to 'user' if no role found
//   }

//   // Save user details (Token, role, userId, name, email)
//   static Future<void> saveUserDetails({
//     required String token,
//     required String role,
//     required String userId,
//     required String name,
//     required String email,
//   }) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenKey, token);
//     await prefs.setString(_roleKey, role); // Save role
//     await prefs.setString('userId', userId);
//     await prefs.setString('name', name);
//     await prefs.setString('email', email);
//   }

//   // Clear all stored data
//   static Future<void> clearAll() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _tokenKey = 'token';
  static const String _roleKey = 'role';

  // Check if the user is logged in
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) != null; // Return true if token exists
  }

  // Get the user's role
  static Future<String> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey) ?? 'user'; // Default to 'user' if null
  }

  // Save user details (Token, role, userId, name, email)
  static Future<void> saveUserDetails({
    required String token,
    required String role,
    required String userId,
    required String name,
    required String email,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);
    await prefs.setString('userId', userId);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
