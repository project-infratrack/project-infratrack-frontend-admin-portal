import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/model/lowServiceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/helper/api_config.dart';

class LowPriorityReportService {
  /// Fetches low priority reports, retrieving the token from SharedPreferences
  Future<List<LowPriorityReport>> fetchLowPriorityReports() async {
    // Retrieve token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found.');
    }

    // API call
    final url = Uri.parse('${ApiConfig.baseUrl}/admin/report/low-priority-reports');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Parse JSON response
      final List<dynamic> data = jsonDecode(response.body);

      // Convert JSON to list of model objects
      final reports = data
          .map((reportJson) => LowPriorityReport.fromJson(reportJson))
          .toList();

      // Optional: Store total count of reports in SharedPreferences
      await prefs.setInt('low_priority_report_count', reports.length);

      return reports;
    } else {
      print('Failed to fetch reports: ${response.statusCode}');
      throw Exception('Failed to load low priority reports');
    }
  }

  /// Retrieve last fetched report count (Optional Utility)
  Future<int?> getStoredReportCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('low_priority_report_count');
  }
}
