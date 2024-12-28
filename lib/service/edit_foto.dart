import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/edit_foto.dart';
import 'api_url.dart';

class PhotoService {
  Future<PhotoResponse> updateProfilePhoto(File photoFile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      if (sessionId == null) {
        return PhotoResponse(
          status: 'error',
          message: 'No active session found',
        );
      }

      final uri = Uri.parse('${AppConfig.apiBaseUrl}/profile.php');
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Cookie': 'PHPSESSID=$sessionId',
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          photoFile.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return PhotoResponse.fromJson(jsonDecode(response.body));
      } else {
        return PhotoResponse(
          status: 'error',
          message: 'Server error: ${response.statusCode}',
        );
      }

    } catch (e) {
      return PhotoResponse(
        status: 'error',
        message: 'Failed to update photo: ${e.toString()}',
      );
    }
  }
}