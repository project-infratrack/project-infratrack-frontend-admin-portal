import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/model/highServiceModel.dart';
import 'package:infratrack/services/highService.dart';

class GovernmentIssueScreenHigh extends StatefulWidget {
  const GovernmentIssueScreenHigh({super.key});

  @override
  _GovernmentIssueScreenHighState createState() =>
      _GovernmentIssueScreenHighState();
}

class _GovernmentIssueScreenHighState extends State<GovernmentIssueScreenHigh> {
  // Set to -1 so that neither Home (0) nor History (1) is selected initially.
  int _selectedIndex = -1;
  List<HighPriorityReport> reportsList = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchReports();
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

  Future<void> fetchReports() async {
    try {
      final reports =
          await HighPriorityReportService.fetchHighPriorityReports();
      setState(() {
        // Filter out Done reports
        reportsList = reports.where((r) => r.status != 'Done').toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "High priority issues",
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
                    const SizedBox(height: 30),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else if (hasError)
                      const Text('Error loading reports')
                    else if (reportsList.isEmpty)
                      const Text('No high priority issues found.')
                    else
                      Column(
                        children: reportsList.map((report) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: _buildIssueButton(
                              context,
                              report: report,
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
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
    required HighPriorityReport report,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C3E50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/status',
            arguments: report.id,
          );

          if (result == 'Done') {
            setState(() {
              reportsList.removeWhere((r) => r.id == report.id);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Issue marked as Done and removed!")),
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.report, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ID: ${report.id}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Type: ${report.reportType}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    report.description,
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
