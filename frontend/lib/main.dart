import 'package:flutter/material.dart';
import 'package:frontend/screens/AdminDashboard.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/services/background_location_service.dart';
import 'package:frontend/utils/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await BackgroundLocationService.initBackgroundLocation();
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Schedule a periodic task
  Workmanager().registerPeriodicTask(
    "1", // Unique task ID
    "updateLocationTask",
    frequency: Duration(hours: 1), // Run every hour
  );

  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Check if the user is logged in and get the user's role
    bool isLoggedIn = await SharedPreferencesService.isLoggedIn();
    String role =
        isLoggedIn ? await SharedPreferencesService.getUserRole() : 'user';

    // Run the app with the appropriate starting screen
    runApp(MyApp(isLoggedIn: isLoggedIn, role: role));
  } catch (e) {
    // Handle any unexpected errors gracefully
    print('Error initializing app: $e');
    runApp(MyApp(isLoggedIn: false, role: ''));
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String role;

  MyApp({required this.isLoggedIn, required this.role});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn
          ? (role == 'admin'
              ? AdminDashboard()
              : HomeScreen()) // Navigate based on role
          : LoginScreen(), // Show LoginScreen if not logged in
    );
  }
}
