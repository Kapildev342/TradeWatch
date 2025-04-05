part of 'translation_widget_bloc.dart';

class TranslationWidgetState extends Equatable {
  const TranslationWidgetState();

  @override
  List<Object?> get props => [];
}

class LoadingTranslationState extends TranslationWidgetState {
  @override
  List<Object> get props => [];
}

class LoadedTranslationState extends TranslationWidgetState {
  final List<bool> translationList;

  const LoadedTranslationState({required this.translationList});

  @override
  List<Object> get props => [translationList];
}
