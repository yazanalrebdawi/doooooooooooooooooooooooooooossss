import 'dart:ui';

import 'package:dooss_business_app/core/services/storage/shared_preferances/shared_preferences_service.dart';
import 'package:dooss_business_app/core/services/translation/translation_service.dart';

class TranslationServiceImpl implements TranslationService {
  final SharedPreferencesService storagePreferanceService;

  TranslationServiceImpl({required this.storagePreferanceService});
  //? -------------------------------------------------------------------

  //* Change
  @override
  Future<void> changeLocaleService(Locale newLocale) async {
    final changedLocale =
        (newLocale.languageCode == 'en') ? Locale('ar') : Locale('en');
    await storagePreferanceService.changeLocaleInCache(changedLocale);
  }

  //* Save
  @override
  Future<void> saveLocaleService(String langCode) async {
    await storagePreferanceService.saveLocaleInCache(langCode);
  }

  //* Clear
  @override
  Future<void> clearLocaleService() async {
    await storagePreferanceService.removeLocaleInCache();
  }

  //* Get
  @override
  Future<String?> getSavedLocaleService() async {
    return await storagePreferanceService.getSavedLocaleInCache();
  }

  //? -------------------------------------------------------------------
}
