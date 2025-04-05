/*
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:river_player/river_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Edited_Packages/TutorialCoachMark/tutorial_coach_mark.dart';
import 'package:tradewatchfinal/Edited_Packages/editor/html_editor.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module3/video_player_page.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_widgets.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_widgets.dart';

class BytesPostPage extends StatefulWidget {
  const BytesPostPage({Key? key}) : super(key: key);

  @override
  State<BytesPostPage> createState() => _BytesPostPageState();
}

class _BytesPostPageState extends State<BytesPostPage> {
  File? pickedImage;
  File? pickedVideo;
  File? pickedFile;
  List<File> file1 = [];
  List<Map<String, dynamic>> fileList = [];
  late BetterPlayerController _betterPlayerController;
  bool playVideo = false;
  bool releaseLoader = false;
  bool previewLoader = false;
  FilePickerResult? doc;
  String selectedUrlType = "";
  List countriesList = ["General", "India", "USA"];
  Map<String, dynamic> data = {};
  Map<String, dynamic> dataGeneral = {};
  Map<String, dynamic> dataUpdate = {};
  Map<String, dynamic> dataUpdateGeneral = {};
  String selectedCategory = "Select a Category";
  String selectedValue = "";
  String mainUserToken = "";
  List categoriesList = [
    "General",
    "Stocks",
    "Crypto",
    "Commodity",
    "Forex",
  ];
  List<GlobalKey> keyList = List.generate(5, (index) => GlobalKey());
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
  FocusNode titleFocus = FocusNode();
  final TextEditingController _tickerSearchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final RefreshController _refreshController = RefreshController();
  final RefreshController _controller = RefreshController();
  final HtmlEditorController htmlController = HtmlEditorController();
  bool selectAll = false;
  bool tickerSelectAll = false;
  bool validTitle = true;
  bool checkBoxValue = false;
  String inputString = "";
  List<String> addFileList = [];

  CustomRenderMatcher imageTagMatcher() => (context) {
        return context.tree.element?.localName == 'img';
      };

  CustomRenderMatcher videoTagMatcher() => (context) {
        return context.tree.element?.localName == 'video';
      };

  late TutorialCoachMark tutorialCoachMark;
  GlobalKey dummyKey = GlobalKey();
  GlobalKey keyButton = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();
  GlobalKey keyButton6 = GlobalKey();
  GlobalKey keyButton7 = GlobalKey();
  GlobalKey keyButton8 = GlobalKey();
  GlobalKey keyButton9 = GlobalKey();

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
          selectedCategory == "Crypto" ? industriesNameList.add("General") : debugPrint("nothing");
          selectedCategory == "Crypto" ? industriesIdList.add("General") : debugPrint("nothing");
          selectedCategory == "Crypto" ? indusBool.add(false) : debugPrint("nothing");
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
    required String description,
    required String type,
    required String exc,
    required List indus,
    required List tickers,
    required List<Map<String, dynamic>> files,
  }) async {
    String catId = "";
    if (selectedCategory.toLowerCase() == "general") {
      setState(() {
        catId = "";
      });
    } else if (selectedCategory.toLowerCase() == "stocks") {
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
    if (type == "Select a Category" || exc == "" || indus.isEmpty || tickers.isEmpty) {
      if (type == "select a category") {
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
          message: "The content playground should contains minimum an alphabet",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (title == "" && files.isEmpty) {
          setState(() {
            releaseLoader = false;
          });
          Flushbar(
            message: "The content playground can't be empty.",
            duration: const Duration(seconds: 2),
          ).show(context);
        } else if (type == "general") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          mainUserToken = prefs.getString('newUserToken') ?? "";
          dataGeneral = {
            "title": title,
            "content": description,
            "billboard_type": "byte",
            "type": type,
            "category": type,
            "category_id": catId,
            "type_general": true,
            "files": files,
            "public_view": checkBoxValue ? "private" : "public",
            "company_name": "General"
          };
          var url = baseurl + versionBillBoard + billBoardAdd;
          var response = await dioMain.post(url,
              data: dataGeneral,
              options: Options(
                headers: {'Authorization': mainUserToken},
              ));
          var responseData = response.data;
          if (responseData["status"]) {
            setState(() {
              releaseLoader = false;
            });
            mainVariables.activeTypeMain.value = "trending";
            mainVariables.isFirstTime.value = false;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
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
        } else if (type == "stocks") {
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
            dataGeneral = {
              "title": title,
              "content": description,
              "billboard_type": "byte",
              "type": type,
              "category": type,
              "category_id": catId,
              "type_general": true,
              "files": files,
              "public_view": checkBoxValue ? "private" : "public",
              "company_name": "General"
            };
            var url = baseurl + versionBillBoard + billBoardAdd;
            var response = await dioMain.post(url,
                data: dataGeneral,
                options: Options(
                  headers: {'Authorization': mainUserToken},
                ));
            var responseData = response.data;
            if (responseData["status"]) {
              setState(() {
                releaseLoader = false;
              });
              mainVariables.activeTypeMain.value = "trending";
              mainVariables.isFirstTime.value = false;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
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
            mainUserToken = prefs.getString('newUserToken') ?? "";
            dataGeneral = {
              "title": title,
              "content": description,
              "billboard_type": 'byte',
              "type": type,
              "category": type,
              "category_id": catId,
              "exchange": exc,
              "industries": [],
              "tickers": tickers,
              "allindustries": true,
              "alltickers": true,
              "files": files,
              "public_view": checkBoxValue ? "private" : "public",
              "company_name": "General"
            };
            var url = baseurl + versionBillBoard + billBoardAdd;
            var response = await dioMain.post(url,
                data: dataGeneral,
                options: Options(
                  headers: {'Authorization': mainUserToken},
                ));
            var responseData = response.data;
            if (responseData["status"]) {
              setState(() {
                releaseLoader = false;
              });
              mainVariables.activeTypeMain.value = "trending";
              mainVariables.isFirstTime.value = false;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
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
            postingBlog(
                title: mainVariables.messageControllerMain.value.text,
                indus: [],
                description: description,
                exc: selectedIdItem,
                cid: catId,
                type: selectedCategory.toLowerCase(),
                tickers: sendTickersList,
                files: files);
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
            dataGeneral = {
              "title": title,
              "content": description,
              "billboard_type": "byte",
              "type": type,
              "category": type,
              "category_id": catId,
              "type_general": true,
              "files": files,
              "public_view": checkBoxValue ? "private" : "public",
              "company_name": "General"
            };
            var url = baseurl + versionBillBoard + billBoardAdd;
            var response = await dioMain.post(url,
                data: dataGeneral,
                options: Options(
                  headers: {'Authorization': mainUserToken},
                ));
            var responseData = response.data;
            if (responseData["status"]) {
              setState(() {
                releaseLoader = false;
              });
              mainVariables.activeTypeMain.value = "trending";
              mainVariables.isFirstTime.value = false;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
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
            postingBlog(
                title: mainVariables.messageControllerMain.value.text,
                indus: sendIndustriesList,
                description: description,
                exc: selectedIdItem,
                cid: catId,
                type: selectedCategory.toLowerCase(),
                tickers: sendTickersList,
                files: files);
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
            dataGeneral = {
              "title": title,
              "content": description,
              "billboard_type": 'byte',
              "type": type,
              "category": type,
              "category_id": catId,
              "type_general": true,
              "files": files,
              "public_view": checkBoxValue ? "private" : "public",
              "company_name": "General"
            };
            var url = baseurl + versionBillBoard + billBoardAdd;
            var response = await dioMain.post(url,
                data: dataGeneral,
                options: Options(
                  headers: {'Authorization': mainUserToken},
                ));
            var responseData = response.data;
            if (responseData["status"]) {
              setState(() {
                releaseLoader = false;
              });
              mainVariables.activeTypeMain.value = "trending";
              mainVariables.isFirstTime.value = false;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
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
            postingBlog(
                title: mainVariables.messageControllerMain.value.text,
                indus: sendIndustriesList,
                description: description,
                exc: selectedIdItem,
                cid: catId,
                type: selectedCategory.toLowerCase(),
                tickers: sendTickersList,
                files: files);
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
            postingBlog(
                title: mainVariables.messageControllerMain.value.text,
                indus: sendIndustriesList,
                description: description,
                exc: selectedIdItem,
                cid: catId,
                type: selectedCategory.toLowerCase(),
                tickers: sendTickersList,
                files: files);
          }
        }
      }
    } else if (validTitle == false) {
      setState(() {
        releaseLoader = false;
      });
      Flushbar(
        message: "The content playground can't be only integers, please try including at least one alphabet.",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      postingBlog(
          title: mainVariables.messageControllerMain.value.text,
          indus: sendIndustriesList,
          description: description,
          exc: selectedIdItem,
          cid: catId,
          type: selectedCategory.toLowerCase(),
          tickers: sendTickersList,
          files: files);
    }
  }

  postingBlog({
    required String title,
    required String description,
    required String type,
    required String cid,
    required String exc,
    required List indus,
    required List tickers,
    required List<Map<String, dynamic>> files,
  }) async {
    if (type == "stocks") {
      data = {
        "title": title,
        "content": description,
        "billboard_type": "byte",
        "type": type,
        "category": type,
        "category_id": cid,
        "exchange": exc,
        "industries": indus,
        "tickers": tickers,
        "allindustries": true,
        "alltickers": tickerSelectAll,
        "files": files,
        "public_view": checkBoxValue ? "private" : "public",
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex
      };
    } else if (type == "crypto") {
      data = {
        "title": title,
        "content": description,
        "billboard_type": "byte",
        "type": type,
        "category": type,
        "category_id": cid,
        "industries": indus,
        "tickers": tickers,
        "alltickers": tickerSelectAll,
        "files": files,
        "public_view": checkBoxValue ? "private" : "public",
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex
      };
    } else if (type == "commodity") {
      data = {
        "title": title,
        "content": description,
        "billboard_type": "byte",
        "type": type,
        "category": type,
        "category_id": cid,
        "country": exc,
        "tickers": tickers,
        "alltickers": tickerSelectAll,
        "files": files,
        "public_view": checkBoxValue ? "private" : "public",
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex
      };
    } else {
      data = {
        "title": title,
        "content": description,
        "billboard_type": "byte",
        "type": type,
        "category": type,
        "category_id": cid,
        "tickers": tickers,
        "alltickers": tickerSelectAll,
        "files": files,
        "public_view": checkBoxValue ? "private" : "public",
        "company_name": tickers.length > 1 ? "Multiple" : _selectIndex
      };
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionBillBoard + billBoardAdd;
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
      mainVariables.activeTypeMain.value = "trending";
      mainVariables.isFirstTime.value = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
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

  @override
  void initState() {
    mainVariables.messageControllerMain.value.clear();
    mainVariables.isUserTagging.value = false;
    mainVariables.isUserTaggingLoader.value = false;
    createTutorial();
    getAllDataMain(name: 'Byte_Posting_Page');
    getData();
    super.initState();
  }

  getData() async {
    if (mainVariables.isJourney.value) {
      mainVariables.isFirstTime.value ? Future.delayed(Duration.zero, showTutorial) : debugPrint("nothing");
    }
  }

  void createTutorial() {
    //ImagePicker _picker = ImagePicker();
    tutorialCoachMark = TutorialCoachMark(
      hideSkip: true,
      targets: _createTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 0,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      onFinish: () {},
      onClickTarget: (target) async {
        if (target.identify == "private") {
          setState(() {
            checkBoxValue = !checkBoxValue;
          });
          tutorialCoachMark.onClickTarget!.call(target.identify);
          mainVariables.isJourney.value = true;
        } else if (target.identify == "text") {
          titleFocus.requestFocus();
          tutorialCoachMark.onClickTarget!.call(target.identify);
          mainVariables.isJourney.value = true;
        } else if (target.identify == "attach") {
          showSheet(context: context, modelSetState: setState);
          tutorialCoachMark.next();
          mainVariables.isJourney.value = true;
          setState(() {});
        } else if (target.identify == "category") {
          setState(() {
            selectedValue = "0";
          });
          categoriesBottomSheet();
          mainVariables.isJourney.value = true;
          tutorialCoachMark.next();
        } else if (target.identify == "categorySelect") {
          tutorialCoachMark.next();
          mainVariables.isJourney.value = true;
          setState(() {});
        } else if (target.identify == "saveButton") {
          Navigator.pop(context, true);
          setState(() {
            selectedCategory = categoriesList[int.parse(selectedValue)];
            _selectSubCategory = selectedValue == "1"
                ? "Select a Exchange"
                : selectedValue == "2"
                    ? "Select a Crypto Type"
                    : selectedValue == "3"
                        ? "Select a Country"
                        : selectedValue == "4"
                            ? ""
                            : "";
            _selectIndex = selectedValue == "1"
                ? "Select a Ticker"
                : selectedValue == "2"
                    ? "Select a Ticker"
                    : selectedValue == "3"
                        ? "Select a Ticker"
                        : selectedValue == "4"
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
          selectedValue == "1"
              ? await getEx(newSetState1: setState)
              : selectedValue == "2"
                  ? await getIndustries(newSetState: setState)
                  : selectedValue == "4"
                      ? await getTickersFunc(tickerSetState: setState)
                      : debugPrint("nothing");
          if (!mounted) {
            return;
          }
          Navigator.pop(context, true);
          mainVariables.isJourney.value = true;
          tutorialCoachMark.next();
          setState(() {});
        } else if (target.identify == "release") {
          logEventFunc(name: 'Blog_Complete', type: 'Blog');
          setState(() {
            releaseLoader = true;
          });
          validatePost(
            title: mainVariables.messageControllerMain.value.text,
            description: "",
            type: selectedCategory.toLowerCase(),
            exc: selectedIdItem,
            indus: sendIndustriesList,
            tickers: sendTickersList,
            files: fileList,
          );
          mainVariables.isJourney.value = false;
          tutorialCoachMark.finish();
          setState(() {});
        }
      },
      onClickTargetWithTapPosition: (target, tapDetails) async {
        if (target.identify == "bottom") {
          if (!mounted) {
            return;
          }
          Navigator.pop(context);
          mainVariables.isJourney.value = true;
          tutorialCoachMark.next();
          */
