import 'package:dooss_business_app/dealer/features/auth/data/dealers_auth_remoute_data_Source.dart';
import 'package:dooss_business_app/user/core/models/enums/app_language_enum.dart';
import 'package:dooss_business_app/user/core/models/enums/app_them_enum.dart';
import 'package:flutter/material.dart';
import 'package:dooss_business_app/user/features/auth/data/models/user_model.dart';

class AppManagerState {
  //?-------------------------------------------------------------------
  //! User Data
  final UserModel? user;

  //! Language
  final Locale locale;
  final AppLanguageEnum? lastApply;

  //! Them
  final AppThemeEnum themeMode;
  final bool tempThem;

  //! Dealer or user
  final bool isDealer;
  final AuthDataResponse? dealer;

  //?-------------------------------------------------------------------

  AppManagerState({
    this.isDealer = false,
    this.tempThem = true,
    this.themeMode = AppThemeEnum.light,
    this.user,
    this.locale = const Locale('en'),
    this.lastApply,
    this.dealer,
  });
  //?-------------------------------------------------------------------
  AppManagerState copyWith({
    bool? isDealer,
    AuthDataResponse? dealer,
    bool? tempThem,
    UserModel? user,
    AppThemeEnum? themeMode,
    Locale? locale,
    AppLanguageEnum? lastApply,
  }) {
    return AppManagerState(
      themeMode: themeMode ?? this.themeMode,
      dealer: dealer ?? this.dealer,
      isDealer: isDealer ?? this.isDealer,
      user: user ?? this.user,
      tempThem: tempThem ?? this.tempThem,
      locale: locale ?? this.locale,
      lastApply: lastApply,
    );
  }

  //?-------------------------------------------------------------------
}
