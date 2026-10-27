# Fix Guest My Orders + Order Status Sync

This plan addresses the issue where guest orders are not correctly retrieved or synchronized in the Flutter app's "My Orders" screen. The solution involves persisting a list of guest order numbers and their corresponding access tokens locally, and then fetching their current status from the backend using the guest-specific endpoints.

## User Review Required

> [!IMPORTANT]
> - Guest orders will be stored locally in `SharedPreferences`. If the user clears app data, these order records will be lost.
> - The app will fetch each guest order individually from the backend to ensure the status is always up-to-date.

## Proposed Changes

### Core Services & Persistence

#### [MODIFY] [local_storage_service.dart](file:///D:/vp/astrovedham/lib/core/services/local_storage_service.dart)
- Add methods to store and retrieve a list of guest order numbers.
- `Future<void> addGuestOrder(String orderNumber)`
- `List<String> getGuestOrderNumbers()`

#### [MODIFY] [order_service.dart](file:///D:/vp/astrovedham/lib/features/orders/data/services/order_service.dart)
- Update `createGuestOrder` to save the new order number to the local guest orders list.
- Ensure response parsing correctly maps `guestAccessToken` from the backend.

### Data Layer

#### [MODIFY] [order_repository.dart](file:///D:/vp/astrovedham/lib/repositories/order_repository.dart)
- Update `getOrders` to check for guest orders if the user is not authenticated.
- If guest orders exist, fetch each one using `_orderService.getOrderDetails(orderNumber)`.
- Aggregate the results into a single response matching the existing pagination structure.

### UI & State Management

#### [MODIFY] [order_provider.dart](file:///D:/vp/astrovedham/lib/core/providers/order_provider.dart)
- Ensure `loadOrders` and `refreshOrders` correctly handle the aggregated guest orders.

## Verification Plan

### Automated Tests
- N/A (Manual verification on device/emulator is required for full flow).

### Manual Verification
1. **Create Guest Order:** Complete a checkout as a guest. Verify the order appears in "My Orders" immediately.
2. **Multiple Orders:** Create a second guest order. Verify both appear in the list.
3. **Status Sync:** Change an order status to "SUCCESSFUL" or "CANCELLED" in the Admin panel. Pull to refresh in the Flutter app and verify the status updates.
4. **App Restart:** Close and reopen the app. Verify guest orders persist and statuses are fetched from the backend.
5. **Order Details:** Tap an order to view details and ensure the correct information is displayed.
6. **Report Access:** Verify that reports can be downloaded/viewed for successful guest orders.
