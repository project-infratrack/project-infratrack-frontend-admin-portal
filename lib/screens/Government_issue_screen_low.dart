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
  List<LowPriorityReport> reportsList = [];
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
          await LowPriorityReportService().fetchLowPriorityReports();
      setState(() {
        // ✅ Filter out reports with status 'Done'
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                      ? const Center(child: Text('Error loading reports'))
                      : reportsList.isEmpty
                          ? const Center(
                              child: Text('No low priority issues found.'))
                          : ListView.builder(
                              itemCount: reportsList.length,
                              itemBuilder: (context, index) {
                                final report = reportsList[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: _buildIssueButton(
                                    context,
                                    report: report,
                                  ),
                                );
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
    required LowPriorityReport report,
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
