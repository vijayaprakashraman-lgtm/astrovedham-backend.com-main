import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:astrovedham/core/theme/app_colors.dart';
import 'package:astrovedham/widgets/common/custom_app_bar.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String? title;
  final String? expectedOrderId;

  const WebViewScreen({
    super.key,
    required this.url,
    this.title,
    this.expectedOrderId,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _isLoading = false;
      _launchWebPaymentUrl();
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
              _checkUrlForPaymentResult(url);
            },
            onPageFinished: (String url) async {
              if (!mounted) return;
              setState(() {
                _isLoading = false;
              });
              _checkUrlForPaymentResult(url);

              try {
                final result = await _controller!.runJavaScriptReturningResult('document.body.innerText');
                final content = result.toString();
                if (kDebugMode) {
                  print('[WEBVIEW Snippet] ${content.length > 200 ? content.substring(0, 200) : content}');
                }
                if (_isApiErrorContent(content)) {
                  if (kDebugMode) {
                    print('[WEBVIEW DIAGNOSTIC] API / 404 response detected in webview: $content');
                  }
                  if (mounted) {
                    setState(() {
                      _hasError = true;
                    });
                  }
                }
              } catch (e) {
                if (kDebugMode) {
                  print('[WEBVIEW] Error inspecting page content: $e');
                }
              }
            },
            onNavigationRequest: (NavigationRequest request) {
              if (_checkUrlForPaymentResult(request.url)) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onWebResourceError: (WebResourceError error) {
              if (kDebugMode) {
                print('[WEBVIEW ERROR DIAGNOSTIC] ${error.description} (code: ${error.errorCode})');
              }
              if (mounted) {
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                });
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  Future<void> _launchWebPaymentUrl() async {
    try {
      final uri = Uri.parse(widget.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (kDebugMode) {
        print('[WEBVIEW] Error launching web payment URL: $e');
      }
    }
  }

  bool _isApiErrorContent(String rawText) {
    if (rawText.isEmpty) return false;

    String text = rawText;
    if (text.startsWith('"') && text.endsWith('"') && text.length >= 2) {
      text = text.substring(1, text.length - 1);
    }
    text = text.replaceAll(r'\"', '"').replaceAll(r'\n', '\n').trim();

    final lower = text.toLowerCase();

    if (lower.contains('api_connection_error') ||
        lower.contains('request_failed') ||
        lower.contains('endpoint or method is not valid') ||
        lower.contains('cannot post /') ||
        lower.contains('cannot get /')) {
      return true;
    }

    if (text.startsWith('{') && text.endsWith('}')) {
      if (lower.contains('"message"') &&
          (lower.contains('"code"') || lower.contains('"type"') || lower.contains('"status"'))) {
        return true;
      }
    }

    return false;
  }

  bool _checkUrlForPaymentResult(String url) {
    if (url.contains('payment_status') ||
        url.contains('status=SUCCESS') ||
        url.contains('status=PAID') ||
        url.contains('astrovedham.com/payment')) {
      final uri = Uri.tryParse(url);
      final orderId = uri?.queryParameters['order_id'] ?? widget.expectedOrderId;
      if (mounted) {
        Navigator.pop(context, {
          'success': true,
          'order_id': orderId,
        });
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: AppColors.sheetBackground,
        appBar: CustomAppBar(
          title: widget.title ?? 'app_name'.tr(),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.primaryText),
            onPressed: () {
              Navigator.pop(context, {'success': false, 'order_id': widget.expectedOrderId});
            },
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.payment_rounded,
                        size: 64,
                        color: AppColors.primaryGreen,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.title ?? 'AstroVedham Payment',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'A payment window has been opened in your browser. Complete your transaction on Cashfree and click below when finished.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        onPressed: _launchWebPaymentUrl,
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('Re-open Payment Window'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context, {
                            'success': true,
                            'order_id': widget.expectedOrderId,
                          });
                        },
                        icon: const Icon(Icons.check_circle_rounded),
                        label: const Text('I Have Completed Payment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, {
                            'success': false,
                            'order_id': widget.expectedOrderId,
                          });
                        },
                        child: const Text(
                          'Cancel Payment',
                          style: TextStyle(color: AppColors.alertRed, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_controller != null && await _controller!.canGoBack()) {
          await _controller!.goBack();
        } else {
          if (context.mounted) {
            Navigator.pop(context, {'success': false, 'order_id': widget.expectedOrderId});
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.sheetBackground,
        appBar: CustomAppBar(
          title: widget.title ?? 'app_name'.tr(),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.primaryText),
            onPressed: () async {
              if (context.mounted) {
                Navigator.pop(context, {'success': false, 'order_id': widget.expectedOrderId});
              }
            },
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (!_hasError && _controller != null) WebViewWidget(controller: _controller!),
              if (_hasError)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: AppColors.alertRed,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'form.error.something_went_wrong'.tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _hasError = false;
                              _isLoading = true;
                            });
                            _controller?.reload();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            minimumSize: const Size(160, 48),
                          ),
                          child: Text(
                            'common.retry'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_isLoading)
                const LinearProgressIndicator(
                  color: AppColors.primaryGreen,
                  backgroundColor: AppColors.sheetBackground,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
