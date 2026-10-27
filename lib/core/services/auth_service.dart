import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../utils/phone_utils.dart';
import 'local_storage_service.dart';
import '../notifications/notification_service.dart';

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  final ApiClient _apiClient = ApiClient.instance;

  /// Send OTP to customer mobile number
  /// POST /customer/send_otp
  Future<Map<String, dynamic>> sendOtp(String mobile) async {
    final normalizedMobile = normalizePhone(mobile);

    try {
      final response = await _apiClient.post('/customer/send_otp', {
        'mobile': normalizedMobile,
      });

      if (response is Map) {
        final status = response['status']?.toString();
        if (status == 'S') {
          return Map<String, dynamic>.from(response);
        }
        final message = response['message']?.toString() ?? 'Failed to send OTP.';
        throw Exception(message);
      }

      throw Exception('Failed to send OTP. Unexpected server response.');
    } catch (e) {
      if (kDebugMode) {
        print('[AUTH SERVICE] Send OTP error: $e');
      }
      rethrow;
    }
  }

  /// Verify OTP and login / auto-register customer
  /// POST /customer/verify_otp
  Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    final normalizedMobile = normalizePhone(mobile);

    try {
      final response = await _apiClient.post('/customer/verify_otp', {
        'mobile': normalizedMobile,
        'otp': otp.trim(),
      });

      if (response is Map) {
        final status = response['status']?.toString();
        if (status == 'S') {
          final data = response['data'];
          if (data is Map) {
            final token = data['token']?.toString();
            final customer = data['customer'];

            if (token != null && token.trim().isNotEmpty) {
              final storage = LocalStorageService.instance;
              await storage.setJwtToken(token.trim());
              await storage.setMobile(normalizedMobile);

              if (customer is Map) {
                if (customer['name'] != null && customer['name'].toString().isNotEmpty) {
                  await storage.setName(customer['name'].toString());
                }
                if (customer['email'] != null && customer['email'].toString().isNotEmpty) {
                  await storage.setEmail(customer['email'].toString());
                }
              }

              try {
                await NotificationService.instance.registerFcmToken();
              } catch (e) {
                if (kDebugMode) {
                  print('[AUTH SERVICE] FCM registration warning: $e');
                }
              }

              return Map<String, dynamic>.from(response);
            }
          }
        }
        final message = response['message']?.toString() ?? 'Invalid or expired OTP.';
        throw Exception(message);
      }

      throw Exception('Verification failed. Unexpected server response.');
    } catch (e) {
      if (kDebugMode) {
        print('[AUTH SERVICE] Verify OTP error: $e');
      }
      rethrow;
    }
  }

  /// Get customer profile
  /// GET /customer/profile
  Future<Map<String, dynamic>> fetchProfile() async {
    try {
      final response = await _apiClient.get('/customer/profile');
      if (response is Map && response['status'] == 'S') {
        final data = response['data'];
        if (data is Map) {
          final storage = LocalStorageService.instance;
          if (data['name'] != null) {
            await storage.setName(data['name'].toString());
          }
          if (data['mobile'] != null) {
            await storage.setMobile(data['mobile'].toString());
          }
          if (data['email'] != null) {
            await storage.setEmail(data['email'].toString());
          }
        }
        return Map<String, dynamic>.from(response);
      }
      throw Exception(response is Map ? response['message'] ?? 'Failed to fetch profile' : 'Failed to fetch profile');
    } catch (e) {
      if (kDebugMode) {
        print('[AUTH SERVICE] Fetch profile error: $e');
      }
      rethrow;
    }
  }

  /// Update customer profile
  /// POST /customer/update_profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      final response = await _apiClient.post('/customer/update_profile', {
        'name': name.trim(),
        'email': email.trim(),
      });

      if (response is Map && response['status'] == 'S') {
        final storage = LocalStorageService.instance;
        await storage.setName(name.trim());
        await storage.setEmail(email.trim());
        return Map<String, dynamic>.from(response);
      }

      throw Exception(
        response is Map ? response['message'] ?? 'Failed to update profile' : 'Failed to update profile',
      );
    } catch (e) {
      if (kDebugMode) {
        print('[AUTH SERVICE] Update profile error: $e');
      }
      rethrow;
    }
  }

  /// Save / update customer phone number
  Future<void> updatePhone(String mobile) async {
    final normalizedMobile = normalizePhone(mobile);
    await LocalStorageService.instance.setMobile(normalizedMobile);
  }

  /// Logout customer session
  Future<void> logout() async {
    await LocalStorageService.instance.clearAuthSession();
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    final token = LocalStorageService.instance.getJwtToken();
    return token != null && token.trim().isNotEmpty;
  }

  /// Get currently stored JWT token
  String? getStoredToken() {
    return LocalStorageService.instance.getJwtToken();
  }
}
