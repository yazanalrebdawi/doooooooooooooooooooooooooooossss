import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../services/token_service.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';

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
        },
      ),
    );

    // Configure HTTP adapter
    _dio.httpClientAdapter = IOHttpClientAdapter()
      ..onHttpClientCreate = (client) {
        client.maxConnectionsPerHost = 6;
        client.connectionTimeout = const Duration(seconds: 15);
        return client;
      };

    _addHeaderToDio();
    _addLogger();
    _addTokenInterceptor();
    _addCacheInterceptor();
  }

  // ---------------------------------------------------------------------------
  // 🌍 Configuration & Setup
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
        filter: (options, args) {
          // Example: skip certain logs if needed
          if (options.path.contains('/posts')) return false;
          return !args.isResponse || !args.hasUint8ListData;
        },
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
            '/dealers/login/',
          ];

          final isAuthEndpoint =
              authEndpoints.any((endpoint) => options.path.contains(endpoint));

          if (!isAuthEndpoint) {
            final isTokenValid = await AuthService.refreshTokenIfNeeded();
            final token = await TokenService.getToken();

            print('🔍 Interceptor: Token valid? $isTokenValid');
            print('🔍 Interceptor: Current token: $token');

            if (token != null && token.isNotEmpty && isTokenValid) {
              options.headers['Authorization'] = 'Bearer $token';
              print('✅ Token attached to request');
            } else {
              print('⚠️ No valid token available');
            }
          } else {
            print('🔓 Auth endpoint, skipping token attachment');
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle timeout
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            print('⏰ Timeout error: ${error.message}');
            print('🔄 Retrying request once...');
            if (error.requestOptions.extra['retry'] != true) {
              error.requestOptions.extra['retry'] = true;
              try {
                final response = await _dio.fetch(error.requestOptions);
                handler.resolve(response);
                return;
              } catch (retryError) {
                print('❌ Retry failed: $retryError');
              }
            }
          }

          // Handle 401 (expired token)
          if (error.response?.statusCode == 401) {
            print('🚨 Token expired - trying to refresh...');
            final refreshSuccess = await AuthService.refreshToken();

            if (refreshSuccess) {
              print('✅ Token refreshed successfully');
              final newToken = await TokenService.getToken();
              if (newToken != null && newToken.isNotEmpty) {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newToken';
                try {
                  final response = await _dio.fetch(error.requestOptions);
                  handler.resolve(response);
                  return;
                } catch (retryError) {
                  print('❌ Retried request failed: $retryError');
                }
              }
            } else {
              print('❌ Token refresh failed, clearing session');
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
        onResponse: (response, handler) {
          if (response.statusCode == 200) {
            print(
                '✅ Network: ${response.requestOptions.method} ${response.requestOptions.path} - ${response.statusCode}');
          }
          handler.next(response);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 📦 Accessor
  // ---------------------------------------------------------------------------

  Dio get dio => _dio;
}
