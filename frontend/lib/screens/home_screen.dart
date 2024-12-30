import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_map_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userRole = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // Fetch user role and details from SharedPreferences
  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? '';
      userName = prefs.getString('name') ?? '';
    });
  }

  // Log out and navigate to login screen
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _logout,
        ),
        actions: [
          TextButton(
            onPressed: _logout,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.red.withOpacity(0.2)), // Light red background
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.red),
                ),
              ),
            ),
            child: Text('LOGOUT',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $userName',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (userRole == "user") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserMapScreen()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid role or not a user')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                backgroundColor: Colors.green.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.green),
                ),
              ),
              child: Text(
                'Goto - $userName - Map'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
