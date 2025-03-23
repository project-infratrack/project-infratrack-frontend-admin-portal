import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/histroyServiceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  /// Fetches done reports from the backend.
  Future<List<HistoryServiceModel>> fetchDoneReports() async {
    // Retrieve the stored token from SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final url = Uri.parse('${ApiConfig.baseUrl}/admin/report/done-reports');

    // Include the token in the headers if available.
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Assuming the endpoint returns a JSON array.
      final List<dynamic> jsonList = json.decode(response.body);
      final reports =
          jsonList.map((json) => HistoryServiceModel.fromJson(json)).toList();
      return reports;
    } else {
      throw Exception(
          'Failed to load done reports, status code: ${response.statusCode}');
    }
  }
}
