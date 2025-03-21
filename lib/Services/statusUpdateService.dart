import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infratrack/helper/api_config.dart';
import 'package:infratrack/model/statusServiceModel.dart';

class StatusUpdateService {
  Future<bool> updateReportStatus(
      String reportId, StatusServiceModel report, String newStatus) async {
    final url = Uri.parse(
        '${ApiConfig.baseUrl}/admin/report/update-report-status/$reportId?status=$newStatus');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      final body = {
        "id": report.id,
        "userId": report.userId,
        "reportType": report.reportType,
        "description": report.description,
        "location": report.location,
        "image": [report.image],
        "latitude": report.latitude,
        "longitude": report.longitude,
        "priorityLevel": report.priorityLevel ?? "",
        "thumbsUp": report.thumbsUp,
        "thumbsDown": report.thumbsDown,
        "approval": "Accepted", // 🔥 SET to Accepted
        "thumbsUpUsers": [],
        "thumbsDownUsers": []
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Status updated successfully');
        return true;
      } else {
        print('Failed to update status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating status: $e');
      return false;
    }
  }
}
