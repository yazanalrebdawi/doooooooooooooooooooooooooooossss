import 'package:dooss_business_app/core/app/source/local/app_manager_local_data_source.dart';
import 'package:dooss_business_app/core/services/storage/hivi/hive_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/features/auth/data/models/auth_response_model.dart';

class AppManagerLocalDataSourceImpl implements AppManagerLocalDataSource {
  final SharedPreferencesService sharedPreferenc;
  final SecureStorageService secureStorage;
  final HiveService hive;

  AppManagerLocalDataSourceImpl({
    required this.sharedPreferenc,
    required this.secureStorage,
    required this.hive,
  });

  //?----------------------------------------------------------
  /// 🔐 استرجاع كامل بيانات اليوزر من الـ SecureStorage
  @override
  Future<AuthResponceModel?> getFullUser() async {
    try {
      final authModel = await secureStorage.getAuthModel();
      return authModel;
    } catch (e) {
      return null;
    }
  }

  //?----------------------------------------------------------
  /// 💾 حفظ كامل بيانات اليوزر (حساس )
  @override
  Future<void> saveFullUser(AuthResponceModel authModel) async {
    try {
      // 🔐 تخزين آمن للموديل بالكامل
      await secureStorage.saveAuthModel(authModel);
    } catch (_) {
      rethrow; // أو يمكنك إرجاع Failure حسب طبقة الـ Repository
    }
  }

  //?----------------------------------------------------------
}
