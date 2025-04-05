part of 'bill_board_translation_bloc.dart';

class BillBoardTranslationState extends Equatable {
  const BillBoardTranslationState();

  @override
  List<Object?> get props => [];
}

class BillBoardLoadingTranslationState extends BillBoardTranslationState {
  @override
  List<Object> get props => [];
}

class BillBoardLoadedTranslationState extends BillBoardTranslationState {
  final List<BillboardMainModelResponse> valueMapList;

  const BillBoardLoadedTranslationState({required this.valueMapList});

  @override
  List<Object> get props => [valueMapList];
}
