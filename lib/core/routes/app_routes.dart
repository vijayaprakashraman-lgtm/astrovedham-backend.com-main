import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:astrovedham/features/navigation/presentation/screens/main_navigation_screen.dart';
import 'package:astrovedham/features/horoscope_generator/presentation/screens/horoscope_generator_screen.dart';
import 'package:astrovedham/features/horoscope_generator/presentation/screens/horoscope_review_screen.dart';
import 'package:astrovedham/features/horoscope_generator/presentation/screens/horoscope_result_screen.dart';
import 'package:astrovedham/features/orders/presentation/screens/orders_screen.dart';
import 'package:astrovedham/features/cancelled_orders/presentation/screens/cancelled_orders_screen.dart';
import 'package:astrovedham/features/horoscope_generator/domain/entities/horoscope_service.dart';
import 'package:astrovedham/features/settings/presentation/screens/settings_screen.dart';
import 'package:astrovedham/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:astrovedham/features/onboarding/presentation/screens/language_selection_screen.dart';
import 'package:astrovedham/features/profile/presentation/screens/profile_screen.dart';
import 'package:astrovedham/features/legal/presentation/screens/about_astrovedham_screen.dart';
import 'package:astrovedham/features/legal/presentation/screens/privacy_policy_screen.dart';
import 'package:astrovedham/features/legal/presentation/screens/terms_and_conditions_screen.dart';
import 'package:astrovedham/features/legal/presentation/screens/legal_privacy_screen.dart';
import 'package:astrovedham/features/legal/presentation/screens/contact_us_screen.dart';
import 'package:astrovedham/features/horoscope/presentation/screens/horoscope_screen.dart';
import 'package:astrovedham/features/horoscope/presentation/screens/horoscope_input_screen.dart';
import 'package:astrovedham/features/horoscope/presentation/screens/horoscope_result_screen.dart'
    as daily;
