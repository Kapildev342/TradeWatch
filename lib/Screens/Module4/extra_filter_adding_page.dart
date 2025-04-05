import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Constants/Common/filter_function.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/videos_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/detailed_forum_image_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/detailed_survey_image_page.dart';

class ExtraFilterAddingPage extends StatefulWidget {
  final String text;
  final bool fromCompare;
  final String fromWhere;
  final String tickerId;

  const ExtraFilterAddingPage({
    Key? key,
    required this.fromCompare,
    required this.fromWhere,
    required this.text,
    required this.tickerId,
  }) : super(key: key);

  @override
  State<ExtraFilterAddingPage> createState() => _ExtraFilterAddingPageState();
}

class _ExtraFilterAddingPageState extends State<ExtraFilterAddingPage> {
  final TextEditingController _listNameController = TextEditingController();
  final FilterFunction _filterFunction = FilterFunction();
  final TextEditingController _exchangeController = TextEditingController();
  final TextEditingController _industriesController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stockTickersController = TextEditingController();
  final TextEditingController _cryptoTickersController = TextEditingController();
  final TextEditingController _commodityTickersController = TextEditingController();
  final TextEditingController _forexTickersController = TextEditingController();
  final TextEditingController _industrySearchController = TextEditingController();
  final TextEditingController _tickerSearchController = TextEditingController();

  final RefreshController _refreshController = RefreshController();
  final RefreshController _controller = RefreshController();

  int stocksInt = 0;
  int stocksInt1 = 0;
  Function eq = const ListEquality().equals;
  bool stateBool = false;
  bool selectAll = false;
  bool tickAll = false;
  bool tickerTickAll = false;
  bool tickerSelectAll = false;
  bool stateButtonBool = false;
  bool searchIndustry = false;
  List countriesList = ["India", "USA"];
  String mainUserToken = "";
  String categoryValue = "";
  String textValue = "";
  String tickersTextValue = "";

  String _selectedExchange = "";
  String selectedIdItem = "";

  List exchangeNameList = [];
  List exchangeCodeList = [];
  List exchangeIdList = [];

  List industriesNameList = [];
  List industriesIdList = [];
  List searchIndustriesNameList = [];
  List searchIndustriesIdList = [];
  List sendIndustriesList = [];
  List sendIndustriesNameList = [];
  List searchSendIndustriesList = [];
  List searchSendIndustriesNameList = [];
  List finalSendIndustriesList = [];
  List finalSendIndustriesNameList = [];
  List<bool> indusBool = [];
  List<bool> searchIndusBool = [];

  List tickersNameList = [];
  List tickersLogoList = [];
  List tickersCatIdList = [];
  List tickersCodeList = [];
  List sendTickersList = [];
  List sendTickersNameList = [];
  List<bool> isCheckedNew = [];

  bool excSelect = false;
  bool indusSelect = false;
  bool loading2 = false;

  String selectedExchangeName = "";
  bool excLoader = false;
  bool indusLoader = false;

  String tickerDetailLogoExtra = "";
  String tickerDetailNameExtra = "";
  String tickerDetailExcExtra = "";
  String tickerDetailCategoryExtra = "";
  String tickerDetailCodeExtra = "";
  String tickerDetailIndustryExtra = "";
  String tickerDetailAddressExtra = "";
  String tickerDetailDescriptionExtra = "";
  String tickerDetailWebUrlExtra = "";
  String editExchange = "";
  bool selectAllButton = false;
  bool tickerSelectAllButton = false;
  List sendIndustriesListCheck = [];
  List enteredFilteredIdList = [];
  String selectedIdItemCheck = "";
  String selectedTypeValue = "";

  @override
  void initState() {
    categoryValue = widget.text;
    getAllDataMain(name: 'Filter_Creation_Page');
    getAllData();
    super.initState();
  }

