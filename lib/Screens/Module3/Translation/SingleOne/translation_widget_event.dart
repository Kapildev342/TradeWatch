part of 'translation_widget_bloc.dart';

class TranslationWidgetEvent extends Equatable {
  const TranslationWidgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadingTranslationEvent extends TranslationWidgetEvent {
  const LoadingTranslationEvent();

  @override
  List<Object?> get props => [];
}

class InitialTranslationEvent extends TranslationWidgetEvent {
  final String id;
  final String type;
  final StateSetter setState;
  final List<bool> translationList;
  final List<String> titleList;
  final int index;
  final BuildContext context;
  final Function initFunction;

  const InitialTranslationEvent(
      {required this.id,
      required this.type,
      required this.setState,
      required this.translationList,
      required this.titleList,
      required this.index,
      required this.context,
      required this.initFunction});

  @override
  // TODO: implement props
  List<Object?> get props => [id, type, translationList, index, titleList, setState, context, initFunction];
}
