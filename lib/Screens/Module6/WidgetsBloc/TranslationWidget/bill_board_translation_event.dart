part of 'bill_board_translation_bloc.dart';

class BillBoardTranslationEvent extends Equatable {
  const BillBoardTranslationEvent();

  @override
  List<Object?> get props => [];
}

class BillBoardLoadingTranslationEvent extends BillBoardTranslationEvent {
  const BillBoardLoadingTranslationEvent();

  @override
  List<Object?> get props => [];
}

class BillBoardInitialTranslationEvent extends BillBoardTranslationEvent {
  final String id;
  final String type;
  final StateSetter setState;
  final int index;
  final BuildContext context;
  final Function initFunction;
  final List<BillboardMainModelResponse> valueMapList;

  const BillBoardInitialTranslationEvent({
    required this.id,
    required this.type,
    required this.setState,
    required this.index,
    required this.context,
    required this.initFunction,
    required this.valueMapList,
  });

  @override
  List<Object?> get props => [id, type, index, setState, context, initFunction, valueMapList];
}