  getFil({required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionLocker + getFilter);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"type": type.toLowerCase()});
    var responseData = json.decode(response.body);
    setState(() {
      enteredFilteredIdList.clear();
      for (int i = 0; i < responseData["response"].length; i++) {
        enteredFilteredIdList.add(responseData["response"][i]["_id"]);
      }
    });
  }

  getDetailData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionHome + tickerDetail);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'category': widget.text.toLowerCase(),
      'ticker_id': widget.tickerId,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      tickerDetailCodeExtra = responseData["response"]["code"];
      tickerDetailNameExtra = responseData["response"]["name"];
      editExchange = responseData["response"]["exchange_id"];
      sendTickersList.add(responseData["response"]["_id"]);
      sendIndustriesListCheck.add(responseData["response"]["_id"]);
      //EXC & Category
      if (responseData["response"]["category"] == "stocks") {
        for (int i = 0; i < finalExchangeIdList.length; i++) {
          if (responseData["response"]["exchange_id"] == finalExchangeIdList[i]) {
            i == 0
                ? tickerDetailCategoryExtra = "USA Stocks"
                : i == 1
                    ? tickerDetailCategoryExtra = "NSE Stocks"
                    : tickerDetailCategoryExtra = "BSE Stocks";
          }
        }
      }
    }
  }

  getCryptoDetailData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionHome + tickerDetail);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'category': widget.text.toLowerCase(),
      'ticker_id': widget.tickerId,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      tickerDetailCodeExtra = responseData["response"]["code"];
      tickerDetailNameExtra = responseData["response"]["name"];
      tickerDetailIndustryExtra = responseData["response"]["industry"];
      sendTickersList.add(responseData["response"]["_id"]);
    }
  }

  getCommodityDetailData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionHome + tickerDetail);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'category': widget.text.toLowerCase(),
      'ticker_id': widget.tickerId,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      tickerDetailCodeExtra = responseData["response"]["code"];
      tickerDetailNameExtra = responseData["response"]["name"];
      tickerDetailIndustryExtra = responseData["response"]["country"];
      sendTickersList.add(responseData["response"]["_id"]);
    }
  }

  getForexDetailData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionHome + tickerDetail);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'category': widget.text.toLowerCase(),
      'ticker_id': widget.tickerId,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      tickerDetailCodeExtra = responseData["response"]["code"];
      tickerDetailNameExtra = responseData["response"]["name"];
      sendTickersList.add(responseData["response"]["_id"]);
    }
  }

  getAllData() async {
    if (widget.text.toLowerCase() == "stocks") {
      await getDetailData();
      selectAllButton = true;
      tickerSelectAllButton = false;
      setState(() {
        selectAll = selectAllButton;
        tickerSelectAll = tickerSelectAllButton;
        _exchangeController.text = tickerDetailCategoryExtra;
        _industriesController.text = "Multiple";
        _stockTickersController.text = tickerDetailNameExtra;
        sendIndustriesList = [];
      });
      await getEx();
      await getIndustries1();
      await getIndustries(newSetState: setState);
      await getTickersFunc1();
      await getTickersFunc(tickerSetState: setState);
    } else if (widget.text.toLowerCase() == "crypto") {
      sendIndustriesList.clear();
      await getCryptoDetailData();
      tickerSelectAllButton = false;
      setState(() {
        tickerSelectAll = tickerSelectAllButton;
        _typeController.text = tickerDetailIndustryExtra;
        _cryptoTickersController.text = tickerDetailNameExtra;
      });
      await getCryptoIndustries(newSetState: setState);
      await getCryptoTickersFunc1();
      await getCryptoTickersFunc(tickerSetState: setState);
    } else if (widget.text.toLowerCase() == "commodity") {
      await getCommodityDetailData();
      tickerSelectAllButton = false;
      setState(() {
        tickerSelectAll = tickerSelectAllButton;
        _countryController.text = tickerDetailIndustryExtra;
        _commodityTickersController.text = tickerDetailNameExtra;
      });
      for (int i = 0; i < countriesList.length; i++) {
        if (countriesList[i] == tickerDetailIndustryExtra) {
          setState(() {
            selectedIdItem = tickerDetailIndustryExtra;
            selectedIdItemCheck = tickerDetailIndustryExtra;
            _selectedExchange = i.toString();
          });
        }
      }
      setState(() {
        stateBool = true;
      });
      await getCommodityTickersFunc1();
      await getCommodityTickersFunc(tickerSetState: setState);
    } else if (widget.text.toLowerCase() == "forex") {
      await getForexDetailData();
      tickerSelectAllButton = false;
      setState(() {
        tickerSelectAll = tickerSelectAllButton;
        _forexTickersController.text = tickerDetailNameExtra;
      });
      await getForexTickersFunc1();
      await getForexTickersFunc(tickerSetState: setState);
      setState(() {
        stateBool = true;
      });
    } else {}
  }

  //STOCKS
  getRefreshIndus({required StateSetter newSetState}) async {
    newSetState(() {
      stocksInt += 20;
    });
    selectAll
        ? tickAll
            ? debugPrint("nothing to do")
            : sendIndustriesList.clear()
        : debugPrint("nothing to do");
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: {
          'type': categoryValue.toLowerCase(),
          'search': _industrySearchController.text.isEmpty ? "" : _industrySearchController.text,
          'skip': stocksInt,
          'exchange': selectedIdItem,
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      newSetState(() {
        for (int i = 0; i < responseData["response"].length; i++) {
          industriesNameList.add(responseData["response"][i]["name"]);
          industriesIdList.add(responseData["response"][i]["_id"]);
          if (selectAll) {
            sendIndustriesList.addAll(industriesIdList);
            if (sendIndustriesList.isNotEmpty) {
              if (sendIndustriesList.contains(responseData["response"][i]["_id"])) {
                newSetState(() {
                  indusBool.add(true);
                });
              } else {
                newSetState(() {
                  indusBool.add(false);
                });
              }
            } else {
              newSetState(() {
                indusBool.add(false);
              });
            }
          } else {
            if (sendIndustriesList.isNotEmpty) {
              if (sendIndustriesList.contains(responseData["response"][i]["_id"])) {
                newSetState(() {
                  indusBool.add(true);
                });
              } else {
                newSetState(() {
                  indusBool.add(false);
                });
              }
            } else {
              newSetState(() {
                indusBool.add(false);
              });
            }
          }
        }
      });
    }
  }

  getEx() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
      headers: {'Authorization': mainUserToken},
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
          exchangeNameList.clear();
          exchangeCodeList.clear();
          exchangeIdList.clear();
          for (int i = 0; i < responseData["response"].length; i++) {
            exchangeNameList.add(responseData["response"][i]["name"]);
            exchangeCodeList.add(responseData["response"][i]["code"]);
            exchangeIdList.add(responseData["response"][i]["_id"]);
            if (editExchange == responseData["response"][i]["_id"]) {
              selectedIdItem = editExchange;
              _selectedExchange = i.toString();
              _exchangeController.text = exchangeNameList[i];
            }
          }
        });
      }
    } else {}
    setState(() {
      stateBool = true;
    });
  }

  getIndustries1() async {
    selectAll
        ? tickAll
            ? debugPrint("nothing to do")
            : sendIndustriesList.clear()
        : debugPrint("nothing to do");
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: {
          'type': categoryValue.toLowerCase(),
          'search': _industrySearchController.text.isEmpty ? "" : _industrySearchController.text,
          'skip': 0,
          'exchange': selectedIdItem,
          'industry_exist': true,
          'industries': sendIndustriesList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
          industriesNameList.clear();
          industriesIdList.clear();
          indusBool.clear();
          for (int i = 0; i < responseData["response"].length; i++) {
            industriesNameList.add(responseData["response"][i]["name"]);
            industriesIdList.add(responseData["response"][i]["_id"]);
            if (selectAll) {
              sendIndustriesList.addAll(industriesIdList);
              if (sendIndustriesList.isNotEmpty) {
                if (sendIndustriesList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    indusBool.add(true);
                  });
                } else {
                  setState(() {
                    indusBool.add(false);
                  });
                }
              } else {
                setState(() {
                  indusBool.add(false);
                });
              }
            } else {
              if (sendIndustriesList.isNotEmpty) {
                if (sendIndustriesList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    indusBool.add(true);
                  });
                } else {
                  setState(() {
                    indusBool.add(false);
                  });
                }
              } else {
                setState(() {
                  indusBool.add(false);
                });
              }
            }
            setState(() {
              excLoader = false;
            });
          }
        });
      }
      setState(() {
        excLoader = false;
      });
    }
  }

  getIndustries({required StateSetter newSetState}) async {
    selectAll
        ? tickAll
            ? debugPrint("nothing to do")
            : sendIndustriesList.clear()
        : debugPrint("nothing to do");
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: {
          'type': categoryValue.toLowerCase(),
          'search': _industrySearchController.text.isEmpty ? "" : _industrySearchController.text,
          'skip': 0,
          'exchange': selectedIdItem,
          'industry_exist': false,
          'industries': sendIndustriesList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        newSetState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            industriesNameList.add(responseData["response"][i]["name"]);
            industriesIdList.add(responseData["response"][i]["_id"]);
            if (selectAll) {
              sendIndustriesList.addAll(industriesIdList);
              if (sendIndustriesList.isNotEmpty) {
                if (sendIndustriesList.contains(responseData["response"][i]["_id"])) {
                  newSetState(() {
                    indusBool.add(true);
                  });
                } else {
                  newSetState(() {
                    indusBool.add(false);
                  });
                }
              } else {
                newSetState(() {
                  indusBool.add(false);
                });
              }
            } else {
              if (sendIndustriesList.isNotEmpty) {
                if (sendIndustriesList.contains(responseData["response"][i]["_id"])) {
                  newSetState(() {
                    indusBool.add(true);
                  });
                } else {
                  newSetState(() {
                    indusBool.add(false);
                  });
                }
              } else {
                newSetState(() {
                  indusBool.add(false);
                });
              }
            }
            newSetState(() {
              excLoader = false;
            });
          }
        });
      }
      newSetState(() {
        excLoader = false;
      });
    }
  }

  getRefreshTickersFunc({required StateSetter tickerSetState1}) async {
    tickerSetState1(() {
      stocksInt += 20;
    });
    selectAll
        ? tickAll
            ? debugPrint("nothing to do")
            : sendIndustriesList.clear()
        : debugPrint("nothing to do");
    tickerSelectAll
        ? tickerTickAll
            ? debugPrint("nothing to do")
            : sendTickersList.clear()
        : debugPrint("nothing to do");
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': stocksInt,
          'exchange': selectedIdItem,
          'industries': sendIndustriesList,
          'ticker_exist': false,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState1(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState1(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState1(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState1(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState1(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState1(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState1(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
    } else {}
  }

  getTickersFunc1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    selectAll
        ? tickAll
            ? debugPrint("nothing to do")
            : sendIndustriesList.clear()
        : debugPrint("nothing to do");
    tickerSelectAll
        ? tickerTickAll
            ? debugPrint("nothing to do")
            : sendTickersList.clear()
        : debugPrint("nothing to do");
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'exchange': selectedIdItem,
          'industries': sendIndustriesList,
          'ticker_exist': true,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
          tickersNameList.clear();
          tickersLogoList.clear();
          tickersCatIdList.clear();
          tickersCodeList.clear();
          isCheckedNew.clear();
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  setState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                setState(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              //sendTickersList.clear();
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  setState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                setState(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
    } else {}
  }

  getTickersFunc({required StateSetter tickerSetState}) async {
    selectAll
        ? tickAll
            ? debugPrint("nothing to do")
            : sendIndustriesList.clear()
        : debugPrint("nothing to do");
    tickerSelectAll
        ? tickerTickAll
            ? debugPrint("nothing to do")
            : sendTickersList.clear()
        : debugPrint("nothing to do");
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'exchange': selectedIdItem,
          'industries': sendIndustriesList,
          'ticker_exist': false,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              //sendTickersList.clear();
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState(() {
                  isCheckedNew.add(false);
                });
              }
            }
            /*if(sendTickersList.length>0){
              if(sendTickersList.contains(responseData["response"][i]["_id"])){
                tickerSetState((){
                  isCheckedNew.add(true);
                });
              }else{
                tickerSetState((){
                  isCheckedNew.add(false);
                });
              }
            }
            else{
              tickerSetState((){
                isCheckedNew.add(false);
              });
            }*/
          }
        });
      }
      tickerSetState(() {
        indusLoader = false;
      });
    } else {
      tickerSetState(() {
        indusLoader = false;
      });
    }
    tickerSetState(() {
      indusLoader = false;
    });
  }

  //CRYPTO
  getCryptoIndustries({required StateSetter newSetState}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    industriesNameList.clear();
    industriesIdList.clear();
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: {
          'type': categoryValue.toLowerCase(),
          'skip': 0,
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        newSetState(() {
          industriesIdList.clear();
          industriesNameList.clear();
          for (int i = 0; i < responseData["response"].length; i++) {
            industriesNameList.add(responseData["response"][i]["name"]);
            industriesIdList.add(responseData["response"][i]["_id"]);
            if (tickerDetailIndustryExtra == industriesNameList[i]) {
              sendIndustriesList.add(industriesIdList[i]);
              sendIndustriesListCheck.add(industriesIdList[i]);
              _selectedExchange = i.toString();
              selectedTypeValue = industriesNameList[i];
            }
          }
        });
      }
    }
    setState(() {
      stateBool = true;
    });
  }

  getCryptoTickersFunc1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'industries': sendIndustriesList,
          'ticker_exist': true,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
          tickersNameList.clear();
          tickersLogoList.clear();
          tickersCatIdList.clear();
          tickersCodeList.clear();
          isCheckedNew.clear();
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  setState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                setState(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  setState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                setState(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
    } else {}
  }

  getCryptoTickersFunc({required StateSetter tickerSetState}) async {
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'industries': sendIndustriesList,
          'ticker_exist': false,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              //sendTickersList.clear();
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
      tickerSetState(() {
        indusLoader = false;
      });
    } else {
      tickerSetState(() {
        indusLoader = false;
      });
    }
    tickerSetState(() {
      indusLoader = false;
    });
  }

  getCryptoRefreshTickersFunc({required StateSetter tickerSetState1}) async {
    tickerSetState1(() {
      stocksInt += 100;
    });
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': stocksInt,
          'industries': sendIndustriesList,
          'ticker_exist': false,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState1(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState1(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState1(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState1(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState1(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState1(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState1(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
    } else {}
  }

  //COMMODITY

  getCommodityTickersFunc1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'country': selectedIdItem,
          'ticker_exist': true,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
          tickersNameList.clear();
          tickersLogoList.clear();
          tickersCatIdList.clear();
          tickersCodeList.clear();
          isCheckedNew.clear();
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  setState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                setState(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  setState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                setState(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
    } else {}
  }

  getCommodityTickersFunc({required StateSetter tickerSetState}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'country': selectedIdItem,
          'ticker_exist': false,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              //sendTickersList.clear();
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
      tickerSetState(() {
        indusLoader = false;
      });
    } else {
      tickerSetState(() {
        indusLoader = false;
      });
    }
  }

  getCommodityRefreshTickersFunc({required StateSetter tickerSetState1}) async {
    tickerSetState1(() {
      stocksInt += 20;
    });
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': stocksInt,
          'country': selectedIdItem,
          'ticker_exist': false,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState1(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState1(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState1(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState1(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState1(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState1(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState1(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
    } else {}
  }

  //FOREX

  getForexTickersFunc1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'ticker_exist': true,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        setState(() {
          tickersNameList.clear();
          tickersLogoList.clear();
          tickersCatIdList.clear();
          tickersCodeList.clear();
          isCheckedNew.clear();
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  setState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                setState(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  setState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  setState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                setState(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
    } else {}
  }

  getForexTickersFunc({required StateSetter tickerSetState}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': 0,
          'ticker_exist': false,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              //sendTickersList.clear();
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
    } else {}
  }

  getForexRefreshTickersFunc({required StateSetter tickerSetState1}) async {
    tickerSetState1(() {
      stocksInt += 20;
    });
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: {
          'category': categoryValue.toLowerCase(),
          'search': _tickerSearchController.text.isEmpty ? "" : _tickerSearchController.text,
          'skip': stocksInt,
          'ticker_exist': false,
          'tickers': sendTickersList
        },
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState1(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            tickersNameList.add(responseData["response"][i]["name"]);
            tickersLogoList.add(responseData["response"][i]["logo_url"]);
            tickersCatIdList.add(responseData["response"][i]["_id"]);
            tickersCodeList.add(responseData["response"][i]["code"]);
            if (tickerSelectAll) {
              sendTickersList.addAll(tickersCatIdList);
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState1(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState1(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState1(() {
                  isCheckedNew.add(false);
                });
              }
            } else {
              if (sendTickersList.isNotEmpty) {
                if (sendTickersList.contains(responseData["response"][i]["_id"])) {
                  tickerSetState1(() {
                    isCheckedNew.add(true);
                  });
                } else {
                  tickerSetState1(() {
                    isCheckedNew.add(false);
                  });
                }
              } else {
                tickerSetState1(() {
                  isCheckedNew.add(false);
                });
              }
            }
          }
        });
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: const Color(0XFFFFFFFF),
      child: SafeArea(
        child: Scaffold(
          body: stateBool
              ? widget.text.toLowerCase() == "stocks"
                  ? SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height / 45.11,
                            ),
                            //heading
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (!mounted) {
                                        return;
                                      }
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.black,
                                      size: 24,
                                    )),
                                const Text(
                                  "Filter",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height / 58,
                            ),
                            //subheading
                            Container(
                              height: height / 14.5,
                              width: double.infinity,
                              color: const Color(0XFFA5A5A5).withOpacity(0.1),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: Text("Filter list", style: TextStyle(color: Color(0xFF4A4A4A), fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            //main filters
                            Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30),
                                          ),
                                        ),
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        enableDrag: false,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter modelSetState) {
                                              return SingleChildScrollView(
                                                child: Container(
                                                  margin: const EdgeInsets.all(15.0),
                                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: height / 54.13,
                                                      ),
                                                      const Row(
                                                        children: [
                                                          Text(
                                                            "Exchanges",
                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF000000), fontSize: 16.0),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: height / 50.75,
                                                      ),
                                                      /*TextFormField(
                                              onChanged: (value) {

                                              },
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Poppins"),
                                              controller:
                                              _exchangeSearchController,
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey.shade100,
                                                prefixIcon: IconButton(
                                                  onPressed: () {},
                                                  icon: SvgPicture.asset(
                                                      "lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                ),
                                                contentPadding: EdgeInsets.all(
                                                    _height / 35.6),
                                                focusedErrorBorder:
                                                OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffEFEFEF),
                                                      width: 3),
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                                focusedBorder:
                                                OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffEFEFEF),
                                                      width: 3),
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                                enabledBorder:
                                                OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffEFEFEF),
                                                      width: 3),
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                                hintStyle: const TextStyle(
                                                    color: Color(0XFFA5A5A5),
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    fontFamily: "Poppins"),
                                                hintText: 'Search here',
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color(0xffEFEFEF),
                                                      width: 3),
                                                  borderRadius:
                                                  BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: _height/50.75,
                                            ),
                                            Text(
                                              "Name of Exchanges",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                  color: Color(0XFF000000)),
                                            ),
                                            SizedBox(
                                              height: _height/50.75,
                                            ),*/
                                                      Stack(
                                                        alignment: AlignmentDirectional.bottomCenter,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: height / 2.37,
                                                                child: ListView.builder(
                                                                    itemCount: exchangeNameList.length,
                                                                    itemBuilder: (BuildContext context, index) {
                                                                      return RadioListTile(
                                                                        activeColor: Colors.green,
                                                                        controlAffinity: ListTileControlAffinity.trailing,
                                                                        value: index.toString(),
                                                                        groupValue: _selectedExchange,
                                                                        onChanged: (value) {
                                                                          modelSetState(() {
                                                                            sendIndustriesList.clear();
                                                                            sendTickersList.clear();
                                                                            _selectedExchange = value.toString();
                                                                            _industriesController.clear();
                                                                            _stockTickersController.clear();
                                                                            selectedIdItem = exchangeIdList[index];
                                                                            selectedExchangeName = exchangeNameList[index];
                                                                          });
                                                                        },
                                                                        title: Text(
                                                                          exchangeNameList[index],
                                                                          style: const TextStyle(
                                                                              fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                                                        ),
                                                                        subtitle: Text(
                                                                          exchangeCodeList[index],
                                                                          style: const TextStyle(
                                                                              fontSize: 12,
                                                                              color: Color(0XFFA5A5A5),
                                                                              fontFamily: "Poppins",
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      );
                                                                    }),
                                                              ),
                                                              SizedBox(
                                                                height: height / 20.3,
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: height / 14.24,
                                                            color: Colors.white,
                                                            child: excLoader
                                                                ? Center(
                                                                    child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                                        height: 100, width: 100),
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            if (!mounted) {
                                                                              return;
                                                                            }
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(color: Colors.lightGreenAccent),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: const Color(0XFF0EA102).withOpacity(0.1),
                                                                            ),
                                                                            child: const Center(
                                                                                child: Text("Cancel",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.bold, color: Color(0XFF0EA102)))),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 7,
                                                                      ),
                                                                      Expanded(
                                                                        child: GestureDetector(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              if (editExchange != selectedIdItem) {
                                                                                sendIndustriesList.clear();
                                                                                sendIndustriesNameList.clear();
                                                                                sendTickersList.clear();
                                                                                sendTickersNameList.clear();
                                                                                industriesIdList.clear();
                                                                                industriesNameList.clear();
                                                                                indusBool.clear();
                                                                                tickersCatIdList.clear();
                                                                                tickersCodeList.clear();
                                                                                tickersNameList.clear();
                                                                                tickersLogoList.clear();
                                                                                isCheckedNew.clear();
                                                                                selectAll = false;
                                                                                tickerSelectAll = false;
                                                                              } else {}
                                                                              _exchangeController.text = selectedExchangeName;
                                                                            });
                                                                            modelSetState(() {
                                                                              excLoader = true;
                                                                            });
                                                                            await getIndustries(newSetState: modelSetState);
                                                                            if (!mounted) {
                                                                              return;
                                                                            }
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(color: Colors.lightGreenAccent),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: const Color(0XFF0EA102),
                                                                            ),
                                                                            child: const Center(
                                                                                child: Text("Save",
                                                                                    style:
                                                                                        TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        });
                                  },
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Exchange:',
                                        style: TextStyle(fontSize: 14, color: Color(0XFF000000), fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        enabled: false,
                                        style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                        controller: _exchangeController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                          contentPadding: const EdgeInsets.all(20),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          labelStyle: const TextStyle(
                                              color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                          labelText: 'Exchange',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30),
                                          ),
                                        ),
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        enableDrag: false,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter modelSetState) {
                                              return SingleChildScrollView(
                                                child: Container(
                                                  margin: const EdgeInsets.all(15.0),
                                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: height / 54.13,
                                                      ),
                                                      const Row(
                                                        children: [
                                                          Text(
                                                            "Industries",
                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF000000), fontSize: 16.0),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: height / 50.75,
                                                      ),
                                                      TextFormField(
                                                        onChanged: (value) async {
                                                          if (value.isNotEmpty) {
                                                            textValue = value;
                                                            industriesNameList.clear();
                                                            industriesIdList.clear();
                                                            indusBool.clear();
                                                            await getIndustries(newSetState: modelSetState);
                                                          } else if (value.isEmpty) {
                                                            textValue = "";
                                                            industriesNameList.clear();
                                                            industriesIdList.clear();
                                                            indusBool.clear();
                                                            await getIndustries(newSetState: modelSetState);
                                                          } else {
                                                            textValue = "";
                                                            industriesNameList.clear();
                                                            industriesIdList.clear();
                                                            indusBool.clear();
                                                            await getIndustries(newSetState: modelSetState);
                                                          }
                                                        },
                                                        style: const TextStyle(fontSize: 12, fontFamily: "Poppins"),
                                                        controller: _industrySearchController,
                                                        keyboardType: TextInputType.emailAddress,
                                                        decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor: Colors.grey.shade100,
                                                          prefixIcon: IconButton(
                                                            onPressed: () {},
                                                            icon: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                          ),
                                                          contentPadding: EdgeInsets.all(height / 35.6),
                                                          focusedErrorBorder: OutlineInputBorder(
                                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          hintStyle: const TextStyle(
                                                              color: Color(0XFFA5A5A5),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.normal,
                                                              fontFamily: "Poppins"),
                                                          hintText: 'Search here',
                                                          border: OutlineInputBorder(
                                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height / 50.75,
                                                      ),
                                                      const Text(
                                                        "Name of Industries",
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Color(0XFF000000)),
                                                      ),
                                                      SizedBox(
                                                        height: height / 50.75,
                                                      ),
                                                      Stack(
                                                        alignment: AlignmentDirectional.bottomCenter,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width / 2.5,
                                                                    child: CheckboxListTile(
                                                                      title: const Text(
                                                                        "Select All",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold, fontSize: 12.0, color: Color(0XFF000000)),
                                                                      ),
                                                                      autofocus: false,
                                                                      activeColor: Colors.green,
                                                                      //selected: _value,
                                                                      value: selectAll,
                                                                      checkboxShape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                      ),
                                                                      onChanged: (bool? value) async {
                                                                        if (value!) {
                                                                          sendIndustriesList.clear();
                                                                          _stockTickersController.clear();
                                                                          industriesNameList.clear();
                                                                          industriesIdList.clear();
                                                                          indusBool.clear();
                                                                          modelSetState(() {
                                                                            selectAll = value;
                                                                            _industrySearchController.text.isEmpty ? tickAll = false : tickAll = true;
                                                                          });
                                                                        } else {
                                                                          industriesNameList.clear();
                                                                          industriesIdList.clear();
                                                                          indusBool.clear();
                                                                          modelSetState(() {
                                                                            selectAll = value;
                                                                            tickAll = value;
                                                                            sendIndustriesList.clear();
                                                                          });
                                                                        }
                                                                        await getIndustries(newSetState: modelSetState);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: height / 2.37,
                                                                child: SmartRefresher(
                                                                  controller: _controller,
                                                                  enablePullDown: false,
                                                                  enablePullUp: true,
                                                                  footer: CustomFooter(
                                                                    builder: (BuildContext context, LoadStatus? mode) {
                                                                      Widget body;
                                                                      if (mode == LoadStatus.idle) {
                                                                        body = const Text("pull up load");
                                                                      } else if (mode == LoadStatus.loading) {
                                                                        body = const CupertinoActivityIndicator();
                                                                      } else if (mode == LoadStatus.failed) {
                                                                        body = const Text("Load Failed!Click retry!");
                                                                      } else if (mode == LoadStatus.canLoading) {
                                                                        body = const Text("release to load more");
                                                                      } else {
                                                                        body = const Text("No more Data");
                                                                      }

                                                                      return SizedBox(
                                                                        height: 55.0,
                                                                        child: Center(child: body),
                                                                      );
                                                                    },
                                                                  ),
                                                                  onLoading: () async {
                                                                    await getRefreshIndus(newSetState: modelSetState);
                                                                    if (mounted) {
                                                                      modelSetState(() {});
                                                                    }
                                                                    _controller.loadComplete();
                                                                  },
                                                                  child: ListView.builder(
                                                                      itemCount: industriesNameList.length,
                                                                      itemBuilder: (BuildContext context, index) {
                                                                        return CheckboxListTile(
                                                                          title: Text(
                                                                            industriesNameList[index],
                                                                            style: const TextStyle(
                                                                                fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                                                          ),
                                                                          autofocus: false,
                                                                          activeColor: Colors.green,
                                                                          //selected: _value,
                                                                          value: indusBool[index],
                                                                          checkboxShape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                          ),
                                                                          onChanged: (bool? value) {
                                                                            if (value!) {
                                                                              modelSetState(() {
                                                                                indusBool[index] = value;
                                                                                sendIndustriesList.add(industriesIdList[index]);
                                                                                sendIndustriesNameList.add(industriesNameList[index]);
                                                                              });
                                                                            } else {
                                                                              modelSetState(() {
                                                                                indusBool[index] = value;
                                                                                for (int i = 0; i < sendIndustriesList.length; i++) {
                                                                                  if (sendIndustriesList[i] == industriesIdList[index]) {
                                                                                    modelSetState(() {
                                                                                      sendIndustriesList.removeAt(i);
                                                                                      selectAll = false;
                                                                                    });
                                                                                  }
                                                                                }
                                                                              });
                                                                            }
                                                                          },
                                                                        );
                                                                      }),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 20.3,
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: height / 14.24,
                                                            color: Colors.white,
                                                            child: indusLoader
                                                                ? Center(
                                                                    child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                                        height: 100, width: 100),
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child: GestureDetector(
                                                                          onTap: () async {
                                                                            if (!mounted) {
                                                                              return;
                                                                            }
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(color: Colors.lightGreenAccent),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: const Color(0XFF0EA102).withOpacity(0.1),
                                                                            ),
                                                                            child: const Center(
                                                                                child: Text("Cancel",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.bold, color: Color(0XFF0EA102)))),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 7,
                                                                      ),
                                                                      Expanded(
                                                                        child: GestureDetector(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              if (eq(sendIndustriesListCheck, sendIndustriesList)) {
                                                                              } else {
                                                                                sendTickersList.clear();
                                                                                sendTickersNameList.clear();
                                                                                tickersCatIdList.clear();
                                                                                tickersCodeList.clear();
                                                                                tickersNameList.clear();
                                                                                tickersLogoList.clear();
                                                                                isCheckedNew.clear();
                                                                                tickerSelectAll = false;
                                                                              }
                                                                              if (selectAll) {
                                                                                _industriesController.text = "Multiple";
                                                                              } else {
                                                                                if (sendIndustriesList.length == 1) {
                                                                                  _industriesController.text = "Single";
                                                                                } else if (sendIndustriesList.isEmpty) {
                                                                                  _industriesController.text = "Nothing";
                                                                                } else {
                                                                                  _industriesController.text = "Multiple";
                                                                                }
                                                                              }
                                                                            });
                                                                            modelSetState(() {
                                                                              indusLoader = true;
                                                                            });
                                                                            await getTickersFunc(tickerSetState: modelSetState);
                                                                            if (!mounted) {
                                                                              return;
                                                                            }
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(color: Colors.lightGreenAccent),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: const Color(0XFF0EA102),
                                                                            ),
                                                                            child: const Center(
                                                                                child: Text("Save",
                                                                                    style:
                                                                                        TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        });
                                  },
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Industries:',
                                        style: TextStyle(fontSize: 14, color: Color(0XFF000000), fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        enabled: false,
                                        style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                        controller: _industriesController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                          contentPadding: const EdgeInsets.all(20),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          labelStyle: const TextStyle(
                                              color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                          labelText: 'Industries',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30),
                                          ),
                                        ),
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: false,
                                        enableDrag: false,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context, StateSetter modelSetState) {
                                              return SingleChildScrollView(
                                                child: Container(
                                                  margin: const EdgeInsets.all(15.0),
                                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: height / 54.13,
                                                      ),
                                                      const Row(
                                                        children: [
                                                          Text(
                                                            "Stocks",
                                                            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF000000), fontSize: 16.0),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: height / 50.75,
                                                      ),
                                                      TextFormField(
                                                        onChanged: (value) async {
                                                          if (value.isNotEmpty) {
                                                            tickersTextValue = value;
                                                            tickersNameList.clear();
                                                            tickersLogoList.clear();
                                                            tickersCatIdList.clear();
                                                            tickersCodeList.clear();
                                                            isCheckedNew.clear();
                                                            await getTickersFunc(tickerSetState: modelSetState);
                                                          } else if (value.isEmpty) {
                                                            tickersTextValue = "";
                                                            tickersNameList.clear();
                                                            tickersLogoList.clear();
                                                            tickersCatIdList.clear();
                                                            tickersCodeList.clear();
                                                            isCheckedNew.clear();
                                                            await getTickersFunc(tickerSetState: modelSetState);
                                                          } else {
                                                            tickersTextValue = "";
                                                            tickersNameList.clear();
                                                            tickersLogoList.clear();
                                                            tickersCatIdList.clear();
                                                            tickersCodeList.clear();
                                                            isCheckedNew.clear();
                                                            await getTickersFunc(tickerSetState: modelSetState);
                                                          }
                                                        },
                                                        style: const TextStyle(fontSize: 12, fontFamily: "Poppins"),
                                                        controller: _tickerSearchController,
                                                        keyboardType: TextInputType.emailAddress,
                                                        decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor: Colors.grey.shade100,
                                                          prefixIcon: IconButton(
                                                            onPressed: () {},
                                                            icon: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                          ),
                                                          contentPadding: EdgeInsets.all(height / 35.6),
                                                          focusedErrorBorder: OutlineInputBorder(
                                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          hintStyle: const TextStyle(
                                                              color: Color(0XFFA5A5A5),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.normal,
                                                              fontFamily: "Poppins"),
                                                          hintText: 'Search here',
                                                          border: OutlineInputBorder(
                                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height / 50.75,
                                                      ),
                                                      const Text(
                                                        "Name of Stocks",
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Color(0XFF000000)),
                                                      ),
                                                      SizedBox(
                                                        height: height / 50.75,
                                                      ),
                                                      Stack(
                                                        alignment: AlignmentDirectional.bottomCenter,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width / 2.5,
                                                                    child: CheckboxListTile(
                                                                      title: const Text(
                                                                        "Select All",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold, fontSize: 12.0, color: Color(0XFF000000)),
                                                                      ),
                                                                      autofocus: false,
                                                                      activeColor: Colors.green,
                                                                      value: tickerSelectAll,
                                                                      checkboxShape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                      ),
                                                                      onChanged: (bool? value) async {
                                                                        if (value!) {
                                                                          sendTickersList.clear();
                                                                          tickersNameList.clear();
                                                                          tickersLogoList.clear();
                                                                          tickersCatIdList.clear();
                                                                          tickersCodeList.clear();
                                                                          isCheckedNew.clear();
                                                                          modelSetState(() {
                                                                            tickerSelectAll = value;
                                                                            _tickerSearchController.text.isEmpty
                                                                                ? tickerTickAll = false
                                                                                : tickerTickAll = true;
                                                                          });
                                                                        } else {
                                                                          tickersNameList.clear();
                                                                          tickersLogoList.clear();
                                                                          tickersCatIdList.clear();
                                                                          tickersCodeList.clear();
                                                                          isCheckedNew.clear();
                                                                          modelSetState(() {
                                                                            tickerSelectAll = value;
                                                                            sendTickersList.clear();
                                                                            tickerTickAll = value;
                                                                          });
                                                                        }
                                                                        await getTickersFunc(tickerSetState: modelSetState);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: height / 2.37,
                                                                child: SmartRefresher(
                                                                  controller: _refreshController,
                                                                  enablePullDown: false,
                                                                  enablePullUp: true,
                                                                  footer: CustomFooter(
                                                                    builder: (BuildContext context, LoadStatus? mode) {
                                                                      Widget body;
                                                                      if (mode == LoadStatus.idle) {
                                                                        body = const Text("pull up load");
                                                                      } else if (mode == LoadStatus.loading) {
                                                                        body = const CupertinoActivityIndicator();
                                                                      } else if (mode == LoadStatus.failed) {
                                                                        body = const Text("Load Failed!Click retry!");
                                                                      } else if (mode == LoadStatus.canLoading) {
                                                                        body = const Text("release to load more");
                                                                      } else {
                                                                        body = const Text("No more Data");
                                                                      }

                                                                      return SizedBox(
                                                                        height: 55.0,
                                                                        child: Center(child: body),
                                                                      );
                                                                    },
                                                                  ),
                                                                  onLoading: () async {
                                                                    await getRefreshTickersFunc(tickerSetState1: modelSetState);
                                                                    if (mounted) {
                                                                      modelSetState(() {});
                                                                    }
                                                                    _refreshController.loadComplete();
                                                                  },
                                                                  child: ListView.builder(
                                                                      itemCount: tickersNameList.length,
                                                                      itemBuilder: (BuildContext context, index) {
                                                                        return CheckboxListTile(
                                                                          title: Text(
                                                                            tickersNameList[index],
                                                                            style: const TextStyle(
                                                                                fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                                                          ),
                                                                          subtitle: Text(
                                                                            tickersCodeList[index],
                                                                            style: const TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 12.0,
                                                                                color: Color(0XFFA5A5A5)),
                                                                          ),
                                                                          secondary: SizedBox(
                                                                              height: height / 23.73,
                                                                              width: width / 12,
                                                                              child: tickersLogoList[index].contains("svg")
                                                                                  ? SvgPicture.network(tickersLogoList[index], fit: BoxFit.fill)
                                                                                  : Image.network(tickersLogoList[index], fit: BoxFit.fill)),
                                                                          autofocus: false,
                                                                          activeColor: Colors.green,
                                                                          //selected: _value,
                                                                          value: isCheckedNew[index],
                                                                          checkboxShape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                          ),
                                                                          onChanged: (bool? value) {
                                                                            if (value!) {
                                                                              modelSetState(() {
                                                                                isCheckedNew[index] = value;
                                                                                sendTickersList.add(tickersCatIdList[index]);
                                                                                sendTickersNameList.add(tickersNameList[index]);
                                                                              });
                                                                            } else {
                                                                              modelSetState(() {
                                                                                isCheckedNew[index] = value;
                                                                                for (int i = 0; i < sendTickersList.length; i++) {
                                                                                  if (sendTickersList[i] == tickersCatIdList[index]) {
                                                                                    sendTickersList.removeAt(i);
                                                                                    tickerSelectAll = false;
                                                                                  }
                                                                                }
                                                                              });
                                                                            }
                                                                          },
                                                                        );
                                                                      }),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 20.3,
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            height: height / 14.24,
                                                            color: Colors.white,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: GestureDetector(
                                                                    onTap: () async {
                                                                      if (!mounted) {
                                                                        return;
                                                                      }
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.lightGreenAccent),
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        color: const Color(0XFF0EA102).withOpacity(0.1),
                                                                      ),
                                                                      child: const Center(
                                                                          child: Text("Cancel",
                                                                              style:
                                                                                  TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF0EA102)))),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 7,
                                                                ),
                                                                Expanded(
                                                                  child: GestureDetector(
                                                                    onTap: () async {
                                                                      setState(() {
                                                                        if (tickerSelectAll) {
                                                                          _stockTickersController.text = "Multiple";
                                                                        } else {
                                                                          if (sendTickersList.length == 1) {
                                                                            _stockTickersController.text = "Single";
                                                                          } else if (sendTickersList.isEmpty) {
                                                                            _stockTickersController.text = "Nothing";
                                                                          } else {
                                                                            _stockTickersController.text = "Multiple";
                                                                          }
                                                                        }
                                                                      });
                                                                      if (!mounted) {
                                                                        return;
                                                                      }
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.lightGreenAccent),
                                                                        borderRadius: BorderRadius.circular(10),
                                                                        color: const Color(0XFF0EA102),
                                                                      ),
                                                                      child: const Center(
                                                                          child: Text("Save",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        });
                                  },
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Stocks(optional):',
                                        style: TextStyle(fontSize: 14, color: Color(0XFF000000), fontWeight: FontWeight.w400),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        enabled: false,
                                        style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                        controller: _stockTickersController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                          contentPadding: const EdgeInsets.all(20),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          labelStyle: const TextStyle(
                                              color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                          labelText: 'Stocks',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height / 40.6,
                            ),
                            //main Text Form
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                controller: _listNameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(20),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                  labelText: 'List Name',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            //Text
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              child: const Text(
                                "Note: Avoid duplicate list names within the same category.",
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                              ),
                            ),
                            SizedBox(
                              height: height / 33.83,
                            ),
                            //Final Buttons
                            loading2
                                ? Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100))
                                : Container(
                                    height: height / 16.24,
                                    margin: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              if (!mounted) {
                                                return;
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.grey.shade400),
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.white,
                                              ),
                                              child: const Center(
                                                  child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              logEventFunc(name: 'Filter_Created', type: 'Locker');
                                              if (_listNameController.text.isEmpty) {
                                                Flushbar(
                                                  message: "List Name is Mandatory, Please provide List Name to Continue",
                                                  duration: const Duration(seconds: 2),
                                                ).show(context);
                                              } else {
                                                setState(() {
                                                  loading2 = true;
                                                });
                                                selectAll
                                                    ? tickAll
                                                        ? debugPrint("nothing to do")
                                                        : sendIndustriesList.clear()
                                                    : debugPrint("nothing to do");
                                                tickerSelectAll
                                                    ? tickerTickAll
                                                        ? debugPrint("nothing to do")
                                                        : sendTickersList.clear()
                                                    : debugPrint("nothing to do");
                                                var responseValue = await _filterFunction.getAddFilter(
                                                    type: categoryValue.toLowerCase(),
                                                    title: _listNameController.text,
                                                    cid: mainCatIdList[0],
                                                    exc: selectedIdItem,
                                                    indus: sendIndustriesList,
                                                    tickers: sendTickersList,
                                                    allIndus: selectAll
                                                        ? tickAll
                                                            ? false
                                                            : true
                                                        : false,
                                                    allTickers: tickerSelectAll
                                                        ? tickerTickAll
                                                            ? false
                                                            : true
                                                        : false);
                                                await getFil(type: widget.text);
                                                setState(() {
                                                  loading2 = false;
                                                });
                                                if (responseValue["status"]) {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return widget.fromWhere == 'news'
                                                        ? NewsMainPage(
                                                            fromCompare: false,
                                                            text: widget.text,
                                                            tickerId: "",
                                                            tickerName: "",
                                                          )
                                                        : widget.fromWhere == 'videos'
                                                            ? VideosMainPage(
                                                                fromCompare: false,
                                                                text: widget.text,
                                                                tickerId: "",
                                                                tickerName: "",
                                                              )
                                                            : widget.fromWhere == 'forum'
                                                                ? DetailedForumImagePage(
                                                                    text: widget.text,
                                                                    fromCompare: false,
                                                                    forumDetail: "",
                                                                    filterId: enteredFilteredIdList[0],
                                                                    catIdList: mainCatIdList,
                                                                    topic: "",
                                                                    tickerId: "",
                                                                    tickerName: "",
                                                                    navBool: false,
                                                                    sendUserId: "",
                                                                  )
                                                                : widget.fromWhere == 'survey'
                                                                    ? DetailedSurveyImagePage(
                                                                        surveyDetail: "",
                                                                        topic: '',
                                                                        catIdList: mainCatIdList,
                                                                        text: widget.text,
                                                                        filterId: enteredFilteredIdList[0],
                                                                        tickerId: "",
                                                                        tickerName: "",
                                                                        fromCompare: false,
                                                                      )
                                                                    : const MainBottomNavigationPage(
                                                                        tType: true,
                                                                        countryIndex: 0,
                                                                        text: '',
                                                                        caseNo1: 0,
                                                                        excIndex: 0,
                                                                        newIndex: 0,
                                                                        isHomeFirstTym: false,
                                                                      );
                                                  }));
                                                } else {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Flushbar(
                                                    message: responseValue["message"],
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                }
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.lightGreenAccent),
                                                borderRadius: BorderRadius.circular(10),
                                                color: const Color(0XFF0EA102),
                                              ),
                                              child: const Center(
                                                  child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    )
                  : widget.text.toLowerCase() == "crypto"
                      ? SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: height / 45.11,
                                ),
                                //heading
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.clear,
                                          color: Colors.black,
                                          size: 24,
                                        )),
                                    const Text(
                                      "Filter",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height / 58,
                                ),
                                //subheading
                                Container(
                                  height: height / 14.5,
                                  width: double.infinity,
                                  color: const Color(0XFFA5A5A5).withOpacity(0.1),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.0),
                                        child: Text("Filter list",
                                            style: TextStyle(color: Color(0xFF4A4A4A), fontSize: 16, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                //main filters
                                Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(30),
                                              ),
                                            ),
                                            context: context,
                                            isScrollControlled: true,
                                            isDismissible: false,
                                            enableDrag: false,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (BuildContext context, StateSetter modelSetState) {
                                                  return SingleChildScrollView(
                                                    child: Container(
                                                      margin: const EdgeInsets.all(15.0),
                                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: height / 54.13,
                                                          ),
                                                          const Row(
                                                            children: [
                                                              Text(
                                                                "Type",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF000000), fontSize: 16.0),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: height / 50.75,
                                                          ),
                                                          Stack(
                                                            alignment: AlignmentDirectional.bottomCenter,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: height / 2.37,
                                                                    child: SmartRefresher(
                                                                      controller: _controller,
                                                                      enablePullDown: false,
                                                                      enablePullUp: true,
                                                                      footer: CustomFooter(
                                                                        builder: (BuildContext context, LoadStatus? mode) {
                                                                          Widget body;
                                                                          if (mode == LoadStatus.idle) {
                                                                            body = const Text("pull up load");
                                                                          } else if (mode == LoadStatus.loading) {
                                                                            body = const CupertinoActivityIndicator();
                                                                          } else if (mode == LoadStatus.failed) {
                                                                            body = const Text("Load Failed!Click retry!");
                                                                          } else if (mode == LoadStatus.canLoading) {
                                                                            body = const Text("release to load more");
                                                                          } else {
                                                                            body = const Text("No more Data");
                                                                          }

                                                                          return SizedBox(
                                                                            height: 55.0,
                                                                            child: Center(child: body),
                                                                          );
                                                                        },
                                                                      ),
                                                                      onLoading: () async {
                                                                        if (mounted) {
                                                                          modelSetState(() {});
                                                                        }
                                                                        _controller.loadComplete();
                                                                      },
                                                                      child: ListView.builder(
                                                                          itemCount: industriesNameList.length,
                                                                          itemBuilder: (BuildContext context, index) {
                                                                            return RadioListTile(
                                                                              activeColor: Colors.green,
                                                                              controlAffinity: ListTileControlAffinity.trailing,
                                                                              value: index.toString(),
                                                                              groupValue: _selectedExchange,
                                                                              onChanged: (value) {
                                                                                modelSetState(() {
                                                                                  sendTickersList.clear();
                                                                                  _cryptoTickersController.clear();
                                                                                  _selectedExchange = value.toString();
                                                                                  sendIndustriesList.clear();
                                                                                  sendIndustriesList.add(industriesIdList[index]);
                                                                                  selectedTypeValue = industriesNameList[index];
                                                                                });
                                                                              },
                                                                              title: Text(
                                                                                industriesNameList[index],
                                                                                style: const TextStyle(
                                                                                    fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                                                              ),
                                                                            );
                                                                          }),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 20.3,
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                height: height / 14.24,
                                                                color: Colors.white,
                                                                child: indusLoader
                                                                    ? Center(
                                                                        child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                                            height: 100, width: 100),
                                                                      )
                                                                    : Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child: GestureDetector(
                                                                              onTap: () {
                                                                                if (!mounted) {
                                                                                  return;
                                                                                }
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(color: Colors.lightGreenAccent),
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  color: const Color(0XFF0EA102).withOpacity(0.1),
                                                                                ),
                                                                                child: const Center(
                                                                                    child: Text("Cancel",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.bold, color: Color(0XFF0EA102)))),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 7,
                                                                          ),
                                                                          Expanded(
                                                                            child: GestureDetector(
                                                                              onTap: () async {
                                                                                modelSetState(() {
                                                                                  indusLoader = true;
                                                                                });
                                                                                setState(() {
                                                                                  if (eq(sendIndustriesListCheck, sendIndustriesList)) {
                                                                                  } else {
                                                                                    sendTickersList.clear();
                                                                                    sendTickersNameList.clear();
                                                                                    tickersCatIdList.clear();
                                                                                    tickersCodeList.clear();
                                                                                    tickersNameList.clear();
                                                                                    tickersLogoList.clear();
                                                                                    isCheckedNew.clear();
                                                                                    tickerSelectAll = false;
                                                                                  }
                                                                                  _typeController.text = selectedTypeValue;
                                                                                });
                                                                                await getCryptoTickersFunc(tickerSetState: modelSetState);
                                                                                if (!mounted) {
                                                                                  return;
                                                                                }
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(color: Colors.lightGreenAccent),
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                  color: const Color(0XFF0EA102),
                                                                                ),
                                                                                child: const Center(
                                                                                    child: Text("Save",
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.bold, color: Colors.white))),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            });
                                      },
                                      title: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Type:',
                                            style: TextStyle(fontSize: 14, color: Color(0XFF000000), fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            readOnly: true,
                                            enabled: false,
                                            style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                            controller: _typeController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                              contentPadding: const EdgeInsets.all(20),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              labelStyle: const TextStyle(
                                                  color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                              labelText: 'Type',
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(30),
                                              ),
                                            ),
                                            context: context,
                                            isScrollControlled: true,
                                            isDismissible: false,
                                            enableDrag: false,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (BuildContext context, StateSetter modelSetState) {
                                                  return SingleChildScrollView(
                                                    child: Container(
                                                      margin: const EdgeInsets.all(15.0),
                                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: height / 54.13,
                                                          ),
                                                          const Row(
                                                            children: [
                                                              Text(
                                                                "Crypto",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF000000), fontSize: 16.0),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: height / 50.75,
                                                          ),
                                                          TextFormField(
                                                            onChanged: (value) async {
                                                              if (value.isNotEmpty) {
                                                                tickersTextValue = value;
                                                                tickersNameList.clear();
                                                                tickersLogoList.clear();
                                                                tickersCatIdList.clear();
                                                                tickersCodeList.clear();
                                                                isCheckedNew.clear();
                                                                await getCryptoTickersFunc(tickerSetState: modelSetState);
                                                              } else if (value.isEmpty) {
                                                                tickersTextValue = "";
                                                                tickersNameList.clear();
                                                                tickersLogoList.clear();
                                                                tickersCatIdList.clear();
                                                                tickersCodeList.clear();
                                                                isCheckedNew.clear();
                                                                await getCryptoTickersFunc(tickerSetState: modelSetState);
                                                              } else {
                                                                tickersTextValue = "";
                                                                tickersNameList.clear();
                                                                tickersLogoList.clear();
                                                                tickersCatIdList.clear();
                                                                tickersCodeList.clear();
                                                                isCheckedNew.clear();
                                                                await getCryptoTickersFunc(tickerSetState: modelSetState);
                                                              }
                                                            },
                                                            style: const TextStyle(fontSize: 12, fontFamily: "Poppins"),
                                                            controller: _tickerSearchController,
                                                            keyboardType: TextInputType.emailAddress,
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.grey.shade100,
                                                              prefixIcon: IconButton(
                                                                onPressed: () {},
                                                                icon: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                              ),
                                                              contentPadding: EdgeInsets.all(height / 35.6),
                                                              focusedErrorBorder: OutlineInputBorder(
                                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              hintStyle: const TextStyle(
                                                                  color: Color(0XFFA5A5A5),
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.normal,
                                                                  fontFamily: "Poppins"),
                                                              hintText: 'Search here',
                                                              border: OutlineInputBorder(
                                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50.75,
                                                          ),
                                                          const Text(
                                                            "Name of Crypto",
                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Color(0XFF000000)),
                                                          ),
                                                          SizedBox(
                                                            height: height / 50.75,
                                                          ),
                                                          Stack(
                                                            alignment: AlignmentDirectional.bottomCenter,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: width / 2.5,
                                                                        child: CheckboxListTile(
                                                                          title: const Text(
                                                                            "Select All",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 12.0,
                                                                                color: Color(0XFF000000)),
                                                                          ),
                                                                          autofocus: false,
                                                                          activeColor: Colors.green,
                                                                          //selected: _value,
                                                                          value: tickerSelectAll,
                                                                          checkboxShape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                          ),
                                                                          onChanged: (bool? value) async {
                                                                            if (value!) {
                                                                              sendTickersList.clear();
                                                                              tickersNameList.clear();
                                                                              tickersLogoList.clear();
                                                                              tickersCatIdList.clear();
                                                                              tickersCodeList.clear();
                                                                              isCheckedNew.clear();
                                                                              modelSetState(() {
                                                                                tickerSelectAll = value;
                                                                                _tickerSearchController.text.isEmpty
                                                                                    ? tickerTickAll = false
                                                                                    : tickerTickAll = true;
                                                                                //getTickersFunc( tickerSetState:modelSetState);
                                                                              });
                                                                            } else {
                                                                              tickersNameList.clear();
                                                                              tickersLogoList.clear();
                                                                              tickersCatIdList.clear();
                                                                              tickersCodeList.clear();
                                                                              isCheckedNew.clear();
                                                                              modelSetState(() {
                                                                                tickerSelectAll = value;
                                                                                tickerTickAll = value;
                                                                                sendTickersList.clear();
                                                                              });
                                                                              //getTickersFunc( tickerSetState:modelSetState);
                                                                            }
                                                                            await getCryptoTickersFunc(tickerSetState: modelSetState);
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 2.37,
                                                                    child: SmartRefresher(
                                                                      controller: _refreshController,
                                                                      enablePullDown: false,
                                                                      enablePullUp: true,
                                                                      footer: CustomFooter(
                                                                        builder: (BuildContext context, LoadStatus? mode) {
                                                                          Widget body;
                                                                          if (mode == LoadStatus.idle) {
                                                                            body = const Text("pull up load");
                                                                          } else if (mode == LoadStatus.loading) {
                                                                            body = const CupertinoActivityIndicator();
                                                                          } else if (mode == LoadStatus.failed) {
                                                                            body = const Text("Load Failed!Click retry!");
                                                                          } else if (mode == LoadStatus.canLoading) {
                                                                            body = const Text("release to load more");
                                                                          } else {
                                                                            body = const Text("No more Data");
                                                                          }

                                                                          return SizedBox(
                                                                            height: 55.0,
                                                                            child: Center(child: body),
                                                                          );
                                                                        },
                                                                      ),
                                                                      onLoading: () async {
                                                                        await getCryptoRefreshTickersFunc(tickerSetState1: modelSetState);
                                                                        if (mounted) {
                                                                          modelSetState(() {});
                                                                        }
                                                                        _refreshController.loadComplete();
                                                                      },
                                                                      child: ListView.builder(
                                                                          itemCount: tickersNameList.length,
                                                                          itemBuilder: (BuildContext context, index) {
                                                                            return CheckboxListTile(
                                                                              title: Text(
                                                                                tickersNameList[index],
                                                                                style: const TextStyle(
                                                                                    fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                                                              ),
                                                                              subtitle: Text(
                                                                                tickersCodeList[index],
                                                                                style: const TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: 12.0,
                                                                                    color: Color(0XFFA5A5A5)),
                                                                              ),
                                                                              secondary: SizedBox(
                                                                                  height: height / 23.73,
                                                                                  width: width / 12,
                                                                                  child: tickersLogoList[index].contains("svg")
                                                                                      ? SvgPicture.network(tickersLogoList[index], fit: BoxFit.fill)
                                                                                      : Image.network(tickersLogoList[index], fit: BoxFit.fill)),
                                                                              autofocus: false,
                                                                              activeColor: Colors.green,
                                                                              //selected: _value,
                                                                              value: isCheckedNew[index],
                                                                              checkboxShape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              onChanged: (bool? value) {
                                                                                if (value!) {
                                                                                  modelSetState(() {
                                                                                    isCheckedNew[index] = value;
                                                                                    sendTickersList.add(tickersCatIdList[index]);
                                                                                    sendTickersNameList.add(tickersNameList[index]);
                                                                                  });
                                                                                } else {
                                                                                  modelSetState(() {
                                                                                    isCheckedNew[index] = value;
                                                                                    for (int i = 0; i < sendTickersList.length; i++) {
                                                                                      if (sendTickersList[i] == tickersCatIdList[index]) {
                                                                                        sendTickersList.removeAt(i);
                                                                                        tickerSelectAll = false;
                                                                                      }
                                                                                    }
                                                                                  });
                                                                                }
                                                                              },
                                                                            );
                                                                          }),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 20.3,
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                height: height / 14.24,
                                                                color: Colors.white,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child: GestureDetector(
                                                                        onTap: () async {
                                                                          if (!mounted) {
                                                                            return;
                                                                          }
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: Colors.lightGreenAccent),
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            color: const Color(0XFF0EA102).withOpacity(0.1),
                                                                          ),
                                                                          child: const Center(
                                                                              child: Text("Cancel",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.bold, color: Color(0XFF0EA102)))),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 7,
                                                                    ),
                                                                    Expanded(
                                                                      child: GestureDetector(
                                                                        onTap: () async {
                                                                          if (tickerSelectAll) {
                                                                            _cryptoTickersController.text = "Multiple";
                                                                          } else {
                                                                            if (sendTickersList.length == 1) {
                                                                              _cryptoTickersController.text = "Single";
                                                                            } else if (sendTickersList.isEmpty) {
                                                                              _cryptoTickersController.text = "Nothing";
                                                                            } else {
                                                                              _cryptoTickersController.text = "Multiple";
                                                                            }
                                                                          }
                                                                          if (!mounted) {
                                                                            return;
                                                                          }
                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(color: Colors.lightGreenAccent),
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            color: const Color(0XFF0EA102),
                                                                          ),
                                                                          child: const Center(
                                                                              child: Text("Save",
                                                                                  style:
                                                                                      TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            });
                                      },
                                      title: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Crypto(optional):',
                                            style: TextStyle(fontSize: 14, color: Color(0XFF000000), fontWeight: FontWeight.w400),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            readOnly: true,
                                            enabled: false,
                                            style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                            controller: _cryptoTickersController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                              contentPadding: const EdgeInsets.all(20),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              labelStyle: const TextStyle(
                                                  color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                              labelText: 'Crypto',
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height / 40.6,
                                ),
                                //main Text Form
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                    controller: _listNameController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(20),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      labelStyle: const TextStyle(
                                          color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                      labelText: 'List Name',
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                //Text
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 15),
                                  child: const Text(
                                    "Note: Avoid duplicate list names within the same category.",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 33.83,
                                ),
                                //Final Buttons
                                loading2
                                    ? Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100))
                                    : Container(
                                        height: height / 16.24,
                                        margin: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey.shade400),
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.white,
                                                  ),
                                                  child: const Center(
                                                      child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () async {
                                                  logEventFunc(name: 'Filter_Created', type: 'Locker');
                                                  if (_listNameController.text.isEmpty) {
                                                    Flushbar(
                                                      message: "List Name is Mandatory, Please provide List Name to Continue",
                                                      duration: const Duration(seconds: 2),
                                                    ).show(context);
                                                  } else {
                                                    setState(() {
                                                      loading2 = true;
                                                    });
                                                    tickerSelectAll
                                                        ? tickerTickAll
                                                            ? debugPrint("nothing to do")
                                                            : sendTickersList.clear()
                                                        : debugPrint("nothing to do");
                                                    var responseValue = await _filterFunction.getAddFilter(
                                                        type: categoryValue.toLowerCase(),
                                                        title: _listNameController.text,
                                                        cid: mainCatIdList[1],
                                                        exc: "",
                                                        indus: sendIndustriesList,
                                                        tickers: sendTickersList,
                                                        allIndus: false,
                                                        allTickers: tickerSelectAll
                                                            ? tickerTickAll
                                                                ? false
                                                                : true
                                                            : false);
                                                    await getFil(type: widget.text);
                                                    setState(() {
                                                      loading2 = false;
                                                    });
                                                    if (responseValue["status"]) {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return widget.fromWhere == 'news'
                                                            ? NewsMainPage(
                                                                fromCompare: false,
                                                                text: widget.text,
                                                                tickerId: "",
                                                                tickerName: "",
                                                              )
                                                            : widget.fromWhere == 'videos'
                                                                ? VideosMainPage(
                                                                    fromCompare: false,
                                                                    text: widget.text,
                                                                    tickerId: "",
                                                                    tickerName: "",
                                                                  )
                                                                : widget.fromWhere == 'forum'
                                                                    ? DetailedForumImagePage(
                                                                        text: widget.text,
                                                                        fromCompare: false,
                                                                        forumDetail: "",
                                                                        filterId: enteredFilteredIdList[0],
                                                                        catIdList: mainCatIdList,
                                                                        topic: "",
                                                                        tickerId: "",
                                                                        tickerName: "",
                                                                        navBool: false,
                                                                        sendUserId: "",
                                                                      )
                                                                    : widget.fromWhere == 'survey'
                                                                        ? DetailedSurveyImagePage(
                                                                            surveyDetail: "",
                                                                            topic: '',
                                                                            catIdList: mainCatIdList,
                                                                            text: widget.text,
                                                                            filterId: enteredFilteredIdList[0],
                                                                            tickerId: "",
                                                                            tickerName: "",
                                                                            fromCompare: false,
                                                                          )
                                                                        : const MainBottomNavigationPage(
                                                                            tType: true,
                                                                            countryIndex: 0,
                                                                            text: '',
                                                                            caseNo1: 0,
                                                                            excIndex: 0,
                                                                            isHomeFirstTym: false,
                                                                            newIndex: 0,
                                                                          );
                                                      }));
                                                    } else {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Flushbar(
                                                        message: responseValue["message"],
                                                        duration: const Duration(seconds: 2),
                                                      ).show(context);
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.lightGreenAccent),
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: const Color(0XFF0EA102),
                                                  ),
                                                  child: const Center(
                                                      child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          ),
                        )
                      : widget.text.toLowerCase() == "commodity"
                          ? SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 15),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: height / 45.11,
                                    ),
                                    //heading
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (!mounted) {
                                                return;
                                              }
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.black,
                                              size: 24,
                                            )),
                                        const Text(
                                          "Filter",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: height / 58,
                                    ),
                                    //subheading
                                    Container(
                                      height: height / 14.5,
                                      width: double.infinity,
                                      color: const Color(0XFFA5A5A5).withOpacity(0.1),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 15.0),
                                            child: Text("Filter list",
                                                style: TextStyle(color: Color(0xFF4A4A4A), fontSize: 16, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    //main filters
                                    Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            showModalBottomSheet(
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(30),
                                                  ),
                                                ),
                                                context: context,
                                                isScrollControlled: true,
                                                isDismissible: false,
                                                enableDrag: false,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter modelSetState) {
                                                      return SingleChildScrollView(
                                                        child: Container(
                                                          margin: const EdgeInsets.all(15.0),
                                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: height / 54.13,
                                                              ),
                                                              const Row(
                                                                children: [
                                                                  Text(
                                                                    "Country",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold, color: Color(0XFF000000), fontSize: 16.0),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: height / 50.75,
                                                              ),
                                                              Stack(
                                                                alignment: AlignmentDirectional.bottomCenter,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: height / 2.37,
                                                                        child: SmartRefresher(
                                                                          controller: _controller,
                                                                          enablePullDown: false,
                                                                          enablePullUp: true,
                                                                          footer: CustomFooter(
                                                                            builder: (BuildContext context, LoadStatus? mode) {
                                                                              Widget body;
                                                                              if (mode == LoadStatus.idle) {
                                                                                body = const Text("pull up load");
                                                                              } else if (mode == LoadStatus.loading) {
                                                                                body = const CupertinoActivityIndicator();
                                                                              } else if (mode == LoadStatus.failed) {
                                                                                body = const Text("Load Failed!Click retry!");
                                                                              } else if (mode == LoadStatus.canLoading) {
                                                                                body = const Text("release to load more");
                                                                              } else {
                                                                                body = const Text("No more Data");
                                                                              }

                                                                              return SizedBox(
                                                                                height: 55.0,
                                                                                child: Center(child: body),
                                                                              );
                                                                            },
                                                                          ),
                                                                          onLoading: () async {
                                                                            if (mounted) {
                                                                              modelSetState(() {});
                                                                            }
                                                                            _controller.loadComplete();
                                                                          },
                                                                          child: ListView.builder(
                                                                              itemCount: countriesList.length,
                                                                              itemBuilder: (BuildContext context, index) {
                                                                                return RadioListTile(
                                                                                  activeColor: Colors.green,
                                                                                  controlAffinity: ListTileControlAffinity.trailing,
                                                                                  value: index.toString(),
                                                                                  groupValue: _selectedExchange,
                                                                                  onChanged: (value) {
                                                                                    modelSetState(() {
                                                                                      sendTickersList.clear();
                                                                                      _commodityTickersController.clear();
                                                                                      _selectedExchange = value.toString();
                                                                                      selectedIdItem = countriesList[index];
                                                                                      selectedTypeValue = countriesList[index];
                                                                                    });
                                                                                  },
                                                                                  title: Text(
                                                                                    countriesList[index],
                                                                                    style: const TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontFamily: "Poppins",
                                                                                        fontWeight: FontWeight.w700),
                                                                                  ),
                                                                                );
                                                                              }),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: height / 20.3,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    height: height / 14.24,
                                                                    color: Colors.white,
                                                                    child: indusLoader
                                                                        ? Center(
                                                                            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                                                height: 100, width: 100),
                                                                          )
                                                                        : Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    if (!mounted) {
                                                                                      return;
                                                                                    }
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(color: Colors.lightGreenAccent),
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      color: const Color(0XFF0EA102).withOpacity(0.1),
                                                                                    ),
                                                                                    child: const Center(
                                                                                        child: Text("Cancel",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.bold,
                                                                                                color: Color(0XFF0EA102)))),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Expanded(
                                                                                child: GestureDetector(
                                                                                  onTap: () async {
                                                                                    setState(() {
                                                                                      if (selectedIdItemCheck != selectedIdItem) {
                                                                                        sendTickersList.clear();
                                                                                        sendTickersNameList.clear();
                                                                                        tickersCatIdList.clear();
                                                                                        tickersCodeList.clear();
                                                                                        tickersNameList.clear();
                                                                                        tickersLogoList.clear();
                                                                                        isCheckedNew.clear();
                                                                                        tickerSelectAll = false;
                                                                                      } else {}
                                                                                      _countryController.text = selectedTypeValue;
                                                                                    });

                                                                                    modelSetState(() {
                                                                                      indusLoader = true;
                                                                                    });
                                                                                    await getCommodityTickersFunc(tickerSetState: modelSetState);
                                                                                    if (!mounted) {
                                                                                      return;
                                                                                    }
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(color: Colors.lightGreenAccent),
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      color: const Color(0XFF0EA102),
                                                                                    ),
                                                                                    child: const Center(
                                                                                        child: Text("Save",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color: Colors.white))),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                });
                                          },
                                          title: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Country:',
                                                style: TextStyle(fontSize: 14, color: Color(0XFF000000), fontWeight: FontWeight.w400),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                readOnly: true,
                                                enabled: false,
                                                style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                                controller: _countryController,
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                  suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                                  contentPadding: const EdgeInsets.all(20),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  labelStyle: const TextStyle(
                                                      color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                                  labelText: 'Country',
                                                  border: OutlineInputBorder(
                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            showModalBottomSheet(
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(30),
                                                  ),
                                                ),
                                                context: context,
                                                isScrollControlled: true,
                                                isDismissible: false,
                                                enableDrag: false,
                                                builder: (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter modelSetState) {
                                                      return SingleChildScrollView(
                                                        child: Container(
                                                          margin: const EdgeInsets.all(15.0),
                                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: height / 54.13,
                                                              ),
                                                              const Row(
                                                                children: [
                                                                  Text(
                                                                    "Stocks",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold, color: Color(0XFF000000), fontSize: 16.0),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: height / 50.75,
                                                              ),
                                                              TextFormField(
                                                                onChanged: (value) async {
                                                                  if (value.isNotEmpty) {
                                                                    tickersTextValue = value;
                                                                    tickersNameList.clear();
                                                                    tickersLogoList.clear();
                                                                    tickersCatIdList.clear();
                                                                    tickersCodeList.clear();
                                                                    isCheckedNew.clear();
                                                                    await getCommodityTickersFunc(tickerSetState: modelSetState);
                                                                  } else if (value.isEmpty) {
                                                                    tickersTextValue = "";
                                                                    tickersNameList.clear();
                                                                    tickersLogoList.clear();
                                                                    tickersCatIdList.clear();
                                                                    tickersCodeList.clear();
                                                                    isCheckedNew.clear();
                                                                    await getCommodityTickersFunc(tickerSetState: modelSetState);
                                                                  } else {
                                                                    tickersTextValue = "";
                                                                    tickersNameList.clear();
                                                                    tickersLogoList.clear();
                                                                    tickersCatIdList.clear();
                                                                    tickersCodeList.clear();
                                                                    isCheckedNew.clear();
                                                                    await getCommodityTickersFunc(tickerSetState: modelSetState);
                                                                  }
                                                                },
                                                                style: const TextStyle(fontSize: 12, fontFamily: "Poppins"),
                                                                controller: _tickerSearchController,
                                                                keyboardType: TextInputType.emailAddress,
                                                                decoration: InputDecoration(
                                                                  filled: true,
                                                                  fillColor: Colors.grey.shade100,
                                                                  prefixIcon: IconButton(
                                                                    onPressed: () {},
                                                                    icon: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                                  ),
                                                                  contentPadding: EdgeInsets.all(height / 35.6),
                                                                  focusedErrorBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  enabledBorder: OutlineInputBorder(
                                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                  hintStyle: const TextStyle(
                                                                      color: Color(0XFFA5A5A5),
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.normal,
                                                                      fontFamily: "Poppins"),
                                                                  hintText: 'Search here',
                                                                  border: OutlineInputBorder(
                                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 50.75,
                                                              ),
                                                              const Text(
                                                                "Name of Stocks",
                                                                style:
                                                                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0, color: Color(0XFF000000)),
                                                              ),
                                                              SizedBox(
                                                                height: height / 50.75,
                                                              ),
                                                              Stack(
                                                                alignment: AlignmentDirectional.bottomCenter,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          SizedBox(
                                                                            width: width / 2.5,
                                                                            child: CheckboxListTile(
                                                                              title: const Text(
                                                                                "Select All",
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 12.0,
                                                                                    color: Color(0XFF000000)),
                                                                              ),
                                                                              autofocus: false,
                                                                              activeColor: Colors.green,
                                                                              //selected: _value,
                                                                              value: tickerSelectAll,
                                                                              checkboxShape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              onChanged: (bool? value) async {
                                                                                if (value!) {
                                                                                  sendTickersList.clear();
                                                                                  tickersNameList.clear();
                                                                                  tickersLogoList.clear();
                                                                                  tickersCatIdList.clear();
                                                                                  tickersCodeList.clear();
                                                                                  isCheckedNew.clear();
                                                                                  modelSetState(() {
                                                                                    tickerSelectAll = value;
                                                                                    _tickerSearchController.text.isEmpty
                                                                                        ? tickerTickAll = false
                                                                                        : tickerTickAll = true;
                                                                                    //getTickersFunc( tickerSetState:modelSetState);
                                                                                  });
                                                                                } else {
                                                                                  tickersNameList.clear();
                                                                                  tickersLogoList.clear();
                                                                                  tickersCatIdList.clear();
                                                                                  tickersCodeList.clear();
                                                                                  isCheckedNew.clear();
                                                                                  modelSetState(() {
                                                                                    tickerSelectAll = value;
                                                                                    tickerTickAll = value;
                                                                                    sendTickersList.clear();
                                                                                  });
                                                                                  //getTickersFunc( tickerSetState:modelSetState);
                                                                                }
                                                                                await getCommodityTickersFunc(tickerSetState: modelSetState);
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: height / 2.37,
                                                                        child: SmartRefresher(
                                                                          controller: _refreshController,
                                                                          enablePullDown: false,
                                                                          enablePullUp: true,
                                                                          footer: CustomFooter(
                                                                            builder: (BuildContext context, LoadStatus? mode) {
                                                                              Widget body;
                                                                              if (mode == LoadStatus.idle) {
                                                                                body = const Text("pull up load");
                                                                              } else if (mode == LoadStatus.loading) {
                                                                                body = const CupertinoActivityIndicator();
                                                                              } else if (mode == LoadStatus.failed) {
                                                                                body = const Text("Load Failed!Click retry!");
                                                                              } else if (mode == LoadStatus.canLoading) {
                                                                                body = const Text("release to load more");
                                                                              } else {
                                                                                body = const Text("No more Data");
                                                                              }

                                                                              return SizedBox(
                                                                                height: 55.0,
                                                                                child: Center(child: body),
                                                                              );
                                                                            },
                                                                          ),
                                                                          onLoading: () async {
                                                                            await getCommodityRefreshTickersFunc(tickerSetState1: modelSetState);
                                                                            if (mounted) {
                                                                              modelSetState(() {});
                                                                            }
                                                                            _refreshController.loadComplete();
                                                                          },
                                                                          child: ListView.builder(
                                                                              itemCount: tickersNameList.length,
                                                                              itemBuilder: (BuildContext context, index) {
                                                                                return CheckboxListTile(
                                                                                  title: Text(
                                                                                    tickersNameList[index],
                                                                                    style: const TextStyle(
                                                                                        fontSize: 12,
                                                                                        fontFamily: "Poppins",
                                                                                        fontWeight: FontWeight.w700),
                                                                                  ),
                                                                                  subtitle: Text(
                                                                                    tickersCodeList[index],
                                                                                    style: const TextStyle(
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontSize: 12.0,
                                                                                        color: Color(0XFFA5A5A5)),
                                                                                  ),
                                                                                  secondary: SizedBox(
                                                                                      height: height / 23.73,
                                                                                      width: width / 12,
                                                                                      child: tickersLogoList[index].contains("svg")
                                                                                          ? SvgPicture.network(tickersLogoList[index],
                                                                                              fit: BoxFit.fill)
                                                                                          : Image.network(tickersLogoList[index], fit: BoxFit.fill)),
                                                                                  autofocus: false,
                                                                                  activeColor: Colors.green,
                                                                                  //selected: _value,
                                                                                  value: isCheckedNew[index],
                                                                                  checkboxShape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  onChanged: (bool? value) {
                                                                                    if (value!) {
                                                                                      modelSetState(() {
                                                                                        isCheckedNew[index] = value;
                                                                                        sendTickersList.add(tickersCatIdList[index]);
                                                                                        sendTickersNameList.add(tickersNameList[index]);
                                                                                      });
                                                                                    } else {
                                                                                      modelSetState(() {
                                                                                        isCheckedNew[index] = value;
                                                                                        for (int i = 0; i < sendTickersList.length; i++) {
                                                                                          if (sendTickersList[i] == tickersCatIdList[index]) {
                                                                                            sendTickersList.removeAt(i);
                                                                                            tickerSelectAll = false;
                                                                                          }
                                                                                        }
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                );
                                                                              }),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: height / 20.3,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    height: height / 14.24,
                                                                    color: Colors.white,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child: GestureDetector(
                                                                            onTap: () async {
                                                                              if (!mounted) {
                                                                                return;
                                                                              }
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.lightGreenAccent),
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: const Color(0XFF0EA102).withOpacity(0.1),
                                                                              ),
                                                                              child: const Center(
                                                                                  child: Text("Cancel",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.bold, color: Color(0XFF0EA102)))),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 7,
                                                                        ),
                                                                        Expanded(
                                                                          child: GestureDetector(
                                                                            onTap: () async {
                                                                              if (tickerSelectAll) {
                                                                                _commodityTickersController.text = "Multiple";
                                                                              } else {
                                                                                if (sendTickersList.length == 1) {
                                                                                  _commodityTickersController.text = "Single";
                                                                                } else if (sendTickersList.isEmpty) {
                                                                                  _commodityTickersController.text = "Nothing";
                                                                                } else {
                                                                                  _commodityTickersController.text = "Multiple";
                                                                                }
                                                                              }
                                                                              if (!mounted) {
                                                                                return;
                                                                              }
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                border: Border.all(color: Colors.lightGreenAccent),
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                color: const Color(0XFF0EA102),
                                                                              ),
                                                                              child: const Center(
                                                                                  child: Text("Save",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.bold, color: Colors.white))),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                });
                                          },
                                          title: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Commodity(optional):',
                                                style: TextStyle(fontSize: 14, color: Color(0XFF000000), fontWeight: FontWeight.w400),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                readOnly: true,
                                                enabled: false,
                                                style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                                controller: _commodityTickersController,
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                  suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                                  contentPadding: const EdgeInsets.all(20),
                                                  focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  labelStyle: const TextStyle(
                                                      color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                                  labelText: 'Commodity',
                                                  border: OutlineInputBorder(
                                                    borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height / 40.6,
                                    ),
                                    //main Text Form
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 15),
                                      child: TextFormField(
                                        style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                        controller: _listNameController,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(20),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          labelStyle: const TextStyle(
                                              color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                          labelText: 'List Name',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //Text
                                    const SizedBox(
                                      height: 8,
                                    ),

                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 15),
                                      child: const Text(
                                        "Note: Avoid duplicate list names within the same category.",
                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                                      ),
                                    ),

                                    SizedBox(
                                      height: height / 33.83,
                                    ),
                                    //Final Buttons
                                    loading2
                                        ? Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100))
                                        : Container(
                                            height: height / 16.24,
                                            margin: const EdgeInsets.symmetric(horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey.shade400),
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Colors.white,
                                                      ),
                                                      child: const Center(
                                                          child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      logEventFunc(name: 'Filter_Created', type: 'Locker');
                                                      if (_listNameController.text.isEmpty) {
                                                        Flushbar(
                                                          message: "List Name is Mandatory, Please provide List Name to Continue",
                                                          duration: const Duration(seconds: 2),
                                                        ).show(context);
                                                      } else {
                                                        setState(() {
                                                          loading2 = true;
                                                        });
                                                        tickerSelectAll
                                                            ? tickerTickAll
                                                                ? debugPrint("nothing to do")
                                                                : sendTickersList.clear()
                                                            : debugPrint("nothing to do");
                                                        var responseValue = await _filterFunction.getAddFilter(
                                                            type: categoryValue.toLowerCase(),
                                                            title: _listNameController.text,
                                                            cid: mainCatIdList[2],
                                                            exc: selectedIdItem,
                                                            indus: [],
                                                            tickers: sendTickersList,
                                                            allIndus: false,
                                                            allTickers: tickerSelectAll
                                                                ? tickerTickAll
                                                                    ? false
                                                                    : true
                                                                : false);
                                                        await getFil(type: widget.text);
                                                        setState(() {
                                                          loading2 = false;
                                                        });
                                                        if (responseValue["status"]) {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return widget.fromWhere == 'news'
                                                                ? NewsMainPage(
                                                                    fromCompare: false,
                                                                    text: widget.text,
                                                                    tickerId: "",
                                                                    tickerName: "",
                                                                  )
                                                                : widget.fromWhere == 'videos'
                                                                    ? VideosMainPage(
                                                                        fromCompare: false,
                                                                        text: widget.text,
                                                                        tickerId: "",
                                                                        tickerName: "",
                                                                      )
                                                                    : widget.fromWhere == 'forum'
                                                                        ? DetailedForumImagePage(
                                                                            text: widget.text,
                                                                            fromCompare: false,
                                                                            forumDetail: "",
                                                                            filterId: enteredFilteredIdList[0],
                                                                            catIdList: mainCatIdList,
                                                                            topic: "",
                                                                            tickerId: "",
                                                                            tickerName: "",
                                                                            navBool: false,
                                                                            sendUserId: "",
                                                                          )
                                                                        : widget.fromWhere == 'survey'
                                                                            ? DetailedSurveyImagePage(
                                                                                surveyDetail: "",
                                                                                topic: '',
                                                                                catIdList: mainCatIdList,
                                                                                text: widget.text,
                                                                                filterId: enteredFilteredIdList[0],
                                                                                tickerId: "",
                                                                                tickerName: "",
                                                                                fromCompare: false,
                                                                              )
                                                                            : const MainBottomNavigationPage(
                                                                                tType: true,
                                                                                countryIndex: 0,
                                                                                text: '',
                                                                                caseNo1: 0,
                                                                                excIndex: 0,
                                                                                isHomeFirstTym: false,
                                                                                newIndex: 0,
                                                                              );
                                                          }));
                                                        } else {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Flushbar(
                                                            message: responseValue["message"],
                                                            duration: const Duration(seconds: 2),
                                                          ).show(context);
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.lightGreenAccent),
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: const Color(0XFF0EA102),
                                                      ),
                                                      child: const Center(
                                                          child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            )
                          : widget.text.toLowerCase() == "forex"
                              ? SingleChildScrollView(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height / 45.11,
                                        ),
                                        //heading
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(
                                                  Icons.clear,
                                                  color: Colors.black,
                                                  size: 24,
                                                )),
                                            const Text(
                                              "Filter",
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: height / 58,
                                        ),
                                        //subheading
                                        Container(
                                          height: height / 14.5,
                                          width: double.infinity,
                                          color: const Color(0XFFA5A5A5).withOpacity(0.1),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 15.0),
                                                child: Text("Filter list",
                                                    style: TextStyle(color: Color(0xFF4A4A4A), fontSize: 16, fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        //main filters
                                        Column(
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(30),
                                                      ),
                                                    ),
                                                    context: context,
                                                    isScrollControlled: true,
                                                    isDismissible: false,
                                                    enableDrag: false,
                                                    builder: (BuildContext context) {
                                                      return StatefulBuilder(
                                                        builder: (BuildContext context, StateSetter modelSetState) {
                                                          return SingleChildScrollView(
                                                            child: Container(
                                                              margin: const EdgeInsets.all(15.0),
                                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                    height: height / 54.13,
                                                                  ),
                                                                  const Row(
                                                                    children: [
                                                                      Text(
                                                                        "Forex",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold, color: Color(0XFF000000), fontSize: 16.0),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 50.75,
                                                                  ),
                                                                  TextFormField(
                                                                    onChanged: (value) async {
                                                                      if (value.isNotEmpty) {
                                                                        tickersTextValue = value;
                                                                        tickersNameList.clear();
                                                                        tickersLogoList.clear();
                                                                        tickersCatIdList.clear();
                                                                        tickersCodeList.clear();
                                                                        isCheckedNew.clear();
                                                                        await getForexTickersFunc(tickerSetState: modelSetState);
                                                                      } else if (value.isEmpty) {
                                                                        tickersTextValue = "";
                                                                        tickersNameList.clear();
                                                                        tickersLogoList.clear();
                                                                        tickersCatIdList.clear();
                                                                        tickersCodeList.clear();
                                                                        isCheckedNew.clear();
                                                                        await getForexTickersFunc(tickerSetState: modelSetState);
                                                                      } else {
                                                                        tickersTextValue = "";
                                                                        tickersNameList.clear();
                                                                        tickersLogoList.clear();
                                                                        tickersCatIdList.clear();
                                                                        tickersCodeList.clear();
                                                                        isCheckedNew.clear();
                                                                        await getForexTickersFunc(tickerSetState: modelSetState);
                                                                      }
                                                                    },
                                                                    style: const TextStyle(fontSize: 12, fontFamily: "Poppins"),
                                                                    controller: _tickerSearchController,
                                                                    keyboardType: TextInputType.emailAddress,
                                                                    decoration: InputDecoration(
                                                                      filled: true,
                                                                      fillColor: Colors.grey.shade100,
                                                                      prefixIcon: IconButton(
                                                                        onPressed: () {},
                                                                        icon: SvgPicture.asset(
                                                                            "lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                                      ),
                                                                      contentPadding: EdgeInsets.all(height / 35.6),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      hintStyle: const TextStyle(
                                                                          color: Color(0XFFA5A5A5),
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.normal,
                                                                          fontFamily: "Poppins"),
                                                                      hintText: 'Search here',
                                                                      border: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 3),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 50.75,
                                                                  ),
                                                                  const Text(
                                                                    "Name of Forex",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold, fontSize: 12.0, color: Color(0XFF000000)),
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 50.75,
                                                                  ),
                                                                  Stack(
                                                                    alignment: AlignmentDirectional.bottomCenter,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                            children: [
                                                                              SizedBox(
                                                                                width: width / 2.5,
                                                                                child: CheckboxListTile(
                                                                                  title: const Text(
                                                                                    "Select All",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 12.0,
                                                                                        color: Color(0XFF000000)),
                                                                                  ),
                                                                                  autofocus: false,
                                                                                  activeColor: Colors.green,
                                                                                  //selected: _value,
                                                                                  value: tickerSelectAll,
                                                                                  checkboxShape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  onChanged: (bool? value) async {
                                                                                    if (value!) {
                                                                                      sendTickersList.clear();
                                                                                      tickersNameList.clear();
                                                                                      tickersLogoList.clear();
                                                                                      tickersCatIdList.clear();
                                                                                      tickersCodeList.clear();
                                                                                      isCheckedNew.clear();
                                                                                      modelSetState(() {
                                                                                        tickerSelectAll = value;
                                                                                        _tickerSearchController.text.isEmpty
                                                                                            ? tickerTickAll = false
                                                                                            : tickerTickAll = true;
                                                                                        // getTickersFunc( tickerSetState:modelSetState);
                                                                                      });
                                                                                    } else {
                                                                                      tickersNameList.clear();
                                                                                      tickersLogoList.clear();
                                                                                      tickersCatIdList.clear();
                                                                                      tickersCodeList.clear();
                                                                                      isCheckedNew.clear();
                                                                                      modelSetState(() {
                                                                                        tickerSelectAll = value;
                                                                                        tickerTickAll = value;
                                                                                        sendTickersList.clear();
                                                                                      });
                                                                                      //getTickersFunc( tickerSetState:modelSetState);
                                                                                    }

                                                                                    await getForexTickersFunc(tickerSetState: modelSetState);
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height: height / 2.37,
                                                                            child: SmartRefresher(
                                                                              controller: _refreshController,
                                                                              enablePullDown: false,
                                                                              enablePullUp: true,
                                                                              footer: CustomFooter(
                                                                                builder: (BuildContext context, LoadStatus? mode) {
                                                                                  Widget body;
                                                                                  if (mode == LoadStatus.idle) {
                                                                                    body = const Text("pull up to load");
                                                                                  } else if (mode == LoadStatus.loading) {
                                                                                    body = const CupertinoActivityIndicator();
                                                                                  } else if (mode == LoadStatus.failed) {
                                                                                    body = const Text("Load Failed!Click retry!");
                                                                                  } else if (mode == LoadStatus.canLoading) {
                                                                                    body = const Text("release to load more");
                                                                                  } else {
                                                                                    body = const Text("No more Data");
                                                                                  }

                                                                                  return SizedBox(
                                                                                    height: 55.0,
                                                                                    child: Center(child: body),
                                                                                  );
                                                                                },
                                                                              ),
                                                                              onLoading: () async {
                                                                                await getForexRefreshTickersFunc(tickerSetState1: modelSetState);
                                                                                if (mounted) {
                                                                                  modelSetState(() {});
                                                                                }
                                                                                _refreshController.loadComplete();
                                                                              },
                                                                              child: ListView.builder(
                                                                                  itemCount: tickersNameList.length,
                                                                                  itemBuilder: (BuildContext context, index) {
                                                                                    return CheckboxListTile(
                                                                                      title: Text(
                                                                                        tickersNameList[index],
                                                                                        style: const TextStyle(
                                                                                            fontSize: 12,
                                                                                            fontFamily: "Poppins",
                                                                                            fontWeight: FontWeight.w700),
                                                                                      ),
                                                                                      subtitle: Text(
                                                                                        tickersCodeList[index],
                                                                                        style: const TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 12.0,
                                                                                            color: Color(0XFFA5A5A5)),
                                                                                      ),
                                                                                      secondary: SizedBox(
                                                                                          height: height / 23.73,
                                                                                          width: width / 12,
                                                                                          child: tickersLogoList[index].contains("svg")
                                                                                              ? SvgPicture.network(tickersLogoList[index],
                                                                                                  fit: BoxFit.fill)
                                                                                              : Image.network(tickersLogoList[index],
                                                                                                  fit: BoxFit.fill)),
                                                                                      autofocus: false,
                                                                                      activeColor: Colors.green,
                                                                                      //selected: _value,
                                                                                      value: isCheckedNew[index],
                                                                                      checkboxShape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                      ),
                                                                                      onChanged: (bool? value) {
                                                                                        if (value!) {
                                                                                          modelSetState(() {
                                                                                            isCheckedNew[index] = value;
                                                                                            sendTickersList.add(tickersCatIdList[index]);
                                                                                            sendTickersNameList.add(tickersNameList[index]);
                                                                                          });
                                                                                        } else {
                                                                                          modelSetState(() {
                                                                                            isCheckedNew[index] = value;
                                                                                            for (int i = 0; i < sendTickersList.length; i++) {
                                                                                              if (sendTickersList[i] == tickersCatIdList[index]) {
                                                                                                sendTickersList.removeAt(i);
                                                                                                tickerSelectAll = false;
                                                                                              }
                                                                                            }
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                    );
                                                                                  }),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: height / 20.3,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Container(
                                                                        height: height / 14.24,
                                                                        color: Colors.white,
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              child: GestureDetector(
                                                                                onTap: () async {
                                                                                  if (!mounted) {
                                                                                    return;
                                                                                  }
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(color: Colors.lightGreenAccent),
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    color: const Color(0XFF0EA102).withOpacity(0.1),
                                                                                  ),
                                                                                  child: const Center(
                                                                                      child: Text("Cancel",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Color(0XFF0EA102)))),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 7,
                                                                            ),
                                                                            Expanded(
                                                                              child: GestureDetector(
                                                                                onTap: () async {
                                                                                  if (tickerSelectAll) {
                                                                                    _forexTickersController.text = "Multiple";
                                                                                  } else {
                                                                                    if (sendTickersList.length == 1) {
                                                                                      _forexTickersController.text = "Single";
                                                                                    } else if (sendTickersList.isEmpty) {
                                                                                      _forexTickersController.text = "Nothing";
                                                                                    } else {
                                                                                      _forexTickersController.text = "Multiple";
                                                                                    }
                                                                                  }
                                                                                  if (!mounted) {
                                                                                    return;
                                                                                  }
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(color: Colors.lightGreenAccent),
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                    color: const Color(0XFF0EA102),
                                                                                  ),
                                                                                  child: const Center(
                                                                                      child: Text("Save",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color: Colors.white))),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    });
                                              },
                                              title: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Forex(optional):',
                                                    style: TextStyle(fontSize: 14, color: Color(0XFF000000), fontWeight: FontWeight.w400),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                    readOnly: true,
                                                    enabled: false,
                                                    style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                                    controller: _forexTickersController,
                                                    keyboardType: TextInputType.text,
                                                    decoration: InputDecoration(
                                                      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                                                      contentPadding: const EdgeInsets.all(20),
                                                      focusedErrorBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      labelStyle: const TextStyle(
                                                          color: Color(0XFFA5A5A5),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.normal,
                                                          fontFamily: "Poppins"),
                                                      labelText: 'Stocks',
                                                      border: OutlineInputBorder(
                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height / 40.6,
                                        ),
                                        //main Text Form
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 15),
                                          child: TextFormField(
                                            style: const TextStyle(fontSize: 12, fontFamily: "Poppins", fontWeight: FontWeight.w700),
                                            controller: _listNameController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(20),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              labelStyle: const TextStyle(
                                                  color: Color(0XFFA5A5A5), fontSize: 14, fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                                              labelText: 'List Name',
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Text
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 15),
                                          child: const Text(
                                            "Note: Avoid duplicate list names within the same category.",
                                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 33.83,
                                        ),
                                        //Final Buttons
                                        loading2
                                            ? Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100))
                                            : Container(
                                                height: height / 16.24,
                                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.grey.shade400),
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Colors.white,
                                                          ),
                                                          child: const Center(
                                                              child:
                                                                  Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 7,
                                                    ),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          logEventFunc(name: 'Filter_Created', type: 'Locker');
                                                          if (_listNameController.text.isEmpty) {
                                                            Flushbar(
                                                              message: "List Name is Mandatory, Please provide List Name to Continue",
                                                              duration: const Duration(seconds: 2),
                                                            ).show(context);
                                                          } else {
                                                            setState(() {
                                                              loading2 = true;
                                                            });
                                                            tickerSelectAll
                                                                ? tickerTickAll
                                                                    ? debugPrint("nothing to do")
                                                                    : sendTickersList.clear()
                                                                : debugPrint("nothing to do");
                                                            var responseValue = await _filterFunction.getAddFilter(
                                                                type: categoryValue.toLowerCase(),
                                                                title: _listNameController.text,
                                                                cid: mainCatIdList[3],
                                                                exc: "",
                                                                indus: [],
                                                                tickers: sendTickersList,
                                                                allIndus: false,
                                                                allTickers: tickerSelectAll
                                                                    ? tickerTickAll
                                                                        ? false
                                                                        : true
                                                                    : false);
                                                            await getFil(type: widget.text);
                                                            setState(() {
                                                              loading2 = false;
                                                            });
                                                            if (responseValue["status"]) {
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return widget.fromWhere == 'news'
                                                                    ? NewsMainPage(
                                                                        fromCompare: false,
                                                                        text: widget.text,
                                                                        tickerId: "",
                                                                        tickerName: "",
                                                                      )
                                                                    : widget.fromWhere == 'videos'
                                                                        ? VideosMainPage(
                                                                            fromCompare: false,
                                                                            text: widget.text,
                                                                            tickerId: "",
                                                                            tickerName: "",
                                                                          )
                                                                        : widget.fromWhere == 'forum'
                                                                            ? DetailedForumImagePage(
                                                                                text: widget.text,
                                                                                fromCompare: false,
                                                                                forumDetail: "",
                                                                                filterId: enteredFilteredIdList[0],
                                                                                catIdList: mainCatIdList,
                                                                                topic: "",
                                                                                tickerId: "",
                                                                                tickerName: "",
                                                                                navBool: false,
                                                                                sendUserId: "",
                                                                              )
                                                                            : widget.fromWhere == 'survey'
                                                                                ? DetailedSurveyImagePage(
                                                                                    surveyDetail: "",
                                                                                    topic: '',
                                                                                    catIdList: mainCatIdList,
                                                                                    text: widget.text,
                                                                                    filterId: enteredFilteredIdList[0],
                                                                                    tickerId: "",
                                                                                    tickerName: "",
                                                                                    fromCompare: false,
                                                                                  )
                                                                                : const MainBottomNavigationPage(
                                                                                    tType: true,
                                                                                    countryIndex: 0,
                                                                                    text: '',
                                                                                    caseNo1: 0,
                                                                                    excIndex: 0,
                                                                                    isHomeFirstTym: false,
                                                                                    newIndex: 0,
                                                                                  );
                                                              }));
                                                            } else {
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Flushbar(
                                                                message: responseValue["message"],
                                                                duration: const Duration(seconds: 2),
                                                              ).show(context);
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.lightGreenAccent),
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: const Color(0XFF0EA102),
                                                          ),
                                                          child: const Center(
                                                              child:
                                                                  Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                )
                              : Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100))
              : Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100)),
        ),
      ),
    );
  }
}
