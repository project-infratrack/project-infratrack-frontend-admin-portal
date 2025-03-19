import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggingService {
  /// Sends a login request with the provided [adminNo] and [password].
  /// Returns `true` if the login is successful (HTTP status 200), otherwise `false`.
  Future<bool> login(String adminNo, String password) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/admin/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'adminNo': adminNo,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response to retrieve the token
      final data = jsonDecode(response.body);
      final token = data["token"] as String?;

      if (token != null && token.isNotEmpty) {
        // Save the token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
      }

      return true;
    } else {
      // Handle error responses appropriately.
      print('Login failed with status: ${response.statusCode}');
      return false;
    }
  }
}
