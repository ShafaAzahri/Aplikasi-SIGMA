// lib/services/ukm_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UkmService {
  static const String baseUrl = 'http://10.0.2.2/websigma/backend';

  Future<List<Map<String, dynamic>>> getUkmDiikuti() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');

      if (userData == null) {
        throw Exception('User not logged in');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/controllers/get_ukm_diikuti.php'),
        headers: {
          'Accept': 'application/json',
          'Cookie': 'PHPSESSID=${prefs.getString('PHPSESSID') ?? ''}'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((ukm) => ukm as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load UKM');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}