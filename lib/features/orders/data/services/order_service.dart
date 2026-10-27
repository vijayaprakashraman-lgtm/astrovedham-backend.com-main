import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../models/order.dart';

class OrderService {
  final ApiClient _apiClient = ApiClient.instance;

  /// Fetch active plans with pricing from backend
  /// GET /customer/getplans
  Future<List<Map<String, dynamic>>> getPlans() async {
    try {
      final response = await _apiClient.get('/customer/getplans');

      if (response is Map && response['status'] == 'S') {
        final data = response['data'];
        if (data is List) {
          return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('[ORDER SERVICE] Error fetching plans: $e');
      }
      return [];
    }
  }

  /// Initiate Cashfree Buy Now payment link
  /// POST /customer/buy_now
  Future<Map<String, dynamic>> buyNow({
    required String planId,
    required String returnUrl,
  }) async {
    final response = await _apiClient.post('/customer/buy_now', {
      'plan_id': planId,
      'return_url': returnUrl,
    });

    if (response is Map && response['status'] == 'S') {
      final data = response['data'];
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
    }

    throw Exception(
      response is Map
          ? response['message'] ?? 'Failed to generate payment link'
          : 'Failed to generate payment link',
    );
  }

  /// Verify Cashfree payment status
  /// POST /customer/verify_payment
  Future<Map<String, dynamic>> verifyPayment(String orderId) async {
    final response = await _apiClient.post('/customer/verify_payment', {
      'order_id': orderId,
    });

    if (response is Map && response['status'] == 'S') {
      final data = response['data'];
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
      return Map<String, dynamic>.from(response);
    }

    throw Exception(
      response is Map
          ? response['message'] ?? 'Payment verification failed'
          : 'Payment verification failed',
    );
  }

  /// Generate Horoscope / Place Order
  /// POST /customer/generate_horoscope
  Future<OrderModel> generateHoroscope(Map<String, dynamic> payload) async {
    if (kDebugMode) {
      print('[ORDER SERVICE] generating horoscope with payload: $payload');
    }

    final response = await _apiClient.post('/customer/generate_horoscope', payload);

    if (response is Map && response['status'] == 'S') {
      final data = response['data'];
      if (data is Map) {
        final mergedData = Map<String, dynamic>.from(data);
        if (response['order_id'] != null) {
          mergedData['_id'] = response['order_id'];
        }
        return OrderModel.fromJson(mergedData);
      }
      if (response['order_id'] != null) {
        return OrderModel.fromJson({
          '_id': response['order_id'],
          'status': 'Pending',
          'created_at': DateTime.now().toIso8601String(),
          ...payload,
        });
      }
    }

    throw Exception(
      response is Map
          ? response['message'] ?? 'Failed to place horoscope order'
          : 'Failed to place horoscope order',
    );
  }

  /// Get Customer Orders
  /// GET /customer/orders
  Future<Map<String, dynamic>> getCustomerOrders({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.get(
      '/customer/orders',
      queryParameters: {'page': page, 'limit': limit},
    );

    if (response is Map && response['status'] == 'S') {
      final dataJson = response['data'];
      final List<OrderModel> orders = [];

      if (dataJson is List) {
        for (final item in dataJson) {
          if (item is Map) {
            orders.add(OrderModel.fromJson(Map<String, dynamic>.from(item)));
          }
        }
      }

      final total = response['total'] ?? orders.length;

      return {
        'orders': orders,
        'pagination': {
          'totalPages': ((total as int) / limit).ceil() == 0 ? 1 : (total / limit).ceil(),
          'hasNextPage': orders.length >= limit,
          'page': page,
        },
      };
    }

    throw Exception(
      response is Map
          ? response['message'] ?? 'Failed to fetch orders'
          : 'Failed to fetch orders',
    );
  }

  /// Get Details for a single order
  Future<OrderModel> getOrderDetails(String orderNumber) async {
    final ordersResult = await getCustomerOrders(page: 1, limit: 100);
    final List<OrderModel> orders = ordersResult['orders'] ?? [];

    for (final order in orders) {
      if (order.orderNumber == orderNumber || order.id == orderNumber) {
        return order;
      }
    }

    throw Exception('Order not found');
  }

  /// Download Order Report PDF
  /// Pattern: https://astrovedham.com/viewhoroscope/fileurl
  Future<Uint8List> getOrderReport(String orderNumberOrFileUrl) async {
    try {
      String downloadUrl;
      if (orderNumberOrFileUrl.startsWith('http://') || orderNumberOrFileUrl.startsWith('https://')) {
        downloadUrl = orderNumberOrFileUrl;
      } else if (orderNumberOrFileUrl.endsWith('.pdf')) {
        downloadUrl = 'https://astrovedham.com/viewhoroscope/$orderNumberOrFileUrl';
      } else {
        // Find order to get fileurl
        final order = await getOrderDetails(orderNumberOrFileUrl);
        if (order.fileurl != null && order.fileurl!.isNotEmpty) {
          downloadUrl = 'https://astrovedham.com/viewhoroscope/${order.fileurl}';
        } else if (order.pdfUrl != null && order.pdfUrl!.isNotEmpty) {
          downloadUrl = order.pdfUrl!;
        } else {
          downloadUrl = 'https://astrovedham.com/viewhoroscope/$orderNumberOrFileUrl';
        }
      }

      if (kDebugMode) {
        print('[PDF DOWNLOAD] Requesting URL: $downloadUrl');
      }

      final response = await _apiClient.download(downloadUrl);
      final Uint8List? data = response.data;
      final statusCode = response.statusCode ?? 200;

      if (data == null || data.isEmpty) {
        throw NetworkException('Report file is empty or unavailable.', statusCode: statusCode);
      }

      // Check PDF header
      if (data.length < 4 || String.fromCharCodes(data.take(4)) != '%PDF') {
        throw NetworkException('The received file is not a valid PDF report.', statusCode: statusCode);
      }

      return data;
    } on NetworkException {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('[PDF DOWNLOAD] Error: $e');
      }
      throw NetworkException('Unable to load the horoscope report. Please try again.');
    }
  }
}
