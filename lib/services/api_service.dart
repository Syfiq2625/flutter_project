import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tool.dart';

class ApiService {
  // Gunakan localhost karena Laragon berjalan di komputer yang sama
  static const String baseUrl = 'http://localhost/lab_api';

  Future<List<Tool>> fetchTools() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tools.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        
        // Memastikan format JSON konsisten dengan arsitektur: { success, data, message }
        if (decoded['success'] == true) {
          final List<dynamic> data = decoded['data'];
          return data.map((item) => Tool.fromJson(item)).toList();
        } else {
          throw Exception(decoded['message'] ?? 'Gagal mengambil data');
        }
      } else {
        throw Exception('Gagal terhubung ke server. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error jaringan: $e');
    }
  }
}