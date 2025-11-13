import 'dart:developer';
import 'dart:io';

import 'package:dooss_business_app/dealer/features/auth/data/dealers_auth_remoute_data_Source.dart';
import 'package:dooss_business_app/user/core/models/enums/app_language_enum.dart';
import 'package:dooss_business_app/user/core/models/enums/app_them_enum.dart';
import 'package:dooss_business_app/user/core/services/image/image_services.dart';
import 'package:dooss_business_app/user/core/services/locator_service.dart';
import 'package:dooss_business_app/user/core/services/storage/hivi/hive_service.dart';
import 'package:dooss_business_app/user/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/user/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dooss_business_app/user/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/user/core/services/translation/translation_service.dart';
import 'package:dooss_business_app/user/features/auth/data/models/user_model.dart';

class AppManagerCubit extends Cubit<AppManagerState> {
  final TranslationService translationService;
  final ImageServices imageServices;
  final SharedPreferencesService sharedPreference;
  final SecureStorageService secureStorage;
  final HiveService hive;
  //todo نضمن كلاسات السيرفيس تبع ال الحفظ كاش

  AppManagerCubit({
    required this.translationService,
    required this.hive,
    required this.secureStorage,
    required this.sharedPreference,
    required this.imageServices,
  }) : super(AppManagerState());

  //?-------   User   ---------------------------------------------------------------------------
  void selectUser() => emit(AppManagerState(isDealer: false));
  void selectDealer() => emit(AppManagerState(isDealer: true));
  //* update  Phone
  Future<void> updatePhone(String phone) async {
    final currentUser = state.user;
    if (currentUser == null) return;

    await secureStorage.updateNameAndPhone(
      newName: currentUser.name,
      newPhone: phone,
    );
    final updatedUser = currentUser.copyWith(phone: phone);
    emit(state.copyWith(user: updatedUser));
  }

  //* Save Data ( UserModel )
  Future<void> saveUserData(UserModel user) async {
    await secureStorage.updateUserDataModel(
      id: user.id,
      name: user.name,
      phone: user.phone,
      role: user.role,
      verified: user.verified,
    );
    emit(state.copyWith(user: user));
  }

  //* update Name And Phone
  Future<void> updateNameAndPhone(String name, String phone) async {
    await secureStorage.updateNameAndPhone(newName: name, newPhone: phone);
    emit(state.copyWith(user: state.user?.copyWith(name: name, phone: phone)));
  }

  //* Save User Model
  void saveUserModel({
    String? name,
    String? phone,
    dynamic latitude,
    dynamic longitude,
    File? avatar,
  }) {
    final currentUser = state.user;
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      name: name ?? currentUser.name,
      phone: phone ?? currentUser.phone,
      latitude: latitude ?? currentUser.latitude,
      longitude: longitude ?? currentUser.longitude,
      avatar: avatar ?? currentUser.avatar,
    );

    emit(state.copyWith(user: updatedUser));
  }

  //* log Out
  Future<void> logOut() async {
    await Future.wait([
      sharedPreference.removeAll(),
      secureStorage.removeAll(),
    ]);
    await hive.clearAllInCache();
  }

  //* حفظ بيانات الديلر بعد تسجيل الدخول
  Future<void> saveDealerData(AuthDataResponse dealerAuth) async {
    await secureStorage.saveDealerAuthData(dealerAuth);
    await appLocator<SharedPreferencesService>().saveDealerAuthData(dealerAuth);
    await secureStorage.setIsDealer(true);
    emit(state.copyWith(isDealer: true, dealer: dealerAuth));
    log("✅ Dealer data saved successfully");
  }

  //* تسجيل خروج الديلر فقط
  Future<void> dealerLogOut() async {
    await secureStorage.removeAll();
    await secureStorage.removeAll();
    emit(state.copyWith(isDealer: false, user: null));
    log("🚪 Dealer logged out and secure storage cleared");
  }

  //?-------  Them  ---------------------------------------------------------------------------

  //* update Temp Theme
  void setTempTheme(bool isTrue) {
    emit(state.copyWith(tempThem: isTrue));
  }

  //* Toggle Them
  void toggleTheme() {
    final newTheme = state.themeMode == AppThemeEnum.light
        ? AppThemeEnum.dark
        : AppThemeEnum.light;

    sharedPreference.saveThemeModeInCache(newTheme == AppThemeEnum.light);

    setTheme(newTheme);
  }

  //* Set Theme
  void setTheme(AppThemeEnum themeMode) {
    emit(state.copyWith(themeMode: themeMode));
  }

  //* Load Theme From Cache
  Future<void> loadThemeFromCache() async {
    final isLight = await sharedPreference.getThemeModeFromCache();

    if (isLight != null) {
      setTheme(isLight ? AppThemeEnum.light : AppThemeEnum.dark);
    } else {
      setTheme(AppThemeEnum.light);
    }
  }

  //?-------  Locale  ---------------------------------------------------------------------------

  //* Load Locale From Cache
  Future<void> loadLocaleFromCache() async {
    final savedLocaleCode = await sharedPreference.getSavedLocaleInCache();

    if (savedLocaleCode != null) {
      final newLocale = Locale(savedLocaleCode);
      await translationService.changeLocaleService(newLocale);
      emit(state.copyWith(locale: newLocale));
    } else {
      // Default to English if no saved locale
      final defaultLocale = const Locale('en');
      await translationService.changeLocaleService(defaultLocale);
      emit(state.copyWith(locale: defaultLocale));
    }
  }

  //*  Change
  Future<void> changeLocale(AppLanguageEnum language) async {
    Locale newLocale;
    switch (language) {
      case AppLanguageEnum.arabic:
        newLocale = const Locale('ar');
        break;
      case AppLanguageEnum.english:
        newLocale = const Locale('en');
        break;
      case AppLanguageEnum.turkish:
        newLocale = const Locale('tr');
        break;
    }
    await translationService.changeLocaleService(newLocale);
    await sharedPreference.saveLocaleInCache(newLocale.languageCode);
    emit(state.copyWith(locale: newLocale, lastApply: null));
  }

  ///* Toggle Language (cycles between Arabic → English → Turkish)
  Future<void> toggleLanguage() async {
    String current = state.locale.languageCode;
    late Locale newLocale;

    if (current == 'ar') {
      newLocale = const Locale('en');
    } else if (current == 'en') {
      newLocale = const Locale('tr');
    } else {
      newLocale = const Locale('ar');
    }

    await translationService.changeLocaleService(newLocale);
    await sharedPreference.saveLocaleInCache(newLocale.languageCode);
    emit(state.copyWith(locale: newLocale));
  }

  ///* Get saved language name
  String getCurrentLocaleString() {
    final code = state.locale.languageCode;
    switch (code) {
      case 'ar':
        return 'Arabic';
      case 'en':
        return 'English';
      case 'tr':
        return 'Turkish';
      default:
        return 'English';
    }
  }

  //* Clear Locale When LogOut
  // Future<void> clearLocale() async {
  //   await translationService.clearLocaleService();
  //   emit(state.copyWith(locale: const Locale('en')));
  // }

  //* Save Change Temp
  Future<void> saveChanegTemp(AppLanguageEnum? language) async {
    emit(state.copyWith(lastApply: language));
  }

  //* Save Image
  Future<void> saveImage(File? image) async {
    if (state.user != null) {
      imageServices.saveProfileImageService(image!);
      emit(state.copyWith(user: state.user!.copyWith(avatar: image)));
    }
  }

  //?----------------------------------------------------------------------------------
}
