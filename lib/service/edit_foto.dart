// lib/service/photo_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_url.dart';

class PhotoService {
  Future<bool> updateProfilePhoto(File imageFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      if (sessionId == null) throw Exception('No active session');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.apiBaseUrl}/profile.php'),
      );

      request.headers['Cookie'] = 'PHPSESSID=$sessionId';
      
      request.files.add(await http.MultipartFile.fromPath(
        'profilePicture',
        imageFile.path,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final jsonResponse = json.decode(response.body);
      return jsonResponse['status'] == 'success';
    } catch (e) {
      print('Error updating photo: $e');
      throw Exception('Failed to update photo');
    }
  }
}