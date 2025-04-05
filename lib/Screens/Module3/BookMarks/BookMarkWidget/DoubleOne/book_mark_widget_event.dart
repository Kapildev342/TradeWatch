part of 'book_mark_widget_bloc.dart';

class BookMarkWidgetEvent extends Equatable {
  const BookMarkWidgetEvent();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class LoadingEvent extends BookMarkWidgetEvent{

const LoadingEvent();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class InitialEvent extends BookMarkWidgetEvent{
  final String id;
  final String type;
  final List<bool> bookmark;
  final int index;
  final BuildContext context;
  final Function initFunction;

 const InitialEvent({
   required this.id,
   required this.type,
   required this.bookmark,
   required this.index,
   required this.context,
   required this.initFunction
 });

  @override
  // TODO: implement props
  List<Object?> get props =>[id,type,bookmark,index];
}

