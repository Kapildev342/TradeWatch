part of 'like_button_all_widget_bloc.dart';

class LikeButtonAllWidgetState extends Equatable {
  const LikeButtonAllWidgetState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LikeButtonAllLoadingState extends LikeButtonAllWidgetState {
  @override
  List<Object> get props => [];
}

class LikeButtonAllLoadedState extends LikeButtonAllWidgetState {
  final List<bool> likeList;
  final List<bool> dislikeList;

  const LikeButtonAllLoadedState({required this.likeList, required this.dislikeList});

  @override
  List<Object> get props => [likeList, dislikeList];
}
