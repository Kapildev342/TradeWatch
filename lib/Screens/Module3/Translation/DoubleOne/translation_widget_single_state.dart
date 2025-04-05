part of 'translation_widget_single_bloc.dart';

class TranslationWidgetSingleState extends Equatable {
  const TranslationWidgetSingleState();

  @override
  List<Object?> get props => [];
}

class LoadingTranslationSingleState extends TranslationWidgetSingleState {
  @override
  List<Object> get props => [];
}

class LoadedTranslationSingleState extends TranslationWidgetSingleState {
  final bool translation;

  const LoadedTranslationSingleState({required this.translation});

  @override
  List<Object> get props => [translation];
}