/*final _image = await _picker.pickImage(source: ImageSource.gallery);
          if (_image != null) {
            await cropImageFunc(
            context: context,
            currentImage: _image,
            type: "image",
            modelSetState: setState,
            );
            tutorialCoachMark.next();
            setState(() {
              pickedImage = File(_image.path);
              selectedUrlType = "image";
              pickedVideo = null;
            });
          }*//*

        } else if (target.identify == "categorySelect") {
          mainVariables.isJourney.value = true;
          tutorialCoachMark.next();
          setState(() {});
        } else if (target.identify == "saveButton") {
          mainVariables.isJourney.value = true;
          Navigator.pop(context, true);
          setState(() {
            selectedCategory = categoriesList[int.parse(selectedValue)];
            _selectSubCategory = selectedValue == "1"
                ? "Select a Exchange"
                : selectedValue == "2"
                    ? "Select a Crypto Type"
                    : selectedValue == "3"
                        ? "Select a Country"
                        : selectedValue == "4"
                            ? ""
                            : "";

            _selectIndex = selectedValue == "1"
                ? "Select a Ticker"
                : selectedValue == "2"
                    ? "Select a Ticker"
                    : selectedValue == "3"
                        ? "Select a Ticker"
                        : selectedValue == "4"
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
          selectedValue == "1"
              ? await getEx(newSetState1: setState)
              : selectedValue == "2"
                  ? await getIndustries(newSetState: setState)
                  : selectedValue == "4"
                      ? await getTickersFunc(tickerSetState: setState)
                      : debugPrint("nothing");
          tutorialCoachMark.next();
          setState(() {});
        }
      },
      onClickOverlay: (target) {
        if (target.identify == "text") {
          mainVariables.isJourney.value = true;
          titleFocus.unfocus();
          tutorialCoachMark.onClickOverlay!.call(target.identify);
        }
      },
      onSkip: () {},
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "private",
        keyTarget: keyButton7,
        color: Colors.black26.withOpacity(0.1),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: width / 11.74),
                    child: SvgPicture.asset("lib/Constants/Assets/BillBoard/handsignal_up.svg"),
                  ),
                  Container(
                    height: height / 4.81,
                    margin: EdgeInsets.only(left: width / 27.4, right: width / 27.4),
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Your Post Visibility",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                            fontSize: text.scale(10),
                          ),
                        ),
                        SizedBox(
                          height: height / 108.25,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Private Posts: Only visible to your believers, ensuring a tight-knit community sees your insights.\n\nPublic Posts: Share your knowledge with everyone on Trade Watch, reaching a wider audience and enhancing community interaction.",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: text.scale(10),
                            ),
                            maxLines: 10,
                          ),
                        ),
                        SizedBox(
                          height: height / 108.25,
                        ),
                        SizedBox(
                          height: height / 34.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                  child: Text(
                                    "5/12",
                                    style: TextStyle(
                                      fontSize: text.scale(10),
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      tutorialCoachMark.finish();
                                      mainVariables.isJourney.value = false;
                                      mainVariables.isFirstTime.value = false;
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
                                      setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                    child: Text(
                                      "Skip",
                                      style: TextStyle(fontSize: text.scale(12), color: Theme.of(context).colorScheme.background),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 41.1,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                                      ),
                                      onPressed: () {
                                        tutorialCoachMark.next();
                                        mainVariables.isJourney.value = true;
                                        setState(() {});
                                      },
                                      child: Text(
                                        "Next",
                                        style: TextStyle(fontSize: text.scale(12), color: Theme.of(context).colorScheme.background),
                                      )),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 0.5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "text",
        keyTarget: keyButton,
        targetPosition: TargetPosition(const Size(0, 0), const Offset(0, 0)),
        color: Colors.black26.withOpacity(0.1),
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("lib/Constants/Assets/BillBoard/handsignal_up.svg"),
                  Container(
                    height: height / 6.414,
                    margin: EdgeInsets.symmetric(horizontal: width / 10.275),
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Craft Your Byte",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                            fontSize: text.scale(10),
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Text(
                          "Write a catchy caption, add an image if you wish, and categorize your byte to make it discoverable.",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: text.scale(10),
                          ),
                          maxLines: 10,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        SizedBox(
                          height: height / 34.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                  child: Text(
                                    "6/12",
                                    style: TextStyle(
                                      fontSize: text.scale(10),
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      tutorialCoachMark.finish();
                                      mainVariables.isJourney.value = false;
                                      mainVariables.isFirstTime.value = false;
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
                                      setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                    child: Text(
                                      "Skip",
                                      style: TextStyle(fontSize: text.scale(12), color: Theme.of(context).colorScheme.background),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 41.1,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                                      ),
                                      onPressed: () {
                                        titleFocus.unfocus();
                                        tutorialCoachMark.next();
                                        mainVariables.isJourney.value = true;
                                        setState(() {});
                                      },
                                      child: Text(
                                        "Next",
                                        style: TextStyle(fontSize: text.scale(12), color: Theme.of(context).colorScheme.background),
                                      )),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 1,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "attach",
        keyTarget: keyButton2,
        color: Colors.black26.withOpacity(0.1),
        paddingFocus: 0,
        contents: [
          TargetContent(
            align: ContentAlign.right,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("lib/Constants/Assets/BillBoard/handsignal_left.svg"),
                  Container(
                    height: height / 4.12,
                    width: width / 2,
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Boost engagement with attachments",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                            fontSize: text.scale(10),
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Text(
                          "Attach an image of a chart or any relevant visual. Showcasing your stock performance visually can drive more engagement, attracting more believers to your profile.",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: text.scale(10),
                          ),
                          maxLines: 10,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        SizedBox(
                          height: height / 34.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                  child: Text(
                                    "7/12",
                                    style: TextStyle(
                                      fontSize: text.scale(10),
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: width / 5.87,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          tutorialCoachMark.finish();
                                          mainVariables.isJourney.value = false;
                                          mainVariables.isFirstTime.value = false;
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                        child: Text(
                                          "Skip",
                                          style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.background),
                                        ),
                                      )),
                                  SizedBox(
                                    width: width / 82.2,
                                  ),
                                  SizedBox(
                                      width: width / 5.87,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                                          ),
                                          onPressed: () async {
                                            showSheet(context: context, modelSetState: setState);
                                            tutorialCoachMark.next();
                                            mainVariables.isJourney.value = true;
                                            setState(() {});
                                          },
                                          child: Text(
                                            "Attach",
                                            style: TextStyle(
                                              fontSize: text.scale(10),
                                              color: Theme.of(context).colorScheme.background,
                                            ),
                                          ))),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "bottom",
        keyTarget: keyButton8,
        color: Colors.black26.withOpacity(0.1),
        paddingFocus: 0,
        enableOverlayTab: false,
        enableTargetTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height / 5.77,
                    margin: EdgeInsets.symmetric(horizontal: width / 16.44),
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manage Your Attachments",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                            fontSize: text.scale(10),
                          ),
                        ),
                        SizedBox(
                          height: height / 108.25,
                        ),
                        Text(
                          "Support your posts with relevant attachments – a quick way to validate your trading insights and enhancing credibility among your peers on Trade Watch. Keep it relevant, keep it real!",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: text.scale(10),
                          ),
                          maxLines: 10,
                        ),
                        SizedBox(
                          height: height / 108.25,
                        ),
                        SizedBox(
                          height: height / 34.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                  child: Text(
                                    "8/12",
                                    style: TextStyle(
                                      fontSize: text.scale(10),
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: width / 5.87,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          tutorialCoachMark.finish();
                                          mainVariables.isJourney.value = false;
                                          mainVariables.isFirstTime.value = false;
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                        child: Text(
                                          "Skip",
                                          style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.background),
                                        ),
                                      )),
                                  SizedBox(
                                    width: width / 82.2,
                                  ),
                                  SizedBox(
                                    width: width / 5.87,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                                      ),
                                      onPressed: () async {
                                        */
