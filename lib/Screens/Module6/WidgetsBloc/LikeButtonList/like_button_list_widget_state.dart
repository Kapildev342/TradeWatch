part of 'like_button_list_widget_bloc.dart';

class LikeButtonListWidgetState extends Equatable {
  const LikeButtonListWidgetState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LikeButtonListLoadingState extends LikeButtonListWidgetState {
  @override
  List<Object> get props => [];
}


class LikeButtonListLoadedState extends LikeButtonListWidgetState {
  final List<BillboardMainModelResponse> valueMapList;
  final List<bool> likeList;
  final List<bool> dislikeList;
  const LikeButtonListLoadedState({required this.valueMapList,required this.likeList,required this.dislikeList});
  @override
  List<Object> get props => [valueMapList];
}