import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_url.dart';

class AuthCheck {
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');
      
      if (sessionId == null) {
        print('No PHPSESSID found');
        return false;
      }

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/auth.php'),
        headers: {
          'Cookie': 'PHPSESSID=$sessionId',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('Auth check response: $result');
        
        // Gunakan authenticated dari response API
        return result['authenticated'] == true;
      }

      print('Failed auth check: ${response.statusCode}');
      return false;
      
    } catch (e) {
      print('AuthCheck error: $e');
      return false;
    }
  }
}