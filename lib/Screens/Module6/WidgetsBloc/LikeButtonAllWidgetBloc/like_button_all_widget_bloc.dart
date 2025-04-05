import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

part 'like_button_all_widget_event.dart';
part 'like_button_all_widget_state.dart';

class LikeButtonAllWidgetBloc extends Bloc<LikeButtonAllWidgetEvent, LikeButtonAllWidgetState> {
  LikeButtonAllWidgetBloc() : super(LikeButtonAllLoadingState()) {
    on<LikeButtonAllLoadingEvent>((event, emit) {
      emit(LikeButtonAllLoadingState());
    });

    on<LikeButtonAllInitialEvent>((event, emit) async {
      List<bool> likeChanged = [];
      List<bool> dislikeChanged = [];
      likeChanged.addAll(event.likeList);
      dislikeChanged.addAll(event.dislikeList);
      bool response = await billBoardApiMain.likeAddOrRemoveApiFunc(
          context: event.context,
          likeType: event.type,
          id: event.id,
          removalStatus: event.type == 'likes' ? !likeChanged[event.index] : !dislikeChanged[event.index],
          responseId: event.responseId,
          commentId: event.commentId,
          billBoardType: event.billBoardType);
      if (response) {
        if (event.type == 'likes') {
          if (likeChanged[event.index] == true) {
            if (dislikeChanged[event.index] == true) {
            } else {
              event.likeCountList[event.index] -= 1;
            }
          } else {
            if (dislikeChanged[event.index] == true) {
              event.dislikeCountList[event.index] -= 1;
              event.likeCountList[event.index] += 1;
            } else {
              event.likeCountList[event.index] += 1;
            }
          }
          likeChanged[event.index] = !likeChanged[event.index];
          dislikeChanged[event.index] = false;
        } else {
          if (dislikeChanged[event.index] == true) {
            if (likeChanged[event.index] == true) {
            } else {
              event.dislikeCountList[event.index] -= 1;
            }
          } else {
            if (likeChanged[event.index] == true) {
              event.likeCountList[event.index] -= 1;
              event.dislikeCountList[event.index] += 1;
            } else {
              event.dislikeCountList[event.index] += 1;
            }
          }
          dislikeChanged[event.index] = !dislikeChanged[event.index];
          likeChanged[event.index] = false;
        }
        event.setState(() {});
      }
      emit(LikeButtonAllLoadedState(
        likeList: likeChanged,
        dislikeList: dislikeChanged,
      ));
    });
  }
}
