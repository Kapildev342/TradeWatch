// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_description_page.dart';

part 'translation_widget_single_event.dart';
part 'translation_widget_single_state.dart';

class TranslationWidgetSingleBloc extends Bloc<TranslationWidgetSingleEvent, TranslationWidgetSingleState> {
  TranslationWidgetSingleBloc() : super(LoadingTranslationSingleState()) {
    on<LoadingTranslationSingleEvent>((event, emit) {
      emit(LoadingTranslationSingleState());
    });
    on<InitialTranslationSingleEvent>((event, emit) async {
      bool translation = event.translation;
      bool response = translation
          ? await getIdData(id: event.id, type: event.type, title: event.title, index: event.index)
          : await translatingFunc(id: event.id, type: event.type, title: event.title, index: event.index);
      if (response) {
        translation = !translation;
        event.setState(() {});
        emit(LoadedTranslationSingleState(translation: translation));
      } else {
        await widgetsMain.translationPage(context: event.context, initFunction: event.initFunction);
      }
    });
  }

  Future<bool> translatingFunc({required String id, required String type, required int index, required String title}) async {
    Uri uri = Uri.parse(baseurl + versionHome + translate);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "post_id": id,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
    if (responseData["response"] != null) {
      logEventFunc(name: "Content_Translated", type: type);
      titleMain = responseData["response"]["title"];
      descriptionMain = responseData["response"]["description"] ?? "";
      nHtmlMain = responseData["response"]["content"] ?? "";
      return responseData["status"];
    } else {
      return false;
    }
  }

  Future<bool> getIdData({required String id, required String type, required int index, required String title}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      "id": id,
      "type": type,
    });
    var responseData = json.decode(response.body);
    titleMain = responseData["response"]["title"];
    descriptionMain = responseData["response"]["description"] ?? "";
    nHtmlMain = responseData["response"]["content"] ?? "";
    return responseData["status"];
  }
}
