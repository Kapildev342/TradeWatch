part of 'book_mark_multiple_widget_bloc.dart';

class BookMarkMultipleWidgetState extends Equatable {
  const BookMarkMultipleWidgetState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MultipleLoadingState extends BookMarkMultipleWidgetState {
  @override
  List<Object> get props => [];
}


class MultipleLoadedState extends BookMarkMultipleWidgetState {
  final List<List<bool>> bookMark;
  const MultipleLoadedState({required this.bookMark});
  @override
  List<Object> get props => [bookMark];
}
