# Implementation Plan - Fix PDF Viewer (Memory-Based Loading)

The previous attempt to load PDFs via `.network` failed with a generic error, and the `.file` approach failed due to a `MissingPluginException` (likely requiring a cold boot). This plan implements a robust **Memory-Based Loading** approach using `Dio` to fetch the bytes, which avoids dependency on the file system and provides a better user experience.

## User Review Required

> [!IMPORTANT]
> - I will switch the loading logic to fetch PDF data as `Uint8List` (memory) instead of streaming directly from the URL.
> - **Action Required**: After I apply these changes, if you still see a "MissingPluginException", please **STOP the app completely** and **START it again** from Android Studio. This is necessary because new native plugins were added.

## Proposed Changes

### Presentation Layer

#### [MODIFY] [pdf_viewer_screen.dart](file:///D:/Flutter_SDK/astrovedham/lib/features/orders/presentation/screens/pdf_viewer_screen.dart)
- Use `Dio` with `ResponseType.bytes` to download the PDF.
- Store the downloaded bytes in a `Uint8List?`.
- Show a progress percentage and a "Downloading..." message.
- Use `SfPdfViewer.memory` to display the content once the download is complete.
- This approach is often more stable for specific network configurations where the direct stream might fail.

## Verification Plan

### Manual Verification
1. **Sample Preview**: Open any service and tap "View".
2. **Download Progress**: Verify that the progress bar increases as the data is fetched.
3. **Display**: Confirm the PDF renders correctly after the progress bar reaches 100%.
4. **Error Handling**: Verify the "Retry" button appears if the download is interrupted (e.g., turning off Wi-Fi).
