import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// Conditional import for web
import 'file_utils_web.dart' if (dart.library.io) 'file_utils_stub.dart';

class FileUtils {
  static const MethodChannel _mediaStoreChannel =
      MethodChannel('com.astrovedham.app/media_store');

  /// Saves the given PDF [bytes] to the public user-accessible Android Downloads directory (`MediaStore.Downloads`).
  /// Returns the saved file path/URI string, or `null` if saving failed.
  static Future<String?> saveToPublicDownloads({
    required Uint8List bytes,
    required String fileName,
  }) async {
    if (kIsWeb) {
      await WebFileUtils.downloadFile(bytes, fileName);
      return 'web_download';
    }

    if (bytes.isEmpty) {
      throw Exception('Cannot save empty PDF bytes');
    }

    try {
      if (!kIsWeb && Platform.isAndroid) {
        try {
          final String? savedPath = await _mediaStoreChannel.invokeMethod<String>(
            'saveToDownloads',
            {
              'bytes': bytes,
              'fileName': fileName,
            },
          );

          if (savedPath != null && savedPath.isNotEmpty) {
            if (kDebugMode) {
              debugPrint('[PUBLIC_DOWNLOAD] Saved via MediaStore to: $savedPath');
            }
            return savedPath;
          }
        } on PlatformException catch (e) {
          if (kDebugMode) {
            debugPrint('[PUBLIC_DOWNLOAD] MediaStore channel error: $e. Falling back to direct storage.');
          }
        }

        // Fallback for older Android / direct filesystem if channel fails
        Directory? downloadDir = Directory('/storage/emulated/0/Download');
        if (!await downloadDir.exists()) {
          downloadDir = await getExternalStorageDirectory();
        }

        if (downloadDir != null) {
          if (!await downloadDir.exists()) {
            await downloadDir.create(recursive: true);
          }

          var destFile = File('${downloadDir.path}/$fileName');
          if (await destFile.exists()) {
            final nameWithoutExt = fileName.contains('.')
                ? fileName.substring(0, fileName.lastIndexOf('.'))
                : fileName;
            final ext = fileName.contains('.')
                ? fileName.substring(fileName.lastIndexOf('.'))
                : '';
            int count = 1;
            while (await destFile.exists()) {
              destFile = File('${downloadDir.path}/$nameWithoutExt ($count)$ext');
              count++;
            }
          }

          await destFile.writeAsBytes(bytes, flush: true);
          if (kDebugMode) {
            debugPrint('[PUBLIC_DOWNLOAD] Saved via fallback to: ${destFile.path}');
          }
          return destFile.path;
        }
      }

      // iOS or fallback
      final docsDir = await getApplicationDocumentsDirectory();
      final file = File('${docsDir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PUBLIC_DOWNLOAD ERROR] $e');
      }
      return null;
    }
  }

  /// Legacy helper method kept for backwards compatibility
  static Future<String?> saveAndOpenPdf({
    required Uint8List bytes,
    required String fileName,
  }) async {
    return saveToPublicDownloads(bytes: bytes, fileName: fileName);
  }
}
