import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/model/midServiceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/helper/api_config.dart';


class MidService {
  /// Fetches mid-priority reports and stores them in SharedPreferences
  Future<List<MidServiceModel>> fetchAndStoreMidPriorityReports() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/admin/report/mid-priority-reports');

    // Retrieve token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      // Convert JSON data to List<MidServiceModel>
      final reports = jsonData.map((json) => MidServiceModel.fromJson(json)).toList();

      // Store in SharedPreferences as String
      final String reportsString = jsonEncode(
        reports.map((report) => report.toJson()).toList(),
      );

      await prefs.setString('mid_priority_reports', reportsString);

      return reports;
    } else {
      print('Failed to load mid-priority reports: ${response.statusCode}');
      throw Exception('Failed to load reports');
    }
  }

  /// Retrieve stored reports from SharedPreferences
  Future<List<MidServiceModel>> getStoredMidPriorityReports() async {
    final prefs = await SharedPreferences.getInstance();
    final String? reportsString = prefs.getString('mid_priority_reports');

    if (reportsString != null) {
      final List<dynamic> jsonData = jsonDecode(reportsString);
      return jsonData.map((json) => MidServiceModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
