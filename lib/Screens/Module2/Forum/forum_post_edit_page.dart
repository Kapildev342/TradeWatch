import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:river_player/river_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class ForumPostEditPage extends StatefulWidget {
  final String text;
  final String forumId;
  final String filterId;
  final List catIdList;

  const ForumPostEditPage({
    Key? key,
    required this.text,
    required this.filterId,
    required this.catIdList,
    required this.forumId,
  }) : super(key: key);

  @override
  State<ForumPostEditPage> createState() => _ForumPostEditPageState();
}

class _ForumPostEditPageState extends State<ForumPostEditPage> {
  File? pickedImage;
  File? pickedVideo;
  File? pickedFile;
  List<File> file1 = [];
  late BetterPlayerController _betterPlayerController;
  bool playVideo = false;
  bool releaseLoader = false;
  FilePickerResult? doc;
  String selectedUrlType = "";
  List countriesList = ["General", "India", "USA"];
  Map<String, dynamic> data = {};
  Map<String, dynamic> dataGeneral = {};
  Map<String, dynamic> dataUpdate = {};
  Map<String, dynamic> dataUpdateGeneral = {};
  String selectedCategory = "Select a Category";
  String selectedValue = "";
  String selectedValueCheck = "";
  String mainUserToken = "";
  List categoriesList = [
    "Stocks",
    "Crypto",
    "Commodity",
    "Forex",
  ];
  Function eq = const ListEquality().equals;
  List exchangeNameList = [];
  List exchangeCodeList = [];
  List exchangeIdList = [];
  List sendIndustriesList = [];
  List sendIndustriesListCheck = [];
  List sendIndustriesNameList = [];
  String _selectedExchange = "";
  String _selectSubCategory = "Select a SubCategory";
  String _selectIndex = "Select an Index";
  String selectedIdItem = "";
  String selectedIdItemCheck = "";
  String editExchange = "";
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
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tickerSearchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  final RefreshController _controller = RefreshController();
  bool selectAll = false;
  bool tickerSelectAll = false;
  bool validTitle = true;
  String urlReceived = "";
  bool firstEdit = false;
  String editedCategoryId = "";

