part of 'book_mark_single_widget_bloc.dart';

class BookMarkSingleWidgetEvent extends Equatable {
  const BookMarkSingleWidgetEvent();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
}


class BookLoadingEvent extends BookMarkSingleWidgetEvent{

  const BookLoadingEvent();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class BookInitialEvent extends BookMarkSingleWidgetEvent{
  final String id;
  final String type;
  final bool bookmark;
  final int index;
  final BuildContext context;

  const BookInitialEvent( {required this.id,required this.type,required this.bookmark,required this.index,required this.context});

  @override
  // TODO: implement props
  List<Object?> get props =>[id,type,bookmark,index];
}