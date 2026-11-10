import 'package:flutter/material.dart';
import '../models/tool.dart';
import '../services/api_service.dart';

class ToolProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Tool> _tools = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Tool> get tools => _tools;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadTools() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Beritahu UI untuk menampilkan loading spinner

    try {
      _tools = await _apiService.fetchTools();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Beritahu UI bahwa data sudah siap/gagal
    }
  }
}