/* ImagePicker _picker=ImagePicker();
                                      if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                      final _image = await _picker.pickImage(source: ImageSource.gallery);
                                      if (_image != null) {
                                        await cropImageFunc(
                                          context: context,
                                          currentImage: _image,
                                          type: "image",
                                          modelSetState: setState,
                                        );
                                        tutorialCoachMark.next();
                                        setState(() {
                                          pickedImage = File(_image.path);
                                          selectedUrlType = "image";
                                          pickedVideo = null;
                                        });
                                      }*//*

                                        if (!mounted) {
                                          return;
                                        }
                                        Navigator.pop(context);
                                        mainVariables.isJourney.value = true;
                                        tutorialCoachMark.next();
                                      },
                                      child: Text(
                                        "Next",
                                        style: TextStyle(
                                          fontSize: text.scale(10),
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SvgPicture.asset("lib/Constants/Assets/BillBoard/handSignal.svg")
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "category",
        keyTarget: keyButton4,
        color: Colors.black26.withOpacity(0.1),
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: height / 6.41,
                    margin: EdgeInsets.only(left: width / 3.425, right: width / 41.1),
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select a category",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                            fontSize: text.scale(10),
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Text(
                          "Categorize your byte to make it more discoverable to relevant audience.",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: text.scale(10),
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        SizedBox(
                          height: height / 34.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                  child: Text(
                                    "9/12",
                                    style: TextStyle(
                                      fontSize: text.scale(10),
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: width / 5.87,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          tutorialCoachMark.finish();
                                          mainVariables.isJourney.value = false;
                                          mainVariables.isFirstTime.value = false;
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                        child: Text(
                                          "Skip",
                                          style: TextStyle(fontSize: text.scale(10), color: Theme.of(context).colorScheme.background),
                                        ),
                                      )),
                                  SizedBox(
                                    width: width / 82.2,
                                  ),
                                  SizedBox(
                                      width: width / 5.87,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              selectedValue = "0";
                                            });
                                            categoriesBottomSheet();
                                            tutorialCoachMark.next();
                                            mainVariables.isJourney.value = true;
                                            setState(() {});
                                          },
                                          child: Text(
                                            "Next",
                                            style: TextStyle(
                                              fontSize: text.scale(10),
                                              color: Theme.of(context).colorScheme.background,
                                            ),
                                          ))),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width / 27.4),
                    child: SvgPicture.asset("lib/Constants/Assets/BillBoard/handSignal.svg"),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "categorySelect",
        keyTarget: keyList[0],
        color: Colors.black26.withOpacity(0.1),
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter modelSetState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: height / 5.77,
                        margin: EdgeInsets.symmetric(horizontal: width / 16.44),
                        padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).colorScheme.background,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              spreadRadius: 0.0,
                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selecting a 'General' Category",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                                fontSize: text.scale(10),
                              ),
                            ),
                            SizedBox(
                              height: height / 108.25,
                            ),
                            Text(
                              "Choose 'General' when your post encompasses varied topics or does not strictly relate to Stocks, Crypto, Commodities, or Forex.",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: text.scale(10),
                              ),
                              maxLines: 10,
                            ),
                            SizedBox(
                              height: height / 108.25,
                            ),
                            SizedBox(
                              height: height / 34.64,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                      child: Text(
                                        "10/12",
                                        style: TextStyle(
                                          fontSize: text.scale(10),
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: width / 5.87,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              tutorialCoachMark.finish();
                                              mainVariables.isJourney.value = false;
                                              mainVariables.isFirstTime.value = false;
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
                                              setState(() {});
                                            },
                                            style:
                                                ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                            child: Text(
                                              "Skip",
                                              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.background),
                                            ),
                                          )),
                                      SizedBox(
                                        width: width / 82.2,
                                      ),
                                      SizedBox(
                                          width: width / 5.87,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                                              ),
                                              onPressed: () async {
                                                tutorialCoachMark.next();
                                                mainVariables.isJourney.value = true;
                                                setState(() {});
                                              },
                                              child: Text(
                                                "Next",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Theme.of(context).colorScheme.background,
                                                ),
                                              ))),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SvgPicture.asset("lib/Constants/Assets/BillBoard/handSignal.svg")
                    ],
                  );
                },
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "saveButton",
        keyTarget: keyButton9,
        color: Colors.black26.withOpacity(0.1),
        enableTargetTab: false,
        enableOverlayTab: false,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter modelSetState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: height / 5.77,
                        margin: EdgeInsets.symmetric(horizontal: width / 16.44),
                        padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).colorScheme.background,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4.0,
                              spreadRadius: 0.0,
                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Save a category",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                                fontSize: text.scale(10),
                              ),
                            ),
                            SizedBox(
                              height: height / 108.25,
                            ),
                            Text(
                              "Click on save to finalize your selection.",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: text.scale(10),
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: height / 108.25,
                            ),
                            SizedBox(
                              height: height / 34.64,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                      child: Text(
                                        "11/12",
                                        style: TextStyle(
                                          fontSize: text.scale(10),
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: width / 5.87,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              tutorialCoachMark.finish();
                                              mainVariables.isJourney.value = false;
                                              mainVariables.isFirstTime.value = false;
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
                                              setState(() {});
                                            },
                                            style:
                                                ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                                            child: Text(
                                              "Skip",
                                              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.background),
                                            ),
                                          )),
                                      SizedBox(
                                        width: width / 82.2,
                                      ),
                                      SizedBox(
                                          width: width / 5.87,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context, true);
                                                setState(() {
                                                  selectedCategory = categoriesList[int.parse(selectedValue)];
                                                  _selectSubCategory = selectedValue == "1"
                                                      ? "Select a Exchange"
                                                      : selectedValue == "2"
                                                          ? "Select a Crypto Type"
                                                          : selectedValue == "3"
                                                              ? "Select a Country"
                                                              : selectedValue == "4"
                                                                  ? ""
                                                                  : "";
                                                  _selectIndex = selectedValue == "1"
                                                      ? "Select a Ticker"
                                                      : selectedValue == "2"
                                                          ? "Select a Ticker"
                                                          : selectedValue == "3"
                                                              ? "Select a Ticker"
                                                              : selectedValue == "4"
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
                                                selectedValue == "1"
                                                    ? await getEx(newSetState1: modelSetState)
                                                    : selectedValue == "2"
                                                        ? await getIndustries(newSetState: setState)
                                                        : selectedValue == "4"
                                                            ? await getTickersFunc(tickerSetState: setState)
                                                            : debugPrint("nothing");
                                                mainVariables.isJourney.value = true;
                                                tutorialCoachMark.next();
                                                setState(() {});
                                              },
                                              child: Text(
                                                "Next",
                                                style: TextStyle(
                                                  fontSize: text.scale(10),
                                                  color: Theme.of(context).colorScheme.background,
                                                ),
                                              ))),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SvgPicture.asset("lib/Constants/Assets/BillBoard/handSignal.svg")
                    ],
                  );
                },
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "release",
        keyTarget: keyButton3,
        color: Colors.black26.withOpacity(0.1),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;
              TextScaler text = MediaQuery.of(context).textScaler;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: width / 27.4),
                    child: SvgPicture.asset("lib/Constants/Assets/BillBoard/handsignal_up.svg"),
                  ),
                  Container(
                    height: height / 8.66,
                    margin: EdgeInsets.only(left: width / 3.425, right: width / 41.1),
                    padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.background,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Click on release to publish your byte to the wider Tradewatch community.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                            fontSize: text.scale(10),
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        SizedBox(
                          height: height / 34.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkTheme.value ? Colors.grey.shade800 : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 82.2),
                                  child: Text(
                                    "12/12",
                                    style: TextStyle(
                                      fontSize: text.scale(10),
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF0EA102),
                                ),
                                onPressed: () {
                                  logEventFunc(name: 'Blog_Complete', type: 'Blog');
                                  setState(() {
                                    releaseLoader = true;
                                  });
                                  validatePost(
                                    title: mainVariables.messageControllerMain.value.text,
                                    description: "",
                                    type: selectedCategory.toLowerCase(),
                                    exc: selectedIdItem,
                                    indus: sendIndustriesList,
                                    tickers: sendTickersList,
                                    files: fileList,
                                  );
                                  tutorialCoachMark.finish();
                                  mainVariables.isJourney.value = false;
                                  setState(() {});
                                },
                                child: Text(
                                  "Done",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: text.scale(8),
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    return targets;
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (tutorialCoachMark.isShowing) {
          mainVariables.isFirstTime.value = false;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
          tutorialCoachMark.finish();
        }
        Navigator.pop(context, false);
        return false;
      },
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
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
                        onTap: () async {
                          if (tutorialCoachMark.isShowing) {
                            mainVariables.isJourney.value = false;
                            tutorialCoachMark.finish();
                          }
                          if (previewLoader) {
                            setState(() {
                              inputString = "";
                              previewLoader = false;
                            });
                          } else {
                            mainVariables.activeTypeMain.value = "trending";
                            mainVariables.isFirstTime.value = false;
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool("isFirstTime", mainVariables.isFirstTime.value);
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context, false);
                          }
                        },
                        child: releaseLoader
                            ? const SizedBox()
                            : Center(
                                child: Text(previewLoader ? "Back" : "Cancel",
                                    style: TextStyle(
                                        fontSize: text.scale(14),
                                        color: const Color(0XFFB0B0B0),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins")),
                              ),
                      ),
                      Center(
                        child: Text("Byte", style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w700, fontFamily: "Poppins")),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            previewLoader
                                ? const SizedBox()
                                : GestureDetector(
                                    onTap: () async {
                                      if (mainVariables.messageControllerMain.value.text.isEmpty) {
                                        Flushbar(
                                          message: "The content playground can't be empty.",
                                          duration: const Duration(seconds: 2),
                                        ).show(context);
                                      } else {
                                        previewLoader = true;
                                        setState(() {});
                                      }
                                    },
                                    child: Center(
                                      child: Text("Preview",
                                          style: TextStyle(
                                              color: const Color(0XFFA5A5A5),
                                              fontSize: text.scale(12),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Poppins")),
                                    ),
                                  ),
                            previewLoader ? const SizedBox() : const VerticalDivider(),
                            releaseLoader
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        releaseLoader = false;
                                      });
                                    },
                                    child: SizedBox(
                                        height: height / 43.3,
                                        width: width / 20.55,
                                        child: const CircularProgressIndicator(
                                          color: Color(0XFF0EA102),
                                          strokeWidth: 2.0,
                                        )),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      logEventFunc(name: 'Byte_Complete', type: "Byte");
                                      setState(() {
                                        releaseLoader = true;
                                      });
                                      validatePost(
                                        title: mainVariables.messageControllerMain.value.text,
                                        description: "",
                                        type: selectedCategory.toLowerCase(),
                                        exc: selectedIdItem,
                                        indus: sendIndustriesList,
                                        tickers: sendTickersList,
                                        files: fileList,
                                      );
                                    },
                                    child: Container(
                                      key: keyButton3,
                                      child: Center(
                                        child: Text("Release",
                                            style: TextStyle(
                                                fontSize: text.scale(14),
                                                color: const Color(0XFF0EA102),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins")),
                                      ),
                                    ),
                                  ),
                          ],
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
                    previewLoader
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height / 57.73,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      billboardWidgetsMain.getProfile(
                                          context: context,
                                          heightValue: height / 14.93,
                                          widthValue: width / 7.08,
                                          myself: true,
                                          userId: '',
                                          isProfile: "user"),
                                      SizedBox(
                                        width: height / 56.26,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${mainVariables.firstNameMyselfMain} ${mainVariables.lastNameMyselfMain}",
                                            style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w600, color: const Color(0XFF2F2F2F)),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return UserBillBoardProfilePage(
                                                    userId: userIdMain) */
