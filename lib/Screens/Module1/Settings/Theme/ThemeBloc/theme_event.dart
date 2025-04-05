part of 'theme_bloc.dart';

class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeInitialEvent extends ThemeEvent {
  final bool value;

  const ThemeInitialEvent({required this.value});

  @override
  List<Object?> get props => [value];
}

class ThemeChangingEvent extends ThemeEvent {
  final bool value;

  const ThemeChangingEvent({required this.value});

  @override
  List<Object?> get props => [value];
}
