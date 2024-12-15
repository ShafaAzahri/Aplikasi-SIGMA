import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/edit_profile_model.dart';
import 'api_url.dart';

class EditProfileService {
  Future<bool> updateProfile(EditProfileModel profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      if (sessionId == null) {
        throw Exception('No active session');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.apiBaseUrl}/profile.php'),
      );

      request.headers['Cookie'] = 'PHPSESSID=$sessionId';
      request.fields.addAll(profile.toJson());

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == 'success';
      }

      throw Exception('Failed to update profile');
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }
}