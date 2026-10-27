import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class NotificationNavigation {
  static GlobalKey<NavigatorState>? navigatorKey;

  static void handle({required String orderNumber, String? type}) {
    if (orderNumber.isEmpty) return;

    if (navigatorKey?.currentState != null) {
      navigatorKey!.currentState!.pushNamed(
        AppRoutes.orderDetail,
        arguments: orderNumber,
      );
    }
  }
}
