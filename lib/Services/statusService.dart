import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/statusServiceModel.dart';

class StatusService {
  /// Fetches status details for a specific report using [reportId].
  /// Returns a [StatusServiceModel] if successful, else null.
  Future<StatusServiceModel?> fetchReportStatus(String reportId) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/admin/report/$reportId');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StatusServiceModel.fromJson(data);
      } else {
        print('Failed to fetch report status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching report status: $e');
      return null;
    }
  }
}
