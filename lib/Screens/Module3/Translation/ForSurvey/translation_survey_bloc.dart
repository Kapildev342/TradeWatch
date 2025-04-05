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

part 'translation_survey_event.dart';
part 'translation_survey_state.dart';

class TranslationSurveyBloc extends Bloc<TranslationSurveyEvent, TranslationSurveyState> {
  Map<String, dynamic> responseDataTranslate = {};

  TranslationSurveyBloc() : super(LoadingTranslationSurveyState()) {
    on<LoadingTranslationSurveyEvent>((event, emit) {
      emit(LoadingTranslationSurveyState());
    });

    on<InitialTranslationSurveyEvent>((event, emit) async {
      bool translation = event.translation;
      bool response = translation
          ? await getIdData(
              id: event.id,
              type: event.type,
              questionList: event.questionList,
              answer1List: event.answer1List,
              answer2List: event.answer2List,
              answer3List: event.answer3List,
              answer4List: event.answer4List,
              answer5List: event.answer5List,
              index: event.index,
            )
          : await translatingFunc(
              id: event.id,
              type: event.type,
              questionList: event.questionList,
              answer1List: event.answer1List,
              answer2List: event.answer2List,
              answer3List: event.answer3List,
              answer4List: event.answer4List,
              answer5List: event.answer5List,
              index: event.index);
      if (response) {
        translation = !translation;
        event.questionList.clear();
        event.answer1List.clear();
        event.answer2List.clear();
        event.answer3List.clear();
        event.answer4List.clear();
        event.answer5List.clear();
        for (int i = 0; i < responseDataTranslate["response"]["questions"].length; i++) {
          event.questionList.add(responseDataTranslate["response"]["questions"][i]["title"]);
          event.answer1List.add(responseDataTranslate["response"]["questions"][i]["answer1"] ?? "");
          event.answer2List.add(responseDataTranslate["response"]["questions"][i]["answer2"] ?? "");
          event.answer3List.add(responseDataTranslate["response"]["questions"][i]["answer3"] ?? "");
          event.answer4List.add(responseDataTranslate["response"]["questions"][i]["answer4"] ?? "");
          event.answer5List.add(responseDataTranslate["response"]["questions"][i]["answer5"] ?? "");
        }
        event.setState(() {});
        emit(LoadedTranslationSurveyState(translation: translation));
      } else {
        await widgetsMain.translationPage(context: event.context, initFunction: event.initFunction);
      }
    });
  }

  Future<bool> translatingFunc({
    required String id,
    required String type,
    required int index,
    required List<String> questionList,
    required List<String> answer1List,
    required List<String> answer2List,
    required List<String> answer3List,
    required List<String> answer4List,
    required List<String> answer5List,
  }) async {
    Uri uri = Uri.parse(baseurl + versionHome + translate);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "post_id": id,
      "type": type,
    });
    responseDataTranslate = jsonDecode(response.body);
    if (responseDataTranslate["response"] != null) {
      logEventFunc(name: "Content_Translated", type: type);
      return responseDataTranslate["status"];
    } else {
      return false;
    }
  }

  Future<bool> getIdData({
    required String id,
    required String type,
    required int index,
    required List<String> questionList,
    required List<String> answer1List,
    required List<String> answer2List,
    required List<String> answer3List,
    required List<String> answer4List,
    required List<String> answer5List,
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
    responseDataTranslate = json.decode(response.body);
    return responseDataTranslate["status"];
  }
}
