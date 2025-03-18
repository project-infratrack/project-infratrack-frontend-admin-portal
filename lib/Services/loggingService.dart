import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infratrack/helper/api_config.dart';

class LoggingService {
  // Basic logging function – you can extend this as needed.
  static void log(String message) {
    print(message);
  }

  /// Calls the login API using [adminNo] and [password].
  /// Expects a JSON payload with "adminNo" and "password".
  static Future<dynamic> login(String adminNo, String password) async {
    final url = Uri.parse(
        '${ApiConfig.baseUrl}/login'); // Update endpoint if necessary.
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "adminNo": adminNo,
      "password": password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log('Login failed: status ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (error) {
      log('Exception during login: $error');
      rethrow;
    }
  }

  /// A generic GET request handler.
  /// The [endpoint] should start with a "/" (e.g., "/users").
  static Future<dynamic> getRequest(String endpoint) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log('GET $endpoint failed: status ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed GET request');
      }
    } catch (error) {
      log('Exception during GET $endpoint: $error');
      rethrow;
    }
  }

  /// A generic POST request handler.
  /// [data] is a Map containing the request payload.
  static Future<dynamic> postRequest(
      String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(data);
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log('POST $endpoint failed: status ${response.statusCode}, body: ${response.body}');
        throw Exception('Failed POST request');
      }
    } catch (error) {
      log('Exception during POST $endpoint: $error');
      rethrow;
    }
  }
}
