import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/commodity_countries_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_comments_initial_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_details_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_my_list_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_post_list_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_post_request_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_response_list_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_trending_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/crypto_industries_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/exchanges_list_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/industries_list_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/members_list_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/tickers_list_page_model.dart';

class CommunitiesFunctions {
  getData() async {
    switch (communitiesVariables.selectedCategoryForCommunity.value.slug.value) {
      case "stocks":
        {
          communitiesVariables.selectedExchangeForCommunity = (ExchangeListResponse.fromJson({
            "_id": "625e59ec49d900f6585bc683",
            "name": "NSE (India)",
            "code": "NSE",
            "OperatingMIC": "XNSE",
            "Country": "India",
            "Currency": "INR",
            "status": 1,
            "createdAt": "2022-04-19T06:42:52.216Z",
            "updatedAt": "2022-04-19T06:42:52.216Z"
          })).obs;
          communitiesVariables.selectedCryptoTypeForCommunity =
              (CryptoIndustriesResponse.fromJson({"_id": "626e72a52e4273c969ed6206", "name": "coin", "category_id": "625feb95a30e9baa6475804d"})).obs;
          communitiesVariables.selectedCountryForCommunity = (CommoditiesCountriesResponse.fromJson({"_id": "India", "name": "India"})).obs;
          communitiesVariables.industriesListForCommunity.clear();
          Map<String, dynamic> exchangeData = await communitiesFunctions.getCommunitiesEx();
          communitiesVariables.exchangeList = (ExchangeListModel.fromJson(exchangeData)).obs;
          communitiesVariables.exchangeList!.value.response
              .insert(0, ExchangeListResponse.fromJson({"_id": "", "name": "General", "code": "general"}));
          communitiesVariables.exchangeController.value.text = communitiesVariables.selectedExchangeForCommunity.value.name.value;
          communitiesVariables.industriesController.value.text = "";
          communitiesVariables.tickerController.value.text = "";
          communitiesVariables.selectedIndustriesListForCommunity = RxList<String>([]);
          communitiesVariables.selectedTickersListForCommunity = RxList<String>([]);
        }
      case "crypto":
        {
          communitiesVariables.selectedExchangeForCommunity = (ExchangeListResponse.fromJson({
            "_id": "625e59ec49d900f6585bc683",
            "name": "NSE (India)",
            "code": "NSE",
            "OperatingMIC": "XNSE",
            "Country": "India",
            "Currency": "INR",
            "status": 1,
            "createdAt": "2022-04-19T06:42:52.216Z",
            "updatedAt": "2022-04-19T06:42:52.216Z"
          })).obs;
          communitiesVariables.selectedCryptoTypeForCommunity =
              (CryptoIndustriesResponse.fromJson({"_id": "626e72a52e4273c969ed6206", "name": "coin", "category_id": "625feb95a30e9baa6475804d"})).obs;
          communitiesVariables.selectedCountryForCommunity = (CommoditiesCountriesResponse.fromJson({"_id": "India", "name": "India"})).obs;
          Map<String, dynamic> cryptoTypeData = await communitiesFunctions.getCommunitiesCryptoType();
          communitiesVariables.cryptoIndustriesList = (CryptoIndustriesModel.fromJson(cryptoTypeData)).obs;
          communitiesVariables.cryptoIndustriesList!.value.response.insert(
              0,
              CryptoIndustriesResponse.fromJson({
                "_id": "",
                "name": "General",
              }));
          communitiesVariables.cryptoTypeController.value.text = communitiesVariables.selectedCryptoTypeForCommunity.value.name.value;
          communitiesVariables.tickerController.value.text = "";
          communitiesVariables.selectedTickersListForCommunity = RxList<String>([]);
        }
      case "commodity":
        {
          communitiesVariables.selectedExchangeForCommunity = (ExchangeListResponse.fromJson({
            "_id": "625e59ec49d900f6585bc683",
            "name": "NSE (India)",
            "code": "NSE",
            "OperatingMIC": "XNSE",
            "Country": "India",
            "Currency": "INR",
            "status": 1,
            "createdAt": "2022-04-19T06:42:52.216Z",
            "updatedAt": "2022-04-19T06:42:52.216Z"
          })).obs;
          communitiesVariables.selectedCryptoTypeForCommunity =
              (CryptoIndustriesResponse.fromJson({"_id": "626e72a52e4273c969ed6206", "name": "coin", "category_id": "625feb95a30e9baa6475804d"})).obs;
          communitiesVariables.selectedCountryForCommunity = (CommoditiesCountriesResponse.fromJson({"_id": "India", "name": "India"})).obs;
          Map<String, dynamic> commodityCountriesData = {
            "status": true,
            "response": [
              {"_id": "India", "name": "India"},
              {"_id": "USA", "name": "USA"}
            ],
            "message": "Trade Watch Industry data."
          };
          communitiesVariables.commodityCountriesList = (CommodityCountriesModel.fromJson(commodityCountriesData)).obs;
          communitiesVariables.commodityCountriesList!.value.response.insert(
              0,
              CommoditiesCountriesResponse.fromJson({
                "_id": "",
                "name": "General",
              }));
          communitiesVariables.countryController.value.text = communitiesVariables.selectedCountryForCommunity.value.name.value;
          communitiesVariables.tickerController.value.text = "";
          communitiesVariables.selectedTickersListForCommunity = RxList<String>([]);
        }
      case "forex":
        {
          communitiesVariables.tickerController.value.text = "";
          communitiesVariables.selectedTickersListForCommunity = RxList<String>([]);
        }
      default:
        {
          communitiesVariables.tickerController.value.text = "";
          communitiesVariables.selectedTickersListForCommunity = RxList<String>([]);
        }
    }
  }

