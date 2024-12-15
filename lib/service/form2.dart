import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import '../models/form2.dart';
import 'package:http_parser/http_parser.dart';  // Untuk MediaType
import 'dart:async';  // Untuk TimeoutException
import 'api_url.dart';

class PendaftaranTahap2Service {
  // Get Divisi UKM
  Future<ApiResponse> getDivisiUkm(String idUkm) async {
    try {
      print('=== Getting Divisi UKM ===');
      print('ID UKM: $idUkm');

      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');
      
      if (sessionId == null) {
        return ApiResponse(
          status: 'error',
          message: 'No active session',
        );
      }

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/get_divisi_ukm.php?id_ukm=$idUkm'),
        headers: {
          'Cookie': 'PHPSESSID=$sessionId',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonResponse);
        
        if (apiResponse.isSuccess && apiResponse.data != null) {
          final divisiList = (apiResponse.data as List)
              .map((item) => DivisiModel.fromJson(item))
              .toList();
          return ApiResponse(
            status: 'success',
            data: divisiList,
          );
        }
        return apiResponse;
      }

      return ApiResponse(
        status: 'error',
        message: 'Server error: ${response.statusCode}',
      );
    } catch (e) {
      print('Error getting divisi: $e');
      return ApiResponse(
        status: 'error',
        message: e.toString(),
      );
    }
  }

  // Submit Tahap 2
  Future<ApiResponse> submitTahap2({
    required PendaftaranTahap2Request request,
    File? izinOrtu,
    File? sertifikatWarna,
    File? sertifikatLkmm,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      print('=== Submit Tahap 2 ===');
      print('Request data: ${request.toJson()}');
      print('Files to upload:');
      print('- Izin Ortu: ${izinOrtu?.path}');
      print('- Sertifikat Warna: ${sertifikatWarna?.path}');
      print('- Sertifikat LKMM: ${sertifikatLkmm?.path}');
      print('Session ID: $sessionId');

      if (sessionId == null) {
        return ApiResponse(
          status: 'error',
          message: 'No active session',
        );
      }

      var uri = Uri.parse('${AppConfig.apiBaseUrl}/submit_tahap2.php');
      var multipartRequest = http.MultipartRequest('POST', uri);

      multipartRequest.headers.addAll({
        'Cookie': 'PHPSESSID=$sessionId',
        'Accept': '*/*',
      });

      // Add fields
      multipartRequest.fields.addAll(request.toJson());
      print('Added fields: ${multipartRequest.fields}');

      // Helper function untuk menambahkan file dengan content type yang tepat
      Future<void> addFileWithType(File? file, String fieldName) async {
        if (file != null) {
          // Set content type based on file extension
          String contentType;
          final extension = path.extension(file.path).toLowerCase();
          
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
              throw Exception('File type not supported. Use PDF, JPG, or PNG');
          }

          final stream = http.ByteStream(file.openRead());
          final length = await file.length();
          final filename = '$fieldName$extension';

          final multipartFile = http.MultipartFile(
            fieldName,
            stream,
            length,
            filename: filename,
            contentType: MediaType.parse(contentType)
          );

          print('Adding $fieldName - Size: $length, Content-Type: $contentType, Filename: $filename');
          multipartRequest.files.add(multipartFile);
        }
      }

      // Add files dengan proper content type
      await addFileWithType(izinOrtu, 'izin_ortu');
      await addFileWithType(sertifikatWarna, 'sertifikat_wa_rna');
      await addFileWithType(sertifikatLkmm, 'sertifikat_lkmm');

      print('Total files to be sent: ${multipartRequest.files.length}');
      
      final streamedResponse = await multipartRequest.send().timeout(
        Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      
      final response = await http.Response.fromStream(streamedResponse);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body);
          print('Parsed response: $jsonResponse');
          return ApiResponse.fromJson(jsonResponse);
        } catch (e) {
          print('Error parsing response: $e');
          return ApiResponse(
            status: 'error',
            message: 'Error parsing response: $e',
          );
        }
      }

      return ApiResponse(
        status: 'error',
        message: 'Server error: ${response.statusCode}',
      );

    } catch (e, stackTrace) {
      print('Error in submitTahap2: $e');
      print('Stack trace: $stackTrace');
      return ApiResponse(
        status: 'error',
        message: e.toString(),
      );
    }
  }
}