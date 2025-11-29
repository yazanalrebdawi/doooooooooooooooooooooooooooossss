import 'dart:convert';
import 'dart:developer';
import 'package:dooss_business_app/user/core/constants/cache_keys.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static final FlutterSecureStorage _storage =
      appLocator<FlutterSecureStorage>();

  /// حفظ الـ token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: CacheKeys.tokenKey, value: token);
  }

  /// حفظ userId
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: CacheKeys.userIdKey, value: userId);
  }

  /// استرجاع userId
  static Future<String?> getUserId() async {
    try {
      String? userId = await _storage.read(key: CacheKeys.userIdKey);
      
      // If userId is null, try to get it from dealer auth data
      if (userId == null) {
        log('⚠️ TokenService - User ID not found in storage, checking dealer auth data...');
        final secureStorage = appLocator<SecureStorageService>();
        final sharedPrefsService = appLocator<SharedPreferencesService>();
        
        bool isDealer = await secureStorage.getIsDealer();
        if (isDealer) {
          // Try SharedPreferences first
          final dealerData = await sharedPrefsService.getDealerAuthData();
          if (dealerData != null) {
            userId = dealerData.user.id.toString();
            log('✅ TokenService - Found dealer user ID from SharedPreferences: $userId');
            // Save it for future use
            await saveUserId(userId);
            return userId;
          }
          
          // Try SecureStorage
          final dealerDataSecure = await secureStorage.getDealerAuthData();
          if (dealerDataSecure != null) {
            userId = dealerDataSecure.user.id.toString();
            log('✅ TokenService - Found dealer user ID from SecureStorage: $userId');
            // Save it for future use
            await saveUserId(userId);
            return userId;
          }
        }
        
        // Last resort: try to extract from JWT token
        final accessToken = await getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          userId = _extractUserIdFromToken(accessToken);
          if (userId != null) {
            log('✅ TokenService - Extracted user ID from JWT token: $userId');
            // Save it for future use
            await saveUserId(userId);
            return userId;
          }
        }
      }
      
      return userId;
    } catch (e) {
      log('Error getting userId: $e');
      return null;
    }
  }
  
  /// Extract user ID from JWT token
  static String? _extractUserIdFromToken(String token) {
    try {
      // JWT tokens have format: header.payload.signature
      final parts = token.split('.');
      if (parts.length != 3) {
        log('⚠️ TokenService - Invalid JWT token format');
        return null;
      }
      
      // Decode the payload (second part)
      final payload = parts[1];
      // Add padding if needed
      String normalizedPayload = payload;
      switch (payload.length % 4) {
        case 1:
          normalizedPayload += '===';
          break;
        case 2:
          normalizedPayload += '==';
          break;
        case 3:
          normalizedPayload += '=';
          break;
      }
      
      // Decode base64
      final decodedBytes = base64Url.decode(normalizedPayload);
      final decodedString = utf8.decode(decodedBytes);
      final payloadMap = jsonDecode(decodedString) as Map<String, dynamic>;
      
      // Extract user_id
      final userId = payloadMap['user_id']?.toString();
      return userId;
    } catch (e) {
      log('⚠️ TokenService - Error extracting user ID from token: $e');
      return null;
    }
  }

  /// حذف userId
  static Future<void> deleteUserId() async {
    await _storage.delete(key: CacheKeys.userIdKey);
  }

  /// حفظ الـ refresh token
  static Future<void> saveRefreshToken(String refreshToken) async {
    log('💾 TokenService - Saving refresh token, length: ${refreshToken.length}');
    log('💾 TokenService - Refresh token preview: ${refreshToken.length > 20 ? "${refreshToken.substring(0, 20)}..." : refreshToken}');
    await _storage.write(key: CacheKeys.refreshTokenKey, value: refreshToken);
    
    // Verify it was saved correctly
    final saved = await _storage.read(key: CacheKeys.refreshTokenKey);
    if (saved == refreshToken) {
      log('✅ TokenService - Refresh token saved and verified correctly');
    } else {
      log('❌ TokenService - ERROR: Refresh token verification failed!');
    }
  }

  /// حفظ تاريخ انتهاء صلاحية الـ token
  static Future<void> saveTokenExpiry(DateTime expiry) async {
    await _storage.write(
      key: CacheKeys.tokenExpiryKey,
      value: expiry.millisecondsSinceEpoch.toString(),
    );
  }

  /// استرجاع الـ token
  static Future<String?> getToken() async {
    return await _storage.read(key: CacheKeys.tokenKey);
  }

  /// استرجاع الـ refresh token
  static Future<String?> getRefreshToken() async {
    try {
      final token = await _storage.read(key: CacheKeys.refreshTokenKey);
      if (token == null || token.isEmpty) {
        log('⚠️ TokenService - No refresh token found in storage');
        return null;
      }
      // Log token info for debugging
      log('🔍 TokenService - Refresh token retrieved, length: ${token.length}');
      log('🔍 TokenService - Refresh token preview: ${token.length > 20 ? "${token.substring(0, 20)}..." : token}');
      
      // Verify it's not the same as access token
      final accessToken = await getToken();
      if (accessToken != null && token == accessToken) {
        log('❌ TokenService - ERROR: Retrieved refresh token is the same as access token!');
      }
      
      return token;
    } catch (e) {
      log('❌ TokenService - Error getting refresh token: $e');
      return null;
    }
  }

  /// استرجاع تاريخ انتهاء صلاحية الـ token
  static Future<DateTime?> getTokenExpiry() async {
    final expiryString = await _storage.read(key: CacheKeys.tokenExpiryKey);
    if (expiryString != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(expiryString));
    }
    return null;
  }

  /// حذف الـ token
  static Future<void> deleteToken() async {
    await _storage.delete(key: CacheKeys.tokenKey);
  }

  /// التحقق من وجود token
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// التحقق من صلاحية الـ token
  static Future<bool> isTokenExpired() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true;

    // نعتبر الـ token منتهي الصلاحية قبل 5 دقائق من الوقت الفعلي
    final now = DateTime.now();
    final bufferTime = Duration(minutes: 5);
    return now.isAfter(expiry.subtract(bufferTime));
  }

  /// حذف جميع بيانات المصادقة
  static Future<void> clearToken() async {
    await _storage.deleteAll();
  }

  /// حفظ جميع بيانات الـ token
  static Future<void> saveAllTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime expiry,
  }) async {
    log('💾 TokenService - Saving all tokens');
    log('💾 TokenService - Access token length: ${accessToken.length}');
    log('💾 TokenService - Refresh token length: ${refreshToken.length}');
    
    await saveToken(accessToken);
    await saveRefreshToken(refreshToken);
    await saveTokenExpiry(expiry);
  }

  // Methods for Access Token (Chat System)
  // This method handles both regular users and dealers
  static Future<String?> getAccessToken() async {
    try {
      // First, try to get from regular token storage (CacheKeys.tokenKey)
      String? token = await _storage.read(key: CacheKeys.tokenKey);
      log('🔍 TokenService: Checking tokenKey (${CacheKeys.tokenKey}): ${token != null && token.isNotEmpty ? "${token.substring(0, token.length > 20 ? 20 : token.length)}..." : "null or empty"}');

      // If found and not empty, return it
      if (token != null && token.isNotEmpty) {
        log('✅ TokenService: Found access token from tokenKey');
        return token;
      }

      // Try to get from accessTokenKey (in case it was set via setAccessToken)
      token = await _storage.read(key: CacheKeys.accessTokenKey);
      log('🔍 TokenService: Checking accessTokenKey (${CacheKeys.accessTokenKey}): ${token != null && token.isNotEmpty ? "${token.substring(0, token.length > 20 ? 20 : token.length)}..." : "null or empty"}');
      if (token != null && token.isNotEmpty) {
        log('✅ TokenService: Found access token from accessTokenKey');
        return token;
      }

      // If not found, check if user is a dealer and get dealer token
      try {
        final secureStorage = appLocator<SecureStorageService>();
        final sharedPrefsService = appLocator<SharedPreferencesService>();

        // Check if user is a dealer (try both methods)
        bool isDealer = await secureStorage.getIsDealer();
        log('🔍 TokenService: isDealer check result: $isDealer');

        // Also check SharedPreferences for dealer flag
        if (!isDealer) {
          final dealerDataFromPrefs =
              await sharedPrefsService.getDealerAuthData();
          isDealer = dealerDataFromPrefs != null;
          log('🔍 TokenService: Dealer check from SharedPreferences: $isDealer');
        }

        // If dealer, try multiple sources
        if (isDealer) {
          log('⚠️ TokenService: Regular token not found, checking dealer token sources...');

          // 1. Try to get dealer token from SharedPreferences
          token = await sharedPrefsService.getDealerToken();
          if (token != null && token.isNotEmpty) {
            log('✅ TokenService: Found dealer access token from SharedPreferences.getDealerToken()');
            return token;
          }
          log('⚠️ TokenService: SharedPreferences.getDealerToken() returned: ${token ?? "null"}');

          // 2. Try to get from SharedPreferences dealer auth data directly
          final dealerDataFromPrefs =
              await sharedPrefsService.getDealerAuthData();
          if (dealerDataFromPrefs != null &&
              dealerDataFromPrefs.access.isNotEmpty) {
            token = dealerDataFromPrefs.access;
            log('✅ TokenService: Found dealer access token from SharedPreferences.getDealerAuthData()');
            return token;
          }
          log('⚠️ TokenService: SharedPreferences.getDealerAuthData() returned: ${dealerDataFromPrefs != null ? "data without access" : "null"}');

          // 3. Try to get from SecureStorage dealer auth data
          final dealerDataFromSecure = await secureStorage.getDealerAuthData();
          if (dealerDataFromSecure != null &&
              dealerDataFromSecure.access.isNotEmpty) {
            token = dealerDataFromSecure.access;
            log('✅ TokenService: Found dealer access token from SecureStorage.getDealerAuthData()');
            return token;
          }
          log('⚠️ TokenService: SecureStorage.getDealerAuthData() returned: ${dealerDataFromSecure != null ? "data without access" : "null"}');
        } else {
          log('⚠️ TokenService: User is not identified as dealer, skipping dealer token checks');
        }
      } catch (e, stackTrace) {
        log('⚠️ TokenService: Error checking dealer token: $e');
        log('⚠️ TokenService: Stack trace: $stackTrace');
      }

      log('❌ TokenService: No access token found in any location');
      return null;
    } catch (e) {
      log('❌ TokenService: Error getting access token: $e');
      return null;
    }
  }

  static Future<void> setAccessToken(String token) async {
    try {
      await _storage.write(key: CacheKeys.accessTokenKey, value: token);
    } catch (e) {
      log('Error setting access token: $e');
    }
  }

  static Future<void> clearAccessToken() async {
    try {
      await _storage.delete(key: CacheKeys.accessTokenKey);
    } catch (e) {
      log('Error clearing access token: $e');
    }
  }
}
