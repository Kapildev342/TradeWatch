part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeLoading extends ThemeState {
  const ThemeLoading();

  @override
  List<Object> get props => [];
}

class ThemeLoaded extends ThemeState {
  final bool switchValue;

  const ThemeLoaded({required this.switchValue});

  @override
  List<Object> get props => [switchValue];
}