/*UserProfilePage(id:userIdMain,type:'forums',index:0)*//*
;
                                              }));
                                            },
                                            child: Text(
                                              mainVariables.userNameMyselfMain,
                                              style: TextStyle(fontSize: text.scale(10), color: const Color(0XFF737373)),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: height / 57.73,
                                ),
                                SizedBox(
                                  height: height / 57.73,
                                ),
                                Text(
                                  mainVariables.messageControllerMain.value.text,
                                  style: TextStyle(color: const Color(0XFF282828), fontSize: text.scale(16), fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: height / 57.73,
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemCount: fileList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return fileList[index]["file_type"] == "image"
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return FullScreenImage(imageUrl: fileList[index]["file"], tag: "generate_a_unique_tag");
                                                }));
                                              },
                                              child: Container(
                                                height: height / 3.84,
                                                width: width,
                                                margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    border: Border.all(color: Colors.grey.shade300),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          fileList[index]["file"],
                                                        ),
                                                        fit: BoxFit.fill)),
                                              ),
                                            )
                                          : fileList[index]["file_type"] == "video"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return VideoPlayerPage(
                                                        url: fileList[index]["file"],
                                                      );
                                                    }));
                                                  },
                                                  child: Container(
                                                    height: height / 3.84,
                                                    width: width,
                                                    margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      border: Border.all(color: Colors.grey.shade300),
                                                    ),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: BetterPlayer.network(
                                                      fileList[index]["file"],
                                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                                          aspectRatio: 1.77,
                                                          fit: BoxFit.contain,
                                                          controlsConfiguration: BetterPlayerControlsConfiguration(
                                                              controlBarColor: Colors.transparent,
                                                              backgroundColor: Colors.grey.shade50,
                                                              enableSkips: true,
                                                              enableFullscreen: false,
                                                              iconsColor: Colors.black87,
                                                              textColor: const Color(0XFF0EA102),
                                                              skipBackIcon: Container(
                                                                  height: height / 17.32,
                                                                  width: width / 8.22,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.black26.withOpacity(0.3),
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: const Icon(
                                                                    Icons.replay_10,
                                                                    color: Colors.white,
                                                                  )),
                                                              playIcon: Container(
                                                                  height: height / 17.32,
                                                                  width: width / 8.22,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.black26.withOpacity(0.3),
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: const Icon(
                                                                    Icons.play_arrow_sharp,
                                                                    color: Colors.white,
                                                                  )),
                                                              pauseIcon: Container(
                                                                  height: height / 17.32,
                                                                  width: width / 8.22,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.black26.withOpacity(0.3),
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: const Icon(
                                                                    Icons.pause,
                                                                    color: Colors.white,
                                                                  )),
                                                              skipForwardIcon: Container(
                                                                  height: height / 17.32,
                                                                  width: width / 8.22,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.black26.withOpacity(0.3),
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: const Icon(
                                                                    Icons.forward_10,
                                                                    color: Colors.white,
                                                                  )),
                                                              muteIcon: Container(
                                                                  height: height / 17.32,
                                                                  width: width / 8.22,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.black26.withOpacity(0.3),
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: const Icon(
                                                                    Icons.volume_off,
                                                                    size: 15,
                                                                    color: Colors.white,
                                                                  )),
                                                              unMuteIcon: Container(
                                                                  height: height / 17.32,
                                                                  width: width / 8.22,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.black26.withOpacity(0.3),
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: const Icon(
                                                                    Icons.volume_up,
                                                                    size: 15,
                                                                    color: Colors.white,
                                                                  )),
                                                              progressBarBackgroundColor: const Color(0XFF0EA102).withOpacity(0.3),
                                                              progressBarPlayedColor: const Color(0XFF0EA102),
                                                              progressBarBufferedColor: Colors.orange.withOpacity(0.1),
                                                              progressBarHandleColor: Colors.white,
                                                              loadingWidget: Container(
                                                                  height: height / 17.32,
                                                                  width: width / 8.22,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.black26.withOpacity(0.3),
                                                                    shape: BoxShape.circle,
                                                                  ),
                                                                  child: const Padding(
                                                                    padding: EdgeInsets.all(12.0),
                                                                    child: CircularProgressIndicator(
                                                                      color: Color(0XFF0EA102),
                                                                    ),
                                                                  )),
                                                              loadingColor: Colors.white10)),
                                                    ),
                                                  ),
                                                )
                                              : fileList[index]["file_type"] == "document"
                                                  ? SizedBox(
                                                      width: width,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              SizedBox(
                                                                height: height / 86.6,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute<dynamic>(
                                                                      builder: (_) => PDFViewerFromUrl(
                                                                        url: fileList[index]["file"],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(color: const Color(0xffD8D8D8).withOpacity(0.5))),
                                                                      child: Text(
                                                                        fileList[index]["file"].split('/').last.toString(),
                                                                        style: TextStyle(color: Colors.black, fontSize: text.scale(13)),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 5),
                                                                    const Icon(
                                                                      Icons.file_copy_outlined,
                                                                      color: Colors.red,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 86.6,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox();
                                    })
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Column(children: [
                                      SizedBox(
                                        height: height / 57.73,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            billboardWidgetsMain.getProfile(
                                                context: context,
                                                heightValue: height / 14.93,
                                                widthValue: width / 7.08,
                                                myself: true,
                                                userId: '',
                                                isProfile: "user"),
                                            SizedBox(
                                              width: height / 56.26,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${mainVariables.firstNameMyselfMain} ${mainVariables.lastNameMyselfMain}",
                                                  style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w600),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return UserBillBoardProfilePage(userId: userIdMain)
                                                          */
