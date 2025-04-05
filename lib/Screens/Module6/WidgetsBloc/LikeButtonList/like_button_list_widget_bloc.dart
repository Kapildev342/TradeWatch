import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_main_model.dart';

part 'like_button_list_widget_event.dart';
part 'like_button_list_widget_state.dart';

class LikeButtonListWidgetBloc extends Bloc<LikeButtonListWidgetEvent, LikeButtonListWidgetState> {
  LikeButtonListWidgetBloc() : super(LikeButtonListLoadingState()) {
    on<LikeButtonListLoadingEvent>((event, emit) {
      emit(LikeButtonListLoadingState());
    });

    on<LikeButtonListInitialEvent>((event, emit) async {
      List<BillboardMainModelResponse> newValueMapList = [];
      newValueMapList.addAll(event.valueMapList);
      bool response = await billBoardApiMain.likeAddOrRemoveApiFunc(
          context: event.context,
          likeType: event.type,
          id: event.id,
          removalStatus: event.type == 'likes' ? !newValueMapList[event.index].like : !newValueMapList[event.index].dislike,
          responseId: event.responseId,
          commentId: event.commentId,
          billBoardType: event.billBoardType);
      if (response) {
        if (event.type == 'likes') {
          if (newValueMapList[event.index].like == true) {
            if (newValueMapList[event.index].dislike == true) {
            } else {
              newValueMapList[event.index].likesCount -= 1;
            }
          } else {
            if (newValueMapList[event.index].dislike == true) {
              newValueMapList[event.index].disLikesCount -= 1;
              newValueMapList[event.index].likesCount += 1;
            } else {
              newValueMapList[event.index].likesCount += 1;
            }
          }
          newValueMapList[event.index].like = !newValueMapList[event.index].like;
          newValueMapList[event.index].dislike = false;
        } else {
          if (newValueMapList[event.index].dislike == true) {
            if (newValueMapList[event.index].like == true) {
            } else {
              newValueMapList[event.index].disLikesCount -= 1;
            }
          } else {
            if (newValueMapList[event.index].like == true) {
              newValueMapList[event.index].likesCount -= 1;
              newValueMapList[event.index].disLikesCount += 1;
            } else {
              newValueMapList[event.index].disLikesCount += 1;
            }
          }
          newValueMapList[event.index].dislike = !newValueMapList[event.index].dislike;
          newValueMapList[event.index].like = false;
        }
        event.setState(() {});
      }
      emit(LikeButtonListLoadedState(
        valueMapList: newValueMapList,
        likeList: const [],
        dislikeList: const [],
      ));
    });
  }
}
