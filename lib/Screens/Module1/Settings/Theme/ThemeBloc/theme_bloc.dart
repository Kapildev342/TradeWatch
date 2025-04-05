import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeLoading()) {
    on<ThemeInitialEvent>((event, emit) {
      emit(const ThemeLoading());
      emit(ThemeLoaded(switchValue: event.value));
    });
    on<ThemeChangingEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      emit(const ThemeLoading());
      if (event.value) {
        currentTheme.value = ThemeMode.dark;
        isDarkTheme.value = true;
        prefs.setString("theme", "dark");
      } else {
        currentTheme.value = ThemeMode.light;
        isDarkTheme.value = false;
        prefs.setString("theme", "light");
      }
      emit(ThemeLoaded(switchValue: event.value));
    });
  }
}
