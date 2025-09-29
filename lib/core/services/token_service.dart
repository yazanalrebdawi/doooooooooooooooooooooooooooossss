import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _accessTokenKey = 'access_token';
  static const String _userId = 'user-id';

  /// حفظ الـ token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// حفظ الـ refresh token
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }
  static Future<void> saveUserId(String id) async {
    await _storage.write(key: _userId, value: id);
  }

  /// حفظ تاريخ انتهاء صلاحية الـ token
  static Future<void> saveTokenExpiry(DateTime expiry) async {
    await _storage.write(key: _tokenExpiryKey, value: expiry.millisecondsSinceEpoch.toString());
  }

  /// استرجاع الـ token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userId);
  }

  /// استرجاع الـ refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// استرجاع تاريخ انتهاء صلاحية الـ token
  static Future<DateTime?> getTokenExpiry() async {
    final expiryString = await _storage.read(key: _tokenExpiryKey);
    if (expiryString != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(expiryString));
    }
    return null;
  }

  /// حذف الـ token
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
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
    await saveToken(accessToken);
    await saveRefreshToken(refreshToken);
    await saveTokenExpiry(expiry);
  }

  // Methods for Chat System
  static Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  static Future<void> setAccessToken(String token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
    } catch (e) {
      print('Error setting access token: $e');
    }
  }

  static Future<void> clearAccessToken() async {
    try {
      await _storage.delete(key: _accessTokenKey);
    } catch (e) {
      print('Error clearing access token: $e');
    }
  }
}
