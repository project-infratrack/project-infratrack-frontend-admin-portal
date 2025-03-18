import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';

class GovernmentIssueScreenMid extends StatelessWidget {
  const GovernmentIssueScreenMid({super.key});

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
              "Mid priority issues",
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
                  _buildIssueButton(context, "Issue 1"),
                  const SizedBox(height: 10),
                  _buildIssueButton(context, "Issue 2"),
                  const SizedBox(height: 10),
                  _buildIssueButton(context, "Issue 3"),
                  const SizedBox(height: 10),
                  _buildIssueButton(context, "Issue 4"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 0,
        onItemTapped: (index) {
          // Handle navigation changes
        },
      ),
    );
  }

  Widget _buildIssueButton(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
            0.65, // Custom width 85% of screen
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2C3E50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {},
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
