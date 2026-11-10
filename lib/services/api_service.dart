import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tool.dart';
import '../models/summary.dart';
import '../models/loan.dart';

class ApiService {
  // Gunakan localhost karena Laragon berjalan di komputer yang sama
  static const String baseUrl = 'http://localhost/lab_api';

  Future<List<Tool>> fetchTools({String query = '', String filter = ''}) async {
    try {
      final url = '$baseUrl/tools.php?search=${Uri.encodeComponent(query)}&filter=${Uri.encodeComponent(filter)}';
      final response = await http.get(Uri.parse(url));

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
  // Letakkan ini di dalam class ApiService
  Future<DashboardSummary> fetchSummary() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/summary.php'));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['success'] == true) {
          return DashboardSummary.fromJson(decoded['data']);
        } else {
          throw Exception(decoded['message']);
        }
      } else {
        throw Exception('Gagal memuat ringkasan');
      }
    } catch (e) {
      throw Exception('Error jaringan: $e');
    }
  }

  Future<List<Loan>> fetchLoans() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/loans.php'));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['success'] == true) {
          final List<dynamic> data = decoded['data'];
          return data.map((item) => Loan.fromJson(item)).toList();
        } else {
          throw Exception(decoded['message']);
        }
      } else {
        throw Exception('Gagal memuat peminjaman');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> returnLoan(int id) async {
    try {
      final response = await http.put(Uri.parse('$baseUrl/loans.php?id=$id'));
      if (response.statusCode != 200) throw Exception('Gagal mengembalikan alat');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> createLoan(Map<String, dynamic> loanData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/loans.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loanData),
      );
      
      final decoded = json.decode(response.body);
      if (response.statusCode == 200 && decoded['success'] == true) {
        return; // Sukses
      } else {
        throw Exception(decoded['message'] ?? 'Gagal membuat peminjaman');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}