  getEx({required StateSetter newSetState1}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
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
            if (selectedIdItem == responseData["response"][i]["_id"]) {
              int j = i + 1;
              _selectedExchange = j.toString();
            }
          }
        });
      }
    } else {}
  }

  getIndustries({required StateSetter newSetState}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
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
    var response = await dioMain.post(url, data: data, options: Options(headers: {'Authorization': mainUserToken}));
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) {
        newSetState(() {
          selectedCategory == "Crypto" ? industriesNameList.add("General") : debugPrint("nothing");
          selectedCategory == "Crypto" ? industriesIdList.add("General") : debugPrint("nothing");
          selectedCategory == "Crypto" ? indusBool.add(false) : debugPrint("nothing");
          for (int i = 0; i < responseData["response"].length; i++) {
            industriesNameList.add(responseData["response"][i]["name"]);
            industriesIdList.add(responseData["response"][i]["_id"]);
            if (sendIndustriesList.isNotEmpty) {
              if (sendIndustriesList[0] == industriesIdList[i + 1]) {
                _selectedExchange = (i + 1).toString();
                _selectSubCategory = industriesNameList[i + 1];
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

  validatePost(
      {required String title,
      required String description,
      required String type,
      required String exc,
      required List indus,
      required List tickers}) async {
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
    if (title == "" || type == "Select a Category" || exc == "" || indus.isEmpty || tickers.isEmpty) {
      if (title == "") {
        setState(() {
          releaseLoader = false;
        });
        Flushbar(
          message: "Title Should not be empty",
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
      } else if (validTitle == false) {
        setState(() {
          releaseLoader = false;
        });
        Flushbar(
          message: "Title should contains minimum an alphabet",
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
          } else if (exc == "General") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            mainUserToken = prefs.getString('newUserToken') ?? "";
            tickerSelectAll ? tickers.clear() : debugPrint('nothing');
            dataGeneral = {
              'forum_id': widget.forumId,
              "title": title,
              "description": description,
              "category": type,
              "url_type": selectedUrlType,
              "category_id": catId,
              "type_general": true,
              "company_name": "General",
              //"exchange":exc,
              "industries": [],
              "tickers": tickers,
              "allindustries": true,
              "alltickers": true,
              'url': urlReceived,
            };
            if (selectedUrlType != "") {
              var res1 = await functionsMain.sendForm(baseurl + versionForum + forumAdd, dataGeneral, {
                'file': selectedUrlType == "image"
                    ? pickedImage!
                    : selectedUrlType == "video"
                        ? pickedVideo!
                        : pickedFile!
              });
              if (res1.data["status"]) {
                setState(() {
                  releaseLoader = false;
                });
                /* Navigator.push(context,
                    MaterialPageRoute(builder:
                        (BuildContext context) {
                      return ForumPage(text: widget.text);
                    }));*/
                if (!mounted) {
                  return false;
                }
                Navigator.pop(context, true);
                Flushbar(
                  message: res1.data["message"],
                  duration: const Duration(seconds: 2),
                ).show(context);
              } else {
                setState(() {
                  releaseLoader = false;
                });
                if (!mounted) {
                  return false;
                }
                Flushbar(
                  message: res1.data["message"],
                  duration: const Duration(seconds: 2),
                ).show(context);
              }
            } else {
              var response = await dioMain.post(baseurl + versionForum + forumAdd,
                  data: dataGeneral,
                  options: Options(
                    headers: {'Authorization': mainUserToken},
                  ));
              var responseData = response.data;
              if (responseData["status"]) {
                setState(() {
                  releaseLoader = false;
                });
                /* Navigator.push(context,
                    MaterialPageRoute(builder:
                        (BuildContext context) {
                      return ForumPage(text: widget.text);
                    }));*/

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
            }
          } else if (_selectIndex == "General") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            mainUserToken = prefs.getString('newUserToken') ?? "";
            tickerSelectAll ? tickers.clear() : debugPrint('nothing');
            dataGeneral = {
              'forum_id': widget.forumId,
              "title": title,
              "description": description,
              "category": type,
              "url_type": selectedUrlType,
              "category_id": catId,
              "exchange": exc,
              "industries": [],
              "tickers": tickers,
              "allindustries": true,
              "alltickers": true,
              "company_name": "General",
              "type_general": false,
              'url': urlReceived,
            };
            if (selectedUrlType != "") {
              var res1 = await functionsMain.sendForm(baseurl + versionForum + forumAdd, dataGeneral, {
                'file': selectedUrlType == "image"
                    ? pickedImage!
                    : selectedUrlType == "video"
                        ? pickedVideo!
                        : pickedFile!
              });
              if (res1.data["status"]) {
                setState(() {
                  releaseLoader = false;
                });
                /*Navigator.push(context,
                    MaterialPageRoute(builder:
                        (BuildContext context) {
                      return ForumPage(text: widget.text);
                    }));*/
                if (!mounted) {
                  return;
                }
                Navigator.pop(context, true);
                Flushbar(
                  message: res1.data["message"],
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
                  message: res1.data["message"],
                  duration: const Duration(seconds: 2),
                ).show(context);
              }
            } else {
              var response = await dioMain.post(baseurl + versionForum + forumAdd,
                  data: dataGeneral,
                  options: Options(
                    headers: {'Authorization': mainUserToken},
                  ));
              var responseData = response.data;
              if (responseData["status"]) {
                setState(() {
                  releaseLoader = false;
                });
                /*  Navigator.push(context,
                    MaterialPageRoute(builder:
                        (BuildContext context) {
                      return ForumPage(text: widget.text);
                    }));*/
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
              indus: [],
              description: _descriptionController.text,
              exc: selectedIdItem,
              cid: catId,
              type: selectedCategory.toLowerCase(),
              tickers: sendTickersList,
            );
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
            mainUserToken = prefs.getString('newUserToken') ?? "";
            tickerSelectAll ? tickers.clear() : debugPrint('nothing');
            dataGeneral = {
              'forum_id': widget.forumId,
              "title": title,
              "description": description,
              "category": type,
              "url_type": selectedUrlType,
              "category_id": catId,
              "type_general": true,
              "company_name": "General",
              "industries": indus,
              "tickers": tickers,
              "alltickers": tickerSelectAll,
              'url': urlReceived,
            };
            if (selectedUrlType != "") {
              var res1 = await functionsMain.sendForm(baseurl + versionForum + forumAdd, dataGeneral, {
                'file': selectedUrlType == "image"
                    ? pickedImage!
                    : selectedUrlType == "video"
                        ? pickedVideo!
                        : pickedFile!
              });
              if (res1.data["status"]) {
                setState(() {
                  releaseLoader = false;
                });
                /*Navigator.push(context,
                    MaterialPageRoute(builder:
                        (BuildContext context) {
                      return ForumPage(text: widget.text);
                    }));*/
                if (!mounted) {
                  return;
                }
                Navigator.pop(context, true);
                Flushbar(
                  message: res1.data["message"],
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
                  message: res1.data["message"],
                  duration: const Duration(seconds: 2),
                ).show(context);
              }
            } else {
              var response = await dioMain.post(baseurl + versionForum + forumAdd,
                  data: dataGeneral,
                  options: Options(
                    headers: {'Authorization': mainUserToken},
                  ));
              var responseData = response.data;
              if (responseData["status"]) {
                setState(() {
                  releaseLoader = false;
                });
                /*Navigator.push(context,
                    MaterialPageRoute(builder:
                        (BuildContext context) {
                      return ForumPage(text: widget.text);
                    }));*/
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
              description: _descriptionController.text,
              exc: selectedIdItem,
              cid: catId,
              type: selectedCategory.toLowerCase(),
              tickers: sendTickersList,
            );
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
            mainUserToken = prefs.getString('newUserToken') ?? "";
            tickerSelectAll ? tickers.clear() : debugPrint('nothing');
            dataGeneral = {
              'forum_id': widget.forumId,
              "title": title,
              "description": description,
              "category": type,
              "url_type": selectedUrlType,
              "category_id": catId,
              "type_general": true,
              "company_name": "General",
              "country": exc,
              "tickers": tickers,
              "alltickers": tickerSelectAll,
              'url': urlReceived,
            };
            if (selectedUrlType != "") {
              var res1 = await functionsMain.sendForm(baseurl + versionForum + forumAdd, dataGeneral, {
                'file': selectedUrlType == "image"
                    ? pickedImage!
                    : selectedUrlType == "video"
                        ? pickedVideo!
                        : pickedFile!
              });
              if (res1.data["status"]) {
                setState(() {
                  releaseLoader = false;
                });
                /*Navigator.push(context,
                    MaterialPageRoute(builder:
                        (BuildContext context) {
                      return ForumPage(text: widget.text);
                    }));*/
                if (!mounted) {
                  return;
                }
                Navigator.pop(context, true);
                Flushbar(
                  message: res1.data["message"],
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
                  message: res1.data["message"],
                  duration: const Duration(seconds: 2),
                ).show(context);
              }
            } else {
              var response = await dioMain.post(baseurl + versionForum + forumAdd,
                  data: dataGeneral,
                  options: Options(
                    headers: {'Authorization': mainUserToken},
                  ));
              var responseData = response.data;
              if (responseData["status"]) {
                setState(() {
                  releaseLoader = false;
                });
                /* Navigator.push(context,
                    MaterialPageRoute(builder:
                        (BuildContext context) {
                      return ForumPage(text: widget.text);
                    }));*/
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
              description: _descriptionController.text,
              exc: selectedIdItem,
              cid: catId,
              type: selectedCategory.toLowerCase(),
              tickers: sendTickersList,
            );
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
              description: _descriptionController.text,
              exc: selectedIdItem,
              cid: catId,
              type: selectedCategory.toLowerCase(),
              tickers: sendTickersList,
            );
          }
        }
      }
    } else if (validTitle == false) {
      setState(() {
        releaseLoader = false;
      });
      Flushbar(
        message: "The title can't be only integers, please try including at least one alphabet.",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      postingForum(
        title: _titleController.text,
        indus: sendIndustriesList,
        description: _descriptionController.text,
        exc: selectedIdItem,
        cid: catId,
        type: selectedCategory.toLowerCase(),
        tickers: sendTickersList,
      );
    }
  }

  postingForum({
    required String title,
    required String description,
    required String type,
    required String cid,
    required String exc,
    required List indus,
    required List tickers,
  }) async {
    if (type == "stocks") {
      tickerSelectAll ? tickers.clear() : debugPrint('nothing');
      data = {
        'forum_id': widget.forumId,
        "title": title,
        "description": description,
        "category": type,
        "url_type": selectedUrlType,
        "category_id": cid,
        "exchange": exc,
        "industries": indus,
        "tickers": tickers,
        "allindustries": true,
        "alltickers": tickerSelectAll,
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex,
        "type_general": false,
        'url': urlReceived,
      };
    } else if (type == "crypto") {
      tickerSelectAll ? tickers.clear() : debugPrint('nothing');
      data = {
        'forum_id': widget.forumId,
        "title": title,
        "description": description,
        "category": type,
        "url_type": selectedUrlType,
        "category_id": cid,
        "industries": indus,
        "tickers": tickers,
        "alltickers": tickerSelectAll,
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex,
        "type_general": false,
        'url': urlReceived,
      };
    } else if (type == "commodity") {
      tickerSelectAll ? tickers.clear() : debugPrint('nothing');
      data = {
        'forum_id': widget.forumId,
        "title": title,
        "description": description,
        "category": type,
        "url_type": selectedUrlType,
        "category_id": cid,
        "country": exc,
        "tickers": tickers,
        "alltickers": tickerSelectAll,
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex,
        "type_general": false,
        'url': urlReceived,
      };
    } else {
      tickerSelectAll ? tickers.clear() : debugPrint('nothing');
      data = {
        'forum_id': widget.forumId,
        "title": title,
        "description": description,
        "category": type,
        "url_type": selectedUrlType,
        "category_id": cid,
        "tickers": tickers,
        "alltickers": tickerSelectAll,
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex,
        "type_general": false,
        'url': urlReceived,
      };
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionForum + forumAdd;
    if (selectedUrlType != "") {
      var res1 = await functionsMain.sendForm(url, data, {
        'file': selectedUrlType == "image"
            ? pickedImage!
            : selectedUrlType == "video"
                ? pickedVideo!
                : pickedFile!
      });
      if (res1.data["status"]) {
        setState(() {
          releaseLoader = false;
        });
        if (!mounted) {
          return;
        }
        Navigator.pop(context, true);
        /*  Navigator.push(context,
            MaterialPageRoute(builder:
                (BuildContext context) {
              return ForumPage(text: widget.text);
            }));*/
        Flushbar(
          message: res1.data["message"],
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
          message: res1.data["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    } else {
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
        /*Navigator.push(context,
            MaterialPageRoute(builder:
                (BuildContext context) {
              return ForumPage(text: widget.text);
            }));*/
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
    }
  }

  @override
  void initState() {
    getAllDataMain(name: 'Forum_Creation_Edit_Page');
    getAllData();
    super.initState();
  }

  getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionForum + editForum;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {"forum_id": widget.forumId});
    var responseData = response.data;
    if (responseData["status"]) {
      if (mounted) _titleController.text = responseData['response']['title'];
      if (responseData['response'].containsKey("description")) {
        _descriptionController.text = responseData['response']['description'];
      } else {
        _descriptionController.text = "";
      }
      if (responseData['response']['url_type'] == null) {
        urlReceived = "";
        pickedImage = null;
        pickedVideo = null;
        doc = null;
        pickedFile = null;
      } else {
        urlReceived = responseData['response']['url'];
        if (responseData['response']['url_type'] == 'image') {
          pickedImage = File(responseData['response']['url']);
          pickedVideo = null;
          doc = null;
          pickedFile = null;
        } else if (responseData['response']['url_type'] == 'video') {
          pickedImage = null;
          pickedVideo = File(responseData['response']['url']);
          doc = null;
          pickedFile = null;
        } else if (responseData['response']['url_type'] == 'document') {
          pickedImage = null;
          pickedVideo = null;
          pickedFile = File(responseData['response']['url']);
        }
      }
      if (responseData['response']['category'] == 'stocks') {
        selectedValue = "0";
        selectedValueCheck = "0";
        selectedCategory = "Stocks";
        editedCategoryId = mainCatIdList[0];
        if (responseData['response']['type_general'] == false) {
          selectedIdItem = responseData['response']['exchange'];
          editExchange = responseData['response']['exchange'];
          for (int i = 0; i < finalExchangeIdList.length; i++) {
            if (responseData['response']['exchange'] == finalExchangeIdList[i]) {
              if (i == 0) {
                _selectSubCategory = "USA stocks";
              } else if (i == 1) {
                _selectSubCategory = "NSE stocks";
              } else if (i == 2) {
                _selectSubCategory = "BSE stocks";
              } else {}
            }
          }
          if (responseData['response']['alltickers'] == true) {
            tickerSelectAll = true;
            _selectIndex = "General";
            sendTickersList.addAll(tickersCatIdList);
          } else {
            tickerSelectAll = false;
            sendTickersList = responseData["response"]["tickers"].toList();
            if (sendTickersList.length > 1) {
              _selectIndex = "Multiple";
            } else {
              setState(() {
                _selectIndex = responseData['response']['company_name'];
              });
            }
          }
        } else {
          _selectedExchange = '0';
          selectedIdItem = "General";
          _selectSubCategory = responseData['response']['company_name'];
        }
        await getEx(newSetState1: setState);
        if (responseData['response']['type_general'] == false) {
          await getTickersFunc1();
          await getTickersFunc(tickerSetState: setState);
        }
      } else if (responseData['response']['category'] == 'crypto') {
        selectedValue = "1";
        selectedCategory = "Crypto";
        editedCategoryId = mainCatIdList[1];
        if (responseData['response']['type_general'] == false) {
          sendIndustriesList.add(responseData['response']['industries'][0]);
          sendIndustriesListCheck.add(responseData['response']['industries'][0]);
          if (responseData['response']['alltickers'] == true) {
            tickerSelectAll = true;
            _selectIndex = "General";
            sendTickersList.addAll(tickersCatIdList);
          } else {
            tickerSelectAll = false;
            sendTickersList = responseData["response"]["tickers"].toList();
            if (sendTickersList.length > 1) {
              _selectIndex = "Multiple";
            } else {
              setState(() {
                _selectIndex = responseData['response']['company_name'];
              });
            }
          }
        } else {
          _selectedExchange = '0';
          _selectSubCategory = responseData['response']['company_name'];
        }
        await getIndustries(newSetState: setState);
        if (responseData['response']['type_general'] == false) {
          await getTickersFunc1();
          await getTickersFunc(tickerSetState: setState);
        }
      } else if (responseData['response']['category'] == 'commodity') {
        selectedValue = "2";
        selectedCategory = "Commodity";
        editedCategoryId = mainCatIdList[2];
        if (responseData['response']['type_general'] == false) {
          selectedIdItem = responseData['response']['country'];
          _selectSubCategory = responseData['response']['country'];
          selectedIdItemCheck = responseData['response']['country'];
          for (int i = 0; i < countriesList.length; i++) {
            if (selectedIdItem == countriesList[i]) {
              _selectedExchange = i.toString();
            }
          }
          if (responseData['response']['alltickers'] == true) {
            tickerSelectAll = true;
            _selectIndex = "General";
            sendTickersList.addAll(tickersCatIdList);
          } else {
            tickerSelectAll = false;
            sendTickersList = responseData["response"]["tickers"];
            if (sendTickersList.length > 1) {
              _selectIndex = "Multiple";
            } else {
              setState(() {
                _selectIndex = responseData['response']['company_name'];
              });
            }
          }
        } else {
          _selectedExchange = '0';
          _selectSubCategory = responseData['response']['company_name'];
        }
        await getTickersFunc1();
        await getTickersFunc(tickerSetState: setState);
      } else {
        selectedValue = "3";
        selectedCategory = "Forex";
        editedCategoryId = mainCatIdList[3];
        if (responseData['response']['alltickers'] == true) {
          tickerSelectAll = true;
          _selectIndex = "General";
          sendTickersList.addAll(tickersCatIdList);
        } else {
          tickerSelectAll = false;
          sendTickersList = responseData["response"]["tickers"];
          if (sendTickersList.length > 1) {
            _selectIndex = "Multiple";
          } else {
            setState(() {
              _selectIndex = responseData['response']['company_name'];
            });
          }
        }
        await getTickersFunc1();
        await getTickersFunc(tickerSetState: setState);
      }
    }
    setState(() {});
  }

  getTickersFunc1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    Map<String, dynamic> newMap = {};
    if (selectedCategory == "Stocks") {
      newMap = {
        'category': selectedCategory.toLowerCase(),
        'search': _tickerSearchController.text == "" ? "" : _tickerSearchController.text,
        'skip': 0,
        'exchange': selectedIdItem,
        'industries': sendIndustriesList,
        'ticker_exist': false,
        'tickers': sendTickersList
      };
    } else if (selectedCategory == "Crypto") {
      newMap = {
        'category': selectedCategory.toLowerCase(),
        'search': _tickerSearchController.text == "" ? "" : _tickerSearchController.text,
        'skip': 0,
        'industries': sendIndustriesList,
        'ticker_exist': false,
        'tickers': sendTickersList
      };
    } else if (selectedCategory == "Commodity") {
      newMap = {
        'category': selectedCategory.toLowerCase(),
        'search': _tickerSearchController.text == "" ? "" : _tickerSearchController.text,
        'skip': 0,
        'country': selectedIdItem,
        'ticker_exist': false,
        'tickers': sendTickersList
      };
    } else {
      newMap = {
        'category': selectedCategory.toLowerCase(),
        'search': _tickerSearchController.text == "" ? "" : _tickerSearchController.text,
        'skip': 0,
        'ticker_exist': false,
        'tickers': sendTickersList
      };
    }
    var url = baseurl + versionLocker + getTickers;
    var response = await dioMain.post(url,
        data: newMap,
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    if (selectedCategory == "Stocks") {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': _tickerSearchController.text == "" ? "" : _tickerSearchController.text,
        'skip': 0,
        'exchange': selectedIdItem,
        'industries': sendIndustriesList,
        'ticker_exist': false,
        'tickers': sendTickersList
      };
    } else if (selectedCategory == "Crypto") {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': _tickerSearchController.text == "" ? "" : _tickerSearchController.text,
        'skip': 0,
        'industries': sendIndustriesList,
        'ticker_exist': false,
        'tickers': sendTickersList
      };
    } else if (selectedCategory == "Commodity") {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': _tickerSearchController.text == "" ? "" : _tickerSearchController.text,
        'skip': 0,
        'country': selectedIdItem,
        'ticker_exist': false,
        'tickers': sendTickersList
      };
    } else {
      dataUpdate = {
        'category': selectedCategory.toLowerCase(),
        'search': _tickerSearchController.text == "" ? "" : _tickerSearchController.text,
        'skip': 0,
        'ticker_exist': false,
        'tickers': sendTickersList
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
    tickerSetState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      // color: const Color(0XFFFFFFFF),
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
                        if (!mounted) {
                          return;
                        }
                        Navigator.pop(context);
                      },
                      child: releaseLoader
                          ? const SizedBox()
                          : Center(
                              child: Text("Cancel",
                                  style: TextStyle(
                                      fontSize: text.scale(16), color: const Color(0XFFB0B0B0), fontWeight: FontWeight.w500, fontFamily: "Poppins")),
                            ),
                    ),
                    Center(
                      child: Text("Post question", style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w700, fontFamily: "Poppins")),
                    ),
                    releaseLoader
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Color(0XFF0EA102),
                              strokeWidth: 2.0,
                            ))
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                releaseLoader = true;
                              });
                              validatePost(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                type: selectedCategory.toLowerCase(),
                                exc: selectedIdItem,
                                indus: sendIndustriesList,
                                tickers: sendTickersList,
                              );
                            },
                            child: Center(
                              child: Text("Release",
                                  style: TextStyle(
                                      fontSize: text.scale(16), color: const Color(0XFF0EA102), fontWeight: FontWeight.w600, fontFamily: "Poppins")),
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
                        contentPadding: const EdgeInsets.only(left: 15),
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
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                        hintText: 'Enter a title for your post here....',
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
                    height: height / 54.13,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                    padding: EdgeInsets.symmetric(horizontal: width / 18.75, vertical: height / 54.13),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xffD8D8D8).withOpacity(0.5))),
                    height: height / 4.29,
                    child: TextFormField(
                      style: TextStyle(color: const Color(0XFFB0B0B0), fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                      controller: _descriptionController,
                      keyboardType: TextInputType.name,
                      maxLines: null,
                      decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "Enter a description...",
                          hintStyle: TextStyle(
                              color: const Color(0XFFB0B0B0), fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400)),
                    ),
                  ),
                  SizedBox(
                    height: height / 50.75,
                  ),
                  (pickedImage == null && pickedVideo == null && pickedFile == null)
                      ? GestureDetector(
                          onTap: () async {
                            showSheet();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                            child: Image.asset(
                              "assets/settings/add_file.png",
                              height: height / 8.82,
                              width: width / 4.07,
                            ),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                          child: pickedImage == null && pickedVideo == null && doc == null
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    pickedImage == null
                                        ? const SizedBox()
                                        : Row(
                                            children: [
                                              Text(
                                                pickedImage!.path.split('/').last.toString(),
                                                style: const TextStyle(fontSize: 8),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    urlReceived = "";
                                                    pickedImage = null;
                                                    pickedVideo = null;
                                                    doc = null;
                                                  });
                                                },
                                                child: Container(
                                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Theme.of(context).colorScheme.background,
                                                        size: 12,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                    pickedVideo == null
                                        ? const SizedBox()
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                pickedVideo!.path.split('/').last.toString(),
                                                style: const TextStyle(fontSize: 8),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    urlReceived = "";
                                                    pickedImage = null;
                                                    pickedVideo = null;
                                                    doc = null;
                                                  });
                                                },
                                                child: Container(
                                                    decoration: const BoxDecoration(shape: BoxShape.circle),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Theme.of(context).colorScheme.background,
                                                        size: 12,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                    doc == null
                                        ? const SizedBox()
                                        : firstEdit
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    doc!.files[0].path!.split('/').last.toString(),
                                                    style: const TextStyle(fontSize: 8),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        urlReceived = "";
                                                        pickedImage = null;
                                                        pickedVideo = null;
                                                        doc = null;
                                                      });
                                                    },
                                                    child: Container(
                                                        decoration: const BoxDecoration(shape: BoxShape.circle),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Theme.of(context).colorScheme.background,
                                                            size: 12,
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    pickedFile!.path.split('/').last.toString(),
                                                    style: const TextStyle(fontSize: 8),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        urlReceived = "";
                                                        pickedImage = null;
                                                        pickedVideo = null;
                                                        doc = null;
                                                        firstEdit = true;
                                                      });
                                                    },
                                                    child: Container(
                                                        decoration: const BoxDecoration(shape: BoxShape.circle),
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Theme.of(context).colorScheme.background,
                                                            size: 12,
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              )
                                  ],
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
                                                          setState(() {
                                                            selectedCategory = categoriesList[int.parse(selectedValue)];
                                                            if (selectedValueCheck != selectedValue) {
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
                                                              isCheckedNew.clear();
                                                            }
                                                          });
                                                          selectedValue == "0"
                                                              ? await getEx(newSetState1: modelSetState)
                                                              : selectedValue == "1"
                                                                  ? await getIndustries(newSetState: setState)
                                                                  : selectedValue == "3"
                                                                      ? await getTickersFunc(tickerSetState: setState)
                                                                      : debugPrint("nothing");
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
                                                                          if (editExchange != selectedIdItem) {
                                                                            sendTickersList.clear();
                                                                            sendTickersNameList.clear();
                                                                            tickersCatIdList.clear();
                                                                            tickersCodeList.clear();
                                                                            tickersNameList.clear();
                                                                            tickersLogoList.clear();
                                                                            isCheckedNew.clear();
                                                                            selectAll = false;
                                                                            tickerSelectAll = false;
                                                                            _selectIndex = 'Select an Ticker';
                                                                          } else {}
                                                                        });
                                                                        selectedIdItem == "General"
                                                                            ? debugPrint("nothing")
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
                                                                        tickersNameList.clear();
                                                                        tickersLogoList.clear();
                                                                        tickersCatIdList.clear();
                                                                        tickersCodeList.clear();
                                                                        isCheckedNew.clear();
                                                                        await getTickersFunc(tickerSetState: modelSetState);
                                                                      } else if (value.isEmpty) {
                                                                        tickersNameList.clear();
                                                                        tickersLogoList.clear();
                                                                        tickersCatIdList.clear();
                                                                        tickersCodeList.clear();
                                                                        isCheckedNew.clear();
                                                                        await getTickersFunc(tickerSetState: modelSetState);
                                                                      } else {
                                                                        tickersNameList.clear();
                                                                        tickersLogoList.clear();
                                                                        tickersCatIdList.clear();
                                                                        tickersCodeList.clear();
                                                                        isCheckedNew.clear();
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
                                                                      hintStyle: Theme.of(context).textTheme.bodyMedium,
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
                                                                                  // getTickersFunc(tickerSetState: modelSetState);
                                                                                });
                                                                              } else {
                                                                                sendTickersList.clear();
                                                                                tickersNameList.clear();
                                                                                tickersLogoList.clear();
                                                                                tickersCatIdList.clear();
                                                                                tickersCodeList.clear();
                                                                                isCheckedNew.clear();
                                                                                modelSetState(() {
                                                                                  tickerSelectAll = value;
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
                                                                                          height: height / 33.83,
                                                                                          width: width / 15.625,
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
                                                                                                fontSize: 12, fontWeight: FontWeight.w700),
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
                                                                                                fontSize: 12, fontWeight: FontWeight.w700),
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
                                                                                    _selectIndex = 'Select an Ticker';
                                                                                  }
                                                                                });
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
                                                                                tickersNameList.clear();
                                                                                tickersLogoList.clear();
                                                                                tickersCatIdList.clear();
                                                                                tickersCodeList.clear();
                                                                                isCheckedNew.clear();
                                                                                await getTickersFunc(tickerSetState: modelSetState);
                                                                              } else if (value.isEmpty) {
                                                                                tickersNameList.clear();
                                                                                tickersLogoList.clear();
                                                                                tickersCatIdList.clear();
                                                                                tickersCodeList.clear();
                                                                                isCheckedNew.clear();
                                                                                await getTickersFunc(tickerSetState: modelSetState);
                                                                              } else {
                                                                                tickersNameList.clear();
                                                                                tickersLogoList.clear();
                                                                                tickersCatIdList.clear();
                                                                                tickersCodeList.clear();
                                                                                isCheckedNew.clear();
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
                                                                              hintStyle: Theme.of(context).textTheme.bodyMedium,
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
                                                                                    checkboxShape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                    ),
                                                                                    onChanged: (bool? value) {
                                                                                      modelSetState(() {
                                                                                        if (value!) {
                                                                                          sendTickersList.clear();
                                                                                          tickersNameList.clear();
                                                                                          tickersLogoList.clear();
                                                                                          tickersCatIdList.clear();
                                                                                          tickersCodeList.clear();
                                                                                          isCheckedNew.clear();
                                                                                          modelSetState(() {
                                                                                            tickerSelectAll = value;
                                                                                            sendTickersList.addAll(tickersCatIdList);
                                                                                            _selectIndex = "General";
                                                                                            getTickersFunc(tickerSetState: modelSetState);
                                                                                          });
                                                                                        } else {
                                                                                          modelSetState(() {
                                                                                            tickerSelectAll = value;
                                                                                            sendTickersList.clear();
                                                                                            tickersNameList.clear();
                                                                                            tickersLogoList.clear();
                                                                                            tickersCatIdList.clear();
                                                                                            tickersCodeList.clear();
                                                                                            isCheckedNew.clear();
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
                                                                                                    fontSize: 12, fontWeight: FontWeight.w700),
                                                                                              ),
                                                                                              subtitle: Text(
                                                                                                tickersCodeList[index],
                                                                                                style: const TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize: 12.0,
                                                                                                    color: Color(0XFFA5A5A5)),
                                                                                              ),
                                                                                              secondary: SizedBox(
                                                                                                  height: height / 33.83,
                                                                                                  width: width / 15.625,
                                                                                                  child: tickersLogoList[index].contains("svg")
                                                                                                      ? SvgPicture.network(tickersLogoList[index],
                                                                                                          fit: BoxFit.fill)
                                                                                                      : Image.network(tickersLogoList[index],
                                                                                                          fit: BoxFit.fill)),
                                                                                              autofocus: false,
                                                                                              activeColor: Colors.green,
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
                                                                                                fontSize: 12, fontWeight: FontWeight.w700),
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
                                                                                                fontSize: 12, fontWeight: FontWeight.w700),
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
                                                                                tickersNameList.clear();
                                                                                tickersLogoList.clear();
                                                                                tickersCatIdList.clear();
                                                                                tickersCodeList.clear();
                                                                                isCheckedNew.clear();
                                                                                await getTickersFunc(tickerSetState: modelSetState);
                                                                              } else if (value.isEmpty) {
                                                                                tickersNameList.clear();
                                                                                tickersLogoList.clear();
                                                                                tickersCatIdList.clear();
                                                                                tickersCodeList.clear();
                                                                                isCheckedNew.clear();
                                                                                await getTickersFunc(tickerSetState: modelSetState);
                                                                              } else {
                                                                                tickersNameList.clear();
                                                                                tickersLogoList.clear();
                                                                                tickersCatIdList.clear();
                                                                                tickersCodeList.clear();
                                                                                isCheckedNew.clear();
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
                                                                              hintStyle: Theme.of(context).textTheme.bodyMedium,
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
                                                                                    checkboxShape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                    ),
                                                                                    onChanged: (bool? value) {
                                                                                      modelSetState(() {
                                                                                        if (value!) {
                                                                                          sendTickersList.clear();
                                                                                          tickersNameList.clear();
                                                                                          tickersLogoList.clear();
                                                                                          tickersCatIdList.clear();
                                                                                          tickersCodeList.clear();
                                                                                          isCheckedNew.clear();
                                                                                          modelSetState(() {
                                                                                            tickerSelectAll = value;
                                                                                            sendTickersList.addAll(tickersCatIdList);
                                                                                            _selectIndex = "General";
                                                                                            getTickersFunc(tickerSetState: modelSetState);
                                                                                          });
                                                                                        } else {
                                                                                          modelSetState(() {
                                                                                            tickerSelectAll = value;
                                                                                            sendTickersList.clear();
                                                                                            tickersNameList.clear();
                                                                                            tickersLogoList.clear();
                                                                                            tickersCatIdList.clear();
                                                                                            tickersCodeList.clear();
                                                                                            isCheckedNew.clear();
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
                                                                                                    fontSize: 12, fontWeight: FontWeight.w700),
                                                                                              ),
                                                                                              subtitle: Text(
                                                                                                tickersCodeList[index],
                                                                                                style: const TextStyle(
                                                                                                    fontWeight: FontWeight.w500,
                                                                                                    fontSize: 12.0,
                                                                                                    color: Color(0XFFA5A5A5)),
                                                                                              ),
                                                                                              secondary: SizedBox(
                                                                                                  height: height / 33.83,
                                                                                                  width: width / 15.625,
                                                                                                  child: tickersLogoList[index].contains("svg")
                                                                                                      ? SvgPicture.network(tickersLogoList[index],
                                                                                                          fit: BoxFit.fill)
                                                                                                      : Image.network(tickersLogoList[index],
                                                                                                          fit: BoxFit.fill)),
                                                                                              autofocus: false,
                                                                                              activeColor: Colors.green,
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
                                                                      tickersNameList.clear();
                                                                      tickersLogoList.clear();
                                                                      tickersCatIdList.clear();
                                                                      tickersCodeList.clear();
                                                                      isCheckedNew.clear();
                                                                      await getTickersFunc(tickerSetState: modelSetState);
                                                                    } else if (value.isEmpty) {
                                                                      tickersNameList.clear();
                                                                      tickersLogoList.clear();
                                                                      tickersCatIdList.clear();
                                                                      tickersCodeList.clear();
                                                                      isCheckedNew.clear();
                                                                      await getTickersFunc(tickerSetState: modelSetState);
                                                                    } else {
                                                                      tickersNameList.clear();
                                                                      tickersLogoList.clear();
                                                                      tickersCatIdList.clear();
                                                                      tickersCodeList.clear();
                                                                      isCheckedNew.clear();
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
                                                                      child:
                                                                          SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
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
                                                                    hintStyle: Theme.of(context).textTheme.bodyMedium,
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
                                                                          checkboxShape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                          ),
                                                                          onChanged: (bool? value) {
                                                                            modelSetState(() {
                                                                              if (value!) {
                                                                                sendTickersList.clear();
                                                                                tickersNameList.clear();
                                                                                tickersLogoList.clear();
                                                                                tickersCatIdList.clear();
                                                                                tickersCodeList.clear();
                                                                                isCheckedNew.clear();
                                                                                modelSetState(() {
                                                                                  tickerSelectAll = value;
                                                                                  sendTickersList.addAll(tickersCatIdList);
                                                                                  _selectIndex = "General";
                                                                                  getTickersFunc(tickerSetState: modelSetState);
                                                                                });
                                                                              } else {
                                                                                modelSetState(() {
                                                                                  tickerSelectAll = value;
                                                                                  sendTickersList.clear();
                                                                                  tickersNameList.clear();
                                                                                  tickersLogoList.clear();
                                                                                  tickersCatIdList.clear();
                                                                                  tickersCodeList.clear();
                                                                                  isCheckedNew.clear();
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
                                                                                      style:
                                                                                          const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                                                                    ),
                                                                                    subtitle: Text(
                                                                                      tickersCodeList[index],
                                                                                      style: const TextStyle(
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: 12.0,
                                                                                          color: Color(0XFFA5A5A5)),
                                                                                    ),
                                                                                    secondary: SizedBox(
                                                                                        height: height / 33.83,
                                                                                        width: width / 15.625,
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
                                                                                if (tickerSelectAll) {
                                                                                  _selectIndex = "General";
                                                                                } else {}
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
    );
  }

  showSheet() {
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
                          pickedImage = File(image.path);
                          selectedUrlType = "image";
                          pickedVideo = null;
                        });
                        if (!mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
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
                          pickedVideo = File(video.path);
                          pickedImage = null;
                          selectedUrlType = "video";
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
                      doc = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'docx'],
                      );
                      if (doc != null) {
                        setState(() {
                          file1 = doc!.paths.map((path) => File(path!)).toList(); //file1 is a global variable which i created
                          pickedFile = file1[0];
                          selectedUrlType = "document";
                          Navigator.of(context).pop();
                        });
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
}
