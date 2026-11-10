import 'package:flutter/material.dart';
import '../models/tool.dart';
import '../services/api_service.dart';

class ToolProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Tool> _tools = [];
  bool _isLoading = false;
  String _errorMessage = '';

  String _searchQuery = '';
  String _activeFilter = '';

  List<Tool> get tools => _tools;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get activeFilter => _activeFilter;


// Fungsi loadTools sekarang mengirim parameter ke service
  Future<void> loadTools() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _tools = await _apiService.fetchTools(query: _searchQuery, filter: _activeFilter);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk dipanggil oleh UI (SearchBar)
  void setSearchQuery(String query) {
    _searchQuery = query;
    loadTools(); // Tarik data ulang
  }

  // Fungsi untuk dipanggil oleh UI (FilterChip)
  void setFilter(String filter) {
    // Jika filter yang diklik sama dengan yang aktif, matikan filternya
    _activeFilter = _activeFilter == filter ? '' : filter;
    loadTools(); // Tarik data ulang
  }
}