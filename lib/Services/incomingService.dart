import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/incomingServiceModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomingService {
  /// Retrieves incoming reports from the backend.
  ///
  /// It calls the endpoint defined at `/admin/report/incoming-reports` and
  /// returns a list of [IncomingServiceModel] objects.
  Future<List<IncomingServiceModel>> getIncomingReports() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/admin/report/incoming-reports');

    // Retrieve the stored authentication token from SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Build headers with the token if available.
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // If the response is a list of reports.
      if (jsonData is List) {
        return jsonData
            .map((item) =>
                IncomingServiceModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      // If the response is a single object, wrap it in a list.
      else if (jsonData is Map) {
        return [
          IncomingServiceModel.fromJson(Map<String, dynamic>.from(jsonData))
        ];
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Failed to load incoming reports');
    }
  }
}
