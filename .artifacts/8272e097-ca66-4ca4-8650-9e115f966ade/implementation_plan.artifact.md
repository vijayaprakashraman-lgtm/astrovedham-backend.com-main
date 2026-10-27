# Implementation Plan — AstroVedham Flutter ↔ Backend Integration

This plan outlines the steps to replace the current local/mock order processing with real AstroVedham backend APIs while preserving the existing Flutter UI and architecture.

## User Review Required

> [!IMPORTANT]
> The "Order Details" screen mentioned in the requirements was not found in the existing codebase. I will implement a new `OrderDetailScreen` in `lib/features/orders/presentation/screens/` to fulfill Phase 6 of the integration.

> [!WARNING]
> The backend base URL for Android Emulator (`http://10.0.2.2:3000/api/v1`) will be centralized in `ApiConfig`. Please ensure the backend is running and accessible at this address.

## Proposed Changes

### Core & Network

#### [NEW] [api_config.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/config/api_config.dart)
- Define `ApiConfig` with `baseUrl` and environment switching (Dev/Prod).
- Use `http://10.0.2.2:3000/api/v1` for development (Android Emulator).

#### [MODIFY] [api_client.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/network/api_client.dart)
- Replace placeholder logic with `Dio`.
- Implement `get`, `post`, `patch` methods with proper error handling and base URL integration.
- Add `interceptors` for logging or future auth needs.
- Handle `DioException` and map to user-friendly messages.

---

### Models

#### [MODIFY] [order.dart](file:///D:/Flutter_SDK/astrovedham/lib/models/order.dart)
- Ensure `OrderModel` correctly maps the backend response:
  - `id`, `orderNumber`, `customerId`, `horoscopeType`, `horoscopeTitle`, `inputDetails`, `amount`, `currency`, `status`, `resultAvailable`, `createdAt`, `updatedAt`, `completedAt`, `cancelledAt`.
- Align `OrderStatus` enum with backend: `PENDING`, `SUCCESS`, `CANCELLED`.

---

### Services & Repositories

#### [NEW] [order_service.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/orders/data/services/order_service.dart)
- Implement `createOrder(Map<String, dynamic> data)`
- Implement `getCustomerOrders(String phone, int page, int limit)`
- Implement `getOrderDetails(String orderNumber)`
- Implement `getOrderReport(String orderNumber)` (returning bytes or temp path).

#### [MODIFY] [order_repository.dart](file:///D:/Flutter_SDK/astrovedham/lib/repositories/order_repository.dart)
- Switch from `SharedPreferences` to `OrderService`.
- Remove mock lifecycle logic.
- Implement pagination handling (mapping service responses).

---

### Features: Orders

#### [MODIFY] [order_provider.dart](file:///D:/Flutter_SDK/astrovedham/lib/core/providers/order_provider.dart)
- Update to support pagination (page, limit, totalPages, hasNextPage).
- Add `loadMoreOrders()` functionality.
- Add method for fetching single order details.
- Maintain existing state management patterns.

#### [MODIFY] [orders_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/orders/presentation/screens/orders_screen.dart)
- Implement "Load More" button or pagination logic at the end of the list.
- Connect "View Details" and "View Report" to backend.
- Ensure the user's phone number is fetched from the session/profile.

#### [NEW] [order_detail_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/orders/presentation/screens/order_detail_screen.dart)
- Create a screen to display comprehensive backend order information (status, amount, input details, etc.).
- Follow existing AstroVedham design system exactly.
- Register route in `app_routes.dart`.

---

### Features: Horoscope

#### [MODIFY] [review_details_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/horoscope/presentation/screens/review_details_screen.dart)
- Replace mock order creation with `POST /api/v1/orders`.
- Map user-entered data correctly to the request body.
- Handle loading state and duplicate submission prevention.
- Preserve existing success UI and navigation.

#### [MODIFY] [pdf_viewer_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/horoscope/presentation/screens/pdf_viewer_screen.dart)
- Update to fetch PDF bytes from `GET /api/v1/orders/{orderNumber}/report` instead of using filesystem paths.

---

## Verification Plan

### Automated Tests
- I will verify the code builds without errors after each modification.
- I will use `read_logcat` to monitor network calls and potential errors during testing.

### Manual Verification Flow
1. **API Config:** Verify `ApiConfig.baseUrl` is correctly set.
2. **Order Creation:** Complete a horoscope input flow and verify the order is created in the backend (PostgreSQL).
3. **My Orders:** Verify the order appears in the list with "PENDING" status.
4. **Pagination:** Verify "Load More" works as expected.
5. **Admin Processing (Simulation):** Upload a PDF via backend API/Admin and verify status changes to "SUCCESS".
6. **Refresh My Orders:** Refresh Flutter and verify status changes to "SUCCESS".
7. **Order Details:** Verify all backend fields are displayed correctly in the new screen.
8. **PDF Viewing:** Tap "View Report" and verify the PDF is displayed in the Flutter viewer.
9. **Error Handling:** Simulate network failure and verify user-friendly error messages.
