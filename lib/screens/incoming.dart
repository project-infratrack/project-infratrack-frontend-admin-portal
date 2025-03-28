import 'package:flutter/material.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/Services/incomingService.dart';
import 'package:infratrack/model/incomingServiceModel.dart';

class IncomingScreen extends StatefulWidget {
  const IncomingScreen({Key? key}) : super(key: key);

  @override
  _IncomingScreenState createState() => _IncomingScreenState();
}

class _IncomingScreenState extends State<IncomingScreen> {
  late Future<List<IncomingServiceModel>> _incomingReportsFuture;

  @override
  void initState() {
    super.initState();
    _loadIncomingReports();
  }

  void _loadIncomingReports() {
    _incomingReportsFuture = IncomingService().getIncomingReports();
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
            Navigator.pushReplacementNamed(context, "/home");
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Incoming Issues",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<IncomingServiceModel>>(
                future: _incomingReportsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'There are no incoming reports',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 102, 255)),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final reports = snapshot.data!;
                    if (reports.isEmpty) {
                      // 🔥 Empty message with icon
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              'There are no incoming reports',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        return _buildIssueCard(context, report);
                      },
                    );
                  } else {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline,
                              size: 50, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            'There are no incoming reports',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        // Set selectedIndex to -1 so that no bottom navigation item is highlighted
        selectedIndex: -1,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, "/home");
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, "/history");
          }
        },
      ),
    );
  }

  Widget _buildIssueCard(BuildContext context, IncomingServiceModel report) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF2C3E50),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final result = await Navigator.pushNamed(
            context,
            "/issue_description",
            arguments: report.id,
          );

          if (result == true) {
            setState(() {
              _loadIncomingReports();
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                report.reportType,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                report.id,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                report.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTag("Pending", const Color(0xFFFFA500)),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
