part of 'book_mark_single_widget_bloc.dart';

class BookMarkSingleWidgetState extends Equatable {
  const BookMarkSingleWidgetState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BookLoadingState extends BookMarkSingleWidgetState {
  @override
  List<Object> get props => [];
}


class BookLoadedState extends BookMarkSingleWidgetState {
  final bool bookMark;
  const BookLoadedState({required this.bookMark});
  @override
  List<Object> get props => [bookMark];
}