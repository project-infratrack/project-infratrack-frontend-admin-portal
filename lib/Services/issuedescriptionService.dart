  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:infratrack/helper/api_config.dart';
  import 'package:infratrack/model/issuedescriptionServiceModel.dart';

  class IssueDescriptionService {
    /// Fetch report details
    Future<IssueDescriptionModel?> fetchReportById(String reportId) async {
      final url = Uri.parse('${ApiConfig.baseUrl}/admin/report/$reportId');

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final issueDescription = IssueDescriptionModel.fromJson(data);
          await prefs.setString('last_fetched_report_id', reportId);
          return issueDescription;
        } else {
          print('Failed to fetch report. Status code: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        print('Error fetching report: $e');
        return null;
      }
    }

    /// ✅ Update priority level as request parameter
    Future<bool> updatePriorityLevel(
        String reportId, String priorityLevel) async {
      final url = Uri.parse(
              '${ApiConfig.baseUrl}/admin/report/update-priority-level/$reportId')
          .replace(queryParameters: {'priorityLevel': priorityLevel});

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          print('Priority level updated successfully');
          return true;
        } else {
          print(
              'Failed to update priority level. Status code: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        print('Error updating priority level: $e');
        return false;
      }
    }

    /// ✅ Update approval status as request parameter
    Future<bool> updateApprovalStatus(String reportId, String status) async {
      final url =
          Uri.parse('${ApiConfig.baseUrl}/admin/report/$reportId/approval')
              .replace(queryParameters: {'approvalStatus': status});

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          print('Approval status updated successfully');
          return true;
        } else {
          print(
              'Failed to update approval status. Status code: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        print('Error updating approval status: $e');
        return false;
      }
    }
  }
