import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';

class IncomingScreen extends StatefulWidget {
  const IncomingScreen({super.key});

  @override
  _IncomingScreenState createState() => _IncomingScreenState();
}

class _IncomingScreenState extends State<IncomingScreen> {
  int _selectedIndex = 0; // Track the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to different screens based on the selected index
    if (index == 0) {
      Navigator.pushNamed(context, "/home"); // Example navigation
    } else if (index == 1) {
      Navigator.pushNamed(context, "/history"); // Example navigation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F1FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, "/home");
          },
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.account_circle, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Incoming Issues",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/infra_track_logo.png',
                    height: 200,
                  ),
                  const SizedBox(height: 50),
                  _buildIssueButton(context, "Pothole in Dehiwala",
                      '/issue_description'), // Navigate to Issue 1 page
                  const SizedBox(height: 10),
                  _buildIssueButton(context, "Pothole in Nugegoda",
                      '/issue2'), // Navigate to Issue 2 page
                  const SizedBox(height: 10),
                  _buildIssueButton(context, "Pothole in Battaramulla",
                      '/issue3'), // Navigate to Issue 3 page
                  const SizedBox(height: 10),
                  _buildIssueButton(context, "Pothole in Kalaniya",
                      '/issue4'), // Navigate to Issue 4 page
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Customize the width of the buttons here (65% of screen width)
  Widget _buildIssueButton(
      BuildContext context, String title, String routeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.80, // 65% of screen width
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2C3E50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            Navigator.pushNamed(
                context, routeName); // Navigate to the route passed
          },
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
