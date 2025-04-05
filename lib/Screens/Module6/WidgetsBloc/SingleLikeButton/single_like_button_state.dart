part of 'single_like_button_bloc.dart';

class SingleLikeButtonState extends Equatable {
  const SingleLikeButtonState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SingleLikeButtonListLoadingState extends SingleLikeButtonState {
  @override
  List<Object> get props => [];
}

class SingleLikeButtonListLoadedState extends SingleLikeButtonState {
  final List<bool> likeList;
  final List<bool> dislikeList;

  const SingleLikeButtonListLoadedState({required this.likeList, required this.dislikeList});

  @override
  List<Object> get props => [likeList, dislikeList];
}
