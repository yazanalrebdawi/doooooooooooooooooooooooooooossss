

import 'package:dooss_business_app/features/auth/data/models/user_model.dart';
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
    }) => 
        AuthResponceModel(
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
    final accessToken = map['access'] ?? '';
    final tokenField = map['token'] ?? '';
    final finalToken = accessToken.isNotEmpty ? accessToken : tokenField;
    
    // استخراج الـ refresh token
    final refreshToken = map['refresh'] ?? '';
    
    // حساب تاريخ انتهاء الصلاحية (افتراضياً ساعة واحدة من الآن)
    final expiry = DateTime.now().add(const Duration(hours: 1));
    
    print('🔍 AuthResponceModel - Raw map keys: ${map.keys.toList()}');
    print('🔍 AuthResponceModel - Access token: $accessToken');
    print('🔍 AuthResponceModel - Token field: $tokenField');
    print('🔍 AuthResponceModel - Final token: $finalToken');
    print('🔍 AuthResponceModel - Token length: ${finalToken.length}');
    print('🔍 AuthResponceModel - Refresh token: $refreshToken');
    print('🔍 AuthResponceModel - Expiry: $expiry');
    
    // حفظ الـ tokens تلقائياً
    if (finalToken.isNotEmpty) {
      TokenService.saveAllTokens(
        accessToken: finalToken,
        refreshToken: refreshToken.isNotEmpty ? refreshToken : finalToken, // استخدام نفس الـ token كـ refresh إذا لم يتم إرسال واحد
        expiry: expiry,
      );
      print('💾 AuthResponceModel - Tokens saved automatically');
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
