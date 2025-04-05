part of 'multiple_like_button_bloc.dart';

class MultipleLikeButtonEvent extends Equatable {
  const MultipleLikeButtonEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MultipleLikeButtonListLoadingEvent extends MultipleLikeButtonEvent{

  const MultipleLikeButtonListLoadingEvent();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class MultipleLikeButtonListInitialEvent extends MultipleLikeButtonEvent {
  final String id;
  final String responseId;
  final String commentId;
  final String type;
  final String billBoardType;
  final StateSetter setState;
  final List<List<bool>> likeList;
  final List<List<bool>> dislikeList;
  final List<List<int>> likeCountList;
  final List<List<int>> dislikeCountList;
  final int index;
  final int lockerIndex;
  final BuildContext context;
  final Function initFunction;

  const MultipleLikeButtonListInitialEvent({
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
    required this.lockerIndex,
    required this.context,
    required this.initFunction
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id,responseId,commentId,type,likeList,dislikeList,likeCountList,dislikeCountList,index,lockerIndex,setState,context,initFunction,billBoardType];
}
