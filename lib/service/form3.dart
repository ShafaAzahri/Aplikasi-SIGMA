// lib/service/submit_tahap3_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:latihan/models/form3.dart';
import 'dart:async';  // Untuk TimeoutException
import 'api_url.dart';

class SubmitTahap3Service {
  Future<SubmitTahap3Response> submitTahap3({
    required String idUkm,
    required File scanKtm,
    required File scanKhs,
    required File cv,
    required File motivationLetter,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      print('=== Submit Tahap 3 ===');
      print('UKM ID: $idUkm');
      print('Session ID: $sessionId');

      if (sessionId == null) {
        throw Exception('No active session');
      }

      var uri = Uri.parse('${AppConfig.apiBaseUrl}/submit_tahap3.php');
      var request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        'Cookie': 'PHPSESSID=$sessionId',
        'Accept': '*/*',
      });

      // Add fields
      request.fields['id_ukm'] = idUkm;

      // Function to add file with proper content type
      Future<void> addFileWithType(File file, String fieldName) async {
        final extension = path.extension(file.path).toLowerCase();
        String contentType;
        
        switch (extension) {
          case '.pdf':
            contentType = 'application/pdf';
            break;
          case '.jpg':
          case '.jpeg':
            contentType = 'image/jpeg';
            break;
          case '.png':
            contentType = 'image/png';
            break;
          default:
            throw Exception('Unsupported file type: $extension');
        }

        final stream = http.ByteStream(file.openRead());
        final length = await file.length();
        final multipartFile = http.MultipartFile(
          fieldName,
          stream,
          length,
          filename: path.basename(file.path),
          contentType: MediaType.parse(contentType),
        );

        print('Adding $fieldName - Type: $contentType, Size: $length bytes');
        request.files.add(multipartFile);
      }

      // Add all files
      await addFileWithType(scanKtm, 'scan_ktm');
      await addFileWithType(scanKhs, 'scan_khs');
      await addFileWithType(cv, 'cv');
      await addFileWithType(motivationLetter, 'motivation_letter');

      print('Sending request with ${request.files.length} files...');
      
      final streamedResponse = await request.send().timeout(
        Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException('Request timed out');  // Sekarang akan berfungsi
        },
      );

      final response = await http.Response.fromStream(streamedResponse);
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return SubmitTahap3Response.fromJson(jsonResponse);
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error in submitTahap3: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to submit: $e');
    }
  }
}