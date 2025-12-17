import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/auth';

  // Register with profile picture
  static Future<Map<String, dynamic>> register(
      String name, String email, String password, {String? profilePicture}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'profilePicture': profilePicture,
        }),
      );

      final data = json.decode(response.body);

      return {
        'success': response.statusCode == 201,
        'data': data,
        'message': data['message'] ?? data['error'] ?? 'Unknown error',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }

  // Login and other methods remain same
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'data': data,
        'message': data['message'] ?? data['error'] ?? 'Unknown error',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      return {
        'success': response.statusCode == 200,
        'data': data,
        'message': data['message'] ?? data['error'] ?? 'Unknown error',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }
}
