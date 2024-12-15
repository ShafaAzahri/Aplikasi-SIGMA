import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/form1.dart';
import 'api_url.dart';

class MahasiswaService {
  Future<MahasiswaFormData?> getMahasiswaFormData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      if (sessionId == null) {
        throw Exception('No active session');
      }

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/get_mahasiswa_form.php'),
        headers: {
          'Cookie': 'PHPSESSID=$sessionId',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = MahasiswaFormResponse.fromJson(
          json.decode(response.body)
        );
        
        if (jsonResponse.status) {
          return jsonResponse.data;
        } else {
          throw Exception(jsonResponse.message ?? 'Failed to get mahasiswa data');
        }
      } else {
        throw Exception('Failed to get mahasiswa data');
      }
    } catch (e) {
      print('Error getting mahasiswa data: $e');
      throw Exception('Error getting mahasiswa data: $e');
    }
  }

  Future<bool> submitPendaftaranTahap1({
  required String idUkm,
  required String motivasi,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('PHPSESSID');

    if (sessionId == null) {
      throw Exception('No active session');
    }

    final response = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/submit_tahap1.php'),
      headers: {
        'Cookie': 'PHPSESSID=$sessionId',
      },
      body: {
        'id_ukm': idUkm,
        'motivasi': motivasi,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['status'] == 'success';
    } else {
      throw Exception('Failed to submit pendaftaran');
    }
  } catch (e) {
    print('Error submitting pendaftaran: $e');
    throw Exception('Error submitting pendaftaran: $e');
  }
}

}

class MahasiswaFormResponse {
  final bool status;
  final MahasiswaFormData? data;
  final String? message;

  MahasiswaFormResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory MahasiswaFormResponse.fromJson(Map<String, dynamic> json) {
    return MahasiswaFormResponse(
      status: json['status'] == 'success',
      data: json['data'] != null ? MahasiswaFormData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  
}