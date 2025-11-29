import 'dart:developer';

import 'package:dooss_business_app/user/features/auth/data/models/user_model.dart';
import '../../../../core/services/token_service.dart';

class AuthResponceModel {
  final String message;
  final UserModel user;
  final String token;
  final String? refreshToken;
  final DateTime? expiry;

  AuthResponceModel({
    required this.message,
    required this.user,
    required this.token,
    this.refreshToken,
    this.expiry,
  });

  AuthResponceModel copyWith({
    String? message,
    UserModel? user,
    String? token,
    String? refreshToken,
    DateTime? expiry,
  }) => AuthResponceModel(
    message: message ?? this.message,
    user: user ?? this.user,
    token: token ?? this.token,
    refreshToken: refreshToken ?? this.refreshToken,
    expiry: expiry ?? this.expiry,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'message': message,
      'user': user.toJson(),
      'token': token,
      'refresh_token': refreshToken,
      'expiry': expiry?.toIso8601String(),
    };
  }

  factory AuthResponceModel.fromJson(Map<String, dynamic> map) {
    // Extract access token with proper type checking
    String accessToken = '';
    if (map['access'] != null) {
      if (map['access'] is String) {
        accessToken = map['access'] as String;
      } else {
        log('⚠️ AuthResponceModel - access token is not a String, type: ${map['access'].runtimeType}');
        accessToken = map['access'].toString();
      }
    }
    
    // Extract token field with proper type checking
    String tokenField = '';
    if (map['token'] != null) {
      if (map['token'] is String) {
        tokenField = map['token'] as String;
      } else {
        log('⚠️ AuthResponceModel - token field is not a String, type: ${map['token'].runtimeType}');
        tokenField = map['token'].toString();
      }
    }
    
    final finalToken = accessToken.isNotEmpty ? accessToken : tokenField;

    // استخراج الـ refresh token with proper type checking
    String refreshToken = '';
    if (map['refresh'] != null) {
      if (map['refresh'] is String) {
        refreshToken = map['refresh'] as String;
      } else {
        log('⚠️ AuthResponceModel - refresh token is not a String, type: ${map['refresh'].runtimeType}');
        refreshToken = map['refresh'].toString();
      }
    }

    // حساب تاريخ انتهاء الصلاحية (افتراضياً ساعة واحدة من الآن)
    final expiry = DateTime.now().add(const Duration(hours: 1));

    log('🔍 AuthResponceModel - Raw map keys: ${map.keys.toList()}');
    log('🔍 AuthResponceModel - Access token: $accessToken');
    log('🔍 AuthResponceModel - Token field: $tokenField');
    log('🔍 AuthResponceModel - Final token: $finalToken');
    log('🔍 AuthResponceModel - Token length: ${finalToken.length}');
    log('🔍 AuthResponceModel - Refresh token: $refreshToken');
    log('🔍 AuthResponceModel - Refresh token length: ${refreshToken.length}');
    log('🔍 AuthResponceModel - Expiry: $expiry');

    // Validate that refresh token is different from access token
    if (refreshToken.isNotEmpty && refreshToken == finalToken) {
      log('⚠️ AuthResponceModel - WARNING: Refresh token is the same as access token!');
    }

    // حفظ الـ tokens تلقائياً
    // IMPORTANT: Only save if we have a valid refresh token, don't fallback to access token
    if (finalToken.isNotEmpty) {
      if (refreshToken.isEmpty) {
        log('❌ AuthResponceModel - ERROR: No refresh token in response! Cannot save tokens.');
      } else {
        TokenService.saveAllTokens(
          accessToken: finalToken,
          refreshToken: refreshToken, // Use refresh token directly, no fallback
          expiry: expiry,
        );
        log('💾 AuthResponceModel - Tokens saved automatically');
        log('💾 AuthResponceModel - Access token saved: ${finalToken.substring(0, finalToken.length > 20 ? 20 : finalToken.length)}...');
        log('💾 AuthResponceModel - Refresh token saved: ${refreshToken.substring(0, refreshToken.length > 20 ? 20 : refreshToken.length)}...');
      }
    }

    return AuthResponceModel(
      message: map['message'] ?? '',
      user: UserModel.fromJson(map['user'] ?? {}),
      token: finalToken,
      refreshToken: refreshToken.isNotEmpty ? refreshToken : finalToken,
      expiry: expiry,
    );
  }
}
