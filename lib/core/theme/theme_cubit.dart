import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({required SharedPreferences prefs})
      : _prefs = prefs,
        super(_themeFromIndex(prefs.getInt(_key)));

  static const _key = 'theme_mode';
  final SharedPreferences _prefs;

  void toggleTheme() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _prefs.setInt(_key, next.index);
    emit(next);
  }

  static ThemeMode _themeFromIndex(int? index) {
    if (index == null) return ThemeMode.system;
    return ThemeMode.values.elementAtOrNull(index) ?? ThemeMode.system;
  }
}
