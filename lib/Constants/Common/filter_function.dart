import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/API.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class FilterFunction {
  String mainUserToken = "";
  Map<String, dynamic> data = {};
  Map<String, dynamic> dataUpdate = {};

  getAddFilter({
    required String type,
    required String title,
    required String cid,
    required String exc,
    required List indus,
    required List tickers,
    required bool allIndus,
    required bool allTickers,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == "stocks") {
      data = {
        "type": type,
        "title": title,
        "category_id": cid,
        "exchange": exc,
        "industries": indus,
        "allindustries": allIndus,
        "alltickers": allTickers,
        "tickers": tickers
      };
    } else if (type == "crypto") {
      data = {"type": type, "title": title, "category_id": cid, "industries": indus, "alltickers": allTickers, "tickers": tickers};
    } else if (type == "commodity") {
      data = {"type": type, "title": title, "category_id": cid, "country": exc, "alltickers": allTickers, "tickers": tickers};
    } else {
      data = {"type": type, "title": title, "category_id": cid, "alltickers": allTickers, "tickers": tickers};
    }
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionLocker + addFilter;
    var response = await dioMain.post(url,
        data: data,
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      return responseData;
    } else {
      return responseData;
    }
  }

  getDeleteFilter({required String filterId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionLocker + deleteFilter;
    await dioMain.post(url,
        data: {"filter_id": filterId},
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
  }

  Future<dynamic> getEditFilter({required String filterId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionLocker + editFilter;
    var response = await dioMain.post(url,
        data: {"filter_id": filterId},
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    return responseData;
  }

  getUpdateFilter(
      {required String filterId,
      required String type,
      required String title,
      required String cid,
      required String exc,
      required List indus,
      required bool allIndus,
      required bool allTickers,
      required List tickers}) async {
    if (type == "stocks") {
      dataUpdate = {
        "filter_id": filterId,
        "type": type,
        "title": title,
        "category_id": cid,
        "exchange": exc,
        "industries": indus,
        "allindustries": allIndus,
        "alltickers": allTickers,
        "tickers": tickers
      };
    } else if (type == "crypto") {
      dataUpdate = {
        "filter_id": filterId,
        "type": type,
        "title": title,
        "category_id": cid,
        "industries": indus,
        "alltickers": allTickers,
        "tickers": tickers
      };
    } else if (type == "commodity") {
      dataUpdate = {
        "filter_id": filterId,
        "type": type,
        "title": title,
        "category_id": cid,
        "country": exc,
        "alltickers": allTickers,
        "tickers": tickers
      };
    } else {
      dataUpdate = {"filter_id": filterId, "type": type, "title": title, "category_id": cid, "alltickers": allTickers, "tickers": tickers};
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionLocker + updateFilter;
    var response = await dioMain.post(url,
        data: dataUpdate,
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      return responseData;
    } else {
      return responseData;
    }
  }
}
