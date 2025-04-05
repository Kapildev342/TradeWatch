import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

import 'LTIPageModel/lti_page_initial_model.dart';
import 'LTIPageModel/lti_ticker_data_chart_values_model.dart';

class LTICalculatorFunctions {
  longTermInitialDataFunction({required StateSetter modelSetState}) async {
    Map<String, dynamic> longTermApiData = await initialAPIFunction();

    lockerVariables.isLongTermPrice.value = true;
    lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value =
        longTermApiData["response"]["trading_details"]["close"].toDouble();
    lockerVariables.longTermInitialData!.value.tickerDetails.value =
        TickerDetails.fromJson(longTermApiData["response"]["ticker_details"]);
    lockerVariables.purchasedQuantityController.value.text =
        lockerVariables.longTermInitialData!.value.tickerDetails.value.category.value == "stocks"
            ? "No. of shares purchased"
            : "Purchased quantity";
    lockerVariables.longTermInitialData!.value.shares.value =
        lockerVariables.longTermInitialData!.value.purchaseValue.value /
            lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value;
    lockerVariables.longTermInitialData!.value.splitsList =
        RxList<SplitsList>.from((longTermApiData["response"]["splits_list"]).map((x) => SplitsList.fromJson(x)));
    lockerVariables.longTermInitialData!.value.dividendList =
        RxList<DividendList>.from((longTermApiData["response"]["dividents_list"]).map((x) => DividendList.fromJson(x)));
    lockerVariables.longTermDateController.value.text =
        DateFormat("dd/MM/yyyy").format(lockerVariables.longTermInitialData!.value.selectedDate.value);
    lockerVariables.longTermCategory.value.text = lockerVariables.longTermInitialData!.value.category.value;
    lockerVariables.longTermTicker.value.text = lockerVariables.longTermInitialData!.value.tickerName.value;
    lockerVariables.longTermInputAmount.value.text =
        lockerVariables.longTermInitialData!.value.purchaseValue.value.toString();
    lockerVariables.longTermInitialData!.value.sliderValue =
        (lockerVariables.longTermInitialData!.value.purchaseValue.value / 1000000.00).obs;

    await longTermValuesCalculation();
    await chartsAPIFunction();
    modelSetState(() {});
  }

  Future<Map<String, dynamic>> initialAPIFunction() async {
    String url = baseurl + versionEconomic + calculator;
    var response = await dioMain.post(url, options: Options(headers: {"Authorization": kToken}), data: {
      "ticker_id": lockerVariables.longTermInitialData!.value.tickerId.value,
      "date": DateFormat("yyyy-MM-dd").format(lockerVariables.longTermInitialData!.value.selectedDate.value)
    });
    return response.data;
  }

