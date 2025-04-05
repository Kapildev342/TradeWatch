import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkOverAll/book_mark_over_view_model.dart';

class ApiFunctions {
  Future<bool> getAddWatchList({
    required String tickerId,
    required BuildContext context,
    required StateSetter modelSetState,
  }) async {
    Map<String, dynamic> data = {};
    var url = baseurl + versionWatch + watchListAdd;
    data = {
      "category_id": mainCatIdList[0],
      "exchange_id": finalExchangeIdList[0],
      "ticker_id": tickerId,
    };
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: data);
    var responseData = response.data;
    if (responseData["status"]) {
      watchVariables.watchListCountTotalMain.value =
          responseData["watchlist_count"] ?? watchVariables.watchListCountTotalMain.value;
      if (watchVariables.watchListCountTotalMain.value % 5 == 0) {
        debugPrint(" ad Started");
        functionsMain.createInterstitialAd(modelSetState: modelSetState);
      }
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData["status"];
  }

  Future<bool> getRemoveWatchList({required String tickerId, required BuildContext context}) async {
    var url = baseurl + versionWatch + watchListRemove;
    var response =
        await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: {"ticker_id": tickerId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData["status"];
  }

  Future<BookMarkOverviewModel> bookMarkInitialFunction() async {
    var url = Uri.parse(baseurl + versionBookMark + overall);
    var response = await http.post(url, headers: {'Authorization': kToken});
    var responseData = json.decode(response.body);
    mainVariables.bookMarkOverViewAllMain = (BookMarkOverviewModel.fromJson(responseData)).obs;
    return mainVariables.bookMarkOverViewAllMain!.value;
  }
}
