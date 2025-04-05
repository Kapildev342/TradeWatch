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
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_main_model.dart';

part 'bill_board_translation_event.dart';
part 'bill_board_translation_state.dart';

class BillBoardTranslationBloc extends Bloc<BillBoardTranslationEvent, BillBoardTranslationState> {
  BillBoardTranslationBloc() : super(BillBoardLoadingTranslationState()) {
    on<BillBoardLoadingTranslationEvent>((event, emit) {
      emit(BillBoardLoadingTranslationState());
    });
    on<BillBoardInitialTranslationEvent>((event, emit) async {
      // List<bool> translationList=[];
      List<BillboardMainModelResponse> newValueMapList = [];
      // translationList.addAll(event.translationList);
      newValueMapList.addAll(event.valueMapList);
      bool response = newValueMapList[event.index].translation
          ? await getIdData(id: event.id, type: event.type, valueMapList: event.valueMapList, index: event.index)
          : await translatingFunc(id: event.id, type: event.type, valueMapList: event.valueMapList, index: event.index);
      if (response) {
        newValueMapList[event.index].translation = !newValueMapList[event.index].translation;
        event.setState(() {});
        emit(BillBoardLoadedTranslationState(valueMapList: newValueMapList));
      } else {
        await widgetsMain.translationPage(context: event.context, initFunction: event.initFunction);
      }
    });
  }

  Future<bool> translatingFunc({
    required String id,
    required String type,
    required int index,
    required List<BillboardMainModelResponse> valueMapList,
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
      valueMapList[index].title = responseData["response"]["title"] ?? responseData["response"]["message"];
      return responseData["status"];
    } else {
      return false;
    }
  }

  Future<bool> getIdData({
    required String id,
    required String type,
    required int index,
    required List<BillboardMainModelResponse> valueMapList,
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
    valueMapList[index].title = responseData["response"]["title"] ?? responseData["response"]["message"];
    return responseData["status"];
  }
}