import 'package:astrovedham/features/horoscope/presentation/screens/pdf_viewer_screen.dart';
import 'package:astrovedham/features/horoscope/presentation/screens/service_info_screen.dart';
import 'package:astrovedham/features/horoscope/presentation/screens/service_form_screen.dart';
import 'package:astrovedham/features/horoscope/presentation/screens/review_details_screen.dart';
import 'package:astrovedham/features/orders/presentation/screens/order_detail_screen.dart';
import 'package:astrovedham/features/consultation/presentation/screens/consultation_form_screen.dart';
import 'package:astrovedham/features/consultation/presentation/screens/consultation_info_screen.dart';
import 'package:astrovedham/features/auth/presentation/screens/login_screen.dart';
import 'package:astrovedham/features/auth/presentation/screens/register_screen.dart';
import 'package:astrovedham/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:astrovedham/features/horoscope/data/horoscope_reports.dart';
import 'package:astrovedham/models/order.dart';
import 'package:astrovedham/core/utils/service_visual_helper.dart';
import 'package:astrovedham/core/config/api_config.dart';
import 'package:astrovedham/features/horoscope/presentation/screens/webview_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  AppRoutes._();

  static const String initial = '/';
  static const String splash = '/splash';
  static const String languageSelection = '/language-selection';
  static const String root = '/home';
  static const String horoscopeGenerator = '/horoscope-generator';
  static const String horoscopeReview = '/horoscope-review';
  static const String horoscopeResult = '/horoscope-result';
  static const String orders = '/orders';
  static const String cancelledOrders = '/cancelled-orders';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String about = '/about';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String legalPrivacy = '/legal-privacy';
  static const String contactUs = '/contact-us';
  static const String horoscope = '/horoscope';
  static const String horoscopeInput = '/horoscope-input';
  static const String dailyHoroscopeResult = '/daily-horoscope-result';
  static const String orderPdf = '/order-pdf';
  static const String serviceInfo = '/service-info';
  static const String serviceForm = '/service-form';
  static const String reviewDetails = '/review-details';
  static const String pdfViewer = '/pdf-viewer';
  static const String orderDetail = '/order-detail';
  static const String consultationInfo = '/consultation-info';
  static const String consultationForm = '/consultation-form';
  static const String webview = '/webview';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static Map<String, WidgetBuilder> get routes {
    return {
      initial: (context) => const SplashScreen(),
      splash: (context) => const SplashScreen(),
      languageSelection: (context) => const LanguageSelectionScreen(),
      root: (context) {
        final initialIndex = ModalRoute.of(context)?.settings.arguments as int? ?? 0;
        return MainNavigationScreen(initialIndex: initialIndex);
      },
      horoscopeGenerator: (context) {
        final service =
            ModalRoute.of(context)?.settings.arguments as HoroscopeService?;
        return HoroscopeGeneratorScreen(service: service);
      },
      horoscopeReview: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return HoroscopeReviewScreen(
          service: args?['service'] as HoroscopeService,
          data: args?['data'],
        );
      },
      horoscopeResult: (context) {
        final service =
            ModalRoute.of(context)?.settings.arguments as HoroscopeService;
        return HoroscopeResultScreen(service: service);
      },
      orders: (context) => const OrdersScreen(),
      cancelledOrders: (context) => const CancelledOrdersScreen(),
      settings: (context) => const SettingsScreen(),
      profile: (context) => const ProfileScreen(),
      about: (context) => const AboutAstroVedhamScreen(),
      privacyPolicy: (context) => const PrivacyPolicyScreen(),
      termsAndConditions: (context) => const TermsAndConditionsScreen(),
      legalPrivacy: (context) => const LegalPrivacyScreen(),
      contactUs: (context) => const ContactUsScreen(),
      horoscope: (context) => const HoroscopeScreen(),
      horoscopeInput: (context) => const HoroscopeInputScreen(),
      dailyHoroscopeResult: (context) => const daily.HoroscopeResultScreen(),
      orderPdf: (context) {
        final order = ModalRoute.of(context)?.settings.arguments as OrderModel;
        final serviceVisual = ServiceVisualHelper.fromOrder(order);
        return PdfViewerScreen(
          pdfUrl: order.pdfUrl ?? '',
          title: serviceVisual.localizedTitle,
          orderNumber: order.orderNumber,
        );
      },
      serviceInfo: (context) {
        final service =
            ModalRoute.of(context)?.settings.arguments as HoroscopeService;
        return ServiceInfoScreen(service: service);
      },
      serviceForm: (context) {
        final service =
            ModalRoute.of(context)?.settings.arguments as HoroscopeService;
        return ServiceFormScreen(service: service);
      },
      reviewDetails: (context) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        return ReviewDetailsScreen(
          service: args['service'] as HoroscopeService,
          formData: args['formData'],
        );
      },
      webview: (context) {
        final rawArgs = ModalRoute.of(context)?.settings.arguments;
        String url = ApiConfig.orderWebPageUrl;
        String? title;
        String? expectedOrderId;

        if (rawArgs is String && rawArgs.isNotEmpty) {
          url = rawArgs;
        } else if (rawArgs is Map) {
          url = rawArgs['url']?.toString() ??
              rawArgs['payment_link']?.toString() ??
              rawArgs['paymentLink']?.toString() ??
              rawArgs['link']?.toString() ??
              ApiConfig.orderWebPageUrl;
          title = rawArgs['title']?.toString();
          expectedOrderId = rawArgs['expectedOrderId']?.toString() ??
              rawArgs['order_id']?.toString() ??
              rawArgs['orderId']?.toString();
        }

        return WebViewScreen(
          url: url,
          title: title,
          expectedOrderId: expectedOrderId,
        );
      },
      pdfViewer: (context) {
        final report =
            ModalRoute.of(context)?.settings.arguments as HoroscopeReport;
        return PdfViewerScreen(pdfUrl: report.pdfUrl, title: report.title);
      },
      orderDetail: (context) {
        final orderNumber =
            ModalRoute.of(context)?.settings.arguments as String;
        return OrderDetailScreen(orderNumber: orderNumber);
      },
      consultationInfo: (context) {
        final service =
            ModalRoute.of(context)?.settings.arguments as HoroscopeService;
        return ConsultationInfoScreen(service: service);
      },
      consultationForm: (context) {
        final service =
            ModalRoute.of(context)?.settings.arguments as HoroscopeService;
        return ConsultationFormScreen(service: service);
      },
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case initial:
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: routeSettings,
        );
      case languageSelection:
        return MaterialPageRoute(
          builder: (_) => const LanguageSelectionScreen(),
          settings: routeSettings,
        );
      case root:
        final initialIndex = routeSettings.arguments as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) => MainNavigationScreen(initialIndex: initialIndex),
          settings: routeSettings,
        );
      case horoscopeGenerator:
        final service = routeSettings.arguments as HoroscopeService?;
        return MaterialPageRoute(
          builder: (_) => HoroscopeGeneratorScreen(service: service),
          settings: routeSettings,
        );
      case horoscopeReview:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => HoroscopeReviewScreen(
            service: args?['service'] as HoroscopeService,
            data: args?['data'],
          ),
          settings: routeSettings,
        );
      case horoscopeResult:
        final service = routeSettings.arguments as HoroscopeService;
        return MaterialPageRoute(
          builder: (_) => HoroscopeResultScreen(service: service),
          settings: routeSettings,
        );
      case orders:
        return MaterialPageRoute(
          builder: (_) => const OrdersScreen(),
          settings: routeSettings,
        );
      case cancelledOrders:
        return MaterialPageRoute(
          builder: (_) => const CancelledOrdersScreen(),
          settings: routeSettings,
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: routeSettings,
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: routeSettings,
        );
      case about:
        return MaterialPageRoute(
          builder: (_) => const AboutAstroVedhamScreen(),
          settings: routeSettings,
        );
      case privacyPolicy:
        return MaterialPageRoute(
          builder: (_) => const PrivacyPolicyScreen(),
          settings: routeSettings,
        );
      case termsAndConditions:
        return MaterialPageRoute(
          builder: (_) => const TermsAndConditionsScreen(),
          settings: routeSettings,
        );
      case legalPrivacy:
        return MaterialPageRoute(
          builder: (_) => const LegalPrivacyScreen(),
          settings: routeSettings,
        );
      case contactUs:
        return MaterialPageRoute(
          builder: (_) => const ContactUsScreen(),
          settings: routeSettings,
        );
      case horoscope:
        return MaterialPageRoute(
          builder: (_) => const HoroscopeScreen(),
          settings: routeSettings,
        );
      case horoscopeInput:
        return MaterialPageRoute(
          builder: (_) => const HoroscopeInputScreen(),
          settings: routeSettings,
        );
      case dailyHoroscopeResult:
        return MaterialPageRoute(
          builder: (_) => const daily.HoroscopeResultScreen(),
          settings: routeSettings,
        );
      case orderPdf:
        final order = routeSettings.arguments as OrderModel;
        final serviceVisual = ServiceVisualHelper.fromOrder(order);
        return MaterialPageRoute(
          builder: (_) => PdfViewerScreen(
            pdfUrl: order.pdfUrl ?? '',
            title: serviceVisual.localizedTitle,
            orderNumber: order.orderNumber,
          ),
          settings: routeSettings,
        );
      case serviceInfo:
        final service = routeSettings.arguments as HoroscopeService;
        return MaterialPageRoute(
          builder: (_) => ServiceInfoScreen(service: service),
          settings: routeSettings,
        );
      case serviceForm:
        final service = routeSettings.arguments as HoroscopeService;
        return MaterialPageRoute(
          builder: (_) => ServiceFormScreen(service: service),
          settings: routeSettings,
        );
      case reviewDetails:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ReviewDetailsScreen(
            service: args['service'] as HoroscopeService,
            formData: args['formData'],
          ),
          settings: routeSettings,
        );
      case pdfViewer:
        final report = routeSettings.arguments as HoroscopeReport;
        return MaterialPageRoute(
          builder: (_) =>
              PdfViewerScreen(pdfUrl: report.pdfUrl, title: report.title),
          settings: routeSettings,
        );
      case orderDetail:
        final orderNumber = routeSettings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(orderNumber: orderNumber),
          settings: routeSettings,
        );
      case consultationInfo:
        final service = routeSettings.arguments as HoroscopeService;
        return MaterialPageRoute(
          builder: (_) => ConsultationInfoScreen(service: service),
          settings: routeSettings,
        );
      case consultationForm:
        final service = routeSettings.arguments as HoroscopeService;
        return MaterialPageRoute(
          builder: (_) => ConsultationFormScreen(service: service),
          settings: routeSettings,
        );
      case webview:
        final rawArgs = routeSettings.arguments;
        String url = ApiConfig.orderWebPageUrl;
        String? title;
        String? expectedOrderId;

        if (rawArgs is String && rawArgs.isNotEmpty) {
          url = rawArgs;
        } else if (rawArgs is Map) {
          url = rawArgs['url']?.toString() ??
              rawArgs['payment_link']?.toString() ??
              rawArgs['paymentLink']?.toString() ??
              rawArgs['link']?.toString() ??
              ApiConfig.orderWebPageUrl;
          title = rawArgs['title']?.toString();
          expectedOrderId = rawArgs['expectedOrderId']?.toString() ??
              rawArgs['order_id']?.toString() ??
              rawArgs['orderId']?.toString();
        }

        return MaterialPageRoute(
          builder: (_) => WebViewScreen(
            url: url,
            title: title,
            expectedOrderId: expectedOrderId,
          ),
          settings: routeSettings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: routeSettings,
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: routeSettings,
        );
      case forgotPassword:
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
          settings: routeSettings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'errors.no_route'.tr(args: [routeSettings.name ?? 'unknown']),
              ),
            ),
          ),
          settings: routeSettings,
        );
    }
  }
}
