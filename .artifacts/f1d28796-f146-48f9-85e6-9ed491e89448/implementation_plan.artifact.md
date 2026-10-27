# Implementation Plan - Fix Guest Order Flow

The goal is to trace and fix the guest order state flow in the AstroVedham Flutter app. Guest orders are being created successfully in the backend but are not being correctly displayed or persisted in the Flutter app.

## Proposed Changes

### Core Network Layer

#### [MODIFY] [api_client.dart](file:///D:/vp/astrovedham/lib/core/network/api_client.dart)
- Add more robust path parsing in the guest token interceptor to handle potential variations in path format.
- Ensure the interceptor correctly extracts the order number for guest authentication.

### Order Service

#### [MODIFY] [order_service.dart](file:///D:/vp/astrovedham/lib/features/orders/data/services/order_service.dart)
- Add safe diagnostics around guest order creation (logging status, response type, order number, and token presence).
- Improve response parsing to handle multiple possible field names for `orderNumber` (e.g., `order_number`, `orderNumber`, `id`) and `guestToken` (e.g., `guestAccessToken`, `guest_token`, `token`).
- Ensure the returned `OrderModel` is correctly populated with data from the backend response.

### Order Provider

#### [MODIFY] [order_provider.dart](file:///D:/vp/astrovedham/lib/core/providers/order_provider.dart)
- Add diagnostics to track the flow of order creation and state updates.
- Ensure `loadOrders` does not cause failures for guest users when it returns an empty list.

### UI Layers

#### [MODIFY] [review_details_screen.dart](file:///D:/vp/astrovedham/lib/features/horoscope/presentation/screens/review_details_screen.dart)
- Add diagnostics for navigation after order creation.
- Ensure the screen correctly handles the result from `addOrder`.

#### [MODIFY] [order_detail_screen.dart](file:///D:/vp/astrovedham/lib/features/orders/presentation/screens/order_detail_screen.dart)
- Add diagnostics for loading guest orders.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no regressions.

### Manual Verification
1.  **Guest Checkout Flow**:
    - Open "Life Horoscope".
    - Enter details and proceed to "Review Details".
    - Click "Continue" to create a guest order.
    - Verify diagnostics show successful order creation and token storage.
    - Verify immediate navigation to "Order Detail" screen.
    - Verify order details are displayed correctly.
2.  **Persistence**:
    - Restart the app.
    - Navigate to the guest order (if reachable via history or manual link).
    - Verify the guest order can still be retrieved using the stored token.
3.  **Regression**:
    - Log in as a customer.
    - Verify authenticated order flow still works correctly.
    - Verify "My Orders" still shows customer orders.
