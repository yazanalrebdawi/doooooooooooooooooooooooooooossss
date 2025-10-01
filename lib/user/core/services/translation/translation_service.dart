import 'package:flutter/widgets.dart';

abstract class TranslationService {
  Future<void> changeLocaleService(Locale newLocale);
  Future<void> saveLocaleService(String langCode);
  Future<void> clearLocaleService();
  Future<String?> getSavedLocaleService();
}
