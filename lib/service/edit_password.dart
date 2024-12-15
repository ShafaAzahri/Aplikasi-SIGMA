// lib/service/edit_password.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_url.dart';

class EditPasswordService {
  Future<bool> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      if (sessionId == null) throw Exception('No active session');

      print('Sending password update with:');
      print('old_password: $oldPassword');
      print('new_password: $newPassword');

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/change_password.php'),
        headers: {
          'Cookie': 'PHPSESSID=$sessionId',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'old_password': oldPassword,
          'new_password': newPassword,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return true;
        }
        throw Exception(jsonResponse['message'] ?? 'Failed to update password');
      }
      
      throw Exception('Failed to connect to server');
    } catch (e) {
      print('Error in password service: $e');
      throw Exception('Failed to change password: $e');
    }
  }
}