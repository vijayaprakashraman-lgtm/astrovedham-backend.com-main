import 'package:flutter/foundation.dart';
import '../../models/order.dart';
import '../../repositories/order_repository.dart';
import '../services/local_storage_service.dart';

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  List<Map<String, dynamic>> _plans = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  String? _error;

  // Pagination state
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasNextPage = false;

  List<OrderModel> get orders => _orders;
  List<Map<String, dynamic>> get plans => _plans;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  String? get error => _error;
  bool get hasNextPage => _hasNextPage;
  int get totalPages => _totalPages;

  Future<void> fetchPlans() async {
    try {
      final fetchedPlans = await OrderRepository.instance.getPlans();
      _plans = fetchedPlans;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('[ORDER PROVIDER] Error fetching plans: $e');
    }
  }

  /// Get plan_id for a given plan_type e.g. 'Single', 'Life', 'Marriage'
  String? getPlanIdForType(String planType) {
    for (final plan in _plans) {
      final id = plan['_id']?.toString() ?? plan['id']?.toString() ?? plan['plan_id']?.toString();
      final pType = plan['plan_type']?.toString() ?? plan['type']?.toString() ?? plan['title']?.toString();
      if (pType != null && pType.trim().toLowerCase() == planType.trim().toLowerCase()) {
        return id;
      }
    }
    return null;
  }

  Future<void> loadOrders({bool refresh = true}) async {
    final token = LocalStorageService.instance.getJwtToken();
    if (token == null || token.trim().isEmpty) {
      _isLoading = false;
      _isMoreLoading = false;
      _orders = [];
      _error = null;
      notifyListeners();
      return;
    }

    if (refresh) {
      _isLoading = true;
      _currentPage = 1;
      _orders = [];
      _error = null;
      notifyListeners();
    } else {
      _isMoreLoading = true;
      notifyListeners();
    }

    try {
      final result = await OrderRepository.instance.getOrders(
        page: _currentPage,
        limit: 10,
      );

      final List<OrderModel> newOrders = result['orders'] ?? [];
      final pagination = result['pagination'] ?? {};

      if (refresh) {
        _orders = newOrders;
      } else {
        _orders.addAll(newOrders);
      }

      _totalPages = pagination['totalPages'] ?? 1;
      _hasNextPage = pagination['hasNextPage'] ?? false;
      _currentPage = pagination['page'] ?? 1;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreOrders() async {
    if (!_hasNextPage || _isMoreLoading) return;
    _currentPage++;
    await loadOrders(refresh: false);
  }

  Future<Map<String, dynamic>> buyNow({
    required String planId,
    required String returnUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await OrderRepository.instance.buyNow(
        planId: planId,
        returnUrl: returnUrl,
      );
      return response;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> verifyPayment(String orderId) async {
    try {
      final result = await OrderRepository.instance.verifyPayment(orderId);
      await loadOrders(refresh: true);
      return result;
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<OrderModel?> generateHoroscope(Map<String, dynamic> payload) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final order = await OrderRepository.instance.generateHoroscope(payload);
      await loadOrders(refresh: true);
      return order;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderModel?> addOrder(Map<String, dynamic> orderData) async {
    return generateHoroscope(orderData);
  }

  Future<void> refreshOrders() async {
    await loadOrders(refresh: true);
  }

  Future<OrderModel?> getOrderDetails(String orderNumber) async {
    try {
      return await OrderRepository.instance.getOrderDetails(orderNumber);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Uint8List?> getOrderReport(String orderNumber) async {
    try {
      return await OrderRepository.instance.getOrderReport(orderNumber);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
