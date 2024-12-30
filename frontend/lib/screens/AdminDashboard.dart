import 'package:flutter/material.dart';
import 'package:frontend/screens/LiveLocationScreen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/services/user_service.dart'; // Ensure this is correctly imported

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String userName = '';
  String userEmail = '';
  String userRole = '';
  List<Map<String, dynamic>> users = [];
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _loadAdminDetails();
    _fetchUsers(); // Fetch users when the page loads
  }

  // Load admin details from SharedPreferences
  Future<void> _loadAdminDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Unknown';
      userEmail = prefs.getString('email') ?? 'Unknown';
      userRole = prefs.getString('role') ?? 'Unknown';
    });
  }

  // Fetch all users (Only accessible by admins)
  Future<void> _fetchUsers() async {
    try {
      List<Map<String, dynamic>> fetchedUsers = await UserService.getAllUsers();
      setState(() {
        users = fetchedUsers
            .where((user) => user['role'] != 'admin')
            .toList(); // Exclude admins
        print("Fetched Users: $users"); // Debugging line to check users data
      });
    } catch (e) {
      setState(() {
        isError = true;
      });
      print("Error fetching users: $e");
    }
  }

  // Build a user list item widget
  Widget _buildUserItem(Map<String, dynamic> user) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.green.shade100,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(user['name'] ?? 'Unknown',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(user['email'] ?? 'Unknown'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // View Map button for each user
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LiveLocationScreen(userId: user['_id']),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.red),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text("View Map",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          // Logout text button with custom design
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Clear stored data
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ), // Navigate to login screen
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade100,
              side: BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            child:
                Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin details section with a card
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.9, // 90% of the screen width
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5), // Border radius of 5
                  ),
                  color: Colors.blue.shade50,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, $userName',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '$userEmail',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Space between admin details and user list
            SizedBox(height: 1),

            // Show user list if there is no error
            if (isError)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Error loading users or no users found.',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
            else
              // Display the list of users if no error
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _buildUserItem(users[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
