part of 'like_button_list_widget_bloc.dart';

class LikeButtonListWidgetEvent extends Equatable {
  const LikeButtonListWidgetEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LikeButtonListLoadingEvent extends LikeButtonListWidgetEvent{

  const LikeButtonListLoadingEvent();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class LikeButtonListInitialEvent extends LikeButtonListWidgetEvent {
  final String id;
  final String responseId;
  final String commentId;
  final String type;
  final StateSetter setState;
  final List<bool> likeList;
  final List<bool> dislikeList;
  final List<int> likeCountList;
  final List<int> dislikeCountList;
  final int index;
  final BuildContext context;
  final Function initFunction;
  final String billBoardType;
  final List<BillboardMainModelResponse> valueMapList;

  const LikeButtonListInitialEvent({
    required this.id,
    required this.responseId,
    required this.commentId,
    required this.type,
    required this.setState,
    required this.likeList,
    required this.dislikeList,
    required this.likeCountList,
    required this.dislikeCountList,
    required this.index,
    required this.context,
    required this.initFunction,
    required this.billBoardType,
    required this.valueMapList,
});

  @override
  // TODO: implement props
  List<Object?> get props => [id,responseId,commentId,type,likeList,dislikeList,likeCountList,dislikeCountList,index,setState,context,initFunction,billBoardType,valueMapList];
}



