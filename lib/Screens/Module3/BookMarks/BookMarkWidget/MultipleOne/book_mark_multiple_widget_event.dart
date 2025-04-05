part of 'book_mark_multiple_widget_bloc.dart';

class BookMarkMultipleWidgetEvent extends Equatable {
  const BookMarkMultipleWidgetEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MultipleLoadingEvent extends BookMarkMultipleWidgetEvent{

  const MultipleLoadingEvent();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class MultipleInitialEvent extends BookMarkMultipleWidgetEvent{
  final String id;
  final String type;
  final int locker;
  final List<List<bool>> bookmark;
  final int index;
  final BuildContext context;
  final Function initFunction;

  const MultipleInitialEvent({
    required this.id,
    required this.type,
    required this.locker,
    required this.bookmark,
    required this.index,
    required this.context,
    required this.initFunction,
  });

  @override
  // TODO: implement props
  List<Object?> get props =>[id,type,bookmark,index,locker,context,initFunction];
}
