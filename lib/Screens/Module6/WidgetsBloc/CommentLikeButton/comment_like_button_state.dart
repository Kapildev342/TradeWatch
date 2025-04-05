part of 'comment_like_button_bloc.dart';

class CommentLikeButtonState extends Equatable {
  const CommentLikeButtonState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CommentLikeButtonListLoadingState extends CommentLikeButtonState {
  @override
  List<Object> get props => [];
}

class CommentLikeButtonListLoadedState extends CommentLikeButtonState {
  final List<bool> likeList;
  final List<bool> dislikeList;

  const CommentLikeButtonListLoadedState({required this.likeList, required this.dislikeList});

  @override
  List<Object> get props => [likeList, dislikeList];
}
