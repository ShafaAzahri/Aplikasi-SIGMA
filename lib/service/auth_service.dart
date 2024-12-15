import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_url.dart';

class AuthService {
  Future<void> saveSession(http.Response response) async {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      String cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      if (cookie.startsWith('PHPSESSID=')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('PHPSESSID', cookie.substring(10));
      }
    }
  }

  Future<UserModel> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          await saveSession(response);
          return UserModel.fromJson(data['user']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to connect to server');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/logout.php'),
        headers: {
          'Cookie': 'PHPSESSID=$sessionId',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Hapus semua data lokal
        await prefs.clear();
        return true;
      }
      return false;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }
  
}