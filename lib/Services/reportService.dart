import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/model/reportServiceModel.dart';

class ReportService {
  Future<ReportServiceModel?> fetchReportById(String reportId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/admin/report/$reportId');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ReportServiceModel.fromJson(jsonData);
      } else {
        print('Failed to load report: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching report: $e');
      return null;
    }
  }
}
