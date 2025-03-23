import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/model/midServiceModel.dart';
import 'package:infratrack/services/midService.dart';

class GovernmentIssueScreenMid extends StatefulWidget {
  const GovernmentIssueScreenMid({super.key});

  @override
  _GovernmentIssueScreenMidState createState() =>
      _GovernmentIssueScreenMidState();
}

class _GovernmentIssueScreenMidState extends State<GovernmentIssueScreenMid> {
  int _selectedIndex = 0;
  List<MidServiceModel> _midPriorityReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
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

  Future<void> _fetchReports() async {
    try {
      MidService service = MidService();
      List<MidServiceModel> reports =
          await service.fetchAndStoreMidPriorityReports();
      setState(() {
        _midPriorityReports = reports;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching reports: $e");
      setState(() {
        _isLoading = false;
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
        actions: [
          IconButton(
            icon:
                const Icon(Icons.account_circle, color: Colors.black, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
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
                          const SizedBox(height: 30),
                          ..._midPriorityReports.map((report) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: _buildIssueButton(
                                context,
                                issueId: report.id,
                                issueType: report.reportType,
                                description: report.description,
                              ),
                            );
                          }).toList(),
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
    required String issueId,
    required String issueType,
    required String description,
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
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/status',
            arguments: issueId, // Pass reportId dynamically
          );
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