  getEditData() async {
    switch (communitiesVariables.selectedCategoryForCommunity.value.slug.value) {
      case "stocks":
        {
          communitiesVariables.selectedExchangeForCommunity = (ExchangeListResponse.fromJson({
            "_id": "625e59ec49d900f6585bc683",
            "name": "NSE (India)",
            "code": "NSE",
            "OperatingMIC": "XNSE",
            "Country": "India",
            "Currency": "INR",
            "status": 1,
            "createdAt": "2022-04-19T06:42:52.216Z",
            "updatedAt": "2022-04-19T06:42:52.216Z"
          })).obs;
          communitiesVariables.selectedCryptoTypeForCommunity =
              (CryptoIndustriesResponse.fromJson({"_id": "626e72a52e4273c969ed6206", "name": "coin", "category_id": "625feb95a30e9baa6475804d"})).obs;
          communitiesVariables.selectedCountryForCommunity = (CommoditiesCountriesResponse.fromJson({"_id": "India", "name": "India"})).obs;
          Map<String, dynamic> exchangeData = await communitiesFunctions.getCommunitiesEx();
          communitiesVariables.exchangeList = (ExchangeListModel.fromJson(exchangeData)).obs;
          communitiesVariables.exchangeList!.value.response
              .insert(0, ExchangeListResponse.fromJson({"_id": "", "name": "General", "code": "general"}));
          for (int i = 0; i < communitiesVariables.exchangeList!.value.response.length; i++) {
            if (communitiesVariables.exchangeList!.value.response[i].id.value == communitiesVariables.communitiesDetail!.value.response.exchangeId) {
              communitiesVariables.selectedExchangeForCommunity = (communitiesVariables.exchangeList!.value.response[i]).obs;
            }
          }
          communitiesVariables.exchangeController.value.text = communitiesVariables.selectedExchangeForCommunity.value.name.value;
          communitiesVariables.industriesListForCommunity.clear();
          communitiesVariables.selectedIndustriesListForCommunity.clear();
          Map<String, dynamic> industryDataSelected = await communitiesFunctions.getCommunitiesIndustries(skipCount: 0, isEditing: true);
          Rx<IndustriesListModel> industriesListSelected = (IndustriesListModel.fromJson(industryDataSelected)).obs;
          communitiesVariables.industriesListForCommunity = (industriesListSelected.value.response).obs;
          Map<String, dynamic> industryData = await communitiesFunctions.getCommunitiesIndustries(skipCount: 0, isEditing: false);
          Rx<IndustriesListModel> industriesList = (IndustriesListModel.fromJson(industryData)).obs;
          communitiesVariables.industriesListForCommunity.addAll(industriesList.value.response);
          communitiesVariables.selectedIndustriesListForCommunity = (communitiesVariables.communitiesDetail!.value.response.industry).obs;
          if (communitiesVariables.selectedIndustriesListForCommunity.isEmpty) {
            communitiesVariables.isIndustriesSelectedAll.value = true;
            communitiesVariables.industriesController.value.text = "Multiple";
            for (int i = 0; i < communitiesVariables.industriesListForCommunity.length; i++) {
              communitiesVariables.selectedIndustriesListForCommunity.add(communitiesVariables.industriesListForCommunity[i].id.value);
            }
          } else {
            if (communitiesVariables.selectedIndustriesListForCommunity.length > 1) {
              communitiesVariables.industriesController.value.text = "Multiple";
            } else {
              communitiesVariables.industriesController.value.text = "Single";
            }
            communitiesVariables.isIndustriesSelectedAll.value = false;
          }
          communitiesVariables.tickersListForCommunity.clear();
          communitiesVariables.selectedTickersListForCommunity.clear();
          communitiesVariables.selectedTickersListForCommunity = (communitiesVariables.communitiesDetail!.value.response.tickers).obs;
          Map<String, dynamic> tickerDataSelected = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: true);
          Rx<TickersListModel> tickersListSelected = (TickersListModel.fromJson(tickerDataSelected)).obs;
          communitiesVariables.tickersListForCommunity = (tickersListSelected.value.response).obs;
          Map<String, dynamic> tickerData = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: false);
          Rx<TickersListModel> tickersList = (TickersListModel.fromJson(tickerData)).obs;
          communitiesVariables.tickersListForCommunity.addAll(tickersList.value.response);
          if (communitiesVariables.selectedTickersListForCommunity.isEmpty) {
            communitiesVariables.isTickerSelectedAll.value = true;
            communitiesVariables.tickerController.value.text = "Multiple";
            for (int i = 0; i < communitiesVariables.tickersListForCommunity.length; i++) {
              communitiesVariables.selectedTickersListForCommunity.add(communitiesVariables.tickersListForCommunity[i].id.value);
            }
          } else {
            if (communitiesVariables.selectedTickersListForCommunity.length > 1) {
              communitiesVariables.tickerController.value.text = "Multiple";
            } else {
              communitiesVariables.tickerController.value.text = "Single";
            }
            communitiesVariables.isTickerSelectedAll.value = false;
          }
        }
      case "crypto":
        {
          communitiesVariables.selectedExchangeForCommunity = (ExchangeListResponse.fromJson({
            "_id": "625e59ec49d900f6585bc683",
            "name": "NSE (India)",
            "code": "NSE",
            "OperatingMIC": "XNSE",
            "Country": "India",
            "Currency": "INR",
            "status": 1,
            "createdAt": "2022-04-19T06:42:52.216Z",
            "updatedAt": "2022-04-19T06:42:52.216Z"
          })).obs;
          communitiesVariables.selectedCryptoTypeForCommunity =
              (CryptoIndustriesResponse.fromJson({"_id": "626e72a52e4273c969ed6206", "name": "coin", "category_id": "625feb95a30e9baa6475804d"})).obs;
          communitiesVariables.selectedCountryForCommunity = (CommoditiesCountriesResponse.fromJson({"_id": "India", "name": "India"})).obs;
          Map<String, dynamic> cryptoTypeData = await communitiesFunctions.getCommunitiesCryptoType();
          communitiesVariables.cryptoIndustriesList = (CryptoIndustriesModel.fromJson(cryptoTypeData)).obs;
          communitiesVariables.cryptoIndustriesList!.value.response.insert(
              0,
              CryptoIndustriesResponse.fromJson({
                "_id": "",
                "name": "General",
              }));
          if (communitiesVariables.communitiesDetail!.value.response.industry.isEmpty) {
            communitiesVariables.selectedCryptoTypeForCommunity = (communitiesVariables.cryptoIndustriesList!.value.response[0]).obs;
            communitiesVariables.cryptoTypeController.value.text = communitiesVariables.selectedCryptoTypeForCommunity.value.name.value;
          } else {
            for (int i = 0; i < communitiesVariables.cryptoIndustriesList!.value.response.length; i++) {
              if (communitiesVariables.cryptoIndustriesList!.value.response[i].id.value ==
                  communitiesVariables.communitiesDetail!.value.response.industry[0]) {
                communitiesVariables.selectedCryptoTypeForCommunity = (communitiesVariables.cryptoIndustriesList!.value.response[i]).obs;
                communitiesVariables.cryptoTypeController.value.text = communitiesVariables.selectedCryptoTypeForCommunity.value.name.value;
              }
            }
          }
          communitiesVariables.tickersListForCommunity.clear();
          communitiesVariables.selectedTickersListForCommunity.clear();
          communitiesVariables.selectedTickersListForCommunity = (communitiesVariables.communitiesDetail!.value.response.tickers).obs;
          Map<String, dynamic> tickerDataSelected = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: true);
          Rx<TickersListModel> tickersListSelected = (TickersListModel.fromJson(tickerDataSelected)).obs;
          communitiesVariables.tickersListForCommunity = (tickersListSelected.value.response).obs;
          Map<String, dynamic> tickerData = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: false);
          Rx<TickersListModel> tickersList = (TickersListModel.fromJson(tickerData)).obs;
          communitiesVariables.tickersListForCommunity.addAll(tickersList.value.response);
          if (communitiesVariables.selectedTickersListForCommunity.isEmpty) {
            communitiesVariables.isTickerSelectedAll.value = true;
            communitiesVariables.tickerController.value.text = "Multiple";
            for (int i = 0; i < communitiesVariables.tickersListForCommunity.length; i++) {
              communitiesVariables.selectedTickersListForCommunity.add(communitiesVariables.tickersListForCommunity[i].id.value);
            }
          } else {
            if (communitiesVariables.selectedTickersListForCommunity.length > 1) {
              communitiesVariables.tickerController.value.text = "Multiple";
            } else {
              communitiesVariables.tickerController.value.text = "Single";
            }
            communitiesVariables.isTickerSelectedAll.value = false;
          }
        }
      case "commodity":
        {
          communitiesVariables.selectedExchangeForCommunity = (ExchangeListResponse.fromJson({
            "_id": "625e59ec49d900f6585bc683",
            "name": "NSE (India)",
            "code": "NSE",
            "OperatingMIC": "XNSE",
            "Country": "India",
            "Currency": "INR",
            "status": 1,
            "createdAt": "2022-04-19T06:42:52.216Z",
            "updatedAt": "2022-04-19T06:42:52.216Z"
          })).obs;
          communitiesVariables.selectedCryptoTypeForCommunity =
              (CryptoIndustriesResponse.fromJson({"_id": "626e72a52e4273c969ed6206", "name": "coin", "category_id": "625feb95a30e9baa6475804d"})).obs;
          communitiesVariables.selectedCountryForCommunity = (CommoditiesCountriesResponse.fromJson({"_id": "India", "name": "India"})).obs;
          Map<String, dynamic> commodityCountriesData = {
            "status": true,
            "response": [
              {"_id": "India", "name": "India"},
              {"_id": "USA", "name": "USA"}
            ],
            "message": "Trade Watch Industry data."
          };
          communitiesVariables.commodityCountriesList = (CommodityCountriesModel.fromJson(commodityCountriesData)).obs;
          communitiesVariables.commodityCountriesList!.value.response
              .insert(0, CommoditiesCountriesResponse.fromJson({"_id": "", "name": "General"}));
          if (communitiesVariables.communitiesDetail!.value.response.country == "") {
            communitiesVariables.selectedCountryForCommunity = (communitiesVariables.commodityCountriesList!.value.response[0]).obs;
            communitiesVariables.countryController.value.text = communitiesVariables.selectedCountryForCommunity.value.name.value;
          } else {
            for (int i = 0; i < communitiesVariables.commodityCountriesList!.value.response.length; i++) {
              if (communitiesVariables.commodityCountriesList!.value.response[i].id.value ==
                  communitiesVariables.communitiesDetail!.value.response.country) {
                communitiesVariables.selectedCountryForCommunity = (communitiesVariables.commodityCountriesList!.value.response[i]).obs;
                communitiesVariables.countryController.value.text = communitiesVariables.selectedCountryForCommunity.value.name.value;
              }
            }
          }
          communitiesVariables.tickersListForCommunity.clear();
          communitiesVariables.selectedTickersListForCommunity.clear();
          communitiesVariables.selectedTickersListForCommunity = (communitiesVariables.communitiesDetail!.value.response.tickers).obs;
          Map<String, dynamic> tickerDataSelected = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: true);
          Rx<TickersListModel> tickersListSelected = (TickersListModel.fromJson(tickerDataSelected)).obs;
          communitiesVariables.tickersListForCommunity = (tickersListSelected.value.response).obs;
          Map<String, dynamic> tickerData = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: false);
          Rx<TickersListModel> tickersList = (TickersListModel.fromJson(tickerData)).obs;
          communitiesVariables.tickersListForCommunity.addAll(tickersList.value.response);
          if (communitiesVariables.selectedTickersListForCommunity.isEmpty) {
            communitiesVariables.isTickerSelectedAll.value = true;
            communitiesVariables.tickerController.value.text = "Multiple";
            for (int i = 0; i < communitiesVariables.tickersListForCommunity.length; i++) {
              communitiesVariables.selectedTickersListForCommunity.add(communitiesVariables.tickersListForCommunity[i].id.value);
            }
          } else {
            if (communitiesVariables.selectedTickersListForCommunity.length > 1) {
              communitiesVariables.tickerController.value.text = "Multiple";
            } else {
              communitiesVariables.tickerController.value.text = "Single";
            }
            communitiesVariables.isTickerSelectedAll.value = false;
          }
        }
      case "forex":
        {
          communitiesVariables.selectedExchangeForCommunity = (ExchangeListResponse.fromJson({
            "_id": "625e59ec49d900f6585bc683",
            "name": "NSE (India)",
            "code": "NSE",
            "OperatingMIC": "XNSE",
            "Country": "India",
            "Currency": "INR",
            "status": 1,
            "createdAt": "2022-04-19T06:42:52.216Z",
            "updatedAt": "2022-04-19T06:42:52.216Z"
          })).obs;
          communitiesVariables.selectedCryptoTypeForCommunity =
              (CryptoIndustriesResponse.fromJson({"_id": "626e72a52e4273c969ed6206", "name": "coin", "category_id": "625feb95a30e9baa6475804d"})).obs;
          communitiesVariables.selectedCountryForCommunity = (CommoditiesCountriesResponse.fromJson({"_id": "India", "name": "India"})).obs;
          communitiesVariables.tickersListForCommunity.clear();
          communitiesVariables.selectedTickersListForCommunity.clear();
          communitiesVariables.selectedTickersListForCommunity = (communitiesVariables.communitiesDetail!.value.response.tickers).obs;
          Map<String, dynamic> tickerDataSelected = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: true);
          Rx<TickersListModel> tickersListSelected = (TickersListModel.fromJson(tickerDataSelected)).obs;
          communitiesVariables.tickersListForCommunity = (tickersListSelected.value.response).obs;
          Map<String, dynamic> tickerData = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: false);
          Rx<TickersListModel> tickersList = (TickersListModel.fromJson(tickerData)).obs;
          communitiesVariables.tickersListForCommunity.addAll(tickersList.value.response);
          if (communitiesVariables.selectedTickersListForCommunity.isEmpty) {
            communitiesVariables.isTickerSelectedAll.value = true;
            communitiesVariables.tickerController.value.text = "Multiple";
            for (int i = 0; i < communitiesVariables.tickersListForCommunity.length; i++) {
              communitiesVariables.selectedTickersListForCommunity.add(communitiesVariables.tickersListForCommunity[i].id.value);
            }
          } else {
            if (communitiesVariables.selectedTickersListForCommunity.length > 1) {
              communitiesVariables.tickerController.value.text = "Multiple";
            } else {
              communitiesVariables.tickerController.value.text = "Single";
            }
            communitiesVariables.isTickerSelectedAll.value = false;
          }
        }
      default:
        {
          communitiesVariables.selectedExchangeForCommunity = (ExchangeListResponse.fromJson({
            "_id": "625e59ec49d900f6585bc683",
            "name": "NSE (India)",
            "code": "NSE",
            "OperatingMIC": "XNSE",
            "Country": "India",
            "Currency": "INR",
            "status": 1,
            "createdAt": "2022-04-19T06:42:52.216Z",
            "updatedAt": "2022-04-19T06:42:52.216Z"
          })).obs;
          communitiesVariables.selectedCryptoTypeForCommunity =
              (CryptoIndustriesResponse.fromJson({"_id": "626e72a52e4273c969ed6206", "name": "coin", "category_id": "625feb95a30e9baa6475804d"})).obs;
          communitiesVariables.selectedCountryForCommunity = (CommoditiesCountriesResponse.fromJson({"_id": "India", "name": "India"})).obs;
          communitiesVariables.tickersListForCommunity.clear();
          communitiesVariables.selectedTickersListForCommunity.clear();
          Map<String, dynamic> tickerDataSelected = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: true);
          Rx<TickersListModel> tickersListSelected = (TickersListModel.fromJson(tickerDataSelected)).obs;
          communitiesVariables.tickersListForCommunity = (tickersListSelected.value.response).obs;
          Map<String, dynamic> tickerData = await communitiesFunctions.getCommunitiesTickers(skipCount: 0, isEditing: false);
          Rx<TickersListModel> tickersList = (TickersListModel.fromJson(tickerData)).obs;
          communitiesVariables.tickersListForCommunity.addAll(tickersList.value.response);
          communitiesVariables.selectedTickersListForCommunity = (communitiesVariables.communitiesDetail!.value.response.tickers).obs;
          if (communitiesVariables.selectedTickersListForCommunity.isEmpty) {
            communitiesVariables.isTickerSelectedAll.value = true;
            communitiesVariables.tickerController.value.text = "Multiple";
            for (int i = 0; i < communitiesVariables.tickersListForCommunity.length; i++) {
              communitiesVariables.selectedTickersListForCommunity.add(communitiesVariables.tickersListForCommunity[i].id.value);
            }
          } else {
            if (communitiesVariables.selectedTickersListForCommunity.length > 1) {
              communitiesVariables.tickerController.value.text = "Multiple";
            } else {
              communitiesVariables.tickerController.value.text = "Single";
            }
            communitiesVariables.isTickerSelectedAll.value = false;
          }
        }
    }
  }

  Future<Map<String, dynamic>> getCommunitiesEx() async {
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
      headers: {'Authorization': kToken},
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getCommunitiesIndustries({
    required int skipCount,
    required bool isEditing,
  }) async {
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: {
          'type': communitiesVariables.selectedCategoryForCommunity.value.slug.value,
          'search': communitiesVariables.textController.value.text,
          'skip': skipCount,
          'exchange': communitiesVariables.selectedExchangeForCommunity.value.id.value,
          'industry_exist': isEditing,
          'industries': communitiesVariables.selectedIndustriesListForCommunity
        },
        options: Options(
          headers: {'Authorization': kToken},
        ));
    return response.data;
  }

  Future<Map<String, dynamic>> getCommunitiesCryptoType() async {
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: {
          'type': communitiesVariables.selectedCategoryForCommunity.value.slug.value,
        },
        options: Options(
          headers: {'Authorization': kToken},
        ));
    return response.data;
  }

  Future<Map<String, dynamic>> getCommunitiesTickers({
    required int skipCount,
    required bool isEditing,
  }) async {
    var url = baseurl + versionLocker + getTickers;
    Map<String, dynamic> data = {};
    if (communitiesVariables.selectedCategoryForCommunity.value.slug.value == "stocks") {
      data = {
        'category': communitiesVariables.selectedCategoryForCommunity.value.slug.value,
        'search': communitiesVariables.tickerTextController.value.text,
        'skip': skipCount,
        'exchange': communitiesVariables.selectedExchangeForCommunity.value.id.value,
        'industries': communitiesVariables.isIndustriesSelectedAll.value ? [] : communitiesVariables.selectedIndustriesListForCommunity,
        'ticker_exist': isEditing,
        'tickers': communitiesVariables.selectedTickersListForCommunity
      };
    } else if (communitiesVariables.selectedCategoryForCommunity.value.slug.value == "crypto") {
      data = {
        'category': communitiesVariables.selectedCategoryForCommunity.value.slug.value,
        'search': communitiesVariables.tickerTextController.value.text,
        'skip': skipCount,
        'industries': [communitiesVariables.selectedCryptoTypeForCommunity.value.id.value],
        'ticker_exist': isEditing,
        'tickers': communitiesVariables.selectedTickersListForCommunity
      };
    } else if (communitiesVariables.selectedCategoryForCommunity.value.slug.value == "commodity") {
      data = {
        'category': communitiesVariables.selectedCategoryForCommunity.value.slug.value,
        'search': communitiesVariables.tickerTextController.value.text,
        'skip': skipCount,
        'country': communitiesVariables.selectedCountryForCommunity.value.id.value,
        'ticker_exist': isEditing,
        'tickers': communitiesVariables.selectedTickersListForCommunity
      };
    } else if (communitiesVariables.selectedCategoryForCommunity.value.slug.value == "forex") {
      data = {
        'category': communitiesVariables.selectedCategoryForCommunity.value.slug.value,
        'search': communitiesVariables.tickerTextController.value.text,
        'skip': skipCount,
        'ticker_exist': isEditing,
        'tickers': communitiesVariables.selectedTickersListForCommunity
      };
    } else {}
    var response = await dioMain.post(url,
        data: data,
        options: Options(
          headers: {'Authorization': kToken},
        ));
    return response.data;
  }

  getCommunitiesList({
    required int skipCount,
  }) async {
    var url = baseurl + versionCommunity + communitiesList;
    Map<String, dynamic> data = {
      "skip": skipCount,
      "limit": 20,
    };
    var response = await dioMain.post(url,
        data: data,
        options: Options(
          headers: {'Authorization': kToken},
        ));
    Map<String, dynamic> responseData = response.data;
    CommunitiesMyListApiModel myList = CommunitiesMyListApiModel.fromJson(responseData);
    if (skipCount == 0) {
      communitiesVariables.communityHomeList.value.communityListData.value = myList.response;
    } else {
      communitiesVariables.communityHomeList.value.communityListData.addAll(myList.response);
    }
    communitiesVariables.communityHomeList.value.communityListData.refresh();
  }

  getTrendingCommunitiesList({
    required int skipCount,
  }) async {
    var url = baseurl + versionCommunity + communitiesTrendingList;
    Map<String, dynamic> data = {
      "skip": skipCount,
      "limit": 20,
    };
    var response = await dioMain.post(url,
        data: data,
        options: Options(
          headers: {'Authorization': kToken},
        ));
    Map<String, dynamic> responseData = response.data;
    CommunitiesTrendingApiModel myList = CommunitiesTrendingApiModel.fromJson(responseData);
    if (skipCount == 0) {
      communitiesVariables.communityHomeList.value.trendingData.value = myList.response;
    } else {
      communitiesVariables.communityHomeList.value.trendingData.addAll(myList.response);
    }
    communitiesVariables.communityHomeList.value.trendingData.refresh();
  }

  Future<Map<String, dynamic>> getCommunitiesCreate({
    required String communityId,
  }) async {
    var url = baseurl + versionCommunity + communitiesAddEdit;
    Map<String, dynamic> data = {};
    List<Map<String, dynamic>> files = [];
    List<Map<String, dynamic>> subscriptionList = [];
    if (communitiesVariables.selectedImageForCommunity != null) {
      String imagePath = await communitiesFunctions.fileUploadBillBoard(file: communitiesVariables.selectedImageForCommunity!);
      files.add({"file": imagePath, "file_type": "image"});
    } else {
      files.clear();
    }
    for (int i = 0; i < communitiesVariables.selectedSubscriptionPeriodValue.length; i++) {
      subscriptionList.add({
        "type": communitiesVariables.selectedSubscriptionPeriodValue[i].slug.value,
        "trail_period": communitiesVariables.selectedTrailAvailableValue[i].slug.value == "yes"
            ? int.parse(communitiesVariables.selectedTrailFreeValue[i].slug.value)
            : 0,
        "amount": communitiesVariables.paymentController[i].value.text == "" ? 0 : communitiesVariables.paymentController[i].value.text,
        "discount_per": communitiesVariables.isDiscountAvailable[i]
            ? communitiesVariables.discountController[i].value.text == ""
                ? 0
                : communitiesVariables.discountController[i].value.text
            : 0
      });
    }
    if (communitiesVariables.selectedCategoryForCommunity.value.slug.value == "general") {
      data = {
        "community_id": communityId,
        "name": communitiesVariables.communityController.value.text,
        "category": communitiesVariables.selectedCategoryForCommunity.value.slug.value,
        "category_id": communitiesVariables.selectedCategoryForCommunity.value.id.value,
        "file": files,
        "subscription": communitiesVariables.selectedSubscriptionType.value,
        "about": communitiesVariables.aboutController.value.text,
        "rules": communitiesVariables.rulesController.value.text,
        "post_type": communitiesVariables.selectedPostLimitValue.value.slug.value,
        "post_access": communitiesVariables.selectedPostLimitValue.value.slug.value != 'flexible'
            ? []
            : communitiesVariables.selectedPostLimitResponseOptionValue,
        "subscription_type": communitiesVariables.selectedSubscriptionType.value == "Free" ? [] : subscriptionList,
      };
    } else if (communitiesVariables.selectedCategoryForCommunity.value.slug.value == "stocks") {
      data = {
        "community_id": communityId,
        "name": communitiesVariables.communityController.value.text,
        "category": communitiesVariables.selectedCategoryForCommunity.value.slug.value,
        "category_id": communitiesVariables.selectedCategoryForCommunity.value.id.value,
        "file": files,
        "subscription": communitiesVariables.selectedSubscriptionType.value,
        "about": communitiesVariables.aboutController.value.text,
        "rules": communitiesVariables.rulesController.value.text,
        "exchange": communitiesVariables.selectedExchangeForCommunity.value.code,
        "exchange_id": communitiesVariables.selectedExchangeForCommunity.value.id.value,
        "industry": communitiesVariables.isIndustriesSelectedAll.value || communitiesVariables.selectedExchangeForCommunity.value.id.value == ""
            ? []
            : communitiesVariables.selectedIndustriesListForCommunity,
        "tickers": communitiesVariables.isTickerSelectedAll.value || communitiesVariables.selectedExchangeForCommunity.value.id.value == ""
            ? []
            : communitiesVariables.selectedTickersListForCommunity,
        "post_type": communitiesVariables.selectedPostLimitValue.value.slug.value,
        "post_access": communitiesVariables.selectedPostLimitValue.value.slug.value != 'flexible'
            ? []
            : communitiesVariables.selectedPostLimitResponseOptionValue,
        "subscription_type": communitiesVariables.selectedSubscriptionType.value == "Free" ? [] : subscriptionList,
      };
    } else if (communitiesVariables.selectedCategoryForCommunity.value.slug.value == "crypto") {
      data = {
        "community_id": communityId,
        "name": communitiesVariables.communityController.value.text,
        "category": communitiesVariables.selectedCategoryForCommunity.value.slug.value,
        "category_id": communitiesVariables.selectedCategoryForCommunity.value.id.value,
        "file": files,
        "subscription": communitiesVariables.selectedSubscriptionType.value,
        "about": communitiesVariables.aboutController.value.text,
        "rules": communitiesVariables.rulesController.value.text,
        "industry": communitiesVariables.selectedCryptoTypeForCommunity.value.id.value == ""
            ? []
            : [communitiesVariables.selectedCryptoTypeForCommunity.value.id.value],
        "tickers": communitiesVariables.isTickerSelectedAll.value || communitiesVariables.selectedCryptoTypeForCommunity.value.id.value == ""
            ? []
            : communitiesVariables.selectedTickersListForCommunity,
        "post_type": communitiesVariables.selectedPostLimitValue.value.slug.value,
        "post_access": communitiesVariables.selectedPostLimitValue.value.slug.value != 'flexible'
            ? []
            : communitiesVariables.selectedPostLimitResponseOptionValue,
        "subscription_type": communitiesVariables.selectedSubscriptionType.value == "Free" ? [] : subscriptionList,
      };
    } else if (communitiesVariables.selectedCategoryForCommunity.value.slug.value == "commodity") {
      data = {
        "community_id": communityId,
        "name": communitiesVariables.communityController.value.text,
        "category": communitiesVariables.selectedCategoryForCommunity.value.slug.value,
        "category_id": communitiesVariables.selectedCategoryForCommunity.value.id.value,
        "file": files,
        "subscription": communitiesVariables.selectedSubscriptionType.value,
        "about": communitiesVariables.aboutController.value.text,
        "rules": communitiesVariables.rulesController.value.text,
        "country": communitiesVariables.selectedCountryForCommunity.value.id.value,
        "tickers": communitiesVariables.isTickerSelectedAll.value || communitiesVariables.selectedCountryForCommunity.value.id.value == ""
            ? []
            : communitiesVariables.selectedTickersListForCommunity,
        "post_type": communitiesVariables.selectedPostLimitValue.value.slug.value,
        "post_access": communitiesVariables.selectedPostLimitValue.value.slug.value != 'flexible'
            ? []
            : communitiesVariables.selectedPostLimitResponseOptionValue,
        "subscription_type": communitiesVariables.selectedSubscriptionType.value == "Free" ? [] : subscriptionList,
      };
    } else if (communitiesVariables.selectedCategoryForCommunity.value.slug.value == "forex") {
      data = {
        "community_id": communityId,
        "name": communitiesVariables.communityController.value.text,
        "category": communitiesVariables.selectedCategoryForCommunity.value.slug.value,
        "category_id": communitiesVariables.selectedCategoryForCommunity.value.id.value,
        "file": files,
        "subscription": communitiesVariables.selectedSubscriptionType.value,
        "about": communitiesVariables.aboutController.value.text,
        "rules": communitiesVariables.rulesController.value.text,
        "tickers": communitiesVariables.isTickerSelectedAll.value ? [] : communitiesVariables.selectedTickersListForCommunity,
        "post_type": communitiesVariables.selectedPostLimitValue.value.slug.value,
        "post_access": communitiesVariables.selectedPostLimitValue.value.slug.value != 'flexible'
            ? []
            : communitiesVariables.selectedPostLimitResponseOptionValue,
        "subscription_type": communitiesVariables.selectedSubscriptionType.value == "Free" ? [] : subscriptionList,
      };
    } else {}
    var response = await dioMain.post(url,
        data: data,
        options: Options(
          headers: {'Authorization': kToken},
        ));
    return response.data;
  }

  Future<String> fileUploadBillBoard({
    required File file,
  }) async {
    var uri = baseurl + versionCommunity + fileAdd;
    var res1 = await functionsMain.sendForm(uri, {"id": "1"}, {'file': file});
    if (res1.data["status"]) {
      return res1.data['response'][0];
    } else {
      return "";
    }
  }

  Future<Map<String, dynamic>> joinCommunity({
    required String communityId,
  }) async {
    var url = baseurl + versionCommunity + communitiesJoin;
    var response = await dioMain.post(url,
        data: {"community_id": communityId},
        options: Options(
          headers: {'Authorization': kToken},
        ));
    return response.data;
  }

  getCommunityDetails({
    required String communityId,
  }) async {
    var url = baseurl + versionCommunity + communitiesDetails;
    var response = await dioMain.post(url,
        data: {"community_id": communityId},
        options: Options(
          headers: {'Authorization': kToken},
        ));
    communitiesVariables.communitiesDetail = (CommunitiesDetailsApiModel.fromJson(response.data)).obs;
    communitiesVariables.communitiesPageInitialData.value.communityData.isJoined.value =
        communitiesVariables.communitiesDetail!.value.response.memberResponse.role != "";
    communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value =
        communitiesVariables.communitiesDetail!.value.response.memberResponse.role;
  }

  getCommunityMemberList({
    required String communityId,
    required int skipCount,
    required int limit,
  }) async {
    var url = baseurl + versionCommunity + membersList;
    print(url);
    print({"community_id": communityId, "skip": skipCount, "limit": limit});
    print({'Authorization': kToken});
    var response = await dioMain.post(url,
        data: {"community_id": communityId, "skip": skipCount, "limit": limit},
        options: Options(
          headers: {'Authorization': kToken},
        ));
    print(response.data);
    print("membersList");
    communitiesVariables.communitiesMembersList = (MembersListApiModel.fromJson(response.data)).obs;
  }

  getCommunityPostList({
    required String communityId,
    required String sortType,
    required int skipCount,
  }) async {
    var url = baseurl + versionCommunity + postList;
    var response = await dioMain.post(url,
        data: {
          "community_id": communityId,
          "search": communitiesVariables.postRequestSearchController.value.text,
          "sort": sortType, //Liked,Disliked,Shared,Responsed
          "skip": skipCount,
          "limit": 10
        },
        options: Options(
          headers: {'Authorization': kToken},
        ));
    communitiesVariables.communitiesPostList = (CommunitiesPostListApiModel.fromJson(response.data)).obs;
    communitiesVariables.communitiesPageInitialData.value.communityData.postContents.value = communitiesVariables.communitiesPostList!.value.response;
  }

  getCommunityPostRequestList({
    required String communityId,
    required int skipCount,
    required int limit,
  }) async {
    var url = baseurl + versionCommunity + postRequest;
    var response = await dioMain.post(url,
        data: {"community_id": communityId, "skip": skipCount, "limit": limit},
        options: Options(
          headers: {'Authorization': kToken},
        ));
    communitiesVariables.communitiesPostRequestList = (CommunitiesPostResponseModel.fromJson(response.data)).obs;
  }

  Future<Map<String, dynamic>> getCommunityBlockOrReport({
    required String action,
    required String why,
    required String description,
    required String communityId,
    required String userId,
    required String list,
    required int index,
  }) async {
    Map<String, dynamic> data1 = {};
    var url = Uri.parse(baseurl + versionCommunity + communitiesBlockOrReport);
    data1 = {
      "action": action,
      "why": why,
      "description": description,
      "community_id": communityId,
      "community_user": userId,
    };
    var responseNew = await http.post(url, body: data1, headers: {'Authorization': kToken});
    Map<String, dynamic> responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"] && action == "Block") {
      if (list == "trending") {
        communitiesVariables.communityHomeList.value.trendingData.removeAt(index);
        communitiesVariables.communityHomeList.value.trendingData.refresh();
      } else if (list == "community") {
        communitiesVariables.communityHomeList.value.communityListData.removeAt(index);
        communitiesVariables.communityHomeList.value.communityListData.refresh();
      } else if (list == "main") {
      } else {}
    }
    return responseDataNew;
  }

  Future<Map<String, dynamic>> getCommunityPost({required Map<String, dynamic> data}) async {
    var url = baseurl + versionCommunity + postAdd;
    var responseNew = await dioMain.post(url, data: data, options: Options(headers: {'Authorization': kToken}));
    Map<String, dynamic> responseDataNew = responseNew.data;
    return responseDataNew;
  }

  Future<Map<String, dynamic>> getCommunityPostDelete({required String postId}) async {
    var url = baseurl + versionCommunity + postRemove;
    var responseNew = await dioMain.post(url, data: {"post_id": postId}, options: Options(headers: {'Authorization': kToken}));
    Map<String, dynamic> responseDataNew = responseNew.data;
    return responseDataNew;
  }

  Future<Map<String, dynamic>> getCommunityPostResponseDelete({required String responseId}) async {
    var url = baseurl + versionCommunity + responseRemove;
    var responseNew = await dioMain.post(url, data: {"response_id": responseId}, options: Options(headers: {'Authorization': kToken}));
    Map<String, dynamic> responseDataNew = responseNew.data;
    return responseDataNew;
  }

  Future<Map<String, dynamic>> getCommunityCommentsDelete({
    required String responseId,
    required String commentId,
  }) async {
    var url = baseurl + versionCommunity + commentsRemove;
    var responseNew =
        await dioMain.post(url, data: {"response_id": responseId, "comment_id": commentId}, options: Options(headers: {'Authorization': kToken}));
    Map<String, dynamic> responseDataNew = responseNew.data;
    return responseDataNew;
  }

  Future<Map<String, dynamic>> getCommunityPostBlockOrReport({
    required String action,
    required String why,
    required String description,
    required String communityId,
    required String postId,
    required String userId,
    required String list,
    required int index,
  }) async {
    Map<String, dynamic> data1 = {};
    var url = Uri.parse(baseurl + versionCommunity + communitiesPostBlockOrReport);
    data1 = {
      "action": action,
      "why": why,
      "description": description,
      "community_id": communityId,
      "post_user": userId,
      "post_id": postId,
    };
    var responseNew = await http.post(url, body: data1, headers: {'Authorization': kToken});
    Map<String, dynamic> responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"] && action == "Block") {
      communitiesVariables.communitiesPageInitialData.value.communityData.postContents.removeAt(index);
      communitiesVariables.communitiesPageInitialData.value.communityData.postContents.refresh();
    }
    return responseDataNew;
  }

  Future<Map<String, dynamic>> getCommunityPostResponseBlockOrReport({
    required String action,
    required String why,
    required String description,
    required String communityId,
    required String postId,
    required String responseId,
    required String userId,
    required String list,
    required int index,
  }) async {
    Map<String, dynamic> data1 = {};
    var url = Uri.parse(baseurl + versionCommunity + communitiesPostBlockOrReport);
    data1 = {
      "action": action,
      "why": why,
      "description": description,
      "community_id": communityId,
      "post_user": userId,
      "post_id": postId,
      "response_id": responseId,
    };
    var responseNew = await http.post(url, body: data1, headers: {'Authorization': kToken});
    Map<String, dynamic> responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"] && action == "Block") {
      communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList.removeAt(index);
      communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList.refresh();
    }
    return responseDataNew;
  }

  Future<Uri> getCommunityLinK({
    required String id,
    required String type,
    required String title,
    required String imageUrl,
    required String description,
  }) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/CommunitiesPage/$id/$type'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: description, imageUrl: Uri.parse(imageUrl)));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  Future<bool> communityLikeFunction({
    required String postId,
    required String communityId,
    required String type,
  }) async {
    var uri = Uri.parse(baseurl + versionCommunity + likeDislikes);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "post_id": postId,
      "community_id": communityId,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
    return responseData['status'];
  }

  Future<bool> communityResponseLikeFunction({
    required String postId,
    required String communityId,
    required String responseId,
    required String type,
  }) async {
    var uri = Uri.parse(baseurl + versionCommunity + responseLikeDislikes);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "post_id": postId,
      "community_id": communityId,
      "response_id": responseId,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
    return responseData['status'];
  }

  Future<bool> communityCommentsLikeFunction({
    required String postId,
    required String communityId,
    required String responseId,
    required String commentId,
    required String type,
  }) async {
    var uri = Uri.parse(baseurl + versionCommunity + commentsLikeDislikes);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "post_id": postId,
      "community_id": communityId,
      "response_id": responseId,
      "comment_id": commentId,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
    return responseData['status'];
  }

  shareFunction({required String id}) async {
    var uri = Uri.parse(baseurl + versionCommunity + share);
    await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "post_id": id
    });
  }

  Future<Map<String, dynamic>> getCommunityResponseAdd({required Map<String, dynamic> data}) async {
    var uri = baseurl + versionCommunity + communityResponseAdd;
    var response = await dioMain.post(uri,
        options: Options(headers: {
          "authorization": kToken,
        }),
        data: data);

    return response.data;
  }

  Future<Map<String, dynamic>> getCommunityCommentAdd({required Map<String, dynamic> data}) async {
    var uri = baseurl + versionCommunity + commentsAddEdit;
    var response = await dioMain.post(uri,
        options: Options(headers: {
          "authorization": kToken,
        }),
        data: data);

    return response.data;
  }

  getCommunityPostResponsesList({
    required String postId,
    required int skipCount,
  }) async {
    var url = baseurl + versionCommunity + responseList;
    var response = await dioMain.post(url,
        data: {"post_id": postId, "skip": skipCount, "limit": 10, "sort_type": mainVariables.selectedResponseSortTypeMain.value},
        options: Options(
          headers: {'Authorization': kToken},
        ));
    communitiesVariables.communitiesPostResponsesList = (CommunitiesResponseListApiModel.fromJson(response.data)).obs;
    communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList.value =
        communitiesVariables.communitiesPostResponsesList!.value.response;
  }

  Future<Map<String, dynamic>> getMemberUpdate({
    required String userId,
    required String communityId,
    required String role,
  }) async {
    print("getMemberUpdate");
    var url = baseurl + versionCommunity + memberUpdate;
    var response = await dioMain.post(url,
        data: {"userId": userId, "community_id": communityId, "role": role},
        options: Options(
          headers: {'Authorization': kToken},
        ));
    print(response.data);
    communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value = "member";
    return response.data;
  }

  Future<Map<String, dynamic>> getMemberExit({required String communityId}) async {
    print("getMemberExit");
    var url = baseurl + versionCommunity + communityExit;
    var response = await dioMain.post(url,
        data: {"community_id": communityId},
        options: Options(
          headers: {'Authorization': kToken},
        ));
    print("response:${response.data}");
    return response.data;
  }

  Future<Map<String, dynamic>> acceptOrDeclinePostRequest({
    required String communityId,
    required String postId,
    required bool isAccepted,
  }) async {
    var url = baseurl + versionCommunity + postAcceptDecline;
    var response = await dioMain.post(url,
        data: {"post_id": postId, "community_id": communityId, "type": isAccepted ? "accept" : "decline"},
        options: Options(
          headers: {'Authorization': kToken},
        ));
    return response.data;
  }

  getCommunityPostResponseComments({
    required String responseId,
  }) async {
    var url = baseurl + versionCommunity + commentsList;
    var response = await dioMain.post(url,
        data: {"response_id": responseId},
        options: Options(
          headers: {'Authorization': kToken},
        ));
    communitiesVariables.communitiesCommentsInitialData = (CommunitiesCommentsInitialModel.fromJson(response.data)).obs;
  }

  Future<Map<String, dynamic>> getCommunityPostCommentsAdd({
    required String communityId,
    required String postId,
    required String responseId,
  }) async {
    var url = baseurl + versionCommunity + commentsAddEdit;
    var response = await dioMain.post(url,
        data: {
          "post_id": postId,
          "community_id": communityId,
          "response_id": responseId,
          "message": communitiesVariables.communityCommentsController.value.text,
        },
        options: Options(
          headers: {'Authorization': kToken},
        ));
    return response.data;
  }
}
