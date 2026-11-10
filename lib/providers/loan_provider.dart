import 'package:flutter/material.dart';
import '../models/loan.dart';
import '../services/api_service.dart';

class LoanProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Loan> _loans = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Loan> get loans => _loans;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadLoans() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _loans = await _apiService.fetchLoans();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> processReturn(int id) async {
    try {
      await _apiService.returnLoan(id);
      await loadLoans(); // Muat ulang data setelah berhasil
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}