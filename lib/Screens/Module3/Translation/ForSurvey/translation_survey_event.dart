part of 'translation_survey_bloc.dart';

class TranslationSurveyEvent extends Equatable {
  const TranslationSurveyEvent();

  @override
  List<Object?> get props => [];
}

class LoadingTranslationSurveyEvent extends TranslationSurveyEvent {
  const LoadingTranslationSurveyEvent();

  @override
  List<Object?> get props => [];
}

class InitialTranslationSurveyEvent extends TranslationSurveyEvent {
  final String id;
  final String type;
  final StateSetter setState;
  final bool translation;
  final List<String> questionList;
  final List<String> answer1List;
  final List<String> answer2List;
  final List<String> answer3List;
  final List<String> answer4List;
  final List<String> answer5List;
  final int index;
  final BuildContext context;
  final Function initFunction;

  const InitialTranslationSurveyEvent(
      {required this.id,
      required this.type,
      required this.setState,
      required this.translation,
      required this.questionList,
      required this.answer1List,
      required this.answer2List,
      required this.answer3List,
      required this.answer4List,
      required this.answer5List,
      required this.index,
      required this.context,
      required this.initFunction});

  @override
  // TODO: implement props
  List<Object?> get props => [id, type, translation, index, questionList, answer1List, answer2List, answer3List, answer4List, answer5List, setState];
}
