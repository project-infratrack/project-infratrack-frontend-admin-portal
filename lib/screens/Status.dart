import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infratrack/components/bottom_navigation.dart';
import 'package:infratrack/components/googlemap.dart';
import 'package:infratrack/services/statusService.dart';
import 'package:infratrack/services/statusUpdateService.dart';
import 'package:infratrack/model/statusServiceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusScreen extends StatefulWidget {
  final String reportId;

  const StatusScreen({super.key, required this.reportId});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String? selectedPriority;
  final List<String> priorityTypes = ["Pending", "Ongoing", "Done"];
  StatusServiceModel? reportData;
  bool isLoading = true;
  bool hasError = false;

  final StatusUpdateService updateService = StatusUpdateService();

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    final statusService = StatusService();
    final result = await statusService.fetchReportStatus(widget.reportId);

    if (result != null) {
      setState(() {
        reportData = result;
        selectedPriority = result.status;
        isLoading = false;
      });
      await loadSavedStatus();
    } else {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> saveStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_status_${widget.reportId}', status);
  }

  Future<void> loadSavedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStatus = prefs.getString('saved_status_${widget.reportId}');
    if (savedStatus != null) {
      setState(() {
        selectedPriority = savedStatus;
      });
    }
  }

  Future<void> _updateReportStatus() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Updating status...")),
    );

    final success = await updateService.updateReportStatus(
      widget.reportId,
      reportData!,
      selectedPriority!,
    );

    if (success) {
      await saveStatus(selectedPriority!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Status updated successfully!")),
      );

      // Return true to parent screen
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update status")),
      );
    }
  }

  Widget _buildMapPreview(StatusServiceModel report) {
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
            "Choose Status Type",
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
          : hasError
              ? const Center(child: Text("Failed to load report details"))
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
                              "Status: ${reportData?.reportType} in ${reportData?.location}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Complaint ID: ${reportData?.id}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (reportData?.image != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  base64Decode(reportData!.image),
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(height: 16),
                            Text(
                              reportData?.description ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 16),
                            _buildMapPreview(reportData!),
                            const SizedBox(height: 16),
                            _buildPriorityDropdown(),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedPriority != null &&
                                    reportData != null) {
                                  _updateReportStatus();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Please select a status")),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2C3E50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: const Text(
                                "Update Status",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 24),
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
}
