import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/highServiceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HighPriorityReportService {
  /// Fetches the list of high priority reports from the API.
  static Future<List<HighPriorityReport>> fetchHighPriorityReports() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse('${ApiConfig.baseUrl}/admin/report/high-priority-reports');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token', // Add token if exists
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((reportJson) => HighPriorityReport.fromJson(reportJson)).toList();
      } else {
        print('Failed to fetch reports. Status: ${response.statusCode}');
        throw Exception('Failed to load high priority reports');
      }
    } catch (e) {
      print('Error fetching reports: $e');
      throw Exception('Error: $e');
    }
  }
}
