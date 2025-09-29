import 'dart:developer';

import 'package:dooss_business_app/core/constants/cache_keys.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  // static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static final FlutterSecureStorage _storage =
      appLocator<FlutterSecureStorage>();

  /// حفظ الـ token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: CacheKeys.tokenKey, value: token);
  }

  /// حفظ الـ refresh token
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: CacheKeys.refreshTokenKey, value: refreshToken);
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
    return await _storage.read(key: CacheKeys.refreshTokenKey);
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
    await saveToken(accessToken);
    await saveRefreshToken(refreshToken);
    await saveTokenExpiry(expiry);
  }

  // Methods for Chat System
  static Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: CacheKeys.accessTokenKey);
    } catch (e) {
      log('Error getting access token: $e');
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
