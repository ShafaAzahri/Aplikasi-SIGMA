import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ukm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latihan/models/ukm_detail_registered.dart';
import 'package:latihan/models/ukm_detail_not_registered.dart';
import 'package:latihan/models/struktur_lengkap.dart';
import 'api_url.dart';

class UkmService {
  Future<List<UkmModel>> getUkmDiikuti() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      if (sessionId == null) {
        throw Exception('No active session');
      }

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/get_ukm_diikuti.php'),
        headers: {
          'Cookie': 'PHPSESSID=$sessionId',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.body.contains('error')) {
          throw Exception('Session expired');
        }
        
        final jsonData = json.decode(response.body);
        return (jsonData as List)
            .map((json) => UkmModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load UKM list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
  
  Future<List<UkmModel>> getUkmRekomendasi() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      if (sessionId == null) {
        throw Exception('No active session');
      }

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/get_ukm_rekomendasi.php'),
        headers: {
          'Cookie': 'PHPSESSID=$sessionId',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> jsonData = jsonResponse['data'];
          return jsonData.map((json) => UkmModel.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load UKM recommendations');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

Future<UkmDetail> getUkmDetailData(String ukmId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('PHPSESSID');

    if (sessionId == null) {
      throw Exception('No active session');
    }

    // Get Banner
    final bannerResponse = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/ukm_detail_registered.php'), // Update nama API
      headers: {
        'Cookie': 'PHPSESSID=$sessionId',
      },
      body: {
        'action': 'getBanner',
        'ukm_id': ukmId,
      },
    );

    // Get Program Kerja
    final prokerResponse = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/ukm_detail_registered.php'), // Update nama API
      headers: {
        'Cookie': 'PHPSESSID=$sessionId',
      },
      body: {
        'action': 'getTimeline',
        'ukm_id': ukmId,
        'jenis': 'proker',
      },
    );

    // Get Agenda
    final agendaResponse = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/ukm_detail_registered.php'), // Update nama API
      headers: {
        'Cookie': 'PHPSESSID=$sessionId',
      },
      body: {
        'action': 'getTimeline',
        'ukm_id': ukmId,
        'jenis': 'agenda',
      },
    );

    if (bannerResponse.statusCode == 200 && 
        prokerResponse.statusCode == 200 && 
        agendaResponse.statusCode == 200) {
      
      final bannerData = json.decode(bannerResponse.body);
      final prokerData = json.decode(prokerResponse.body);
      final agendaData = json.decode(agendaResponse.body);

      // Print response untuk debugging
      print('Banner Response: ${bannerResponse.body}');
      print('Proker Response: ${prokerResponse.body}');
      print('Agenda Response: ${agendaResponse.body}');

      if (bannerData['status'] == 'error' ||
          prokerData['status'] == 'error' ||
          agendaData['status'] == 'error') {
        throw Exception('Error from server');
      }

      final combinedData = {
        'banner': bannerData['data']['banner_path'],
        'proker': prokerData['data'] ?? [],
        'agenda': agendaData['data'] ?? [],
      };

      return UkmDetail.fromJson(combinedData);
    } else {
      throw Exception('Gagal mengambil data UKM');
    }
  } catch (e) {
    print('Error detail: $e'); // untuk debugging
    throw Exception('Network error: ${e.toString()}');
  }
}

Future<UkmDetailNotRegistered> getUkmDetailNotRegistered(String ukmId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('PHPSESSID');

    if (sessionId == null) {
      throw Exception('No active session');
    }

    final response = await http.get(
      Uri.parse('${AppConfig.apiBaseUrl}/ukm_detail_not_registered.php?id_ukm=$ukmId'),
      headers: {
        'Cookie': 'PHPSESSID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      if (jsonData['status'] == 'error') {
        throw Exception(jsonData['message']);
      }

      return UkmDetailNotRegistered.fromJson(jsonData);
    } else {
      throw Exception('Failed to load UKM detail');
    }
  } catch (e) {
    print('Error detail: $e');
    throw Exception('Network error: ${e.toString()}');
  }
}

  // di dalam UkmService
Future<StrukturLengkapResponse> getStrukturLengkap(String ukmId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('PHPSESSID');

    if (sessionId == null) {
      throw Exception('No active session');
    }

    final response = await http.get(
      Uri.parse('${AppConfig.apiBaseUrl}/struktur_lengkap.php?id_ukm=$ukmId'),
      headers: {
        'Cookie': 'PHPSESSID=$sessionId',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      
      if (jsonData['status'] == 'error') {
        throw Exception(jsonData['message']);
      }

      return StrukturLengkapResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to load struktur data');
    }
  } catch (e) {
    print('Error detail: $e');
    throw Exception('Network error: ${e.toString()}');
  }
}
}