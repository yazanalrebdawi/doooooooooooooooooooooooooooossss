import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../network/api.dart';
import '../network/api_request.dart';
import '../network/api_urls.dart';
import '../network/failure.dart';
import 'token_service.dart';

class AuthService {
  
  /// التحقق من وجود token صالح
  static Future<bool> isAuthenticated() async {
    return await TokenService.hasToken();
  }

  /// الحصول على الـ token الحالي
  static Future<String?> getCurrentToken() async {
    return await TokenService.getToken();
  }

  /// تسجيل الخروج وحذف جميع بيانات المصادقة
  static Future<void> logout() async {
    await TokenService.clearToken();
  }

  /// التحقق من صلاحية الـ token
  static Future<bool> isTokenValid() async {
    final token = await TokenService.getToken();
    if (token == null || token.isEmpty) {
      return false;
    }
    
    // التحقق من انتهاء صلاحية الـ token
    final isExpired = await TokenService.isTokenExpired();
    if (isExpired) {
      print('⚠️ Token is expired, attempting to refresh...');
      return await refreshToken();
    }
    
    return true;
  }

  /// تجديد الـ token تلقائياً
  static Future<bool> refreshToken() async {
    try {
      final refreshToken = await TokenService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        print('❌ No refresh token available, redirecting to login');
        await TokenService.clearToken();
        return false;
      }

      print('🔄 Attempting to refresh token...');
      
      // إنشاء Dio instance بدون interceptor لتجنب loop
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
      ));
      
      final api = API(dio: dio);
      
      final response = await api.post<Map<String, dynamic>>(
        apiRequest: ApiRequest(
          url: ApiUrls.refreshToken,
          data: {'refresh': refreshToken},
        ),
      );

      return response.fold(
        (failure) {
          print('❌ Token refresh failed: ${failure.message}');
          print('🔄 Redirecting to login screen...');
          // إذا فشل تجديد الـ token، نحذف جميع البيانات
          TokenService.clearToken();
          return false;
        },
        (data) async {
          print('✅ Token refresh successful');
          
          // استخراج الـ tokens الجديدة
          final newAccessToken = data['access'] ?? data['token'] ?? '';
          final newRefreshToken = data['refresh'] ?? refreshToken; // استخدام القديم إذا لم يتم إرسال واحد جديد
          
          if (newAccessToken.isNotEmpty) {
            // حساب تاريخ انتهاء الصلاحية (افتراضياً ساعة واحدة)
            final expiry = DateTime.now().add(const Duration(hours: 1));
            
            // حفظ الـ tokens الجديدة
            await TokenService.saveAllTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
              expiry: expiry,
            );
            
            print('💾 New tokens saved successfully');
            return true;
          } else {
            print('❌ No access token in refresh response, redirecting to login');
            await TokenService.clearToken();
            return false;
          }
        },
      );
    } catch (e) {
      print('❌ Token refresh error: $e');
      print('🔄 Redirecting to login screen...');
      await TokenService.clearToken();
      return false;
    }
  }

  /// تجديد الـ token إذا كان منتهي الصلاحية
  static Future<bool> refreshTokenIfNeeded() async {
    final isExpired = await TokenService.isTokenExpired();
    if (isExpired) {
      return await refreshToken();
    }
    return true;
  }

  /// التحقق من وجود refresh endpoint (اختياري)
  static Future<bool> hasRefreshEndpoint() async {
    try {
      // محاولة الوصول للـ refresh endpoint للتحقق من وجوده
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 5), // timeout قصير للاختبار
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ));
      
      final response = await dio.get(ApiUrls.refreshToken);
      return response.statusCode != 404; // إذا لم يكن 404، فالمدخل موجود
    } catch (e) {
      print('⚠️ Refresh endpoint not available: $e');
      return false;
    }
  }
} 