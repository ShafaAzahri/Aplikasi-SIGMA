import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/mahasiswa.dart';
import '../models/ukm_keanggotaan.dart';
import '../models/cek_pendaftaran_ukm.dart';  // Import the new model
import 'package:shared_preferences/shared_preferences.dart';
import 'api_url.dart';

class ProfileResponse {
  final MahasiswaModel profile;
  final List<UkmKeanggotaanModel> ukmAktif;
  final List<UkmKeanggotaanModel> ukmHistori;
  final List<UkmPendaftaranModel> ukmPendaftaran;  // Add new field

  ProfileResponse({
    required this.profile,
    required this.ukmAktif,
    required this.ukmHistori,
    required this.ukmPendaftaran,  // Add to constructor
  });
}

class ProfileService {
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
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('UKM Aktif data: ${jsonResponse['ukm_aktif']}');
        print('UKM Pendaftaran data: ${jsonResponse['ukm_pendaftaran']}');

        if (jsonResponse['profile'] != null) {
          return ProfileResponse(
            profile: MahasiswaModel.fromJson(jsonResponse['profile']),
            ukmAktif: (jsonResponse['ukm_aktif'] as List)
                .map((ukm) => UkmKeanggotaanModel.fromJson(ukm))
                .toList(),
            ukmHistori: (jsonResponse['ukm_histori'] as List)
                .map((ukm) => UkmKeanggotaanModel.fromJson(ukm))
                .toList(),
            ukmPendaftaran: (jsonResponse['ukm_pendaftaran'] as List)
                .map((ukm) => UkmPendaftaranModel.fromJson(ukm))
                .toList(),
          );
        }
        throw Exception(jsonResponse['message'] ?? 'Failed to load profile');
      }
      throw Exception('Failed to connect to server');
    } catch (e) {
      print('Error detail: $e');
      throw Exception('Error fetching profile: ${e.toString()}');
    }
  }
}