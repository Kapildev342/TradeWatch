part of 'like_button_all_widget_bloc.dart';

class LikeButtonAllWidgetEvent extends Equatable {
  const LikeButtonAllWidgetEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class LikeButtonAllLoadingEvent extends LikeButtonAllWidgetEvent{

  const LikeButtonAllLoadingEvent();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class LikeButtonAllInitialEvent extends LikeButtonAllWidgetEvent {
  final String id;
  final String responseId;
  final String commentId;
  final String type;
  final String billBoardType;
  final StateSetter setState;
  final List<bool> likeList;
  final List<bool> dislikeList;
  final List<int> likeCountList;
  final List<int> dislikeCountList;
  final int index;
  final BuildContext context;
  final Function initFunction;

  const LikeButtonAllInitialEvent({
    required this.id,
    required this.responseId,
    required this.commentId,
    required this.type,
    required this.billBoardType,
    required this.setState,
    required this.likeList,
    required this.dislikeList,
    required this.likeCountList,
    required this.dislikeCountList,
    required this.index,
    required this.context,
    required this.initFunction
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id,responseId,commentId,type,likeList,dislikeList,likeCountList,dislikeCountList,index,setState,context,initFunction,billBoardType];
}
