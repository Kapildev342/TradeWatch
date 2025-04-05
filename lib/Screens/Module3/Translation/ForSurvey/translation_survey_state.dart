part of 'translation_survey_bloc.dart';

class TranslationSurveyState extends Equatable {
  const TranslationSurveyState();

  @override
  List<Object?> get props => [];
}

class LoadingTranslationSurveyState extends TranslationSurveyState {
  @override
  List<Object> get props => [];
}

class LoadedTranslationSurveyState extends TranslationSurveyState {
  final bool translation;
  const LoadedTranslationSurveyState({required this.translation});
  @override
  List<Object> get props => [translation];
}
