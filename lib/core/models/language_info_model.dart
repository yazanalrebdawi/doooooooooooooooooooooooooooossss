import 'dart:ui';
import 'package:dooss_business_app/core/models/enums/app_language_enum.dart';

class LanguageInfoModel {
  final String native;
  final String english;
  final String code;
  final List<Color> colors;

  const LanguageInfoModel({
    required this.native,
    required this.english,
    required this.code,
    required this.colors,
  });
}

const Map<AppLanguageEnum, LanguageInfoModel> languageMap = {
  AppLanguageEnum.arabic: LanguageInfoModel(
    code: "ع",
    native: "العربية",
    english: "Arabic",
    colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
  ),
  AppLanguageEnum.english: LanguageInfoModel(
    code: "EN",
    native: "English",
    english: "English",
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
  ),
};
