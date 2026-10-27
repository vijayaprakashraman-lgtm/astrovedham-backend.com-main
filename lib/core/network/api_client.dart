import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import '../services/local_storage_service.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  NetworkException(this.message, {this.statusCode});

  @override
  String toString() {
    return 'NetworkException: $message (Status: $statusCode)';
  }
}

class ApiClient {
  late final Dio _dio;

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.currentBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = LocalStorageService.instance.getJwtToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Check for status UA in response body
          if (response.data is Map) {
            final data = response.data as Map;
            if (data['status'] == 'UA') {
              LocalStorageService.instance.clearAuthSession();
              if (kDebugMode) {
                print('[API AUTH] UA Status (Unauthorized) detected in response.');
              }
            }
          }
          return handler.next(response);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401 ||
              (e.response?.data is Map && e.response?.data['status'] == 'UA')) {
            LocalStorageService.instance.clearAuthSession();
            final path = e.requestOptions.path;
            if (kDebugMode) {
              print('[API AUTH] 401/UA Unauthorized detected on $path.');
            }
          }
          return handler.next(e);
        },
      ),
    );

    if (ApiConfig.isDevelopment) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (object) {
            print('[DIO] $object');
          },
        ),
      );
    }
  }

  static final ApiClient instance = ApiClient._();

  String get baseUrl => _dio.options.baseUrl;

  String _normalizePath(String rawPath) {
    if (rawPath.startsWith('http://') || rawPath.startsWith('https://')) {
      return rawPath;
    }
    // Remove leading slash so Uri.resolve keeps the base path '/api/'
    return rawPath.startsWith('/') ? rawPath.substring(1) : rawPath;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final cleanPath = _normalizePath(path);
    try {
      final response = await _dio.get(cleanPath, queryParameters: queryParameters);

      if (ApiConfig.isDevelopment) {
        debugPrint('API REQUEST SUCCESS: GET $cleanPath');
        debugPrint('Status Code: ${response.statusCode}');
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<dynamic> post(String path, dynamic data) async {
    final cleanPath = _normalizePath(path);
    if (kDebugMode) {
      print('[ASTROVEDHAM] API BASE URL: ${_dio.options.baseUrl}');
      print('[ASTROVEDHAM] REQUEST PATH: $cleanPath');
      print('[ASTROVEDHAM] FULL URL: ${_dio.options.baseUrl}$cleanPath');
    }

    try {
      final response = await _dio.post(cleanPath, data: data);

      if (ApiConfig.isDevelopment) {
        debugPrint('API REQUEST SUCCESS: POST $cleanPath');
        debugPrint('Status Code: ${response.statusCode}');
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<dynamic> patch(String path, dynamic data) async {
    final cleanPath = _normalizePath(path);
    try {
      final response = await _dio.patch(cleanPath, data: data);

      if (ApiConfig.isDevelopment) {
        debugPrint('API REQUEST SUCCESS: PATCH $cleanPath');
        debugPrint('Status Code: ${response.statusCode}');
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<Response<Uint8List>> download(String path) async {
    final cleanPath = _normalizePath(path);
    try {
      final response = await _dio.get<List<int>>(
        cleanPath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      final data = response.data;
      if (data == null) {
        throw NetworkException('No data received');
      }

      final uint8list = Uint8List.fromList(data);

      if (ApiConfig.isDevelopment) {
        debugPrint('API DOWNLOAD SUCCESS: $cleanPath');
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Bytes Received: ${uint8list.length}');
      }

      return Response<Uint8List>(
        data: uint8list,
        headers: response.headers,
        requestOptions: response.requestOptions,
        isRedirect: response.isRedirect,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        extra: response.extra,
        redirects: response.redirects,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      debugPrint('CONNECTION ERROR: $e');
      throw NetworkException(e.toString());
    }
  }

  NetworkException _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final requestPath = e.requestOptions.path;
    final fullUrl = '${e.requestOptions.baseUrl}$requestPath';

    // ALWAYS PRINT IN PRODUCTION TEMPORARILY
    print('[ASTROVEDHAM] DIO ERROR TYPE: ${e.type}');
    print('[ASTROVEDHAM] DIO ERROR MESSAGE: ${e.message}');
    print('[ASTROVEDHAM] DIO ERROR: ${e.error}');
    print('[ASTROVEDHAM] BASE URL: ${e.requestOptions.baseUrl}');
    print('[ASTROVEDHAM] REQUEST PATH: $requestPath');
    print('[ASTROVEDHAM] FULL URL: $fullUrl');
    print('[ASTROVEDHAM] STATUS CODE: $statusCode');
    print('[ASTROVEDHAM] RESPONSE: ${e.response?.data}');

    if (ApiConfig.isDevelopment) {
      debugPrint('========== DIO ERROR ==========');
      debugPrint('Type: ${e.type}');
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      debugPrint('API BASE URL: ${e.requestOptions.baseUrl}');
      debugPrint('HTTP METHOD: ${e.requestOptions.method}');
      debugPrint('REQUEST PATH: $requestPath');
      debugPrint('FULL URL: $fullUrl');
      debugPrint('Status Code: $statusCode');
      if (e.response?.data != null) {
        debugPrint('Response: ${e.response?.data}');
      }
      debugPrint('================================');
    }

    if (e.response != null) {
      final data = e.response?.data;

      if (data is Map) {
        final backendMessage = data['message'] ?? data['error'];

        if (backendMessage != null) {
          final msgStr = backendMessage.toString();
          if (kDebugMode) {
            print('[API ERROR DIAGNOSTIC] Backend message: $msgStr');
          }
          if (msgStr.contains('endpoint or method is not valid') ||
              msgStr.contains('request_failed') ||
              msgStr.contains('api_connection_error')) {
            return NetworkException(
              'Unable to process your request. Please try again later.',
              statusCode: statusCode,
            );
          }
          return NetworkException(
            msgStr,
            statusCode: statusCode,
          );
        }
      }

      return NetworkException(
        'Request failed. Please try again.',
        statusCode: statusCode,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException(
          'Unable to connect to the server. Please check your network connection and make sure the AstroVedham server is running.',
          statusCode: statusCode,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          'Unable to connect to the AstroVedham server. Please ensure the backend is running and reachable on your local network.',
          statusCode: statusCode,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          'Secure connection failed.',
          statusCode: statusCode,
        );

      case DioExceptionType.cancel:
        return NetworkException(
          'Request was cancelled.',
          statusCode: statusCode,
        );

      default:
        return NetworkException(
          'Unable to connect to the server. Please check your network connection and try again.',
          statusCode: statusCode,
        );
    }
  }
}
