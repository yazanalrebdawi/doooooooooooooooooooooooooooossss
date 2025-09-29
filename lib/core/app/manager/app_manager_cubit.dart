import 'dart:developer';
import 'dart:io';

import 'package:dooss_business_app/core/app/source/local/user_storage_service.dart';
import 'package:dooss_business_app/core/models/enums/app_language_enum.dart';
import 'package:dooss_business_app/core/models/enums/app_them_enum.dart';
import 'package:dooss_business_app/core/services/image/image_services.dart';
import 'package:dooss_business_app/core/services/locator_service.dart';
import 'package:dooss_business_app/core/services/storage/hivi/hive_service.dart';
import 'package:dooss_business_app/core/services/storage/secure_storage/secure_storage_service.dart';
import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dooss_business_app/core/app/manager/app_manager_state.dart';
import 'package:dooss_business_app/core/services/translation/translation_service.dart';
import 'package:dooss_business_app/features/auth/data/models/user_model.dart';

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
  void saveUserData(UserModel user) {
    secureStorage.updateUserDataModel(
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

  //?-------  Them  ---------------------------------------------------------------------------

  //* update Temp Theme
  void setTempTheme(bool isTrue) {
    emit(state.copyWith(tempThem: isTrue));
  }

  //* Toggle Them
  void toggleTheme() {
    final newTheme =
        state.themeMode == AppThemeEnum.light
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

  //*  Change
  Future<void> changeLocale(AppLanguageEnum language) async {
    Locale newLocale;
    switch (language) {
      case AppLanguageEnum.arabic:
        newLocale = Locale('ar');
        break;
      case AppLanguageEnum.english:
        newLocale = Locale('en');
        break;
    }
    await translationService.changeLocaleService(newLocale);
    await sharedPreference.saveLocaleInCache(newLocale.languageCode);
    emit(state.copyWith(locale: newLocale, lastApply: null));
  }

  //* Toggle
  Future<void> toggleLanguage() async {
    final newLocale =
        state.locale.languageCode == 'ar' ? Locale('en') : Locale('ar');
    await translationService.changeLocaleService(newLocale);
    await sharedPreference.saveLocaleInCache(newLocale.languageCode);
    emit(state.copyWith(locale: newLocale));
  }

  //* Get Locale
  Future<void> getSavedLocale() async {
    final savedLangCode = await sharedPreference.getSavedLocaleInCache();
    if (savedLangCode != null) {
      emit(state.copyWith(locale: Locale(savedLangCode)));
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

  String getCurrentLocaleString() {
    if (state.locale == Locale("en")) {
      return "English";
    } else {
      return "Arabic";
    }
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
