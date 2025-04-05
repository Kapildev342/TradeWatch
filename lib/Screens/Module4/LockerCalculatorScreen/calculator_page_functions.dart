import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

import 'calculator_page_design_model.dart';
import 'calculator_page_initial_model.dart';

class CalculatorPageFunctions {
  List stocksList = [];
  List cryptoList = [];
  List commodityList = [];
  List forexList = [];

  Future<CalculatorPageInitialModel> getInitialData() async {
    String url = baseurl + versionEconomic + investmentPlanner;
    var response = await dioMain.get(url, options: Options(headers: {"authorization": kToken}));
    var responseData = response.data;
    return CalculatorPageInitialModel.fromJson(responseData);
  }

  assigningInitialValuesFunction() async {
    stocksList.clear();
    cryptoList.clear();
    commodityList.clear();
    forexList.clear();
    lockerVariables.calculatorSelectedTickersList.clear();
    lockerVariables.calculatorSelectedTickersList = List<List<String>>.generate(4, (index) => <String>[]);
    lockerVariables.isIndia.value = true;
    lockerVariables.isDeletingEnabled = RxList.generate(4, (index) => false);
    CalculatorPageInitialModel initialData = await getInitialData();
    lockerVariables.initialValue.value = initialData.response.amount / 1000000;
    lockerVariables.purchaseValue.value = initialData.response.amount.toDouble();
    lockerVariables.dollarValue.value = initialData.currencyChange.close;
    lockerVariables.calculatorTextControl.value.text = lockerVariables.isIndia.value
        ? lockerVariables.purchaseValue.value.toStringAsFixed(2)
        : lockerVariables.purchaseValue.value.toStringAsFixed(2);
    for (int i = 0; i < initialData.response.tickers.length; i++) {
      if (initialData.response.tickers[i].category == 'stocks') {
        lockerVariables.calculatorSelectedTickersList[0].add(initialData.response.tickers[i].id);
        Map<String, dynamic> data = {
          "name": initialData.response.tickers[i].exchange == "NSE" ||
                  initialData.response.tickers[i].exchange == "BSE" ||
                  initialData.response.tickers[i].exchange == "INDX"
              ? initialData.response.tickers[i].exchange.toLowerCase()
              : "usastocks",
          "ticker": {
            "id": initialData.response.tickers[i].id,
            "imageUrl": initialData.response.tickers[i].logoUrl,
            "name": initialData.response.tickers[i].name,
            "category": initialData.response.tickers[i].category,
            "exchange": initialData.response.tickers[i].exchange,
            "country": initialData.response.tickers[i].country,
            "code": initialData.response.tickers[i].code,
            "close": initialData.response.tickers[i].close,
            "value": initialData.response.tickers[i].close == 0
                ? initialData.response.tickers[i].close.toString()
                : (lockerVariables.isIndia.value
                        ? (lockerVariables.purchaseValue.value / initialData.response.tickers[i].close)
                        : ((lockerVariables.purchaseValue.value * lockerVariables.dollarValue.value) /
                            initialData.response.tickers[i].close))
                    .toStringAsFixed(2),
            "fromWhere": "calculator"
          }
        };
        stocksList.add(data);
      } else if (initialData.response.tickers[i].category == 'crypto') {
        lockerVariables.calculatorSelectedTickersList[1].add(initialData.response.tickers[i].id);
        Map<String, dynamic> data = {
          "name": initialData.response.tickers[i].industry.toLowerCase(),
          "ticker": {
            "id": initialData.response.tickers[i].id,
            "imageUrl": initialData.response.tickers[i].logoUrl,
            "name": initialData.response.tickers[i].name,
            "category": initialData.response.tickers[i].category,
            "exchange": initialData.response.tickers[i].exchange,
            "country": initialData.response.tickers[i].country,
            "code": initialData.response.tickers[i].cryptoCode,
            "close": initialData.response.tickers[i].close,
            "value": initialData.response.tickers[i].close == 0
                ? initialData.response.tickers[i].close.toString()
                : (lockerVariables.isIndia.value
                        ? (lockerVariables.purchaseValue.value / initialData.response.tickers[i].close)
                        : ((lockerVariables.purchaseValue.value * lockerVariables.dollarValue.value) /
                            initialData.response.tickers[i].close))
                    .toStringAsFixed(2),
            "fromWhere": "calculator"
          }
        };
        cryptoList.add(data);
      } else if (initialData.response.tickers[i].category == 'commodity') {
        lockerVariables.calculatorSelectedTickersList[2].add(initialData.response.tickers[i].id);
        Map<String, dynamic> data = {
          "name": initialData.response.tickers[i].country.toLowerCase(),
          "ticker": {
            "id": initialData.response.tickers[i].id,
            "imageUrl": initialData.response.tickers[i].logoUrl,
            "name": initialData.response.tickers[i].name,
            "category": initialData.response.tickers[i].category,
            "exchange": initialData.response.tickers[i].exchange,
            "country": initialData.response.tickers[i].country,
            "code": initialData.response.tickers[i].code,
            "close": initialData.response.tickers[i].close,
            "value": initialData.response.tickers[i].close == 0
                ? initialData.response.tickers[i].close.toString()
                : (lockerVariables.isIndia.value
                        ? (lockerVariables.purchaseValue.value / initialData.response.tickers[i].close)
                        : ((lockerVariables.purchaseValue.value * lockerVariables.dollarValue.value) /
                            initialData.response.tickers[i].close))
                    .toStringAsFixed(2),
            "fromWhere": "calculator"
          }
        };
        commodityList.add(data);
      } else if (initialData.response.tickers[i].category == 'forex') {
        lockerVariables.calculatorSelectedTickersList[3].add(initialData.response.tickers[i].id);
        Map<String, dynamic> data = {
          "name": "inrusd",
          "ticker": {
            "id": initialData.response.tickers[i].id,
            "imageUrl": initialData.response.tickers[i].logoUrl,
            "name": initialData.response.tickers[i].name,
            "category": initialData.response.tickers[i].category,
            "exchange": initialData.response.tickers[i].exchange,
            "country": initialData.response.tickers[i].country,
            "code": initialData.response.tickers[i].code,
            "close": initialData.response.tickers[i].close,
            "value": initialData.response.tickers[i].close == 0
                ? initialData.response.tickers[i].close.toString()
                : (lockerVariables.isIndia.value
                        ? (lockerVariables.purchaseValue.value / initialData.response.tickers[i].close)
                        : ((lockerVariables.purchaseValue.value * lockerVariables.dollarValue.value) /
                            initialData.response.tickers[i].close))
                    .toStringAsFixed(2),
            "fromWhere": "calculator"
          }
        };
        forexList.add(data);
      } else {
        debugPrint("nothing");
      }
    }
    Map<String, dynamic> calculatorContentData = {
      "response": [
        {"topic": "Stocks", "imageUrl": "lib/Constants/Assets/SMLogos/LockerScreen/Chart.svg", "responseList": stocksList},
        {"topic": "Crypto", "imageUrl": "lib/Constants/Assets/SMLogos/LockerScreen/Bitcoin.svg", "responseList": cryptoList},
        {
          "topic": "Commodity",
          "imageUrl": "lib/Constants/Assets/SMLogos/LockerScreen/Commodity Icon (2).png",
          "responseList": commodityList
        },
        {"topic": "Forex", "imageUrl": "lib/Constants/Assets/SMLogos/LockerScreen/Forex Icon.png", "responseList": forexList}
      ]
    };
    lockerVariables.calculatorPageContents = (CalculatorPageDesignModel.fromJson(calculatorContentData)).obs;
  }

  favouriteSaveFunction({required BuildContext context}) async {
    String url = baseurl + versionEconomic + investmentPlannerSave;
    List<String> addedData = [];
    addedData
      ..addAll(lockerVariables.calculatorSelectedTickersList[0])
      ..addAll(lockerVariables.calculatorSelectedTickersList[1])
      ..addAll(lockerVariables.calculatorSelectedTickersList[2])
      ..addAll(lockerVariables.calculatorSelectedTickersList[3]);
    var response = await dioMain.post(url, options: Options(headers: {"authorization": kToken}), data: {
      "amount": lockerVariables.isIndia.value
          ? lockerVariables.purchaseValue.value
          : (lockerVariables.purchaseValue.value * lockerVariables.dollarValue.value),
      "currency": lockerVariables.isIndia.value ? "INR" : "USD",
      "ticker_ids": addedData
    });
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: "Successfully saved your favourites",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: "Something went wrong, Please try again later",
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    debugPrint("responseData");
    debugPrint(responseData);
  }
}
