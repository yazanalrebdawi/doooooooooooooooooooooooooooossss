import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../services/token_service.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../services/translation/translation_service.dart';

class AppDio {
  // ✅ Singleton instance
  static final AppDio _instance = AppDio._internal();
  late Dio _dio;

  // ✅ Factory constructor ensures one instance only
  factory AppDio() => _instance;

  // ✅ Private constructor
  AppDio._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
        headers: {
          'Accept-Encoding': 'gzip, deflate, br',
          // اللغة الافتراضية مؤقتًا لحد ما نحملها فعلياً من التخزين
          'Accept-Language': 'ar',
        },
      ),
    );

    // إعدادات أخرى
    _addHeaderToDio();
    _addLogger();
    _addTokenInterceptor();
    _addCacheInterceptor();
  }

  // ---------------------------------------------------------------------------
  // 🌍 Initialize Language Dynamically
  // ---------------------------------------------------------------------------
  Future<void> init() async {
    try {
      final savedLang =
          await appLocator<TranslationService>().getSavedLocaleService();

      final languageCode = savedLang ?? 'ar'; // افتراضي عربي إذا ما في شيء محفوظ
      _dio.options.headers['Accept-Language'] = languageCode;

      print('🌐 Language initialized in Dio: $languageCode');
    } catch (e) {
      print('⚠️ Failed to initialize language: $e');
      _dio.options.headers['Accept-Language'] = 'ar';
    }
  }

  // ---------------------------------------------------------------------------
  // 🔧 Setup & Config
  // ---------------------------------------------------------------------------

  _addHeaderToDio() {
    _dio.options.headers = {};
  }

  void addTokenToHeader(String token) {
    _dio.options.headers["Authorization"] = "Bearer $token";
    print('✅ Token added to Dio header');
  }

  _addLogger() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: true,
      ),
    );
  }

  _addTokenInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final authEndpoints = [
            '/users/login/',
            '/users/register/',
            '/users/forgot-password/',
            '/users/verify-forget-password/',
            '/users/reset-password/',
            '/users/request-otp/',
            '/users/resend-otp/',
            '/users/verify/',
            '/users/refresh/',
            '/users/logout/',
            '/dealers/login/',
          ];

          final isAuthEndpoint =
              authEndpoints.any((endpoint) => options.path.contains(endpoint) || options.uri.path.contains(endpoint));

          // For logout endpoint, we need the access token in the header
          // So we don't treat it as an auth endpoint (to add the token)
          final isLogoutEndpoint = options.path.contains('/users/logout/') || options.uri.path.contains('/users/logout/');

          if (!isAuthEndpoint || isLogoutEndpoint) {
            final isTokenValid = await AuthService.refreshTokenIfNeeded();
            final token = await TokenService.getToken();

            if (token != null && token.isNotEmpty && isTokenValid) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshSuccess = await AuthService.refreshToken();

            if (refreshSuccess) {
              final newToken = await TokenService.getToken();
              if (newToken != null && newToken.isNotEmpty) {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                final response = await _dio.fetch(error.requestOptions);
                handler.resolve(response);
                return;
              }
            } else {
              await TokenService.clearToken();
              NavigationService.navigateToLoginFromAnywhere();
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  _addCacheInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.method.toUpperCase() == 'GET') {
            options.headers['Cache-Control'] = 'max-age=300'; // 5 min cache
          }
          handler.next(options);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 📦 Accessor
  // ---------------------------------------------------------------------------
  Dio get dio => _dio;
}
