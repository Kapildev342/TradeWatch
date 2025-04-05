// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/Api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

part 'translation_widget_event.dart';
part 'translation_widget_state.dart';

class TranslationWidgetBloc extends Bloc<TranslationWidgetEvent, TranslationWidgetState> {
  TranslationWidgetBloc() : super(LoadingTranslationState()) {
    on<LoadingTranslationEvent>((event, emit) {
      emit(LoadingTranslationState());
    });
    on<InitialTranslationEvent>((event, emit) async {
      List<bool> translationList = [];
      translationList.addAll(event.translationList);
      bool response = translationList[event.index]
          ? await getIdData(id: event.id, type: event.type, titleList: event.titleList, index: event.index)
          : await translatingFunc(id: event.id, type: event.type, titleList: event.titleList, index: event.index);
      if (response) {
        translationList[event.index] = !translationList[event.index];
        event.setState(() {});
        emit(LoadedTranslationState(translationList: translationList));
      } else {
        if (event.context.mounted) {
          await widgetsMain.translationPage(context: event.context, initFunction: event.initFunction);
        }
      }
    });
  }

  Future<bool> translatingFunc({
    required String id,
    required String type,
    required int index,
    required List<String> titleList,
  }) async {
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
      titleList[index] = responseData["response"]["title"] ?? responseData["response"]["message"];
      return responseData["status"];
    } else {
      return false;
    }
  }

  Future<bool> getIdData({
    required String id,
    required String type,
    required int index,
    required List<String> titleList,
  }) async {
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
    titleList[index] = responseData["response"]["title"] ?? responseData["response"]["message"];
    return responseData["status"];
  }
}
