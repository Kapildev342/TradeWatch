import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:river_player/river_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class SurveyPostPage extends StatefulWidget {
  final String text;
  final bool fromLink;
  final String? fromWhere;

  const SurveyPostPage({Key? key, required this.text, this.fromLink = false, this.fromWhere}) : super(key: key);

  @override
  State<SurveyPostPage> createState() => _SurveyPostPageState();
}

class _SurveyPostPageState extends State<SurveyPostPage> {
  List<File?> pickedImage = List.generate(1, (i) => null);
  List<File?> pickedVideo = List.generate(1, (i) => null);
  List<File?> pickedFile = List.generate(1, (i) => null);
  List<String> selectedUrlType = List.generate(1, (i) => "");
  List<FilePickerResult?> doc = List.generate(1, (i) => null);
  List<List<TextEditingController>> finalControllersList = List.generate(1, (i) => List.generate(2, (i) => TextEditingController()));
  final List<TextEditingController> _questionControllerList = List.generate(1, (i) => TextEditingController());
  final List<bool> _optionalTypeList = List.generate(1, (i) => true);
  final List<String> _answerTypeList = List.generate(1, (i) => "Select Type");
  List<String> surveyAttachUrlList = List.generate(1, (i) => "");
  List<bool> validTitleList = List.generate(1, (index) => true);
  List<Map<String, dynamic>> questionsData = [];
  List<File> file1 = [];
  late BetterPlayerController _betterPlayerController;
  bool playVideo = false;
  bool releaseLoader = false;
  String selectedValue = "";
  List countriesList = ["General", "India", "USA"];
  Map<String, dynamic> data = {};
  Map<String, dynamic> dataGeneral = {};
  Map<String, dynamic> dataUpdate = {};
  Map<String, dynamic> dataUpdateGeneral = {};
  String selectedCategory = "Select a Category";
  String selected1ddValue = "1 Day";
  String selected2ddValue = "Single";
  String mainUserToken = "";
  List categoriesList = [
    "Stocks",
    "Crypto",
    "Commodity",
    "Forex",
  ];
  final List<String> _currencies = ["1 Day", "1 Week", "1 Month", "6 Months"];
  List<String> choices = [
    "Single",
    "Multiple",
  ];
  bool validTitle = true;
  List exchangeNameList = [];
  List exchangeCodeList = [];
  List exchangeIdList = [];
  List sendIndustriesList = [];
  List sendIndustriesNameList = [];
  String _selectedExchange = "";
  String _selectSubCategory = "Select a SubCategory";
  String _selectIndex = "Select an Index";
  String selectedIdItem = "";
  int stocksInt = 0;
  List industriesNameList = [];
  List industriesIdList = [];
  List<bool> indusBool = [];
  String textValue = "";
  String tickersTextValue = "";
  List tickersNameList = [];
  List tickersLogoList = [];
  List tickersCatIdList = [];
  List tickersCodeList = [];
  List sendTickersList = [];
  List sendTickersNameList = [];
  List<bool> isCheckedNew = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tickerSearchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  final RefreshController _controller = RefreshController();
  bool selectAll = false;
  bool mandatory = true;
  bool publicOrPrivate = false;
  bool tickerSelectAll = false;
  bool addButton = false;
  bool releaseButton = false;
  bool saveButton = false;
  bool gotUrl = false;
  bool uploadCompleted = false;

  get dropdownValue => "1Hour";

  get hour => null;
  Map<String, dynamic> surveyDataNew = {};
  String answerType = "Select Type";
  String surveyAttachUrl = "";
  String optionalType = "Select (optional,mandatory)";
  List textList = [];

  @override
  void initState() {
    getAllDataMain(name: 'Survey_Creation_Page');
    super.initState();
  }

  getEx({required StateSetter newSetState1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    exchangeNameList.clear();
    exchangeCodeList.clear();
    exchangeIdList.clear();
    var url = Uri.parse(baseurl + versionLocker + getExchanges);
    var response = await http.post(
      url,
      headers: {'Authorization': mainUserToken},
    );
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      if (mounted) {
        newSetState1(() {
          exchangeNameList.add("General");
          exchangeCodeList.add("Use this option, if you want to create something generic");
          exchangeIdList.add("General");
          for (int i = 0; i < responseData["response"].length; i++) {
            exchangeNameList.add(responseData["response"][i]["name"]);
            exchangeCodeList.add(responseData["response"][i]["code"]);
            exchangeIdList.add(responseData["response"][i]["_id"]);
          }
        });
      }
    } else {}
  }

