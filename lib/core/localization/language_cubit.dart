import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

<<<<<<< HEAD
class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en'));
=======
class AppManagerCubit extends Cubit<Locale> {
  AppManagerCubit() : super(const Locale('en'));
>>>>>>> zoz

  void toArabic() => emit(const Locale('ar'));
  void toEnglish() => emit(const Locale('en'));
  void toggle() => emit(state.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));
} 