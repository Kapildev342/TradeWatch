import 'package:flutter/material.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/videos_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/coming_soon_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_request_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_page.dart';
import 'package:tradewatchfinal/Screens/Module3/locker_skip_screen.dart';
import 'package:tradewatchfinal/Screens/Module4/LTICalculator/lti_calculator_page.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerCalculatorScreen/calculator_page.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerEssentialPage/locker_essentials_page.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/final_chart_page.dart';
import 'package:tradewatchfinal/Screens/Module5/super_charts_page.dart';

import 'locker_screen_model.dart';

class LockerScreenFunctions {
  filterSearchResults({required String query}) async {
    List<ResponseList> dummySearchList = [];
    List<ResponseList> dummySearchList1 = [];
    List<ResponseList> dummySearchList2 = [];
    List<ResponseList> dummySearchList3 = [];
    dummySearchList.addAll(lockerVariables.lockerBuzzListMain);
    dummySearchList1.addAll(lockerVariables.lockerEssentialsListMain);
    dummySearchList2.addAll(lockerVariables.lockerCommunityListMain);
    dummySearchList3.addAll(lockerVariables.lockerServicesListMain);
    if (query.isNotEmpty) {
      List<ResponseList> dummyListData = [];
      List<ResponseList> dummyListData1 = [];
      List<ResponseList> dummyListData2 = [];
      List<ResponseList> dummyListData3 = [];
      for (var item in dummySearchList) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      for (var item in dummySearchList1) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData1.add(item);
        }
      }
      for (var item in dummySearchList2) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData2.add(item);
        }
      }
      for (var item in dummySearchList3) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData3.add(item);
        }
      }
      lockerVariables.lockerBuzzList.clear();
      lockerVariables.lockerEssentialsList.clear();
      lockerVariables.lockerCommunityList.clear();
      lockerVariables.lockerServicesList.clear();
      lockerVariables.lockerBuzzList.addAll(dummyListData);
      lockerVariables.lockerEssentialsList.addAll(dummyListData1);
      lockerVariables.lockerCommunityList.addAll(dummyListData2);
      lockerVariables.lockerServicesList.addAll(dummyListData3);
    } else {
      lockerVariables.lockerBuzzList.clear();
      lockerVariables.lockerEssentialsList.clear();
      lockerVariables.lockerCommunityList.clear();
      lockerVariables.lockerServicesList.clear();
      lockerVariables.lockerBuzzList.addAll(dummySearchList);
      lockerVariables.lockerEssentialsList.addAll(dummySearchList1);
      lockerVariables.lockerCommunityList.addAll(dummySearchList2);
      lockerVariables.lockerServicesList.addAll(dummySearchList3);
    }
  }

  filterChartSearchResults({required String query}) async {
    List<ResponseList> dummySearchList = [];
    List<ResponseList> dummySearchList1 = [];
    List<ResponseList> dummySearchList2 = [];
    List<ResponseList> dummySearchList3 = [];
    List<ResponseList> dummySearchList4 = [];
    List<ResponseList> dummySearchList5 = [];
    dummySearchList.addAll(lockerVariables.chartsTrendListMain);
    dummySearchList1.addAll(lockerVariables.chartsVolatilityListMain);
    dummySearchList2.addAll(lockerVariables.chartsBasicListMain);
    dummySearchList3.addAll(lockerVariables.chartsPatternListMain);
    dummySearchList4.addAll(lockerVariables.chartsComparisonListMain);
    dummySearchList5.addAll(lockerVariables.chartsRequestListMain);
    if (query.isNotEmpty) {
      List<ResponseList> dummyListData = [];
      List<ResponseList> dummyListData1 = [];
      List<ResponseList> dummyListData2 = [];
      List<ResponseList> dummyListData3 = [];
      List<ResponseList> dummyListData4 = [];
      List<ResponseList> dummyListData5 = [];
      for (var item in dummySearchList) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      for (var item in dummySearchList1) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData1.add(item);
        }
      }
      for (var item in dummySearchList2) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData2.add(item);
        }
      }
      for (var item in dummySearchList3) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData3.add(item);
        }
      }
      for (var item in dummySearchList4) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData4.add(item);
        }
      }
      for (var item in dummySearchList5) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData5.add(item);
        }
      }
      lockerVariables.chartsTrendList.clear();
      lockerVariables.chartsVolatilityList.clear();
      lockerVariables.chartsBasicList.clear();
      lockerVariables.chartsPatternList.clear();
      lockerVariables.chartsComparisonList.clear();
      lockerVariables.chartsRequestList.clear();
      lockerVariables.chartsTrendList.addAll(dummyListData);
      lockerVariables.chartsVolatilityList.addAll(dummyListData1);
      lockerVariables.chartsBasicList.addAll(dummyListData2);
      lockerVariables.chartsPatternList.addAll(dummyListData3);
      lockerVariables.chartsComparisonList.addAll(dummyListData4);
      lockerVariables.chartsRequestList.addAll(dummyListData5);
    } else {
      lockerVariables.chartsTrendList.clear();
      lockerVariables.chartsVolatilityList.clear();
      lockerVariables.chartsBasicList.clear();
      lockerVariables.chartsPatternList.clear();
      lockerVariables.chartsComparisonList.clear();
      lockerVariables.chartsRequestList.clear();
      lockerVariables.chartsTrendList.addAll(dummySearchList);
      lockerVariables.chartsVolatilityList.addAll(dummySearchList1);
      lockerVariables.chartsBasicList.addAll(dummySearchList2);
      lockerVariables.chartsPatternList.addAll(dummySearchList3);
      lockerVariables.chartsComparisonList.addAll(dummySearchList4);
      lockerVariables.chartsRequestList.addAll(dummySearchList5);
    }
  }

  navigationFunction({required BuildContext context, required String name}) async {
    switch (name.toLowerCase()) {
      case "news":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return NewsMainPage(fromCompare: false, text: finalisedCategory, tickerId: "", tickerName: "");
          }));
          break;
        }
      case "videos":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return VideosMainPage(fromCompare: false, text: finalisedCategory, tickerId: "", tickerName: "");
          }));
          break;
        }
      case "charts":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const MainBottomNavigationPage(
                caseNo1: 4, text: "", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true);
          }));
          break;
        }
      case "forum":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return mainSkipValue ? const LockerSkipScreen() : ForumPage(text: finalisedCategory);
          }));
          break;
        }
      case "survey":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return mainSkipValue ? const LockerSkipScreen() : SurveyPage(text: finalisedCategory);
          }));
          break;
        }
      case "earning":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return LockerEssentialsPage(
              title: name.toLowerCase(),
            );
          }));
          break;
        }
      case "ipo":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return LockerEssentialsPage(
              title: name.toLowerCase(),
            );
          }));
          break;
        }
      case "splits":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const LockerEssentialsPage(title: "split");
          }));
          break;
        }
      case "dividends":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const LockerEssentialsPage(title: "dividend");
          }));
          break;
        }
      case "lti":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const LTICalculatorPage();
          }));
          break;
        }
      case "calculator":
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const CalculatorPage();
          }));
          break;
        }
      default:
        {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const ComingSoonPage();
          }));
          /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const Payment();
          }));*/
          break;
        }
    }
  }

  navigationChartsFunction({
    required BuildContext context,
    required String name,
    required String id,
    required String exchangeName,
    required String defaultTvSymbol,
    required String tvSym1,
    required String tvSym2,
    required String defaultFilterId,
    required String defaultFilterId1,
    required String secondaryFilterId,
    required String secondaryFilterId1,
  }) async {
    Future.delayed(const Duration(seconds: 1), () {
      int chartValue = int.parse(id);
      if (name == 'Request') {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const FeatureRequestPage()));
      } else {
        if (finalisedFilterId != "" && chartValue > 6 && finalisedCategory.toLowerCase() == "stocks") {
          if (exchangeName == "NSE" || exchangeName == "INDX") {
            if (defaultTvSymbol != "") {
              String webLink =
                  "https://www.tradingview.com/chart/?symbol=$tvSym1%3A$tvSym2&utm_source=www.tradingview.com&utm_medium=widget&utm_campaign=chart&utm_term=$tvSym1%3A$tvSym2";
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SuperChartsPage(url: webLink);
              }));
            }
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => FinalChartPage(
                          tickerId: finalisedFilterId == ""
                              ? finalisedCategory.toLowerCase() == 'stocks'
                                  ? chartValue < 6
                                      ? defaultFilterId
                                      : defaultFilterId1
                                  : defaultFilterId
                              : defaultFilterId,
                          secTickerId: finalisedFilterId == ""
                              ? finalisedCategory.toLowerCase() == 'stocks'
                                  ? chartValue < 6
                                      ? secondaryFilterId
                                      : secondaryFilterId1
                                  : secondaryFilterId
                              : secondaryFilterId,
                          category: finalisedCategory.toLowerCase(),
                          exchange: finalisedFilterId != ""
                              ? exchangeName
                              : finalisedCategory.toLowerCase() == 'stocks'
                                  ? chartValue < 6
                                      ? "NSE"
                                      : "BSE"
                                  : "",
                          chartType: id,
                          index: 0,
                        )));
          }
        } else if (finalisedFilterId == "" && chartValue > 6 && finalisedCategory.toLowerCase() == "commodity") {
          if (defaultTvSymbol != "") {
            String webLink =
                "https://www.tradingview.com/chart/?symbol=$tvSym1%3A$tvSym2&utm_source=www.tradingview.com&utm_medium=widget&utm_campaign=chart&utm_term=$tvSym1%3A$tvSym2";
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SuperChartsPage(url: webLink);
            }));
          } else {}
        } else if (finalisedFilterId != "" && chartValue > 6) {
          if (finalisedCategory.toLowerCase() == "commodity") {
            if (defaultTvSymbol != "") {
              String webLink =
                  "https://www.tradingview.com/chart/?symbol=$tvSym1%3A$tvSym2&utm_source=www.tradingview.com&utm_medium=widget&utm_campaign=chart&utm_term=$tvSym1%3A$tvSym2";
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SuperChartsPage(url: webLink);
              }));
            } else {
              String webLink =
                  "https://www.tradingview.com/chart/?symbol=$tvSym1%3A$tvSym2&utm_source=www.tradingview.com&utm_medium=widget&utm_campaign=chart&utm_term=$tvSym1%3A$tvSym2";
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SuperChartsPage(url: webLink);
              }));
            }
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => FinalChartPage(
                          tickerId: finalisedFilterId == ""
                              ? finalisedCategory.toLowerCase() == 'stocks'
                                  ? chartValue < 6
                                      ? defaultFilterId
                                      : defaultFilterId1
                                  : defaultFilterId
                              : defaultFilterId,
                          secTickerId: finalisedFilterId == ""
                              ? finalisedCategory.toLowerCase() == 'stocks'
                                  ? chartValue < 6
                                      ? secondaryFilterId
                                      : secondaryFilterId1
                                  : secondaryFilterId
                              : secondaryFilterId,
                          category: finalisedCategory.toLowerCase(),
                          exchange: finalisedFilterId != ""
                              ? exchangeName
                              : finalisedCategory.toLowerCase() == 'stocks'
                                  ? chartValue < 6
                                      ? "NSE"
                                      : "BSE"
                                  : "",
                          chartType: id,
                          index: 0,
                        )));
          }
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => FinalChartPage(
                        tickerId: finalisedFilterId == ""
                            ? finalisedCategory.toLowerCase() == 'stocks'
                                ? chartValue < 6
                                    ? defaultFilterId
                                    : defaultFilterId1
                                : defaultFilterId
                            : defaultFilterId,
                        secTickerId: finalisedFilterId == ""
                            ? finalisedCategory.toLowerCase() == 'stocks'
                                ? chartValue < 6
                                    ? secondaryFilterId
                                    : secondaryFilterId1
                                : secondaryFilterId
                            : secondaryFilterId,
                        category: finalisedCategory.toLowerCase(),
                        exchange: finalisedFilterId != ""
                            ? exchangeName
                            : finalisedCategory.toLowerCase() == 'stocks'
                                ? chartValue < 6
                                    ? "NSE"
                                    : "BSE"
                                : "",
                        chartType: id,
                        index: 0,
                      )));
        }
      }
    });
  }
}
