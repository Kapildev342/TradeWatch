part of 'multiple_like_button_bloc.dart';

class MultipleLikeButtonState extends Equatable {
  const MultipleLikeButtonState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MultipleLikeButtonListLoadingState extends MultipleLikeButtonState {
  @override
  List<Object> get props => [];
}

class MultipleLikeButtonListLoadedState extends MultipleLikeButtonState {
  final List<List<bool>> likeList;
  final List<List<bool>> dislikeList;

  const MultipleLikeButtonListLoadedState({required this.likeList, required this.dislikeList});

  @override
  List<Object> get props => [likeList, dislikeList];
}