/*UserProfilePage(
                                                        id:userIdMain,type:'forums',index:0)*//*

                                                          ;
                                                    }));
                                                  },
                                                  child: Text(
                                                    mainVariables.userNameMyselfMain,
                                                    style: TextStyle(fontSize: text.scale(10), color: const Color(0XFF737373)),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              key: keyButton7,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  checkBoxValue ? "Private" : "Public",
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                                                ),
                                                Transform.scale(
                                                  scale: 0.6,
                                                  child: CupertinoSwitch(
                                                    value: checkBoxValue,
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        checkBoxValue = value;
                                                      });
                                                    },
                                                    activeColor: const Color(0xff0EA102),
                                                    trackColor: const Color.fromARGB(255, 212, 206, 206),
                                                    thumbColor: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                    Obx(() => mainVariables.isUserTagging.value ? const UserTaggingContainer() : const SizedBox()),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  child: TextFormField(
                                    key: keyButton,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          String newResponseValue = value.trim();
                                          if (newResponseValue.isNotEmpty) {
                                            String messageText = newResponseValue;
                                            if (messageText.startsWith("+")) {
                                              if (messageText.substring(messageText.length - 1) == '+') {
                                                setState(() {
                                                  mainVariables.isUserTagging.value = true;
                                                  mainVariables.isUserTaggingLoader.value = true;
                                                });
                                              } else {
                                                if (mainVariables.isUserTagging.value) {
                                                  conversationFunctionsMain.conversationSearchData(
                                                    newResponseValue: newResponseValue,
                                                    newSetState: setState,
                                                  );
                                                  setState(() {
                                                    mainVariables.isUserTaggingLoader.value = false;
                                                  });
                                                } else {
                                                  conversationFunctionsMain.conversationSearchData(
                                                    newResponseValue: newResponseValue,
                                                    newSetState: setState,
                                                  );
                                                }
                                              }
                                            } else {
                                              if (messageText.contains(" +")) {
                                                if (messageText.substring(messageText.length - 1) == '+') {
                                                  setState(() {
                                                    mainVariables.isUserTagging.value = true;
                                                    mainVariables.isUserTaggingLoader.value = true;
                                                  });
                                                } else {
                                                  if (mainVariables.isUserTagging.value) {
                                                    conversationFunctionsMain.conversationSearchData(
                                                      newResponseValue: newResponseValue,
                                                      newSetState: setState,
                                                    );
                                                    setState(() {
                                                      mainVariables.isUserTaggingLoader.value = false;
                                                    });
                                                  } else {
                                                    conversationFunctionsMain.conversationSearchData(
                                                        newResponseValue: newResponseValue, newSetState: setState);
                                                  }
                                                }
                                              } else {
                                                setState(() {
                                                  mainVariables.isUserTagging.value = false;
                                                  mainVariables.isUserTaggingLoader.value = true;
                                                });
                                              }
                                            }
                                          }
                                        });
                                      } else if (value.isEmpty) {
                                        setState(() {
                                          mainVariables.isUserTagging.value = false;
                                        });
                                      } else {
                                        setState(() {});
                                      }
                                    },
                                    controller: mainVariables.messageControllerMain.value,
                                    focusNode: titleFocus,
                                    maxLines: 25,
                                    minLines: 12,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      fillColor: Theme.of(context).colorScheme.tertiary,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
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
                                      hintText: '**Content Playground**',
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 50.75,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        showSheet(context: context, modelSetState: setState);
                                      },
                                      child: Container(
                                        height: height / 8.82,
                                        width: width / 4.07,
                                        margin: EdgeInsets.symmetric(horizontal: width / 41.1),
                                        child: Image.asset(
                                          "assets/settings/add_file.png",
                                          key: keyButton2,
                                          height: height / 8.82,
                                          width: width / 4.07,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 8.82,
                                      width: width / 1.5,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          physics: const ScrollPhysics(),
                                          itemCount: fileList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (fileList[index]["file_type"] == "image") {
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return FullScreenImage(imageUrl: fileList[index]["file"], tag: "generate_a_unique_tag");
                                                      }));
                                                    } else if (fileList[index]["file_type"] == "video") {
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return VideoPlayerPage(
                                                          url: fileList[index]["file"],
                                                        );
                                                      }));
                                                    } else if (fileList[index]["file_type"] == "document") {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute<dynamic>(
                                                          builder: (_) => PDFViewerFromUrl(
                                                            url: fileList[index]["file"],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade500)),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: fileList[index]["file_type"] == "image"
                                                        ? Image.network(
                                                            fileList[index]["file"],
                                                            height: height / 8.82,
                                                            width: width / 4.07,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : fileList[index]["file_type"] == "video"
                                                            ? Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                                  Image.asset(
                                                                    "lib/Constants/Assets/Settings/coverImage_default.png",
                                                                    height: height / 8.82,
                                                                    width: width / 4.07,
                                                                    fit: BoxFit.fill,
                                                                  ),
                                                                  Container(
                                                                      height: height / 34.64,
                                                                      width: width / 16.44,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle, color: Colors.black26.withOpacity(0.7)),
                                                                      child: const Icon(
                                                                        Icons.play_arrow_sharp,
                                                                        color: Colors.white,
                                                                        size: 15,
                                                                      ))
                                                                ],
                                                              )
                                                            : fileList[index]["file_type"] == "document"
                                                                ? Stack(
                                                                    alignment: Alignment.center,
                                                                    children: [
                                                                      Image.asset(
                                                                        "lib/Constants/Assets/Settings/coverImage.png",
                                                                        height: height / 8.82,
                                                                        width: width / 4.07,
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                      Container(
                                                                        height: height / 34.64,
                                                                        width: width / 16.44,
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: Colors.black26.withOpacity(0.3),
                                                                        ),
                                                                        child: Center(
                                                                          child: Image.asset(
                                                                            "lib/Constants/Assets/BillBoard/document.png",
                                                                            color: Colors.white,
                                                                            height: 15,
                                                                            width: 15,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                : const SizedBox(),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 7,
                                                  top: 5,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      bool response = await billBoardApiMain.fileRemoveBillBoard(
                                                          context: context, filePath: fileList[index]["file"]);
                                                      if (response) {
                                                        fileList.removeAt(index);
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Container(
                                                      height: height / 48.11,
                                                      width: width / 22.83,
                                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black26.withOpacity(0.3)),
                                                      child: const Icon(
                                                        Icons.remove,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: width / 37.5),
                                  child: ListTile(
                                    key: keyButton4,
                                    onTap: () {
                                      categoriesBottomSheet();
                                    },
                                    title: Text(selectedCategory),
                                    trailing: const Icon(Icons.keyboard_arrow_down_sharp),
                                  ),
                                ),
                                selectedValue == "" || selectedValue == "0"
                                    ? const SizedBox()
                                    : selectedValue == "1"
                                        ? Column(
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
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            "Exchanges",
                                                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: text.scale(16.0)),
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
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              fontSize: text.scale(12.0)),
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          exchangeCodeList[index],
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: text.scale(12.0),
                                                                                              color: const Color(0XFFA5A5A5)),
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
                                                                                      selectedIdItem == "General"
                                                                                          ? debugPrint("nothing")
                                                                                          : await getTickersFunc(tickerSetState: modelSetState);
                                                                                      if (!mounted) {
                                                                                        return;
                                                                                      }
                                                                                      Navigator.pop(context, true);
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
                                                  trailing: Icon(
                                                    Icons.keyboard_arrow_down_sharp,
                                                    key: keyButton5,
                                                  ),
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
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: height / 54.13,
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      "Stocks",
                                                                                      style: TextStyle(
                                                                                          fontWeight: FontWeight.bold, fontSize: text.scale(16.0)),
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
                                                                                      borderSide:
                                                                                          const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                    ),
                                                                                    focusedBorder: OutlineInputBorder(
                                                                                      borderSide:
                                                                                          const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                    ),
                                                                                    enabledBorder: OutlineInputBorder(
                                                                                      borderSide:
                                                                                          const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                    ),
                                                                                    hintStyle: Theme.of(context)
                                                                                        .textTheme
                                                                                        .bodyMedium!
                                                                                        .copyWith(color: const Color(0XFFA5A5A5)),
                                                                                    hintText: 'Search here',
                                                                                    border: OutlineInputBorder(
                                                                                      borderSide:
                                                                                          const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                      borderRadius: BorderRadius.circular(12),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: height / 50.75,
                                                                                ),
                                                                                Text(
                                                                                  "Name of Stocks",
                                                                                  style: TextStyle(
                                                                                      fontWeight: FontWeight.bold, fontSize: text.scale(12.0)),
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
                                                                                          title: Text(
                                                                                            "General",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.bold,
                                                                                                fontSize: text.scale(12.0)),
                                                                                          ),
                                                                                          subtitle: Text(
                                                                                            'Use this option, if you want to create something generic',
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontSize: text.scale(12.0),
                                                                                                color: const Color(0XFFA5A5A5)),
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
                                                                                              modelSetState(() {
                                                                                                tickerSelectAll = value;
                                                                                              });
                                                                                            } else {
                                                                                              modelSetState(() {
                                                                                                tickerSelectAll = value;
                                                                                                sendTickersList.clear();
                                                                                              });
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
                                                                                              await getRefreshTickersFunc(
                                                                                                  tickerSetState1: modelSetState);
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
                                                                                                      style: TextStyle(
                                                                                                          fontWeight: FontWeight.bold,
                                                                                                          fontSize: text.scale(12.0)),
                                                                                                    ),
                                                                                                    subtitle: Text(
                                                                                                      tickersCodeList[index],
                                                                                                      style: TextStyle(
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          fontSize: text.scale(12.0),
                                                                                                          color: const Color(0XFFA5A5A5)),
                                                                                                    ),
                                                                                                    secondary: SizedBox(
                                                                                                        height: height / 33.83,
                                                                                                        width: width / 15.625,
                                                                                                        child: tickersLogoList[index].contains("svg")
                                                                                                            ? SvgPicture.network(
                                                                                                                tickersLogoList[index],
                                                                                                                fit: BoxFit.fill)
                                                                                                            : Image.network(tickersLogoList[index],
                                                                                                                fit: BoxFit.fill)),
                                                                                                    autofocus: false,
                                                                                                    activeColor: Colors.green,
                                                                                                    value: isCheckedNew[index],
                                                                                                    onChanged: (bool? value) {
                                                                                                      if (value!) {
                                                                                                        modelSetState(() {
                                                                                                          isCheckedNew[index] = value;
                                                                                                          sendTickersList
                                                                                                              .add(tickersCatIdList[index]);
                                                                                                          sendTickersNameList
                                                                                                              .add(tickersNameList[index]);
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
                                                                                                              sendTickersNameList.removeAt(i);
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
                                                            trailing: Icon(Icons.keyboard_arrow_down_sharp, key: keyButton6),
                                                          ),
                                                        ),
                                            ],
                                          )
                                        : (selectedValue == "2" || selectedValue == "3")
                                            ? selectedValue == "2"
                                                ? Column(
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
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "Type",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.bold, fontSize: text.scale(16.0)),
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
                                                                                            if (mounted) {
                                                                                              modelSetState(() {});
                                                                                            }
                                                                                            _controller.loadComplete();
                                                                                          },
                                                                                          child: ListView.builder(
                                                                                              itemCount: industriesNameList.length,
                                                                                              itemBuilder: (BuildContext context, index) {
                                                                                                return index == 0
                                                                                                    ? RadioListTile(
                                                                                                        activeColor: Colors.green,
                                                                                                        controlAffinity:
                                                                                                            ListTileControlAffinity.trailing,
                                                                                                        value: index.toString(),
                                                                                                        groupValue: _selectedExchange,
                                                                                                        onChanged: (value) {
                                                                                                          modelSetState(() {
                                                                                                            sendIndustriesList.clear();
                                                                                                            _selectIndex = "Select a Ticker";
                                                                                                            _selectedExchange = value.toString();
                                                                                                            sendIndustriesList
                                                                                                                .add(industriesIdList[index]);
                                                                                                          });
                                                                                                          setState(() {
                                                                                                            _selectSubCategory =
                                                                                                                industriesNameList[index];
                                                                                                          });
                                                                                                        },
                                                                                                        title: Text(
                                                                                                          industriesNameList[index],
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(12),
                                                                                                              fontFamily: "Poppins",
                                                                                                              fontWeight: FontWeight.w700),
                                                                                                        ),
                                                                                                        subtitle: Text(
                                                                                                          'Use this option, if you want to create something generic',
                                                                                                          style: TextStyle(
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                              fontSize: text.scale(12.0),
                                                                                                              color: const Color(0XFFA5A5A5)),
                                                                                                        ),
                                                                                                      )
                                                                                                    : RadioListTile(
                                                                                                        activeColor: Colors.green,
                                                                                                        controlAffinity:
                                                                                                            ListTileControlAffinity.trailing,
                                                                                                        value: index.toString(),
                                                                                                        groupValue: _selectedExchange,
                                                                                                        onChanged: (value) {
                                                                                                          modelSetState(() {
                                                                                                            sendIndustriesList.clear();
                                                                                                            _selectIndex = "Select a Ticker";
                                                                                                            _selectedExchange = value.toString();
                                                                                                            sendIndustriesList
                                                                                                                .add(industriesIdList[index]);
                                                                                                          });
                                                                                                          setState(() {
                                                                                                            _selectSubCategory =
                                                                                                                industriesNameList[index];
                                                                                                          });
                                                                                                        },
                                                                                                        title: Text(
                                                                                                          industriesNameList[index],
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(12),
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
                                                                                            onTap: () async {
                                                                                              if (sendIndustriesList[0] == "General") {
                                                                                              } else {
                                                                                                await getTickersFunc(tickerSetState: modelSetState);
                                                                                              }
                                                                                              if (!mounted) {
                                                                                                return;
                                                                                              }
                                                                                              Navigator.pop(context, true);
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
                                                          title: Text(_selectSubCategory),
                                                          trailing: Icon(Icons.keyboard_arrow_down_sharp, key: keyButton5),
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
                                                                                    padding: EdgeInsets.only(
                                                                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: height / 54.13,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              "Crypto",
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontSize: text.scale(16.0)),
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
                                                                                              borderSide: const BorderSide(
                                                                                                  color: Color(0xffD8D8D8), width: 0.1),
                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderSide: const BorderSide(
                                                                                                  color: Color(0xffD8D8D8), width: 0.1),
                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                            ),
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderSide: const BorderSide(
                                                                                                  color: Color(0xffD8D8D8), width: 0.1),
                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                            ),
                                                                                            hintStyle: Theme.of(context)
                                                                                                .textTheme
                                                                                                .bodyMedium!
                                                                                                .copyWith(color: const Color(0XFFA5A5A5)),
                                                                                            hintText: 'Search here',
                                                                                            border: OutlineInputBorder(
                                                                                              borderSide: const BorderSide(
                                                                                                  color: Color(0xffD8D8D8), width: 0.1),
                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: height / 50.75,
                                                                                        ),
                                                                                        Text(
                                                                                          "Name of Crypto",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              fontSize: text.scale(12.0)),
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
                                                                                                  title: Text(
                                                                                                    "General",
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        fontSize: text.scale(12.0)),
                                                                                                  ),
                                                                                                  subtitle: Text(
                                                                                                    'Use this option, if you want to create something generic',
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: text.scale(12.0),
                                                                                                        color: const Color(0XFFA5A5A5)),
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
                                                                                                  onChanged: (bool? value) {
                                                                                                    modelSetState(() {
                                                                                                      if (value!) {
                                                                                                        sendTickersList.clear();
                                                                                                        modelSetState(() {
                                                                                                          tickerSelectAll = value;
                                                                                                          sendTickersList.addAll(tickersCatIdList);
                                                                                                          _selectIndex = "multiple";
                                                                                                          getTickersFunc(
                                                                                                              tickerSetState: modelSetState);
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
                                                                                                      builder:
                                                                                                          (BuildContext context, LoadStatus? mode) {
                                                                                                        Widget body;
                                                                                                        if (mode == LoadStatus.idle) {
                                                                                                          body = const Text("pull up to load");
                                                                                                        } else if (mode == LoadStatus.loading) {
                                                                                                          body = const CupertinoActivityIndicator();
                                                                                                        } else if (mode == LoadStatus.failed) {
                                                                                                          body =
                                                                                                              const Text("Load Failed!Click retry!");
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
                                                                                                      await getRefreshTickersFunc(
                                                                                                          tickerSetState1: modelSetState);
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
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(12),
                                                                                                                  fontFamily: "Poppins",
                                                                                                                  fontWeight: FontWeight.w700),
                                                                                                            ),
                                                                                                            subtitle: Text(
                                                                                                              tickersCodeList[index],
                                                                                                              style: TextStyle(
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                  fontSize: text.scale(12.0),
                                                                                                                  color: const Color(0XFFA5A5A5)),
                                                                                                            ),
                                                                                                            secondary: SizedBox(
                                                                                                                height: height / 33.83,
                                                                                                                width: width / 15.625,
                                                                                                                child: tickersLogoList[index]
                                                                                                                        .contains("svg")
                                                                                                                    ? SvgPicture.network(
                                                                                                                        tickersLogoList[index],
                                                                                                                        fit: BoxFit.fill)
                                                                                                                    : Image.network(
                                                                                                                        tickersLogoList[index],
                                                                                                                        fit: BoxFit.fill)),
                                                                                                            autofocus: false,
                                                                                                            activeColor: Colors.green,
                                                                                                            value: isCheckedNew[index],
                                                                                                            onChanged: (bool? value) {
                                                                                                              if (value!) {
                                                                                                                modelSetState(() {
                                                                                                                  isCheckedNew[index] = value;
                                                                                                                  sendTickersList
                                                                                                                      .add(tickersCatIdList[index]);
                                                                                                                  sendTickersNameList
                                                                                                                      .add(tickersNameList[index]);
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
                                                                                                                      sendTickersNameList.removeAt(i);
                                                                                                                      tickerSelectAll = false;
                                                                                                                    }
                                                                                                                  }
                                                                                                                });
                                                                                                              }
                                                                                                              setState(() {
                                                                                                                if (sendTickersList.length == 1) {
                                                                                                                  _selectIndex =
                                                                                                                      sendTickersNameList[0];
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
                                                                                                          border:
                                                                                                              Border.all(color: Colors.grey.shade400),
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
                                                                                                        Navigator.pop(context, true);
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        decoration: BoxDecoration(
                                                                                                          border: Border.all(
                                                                                                              color: Colors.lightGreenAccent),
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
                                                                    trailing: Icon(Icons.keyboard_arrow_down_sharp, key: keyButton6),
                                                                  ),
                                                                ),
                                                    ],
                                                  )
                                                : Column(
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
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "Country",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.bold, fontSize: text.scale(16.0)),
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
                                                                                            if (mounted) {
                                                                                              modelSetState(() {});
                                                                                            }
                                                                                            _controller.loadComplete();
                                                                                          },
                                                                                          child: ListView.builder(
                                                                                              itemCount: countriesList.length,
                                                                                              itemBuilder: (BuildContext context, index) {
                                                                                                return index == 0
                                                                                                    ? RadioListTile(
                                                                                                        activeColor: Colors.green,
                                                                                                        controlAffinity:
                                                                                                            ListTileControlAffinity.trailing,
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
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(12),
                                                                                                              fontFamily: "Poppins",
                                                                                                              fontWeight: FontWeight.w700),
                                                                                                        ),
                                                                                                        subtitle: Text(
                                                                                                          'Use this option, if you want to create something generic',
                                                                                                          style: TextStyle(
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                              fontSize: text.scale(12.0),
                                                                                                              color: const Color(0XFFA5A5A5)),
                                                                                                        ),
                                                                                                      )
                                                                                                    : RadioListTile(
                                                                                                        activeColor: Colors.green,
                                                                                                        controlAffinity:
                                                                                                            ListTileControlAffinity.trailing,
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
                                                                                                          style: TextStyle(
                                                                                                              fontSize: text.scale(12),
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
                                                                                            onTap: () async {
                                                                                              await getTickersFunc(tickerSetState: modelSetState);
                                                                                              if (!mounted) {
                                                                                                return;
                                                                                              }
                                                                                              Navigator.pop(context, true);
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
                                                          title: Text(_selectSubCategory),
                                                          trailing: Icon(Icons.keyboard_arrow_down_sharp, key: keyButton5),
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
                                                                                    padding: EdgeInsets.only(
                                                                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: height / 54.13,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              "Commodity",
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontSize: text.scale(16.0)),
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
                                                                                              borderSide: const BorderSide(
                                                                                                  color: Color(0xffD8D8D8), width: 0.1),
                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                            ),
                                                                                            focusedBorder: OutlineInputBorder(
                                                                                              borderSide: const BorderSide(
                                                                                                  color: Color(0xffD8D8D8), width: 0.1),
                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                            ),
                                                                                            enabledBorder: OutlineInputBorder(
                                                                                              borderSide: const BorderSide(
                                                                                                  color: Color(0xffD8D8D8), width: 0.1),
                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                            ),
                                                                                            hintStyle: Theme.of(context)
                                                                                                .textTheme
                                                                                                .bodyMedium!
                                                                                                .copyWith(color: const Color(0XFFA5A5A5)),
                                                                                            hintText: 'Search here',
                                                                                            border: OutlineInputBorder(
                                                                                              borderSide: const BorderSide(
                                                                                                  color: Color(0xffD8D8D8), width: 0.1),
                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: height / 50.75,
                                                                                        ),
                                                                                        Text(
                                                                                          "Name of Commodity",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.bold,
                                                                                              fontSize: text.scale(12.0)),
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
                                                                                                  title: Text(
                                                                                                    "General",
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                        fontSize: text.scale(12.0)),
                                                                                                  ),
                                                                                                  subtitle: Text(
                                                                                                    'Use this option, if you want to create something generic',
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: text.scale(12.0),
                                                                                                        color: const Color(0XFFA5A5A5)),
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
                                                                                                  onChanged: (bool? value) {
                                                                                                    modelSetState(() {
                                                                                                      if (value!) {
                                                                                                        sendTickersList.clear();
                                                                                                        modelSetState(() {
                                                                                                          tickerSelectAll = value;
                                                                                                          sendTickersList.addAll(tickersCatIdList);
                                                                                                          _selectIndex = "multiple";
                                                                                                          getTickersFunc(
                                                                                                              tickerSetState: modelSetState);
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
                                                                                                      builder:
                                                                                                          (BuildContext context, LoadStatus? mode) {
                                                                                                        Widget body;
                                                                                                        if (mode == LoadStatus.idle) {
                                                                                                          body = const Text("pull up to load");
                                                                                                        } else if (mode == LoadStatus.loading) {
                                                                                                          body = const CupertinoActivityIndicator();
                                                                                                        } else if (mode == LoadStatus.failed) {
                                                                                                          body =
                                                                                                              const Text("Load Failed!Click retry!");
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
                                                                                                      await getRefreshTickersFunc(
                                                                                                          tickerSetState1: modelSetState);
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
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: text.scale(12),
                                                                                                                  fontFamily: "Poppins",
                                                                                                                  fontWeight: FontWeight.w700),
                                                                                                            ),
                                                                                                            subtitle: Text(
                                                                                                              tickersCodeList[index],
                                                                                                              style: TextStyle(
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                  fontSize: text.scale(12.0),
                                                                                                                  color: const Color(0XFFA5A5A5)),
                                                                                                            ),
                                                                                                            secondary: SizedBox(
                                                                                                                height: height / 33.83,
                                                                                                                width: width / 15.625,
                                                                                                                child: tickersLogoList[index]
                                                                                                                        .contains("svg")
                                                                                                                    ? SvgPicture.network(
                                                                                                                        tickersLogoList[index],
                                                                                                                        fit: BoxFit.fill)
                                                                                                                    : Image.network(
                                                                                                                        tickersLogoList[index],
                                                                                                                        fit: BoxFit.fill)),
                                                                                                            autofocus: false,
                                                                                                            activeColor: Colors.green,
                                                                                                            value: isCheckedNew[index],
                                                                                                            onChanged: (bool? value) {
                                                                                                              if (value!) {
                                                                                                                modelSetState(() {
                                                                                                                  isCheckedNew[index] = value;
                                                                                                                  sendTickersList
                                                                                                                      .add(tickersCatIdList[index]);
                                                                                                                  sendTickersNameList
                                                                                                                      .add(tickersNameList[index]);
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
                                                                                                                      sendTickersNameList.removeAt(i);
                                                                                                                      tickerSelectAll = false;
                                                                                                                    }
                                                                                                                  }
                                                                                                                });
                                                                                                              }
                                                                                                              setState(() {
                                                                                                                if (sendTickersList.length == 1) {
                                                                                                                  _selectIndex =
                                                                                                                      sendTickersNameList[0];
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
                                                                                                          border:
                                                                                                              Border.all(color: Colors.grey.shade400),
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
                                                                                                        Navigator.pop(context, true);
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        decoration: BoxDecoration(
                                                                                                          border: Border.all(
                                                                                                              color: Colors.lightGreenAccent),
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
                                                                    trailing: Icon(Icons.keyboard_arrow_down_sharp, key: keyButton6),
                                                                  ),
                                                                ),
                                                    ],
                                                  )
                                            : selectedValue == "4"
                                                ? Column(
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
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "Forex",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.bold, fontSize: text.scale(16.0)),
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
                                                                                    borderSide:
                                                                                        const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide:
                                                                                        const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderSide:
                                                                                        const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                  hintStyle: Theme.of(context)
                                                                                      .textTheme
                                                                                      .bodyMedium!
                                                                                      .copyWith(color: const Color(0XFFA5A5A5)),
                                                                                  hintText: 'Search here',
                                                                                  border: OutlineInputBorder(
                                                                                    borderSide:
                                                                                        const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                                                                                    borderRadius: BorderRadius.circular(12),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: height / 50.75,
                                                                              ),
                                                                              Text(
                                                                                "Name of Forex",
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: text.scale(12.0),
                                                                                ),
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
                                                                                        title: Text(
                                                                                          "General",
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: text.scale(12.0),
                                                                                          ),
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          'Use this option, if you want to create something generic',
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: text.scale(12.0),
                                                                                              color: const Color(0XFFA5A5A5)),
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
                                                                                            await getRefreshTickersFunc(
                                                                                                tickerSetState1: modelSetState);
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
                                                                                                    style: TextStyle(
                                                                                                        fontSize: text.scale(12),
                                                                                                        fontFamily: "Poppins",
                                                                                                        fontWeight: FontWeight.w700),
                                                                                                  ),
                                                                                                  subtitle: Text(
                                                                                                    tickersCodeList[index],
                                                                                                    style: TextStyle(
                                                                                                        fontWeight: FontWeight.w500,
                                                                                                        fontSize: text.scale(12.0),
                                                                                                        color: const Color(0XFFA5A5A5)),
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
                                                                                                  onChanged: (bool? value) {
                                                                                                    if (value!) {
                                                                                                      modelSetState(() {
                                                                                                        isCheckedNew[index] = value;
                                                                                                        sendTickersList.add(tickersCatIdList[index]);
                                                                                                        sendTickersNameList
                                                                                                            .add(tickersNameList[index]);
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
                                                                                                            sendTickersNameList.removeAt(i);
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
                                                                                              Navigator.pop(context, true);
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
                                                                                              Navigator.pop(context, true);
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
                                                          trailing: Icon(Icons.keyboard_arrow_down_sharp, key: keyButton6),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  cropImageFunc({required BuildContext context, required XFile currentImage, required String type, required StateSetter modelSetState}) async {
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(sourcePath: currentImage.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
      AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: const Color(0XFF0EA102),
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: const Color(0XFF0EA102),
          initAspectRatio: CropAspectRatioPreset.original,
          hideBottomControls: false,
          lockAspectRatio: false),
    ]);
    if (croppedFile != null) {
      pickedImage = File(croppedFile.path);
      if (!mounted) {
        return;
      }
      String imagePath = await billBoardApiMain.fileUploadBillBoard(file: pickedImage!, context: context);
      fileList.add({"file": imagePath, "file_type": type});
    }
  }

  Future<dynamic> showSheet({required BuildContext context, required StateSetter modelSetState}) async {
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
                    key: keyButton8,
                    onTap: () async {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      final image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        if (!mounted) {
                          return;
                        }
                        await cropImageFunc(
                          context: context,
                          currentImage: image,
                          type: "image",
                          modelSetState: modelSetState,
                        );
                        modelSetState(() {
                          pickedImage = File(image.path);
                          selectedUrlType = "image";
                          pickedVideo = null;
                        });
                      }
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.image_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Image",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      final video = await picker.pickVideo(source: ImageSource.gallery);
                      if (video != null) {
                        if (!mounted) {
                          return;
                        }
                        String imagePath = await billBoardApiMain.fileUploadBillBoard(file: File(video.path), context: context);
                        fileList.add({"file": imagePath, "file_type": "video"});
                        modelSetState(() {
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
                      }
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.video_library_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Video",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.of(context).pop();
                      doc = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'docx'],
                      );
                      if (doc != null) {
                        file1 = doc!.paths.map((path) => File(path!)).toList();
                        pickedFile = file1[0];
                        if (!mounted) {
                          return;
                        }
                        String imagePath = await billBoardApiMain.fileUploadBillBoard(file: pickedFile!, context: context);
                        fileList.add({"file": imagePath, "file_type": "document"});
                        modelSetState(() {
                          selectedUrlType = "document";
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
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> categoriesBottomSheet() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
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
                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 57.73,
                      ),
                      Row(
                        children: [
                          Text(
                            "Categories",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: text.scale(16.0)),
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
                                        key: keyList[index],
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
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: text.scale(12.0)),
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
                                      child: const Center(child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    key: keyButton9,
                                    onTap: () async {
                                      setState(() {
                                        selectedCategory = categoriesList[int.parse(selectedValue)];
                                        _selectSubCategory = selectedValue == "1"
                                            ? "Select a Exchange"
                                            : selectedValue == "2"
                                                ? "Select a Crypto Type"
                                                : selectedValue == "3"
                                                    ? "Select a Country"
                                                    : selectedValue == "4"
                                                        ? ""
                                                        : "";
                                        _selectIndex = selectedValue == "1"
                                            ? "Select a Ticker"
                                            : selectedValue == "2"
                                                ? "Select a Ticker"
                                                : selectedValue == "3"
                                                    ? "Select a Ticker"
                                                    : selectedValue == "4"
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
                                      selectedValue == "1"
                                          ? await getEx(newSetState1: modelSetState)
                                          : selectedValue == "2"
                                              ? await getIndustries(newSetState: setState)
                                              : selectedValue == "4"
                                                  ? await getTickersFunc(tickerSetState: setState)
                                                  : debugPrint("nothing");
                                      if (!mounted) {
                                        return;
                                      }
                                      Navigator.pop(context, true);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.lightGreenAccent),
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0XFF0EA102),
                                      ),
                                      child: const Center(child: Text("Save", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
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
  }
}
*/
