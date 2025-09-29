import 'dart:convert';
import 'package:dooss_business_app/core/constants/cache_keys.dart';
import 'package:dooss_business_app/features/auth/data/models/auth_response_model.dart';
import 'package:dooss_business_app/features/auth/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage storage;
  SecureStorageService({required this.storage});
  //?--------------------------------------------------------------------------

  /// 💾 حفظ كامل الـ AuthResponceModel
  Future<void> saveAuthModel(AuthResponceModel auth) async {
    try {
      final encoded = jsonEncode(auth.toJson());
      await storage.write(key: CacheKeys.sensitiveData, value: encoded);
    } catch (e) {
      rethrow;
    }
  }

  /// 📥 استرجاع كامل الـ AuthResponceModel
  Future<AuthResponceModel?> getAuthModel() async {
    try {
      final jsonString = await storage.read(key: CacheKeys.sensitiveData);
      if (jsonString == null) return null;

      final Map<String, dynamic> data = jsonDecode(jsonString);
      return AuthResponceModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// 🔄 تحديث معلومات المستخدم فقط (id / name / phone / role / verified)
  Future<void> updateUserDataModel({
    int? id,
    String? name,
    String? phone,
    String? role,
    bool? verified,
  }) async {
    try {
      final auth = await getAuthModel();
      if (auth == null) return;

      final updated = auth.copyWith(
        user: auth.user.copyWith(
          id: id ?? auth.user.id,
          name: name ?? auth.user.name,
          phone: phone ?? auth.user.phone,
          role: role ?? auth.user.role,
          verified: verified ?? auth.user.verified,
        ),
      );

      await saveAuthModel(updated);
    } catch (e) {
      rethrow;
    }
  }

  /// 🔄 تحديث الاسم ورقم الهاتف فقط
  /// 🔄 تحديث الاسم ورقم الهاتف (اختياري)
  Future<void> updateNameAndPhone({String? newName, String? newPhone}) async {
    final auth = await getAuthModel();
    if (auth == null) return;

    final updatedAuth = auth.copyWith(
      user: auth.user.copyWith(
        name: newName ?? auth.user.name,
        phone: newPhone ?? auth.user.phone,
      ),
    );

    await saveAuthModel(updatedAuth);
  }

  /// 🔄 تحديث كامل بيانات الـ UserModel فقط
  Future<void> updateUserModel({required UserModel newUser}) async {
    try {
      final auth = await getAuthModel();
      if (auth == null) return;

      // إنشاء نسخة جديدة من AuthResponceModel مع تحديث الـ user فقط
      final updatedAuth = auth.copyWith(user: newUser);

      await saveAuthModel(updatedAuth);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserModel() async {
    try {
      final auth = await getAuthModel();
      if (auth == null) return null;

      return auth.user; // ترجع نسخة المستخدم
    } catch (e) {
      rethrow;
    }
  }

  /// 🔄 تحديث الاسم ورقم الهاتف فقط
  /// 🔄 تحديث الاسم ورقم الهاتف (اختياري)
  Future<void> updateNameAndPhone1({String? newName, String? newPhone}) async {
    final auth = await getAuthModel();
    if (auth == null) return;

    final updatedAuth = auth.copyWith(
      user: auth.user.copyWith(
        name: newName ?? auth.user.name,
        phone: newPhone ?? auth.user.phone,
      ),
    );

    await saveAuthModel(updatedAuth);
  }

  /// 🗑️ حذف كامل البيانات
  Future<void> clearSensitiveData() async {
    try {
      await storage.delete(key: CacheKeys.sensitiveData);
    } catch (_) {}
  }

  Future<void> removeAll() async {
    try {
      await storage.deleteAll();
    } catch (_) {}
  }

  //?--------------------------------------------------------------------------
}
