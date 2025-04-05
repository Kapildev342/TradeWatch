part of 'book_mark_widget_bloc.dart';

class BookMarkWidgetState extends Equatable {
  const BookMarkWidgetState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadingState extends BookMarkWidgetState {
  @override
  List<Object> get props => [];
}


class LoadedState extends BookMarkWidgetState {
  final List<bool> bookMark;
  const LoadedState({required this.bookMark});
  @override
  List<Object> get props => [bookMark];
}