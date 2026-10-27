import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LocalReportService {
  static final LocalReportService instance = LocalReportService._();
  LocalReportService._();

  Directory? _reportsDirectory;

  Future<Directory> _getReportsDirectory() async {
    if (_reportsDirectory != null && await _reportsDirectory!.exists()) {
      return _reportsDirectory!;
    }
    final docsDir = await getApplicationDocumentsDirectory();
    final reportsDir = Directory('${docsDir.path}/reports');
    if (!await reportsDir.exists()) {
      await reportsDir.create(recursive: true);
    }
    _reportsDirectory = reportsDir;
    return reportsDir;
  }

  String _getSanitizedFileName(String orderNumber) {
    final safeOrder = orderNumber.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return '$safeOrder.pdf';
  }

  Future<File?> getLocalReport(String orderNumber) async {
    if (kIsWeb) return null;
    if (orderNumber.trim().isEmpty) return null;

    if (kDebugMode) {
      debugPrint('[PDF_CACHE] Checking local report: $orderNumber');
    }

    try {
      final dir = await _getReportsDirectory();
      final fileName = _getSanitizedFileName(orderNumber);
      final file = File('${dir.path}/$fileName');

      if (await file.exists()) {
        final length = await file.length();
        if (length >= 4) {
          final handle = await file.open(mode: FileMode.read);
          final headerBytes = await handle.read(4);
          await handle.close();

          if (headerBytes.length >= 4 &&
              String.fromCharCodes(headerBytes) == '%PDF') {
            if (kDebugMode) {
              debugPrint('[PDF_CACHE] Local report found: ${file.path}');
            }
            return file;
          }
        }

        if (kDebugMode) {
          debugPrint(
            '[PDF_CACHE] Corrupted local report detected for $orderNumber, deleting...',
          );
        }
        await file.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PDF_CACHE] Error reading local report: $e');
      }
    }

    if (kDebugMode) {
      debugPrint('[PDF_CACHE] Local report missing');
    }
    return null;
  }

  Future<bool> hasLocalReport(String orderNumber) async {
    final file = await getLocalReport(orderNumber);
    return file != null;
  }

  Future<File> saveReport(String orderNumber, Uint8List bytes) async {
    if (bytes.isEmpty) {
      throw Exception('Cannot save empty PDF report.');
    }

    if (bytes.length < 4 || String.fromCharCodes(bytes.take(4)) != '%PDF') {
      throw Exception('The downloaded file is not a valid PDF report.');
    }

    if (kIsWeb) {
      if (kDebugMode) {
        debugPrint('[PDF_CACHE] Web environment detected; skipping disk persistence');
      }
      return File('');
    }

    if (kDebugMode) {
      debugPrint('[PDF_CACHE] PDF validated');
    }

    final dir = await _getReportsDirectory();
    final fileName = _getSanitizedFileName(orderNumber);
    final finalPath = '${dir.path}/$fileName';
    final tempPath = '${dir.path}/$fileName.tmp';

    final tempFile = File(tempPath);
    await tempFile.writeAsBytes(bytes, flush: true);

    final finalFile = await tempFile.rename(finalPath);
    if (kDebugMode) {
      debugPrint('[PDF_CACHE] Saved local report: ${finalFile.path}');
    }
    return finalFile;
  }

  Future<void> deleteLocalReport(String orderNumber) async {
    if (kIsWeb || orderNumber.trim().isEmpty) return;
    try {
      final dir = await _getReportsDirectory();
      final fileName = _getSanitizedFileName(orderNumber);
      final file = File('${dir.path}/$fileName');
      if (await file.exists()) {
        await file.delete();
        if (kDebugMode) {
          debugPrint('[PDF_CACHE] Deleted local report: ${file.path}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PDF_CACHE] Error deleting local report: $e');
      }
    }
  }

  Future<void> clearAllReports() async {
    if (kIsWeb) return;
    try {
      final dir = await _getReportsDirectory();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        await dir.create(recursive: true);
        if (kDebugMode) {
          debugPrint('[PDF_CACHE] Cleared all local reports');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[PDF_CACHE] Error clearing local reports: $e');
      }
    }
  }
}
