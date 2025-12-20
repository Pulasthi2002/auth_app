import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class AuthRepository {
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? profilePicture,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.registerEndpoint),
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

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginEndpoint),
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

  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.profileEndpoint),
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
