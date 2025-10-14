import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      final token = await ApiService.getToken();
      if (token != null) {
        final response = await ApiService.verifyToken();
        _setUser(User.fromJson(response['user']));
        _setError(null);
      }
    } catch (e) {
      // Token is invalid, clear it
      await ApiService.clearToken();
      _setUser(null);
      _setError(null);
    } finally {
      _setLoading(false);
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await ApiService.login(email, password);
      _setUser(User.fromJson(response['user']));
      _setError(null);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await ApiService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
      _setUser(User.fromJson(response['user']));
      _setError(null);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Update profile
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await ApiService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
      _setUser(User.fromJson(response['user']));
      _setError(null);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);
    await ApiService.clearToken();
    _setUser(null);
    _setError(null);
    _setLoading(false);
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Get fresh profile data
  Future<void> refreshProfile() async {
    if (!isAuthenticated) return;
    
    try {
      final response = await ApiService.getProfile();
      _setUser(User.fromJson(response['user']));
      _setError(null);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
