import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module5/TickerDetail/tickers_details_page.dart';

import 'LockerEssentialModels/exchange_list_model.dart';
import 'LockerEssentialModels/locker_dividend_essential_model.dart';
import 'LockerEssentialModels/locker_dividend_history_model.dart';
import 'LockerEssentialModels/locker_essential_model_file.dart';
import 'LockerEssentialModels/locker_ipo_essential_model.dart';
import 'LockerEssentialModels/locker_split_essential_model.dart';

class LockerEssentialApiFunctions {
  lockerEssentialData({
    required BuildContext context,
    required String skipCount,
    required String title,
    StateSetter? modelSetState,
  }) async {
    lockerVariables.lockerEssentialResponseList = RxList<LockerEssentialResponse>([]);
    lockerVariables.lockerIpoEssentialResponseList = RxList<LockerIpoEssentialResponse>([]);
    lockerVariables.lockerSplitEssentialResponseList = RxList<LockerSplitEssentialResponse>([]);
    lockerVariables.lockerDividendEssentialResponseList = RxList<LockerDividendEssentialResponse>([]);
    lockerVariables.titleRowMain = RxList<Widget>([]);
    lockerVariables.matrixDataMain = RxList<List<String>>([]);
    var url = title == "ipo"
        ? baseurl + versionEconomic + ipoCalenderList
        : title == "dividend"
            ? baseurl + versionEconomic + dividendsList
            : title == "split"
                ? baseurl + versionEconomic + splitCalenderList
                : baseurl + versionEconomic + calenderList;
    Map<String, dynamic> data = title == "ipo"
        ? {
            "report_date": lockerVariables.selectedDateTime.value.toString(),
            "search": lockerVariables.searchEssentialControllerMain.value.text,
            "exchange": lockerVariables.selectedCategory.value == "general"
                ? lockerVariables.selectedCategory.value
                : lockerVariables.selectedCategory.value.toUpperCase(),
            "industry": lockerVariables.selectedIndustriesListMain,
            "date_type": lockerVariables.selectedPeriod.value,
            "ipo_type": lockerVariables.selectedIPOSlugType.value,
            "sort": lockerVariables.selectedSortValue,
            "skip": skipCount,
            "limit": 8,
          }
        : title == "dividend"
            ? {
                "report_date": lockerVariables.selectedDateTime.value.toString(),
                "search": lockerVariables.searchEssentialControllerMain.value.text,
                "exchange": lockerVariables.selectedCategory.value == "general"
                    ? lockerVariables.selectedCategory.value
                    : lockerVariables.selectedCategory.value.toUpperCase(),
                "industry": lockerVariables.selectedIndustriesListMain,
                "date_type": lockerVariables.selectedPeriod.value,
                "sort": lockerVariables.selectedSortValue,
                "skip": skipCount,
                "limit": 8,
              }
            : title == "split"
                ? {
                    "report_date": lockerVariables.selectedDateTime.value.toString(),
                    "search": lockerVariables.searchEssentialControllerMain.value.text,
                    "exchange": lockerVariables.selectedCategory.value == "general"
                        ? lockerVariables.selectedCategory.value
                        : lockerVariables.selectedCategory.value.toUpperCase(),
                    "industry": lockerVariables.selectedIndustriesListMain,
                    "date_type": lockerVariables.selectedPeriod.value,
                    "sort": lockerVariables.selectedSortValue,
                    "skip": skipCount,
                    "limit": 8,
                  }
                : {
                    "report_date": lockerVariables.selectedDateTime.value.toString(),
                    "search": lockerVariables.searchEssentialControllerMain.value.text,
                    "exchange": lockerVariables.selectedCategory.value == "general"
                        ? lockerVariables.selectedCategory.value
                        : lockerVariables.selectedCategory.value.toUpperCase(),
                    "industry": lockerVariables.selectedIndustriesListMain,
                    "date_type": lockerVariables.selectedPeriod.value,
                    "sort": lockerVariables.selectedSortValue,
                    "skip": skipCount,
                    "limit": 8,
                  };
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: data);
    var responseData = response.data;
    if (title == "ipo") {
      lockerVariables.lockerIPOEssentials = (LockerIpoEssentialModel.fromJson(responseData)).obs;
      lockerVariables.lockerIPOEssentials!.refresh();
      lockerVariables.lockerIpoEssentialResponseList.addAll(lockerVariables.lockerIPOEssentials!.value.response);
      lockerVariables.lockerIpoEssentialResponseList.refresh();
      for (final item in lockerVariables.lockerIpoEssentialResponseList) {
        lockerVariables.titleRowMain.add(GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'stocks',
                id: item.tickerId,
                exchange: 'NSE',
                country: "India",
                name: item.name,
                fromWhere: '',
              );
            }));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(item.logoUrl),
                      fit: BoxFit.fill,
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      item.code,
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 10, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
        lockerVariables.titleRowMain.refresh();
        lockerVariables.matrixDataMain.add([
          "${item.exchange == "NSE" || item.exchange == "BSE" ? "\u{20B9}" : "\$"} ${item.offerPrice}",
          item.shares.toString(),
          item.dealType,
          item.startDate,
          item.filingDate,
          item.amendedDate,
          item.priceFrom.toString(),
          item.priceTo.toString(),
        ]);
        lockerVariables.matrixDataMain.refresh();
      }
    } else if (title == "dividend") {
      lockerVariables.lockerDividendEssentials = (LockerDividendEssentialModel.fromJson(responseData)).obs;
      lockerVariables.lockerDividendEssentials!.refresh();
      lockerVariables.lockerDividendEssentialResponseList.addAll(lockerVariables.lockerDividendEssentials!.value.response);
      lockerVariables.lockerDividendEssentialResponseList.refresh();

      for (final item in lockerVariables.lockerDividendEssentialResponseList) {
        lockerVariables.titleRowMain.add(GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'stocks',
                id: item.tickerId,
                exchange: 'NSE',
                country: "India",
                name: item.name,
                fromWhere: '',
              );
            }));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(item.logoUrl),
                      fit: BoxFit.fill,
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      item.code,
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 10, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
        lockerVariables.titleRowMain.refresh();
        lockerVariables.matrixDataMain.add([
          item.year,
          item.date,
          item.industry,
          "${item.exchange == "NSE" || item.exchange == "BSE" ? "\u{20B9}" : "\$"} ${item.value}",
          item.watchlist.toString(),
          item.tickerId,
        ]);
        lockerVariables.matrixDataMain.refresh();
      }
    } else if (title == "split") {
      lockerVariables.lockerSplitEssentials = (LockerSplitEssentialModel.fromJson(responseData)).obs;
      lockerVariables.lockerSplitEssentials!.refresh();
      lockerVariables.lockerSplitEssentialResponseList.addAll(lockerVariables.lockerSplitEssentials!.value.response);
      lockerVariables.lockerSplitEssentialResponseList.refresh();

      for (final item in lockerVariables.lockerSplitEssentialResponseList) {
        lockerVariables.titleRowMain.add(GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'stocks',
                id: item.tickerId,
                exchange: 'NSE',
                country: "India",
                name: item.name,
                fromWhere: '',
              );
            }));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(item.logoUrl),
                      fit: BoxFit.fill,
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      item.code,
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 10, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
        lockerVariables.titleRowMain.refresh();
        lockerVariables.matrixDataMain.add([
          item.splitDate,
          item.industry,
          item.optionable,
          item.oldShares.toString(),
          item.newShares.toString(),
        ]);
        lockerVariables.matrixDataMain.refresh();
      }
    } else {
      lockerVariables.lockerEssentials = (LockerEssentialModel.fromJson(responseData)).obs;
      lockerVariables.lockerEssentials!.refresh();
      lockerVariables.lockerEssentialResponseList.addAll(lockerVariables.lockerEssentials!.value.response);
      lockerVariables.lockerEssentialResponseList.refresh();
      for (final item in lockerVariables.lockerEssentialResponseList) {
        lockerVariables.titleRowMain.add(GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return TickersDetailsPage(
                category: 'stocks',
                id: item.tickerId,
                exchange: 'NSE',
                country: "India",
                name: item.name,
                fromWhere: '',
              );
            }));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(item.logoUrl),
                      fit: BoxFit.fill,
                    )),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      item.code,
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 10, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
        lockerVariables.matrixDataMain.add([
          item.reportDate,
          item.industry,
          "${item.exchange == "NSE" || item.exchange == "BSE" ? "\u{20B9}" : "\$"} ${item.actual}",
          "${item.exchange == "NSE" || item.exchange == "BSE" ? "\u{20B9}" : "\$"} ${item.estimate}",
          "${item.exchange == "NSE" || item.exchange == "BSE" ? "\u{20B9}" : "\$"} ${item.difference}",
          "${item.percent} %",
          item.beforeAfterMarket,
          item.watchlist.toString(),
        ]);
        lockerVariables.titleRowMain.refresh();
        lockerVariables.matrixDataMain.refresh();
      }
    }
    if (modelSetState != null) {
      modelSetState(() {});
    }
  }

  lockerExtensionTableEssentialData({
    required BuildContext context,
    required String skipCount,
    required String industry,
    required String name,
    required String code,
    required String logoUrl,
    required String tickerId,
    required String dividendId,
    required StateSetter modelSetState,
  }) async {
    lockerVariables.lockerDividendHistoryResponseList = RxList<LockerDividendHistoryResponse>([]);
    var url = baseurl + versionEconomic + dividendsHistory;
    Map<String, dynamic> data = {
      "ticker_id": tickerId,
      "dividend_id": dividendId,
      "skip": skipCount,
      "limit": 8,
    };

    var response = await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: data);
    var responseData = response.data;

    lockerVariables.lockerDividendHistory = (LockerDividendHistoryModel.fromJson(responseData)).obs;
    lockerVariables.lockerDividendHistory!.refresh();
    lockerVariables.lockerDividendHistoryResponseList.addAll(lockerVariables.lockerDividendHistory!.value.response);
    lockerVariables.lockerDividendHistoryResponseList.refresh();
    for (final item in lockerVariables.lockerDividendHistoryResponseList) {
      lockerVariables.titleDividendsHistoryRowMain.add(GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return TickersDetailsPage(
              category: 'stocks',
              id: tickerId,
              exchange: 'NSE',
              country: "India",
              name: name,
              fromWhere: '',
            );
          }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(logoUrl),
                    fit: BoxFit.fill,
                  )),
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                  ),
                  Text(
                    code,
                    maxLines: 1,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 10, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
      lockerVariables.matrixDividendsHistoryDataMain.add([
        item.year,
        item.date,
        industry,
        item.value.toString(),
      ]);
      lockerVariables.titleRowMain.refresh();
      lockerVariables.matrixDataMain.refresh();
    }
    modelSetState(() {});
  }

  getIndustries({required String skipCount}) async {
    if (skipCount == "0") {
      lockerVariables.industriesListMain.clear();
    }
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: {
          'type': "stocks",
          'search': lockerVariables.searchIndustriesBottomSheetControllerMain.value.text,
          'skip': skipCount,
          'exchange': "625e59ec49d900f6585bc683",
          'limit': 20,
        },
        options: Options(
          headers: {'Authorization': kToken},
        ));
    Map<String, dynamic> responseData = response.data;
    if (responseData["status"]) {
      ExchangesListModel industries = ExchangesListModel.fromJson(responseData);
      List<ExchangesListResponse> industriesList = [];
      industriesList.addAll(industries.response);
      if (lockerVariables.selectedIndustriesListMain.isNotEmpty) {
        for (int i = 0; i < industriesList.length; i++) {
          if (lockerVariables.selectedIndustriesListMain.contains(industriesList[i].id)) {
            industriesList[i].isChecked = true;
            lockerVariables.industriesListMain.insert(0, industriesList[i]);
          } else {
            industriesList[i].isChecked = false;
            lockerVariables.industriesListMain.add(industriesList[i]);
          }
        }
      } else {
        lockerVariables.industriesListMain.addAll(industries.response);
      }
    }
  }
}