  getIndustries({required StateSetter newSetState}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    sendIndustriesList.clear();
    sendIndustriesNameList.clear();
    sendTickersNameList.clear();
    sendTickersList.clear();
    industriesNameList.clear();
    industriesIdList.clear();
    indusBool.clear();
    if (selectedCategory == "Stocks") {
      data = {
        'type': selectedCategory.toLowerCase(),
        'search': textValue.isEmpty ? "" : textValue,
        'skip': 0,
        'exchange': selectedIdItem,
      };
    } else if (selectedCategory == "Crypto") {
      data = {'type': selectedCategory.toLowerCase(), 'search': textValue.isEmpty ? "" : textValue, 'skip': 0};
    } else if (selectedCategory == "Commodity") {
      data = {'type': selectedCategory.toLowerCase(), 'search': textValue.isEmpty ? "" : textValue, 'skip': 0};
    } else {
      data = {'type': selectedCategory.toLowerCase(), 'search': textValue.isEmpty ? "" : textValue, 'skip': 0};
    }
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: data,
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        newSetState(() {
          selectedCategory == "Crypto" ? industriesNameList.add("General") : debugPrint("Not a crypto");
          selectedCategory == "Crypto" ? industriesIdList.add("General") : debugPrint("Not a crypto");
          selectedCategory == "Crypto" ? indusBool.add(false) : debugPrint("Not a crypto");
          for (int i = 0; i < responseData["response"].length; i++) {
            industriesNameList.add(responseData["response"][i]["name"]);
            industriesIdList.add(responseData["response"][i]["_id"]);
            if (selectAll) {
              setState(() {
                sendIndustriesList.addAll(industriesIdList);
              });
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
              sendIndustriesList.clear();
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
  }

  getRefreshIndus({required StateSetter newSetState}) async {
    newSetState(() {
      stocksInt += 20;
    });
    if (selectedCategory == "Stocks") {
      data = {
        'type': selectedCategory.toLowerCase(),
        'search': textValue.isEmpty ? "" : textValue,
        'skip': stocksInt,
        'exchange': selectedIdItem,
      };
    } else if (selectedCategory == "Crypto") {
      data = {'type': selectedCategory.toLowerCase(), 'search': textValue.isEmpty ? "" : textValue, 'skip': stocksInt};
    } else if (selectedCategory == "Commodity") {
      data = {'type': selectedCategory.toLowerCase(), 'search': textValue.isEmpty ? "" : textValue, 'skip': stocksInt};
    } else {
      data = {'type': selectedCategory.toLowerCase(), 'search': textValue.isEmpty ? "" : textValue, 'skip': stocksInt};
    }
    var url = baseurl + versionLocker + getIndustry;
    var response = await dioMain.post(url,
        data: data,
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
            sendIndustriesList.clear();
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

  getTickersFunc({required StateSetter tickerSetState}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    if (selectedCategory == "Stocks") {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': tickersTextValue.isEmpty ? "" : tickersTextValue,
        'skip': 0,
        'exchange': selectedIdItem,
        'industries': sendIndustriesList
      };
    } else if (selectedCategory == "Crypto") {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': tickersTextValue.isEmpty ? "" : tickersTextValue,
        'skip': 0,
        'industries': sendIndustriesList
      };
    } else if (selectedCategory == "Commodity") {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': tickersTextValue.isEmpty ? "" : tickersTextValue,
        'skip': 0,
        'country': selectedIdItem,
      };
    } else {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': tickersTextValue.isEmpty ? "" : tickersTextValue,
        'skip': 0,
      };
    }
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: dataUpdate,
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState(() {
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
              setState(() {
                sendTickersList.addAll(tickersCatIdList);
              });

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

  getRefreshTickersFunc({required StateSetter tickerSetState1}) async {
    tickerSetState1(() {
      stocksInt += 20;
    });
    var url = baseurl + versionLocker + getTickers;
    if (selectedCategory == "Stocks") {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': tickersTextValue.isEmpty ? "" : tickersTextValue,
        'skip': stocksInt,
        'exchange': selectedIdItem,
        'industries': sendIndustriesList
      };
    } else if (selectedCategory == "Crypto") {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': tickersTextValue.isEmpty ? "" : tickersTextValue,
        'skip': stocksInt,
        'industries': sendIndustriesList
      };
    } else if (selectedCategory == "Commodity") {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': tickersTextValue.isEmpty ? "" : tickersTextValue,
        'skip': stocksInt,
        'country': selectedIdItem
      };
    } else {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': tickersTextValue.isEmpty ? "" : tickersTextValue,
        'skip': stocksInt,
      };
    }
    var response = await dioMain.post(url,
        data: dataUpdate,
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        tickerSetState1(() {
          for (int i = 0; i < responseData["response"].length; i++) {
            tickerSetState1(() {});
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

  validatePost({
    required String title,
    required String type,
    required String exc,
    required List indus,
    required List tickers,
    required List questions,
    required String active,
  }) async {
    String catId = "";
    if (selectedCategory.toLowerCase() == "stocks") {
      setState(() {
        catId = mainCatIdList[0];
      });
    } else if (selectedCategory.toLowerCase() == "crypto") {
      setState(() {
        catId = mainCatIdList[1];
      });
    } else if (selectedCategory.toLowerCase() == "commodity") {
      setState(() {
        catId = mainCatIdList[2];
      });
    } else {
      setState(() {
        catId = mainCatIdList[3];
      });
    }
    if (title == "" || type == "Select a Category" || exc == "" || indus.isEmpty || tickers.isEmpty || questions.isEmpty) {
      if (title == "") {
        setState(() {
          releaseLoader = false;
        });
        Flushbar(
          message: "Title Should not be empty",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else if (validTitle == false) {
        setState(() {
          releaseLoader = false;
        });
        Flushbar(
          message: "The title can't be only integers, please try including at least one alphabet.",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else if (questions.isEmpty) {
        setState(() {
          releaseLoader = false;
        });
        Flushbar(
          message: "Please add atleast 1 question",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else if (validTitleList.contains(false)) {
        setState(() {
          releaseLoader = false;
        });
        Flushbar(
          message: "Question can't be only integers, please try including at least one alphabet.",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else if (type == "select a category") {
        setState(() {
          releaseLoader = false;
        });
        Flushbar(
          message: "Please Select the Category",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (type == "stocks") {
          if (exc == "") {
            setState(() {
              releaseLoader = false;
            });
            Flushbar(
              message: "Please Select the SubCategory",
              duration: const Duration(seconds: 2),
            ).show(context);
          }
          //General Stocks
          else if (exc == "General") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            mainUserToken = prefs.getString('newUserToken')!;
            dataGeneral = {
              "title": title,
              "active_until": active,
              "category": type,
              "category_id": catId,
              "type_general": true,
              "questions": questions,
              "company_name": "General",
              "public_view": publicOrPrivate ? "private" : "public"
            };
            var response = await dioMain.post(baseurl + versionSurvey + addSurvey,
                data: dataGeneral,
                options: Options(
                  headers: {'Authorization': mainUserToken},
                ));
            var responseData = response.data;
            if (responseData["status"]) {
              setState(() {
                releaseLoader = false;
              });
              if (!mounted) {
                return;
              }
              Navigator.pop(context, true);
              Flushbar(
                message: responseData["message"],
                duration: const Duration(seconds: 2),
              ).show(context);
            } else {
              setState(() {
                releaseLoader = false;
              });
              if (!mounted) {
                return;
              }
              Flushbar(
                message: responseData["message"],
                duration: const Duration(seconds: 2),
              ).show(context);
            }
          } else if (_selectIndex == "General") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            mainUserToken = prefs.getString('newUserToken')!;
            dataGeneral = {
              "title": title,
              "active_until": active,
              "category": type,
              "category_id": catId,
              "exchange": exc,
              "industries": indus,
              "tickers": tickers,
              "allindustries": true,
              "alltickers": true,
              "questions": questions,
              "company_name": "General",
              "public_view": publicOrPrivate ? "private" : "public"
            };
            var response = await dioMain.post(baseurl + versionSurvey + addSurvey,
                data: dataGeneral,
                options: Options(
                  headers: {'Authorization': mainUserToken},
                ));
            var responseData = response.data;
            if (responseData["status"]) {
              setState(() {
                releaseLoader = false;
              });
              if (!mounted) {
                return;
              }
              Navigator.pop(context, true);
              Flushbar(
                message: responseData["message"],
                duration: const Duration(seconds: 2),
              ).show(context);
            } else {
              setState(() {
                releaseLoader = false;
              });
              if (!mounted) {
                return;
              }
              Flushbar(
                message: responseData["message"],
                duration: const Duration(seconds: 2),
              ).show(context);
            }
          } else if (tickers.isEmpty) {
            setState(() {
              releaseLoader = false;
            });
            Flushbar(
              message: "Please Select at least one Index",
              duration: const Duration(seconds: 2),
            ).show(context);
          } else {
            postingForum(
                title: _titleController.text,
                indus: sendIndustriesList,
                exc: selectedIdItem,
                cid: catId,
                type: selectedCategory.toLowerCase(),
                tickers: sendTickersList,
                questions: questions,
                active: active);
          }
        } else if (type == "crypto") {
          if (indus.isEmpty) {
            setState(() {
              releaseLoader = false;
            });
            Flushbar(
              message: "Please Select SubCategory",
              duration: const Duration(seconds: 2),
            ).show(context);
          } else if (indus[0] == "General") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            mainUserToken = prefs.getString('newUserToken')!;
            dataGeneral = {
              "title": title,
              "category": type,
              "type_general": true,
              "category_id": catId,
              "active_until": active,
              "questions": questions,
              "company_name": "General",
              "public_view": publicOrPrivate ? "private" : "public"
            };
            var response = await dioMain.post(baseurl + versionSurvey + addSurvey,
                data: dataGeneral,
                options: Options(
                  headers: {'Authorization': mainUserToken},
                ));
            var responseData = response.data;
            if (responseData["status"]) {
              setState(() {
                releaseLoader = false;
              });
              if (!mounted) {
                return;
              }
              Navigator.pop(context, true);
              Flushbar(
                message: responseData["message"],
                duration: const Duration(seconds: 2),
              ).show(context);
            } else {
              setState(() {
                releaseLoader = false;
              });
              if (!mounted) {
                return;
              }
              Flushbar(
                message: responseData["message"],
                duration: const Duration(seconds: 2),
              ).show(context);
            }
            // }
          } else if (tickers.isEmpty) {
            setState(() {
              releaseLoader = false;
            });
            Flushbar(
              message: "Please Select at least one Index",
              duration: const Duration(seconds: 2),
            ).show(context);
          } else {
            postingForum(
                title: _titleController.text,
                indus: sendIndustriesList,
                exc: selectedIdItem,
                cid: catId,
                type: selectedCategory.toLowerCase(),
                tickers: sendTickersList,
                questions: questions,
                active: active);
          }
        } else if (type == "commodity") {
          if (exc == "") {
            setState(() {
              releaseLoader = false;
            });
            Flushbar(
              message: "Please Select SubCategory",
              duration: const Duration(seconds: 2),
            ).show(context);
          } else if (exc == "General") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            mainUserToken = prefs.getString('newUserToken')!;
            dataGeneral = {
              "title": title,
              "category": type,
              "type_general": true,
              "active_until": active,
              "category_id": catId,
              "questions": questions,
              "company_name": "General",
              "public_view": publicOrPrivate ? "private" : "public"
            };
            var response = await dioMain.post(baseurl + versionSurvey + addSurvey,
                data: dataGeneral,
                options: Options(
                  headers: {'Authorization': mainUserToken},
                ));
            var responseData = response.data;
            if (responseData["status"]) {
              setState(() {
                releaseLoader = false;
              });
              if (!mounted) {
                return;
              }
              Navigator.pop(context, true);
              Flushbar(
                message: responseData["message"],
                duration: const Duration(seconds: 2),
              ).show(context);
            } else {
              setState(() {
                releaseLoader = false;
              });
              if (!mounted) {
                return;
              }
              Flushbar(
                message: responseData["message"],
                duration: const Duration(seconds: 2),
              ).show(context);
            }
            // }
          } else if (tickers.isEmpty) {
            setState(() {
              releaseLoader = false;
            });
            Flushbar(
              message: "Please Select at least one Index",
              duration: const Duration(seconds: 2),
            ).show(context);
          } else {
            postingForum(
                title: _titleController.text,
                indus: sendIndustriesList,
                exc: selectedIdItem,
                cid: catId,
                type: selectedCategory.toLowerCase(),
                tickers: sendTickersList,
                questions: questions,
                active: active);
          }
        } else {
          if (tickers.isEmpty) {
            setState(() {
              releaseLoader = false;
            });
            Flushbar(
              message: "Please Select at least one Index",
              duration: const Duration(seconds: 2),
            ).show(context);
          } else {
            postingForum(
                title: _titleController.text,
                indus: sendIndustriesList,
                exc: selectedIdItem,
                cid: catId,
                type: selectedCategory.toLowerCase(),
                tickers: sendTickersList,
                questions: questions,
                active: active);
          }
        }
      }
    } else if (validTitle == false) {
      Flushbar(
        message: "Title should contains minimum an alphabet",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      postingForum(
          title: _titleController.text,
          indus: sendIndustriesList,
          exc: selectedIdItem,
          cid: catId,
          type: selectedCategory.toLowerCase(),
          tickers: sendTickersList,
          questions: questions,
          active: active);
    }
  }

  postingForum({
    required String title,
    required String type,
    required String cid,
    required String exc,
    required List indus,
    required List tickers,
    required List questions,
    required String active,
  }) async {
    if (type == "stocks") {
      data = {
        "title": title,
        "category": type,
        "category_id": cid,
        "exchange": exc,
        "industries": indus,
        "tickers": tickers,
        "allindustries": selectAll,
        "alltickers": tickerSelectAll,
        "active_until": active,
        "questions": questions,
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex,
        "public_view": publicOrPrivate ? "private" : "public"
      };
    } else if (type == "crypto") {
      data = {
        "title": title,
        "category": type,
        "category_id": cid,
        "industries": indus,
        "tickers": tickers,
        "alltickers": tickerSelectAll,
        "active_until": active,
        "questions": questions,
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex,
        "public_view": publicOrPrivate ? "private" : "public"
      };
    } else if (type == "commodity") {
      data = {
        "title": title,
        "category": type,
        "category_id": cid,
        "country": exc,
        "tickers": tickers,
        "alltickers": tickerSelectAll,
        "active_until": active,
        "questions": questions,
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex,
        "public_view": publicOrPrivate ? "private" : "public"
      };
    } else {
      data = {
        "title": title,
        "category": type,
        "category_id": cid,
        "tickers": tickers,
        "alltickers": tickerSelectAll,
        "active_until": active,
        "questions": questions,
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex,
        "public_view": publicOrPrivate ? "private" : "public"
      };
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionSurvey + addSurvey;
    var response = await dioMain.post(url,
        data: data,
        options: Options(
          headers: {'Authorization': mainUserToken},
        ));
    var responseData = response.data;
    if (responseData["status"]) {
      setState(() {
        releaseLoader = false;
      });
      if (!mounted) {
        return;
      }
      Navigator.pop(context, true);
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      setState(() {
        releaseLoader = false;
      });
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    // }
  }

  fileUploadingFunc({required File? file, required String surveyUrlType, required int index}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionSurvey + fileAdd;
    var res1 = await functionsMain.sendForm(url, surveyDataNew, {
      'file': surveyUrlType == "image"
          ? pickedImage[index]!
          : surveyUrlType == "video"
              ? pickedVideo[index]!
              : pickedFile[index]!
    });
    if (res1.data["status"]) {
      setState(() {
        surveyAttachUrl = res1.data["response"]["url"];
        surveyAttachUrlList[index] = surveyAttachUrl;
      });
      setState(() {
        uploadCompleted = true;
      });
    } else {
      setState(() {
        uploadCompleted = false;
      });
      if (!mounted) {
        return;
      }
      Flushbar(
        message: res1.data["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromLink) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const MainBottomNavigationPage(
                        caseNo1: 0,
                        text: "",
                        excIndex: 1,
                        newIndex: 0,
                        countryIndex: 0,
                        tType: true,
                        isHomeFirstTym: false,
                      )));
        } else {
          if (widget.fromWhere == "finalCharts") {
            //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
          }
          /*   if (!mounted) {
            return false;
          }*/
          Navigator.pop(context);
        }
        return false;
      },
      child: Container(
        //  color: const Color(0XFFFFFFFF),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Scaffold(
            // backgroundColor: const Color(0XFFFFFFFF),
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              // backgroundColor: const Color(0XFFFFFFFF),
              backgroundColor: Theme.of(context).colorScheme.background,
              toolbarHeight: height / 10.68,
              automaticallyImplyLeading: false,
              elevation: 10,
              title: SizedBox(
                width: width,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.fromLink) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => const MainBottomNavigationPage(
                                          caseNo1: 0,
                                          text: "",
                                          excIndex: 1,
                                          newIndex: 0,
                                          countryIndex: 0,
                                          tType: true,
                                          isHomeFirstTym: false,
                                        )));
                          } else {
                            if (widget.fromWhere == "finalCharts") {
                              // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                              SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                            }
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                          }
                        },
                        child: releaseLoader
                            ? const SizedBox()
                            : Center(
                                child: Text("Cancel",
                                    style: TextStyle(
                                        fontSize: text.scale(16),
                                        color: const Color(0XFFB0B0B0),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins")),
                              ),
                      ),
                      Center(
                        child: Text("Post Survey", style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w700, fontFamily: "Poppins")),
                      ),
                      releaseLoader
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Color(0XFF0EA102),
                                strokeWidth: 2.0,
                              ))
                          : addButton
                              ? GestureDetector(
                                  onTap: () {
                                    logEventFunc(name: 'Survey_Complete', type: 'Survey');
                                    setState(() {
                                      releaseLoader = true;
                                    });
                                    validatePost(
                                      title: _titleController.text,
                                      type: selectedCategory.toLowerCase(),
                                      exc: selectedIdItem,
                                      indus: sendIndustriesList,
                                      tickers: sendTickersList,
                                      questions: questionsData,
                                      active: selected1ddValue == "1 Day" ? '1 day' : selected1ddValue,
                                    );
                                  },
                                  child: Center(
                                    child: Text("Release",
                                        style: TextStyle(
                                            fontSize: text.scale(16),
                                            color: const Color(0XFF0EA102),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins")),
                                  ),
                                )
                              : questionsData.isEmpty
                                  ? GestureDetector(
                                      onTap: () {},
                                      child: Center(
                                        child: Text("Release",
                                            style: TextStyle(
                                                fontSize: text.scale(16),
                                                color: const Color(0XFFB0B0B0),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins")),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Flushbar(
                                          message: "you missed to save a question, please save the release",
                                          duration: const Duration(seconds: 2),
                                        ).show(context);
                                      },
                                      child: Center(
                                        child: Text("Release",
                                            style: TextStyle(
                                                fontSize: text.scale(16),
                                                color: const Color(0XFF0EA102),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins")),
                                      ),
                                    ),
                    ],
                  ),
                ),
              ),
            ),
            body: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (scroll) {
                scroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height / 20.3,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                      height: height / 14.5,
                      child: TextFormField(
                        onTap: () {},
                        onChanged: (value) {
                          setState(() {
                            validTitle = value.isEmpty ? true : RegExp(r"([a-z])").hasMatch(value);
                          });
                        },
                        style: Theme.of(context).textTheme.bodyMedium,
                        controller: _titleController,
                        maxLines: null,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).colorScheme.tertiary,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                          hintText: 'Enter your survey title here...',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    validTitle
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 16.25),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Should at least contain one alphabet.", style: TextStyle(fontSize: 11, color: Colors.red)),
                              ],
                            )),
                    SizedBox(
                      height: height / 50.75,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: width / 3.2,
                          child: CheckboxListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text(
                              "Private",
                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0),
                            ),
                            autofocus: false,
                            activeColor: Colors.green,
                            value: publicOrPrivate,
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            onChanged: (bool? value) async {
                              setState(() {
                                publicOrPrivate = value!;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Active until:  ",
                              style: TextStyle(color: const Color(0xffB0B0B0), fontWeight: FontWeight.w600, fontSize: text.scale(12)),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: width / 25),
                              width: width / 4,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  items: _currencies
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600),
                                            ),
                                          ))
                                      .toList(),
                                  value: selected1ddValue,
                                  onChanged: (String? value) async {
                                    setState(() {
                                      selected1ddValue = value!;
                                    });
                                  },
                                  iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
                                      iconSize: 18,
                                      iconEnabledColor: Colors.black54,
                                      iconDisabledColor: Colors.black54),
                                  buttonStyleData: ButtonStyleData(height: height / 16.24, width: width / 3, elevation: 0),
                                  menuItemStyleData: MenuItemStyleData(height: height / 20.3),
                                  dropdownStyleData: DropdownStyleData(
                                      maxHeight: height / 3.248,
                                      width: width / 2.5,
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(15), color: Theme.of(context).colorScheme.tertiary),
                                      elevation: 8,
                                      offset: const Offset(-20, 0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: height / 67.66),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _questionControllerList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index1) {
                          return Container(
                            margin: EdgeInsets.only(left: width / 27.4, right: width / 27.4, bottom: height / 57.73),
                            padding: EdgeInsets.symmetric(horizontal: width / 31.25),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.75), blurRadius: 4, spreadRadius: 0)
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height / 67.66),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            validTitleList[index1] = value.isEmpty ? true : RegExp(r"([a-z])").hasMatch(value);
                                          });
                                        },
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        controller: _questionControllerList[index1],
                                        maxLines: null,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          fillColor: Theme.of(context).colorScheme.tertiary,
                                          filled: true,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                                          hintText: 'Enter question',
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 93.75,
                                    ),
                                    GestureDetector(
                                      child: Image.asset(
                                        "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                                        height: height / 32.48,
                                        width: width / 15,
                                      ),
                                      onTap: () {
                                        showSheet(index: index1);
                                      },
                                    ),
                                    _questionControllerList.length > 1
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _questionControllerList.removeAt(index1);
                                                questionsData.removeAt(index1);
                                                pickedImage.removeAt(index1);
                                                pickedVideo.removeAt(index1);
                                                pickedFile.removeAt(index1);
                                                selectedUrlType.removeAt(index1);
                                                doc.removeAt(index1);
                                                _answerTypeList.removeAt(index1);
                                                _optionalTypeList.removeAt(index1);
                                                finalControllersList.removeAt(index1);
                                                surveyAttachUrlList.removeAt(index1);
                                                validTitleList.removeAt(index1);
                                              });
                                            },
                                            child: Image.asset(
                                              "lib/Constants/Assets/ForumPage/x.png",
                                              height: height / 32.48,
                                              width: width / 15,
                                            ))
                                        : const SizedBox(),
                                  ],
                                ),
                                validTitleList[index1]
                                    ? const SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.symmetric(horizontal: width / 16.25),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Should at least contain one alphabet.", style: TextStyle(fontSize: 11, color: Colors.red)),
                                          ],
                                        )),
                                (pickedImage[index1] == null && pickedVideo[index1] == null && pickedFile[index1] == null)
                                    ? const SizedBox()
                                    : SizedBox(height: height / 50.75),
                                (pickedImage[index1] == null && pickedVideo[index1] == null && pickedFile[index1] == null)
                                    ? const SizedBox()
                                    : Container(
                                        child: pickedImage[index1] == null && pickedVideo[index1] == null && doc[index1] == null
                                            ? const SizedBox()
                                            : Row(
                                                children: [
                                                  pickedImage[index1] == null
                                                      ? const SizedBox()
                                                      : Row(
                                                          children: [
                                                            Text(
                                                              pickedImage[index1]!.path.split('/').last.toString(),
                                                              style: const TextStyle(fontSize: 8),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  pickedImage[index1] = null;
                                                                  pickedVideo[index1] = null;
                                                                  doc[index1] = null;
                                                                });
                                                              },
                                                              child: Container(
                                                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.close,
                                                                      color: Theme.of(context).colorScheme.onPrimary,
                                                                      size: 12,
                                                                    ),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                  pickedVideo[index1] == null
                                                      ? const SizedBox()
                                                      : Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              pickedVideo[index1]!.path.split('/').last.toString(),
                                                              style: const TextStyle(fontSize: 8),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  pickedImage[index1] = null;
                                                                  pickedVideo[index1] = null;
                                                                  doc[index1] = null;
                                                                });
                                                              },
                                                              child: Container(
                                                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.close,
                                                                      color: Theme.of(context).colorScheme.onPrimary,
                                                                      size: 12,
                                                                    ),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                  doc[index1] == null
                                                      ? const SizedBox()
                                                      : Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              doc[index1]!.files[0].path!.split('/').last.toString(),
                                                              style: const TextStyle(fontSize: 8),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  pickedImage[index1] = null;
                                                                  pickedVideo[index1] = null;
                                                                  doc[index1] = null;
                                                                });
                                                              },
                                                              child: Container(
                                                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.close,
                                                                      color: Theme.of(context).colorScheme.onPrimary,
                                                                      size: 12,
                                                                    ),
                                                                  )),
                                                            ),
                                                          ],
                                                        )
                                                ],
                                              ),
                                      ),
                                (pickedImage[index1] == null && pickedVideo[index1] == null && pickedFile[index1] == null)
                                    ? const SizedBox()
                                    : SizedBox(height: height / 33.83),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showSheet1(index: index1, listLength: finalControllersList[index1].length <= 2 ? false : true);
                                      },
                                      child: SizedBox(
                                        // color: Colors.red,
                                        width: width / 2.5,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                  ),
                                                  height: height / 54.13,
                                                  width: width / 25,
                                                  child: GestureDetector(child: Image.asset("lib/Constants/Assets/ForumPage/Vector 16.png")),
                                                ),
                                                Text(_answerTypeList[index1],
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: text.scale(10),
                                                        color: isDarkTheme.value
                                                            ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)
                                                            : const Color(0xff4A4A4A))),
                                              ],
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 3.2,
                                      child: CheckboxListTile(
                                        dense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: const Text(
                                          "Mandatory",
                                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10.0),
                                        ),
                                        autofocus: false,
                                        activeColor: Colors.green,
                                        value: _optionalTypeList[index1],
                                        onChanged: (bool? value) async {
                                          setState(() {
                                            _optionalTypeList[index1] = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height / 50.75),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: finalControllersList[index1].length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: height / 50.75,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: width / 1.50,
                                                child: TextFormField(
                                                  textInputAction: TextInputAction.done,
                                                  maxLines: null,
                                                  controller: finalControllersList[index1][index],
                                                  style: TextStyle(fontSize: text.scale(12)),
                                                  decoration: InputDecoration(
                                                    focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: isDarkTheme.value
                                                                ? const Color(0xffA5A5A5).withOpacity(0.7)
                                                                : const Color(0xffA5A5A5))),
                                                    enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: isDarkTheme.value
                                                                ? const Color(0xffA5A5A5).withOpacity(0.7)
                                                                : const Color(0xffA5A5A5))),
                                                    disabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: isDarkTheme.value
                                                                ? const Color(0xffA5A5A5).withOpacity(0.7)
                                                                : const Color(0xffA5A5A5))),
                                                    errorBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: isDarkTheme.value
                                                                ? Theme.of(context).colorScheme.tertiary
                                                                : const Color(0xffA5A5A5))),
                                                    border: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: isDarkTheme.value
                                                                ? const Color(0xffA5A5A5).withOpacity(0.7)
                                                                : const Color(0xffA5A5A5))),
                                                    hintText: "Short answer text",
                                                    hintStyle: const TextStyle(color: Color(0xffA5A5A5)),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: width / 93.75,
                                              ),
                                              finalControllersList[index1].length <= 2
                                                  ? const SizedBox()
                                                  : SizedBox(
                                                      height: height / 40.6,
                                                      width: width / 18.75,
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              finalControllersList[index1].removeAt(index);
                                                            });
                                                          },
                                                          child: Image.asset(
                                                            "lib/Constants/Assets/ForumPage/x.png",
                                                          )))
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                                finalControllersList[index1].length > 4 ? SizedBox(height: height / 50.75) : const SizedBox(),
                                saveButton
                                    ? const Center(child: CircularProgressIndicator(color: Color(0XFF0EA102)))
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          finalControllersList[index1].length > 4
                                              ? const SizedBox()
                                              : TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      finalControllersList[index1].add(TextEditingController());
                                                    });
                                                  },
                                                  child: Text(
                                                    "add options +",
                                                    style: TextStyle(
                                                      decoration: TextDecoration.underline,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12,
                                                      color: Theme.of(context).colorScheme.primary,
                                                    ),
                                                  ),
                                                ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                saveButton = true;
                                              });
                                              if ((pickedImage[index1] == null && pickedVideo[index1] == null && pickedFile[index1] == null)) {
                                                textList.clear();
                                                if (finalControllersList[index1].length == 2) {
                                                  if (finalControllersList[index1][0].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][0].text);
                                                  } else {}
                                                  if (finalControllersList[index1][1].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][1].text);
                                                  } else {}
                                                } else if (finalControllersList[index1].length == 3) {
                                                  if (finalControllersList[index1][0].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][0].text);
                                                  } else {}
                                                  if (finalControllersList[index1][1].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][1].text);
                                                  } else {}
                                                  if (finalControllersList[index1][2].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][2].text);
                                                  } else {}
                                                } else if (finalControllersList[index1].length == 4) {
                                                  if (finalControllersList[index1][0].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][0].text);
                                                  } else {}
                                                  if (finalControllersList[index1][1].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][1].text);
                                                  } else {}
                                                  if (finalControllersList[index1][2].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][2].text);
                                                  } else {}
                                                  if (finalControllersList[index1][3].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][3].text);
                                                  } else {}
                                                } else {
                                                  if (finalControllersList[index1][0].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][0].text);
                                                  } else {}
                                                  if (finalControllersList[index1][1].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][1].text);
                                                  } else {}
                                                  if (finalControllersList[index1][2].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][2].text);
                                                  } else {}
                                                  if (finalControllersList[index1][3].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][3].text);
                                                  } else {}
                                                  if (finalControllersList[index1][4].text.isNotEmpty) {
                                                    textList.add(finalControllersList[index1][4].text);
                                                  } else {}
                                                }
                                                if (_questionControllerList[index1].text == "" ||
                                                    _answerTypeList[index1] == "Select Type" ||
                                                    textList.length < 2) {
                                                  if (_questionControllerList[index1].text == "") {
                                                    Flushbar(
                                                      message: "Please enter question",
                                                      duration: const Duration(seconds: 2),
                                                    ).show(context);
                                                    setState(() {
                                                      saveButton = false;
                                                    });
                                                  } else if (_answerTypeList[index1] == "Select Type") {
                                                    Flushbar(
                                                      message: "Please select AnswerType",
                                                      duration: const Duration(seconds: 2),
                                                    ).show(context);
                                                    setState(() {
                                                      saveButton = false;
                                                    });
                                                  } else if (textList.length < 2) {
                                                    Flushbar(
                                                      message: "Please Enter atleast 2 answers to submit the question",
                                                      duration: const Duration(seconds: 2),
                                                    ).show(context);
                                                    setState(() {
                                                      saveButton = false;
                                                    });
                                                  } else {}
                                                } else {
                                                  Map<String, dynamic> surveyData = {};
                                                  if (textList.length == 2) {
                                                    surveyData = {
                                                      "title": _questionControllerList[index1].text,
                                                      "url": surveyAttachUrlList[index1],
                                                      "url_type": selectedUrlType[index1],
                                                      "answer_type": _answerTypeList[index1] == "Single" ? 'single' : 'multiple',
                                                      "optional_type": _optionalTypeList[index1] ? 'mandatory' : 'optional',
                                                      "answer1": textList[0],
                                                      "answer2": textList[1],
                                                    };
                                                  } else if (textList.length == 3) {
                                                    surveyData = {
                                                      "title": _questionControllerList[index1].text,
                                                      "url": surveyAttachUrlList[index1],
                                                      "url_type": selectedUrlType[index1],
                                                      "answer_type": _answerTypeList[index1] == "Single" ? 'single' : 'multiple',
                                                      "optional_type": _optionalTypeList[index1] ? 'mandatory' : 'optional',
                                                      "answer1": textList[0],
                                                      "answer2": textList[1],
                                                      "answer3": textList[2],
                                                    };
                                                  } else if (textList.length == 4) {
                                                    surveyData = {
                                                      "title": _questionControllerList[index1].text,
                                                      "url": surveyAttachUrlList[index1],
                                                      "url_type": selectedUrlType[index1],
                                                      "answer_type": _answerTypeList[index1] == "Single" ? 'single' : 'multiple',
                                                      "optional_type": _optionalTypeList[index1] ? 'mandatory' : 'optional',
                                                      "answer1": textList[0],
                                                      "answer2": textList[1],
                                                      "answer3": textList[2],
                                                      "answer4": textList[3],
                                                    };
                                                  } else if (textList.length == 5) {
                                                    surveyData = {
                                                      "title": _questionControllerList[index1].text,
                                                      "url": surveyAttachUrlList[index1],
                                                      "url_type": selectedUrlType[index1],
                                                      "answer_type": _answerTypeList[index1] == "Single" ? 'single' : 'multiple',
                                                      "optional_type": _optionalTypeList[index1] ? 'mandatory' : 'optional',
                                                      "answer1": textList[0],
                                                      "answer2": textList[1],
                                                      "answer3": textList[2],
                                                      "answer4": textList[3],
                                                      "answer5": textList[4],
                                                    };
                                                  } else {}

                                                  questionsData.isEmpty
                                                      ? debugPrint("empty")
                                                      : (index1 + 1) > questionsData.length
                                                          ? debugPrint("not available")
                                                          : questionsData.removeAt(index1);
                                                  questionsData.isEmpty
                                                      ? questionsData.add(surveyData)
                                                      : (index1 + 1) > questionsData.length
                                                          ? questionsData.add(surveyData)
                                                          : questionsData[index1] = surveyData;
                                                  textList.clear();
                                                  Flushbar(
                                                    message: "Question got added successfully",
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                  setState(() {
                                                    addButton = true;
                                                    saveButton = false;
                                                  });
                                                }
                                              } else {
                                                if (uploadCompleted) {
                                                  textList.clear();
                                                  if (finalControllersList[index1].length == 2) {
                                                    if (finalControllersList[index1][0].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][0].text);
                                                    } else {}
                                                    if (finalControllersList[index1][1].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][1].text);
                                                    } else {}
                                                  } else if (finalControllersList[index1].length == 3) {
                                                    if (finalControllersList[index1][0].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][0].text);
                                                    } else {}
                                                    if (finalControllersList[index1][1].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][1].text);
                                                    } else {}
                                                    if (finalControllersList[index1][2].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][2].text);
                                                    } else {}
                                                  } else if (finalControllersList[index1].length == 4) {
                                                    if (finalControllersList[index1][0].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][0].text);
                                                    } else {}
                                                    if (finalControllersList[index1][1].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][1].text);
                                                    } else {}
                                                    if (finalControllersList[index1][2].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][2].text);
                                                    } else {}
                                                    if (finalControllersList[index1][3].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][3].text);
                                                    } else {}
                                                  } else {
                                                    if (finalControllersList[index1][0].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][0].text);
                                                    } else {}
                                                    if (finalControllersList[index1][1].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][1].text);
                                                    } else {}
                                                    if (finalControllersList[index1][2].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][2].text);
                                                    } else {}
                                                    if (finalControllersList[index1][3].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][3].text);
                                                    } else {}
                                                    if (finalControllersList[index1][4].text.isNotEmpty) {
                                                      textList.add(finalControllersList[index1][4].text);
                                                    } else {}
                                                  }
                                                  if (_questionControllerList[index1].text == "" ||
                                                      _answerTypeList[index1] == "Select Type" ||
                                                      textList.length < 2) {
                                                    if (_questionControllerList[index1].text == "") {
                                                      Flushbar(
                                                        message: "Please enter question",
                                                        duration: const Duration(seconds: 2),
                                                      ).show(context);
                                                      setState(() {
                                                        saveButton = false;
                                                      });
                                                    } else if (_answerTypeList[index1] == "Select Type") {
                                                      Flushbar(
                                                        message: "Please select AnswerType",
                                                        duration: const Duration(seconds: 2),
                                                      ).show(context);
                                                      setState(() {
                                                        saveButton = false;
                                                      });
                                                    } else if (textList.length < 2) {
                                                      Flushbar(
                                                        message: "Please Enter atleast 2 answers to submit the question",
                                                        duration: const Duration(seconds: 2),
                                                      ).show(context);
                                                      setState(() {
                                                        saveButton = false;
                                                      });
                                                    } else {}
                                                  } else {
                                                    Map<String, dynamic> surveyData = {};
                                                    if (textList.length == 2) {
                                                      surveyData = {
                                                        "title": _questionControllerList[index1].text,
                                                        "url": surveyAttachUrlList[index1],
                                                        "url_type": selectedUrlType[index1],
                                                        "answer_type": _answerTypeList[index1] == "Single" ? 'single' : 'multiple',
                                                        "optional_type": _optionalTypeList[index1] ? 'mandatory' : 'optional',
                                                        "answer1": textList[0],
                                                        "answer2": textList[1],
                                                      };
                                                    } else if (textList.length == 3) {
                                                      surveyData = {
                                                        "title": _questionControllerList[index1].text,
                                                        "url": surveyAttachUrlList[index1],
                                                        "url_type": selectedUrlType[index1],
                                                        "answer_type": _answerTypeList[index1] == "Single" ? 'single' : 'multiple',
                                                        "optional_type": _optionalTypeList[index1] ? 'mandatory' : 'optional',
                                                        "answer1": textList[0],
                                                        "answer2": textList[1],
                                                        "answer3": textList[2],
                                                      };
                                                    } else if (textList.length == 4) {
                                                      surveyData = {
                                                        "title": _questionControllerList[index1].text,
                                                        "url": surveyAttachUrlList[index1],
                                                        "url_type": selectedUrlType[index1],
                                                        "answer_type": _answerTypeList[index1] == "Single" ? 'single' : 'multiple',
                                                        "optional_type": _optionalTypeList[index1] ? 'mandatory' : 'optional',
                                                        "answer1": textList[0],
                                                        "answer2": textList[1],
                                                        "answer3": textList[2],
                                                        "answer4": textList[3],
                                                      };
                                                    } else if (textList.length == 5) {
                                                      surveyData = {
                                                        "title": _questionControllerList[index1].text,
                                                        "url": surveyAttachUrlList[index1],
                                                        "url_type": selectedUrlType[index1],
                                                        "answer_type": _answerTypeList[index1] == "Single" ? 'single' : 'multiple',
                                                        "optional_type": _optionalTypeList[index1] ? 'mandatory' : 'optional',
                                                        "answer1": textList[0],
                                                        "answer2": textList[1],
                                                        "answer3": textList[2],
                                                        "answer4": textList[3],
                                                        "answer5": textList[4],
                                                      };
                                                    } else {}

                                                    questionsData.isEmpty
                                                        ? debugPrint("empty")
                                                        : (index1 + 1) > questionsData.length
                                                            ? debugPrint("not available")
                                                            : questionsData.removeAt(index1);
                                                    questionsData.isEmpty
                                                        ? questionsData.add(surveyData)
                                                        : (index1 + 1) > questionsData.length
                                                            ? questionsData.add(surveyData)
                                                            : questionsData[index1] = surveyData;
                                                    textList.clear();
                                                    Flushbar(
                                                      message: "Question got added successfully",
                                                      duration: const Duration(seconds: 2),
                                                    ).show(context);
                                                    setState(() {
                                                      addButton = true;
                                                      saveButton = false;
                                                      uploadCompleted = false;
                                                    });
                                                  }
                                                } else {
                                                  Flushbar(
                                                    message: "Attachment is still uploading, Please wait...",
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                  setState(() {
                                                    saveButton = false;
                                                  });
                                                }
                                              }
                                            },
                                            child: Text(
                                              "save question",
                                              style: TextStyle(
                                                decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          );
                        }),
                    SizedBox(height: height / 70.75),
                    addButton
                        ? _questionControllerList.length > 9
                            ? const SizedBox()
                            : Center(
                                child: SizedBox(
                                  height: height / 18.04,
                                  width: width / 8.33,
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        _questionControllerList.add(TextEditingController());
                                        questionsData.add({});
                                        pickedImage.add(null);
                                        pickedVideo.add(null);
                                        pickedFile.add(null);
                                        selectedUrlType.add("");
                                        doc.add(null);
                                        finalControllersList.add(List.generate(2, (i) => TextEditingController()));
                                        _optionalTypeList.add(true);
                                        _answerTypeList.add("Select Type");
                                        surveyAttachUrlList.add("");
                                        validTitleList.add(true);
                                        addButton = false;
                                      });
                                    },
                                    tooltip: "add a new question",
                                    backgroundColor: const Color(0XFF0EA102),
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              )
                        : Center(
                            child: SizedBox(
                              height: height / 18.04,
                              width: width / 8.33,
                              child: FloatingActionButton(
                                onPressed: () {
                                  Flushbar(
                                    message: "Please Save the Question",
                                    duration: const Duration(seconds: 2),
                                  ).show(context);
                                },
                                //tooltip: "add a new question",
                                backgroundColor: Colors.grey,
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: height / 50.75,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 37.5),
                      child: ListTile(
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
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const Row(
                                              children: [
                                                Text(
                                                  "Categories",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                                                      child: ListView.builder(
                                                          itemCount: categoriesList.length,
                                                          itemBuilder: (BuildContext context, index) {
                                                            return RadioListTile(
                                                              activeColor: Colors.green,
                                                              controlAffinity: ListTileControlAffinity.trailing,
                                                              value: index.toString(),
                                                              groupValue: selectedValue,
                                                              onChanged: (value) {
                                                                modelSetState(() {
                                                                  selectedValue = value.toString();
                                                                });
                                                              },
                                                              title: Text(
                                                                categoriesList[index],
                                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
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
                                                  color: Theme.of(context).colorScheme.background,
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
                                                                child: Text("Cancel",
                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
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
                                                              selectedCategory = categoriesList[int.parse(selectedValue)];
                                                              _selectSubCategory = selectedValue == "0"
                                                                  ? "Select a Exchange"
                                                                  : selectedValue == "1"
                                                                      ? "Select a Crypto Type"
                                                                      : selectedValue == "2"
                                                                          ? "Select a Country"
                                                                          : selectedValue == "3"
                                                                              ? ""
                                                                              : "";
                                                              _selectIndex = selectedValue == "0"
                                                                  ? "Select a Ticker"
                                                                  : selectedValue == "1"
                                                                      ? "Select a Ticker"
                                                                      : selectedValue == "2"
                                                                          ? "Select a Ticker"
                                                                          : selectedValue == "3"
                                                                              ? "Select a Ticker"
                                                                              : "";
                                                              selectedIdItem = "";
                                                              selectAll = false;
                                                              tickerSelectAll = false;
                                                              _selectedExchange = "";
                                                              sendIndustriesList.clear();
                                                              sendIndustriesNameList.clear();
                                                              sendTickersList.clear();
                                                              sendTickersNameList.clear();
                                                            });
                                                            selectedValue == "0"
                                                                ? await getEx(newSetState1: modelSetState)
                                                                : selectedValue == "1"
                                                                    ? await getIndustries(newSetState: setState)
                                                                    : selectedValue == "3"
                                                                        ? await getTickersFunc(tickerSetState: setState)
                                                                        : debugPrint("CommodityPA");
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
                                                                child:
                                                                    Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
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
                        title: Text(selectedCategory),
                        trailing: const Icon(Icons.keyboard_arrow_down_sharp),
                      ),
                    ),
                    selectedValue == ""
                        ? const SizedBox()
                        : selectedValue == "0"
                            ?
                            //Stocks
                            Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width / 37.5),
                                    child: ListTile(
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
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          const Row(
                                                            children: [
                                                              Text(
                                                                "Exchanges",
                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                                                                                _selectedExchange = value.toString();
                                                                                selectedIdItem = exchangeIdList[index];
                                                                              });
                                                                              setState(() {
                                                                                _selectSubCategory = exchangeNameList[index];
                                                                              });
                                                                            },
                                                                            title: Text(
                                                                              exchangeNameList[index],
                                                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                            ),
                                                                            subtitle: Text(
                                                                              exchangeCodeList[index],
                                                                              style: const TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 12.0,
                                                                                  color: Color(0XFFA5A5A5)),
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
                                                                color: Theme.of(context).colorScheme.background,
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
                                                                              child: Text("Cancel",
                                                                                  style:
                                                                                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 7,
                                                                    ),
                                                                    Expanded(
                                                                      child: GestureDetector(
                                                                        onTap: () async {
                                                                          /*await getIndustries(newSetState: modelSetState);*/
                                                                          selectedIdItem == "General"
                                                                              ? debugPrint("General one")
                                                                              : await getTickersFunc(tickerSetState: modelSetState);
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
                                      title: Text(_selectSubCategory),
                                      trailing: const Icon(Icons.keyboard_arrow_down_sharp),
                                    ),
                                  ),
                                  selectedIdItem == "General"
                                      ? const SizedBox()
                                      : selectedIdItem == ""
                                          ? const SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.symmetric(horizontal: width / 37.5),
                                              child: ListTile(
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
                                                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                                                                          await getTickersFunc(tickerSetState: modelSetState);
                                                                        } else if (value.isEmpty) {
                                                                          tickersTextValue = "";
                                                                          await getTickersFunc(tickerSetState: modelSetState);
                                                                        } else {
                                                                          tickersTextValue = "";
                                                                          await getTickersFunc(tickerSetState: modelSetState);
                                                                        }
                                                                      },
                                                                      style: Theme.of(context).textTheme.bodyMedium,
                                                                      controller: _tickerSearchController,
                                                                      keyboardType: TextInputType.emailAddress,
                                                                      decoration: InputDecoration(
                                                                        fillColor: Theme.of(context).colorScheme.tertiary,
                                                                        filled: true,
                                                                        prefixIcon: Padding(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: width / 27.4, vertical: height / 57.73),
                                                                          child: SvgPicture.asset(
                                                                              "lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                                        ),
                                                                        contentPadding: EdgeInsets.all(height / 35.6),
                                                                        focusedErrorBorder: OutlineInputBorder(
                                                                          borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                          borderRadius: BorderRadius.circular(12),
                                                                        ),
                                                                        focusedBorder: OutlineInputBorder(
                                                                          borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                          borderRadius: BorderRadius.circular(12),
                                                                        ),
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                          borderRadius: BorderRadius.circular(12),
                                                                        ),
                                                                        hintStyle: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .copyWith(color: const Color(0XFFA5A5A5)),
                                                                        hintText: 'Search here',
                                                                        border: OutlineInputBorder(
                                                                          borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                          borderRadius: BorderRadius.circular(12),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: height / 50.75,
                                                                    ),
                                                                    const Text(
                                                                      "Name of Stocks",
                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                    ),
                                                                    SizedBox(
                                                                      height: height / 50.75,
                                                                    ),
                                                                    Stack(
                                                                      alignment: AlignmentDirectional.bottomCenter,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            CheckboxListTile(
                                                                              title: const Text(
                                                                                "General",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                              ),
                                                                              subtitle: const Text(
                                                                                'Use this option, if you want to create something generic',
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w500,
                                                                                    fontSize: 12.0,
                                                                                    color: Color(0XFFA5A5A5)),
                                                                              ),
                                                                              secondary: SizedBox(
                                                                                  height: height / 23.73,
                                                                                  width: width / 12,
                                                                                  child: SvgPicture.asset(
                                                                                      "lib/Constants/Assets/SMLogos/masari-msr-logo.svg",
                                                                                      fit: BoxFit.fill)),
                                                                              autofocus: false,
                                                                              activeColor: Colors.green,
                                                                              value: tickerSelectAll,
                                                                              onChanged: (bool? value) async {
                                                                                if (value!) {
                                                                                  sendTickersList.clear();
                                                                                  modelSetState(() {
                                                                                    tickerSelectAll = value;
                                                                                    // getTickersFunc(tickerSetState: modelSetState);
                                                                                  });
                                                                                } else {
                                                                                  modelSetState(() {
                                                                                    tickerSelectAll = value;
                                                                                    sendTickersList.clear();
                                                                                  });
                                                                                  //getTickersFunc( tickerSetState:modelSetState);
                                                                                }
                                                                                await getTickersFunc(tickerSetState: modelSetState);
                                                                              },
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
                                                                                  await getRefreshTickersFunc(tickerSetState1: modelSetState);
                                                                                  if (mounted) modelSetState(() {});
                                                                                  _refreshController.loadComplete();
                                                                                },
                                                                                child: ListView.builder(
                                                                                    itemCount: tickersNameList.length,
                                                                                    itemBuilder: (BuildContext context, index) {
                                                                                      return CheckboxListTile(
                                                                                        title: Text(
                                                                                          tickersNameList[index],
                                                                                          style: const TextStyle(
                                                                                              fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          tickersCodeList[index],
                                                                                          style: const TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 12.0,
                                                                                              color: Color(0XFFA5A5A5)),
                                                                                        ),
                                                                                        //subtitle: const Text('A computer science portal for geeks.'),
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
                                                                          color: Theme.of(context).colorScheme.background,
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    //_tickerSearchController.clear();
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
                                                                                        child: Text("Cancel",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.bold, color: Colors.black))),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 7,
                                                                              ),
                                                                              Expanded(
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    // _tickerSearchController.clear();
                                                                                    setState(() {
                                                                                      if (tickerSelectAll) {
                                                                                        _selectIndex = "General";
                                                                                      } else {
                                                                                        if (sendTickersList.length == 1) {
                                                                                          _selectIndex = sendTickersNameList[0];
                                                                                        } else if (sendTickersList.isEmpty) {
                                                                                          _selectIndex = "Nothing";
                                                                                        } else {
                                                                                          _selectIndex = "Multiple";
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
                                                title: Text(_selectIndex),
                                                trailing: const Icon(Icons.keyboard_arrow_down_sharp),
                                              ),
                                            ),
                                ],
                              )
                            : (selectedValue == "1" || selectedValue == "2")
                                ?
                                //Crypto & Commodity
                                selectedValue == "1"
                                    ?
                                    //Crypto
                                    Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width / 37.5),
                                            child: ListTile(
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
                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                                                                                if (mounted) modelSetState(() {});
                                                                                _controller.loadComplete();
                                                                              },
                                                                              child: ListView.builder(
                                                                                  itemCount: industriesNameList.length,
                                                                                  itemBuilder: (BuildContext context, index) {
                                                                                    return index == 0
                                                                                        ? RadioListTile(
                                                                                            activeColor: Colors.green,
                                                                                            controlAffinity: ListTileControlAffinity.trailing,
                                                                                            value: index.toString(),
                                                                                            groupValue: _selectedExchange,
                                                                                            onChanged: (value) {
                                                                                              modelSetState(() {
                                                                                                sendIndustriesList.clear();
                                                                                                _selectIndex = "Select a Ticker";
                                                                                                _selectedExchange = value.toString();
                                                                                                sendIndustriesList.add(industriesIdList[index]);
                                                                                              });
                                                                                              setState(() {
                                                                                                _selectSubCategory = industriesNameList[index];
                                                                                              });
                                                                                            },
                                                                                            title: Text(
                                                                                              industriesNameList[index],
                                                                                              style: const TextStyle(
                                                                                                  fontSize: 12,
                                                                                                  fontFamily: "Poppins",
                                                                                                  fontWeight: FontWeight.w700),
                                                                                            ),
                                                                                            subtitle: const Text(
                                                                                              'Use this option, if you want to create something generic',
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontSize: 12.0,
                                                                                                  color: Color(0XFFA5A5A5)),
                                                                                            ),
                                                                                          )
                                                                                        : RadioListTile(
                                                                                            activeColor: Colors.green,
                                                                                            controlAffinity: ListTileControlAffinity.trailing,
                                                                                            value: index.toString(),
                                                                                            groupValue: _selectedExchange,
                                                                                            onChanged: (value) {
                                                                                              modelSetState(() {
                                                                                                sendIndustriesList.clear();
                                                                                                _selectIndex = "Select a Ticker";
                                                                                                _selectedExchange = value.toString();
                                                                                                sendIndustriesList.add(industriesIdList[index]);
                                                                                              });
                                                                                              setState(() {
                                                                                                _selectSubCategory = industriesNameList[index];
                                                                                              });
                                                                                            },
                                                                                            title: Text(
                                                                                              industriesNameList[index],
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
                                                                        color: Theme.of(context).colorScheme.background,
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
                                                                                      child: Text("Cancel",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color: Colors.black))),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 7,
                                                                            ),
                                                                            Expanded(
                                                                              child: GestureDetector(
                                                                                onTap: () async {
                                                                                  if (sendIndustriesList[0] == "General") {
                                                                                  } else {
                                                                                    await getTickersFunc(tickerSetState: modelSetState);
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
                                              title: Text(_selectSubCategory),
                                              trailing: const Icon(Icons.keyboard_arrow_down_sharp),
                                            ),
                                          ),
                                          sendIndustriesList.isEmpty
                                              ? const SizedBox()
                                              : sendIndustriesList[0] == "General"
                                                  ? const SizedBox()
                                                  : Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: width / 37.5),
                                                      child: ListTile(
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
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                                                                                  await getTickersFunc(tickerSetState: modelSetState);
                                                                                } else if (value.isEmpty) {
                                                                                  tickersTextValue = "";
                                                                                  await getTickersFunc(tickerSetState: modelSetState);
                                                                                } else {
                                                                                  tickersTextValue = "";
                                                                                  await getTickersFunc(tickerSetState: modelSetState);
                                                                                }
                                                                              },
                                                                              style: Theme.of(context).textTheme.bodyMedium,
                                                                              controller: _tickerSearchController,
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              decoration: InputDecoration(
                                                                                fillColor: Theme.of(context).colorScheme.tertiary,
                                                                                filled: true,
                                                                                prefixIcon: Padding(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: width / 27.4, vertical: height / 57.73),
                                                                                  child: SvgPicture.asset(
                                                                                      "lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                                                ),
                                                                                contentPadding: EdgeInsets.all(height / 35.6),
                                                                                focusedErrorBorder: OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                                hintStyle: Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodyMedium!
                                                                                    .copyWith(color: const Color(0XFFA5A5A5)),
                                                                                hintText: 'Search here',
                                                                                border: OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: height / 50.75,
                                                                            ),
                                                                            const Text(
                                                                              "Name of Crypto",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                            ),
                                                                            SizedBox(
                                                                              height: height / 50.75,
                                                                            ),
                                                                            Stack(
                                                                              alignment: AlignmentDirectional.bottomCenter,
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    CheckboxListTile(
                                                                                      title: const Text(
                                                                                        "General",
                                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                                      ),
                                                                                      subtitle: const Text(
                                                                                        'Use this option, if you want to create something generic',
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 12.0,
                                                                                            color: Color(0XFFA5A5A5)),
                                                                                      ),
                                                                                      secondary: SizedBox(
                                                                                          height: height / 23.73,
                                                                                          width: width / 12,
                                                                                          child: SvgPicture.asset(
                                                                                              "lib/Constants/Assets/SMLogos/masari-msr-logo.svg",
                                                                                              fit: BoxFit.fill)),
                                                                                      autofocus: false,
                                                                                      activeColor: Colors.green,
                                                                                      //selected: _value,
                                                                                      value: tickerSelectAll,
                                                                                      onChanged: (bool? value) {
                                                                                        modelSetState(() {
                                                                                          if (value!) {
                                                                                            sendTickersList.clear();
                                                                                            modelSetState(() {
                                                                                              tickerSelectAll = value;
                                                                                              sendTickersList.addAll(tickersCatIdList);
                                                                                              _selectIndex = "multiple";
                                                                                              getTickersFunc(tickerSetState: modelSetState);
                                                                                            });
                                                                                          } else {
                                                                                            modelSetState(() {
                                                                                              tickerSelectAll = value;
                                                                                              sendTickersList.clear();
                                                                                              _selectIndex = "Select a Ticker";
                                                                                            });
                                                                                            getTickersFunc(tickerSetState: modelSetState);
                                                                                          }
                                                                                        });
                                                                                      },
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
                                                                                                      for (int i = 0;
                                                                                                          i < sendTickersList.length;
                                                                                                          i++) {
                                                                                                        if (sendTickersList[i] ==
                                                                                                            tickersCatIdList[index]) {
                                                                                                          sendTickersList.removeAt(i);
                                                                                                          tickerSelectAll = false;
                                                                                                        }
                                                                                                      }
                                                                                                    });
                                                                                                  }
                                                                                                  setState(() {
                                                                                                    if (sendTickersList.length == 1) {
                                                                                                      _selectIndex = sendTickersNameList[0];
                                                                                                    } else if (sendTickersList.isEmpty) {
                                                                                                      _selectIndex = "Nothing";
                                                                                                    } else {
                                                                                                      _selectIndex = "Multiple";
                                                                                                    }
                                                                                                  });
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
                                                                                  color: Theme.of(context).colorScheme.background,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: GestureDetector(
                                                                                          onTap: () {
                                                                                            _tickerSearchController.clear();
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
                                                                                                child: Text("Cancel",
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        color: Colors.black))),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 7,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: GestureDetector(
                                                                                          onTap: () {
                                                                                            _tickerSearchController.clear();
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
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        color: Colors.white))),
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
                                                        title: Text(_selectIndex),
                                                        trailing: const Icon(Icons.keyboard_arrow_down_sharp),
                                                      ),
                                                    ),
                                        ],
                                      )
                                    :
                                    //Commodity
                                    Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width / 37.5),
                                            child: ListTile(
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
                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                                                                                if (mounted) modelSetState(() {});
                                                                                _controller.loadComplete();
                                                                              },
                                                                              child: ListView.builder(
                                                                                  itemCount: countriesList.length,
                                                                                  itemBuilder: (BuildContext context, index) {
                                                                                    return index == 0
                                                                                        ? RadioListTile(
                                                                                            activeColor: Colors.green,
                                                                                            controlAffinity: ListTileControlAffinity.trailing,
                                                                                            value: index.toString(),
                                                                                            groupValue: _selectedExchange,
                                                                                            onChanged: (value) {
                                                                                              modelSetState(() {
                                                                                                _selectIndex = "Select a Ticker";
                                                                                                _selectedExchange = value.toString();
                                                                                                selectedIdItem = countriesList[index];
                                                                                              });
                                                                                              setState(() {
                                                                                                _selectSubCategory = countriesList[index];
                                                                                              });
                                                                                            },
                                                                                            title: Text(
                                                                                              countriesList[index],
                                                                                              style: const TextStyle(
                                                                                                  fontSize: 12,
                                                                                                  fontFamily: "Poppins",
                                                                                                  fontWeight: FontWeight.w700),
                                                                                            ),
                                                                                            subtitle: const Text(
                                                                                              'Use this option, if you want to create something generic',
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontSize: 12.0,
                                                                                                  color: Color(0XFFA5A5A5)),
                                                                                            ),
                                                                                          )
                                                                                        : RadioListTile(
                                                                                            activeColor: Colors.green,
                                                                                            controlAffinity: ListTileControlAffinity.trailing,
                                                                                            value: index.toString(),
                                                                                            groupValue: _selectedExchange,
                                                                                            onChanged: (value) {
                                                                                              modelSetState(() {
                                                                                                _selectIndex = "Select a Ticker";
                                                                                                _selectedExchange = value.toString();
                                                                                                selectedIdItem = countriesList[index];
                                                                                              });
                                                                                              setState(() {
                                                                                                _selectSubCategory = countriesList[index];
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
                                                                        color: Theme.of(context).colorScheme.background,
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
                                                                                      child: Text("Cancel",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color: Colors.black))),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 7,
                                                                            ),
                                                                            Expanded(
                                                                              child: GestureDetector(
                                                                                onTap: () async {
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
                                              title: Text(_selectSubCategory),
                                              trailing: const Icon(Icons.keyboard_arrow_down_sharp),
                                            ),
                                          ),
                                          selectedIdItem == "General"
                                              ? const SizedBox()
                                              : selectedIdItem == ""
                                                  ? const SizedBox()
                                                  : Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: width / 37.5),
                                                      child: ListTile(
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
                                                                                  "Commodity",
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                                                                                  await getTickersFunc(tickerSetState: modelSetState);
                                                                                } else if (value.isEmpty) {
                                                                                  tickersTextValue = "";
                                                                                  await getTickersFunc(tickerSetState: modelSetState);
                                                                                } else {
                                                                                  tickersTextValue = "";
                                                                                  await getTickersFunc(tickerSetState: modelSetState);
                                                                                }
                                                                              },
                                                                              style: Theme.of(context).textTheme.bodyMedium,
                                                                              controller: _tickerSearchController,
                                                                              keyboardType: TextInputType.emailAddress,
                                                                              decoration: InputDecoration(
                                                                                fillColor: Theme.of(context).colorScheme.tertiary,
                                                                                filled: true,
                                                                                prefixIcon: Padding(
                                                                                  padding: EdgeInsets.symmetric(
                                                                                      horizontal: width / 27.4, vertical: height / 57.73),
                                                                                  child: SvgPicture.asset(
                                                                                      "lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                                                ),
                                                                                contentPadding: EdgeInsets.all(height / 35.6),
                                                                                focusedErrorBorder: OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                                hintStyle: Theme.of(context)
                                                                                    .textTheme
                                                                                    .bodyMedium!
                                                                                    .copyWith(color: const Color(0XFFA5A5A5)),
                                                                                hintText: 'Search here',
                                                                                border: OutlineInputBorder(
                                                                                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                  borderRadius: BorderRadius.circular(12),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: height / 50.75,
                                                                            ),
                                                                            const Text(
                                                                              "Name of Commodity",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                            ),
                                                                            SizedBox(
                                                                              height: height / 50.75,
                                                                            ),
                                                                            Stack(
                                                                              alignment: AlignmentDirectional.bottomCenter,
                                                                              children: [
                                                                                Column(
                                                                                  children: [
                                                                                    CheckboxListTile(
                                                                                      title: const Text(
                                                                                        "General",
                                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                                      ),
                                                                                      subtitle: const Text(
                                                                                        'Use this option, if you want to create something generic',
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500,
                                                                                            fontSize: 12.0,
                                                                                            color: Color(0XFFA5A5A5)),
                                                                                      ),
                                                                                      secondary: SizedBox(
                                                                                          height: height / 23.73,
                                                                                          width: width / 12,
                                                                                          child: SvgPicture.asset(
                                                                                              "lib/Constants/Assets/SMLogos/masari-msr-logo.svg",
                                                                                              fit: BoxFit.fill)),
                                                                                      autofocus: false,
                                                                                      activeColor: Colors.green,
                                                                                      //selected: _value,
                                                                                      value: tickerSelectAll,
                                                                                      onChanged: (bool? value) {
                                                                                        modelSetState(() {
                                                                                          if (value!) {
                                                                                            sendTickersList.clear();
                                                                                            modelSetState(() {
                                                                                              tickerSelectAll = value;
                                                                                              sendTickersList.addAll(tickersCatIdList);
                                                                                              _selectIndex = "multiple";
                                                                                              getTickersFunc(tickerSetState: modelSetState);
                                                                                            });
                                                                                          } else {
                                                                                            modelSetState(() {
                                                                                              tickerSelectAll = value;
                                                                                              sendTickersList.clear();
                                                                                              _selectIndex = "Select a Ticker";
                                                                                            });
                                                                                            getTickersFunc(tickerSetState: modelSetState);
                                                                                          }
                                                                                        });
                                                                                      },
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
                                                                                                      for (int i = 0;
                                                                                                          i < sendTickersList.length;
                                                                                                          i++) {
                                                                                                        if (sendTickersList[i] ==
                                                                                                            tickersCatIdList[index]) {
                                                                                                          sendTickersList.removeAt(i);
                                                                                                          tickerSelectAll = false;
                                                                                                        }
                                                                                                      }
                                                                                                    });
                                                                                                  }
                                                                                                  setState(() {
                                                                                                    if (sendTickersList.length == 1) {
                                                                                                      _selectIndex = sendTickersNameList[0];
                                                                                                    } else if (sendTickersList.isEmpty) {
                                                                                                      _selectIndex = "Nothing";
                                                                                                    } else {
                                                                                                      _selectIndex = "Multiple";
                                                                                                    }
                                                                                                  });
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
                                                                                  color: Theme.of(context).colorScheme.background,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: GestureDetector(
                                                                                          onTap: () {
                                                                                            _tickerSearchController.clear();
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
                                                                                                child: Text("Cancel",
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        color: Colors.black))),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 7,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: GestureDetector(
                                                                                          onTap: () {
                                                                                            _tickerSearchController.clear();
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
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        color: Colors.white))),
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
                                                        title: Text(_selectIndex),
                                                        trailing: const Icon(Icons.keyboard_arrow_down_sharp),
                                                      ),
                                                    ),
                                        ],
                                      )
                                : selectedValue == "3"
                                    ?
                                    //Forex
                                    Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width / 37.5),
                                            child: ListTile(
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
                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                                                                        await getTickersFunc(tickerSetState: modelSetState);
                                                                      } else if (value.isEmpty) {
                                                                        tickersTextValue = "";
                                                                        await getTickersFunc(tickerSetState: modelSetState);
                                                                      } else {
                                                                        tickersTextValue = "";
                                                                        await getTickersFunc(tickerSetState: modelSetState);
                                                                      }
                                                                    },
                                                                    style: Theme.of(context).textTheme.bodyMedium,
                                                                    controller: _tickerSearchController,
                                                                    keyboardType: TextInputType.emailAddress,
                                                                    decoration: InputDecoration(
                                                                      fillColor: Theme.of(context).colorScheme.tertiary,
                                                                      filled: true,
                                                                      prefixIcon: Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                                                        child: SvgPicture.asset(
                                                                            "lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                                                                      ),
                                                                      contentPadding: EdgeInsets.all(height / 35.6),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                      hintStyle: Theme.of(context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(color: const Color(0XFFA5A5A5)),
                                                                      hintText: 'Search here',
                                                                      border: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                        borderRadius: BorderRadius.circular(12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 50.75,
                                                                  ),
                                                                  const Text(
                                                                    "Name of Forex",
                                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                  ),
                                                                  SizedBox(
                                                                    height: height / 50.75,
                                                                  ),
                                                                  Stack(
                                                                    alignment: AlignmentDirectional.bottomCenter,
                                                                    children: [
                                                                      Column(
                                                                        children: [
                                                                          CheckboxListTile(
                                                                            title: const Text(
                                                                              "General",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                                                            ),
                                                                            subtitle: const Text(
                                                                              'Use this option, if you want to create something generic',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 12.0,
                                                                                  color: Color(0XFFA5A5A5)),
                                                                            ),
                                                                            secondary: SizedBox(
                                                                                height: height / 23.73,
                                                                                width: width / 12,
                                                                                child: SvgPicture.asset(
                                                                                    "lib/Constants/Assets/SMLogos/masari-msr-logo.svg",
                                                                                    fit: BoxFit.fill)),
                                                                            autofocus: false,
                                                                            activeColor: Colors.green,
                                                                            //selected: _value,
                                                                            value: tickerSelectAll,
                                                                            onChanged: (bool? value) {
                                                                              modelSetState(() {
                                                                                if (value!) {
                                                                                  sendTickersList.clear();
                                                                                  modelSetState(() {
                                                                                    tickerSelectAll = value;
                                                                                    sendTickersList.addAll(tickersCatIdList);
                                                                                    _selectIndex = "multiple";
                                                                                    getTickersFunc(tickerSetState: modelSetState);
                                                                                  });
                                                                                } else {
                                                                                  modelSetState(() {
                                                                                    tickerSelectAll = value;
                                                                                    sendTickersList.clear();
                                                                                    _selectIndex = "Select a Ticker";
                                                                                  });
                                                                                  getTickersFunc(tickerSetState: modelSetState);
                                                                                }
                                                                              });
                                                                            },
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
                                                                                await getRefreshTickersFunc(tickerSetState1: modelSetState);
                                                                                if (mounted) modelSetState(() {});
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
                                                                                        setState(() {
                                                                                          if (sendTickersList.length == 1) {
                                                                                            _selectIndex = sendTickersNameList[0];
                                                                                          } else if (sendTickersList.isEmpty) {
                                                                                            _selectIndex = "Nothing";
                                                                                          } else {
                                                                                            _selectIndex = "Multiple";
                                                                                          }
                                                                                        });
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
                                                                        color: Theme.of(context).colorScheme.background,
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  _tickerSearchController.clear();
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
                                                                                      child: Text("Cancel",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.bold, color: Colors.black))),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 7,
                                                                            ),
                                                                            Expanded(
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  _tickerSearchController.clear();
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
                                              title: Text(_selectIndex),
                                              trailing: const Icon(Icons.keyboard_arrow_down_sharp),
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSheet({required int index}) {
    ImagePicker picker = ImagePicker();
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () async {
                      final image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          pickedImage[index] = File(image.path);
                          selectedUrlType[index] = "image";
                          pickedVideo[index] = null;
                        });
                        if (!mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
                        await fileUploadingFunc(file: pickedImage[index], surveyUrlType: selectedUrlType[index], index: index);
                      }
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.image_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Image",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.tertiary,
                    thickness: 0.8,
                  ),
                  ListTile(
                    onTap: () async {
                      final video = await picker.pickVideo(source: ImageSource.gallery);
                      if (video != null) {
                        setState(() {
                          pickedVideo[index] = File(video.path);
                          pickedImage[index] = null;
                          selectedUrlType[index] = "video";
                        });
                        BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
                            aspectRatio: 16 / 9,
                            fit: BoxFit.contain,
                            controlsConfiguration: BetterPlayerControlsConfiguration(
                              enableFullscreen: false,
                              enablePip: false,
                              enableOverflowMenu: false,
                              enablePlayPause: false,
                              enableProgressText: false,
                              controlsHideTime: Duration(microseconds: 300),
                            ));
                        BetterPlayerDataSource dataSource = BetterPlayerDataSource(
                          BetterPlayerDataSourceType.file,
                          video.path,
                        );
                        _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
                        _betterPlayerController.setupDataSource(dataSource);
                        if (!mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
                        await fileUploadingFunc(file: pickedImage[index], surveyUrlType: selectedUrlType[index], index: index);
                      }
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.video_library_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Video",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.tertiary,
                    thickness: 0.8,
                  ),
                  ListTile(
                    onTap: () async {
                      doc[index] = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'docx'],
                      );
                      if (doc[index] != null) {
                        setState(() {
                          file1 = doc[index]!.paths.map((path) => File(path!)).toList(); //file1 is a global variable which i created
                          pickedFile[index] = file1[0];
                          selectedUrlType[index] = "document";
                          Navigator.of(context).pop();
                        });
                        await fileUploadingFunc(file: pickedImage[index], surveyUrlType: selectedUrlType[index], index: index);
                      }
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.attach_file_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Document",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showSheet1({required int index, required bool listLength}) {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () async {
                      setState(() {
                        _answerTypeList[index] = "Single";
                      });
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    minLeadingWidth: width / 25,
                    leading: Icon(
                      Icons.check,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: Text(
                      "Single",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.tertiary,
                    thickness: 0.8,
                  ),
                  ListTile(
                    onTap: listLength
                        ? () async {
                            setState(() {
                              _answerTypeList[index] = "Multiple";
                            });
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                          }
                        : () {
                            Flushbar(
                              message: "Multiple option is only enabled when you add more than 2 options",
                              duration: const Duration(seconds: 2),
                            ).show(context);
                          },
                    minLeadingWidth: width / 25,
                    leading: Icon(
                      Icons.playlist_add_check_outlined,
                      size: 20,
                      color: listLength ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.tertiary,
                    ),
                    title: Text(
                      "Multiple",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: text.scale(14),
                          color: listLength ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showSheet2() {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () async {
                      setState(() {
                        optionalType = "optional";
                      });
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.question_mark_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Optional",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      setState(() {
                        optionalType = "mandatory";
                      });
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.star,
                      color: Colors.grey,
                      size: 20,
                    ),
                    title: Text(
                      "Mandatory",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
