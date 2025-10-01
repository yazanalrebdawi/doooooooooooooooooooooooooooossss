import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  /// Navigate to login screen
  static void navigateToLogin(BuildContext context) {
    context.go('/login');
  }
  
  /// Navigate to home screen
  static void navigateToHome(BuildContext context) {
    context.go('/home');
  }
  
  /// Navigate to login from anywhere in the app
  static void navigateToLoginFromAnywhere() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.go('/login');
    }
  }
  
  /// Clear stack and navigate to login
  static void clearStackAndNavigateToLogin(BuildContext context) {
    context.go('/login');
  }
}
