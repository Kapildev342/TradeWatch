import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

part 'book_mark_multiple_widget_event.dart';

part 'book_mark_multiple_widget_state.dart';

class BookMarkMultipleWidgetBloc extends Bloc<BookMarkMultipleWidgetEvent, BookMarkMultipleWidgetState> {
  BookMarkMultipleWidgetBloc() : super(MultipleLoadingState()) {
    on<MultipleLoadingEvent>((event, emit) {
      emit(MultipleLoadingState());
    });

    on<MultipleInitialEvent>((event, emit) async {
      List<List<bool>> bookMarkChanged = [];
      bookMarkChanged.addAll(event.bookmark);
      bool response = await bookMarkAddRemove(id: event.id, type: event.type, context: event.context);
      if (response) {
        // bookMarkChanged[event.locker][event.index]=!bookMarkChanged[event.locker][event.index];
        event.initFunction();
      }
      emit(MultipleLoadedState(bookMark: bookMarkChanged));
    });
  }

  Future<bool> bookMarkAddRemove({required String id, required String type, required BuildContext context}) async {
    Uri uri = Uri.parse(baseurl + versionBookMark + addRemove);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "post_id": id,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
    debugPrint(responseData["message"]);
    if (responseData["message"] == "Bookmark removed") {
      logEventFunc(name: "Bookmark removed", type: type);
    } else {
      logEventFunc(name: "Bookmark added", type: type);
    }
    if (!context.mounted) {
      return false;
    }
    Flushbar(
      message: responseData["message"],
      duration: const Duration(seconds: 2),
    ).show(context);
    return responseData["status"];
  }
}
