import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:infratrack/Services/issuedescriptionService.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/components/googlemap.dart';
import 'package:infratrack/model/issuedescriptionServiceModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GovernmentIssueDescriptionScreen extends StatefulWidget {
  final String reportId;

  const GovernmentIssueDescriptionScreen({super.key, required this.reportId});

  @override
  _GovernmentIssueDescriptionScreenState createState() =>
      _GovernmentIssueDescriptionScreenState();
}

class _GovernmentIssueDescriptionScreenState
    extends State<GovernmentIssueDescriptionScreen> {
  String? selectedPriority;
  final List<String> priorityTypes = [
    "High Priority",
    "Mid Priority", // changed here
    "Low Priority",
  ];

  IssueDescriptionModel? reportData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  Future<void> _fetchReport() async {
    final service = IssueDescriptionService();
    final result = await service.fetchReportById(widget.reportId);
    if (result != null) {
      setState(() {
        reportData = result;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch report details')),
      );
    }
  }

  Future<void> _handleApprovalUpdate(String status) async {
    final service = IssueDescriptionService();

    if (status == "Accepted" && selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a priority level first')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool priorityUpdated = true;

    if (status == "Accepted") {
      priorityUpdated = await service.updatePriorityLevel(
        widget.reportId,
        selectedPriority!,
      );
    }

    final approvalUpdated =
        await service.updateApprovalStatus(widget.reportId, status);

    setState(() {
      isLoading = false;
    });

    if (priorityUpdated && approvalUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report ${status.toLowerCase()} successfully')),
      );
      Navigator.pop(context, true); // Tell IncomingScreen to refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update report')),
      );
    }
  }

  /// 🗺️ Build Google Map Preview (Clickable)
  Widget _buildMapPreview(IssueDescriptionModel report) {
    final LatLng reportLocation = LatLng(report.latitude, report.longitude);
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: reportLocation,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("report-location"),
                  position: reportLocation,
                  draggable: false,
                )
              },
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              tiltGesturesEnabled: false,
              rotateGesturesEnabled: false,
              onMapCreated: (controller) {},
            ),
          ),
          // Overlay an InkWell to capture taps.
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MapViewPopup(initialLocation: reportLocation),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reportData == null
              ? const Center(child: Text("No data found"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              reportData!.reportType,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Complaint ID: ${reportData!.id}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: reportData!.image.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(reportData!.image),
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox(),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              reportData!.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 16),

                            /// 🗺️ Dynamic map
                            _buildMapPreview(reportData!),

                            const SizedBox(height: 16),
                            _buildPriorityDropdown(),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildActionButton("Accept", Colors.green,
                                    () async {
                                  await _handleApprovalUpdate("Accepted");
                                }),
                                _buildActionButton("Reject", Colors.red,
                                    () async {
                                  await _handleApprovalUpdate("Rejected");
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 0,
        onItemTapped: (index) {},
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2C3E50),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: const Color(0xFF2C3E50),
          value: selectedPriority,
          hint: const Text(
            "Choose Priority Type",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: priorityTypes.map((priority) {
            return DropdownMenuItem(
              value: priority,
              child: Text(
                priority,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedPriority = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
