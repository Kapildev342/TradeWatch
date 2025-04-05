import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

part 'comment_like_button_event.dart';
part 'comment_like_button_state.dart';

class CommentLikeButtonBloc extends Bloc<CommentLikeButtonEvent, CommentLikeButtonState> {
  CommentLikeButtonBloc() : super(CommentLikeButtonListLoadingState()) {
    on<CommentLikeButtonListLoadingEvent>((event, emit) {
      emit(CommentLikeButtonListLoadingState());
    });

    on<CommentLikeButtonListInitialEvent>((event, emit) async {
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
      emit(CommentLikeButtonListLoadedState(
        likeList: likeChanged,
        dislikeList: dislikeChanged,
      ));
    });
  }
}
