import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';

class AcceptedScreen extends StatelessWidget {
  const AcceptedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xE6F1FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Vertical alignment
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Horizontal alignment
              children: [
                Container(
                  width: constraints.maxWidth * 0.8,
                  height: 500,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: constraints.maxWidth * 0.15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.check,
                          color: const Color.fromARGB(255, 43, 255,
                              0), // Changed to blue for accepted status
                          size: constraints.maxWidth * 0.15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Issue Accepted Successfully!",
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 252,
                              34), // Changed to blue for accepted status
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 0,
        onItemTapped: (index) {
          // Handle navigation changes
        },
      ),
    );
  }
}
