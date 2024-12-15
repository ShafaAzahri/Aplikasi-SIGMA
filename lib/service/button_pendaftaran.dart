import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latihan/models/cek_periode_pendaftaran.dart';
import 'package:latihan/models/registration_status_model.dart';
import 'api_url.dart';


class RegistrationService {
  Future<RegistrationStatusData> checkRegistrationStatus(String idUkm) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionId = prefs.getString('PHPSESSID');

      print('Checking with sessionId: $sessionId'); // Debug session

      if (sessionId == null) {
        throw Exception('No active session');
      }

      final url = '${AppConfig.apiBaseUrl}/cek-status-pendaftaran.php?id_ukm=$idUkm';
      print('Request URL: $url'); // Debug URL

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Cookie': 'PHPSESSID=$sessionId',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Parsed JSON: $jsonResponse'); // Debug parsed JSON

        final statusResponse = RegistrationStatusResponse.fromJson(jsonResponse);

        if (statusResponse.status) {
          return statusResponse.data ?? RegistrationStatusData(status: 'BELUM_DAFTAR');
        } else {
          print('Status response failed: ${jsonResponse['message']}'); // Debug error message
          throw Exception('Failed to get registration status: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error in checkRegistrationStatus:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to check registration status: $e');
    }
  }

    Future<RegistrationPeriodResponse> checkRegistrationPeriod(String idUkm) async {
      try {
        final response = await http.get(
          Uri.parse('${AppConfig.apiBaseUrl}/cek-periode-pendaftaran.php?id_ukm=$idUkm'),
        );

        if (response.statusCode == 200) {
          return RegistrationPeriodResponse.fromJson(
            json.decode(response.body)
          );
        } else {
          throw Exception('Failed to check registration period');
        }
      } catch (e) {
        throw Exception('Error checking registration period: $e');
      }
    }
  }