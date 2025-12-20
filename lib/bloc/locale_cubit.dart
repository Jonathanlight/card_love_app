import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  final SharedPreferences prefs;
  static const String _localeKey = 'app_locale';

  LocaleCubit(this.prefs) : super(const Locale('fr', '')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocale = prefs.getString(_localeKey);
    if (savedLocale != null) {
      emit(Locale(savedLocale, ''));
    }
  }

  Future<void> changeLocale(String languageCode) async {
    await prefs.setString(_localeKey, languageCode);
    emit(Locale(languageCode, ''));
  }

  Future<void> setFrench() async {
    await changeLocale('fr');
  }

  Future<void> setEnglish() async {
    await changeLocale('en');
  }
}
