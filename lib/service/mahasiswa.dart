import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/mahasiswa.dart';
import '../models/ukm_keanggotaan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_url.dart';

class ProfileResponse {
  final MahasiswaModel profile;
  final List<UkmKeanggotaanModel> ukmAktif;
  final List<UkmKeanggotaanModel> ukmHistori;

  ProfileResponse({
    required this.profile,
    required this.ukmAktif,
    required this.ukmHistori,
  });
}

class ProfileService {
  // lib/service/profile_service.dart
  Future<ProfileResponse> getMahasiswaProfile() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('PHPSESSID');

    if (sessionId == null) {
      throw Exception('No active session');
    }

    final response = await http.get(
      Uri.parse('${AppConfig.apiBaseUrl}/get_mahasiswa.php'),
      headers: {
        'Cookie': 'PHPSESSID=$sessionId',
        'Content-Type': 'application/json',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // Debug response

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('UKM Aktif data: ${jsonResponse['ukm_aktif']}'); // Debug UKM data

      if (jsonResponse['profile'] != null) {
        return ProfileResponse(
          profile: MahasiswaModel.fromJson(jsonResponse['profile']),
          ukmAktif: (jsonResponse['ukm_aktif'] as List)
              .map((ukm) {
                print('Processing UKM: $ukm'); // Debug individual UKM
                return UkmKeanggotaanModel.fromJson(ukm);
              })
              .toList(),
          ukmHistori: (jsonResponse['ukm_histori'] as List)
              .map((ukm) => UkmKeanggotaanModel.fromJson(ukm))
              .toList(),
        );
      }
      throw Exception(jsonResponse['message'] ?? 'Failed to load profile');
    }
    throw Exception('Failed to connect to server');
  } catch (e) {
    print('Error detail: $e'); // Debug error
    throw Exception('Error fetching profile: ${e.toString()}');
  }
}
}