import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/common/custom_app_bar.dart';
import '../../../../repositories/order_repository.dart';
import '../../../../core/services/local_report_service.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.title,
    this.orderNumber,
  });

  final String pdfUrl;
  final String title;
  final String? orderNumber;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  Uint8List? _pdfBytes;
  String? _localPath;
  bool _isLoading = true;
  String? _errorMessage;
  double _downloadProgress = 0;
  final Dio _dio = Dio();

  // Session-based cache to avoid re-downloading during the current app run
  static final Map<String, String> _downloadCache = {};

  @override
  void initState() {
    super.initState();
    _loadPdfData();
  }

  Future<void> _loadPdfData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _pdfBytes = null;
      _localPath = null;
      _downloadProgress = 0;
    });

    try {
      if (widget.orderNumber != null && widget.orderNumber!.isNotEmpty) {
        // --- PHASE 2: CUSTOMER ORDER REPORT FLOW (Local-First Caching) ---
        final orderNum = widget.orderNumber!;

        if (kIsWeb) {
          final bytes = await OrderRepository.instance.getOrderReport(orderNum);
          if (!mounted) return;
          setState(() {
            _pdfBytes = bytes;
            _isLoading = false;
          });
          return;
        }

        // 1. Check local report cache
        final localReport = await LocalReportService.instance.getLocalReport(orderNum);
        final bool hasCache = localReport != null;
        debugPrint('[PDF] local cache exists: $hasCache');

        if (localReport != null) {
          if (!mounted) return;
          setState(() {
            _localPath = localReport.path;
            _isLoading = false;
          });
          return;
        }

        // 2. Local report missing -> Download from backend
        final bytes = await OrderRepository.instance.getOrderReport(orderNum);

        // 3. Validate & save to local app-private storage
        final savedFile = await LocalReportService.instance.saveReport(orderNum, bytes);
        debugPrint('[PDF] cache saved: true');

        if (!mounted) return;
        setState(() {
          _localPath = savedFile.path;
          _isLoading = false;
        });
      } else if (widget.pdfUrl.isNotEmpty) {
        // --- SAMPLE REPORT FLOW (Download to File) ---
        if (kDebugMode) {
          debugPrint('================================================');
          debugPrint('[PDF] Source: Remote URL (Sample)');
          debugPrint('[PDF] URL: ${widget.pdfUrl}');
        }

        if (kIsWeb) {
          final response = await _dio.get<List<int>>(
            widget.pdfUrl,
            options: Options(
              responseType: ResponseType.bytes,
              followRedirects: true,
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 30),
            ),
            onReceiveProgress: (received, total) {
              if (total > 0 && mounted) {
                setState(() => _downloadProgress = received / total);
              }
            },
          );

          final data = response.data;
          if (data == null) throw Exception('Empty response from server.');
          final bytes = Uint8List.fromList(data);
          if (bytes.length < 4 || String.fromCharCodes(bytes.take(4)) != '%PDF') {
            throw Exception('The downloaded file is not a valid PDF.');
          }

          if (!mounted) return;
          setState(() {
            _pdfBytes = bytes;
            _isLoading = false;
          });
          return;
        }

        // 1. Check Cache
        if (!kIsWeb && _downloadCache.containsKey(widget.pdfUrl)) {
          final cachedPath = _downloadCache[widget.pdfUrl]!;
          if (await File(cachedPath).exists()) {
            if (kDebugMode) debugPrint('[PDF] Using cached file: $cachedPath');
            if (!mounted) return;
            setState(() {
              _localPath = cachedPath;
              _isLoading = false;
            });
            return;
          }
        }

        // 2. Download Document
        final tempDir = await getTemporaryDirectory();
        final urlParts = widget.pdfUrl.split('/');
        final rawFileName = urlParts.isNotEmpty
            ? urlParts.last
            : 'document.pdf';
        final safeFileName = rawFileName.replaceAll(
          RegExp(r'[^a-zA-Z0-9._]'),
          '_',
        );
        final finalFileName = safeFileName.endsWith('.pdf')
            ? safeFileName
            : '$safeFileName.pdf';
        final savePath = '${tempDir.path}/$finalFileName';

        final response = await _dio.get<List<int>>(
          widget.pdfUrl,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
          ),
          onReceiveProgress: (received, total) {
            if (total > 0 && mounted) {
              setState(() => _downloadProgress = received / total);
            }
          },
        );

        final data = response.data;
        if (data == null) throw Exception('Empty response from server.');

        final bytes = Uint8List.fromList(data);

        // 3. Verify PDF Header
        if (bytes.length < 4 || String.fromCharCodes(bytes.take(4)) != '%PDF') {
          throw Exception('The downloaded file is not a valid PDF.');
        }

        // 4. Save Locally
        final file = File(savePath);
        await file.writeAsBytes(bytes);
        _downloadCache[widget.pdfUrl] = savePath;

        if (kDebugMode) {
          debugPrint('[PDF] Successfully downloaded: $savePath');
          debugPrint('[PDF] Size: ${bytes.length} bytes');
          debugPrint('================================================');
        }

        if (!mounted) return;
        setState(() {
          _localPath = savePath;
          _isLoading = false;
        });
      } else {
        throw Exception('No document source provided.');
      }
    } catch (e) {
      debugPrint('[PDF] ERROR: $e');

      if (widget.orderNumber != null && widget.orderNumber!.isNotEmpty) {
        await LocalReportService.instance.deleteLocalReport(widget.orderNumber!);
      }

      String displayError = 'pdf_viewer.error_load_failed'.tr();
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          displayError = 'pdf_viewer.error_timeout'.tr();
        } else if (e.type == DioExceptionType.badResponse) {
          displayError = 'pdf_viewer.error_server'.tr(
            args: [e.response?.statusCode.toString() ?? 'unknown'],
          );
        }
      } else if (e.toString().contains('valid PDF')) {
        displayError = 'pdf_viewer.error_invalid'.tr();
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = displayError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: widget.title, centerTitle: false),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_errorMessage != null) {
      return _buildErrorView();
    }

    // View Order (Memory)
    if (_pdfBytes != null) {
      return SfPdfViewer.memory(
        _pdfBytes!,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
        onDocumentLoadFailed: (details) => _onViewerError(details.description),
      );
    }

    // View Sample (File - Mobile only)
    if (!kIsWeb && _localPath != null) {
      return SfPdfViewer.file(
        File(_localPath!),
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
        onDocumentLoadFailed: (details) => _onViewerError(details.description),
      );
    }

    return const SizedBox.shrink();
  }

  void _onViewerError(String description) {
    if (!mounted) return;
    debugPrint('[PDF] Viewer Error: $description');
    setState(() {
      _errorMessage = '${'pdf_viewer.error_title'.tr()}\n$description';
    });
  }

  Widget _buildLoadingView() {
    final hasProgress = _downloadProgress > 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primaryEmerald,
              strokeWidth: 3,
            ),
            const SizedBox(height: 32),
            Text(
              'pdf_viewer.loading_sample'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hasProgress
                  ? 'pdf_viewer.downloading_progress'.tr(
                      args: [(_downloadProgress * 100).toInt().toString()],
                    )
                  : 'pdf_viewer.downloading'.tr(),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            if (hasProgress) ...[
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _downloadProgress,
                  backgroundColor: AppColors.surfaceElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryEmerald,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.error,
                size: 64,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'pdf_viewer.error_title'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'pdf_viewer.error_load_failed'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                // Wipe cache for this URL or order to ensure clean retry
                if (widget.pdfUrl.isNotEmpty) {
                  _downloadCache.remove(widget.pdfUrl);
                }
                if (widget.orderNumber != null &&
                    widget.orderNumber!.isNotEmpty) {
                  await LocalReportService.instance.deleteLocalReport(
                    widget.orderNumber!,
                  );
                }
                _loadPdfData();
              },
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text('horoscope.error.try_again'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryEmerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
