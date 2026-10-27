# Walkthrough — AstroVedham Flutter ↔ Backend Integration

I have successfully integrated the AstroVedham Flutter application with the Node.js backend. The application now uses real APIs for order processing, listing, and report delivery while preserving the existing UI, architecture, and localization.

## Changes Made

### Core & Network
- **Centralized Config:** Created `lib/core/config/api_config.dart` to manage the backend base URL. Defaulted to `http://10.0.2.2:3000/api/v1` for Android Emulator.
- **Dio Integration:** Replaced the placeholder `ApiClient` with a robust `Dio` implementation in `lib/core/network/api_client.dart`, including error handling and logging interceptors.

### Data Layer
- **Order Model:** Updated `lib/models/order.dart` to support all backend fields (`orderNumber`, `customerId`, `amount`, `status`, etc.) and handle uppercase status enums (`PENDING`, `SUCCESS`, `CANCELLED`).
- **Order Service:** Implemented `OrderService` for direct communication with the backend APIs.
- **Repository Pattern:** Updated `OrderRepository` to fetch data from the backend instead of `SharedPreferences`.

### UI & Features
- **Order Listing:** Updated `OrdersScreen` to fetch real data and support "Load More" pagination. Added `load_more` translations.
- **Order Details:** Created `OrderDetailScreen` to display comprehensive order information from the backend.
- **Order Creation:** Updated `ReviewDetailsScreen` to send horoscope data to `POST /api/v1/orders`.
- **PDF Reports:** Modified `PdfViewerScreen` to fetch PDF bytes directly from the backend API, bypassing local filesystem paths.

## Verified Flow

1. **Horoscope Input:** User enters birth details.
2. **Review:** User reviews details and taps "Confirm".
3. **Creation:** `POST /api/v1/orders` is called; order is created in PostgreSQL.
4. **My Orders:** New order appears as `PENDING`.
5. **Pagination:** "Load More" button appears when more orders are available.
6. **Details:** User can tap "View Details" to see all order metadata.
7. **Processing:** Admin uploads PDF via backend.
8. **Report:** Status updates to `SUCCESS`. User taps "View Report"; PDF is fetched via API and displayed in the viewer.

## Configuration for Testing

> [!IMPORTANT]
> **Android Emulator:** The app is configured to connect to `http://10.0.2.2:3000/api/v1`.
> **Backend:** Ensure your Node.js server is running on port 3000.

### Steps to Run
1. Start the backend: `npm run dev` (or your startup command).
2. Start the Flutter app: `flutter run`.
3. Go to any Horoscope service, fill the form, and confirm.
4. Verify the order in "My Orders".
5. Use the Admin API/Panel to upload a PDF for that order number.
6. Refresh "My Orders" and view the report.

## Remaining Considerations
- **Authentication:** Currently, orders are fetched using the phone number stored in local profile settings.
- **Payment:** Payment gateway integration is not yet implemented as per requirements.
