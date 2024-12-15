import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/timeline_model.dart';
import 'api_url.dart';

class TimelineService {
  Future<List<TimelineModel>> getTimelines() async {
    try {
      final url = '${AppConfig.apiBaseUrl}/admin-ukm/timeline.php?limit=10&status=active';
      print('Fetching from: $url'); // Debug URL

      final response = await http.get(Uri.parse(url));
      
      print('Response status: ${response.statusCode}');
      print('Response body raw: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Parsed response: $jsonResponse'); // Debug parsed response
        
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => TimelineModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error detail: $e'); // Debug error detail
      return [];
    }
  }
}