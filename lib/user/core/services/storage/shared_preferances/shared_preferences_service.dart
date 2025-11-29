import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:dooss_business_app/dealer/features/auth/data/dealers_auth_remoute_data_Source.dart';
import 'package:dooss_business_app/user/core/constants/cache_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences storagePreferences;
  SharedPreferencesService({required this.storagePreferences});

  //?---------------- Remove All ------------------------------------------
  Future<void> removeAll() async {
    try {
      await storagePreferences.clear();
    } catch (_) {}
  }

  //?---------------- Remove All Except Privacy Policy --------------------
  // This method clears all data except privacy policy acceptance
  Future<void> removeAllExceptPrivacyPolicy() async {
    try {
      // Save privacy policy acceptance status
      final privacyPolicyAccepted = await getPrivacyPolicyAccepted();
      
      // Clear all data
      await storagePreferences.clear();
      
      // Restore privacy policy acceptance if it was accepted
      if (privacyPolicyAccepted) {
        await savePrivacyPolicyAccepted(true);
      }
    } catch (_) {}
  }

  //?---------------- Get Dealer Token ----------------------------------------
  Future<String?> getDealerToken() async {
    try {
      final jsonString = storagePreferences.getString('dealer_data');
      if (jsonString == null) return null;

      final Map<String, dynamic> map = jsonDecode(jsonString);
      final dealer = AuthDataResponse.fromMap(map);

      // 🔹 تأكد إنو في توكن
      if (dealer.access != null && dealer.access.isNotEmpty) {
        return dealer.access;
      } else {
        log("⚠️ Dealer token is null or empty");
        return null;
      }
    } catch (e) {
      log("❌ Error getting dealer token: $e");
      return null;
    }
  }

  // ------------------ Save Dealer Auth Data ------------------------
  Future<void> saveDealerAuthData(AuthDataResponse dealer) async {
    try {
      final encoded = jsonEncode(dealer.toMap());
      await storagePreferences.setString('dealer_data', encoded);
      await storagePreferences.setBool(CacheKeys.dealerData, true);
      log("✅ Dealer saved successfully");
    } catch (e) {
      log("❌ Error saving dealer: $e");
    }
  }

  // ------------------ Get Dealer Auth Data -------------------------
  Future<AuthDataResponse?> getDealerAuthData() async {
    try {
      final jsonString = storagePreferences.getString('dealer_data');
      if (jsonString == null) return null;

      final Map<String, dynamic> map = jsonDecode(jsonString);
      return AuthDataResponse.fromMap(map);
    } catch (e) {
      log("❌ Error reading dealer: $e");
      return null;
    }
  }

  //?----------------  Them ------------------------------------------------
  //* Save
  Future<void> saveThemeModeInCache(bool isLight) async {
    try {
      await storagePreferences.setBool(CacheKeys.appThemeMode, isLight);
    } catch (_) {}
  }

  //* Get
  Future<bool?> getThemeModeFromCache() async {
    try {
      return storagePreferences.getBool(CacheKeys.appThemeMode);
    } catch (_) {
      return null;
    }
  }

  //?----------------  User - ----------------------------------------------
  // //* Save User Non-Sensitive Info
  // Future<void> saveUserNonSensitiveData(UserModel user) async {
  //   try {
  //     final userJson = jsonEncode({
  //       'latitude': user.latitude,
  //       'longitude': user.longitude,
  //       'created_at': user.createdAt.toIso8601String(),
  //     });
  //     await storagePreferences.setString(CacheKeys.userModel, userJson);
  //   } catch (_) {}
  // }

  // //* Get User Non-Sensitive Info
  // Map<String, dynamic>? getUserNonSensitiveData() {
  //   try {
  //     final userJson = storagePreferences.getString(CacheKeys.userModel);
  //     if (userJson != null) {
  //       return jsonDecode(userJson);
  //     }
  //     return null;
  //   } catch (_) {
  //     return null;
  //   }
  // }

  // //*  Remove User Non-Sensitive Info
  // Future<void> removeUserNonSensitiveData() async {
  //   try {
  //     await storagePreferences.remove(CacheKeys.userModel);
  //   } catch (_) {}
  // }
  //?----------------  Image ----------------------------------------------

  //* Save
  Future<void> saveProfileImageInCache(String key, String value) async {
    try {
      await storagePreferences.remove(key);
      await storagePreferences.setString(key, value);
    } catch (_) {}
  }

  //* Get
  Future<String?> getProfileImageInCache() async {
    try {
      return storagePreferences.getString(CacheKeys.imageProfile);
    } catch (_) {
      return null;
    }
  }

  //* Remove
  Future<void> removeProfileImageInCache() async {
    try {
      final path = storagePreferences.getString(CacheKeys.imageProfile);
      if (path != null) {
        final file = File(path);
        if (file.existsSync()) {
          await file.delete();
        }
      }
      await storagePreferences.remove(CacheKeys.imageProfile);
    } catch (_) {}
  }

  //?-------------------- Locale  ------------------------------------------

  //* Get
  Future<String?> getSavedLocaleInCache() async {
    try {
      return storagePreferences.getString(CacheKeys.appLanguage);
    } catch (_) {
      return null;
    }
  }

  //* Save
  Future<void> saveLocaleInCache(String langCode) async {
    try {
      await storagePreferences.setString(CacheKeys.appLanguage, langCode);
    } catch (_) {}
  }

  //* Change
  Future<void> changeLocaleInCache(Locale newLocale) async {
    try {
      await storagePreferences.setString(
        CacheKeys.appLanguage,
        newLocale.languageCode,
      );
    } catch (_) {}
  }

  //* Remove
  Future<void> removeLocaleInCache() async {
    try {
      await storagePreferences.remove(CacheKeys.appLanguage);
    } catch (_) {}
  }

  //?-------------------- Privacy Policy Acceptance  ------------------------------------------

  //* Save
  Future<void> savePrivacyPolicyAccepted(bool accepted) async {
    try {
      await storagePreferences.setBool(CacheKeys.privacyPolicyAccepted, accepted);
    } catch (_) {}
  }

  //* Get
  Future<bool> getPrivacyPolicyAccepted() async {
    try {
      return storagePreferences.getBool(CacheKeys.privacyPolicyAccepted) ?? false;
    } catch (_) {
      return false;
    }
  }
}
