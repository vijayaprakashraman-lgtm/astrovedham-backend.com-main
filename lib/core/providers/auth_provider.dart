import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';

enum AuthState { unauthenticated, authenticating, authenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  AuthState _state = AuthState.unauthenticated;
  bool _isLoading = false;
  String? _error;
  String? _otpSentMobile;

  AuthState get state => _state;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _state == AuthState.authenticated;
  String? get error => _error;
  String? get otpSentMobile => _otpSentMobile;

  String? get customerName => LocalStorageService.instance.getName();
  String? get customerMobile => LocalStorageService.instance.getMobile();
  String? get customerEmail => LocalStorageService.instance.getEmail();
  String? get customerGender => LocalStorageService.instance.getGender();

  AuthProvider() {
    checkAuthStatus();
  }

  /// Check token existence on app startup
  void checkAuthStatus() {
    if (_authService.isAuthenticated()) {
      _state = AuthState.authenticated;
      // Refresh profile in background
      _refreshProfileSilently();
    } else {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> _refreshProfileSilently() async {
    try {
      await _authService.fetchProfile();
      notifyListeners();
    } catch (_) {}
  }

  String _cleanError(dynamic e) {
    String msg = e.toString();
    if (e is NetworkException) {
      msg = e.message;
    }
    msg = msg.replaceAll(RegExp(r'^(NetworkException|Exception|DioException):\s*'), '');
    msg = msg.replaceAll(RegExp(r'\s*\(Status:\s*\d+\)$'), '');
    msg = msg.trim();

    if (msg.contains('SocketException') || msg.contains('connect') || msg.contains('network') || msg.contains('connection')) {
      return 'Unable to connect. Please check your internet connection.';
    }
    if (msg.contains('401') || msg.contains('Unauthorized') || msg.contains('403') || msg.contains('UA')) {
      return 'Authentication failed or session expired. Please try again.';
    }
    if (msg.isEmpty) {
      return 'Authentication failed. Please try again.';
    }
    return msg;
  }

  /// Request OTP for customer mobile number
  Future<bool> sendOtp(String mobile) async {
    if (_isLoading) return false;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.sendOtp(mobile);
      _otpSentMobile = mobile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _cleanError(e);
      notifyListeners();
      return false;
    }
  }

  /// Verify submitted OTP
  Future<bool> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    if (_isLoading) return false;
    _isLoading = true;
    _error = null;
    _state = AuthState.authenticating;
    notifyListeners();

    try {
      await _authService.verifyOtp(mobile: mobile, otp: otp);
      _state = AuthState.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.unauthenticated;
      _isLoading = false;
      _error = _cleanError(e);
      notifyListeners();
      return false;
    }
  }

  /// Update Profile
  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    if (_isLoading) return false;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.updateProfile(name: name, email: email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _cleanError(e);
      notifyListeners();
      return false;
    }
  }

  /// Logout customer
  Future<void> logout() async {
    await _authService.logout();
    _state = AuthState.unauthenticated;
    _error = null;
    _otpSentMobile = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
