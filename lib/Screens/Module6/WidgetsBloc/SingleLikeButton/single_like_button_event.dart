part of 'single_like_button_bloc.dart';

class SingleLikeButtonEvent extends Equatable {
  const SingleLikeButtonEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SingleLikeButtonListLoadingEvent extends SingleLikeButtonEvent{

  const SingleLikeButtonListLoadingEvent();

  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class SingleLikeButtonListInitialEvent extends SingleLikeButtonEvent {
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

  const SingleLikeButtonListInitialEvent({
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
