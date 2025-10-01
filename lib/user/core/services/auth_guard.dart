import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_service.dart';
import '../routes/route_names.dart';

class AuthGuard {
  /// التحقق من المصادقة قبل الوصول للصفحة
  static Future<bool> canAccess(BuildContext context, String routeName) async {
    final isAuthenticated = await AuthService.isAuthenticated();
    
    // الصفحات التي لا تحتاج مصادقة
    final publicRoutes = [
      RouteNames.selectAppTypeScreen,
      RouteNames.loginScreen,
      RouteNames.rigesterScreen,
      RouteNames.forgetPasswordPage,
      RouteNames.verifyForgetPasswordPage,
      RouteNames.createNewPasswordPage,
    ];
    
    // إذا كانت الصفحة عامة، السماح بالوصول
    if (publicRoutes.contains(routeName)) {
      return true;
    }
    
    // إذا لم يكن المستخدم مصادق عليه، الانتقال لصفحة تسجيل الدخول
    if (!isAuthenticated) {
      if (context.mounted) {
        context.go(RouteNames.loginScreen);
      }
      return false;
    }
    
    return true;
  }
  
  /// التحقق من المصادقة للصفحات المحمية
  static Future<bool> requireAuth(BuildContext context) async {
    final isAuthenticated = await AuthService.isAuthenticated();
    
    if (!isAuthenticated) {
      if (context.mounted) {
        context.go(RouteNames.loginScreen);
      }
      return false;
    }
    
    return true;
  }
  
  /// التحقق من عدم المصادقة للصفحات العامة (مثل تسجيل الدخول)
  static Future<bool> requireNoAuth(BuildContext context) async {
    final isAuthenticated = await AuthService.isAuthenticated();
    
    if (isAuthenticated) {
      if (context.mounted) {
        context.go(RouteNames.homeScreen);
      }
      return false;
    }
    
    return true;
  }
} 