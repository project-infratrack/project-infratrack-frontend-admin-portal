import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/model/lowServiceModel.dart';
import 'package:infratrack/services/lowService.dart';

class GovernmentIssueScreenLow extends StatefulWidget {
  const GovernmentIssueScreenLow({super.key});

  @override
  _GovernmentIssueScreenLowState createState() =>
      _GovernmentIssueScreenLowState();
}

class _GovernmentIssueScreenLowState extends State<GovernmentIssueScreenLow> {
  int _selectedIndex = 0;
  late Future<List<LowPriorityReport>> _lowPriorityReports;

  @override
  void initState() {
    super.initState();
    _lowPriorityReports = LowPriorityReportService().fetchLowPriorityReports();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamed(context, "/home");
    } else if (index == 1) {
      Navigator.pushNamed(context, "/history");
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
            icon: const Icon(Icons.account_circle, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Low priority issues",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<LowPriorityReport>>(
                future: _lowPriorityReports,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No low priority issues found.'));
                  } else {
                    final reports = snapshot.data!;
                    return ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: _buildIssueButton(
                            context,
                            issueId: report.id,
                            issueType: report.reportType,
                            description: report.description,
                            routeName: "/issueDetailsLow",
                            report: report,
                          ),
                        );
                      },
                    );
                  }
                },
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

  Widget _buildIssueButton(
    BuildContext context, {
    required String issueId,
    required String issueType,
    required String description,
    required String routeName,
    required LowPriorityReport report,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85, // Consistent width
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C3E50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16), // Uniform padding
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            routeName,
            arguments: report,
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.report, color: Colors.white), // Optional icon
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ID: $issueId",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Type: $issueType",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
