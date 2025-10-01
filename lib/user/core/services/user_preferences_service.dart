import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService{

 static const String _userKey = 'user_data';

  /// حفظ بيانات المستخدم
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
  
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userData.toString());
  }

  /// استرجاع بيانات المستخدم
  static Future<Map<String, dynamic>?> getUserData() async {

    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);

    if (userDataString != null) {
      // تحويل الـ string إلى Map (هذا مثال بسيط)
      return {'user_data': userDataString};
    }
    return null;
  }

  /// حذف جميع بيانات المصادقة
   static Future<void> clearAuthData() async {
   

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }


}