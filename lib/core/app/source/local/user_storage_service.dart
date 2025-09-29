// import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
// import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
// import 'package:dooss_business_app/features/auth/data/models/user_model.dart';

// class UserStorageService {
//   final SecureStorageService secureStorage;
//   final SharedPreferencesService sharedPreference;

//   UserStorageService({
//     required this.secureStorage,
//     required this.sharedPreference,
//   });

//   /// Get all user data (sensitive + non-sensitive)
//   Future<Map<String, dynamic>?> getAllUserData() async {
//     try {
//       // 1️⃣ اقرأ الحساسة
//       final sensitive = await secureStorage.getSensitiveData();

//       // 2️⃣ اقرأ الغير حساسة
//       final nonSensitive = sharedPreference.getUserNonSensitiveData();

//       if (sensitive == null && nonSensitive == null) return null;

//       // 3️⃣ دمج الاثنين
//       return {...?sensitive, ...?nonSensitive};
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Convert to UserModel كامل (لو حابب)
//   Future<UserModel?> getUserModel() async {
//     final data = await getAllUserData();
//     if (data == null) return null;

//     try {
//       return UserModel(
//         id: data['id'],
//         name: data['name'],
//         phone: data['phone'],
//         role: data['role'],
//         verified: data['verified'],
//         latitude: data['latitude'],
//         longitude: data['longitude'],
//         createdAt: DateTime.parse(data['created_at']),
//       );
//     } catch (_) {
//       return null;
//     }
//   }

//   Future<String?> getToken() async {
//     try {
//       final sensitive = await secureStorage.getSensitiveData();
//       if (sensitive == null) return null;
//       return sensitive['token'] as String?;
//     } catch (_) {
//       return null;
//     }
//   }
// }
