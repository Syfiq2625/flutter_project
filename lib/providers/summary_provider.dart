import 'package:flutter/material.dart';
import '../models/summary.dart';
import '../services/api_service.dart';

class SummaryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  DashboardSummary? _summary;
  bool _isLoading = false;
  String _errorMessage = '';

  DashboardSummary? get summary => _summary;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadSummary() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _summary = await _apiService.fetchSummary();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}