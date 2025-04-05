import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

part 'multiple_like_button_event.dart';
part 'multiple_like_button_state.dart';

class MultipleLikeButtonBloc extends Bloc<MultipleLikeButtonEvent, MultipleLikeButtonState> {
  MultipleLikeButtonBloc() : super(MultipleLikeButtonListLoadingState()) {
    on<MultipleLikeButtonListLoadingEvent>((event, emit) {
      emit(MultipleLikeButtonListLoadingState());
    });

    on<MultipleLikeButtonListInitialEvent>((event, emit) async {
      List<List<bool>> likeChanged = [];
      List<List<bool>> dislikeChanged = [];
      likeChanged.addAll(event.likeList);
      dislikeChanged.addAll(event.dislikeList);
      bool response = await billBoardApiMain.likeAddOrRemoveApiFunc(
          context: event.context,
          likeType: event.type,
          id: event.id,
          removalStatus: event.type == 'likes'
              ? !likeChanged[event.lockerIndex][event.index]
              : !dislikeChanged[event.lockerIndex][event.index],
          responseId: event.responseId,
          commentId: event.commentId,
          billBoardType: event.billBoardType);
      if (response) {
        if (event.type == 'likes') {
          if (likeChanged[event.lockerIndex][event.index] == true) {
            if (dislikeChanged[event.lockerIndex][event.index] == true) {
            } else {
              event.likeCountList[event.lockerIndex][event.index] -= 1;
            }
          } else {
            if (dislikeChanged[event.lockerIndex][event.index] == true) {
              event.dislikeCountList[event.lockerIndex][event.index] -= 1;
              event.likeCountList[event.lockerIndex][event.index] += 1;
            } else {
              event.likeCountList[event.lockerIndex][event.index] += 1;
            }
          }
          likeChanged[event.lockerIndex][event.index] = !likeChanged[event.lockerIndex][event.index];
          dislikeChanged[event.lockerIndex][event.index] = false;
        } else {
          if (dislikeChanged[event.lockerIndex][event.index] == true) {
            if (likeChanged[event.lockerIndex][event.index] == true) {
            } else {
              event.dislikeCountList[event.lockerIndex][event.index] -= 1;
            }
          } else {
            if (likeChanged[event.lockerIndex][event.index] == true) {
              event.likeCountList[event.lockerIndex][event.index] -= 1;
              event.dislikeCountList[event.lockerIndex][event.index] += 1;
            } else {
              event.dislikeCountList[event.lockerIndex][event.index] += 1;
            }
          }
          dislikeChanged[event.lockerIndex][event.index] = !dislikeChanged[event.lockerIndex][event.index];
          likeChanged[event.lockerIndex][event.index] = false;
        }
        event.setState(() {});
      }
      emit(MultipleLikeButtonListLoadedState(
        likeList: likeChanged,
        dislikeList: dislikeChanged,
      ));
    });
  }
}
