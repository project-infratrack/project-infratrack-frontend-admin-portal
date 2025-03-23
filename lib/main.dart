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
      home: const LoginScreen(),

      // Static routes (for screens without dynamic data)
      routes: {
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
        "/Gov_high": (context) => const GovernmentIssueScreenHigh(),
        "/Gov_mid": (context) => const GovernmentIssueScreenMid(),
        "/Gov_low": (context) => const GovernmentIssueScreenLow(),
        "/history": (context) => HistoryScreen(),
        "/incoming": (context) => IncomingScreen(),
        "/Accept": (context) => const AcceptedScreen(),
        "/Reject": (context) => const IssueRejectedScreen(),
        // Removed static "/Status" route
      },

      // 🟢 Dynamic routes
      onGenerateRoute: (settings) {
        if (settings.name == '/issue_description') {
          final reportId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) =>
                GovernmentIssueDescriptionScreen(reportId: reportId),
          );
        }

        if (settings.name == '/status') {
          final reportId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => StatusScreen(reportId: reportId),
          );
        }

        return null;
      },
    );
  }
}
