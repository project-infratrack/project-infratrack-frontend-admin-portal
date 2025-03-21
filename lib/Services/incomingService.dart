import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/incomingServiceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomingService {
  /// Retrieves incoming reports from the backend.
  ///
  /// Calls `/admin/report/incoming-reports` and returns a list of reports.
  Future<List<IncomingServiceModel>> getIncomingReports() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/admin/report/incoming-reports');

    // Retrieve stored token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Print token for debugging
    print('Auth Token: $token');

    // Prepare headers
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      final response = await http.get(url, headers: headers);

      // Debugging output
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // If backend returns a list
        if (jsonData is List) {
          return jsonData
              .map((item) => IncomingServiceModel.fromJson(
                  Map<String, dynamic>.from(item)))
              .toList();
        }
        // If backend returns a single object
        else if (jsonData is Map) {
          return [
            IncomingServiceModel.fromJson(Map<String, dynamic>.from(jsonData))
          ];
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        // If backend returns error status
        throw Exception(
            'Failed to load incoming reports. Status: ${response.statusCode}');
      }
    } catch (e) {
      // Print error for debugging
      print('Error occurred: $e');
      throw Exception('Failed to load incoming reports: $e');
    }
  }
}