  longTermValuesCalculation() async {
    double shares = 0.0;
    shares = lockerVariables.longTermInitialData!.value.purchaseValue.value /
        lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value;
    List<DateTime> dividendDateList = [];
    List<DateTime> splitDateList = [];
    List<double> dividendValuesList = [];
    lockerVariables.longTermInitialData!.value.sliderValue =
        (lockerVariables.longTermInitialData!.value.purchaseValue.value / 1000000.00).obs;
    lockerVariables.longTermInitialData!.value.ltiValues.value.isSplitsAvailable.value =
        lockerVariables.longTermInitialData!.value.splitsList.isNotEmpty;
    lockerVariables.longTermInitialData!.value.ltiValues.value.isDividendsAvailable.value =
        lockerVariables.longTermInitialData!.value.dividendList.isNotEmpty;
    if (lockerVariables.longTermInitialData!.value.ltiValues.value.isSplitsAvailable.value) {
      for (int i = 0; i < lockerVariables.longTermInitialData!.value.splitsList.length; i++) {
        splitDateList.add(lockerVariables.longTermInitialData!.value.splitsList[i].splitDate.value);
        shares = shares *
            (lockerVariables.longTermInitialData!.value.splitsList[i].newShares.value /
                lockerVariables.longTermInitialData!.value.splitsList[i].oldShares.value);
      }
      lockerVariables.longTermInitialData!.value.ltiValues.value.noOfShares.value = shares;
    } else {
      splitDateList = [];
      lockerVariables.longTermInitialData!.value.ltiValues.value.noOfShares.value =
          lockerVariables.longTermInitialData!.value.purchaseValue.value /
              lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value;
    }
    lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentValue.value =
        lockerVariables.longTermInitialData!.value.ltiValues.value.noOfShares.value *
            lockerVariables.longTermInitialData!.value.tickerDetails.value.close.value;
    lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentPercent.value =
        ((lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentValue.value -
                    lockerVariables.longTermInitialData!.value.purchaseValue.value) /
                lockerVariables.longTermInitialData!.value.purchaseValue.value) *
            100;
    lockerVariables.longTermInitialData!.value.ltiValues.value.noOfSharesPercent.value =
        ((lockerVariables.longTermInitialData!.value.ltiValues.value.noOfShares.value -
                    (lockerVariables.longTermInitialData!.value.purchaseValue.value /
                        lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value)) /
                (lockerVariables.longTermInitialData!.value.purchaseValue.value /
                    lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value)) *
            100;
    lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentPercentStatus.value =
        lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentPercent.value < 0 ? false : true;
    lockerVariables.longTermInitialData!.value.ltiValues.value.noOfSharesPercentStatus.value =
        lockerVariables.longTermInitialData!.value.ltiValues.value.noOfSharesPercent.value < 0 ? false : true;
    lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentPercent.value =
        (lockerVariables.longTermInitialData!.value.ltiValues.value.totalInvestmentPercent.value).abs();
    lockerVariables.longTermInitialData!.value.ltiValues.value.noOfSharesPercent.value =
        (lockerVariables.longTermInitialData!.value.ltiValues.value.noOfSharesPercent.value).abs();
    if (lockerVariables.longTermInitialData!.value.ltiValues.value.isDividendsAvailable.value) {
      for (int i = 0; i < lockerVariables.longTermInitialData!.value.dividendList.length; i++) {
        dividendDateList.add(lockerVariables.longTermInitialData!.value.dividendList[i].date.value);
      }
    } else {
      dividendDateList = [];
    }

    if (lockerVariables.longTermInitialData!.value.ltiValues.value.isDividendsAvailable.value) {
      if (lockerVariables.longTermInitialData!.value.ltiValues.value.isSplitsAvailable.value) {
        dividendDateList.add(lockerVariables.longTermInitialData!.value.selectedDate.value);
        for (int i = 0; i < lockerVariables.longTermInitialData!.value.dividendList.length; i++) {
          dividendDateList.add(lockerVariables.longTermInitialData!.value.dividendList[i].date.value);
        }
        for (int j = 0; j < lockerVariables.longTermInitialData!.value.splitsList.length; j++) {
          splitDateList.add(lockerVariables.longTermInitialData!.value.splitsList[j].splitDate.value);
        }
        for (int j = 0; j < dividendDateList.length - 1; j++) {
          for (int i = 0; i < splitDateList.length; i++) {
            if (splitDateList[i].isAfter(dividendDateList[j]) && splitDateList[i].isBefore(dividendDateList[j + 1])) {
              dividendValuesList.add((lockerVariables.longTermInitialData!.value.purchaseValue.value /
                      lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value) *
                  (lockerVariables.longTermInitialData!.value.splitsList[i].newShares.value /
                      lockerVariables.longTermInitialData!.value.splitsList[i].oldShares.value) *
                  lockerVariables.longTermInitialData!.value.dividendList[j].value.value);
            }
          }
        }
        if (dividendValuesList.length > 1) {
          lockerVariables.longTermInitialData!.value.ltiValues.value.totalDividendEarnings.value =
              dividendValuesList.reduce((a, b) => a + b);
        } else if (dividendValuesList.length == 1) {
          lockerVariables.longTermInitialData!.value.ltiValues.value.totalDividendEarnings.value = dividendValuesList[0];
        } else {
          lockerVariables.longTermInitialData!.value.ltiValues.value.totalDividendEarnings.value = 0.0;
        }
      } else {
        for (int j = 0; j < dividendDateList.length; j++) {
          dividendValuesList.add((lockerVariables.longTermInitialData!.value.purchaseValue.value /
                  lockerVariables.longTermInitialData!.value.purchaseDateCloseValue.value) *
              lockerVariables.longTermInitialData!.value.dividendList[j].value.value);
        }

        if (dividendValuesList.length > 1) {
          lockerVariables.longTermInitialData!.value.ltiValues.value.totalDividendEarnings.value =
              dividendValuesList.reduce((a, b) => a + b);
        } else if (dividendValuesList.length == 1) {
          lockerVariables.longTermInitialData!.value.ltiValues.value.totalDividendEarnings.value = dividendValuesList[0];
        } else {
          lockerVariables.longTermInitialData!.value.ltiValues.value.totalDividendEarnings.value = 0.0;
        }
      }
    } else {
      lockerVariables.longTermInitialData!.value.ltiValues.value.totalDividendEarnings.value = 0.0;
    }
  }

  chartsAPIFunction() async {
    lockerVariables.longTermChartDataList.clear();
    List<int> valueYList = [];
    String url = baseurl + chartTickerRange;
    var response = await dioMain.post(url, options: Options(headers: {"Authorization": kToken}), data: {
      "ticker_id": lockerVariables.longTermInitialData!.value.tickerId.value,
      "date_start": DateFormat("yyyy-MM-dd").format(lockerVariables.longTermInitialData!.value.selectedDate.value)
    });
    LtiTickerDataChartValuesModel chartData = LtiTickerDataChartValuesModel.fromJson(response.data);
    for (int i = 0; i < chartData.response.length; i++) {
      lockerVariables.longTermChartDataList
          .add(ChartData(x: chartData.response[i].createdTime, y: chartData.response[i].close));
      valueYList.add(chartData.response[i].close);
    }
    valueYList.sort();
    lockerVariables.minXValue.value = DateTime.now().subtract(
        Duration(days: (DateTime.now().difference(lockerVariables.longTermInitialData!.value.selectedDate.value)).inDays));
    lockerVariables.minYValue.value = (valueYList[0] - (valueYList[0] / 10)).toInt();
    lockerVariables.maxXValue.value = DateTime.now();
    lockerVariables.maxYValue.value = (valueYList[valueYList.length - 1] + (valueYList[valueYList.length - 1] / 10)).toInt();
  }
}

class ChartData {
  ChartData({required this.x, required this.y});

  final DateTime x;
  final int? y;

  ChartData.fromJson(Map<String, dynamic> json)
      : x = json['x'],
        y = json['y'];

  Map<String, dynamic> toJson() {
    return {'x': x, 'y': y};
  }

  @override
  String toString() {
    return "ChartData(x:$x,y:$y)";
  }
}
