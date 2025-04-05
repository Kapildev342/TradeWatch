part of 'translation_widget_single_bloc.dart';

class TranslationWidgetSingleEvent extends Equatable {
  const TranslationWidgetSingleEvent();

  @override
  List<Object?> get props => [];
}

class LoadingTranslationSingleEvent extends TranslationWidgetSingleEvent {
  const LoadingTranslationSingleEvent();

  @override
  List<Object?> get props => [];
}

class InitialTranslationSingleEvent extends TranslationWidgetSingleEvent {
  final String id;
  final String type;
  final StateSetter setState;
  final bool translation;
  final String title;
  final int index;
  final BuildContext context;
  final Function initFunction;

  const InitialTranslationSingleEvent(
      {required this.id,
      required this.type,
      required this.setState,
      required this.translation,
      required this.title,
      required this.index,
      required this.context,
      required this.initFunction});

  @override
  // TODO: implement props
  List<Object?> get props => [id, type, translation, index, title, setState];
}
