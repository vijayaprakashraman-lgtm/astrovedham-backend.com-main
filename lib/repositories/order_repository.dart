import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../features/orders/data/services/order_service.dart';

class OrderRepository {
  final OrderService _orderService = OrderService();

  static final OrderRepository instance = OrderRepository._();
  OrderRepository._();

  Future<Map<String, dynamic>> getOrders({int page = 1, int limit = 10}) async {
    return await _orderService.getCustomerOrders(
      page: page,
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> getPlans() async {
    return await _orderService.getPlans();
  }

  Future<Map<String, dynamic>> buyNow({
    required String planId,
    required String returnUrl,
  }) async {
    return await _orderService.buyNow(
      planId: planId,
      returnUrl: returnUrl,
    );
  }

  Future<Map<String, dynamic>> verifyPayment(String orderId) async {
    return await _orderService.verifyPayment(orderId);
  }

  Future<OrderModel> generateHoroscope(Map<String, dynamic> payload) async {
    return await _orderService.generateHoroscope(payload);
  }

  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    return await _orderService.generateHoroscope(orderData);
  }

  Future<OrderModel> getOrderDetails(String orderNumber) async {
    return await _orderService.getOrderDetails(orderNumber);
  }

  Future<Uint8List> getOrderReport(String orderNumber) async {
    return await _orderService.getOrderReport(orderNumber);
  }

  Future<void> refreshOrders() async {
    // Refreshing happens on fetch
  }

  Future<void> cancelOrder(String orderNumber) async {
    // Admin cancellation
  }
}
