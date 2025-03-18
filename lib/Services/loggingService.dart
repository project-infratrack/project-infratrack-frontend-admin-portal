import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';

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
      // Optionally, parse the response body if needed:
      // final responseData = jsonDecode(response.body);
      return true;
    } else {
      // Handle error responses appropriately.
      print('Login failed with status: ${response.statusCode}');
      return false;
    }
  }
}
