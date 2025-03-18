import 'package:flutter/material.dart';
import 'package:infratrack/screens/Accepted.dart';
import 'package:infratrack/screens/Gov_issue_description.dart';
import 'package:infratrack/screens/Government_issue_screen_high.dart';
import 'package:infratrack/screens/Government_issue_screen_low.dart';
import 'package:infratrack/screens/Government_issue_screen_mid.dart';
import 'package:infratrack/screens/History.dart';
import 'package:infratrack/screens/Rejected.dart';
import 'package:infratrack/screens/Status.dart';
import 'package:infratrack/screens/home.dart';
import 'package:infratrack/screens/incoming.dart';
import 'package:infratrack/screens/login.dart';

// Placeholder for Reset Password

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Infra Track',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const LoginScreen(), // Default starting screen
      routes: {
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
        "/issue_description": (context) =>
            const GovernmentIssueDescriptionScreen(),
        "/Gov_high": (context) => const GovernmentIssueScreenHigh(),
        "/Gov_mid": (context) => const GovernmentIssueScreenMid(),
        "/Gov_low": (context) => const GovernmentIssueScreenLow(),
        "/history": (context) => HistoryScreen(),
        "/incoming": (context) => IncomingScreen(),
        "/Accept": (context) => AcceptedScreen(),
        "/Reject": (context) => IssueRejectedScreen(),
        "/Status": (context) => StatusScreen(),
      },
    );
  }
}
