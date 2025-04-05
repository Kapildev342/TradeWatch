import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:river_player/river_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tradewatchfinal/Constants/API/Api.dart';
import 'package:tradewatchfinal/Edited_Packages/PopUpLibrary/contextual_menu.dart';
import 'package:tradewatchfinal/Edited_Packages/PopUpLibrary/popup_menu_item.dart';
import 'package:tradewatchfinal/Edited_Packages/chewieLibrary/src/chewie_player.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/src/category_icons.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/src/config.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/src/emoji_picker.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/src/recent_tab_behavior.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/my_activity_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_edit_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/questionnaire_page.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BillBoard/content_filter_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_comments_bottom_sheet.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_post_edit_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Bytes/bytes_edit_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Intermediary/intermediary.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/popular_traders_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_comments_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_main_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_response_model.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/CommentLikeButton/comment_like_button_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/LikeButtonAllWidgetBloc/like_button_all_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/LikeButtonList/like_button_list_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/MultipleLikeButton/multiple_like_button_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/SingleLikeButton/single_like_button_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/TranslationWidget/bill_board_translation_bloc.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_widgets.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/conversation_list_page.dart';

class BillBoardWidgets {
  Widget getSearchField({
    required BuildContext context,
    required StateSetter modelSetState,
    required Function billBoardFunction,
    Color? color,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => TextFormField(
        controller: mainVariables.billBoardSearchControllerMain.value,
        onChanged: (value) async {
          if (value.isEmpty || value.isEmpty) {
            billBoardFunction();
            /*billBoardApiMain.getBillBoardListApiFunc(
            context: context,
            category: mainVariables.contentCategoriesMain,
            contentType: mainVariables.contentTypeMain.value,
            profile: mainVariables.selectedProfileMain.value,
            skipBillBoardCount: 0,
            skipForumCount: 0,
            skipSurveyCount: 0,
            skipNewsCount: 0,
            tickers: [],
            userId: '',
          );
          mainVariables.valueMapListProfilePage.addAll(mainVariables.billBoardDataProfilePage!.value.response);
          mainVariables.searchDataMain = null;
          FocusManager.instance.primaryFocus?.unfocus();*/
            mainVariables.searchDataMain = null;
            FocusManager.instance.primaryFocus?.unfocus();
            mainVariables.billBoardSearchControllerMain.refresh();
            modelSetState(() {});
          } else {
            await billBoardApiMain.getSearchData(searchKey: mainVariables.billBoardSearchControllerMain.value.text, context: context);
            mainVariables.billBoardSearchControllerMain.refresh();
            modelSetState(() {});
          }
        },
        onTap: () async {
          await billBoardFunctionsMain.getSearchCountFunc();
          if (watchVariables.billBoardSearchCountCountTotalMain.value % 5 == 0) {
            functionsMain.createInterstitialAd(modelSetState: modelSetState);
          }
          if (!context.mounted) {
            return;
          }
          await billBoardApiMain.getPopularTraderData(
            searchValue: '',
            context: context,
            skip: "0",
            limit: "10",
          );
          mainVariables.searchDataMain = null;
          mainVariables.billBoardSearchControllerMain.refresh();
          modelSetState(() {});
        },
        cursorColor: Colors.green,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: Theme.of(context).textTheme.bodyMedium,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.tertiary,
          filled: true,
          suffixIcon: mainVariables.billBoardSearchControllerMain.value.text.isEmpty
              ? const SizedBox()
              : GestureDetector(
                  onTap: () {
                    billBoardFunction();
                    /*billBoardApiMain.getBillBoardListApiFunc(
                      context: context,
                      category: mainVariables.contentCategoriesMain,
                      contentType: mainVariables.contentTypeMain.value,
                      profile: mainVariables.selectedProfileMain.value,
                      skipBillBoardCount: 0,
                      skipForumCount: 0,
                      skipSurveyCount: 0,
                      skipNewsCount: 0,
                      tickers: [],
                      userId: '',
                    );
                    mainVariables.valueMapListProfilePage.addAll(mainVariables.billBoardDataProfilePage!.value.response);
                    mainVariables.searchDataMain = null;*/
                    mainVariables.billBoardSearchControllerMain.value.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                    mainVariables.billBoardSearchControllerMain.refresh();
                    modelSetState(() {});
                  },
                  child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
          ),
          contentPadding: EdgeInsets.zero,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
          hintText: 'Search here',
          // errorStyle: TextStyle(fontSize: text.scale(10))),
          errorStyle: Theme.of(context).textTheme.labelSmall,
        )));
  }

  Widget getPopularSearchField({
    required BuildContext context,
    required String forWhat,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return TextFormField(
      controller: mainVariables.popularSearchControllerMain.value,
      onChanged: (value) async {
        if (value.isEmpty || value.isEmpty) {
          if (forWhat == "popular") {
            await billBoardApiMain.getPopularTraderData(searchValue: "", context: context);
            modelSetState(() {});
          } else if (forWhat == "business") {
            await billBoardApiMain.getAllCategoriesData(
                category: mainVariables.overViewMain!.value.response.category,
                tickerId: mainVariables.selectedTickerId.value,
                skipLimit: ["0", "0", "0", "0"]);
            modelSetState(() {});
          }
          FocusManager.instance.primaryFocus?.unfocus();
        } else {
          if (forWhat == "popular") {
            await billBoardApiMain.getPopularTraderData(searchValue: mainVariables.popularSearchControllerMain.value.text, context: context);
            modelSetState(() {});
          } else if (forWhat == "business") {
            await billBoardApiMain.getAllCategoriesData(
                category: mainVariables.overViewMain!.value.response.category,
                tickerId: mainVariables.selectedTickerId.value,
                skipLimit: ["0", "0", "0", "0"]);
            modelSetState(() {});
          }
        }
      },
      cursorColor: Colors.green,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Theme.of(context).textTheme.bodyMedium,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          suffixIcon: mainVariables.popularSearchControllerMain.value.text.isEmpty
              ? const SizedBox()
              : GestureDetector(
                  onTap: () async {
                    mainVariables.popularSearchControllerMain.value.clear();
                    if (forWhat == "popular") {
                      await billBoardApiMain.getPopularTraderData(searchValue: "", context: context);
                    } else if (forWhat == "business") {
                      await billBoardApiMain.getAllCategoriesData(
                          category: mainVariables.overViewMain!.value.response.category,
                          tickerId: mainVariables.selectedTickerId.value,
                          skipLimit: ["0", "0", "0", "0"]);
                    }
                    modelSetState(() {});
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
          ),
          contentPadding: EdgeInsets.zero,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
          fillColor: Theme.of(context).colorScheme.tertiary,
          filled: true,
          hintText: 'Search here',
          errorStyle: Theme.of(context).textTheme.labelSmall),
    );
  }

  Widget getBillBoardSearchField({
    required BuildContext context,
    required StateSetter modelSetState,
    required Function billBoardFunction,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Obx(() => TextFormField(
            controller: mainVariables.billBoardListSearchControllerMain.value,
            onChanged: (value) async {
              if (value.isEmpty || value.isEmpty) {
                billBoardFunction();
                FocusManager.instance.primaryFocus?.unfocus();
                mainVariables.billBoardSearchControllerMain.refresh();
                modelSetState(() {});
              } else {
                String previousValue = value;
                Timer(const Duration(seconds: 1), () {
                  if (previousValue == mainVariables.billBoardListSearchControllerMain.value.text) {
                    billBoardFunction();
                    mainVariables.billBoardSearchControllerMain.refresh();
                    modelSetState(() {});
                  }
                });
              }
            },
            cursorColor: Colors.green,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              suffixIcon: mainVariables.billBoardListSearchControllerMain.value.text.isEmpty
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () async {
                        mainVariables.billBoardListSearchControllerMain.value.clear();
                        billBoardFunction();
                        FocusManager.instance.primaryFocus?.unfocus();
                        mainVariables.billBoardSearchControllerMain.refresh();
                        modelSetState(() {});
                      },
                      child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                    ),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
              ),
              fillColor: Theme.of(context).colorScheme.tertiary,
              filled: true,
              contentPadding: EdgeInsets.zero,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffA7A7A7), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffA7A7A7), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffA7A7A7), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
              hintText: 'Search here',
              errorStyle: Theme.of(context).textTheme.labelSmall,
            ))));
  }

  Widget getBelieversListSearchField({
    required BuildContext context,
    required String id,
    required int index,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return TextFormField(
      controller: mainVariables.believersListSearchControllerMain.value,
      onChanged: (value) async {
        if (value.isEmpty || value.isEmpty) {
          await billBoardApiMain.getBelieversListApiFunc(id: id, index: index, skip: '0');
          modelSetState(() {});
          FocusManager.instance.primaryFocus?.unfocus();
        } else {
          await billBoardApiMain.getBelieversListApiFunc(id: id, index: index, skip: '0');
          modelSetState(() {});
        }
      },
      cursorColor: Colors.green,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          suffixIcon: mainVariables.believersListSearchControllerMain.value.text.isEmpty
              ? const SizedBox()
              : GestureDetector(
                  onTap: () async {
                    mainVariables.believersListSearchControllerMain.value.clear();
                    await billBoardApiMain.getBelieversListApiFunc(id: id, index: index, skip: '0');
                    modelSetState(() {});
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: const Icon(Icons.cancel, size: 22, color: Colors.black),
                ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
          ),
          contentPadding: EdgeInsets.zero,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
          filled: true,
          hintText: 'Search here',
          errorStyle: TextStyle(fontSize: text.scale(10))),
    );
  }

  Widget getBelievedListSearchField({
    required BuildContext context,
    required String id,
    required String type,
    required StateSetter modelSetState,
    bool? isGeneral,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return TextFormField(
      controller: mainVariables.believedListSearchControllerMain.value,
      onChanged: (value) async {
        if (value.isEmpty || value.isEmpty) {
          if (isGeneral != null) {
            isGeneral
                ? await billBoardApiMain.getNotBelievedListApiFunc(id: userIdMain, skip: "0")
                : await billBoardApiMain.getBelievedListApiFunc(id: userIdMain, type: "", skip: "0");
          } else {
            await billBoardApiMain.getBelievedListApiFunc(id: id, type: type, skip: "0");
          }
          modelSetState(() {});
          FocusManager.instance.primaryFocus?.unfocus();
        } else {
          if (isGeneral != null) {
            isGeneral
                ? await billBoardApiMain.getNotBelievedListApiFunc(id: userIdMain, skip: "0")
                : await billBoardApiMain.getBelievedListApiFunc(id: userIdMain, type: "", skip: "0");
          } else {
            await billBoardApiMain.getBelievedListApiFunc(id: id, type: type, skip: "0");
          }
          modelSetState(() {});
        }
      },
      cursorColor: Colors.green,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Theme.of(context).textTheme.bodyMedium,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          suffixIcon: mainVariables.believedListSearchControllerMain.value.text.isEmpty
              ? const SizedBox()
              : GestureDetector(
                  onTap: () async {
                    mainVariables.believedListSearchControllerMain.value.clear();
                    if (isGeneral != null) {
                      isGeneral
                          ? await billBoardApiMain.getNotBelievedListApiFunc(id: userIdMain, skip: "0")
                          : await billBoardApiMain.getBelievedListApiFunc(id: userIdMain, type: "", skip: "0");
                    } else {
                      await billBoardApiMain.getBelievedListApiFunc(id: id, type: type, skip: "0");
                    }
                    modelSetState(() {});
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
          ),
          contentPadding: EdgeInsets.zero,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
          fillColor: Theme.of(context).colorScheme.tertiary,
          filled: true,
          hintText: 'Search here',
          errorStyle: TextStyle(fontSize: text.scale(10))),
    );
  }

  Widget getLikeDisLikeUsersSearchField(
      {required BuildContext context,
      required StateSetter modelSetState,
      required String billBoardType,
      required String billBoardId,
      required String responseId,
      required String commentId,
      required String action,
      required int skipLimit,
      required int selectedIndex}) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return TextFormField(
      controller: mainVariables.listDislikeUsersSearchControllerMain.value,
      onChanged: (value) async {
        if (value.isEmpty || value.isEmpty) {
          selectedIndex == 0
              ? await billBoardApiMain.getViewUsersList(
                  skipLimit: skipLimit,
                  billBoardId: billBoardId,
                  billBoardType: billBoardType,
                )
              : await billBoardApiMain.getLikeDisLikeUsersList(
                  billBoardType: billBoardType,
                  action: action,
                  billBoardId: billBoardId,
                  skipLimit: skipLimit,
                  responseId: responseId,
                  commentId: commentId);
          modelSetState(() {});
          FocusManager.instance.primaryFocus?.unfocus();
        } else {
          selectedIndex == 0
              ? await billBoardApiMain.getViewUsersList(
                  skipLimit: skipLimit,
                  billBoardId: billBoardId,
                  billBoardType: billBoardType,
                )
              : await billBoardApiMain.getLikeDisLikeUsersList(
                  billBoardType: billBoardType,
                  action: action,
                  billBoardId: billBoardId,
                  skipLimit: skipLimit,
                  responseId: responseId,
                  commentId: commentId);
          modelSetState(() {});
        }
      },
      cursorColor: Colors.green,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          suffixIcon: mainVariables.listDislikeUsersSearchControllerMain.value.text.isEmpty
              ? const SizedBox()
              : GestureDetector(
                  onTap: () async {
                    mainVariables.listDislikeUsersSearchControllerMain.value.clear();
                    await billBoardApiMain.getLikeDisLikeUsersList(
                        billBoardType: billBoardType,
                        action: action,
                        billBoardId: billBoardId,
                        responseId: responseId,
                        commentId: commentId,
                        skipLimit: skipLimit);
                    modelSetState(() {});
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: const Icon(Icons.cancel, size: 22, color: Colors.black),
                ),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
          ),
          contentPadding: EdgeInsets.zero,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
          filled: true,
          hintText: 'Search here',
          errorStyle: TextStyle(fontSize: text.scale(10))),
    );
  }

  Widget getMessageBadge({required BuildContext context, Function? initState}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return GestureDetector(
      onTap: () {
        if (mainSkipValue) {
          commonFlushBar(context: context, initFunction: initState);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ConversationListPage()));
        }
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: height / 25.02,
            width: width / 11.74,
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              isDarkTheme.value ? "assets/home_screen/messages_dark.png" : "lib/Constants/Assets/BillBoard/messages.png",
              fit: BoxFit.fill,
            ),
          ),
          Obx(() => badgeMessageCount.value == 0
              ? const SizedBox()
              : Container(
                  height: height / 50,
                  width: width / 25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0XFFF5103A),
                  ),
                  child: Center(
                      child: Text(
                    badgeMessageCount.value > 99 ? "99+" : badgeMessageCount.value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: badgeMessageCount.value.toString().length == 1
                          ? text.scale(10)
                          : badgeMessageCount.value.toString().length == 2
                              ? text.scale(8)
                              : text.scale(6),
                    ),
                  )),
                ))
        ],
      ),
    );
  }

  Widget getProfile({
    required BuildContext context,
    required double heightValue,
    required double widthValue,
    required String userId,
    required bool myself,
    Function? getBillBoardListData,
    String? repostAvatar,
    String? repostUserId,
    String? isRepostProfile,
    String? avatar,
    required String isProfile,
  }) {
    return myself
        ? Obx(() => GestureDetector(
              onTap: () async {
                if (isProfile != "intermediate" || isProfile != "user") {
                  mainVariables.selectedTickerId.value = userId;
                }
                bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return isProfile == "intermediate"
                      ? IntermediaryBillBoardProfilePage(userId: userId)
                      : isProfile != 'user'
                          ? const BusinessProfilePage()
                          : UserBillBoardProfilePage(userId: userId);
                }));
                if (response && getBillBoardListData != null) {
                  getBillBoardListData();
                }
                /*Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return UserBillBoardProfilePage(
                      userId: userIdMain);
                }));*/
              },
              child: Container(
                height: heightValue,
                width: heightValue,
                decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(avatarMain.value), fit: BoxFit.fill)),
              ),
            ))
        : Stack(
            alignment: Alignment.bottomRight,
            children: [
              GestureDetector(
                  onTap: () async {
                    if (isProfile != "intermediate" || isProfile != "user") {
                      mainVariables.selectedTickerId.value = userId;
                    }
                    bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return isProfile == "intermediate"
                          ? IntermediaryBillBoardProfilePage(userId: userId)
                          : isProfile != 'user'
                              ? const BusinessProfilePage()
                              : UserBillBoardProfilePage(userId: userId);
                    }));
                    if (response && getBillBoardListData != null) {
                      getBillBoardListData();
                    }
                  },
                  child: Container(
                    height: heightValue,
                    width: widthValue,
                    decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(avatar ?? ''), fit: BoxFit.fill)),
                  )),
              repostAvatar != null
                  ? GestureDetector(
                      onTap: () {
                        if (isRepostProfile != "intermediate" || isRepostProfile != "user") {
                          mainVariables.selectedTickerId.value = repostUserId ?? "";
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return isRepostProfile == "intermediate"
                              ? IntermediaryBillBoardProfilePage(userId: repostUserId ?? "")
                              : isRepostProfile != 'user'
                                  ? const BusinessProfilePage()
                                  : UserBillBoardProfilePage(userId: repostUserId ?? "");
                        }));
                      },
                      child: Container(
                        height: heightValue / 2,
                        width: widthValue / 2,
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(repostAvatar), fit: BoxFit.fill)),
                      ))
                  : const SizedBox()
            ],
          );
  }

  Widget getChatProfile(
      {required BuildContext context,
      required double heightValue,
      required double widthValue,
      required String userId,
      required List<bool> isChecked,
      required bool isCreateGroup,
      String? avatar,
      required String isProfile,
      required StateSetter modelSetState,
      required int index}) {
    return isCreateGroup
        ? GestureDetector(
            onTap: () {
              if (isChecked[index]) {
                modelSetState(() {
                  isChecked[index] = false;
                });
              } else {
                if (isProfile == "intermediate" || isProfile == "user") {
                  mainVariables.selectedTickerId.value = userId;
                }
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return isProfile == "intermediate"
                      ? IntermediaryBillBoardProfilePage(userId: userId)
                      : isProfile != 'user'
                          ? const BusinessProfilePage()
                          : UserBillBoardProfilePage(userId: userId);
                }));
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: heightValue,
                  width: heightValue,
                  decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(avatar ?? ''), fit: BoxFit.fill)),
                ),
                isCreateGroup
                    ? isChecked[index]
                        ? Container(
                            height: heightValue,
                            width: heightValue,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black26.withOpacity(0.3)),
                            child: const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 35,
                            ),
                          )
                        : const SizedBox()
                    : const SizedBox(),
              ],
            ))
        : GestureDetector(
            onTap: () {
              if (isProfile == "intermediate" || isProfile == "user") {
                mainVariables.selectedTickerId.value = userId;
              }
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return isProfile == "intermediate"
                    ? IntermediaryBillBoardProfilePage(userId: userId)
                    : isProfile != 'user'
                        ? const BusinessProfilePage()
                        : UserBillBoardProfilePage(userId: userId);
              }));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: heightValue,
                  width: heightValue,
                  decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(avatar ?? ''), fit: BoxFit.fill)),
                ),
                isCreateGroup
                    ? isChecked[index]
                        ? Container(
                            height: heightValue,
                            width: heightValue,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black26.withOpacity(0.3)),
                            child: const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 35,
                            ),
                          )
                        : const SizedBox()
                    : const SizedBox(),
              ],
            ));
  }

  Widget likeButtonHomeListWidget(
      {required List<BillboardMainModelResponse> valueMapList,
      required List<bool> likeList,
      required List<bool> dislikeList,
      required List<int> likeCountList,
      required List<int> dislikeCountList,
      List<FocusNode>? responseFocusList,
      required String id,
      required String responseId,
      required String commentId,
      required String postUserId,
      required String responseUserId,
      required String type,
      required String billBoardType,
      required String fromWhere,
      required int index,
      required BuildContext context,
      double? scale,
      Color? color,
      bool? enabled,
      required String image,
      String? title,
      String? description,
      required Function initFunction,
      required TextEditingController controller,
      required StateSetter modelSetState,
      required bool notUse}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<LikeButtonListWidgetBloc, LikeButtonListWidgetState>(
      builder: (context, state) {
        if (state is LikeButtonListLoadedState) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: enabled == false
                      ? () {}
                      : () async {
                          if (mainSkipValue) {
                            commonFlushBar(context: context, initFunction: initFunction);
                          } else {
                            context.read<LikeButtonListWidgetBloc>().add(LikeButtonListInitialEvent(
                                id: id,
                                type: "likes",
                                index: index,
                                context: context,
                                initFunction: notUse ? initFunction : () {},
                                setState: modelSetState,
                                likeList: state.likeList,
                                dislikeList: state.dislikeList,
                                likeCountList: likeCountList,
                                dislikeCountList: dislikeCountList,
                                responseId: responseId,
                                commentId: commentId,
                                billBoardType: billBoardType,
                                valueMapList: state.valueMapList));
                          }
                        },
                  child: Center(
                    child: SvgPicture.asset(
                      state.valueMapList[index].like
                          ? isDarkTheme.value
                              ? "assets/home_screen/like_filled_dark.svg"
                              : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                          : isDarkTheme.value
                              ? "assets/home_screen/like_dark.svg"
                              : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                      height: height / 40.6,
                      width: width / 18.75,
                    ),
                  ),
                ),
                fromWhere == "response" || fromWhere == "comments" ? const SizedBox() : SizedBox(width: width / 25),
                fromWhere == "response" || fromWhere == "comments"
                    ? const SizedBox()
                    : billboardWidgetsMain.getShareRepostButton(
                        context: context,
                        id: id,
                        type: type,
                        imageUrl: image,
                        title: title ?? "",
                        description: description ?? "",
                        heightValue: height / 40.6,
                        widthValue: width / 18.75,
                        repostUserName: valueMapList[index].username,
                        profileType: valueMapList[index].profileType,
                        tickerId: valueMapList[index].tickerId,
                        postUserId: postUserId,
                        billBoardType: billBoardType,
                        category: valueMapList[index].category),
                SizedBox(width: width / 25),
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<LikeButtonListWidgetBloc>().add(LikeButtonListInitialEvent(
                                  id: id,
                                  type: 'dislikes',
                                  dislikeList: state.dislikeList,
                                  likeList: state.likeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                  valueMapList: state.valueMapList));
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        state.valueMapList[index].dislike
                            ? isDarkTheme.value
                                ? "assets/home_screen/dislike_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/dislike_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                SizedBox(width: width / 25),
                valueMapList[index].profileType == "intermediate"
                    ? const SizedBox()
                    : billboardWidgetsMain.getCommentButton(
                        heightValue: height / 40.6,
                        widthValue: width / 18.75,
                        fromWhere: fromWhere,
                        context: context,
                        controller: controller,
                        billBoardId: id,
                        postUserId: postUserId,
                        responseId: responseId,
                        responseUserId: responseUserId,
                        commentId: "",
                        callFunction: initFunction,
                        responseFocusList: responseFocusList ?? [],
                        index: index,
                        modelSetState: modelSetState,
                        billBoardType: billBoardType,
                      ),
              ],
            ),
          );
        } else if (state is LikeButtonListLoadingState) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<LikeButtonListWidgetBloc>().add(LikeButtonListInitialEvent(
                                  id: id,
                                  type: "likes",
                                  likeList: likeList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  dislikeList: dislikeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                  valueMapList: valueMapList));
                              initFunction();
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        valueMapList[index].like
                            ? isDarkTheme.value
                                ? "assets/home_screen/like_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/like_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                fromWhere == "response" || fromWhere == "comments" ? const SizedBox() : SizedBox(width: width / 25),
                fromWhere == "response" || fromWhere == "comments"
                    ? const SizedBox()
                    : billboardWidgetsMain.getShareRepostButton(
                        context: context,
                        id: id,
                        type: type,
                        billBoardType: billBoardType,
                        imageUrl: image,
                        title: title ?? "",
                        description: description ?? "",
                        heightValue: height / 40.6,
                        widthValue: width / 18.75,
                        repostUserName: valueMapList[index].username,
                        profileType: valueMapList[index].profileType,
                        tickerId: valueMapList[index].tickerId,
                        postUserId: postUserId,
                        category: valueMapList[index].category),
                SizedBox(width: width / 25),
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<LikeButtonListWidgetBloc>().add(LikeButtonListInitialEvent(
                                  id: id,
                                  type: 'dislikes',
                                  dislikeList: dislikeList,
                                  likeList: likeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                  valueMapList: valueMapList));
                              initFunction();
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        valueMapList[index].dislike
                            ? isDarkTheme.value
                                ? "assets/home_screen/dislike_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/dislike_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                SizedBox(width: width / 25),
                valueMapList[index].profileType == "intermediate"
                    ? const SizedBox()
                    : billboardWidgetsMain.getCommentButton(
                        heightValue: height / 40.6,
                        widthValue: width / 18.75,
                        fromWhere: fromWhere,
                        context: context,
                        controller: controller,
                        billBoardId: id,
                        postUserId: postUserId,
                        responseId: responseId,
                        responseUserId: responseUserId,
                        commentId: "",
                        index: index,
                        callFunction: initFunction,
                        responseFocusList: responseFocusList ?? [],
                        modelSetState: modelSetState,
                        billBoardType: billBoardType),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget likeButtonBookMarkListWidget(
      {required List<BillboardMainModelResponse> valueMapList,
      required List<bool> likeList,
      required List<bool> dislikeList,
      required List<int> likeCountList,
      required List<int> dislikeCountList,
      List<FocusNode>? responseFocusList,
      required String id,
      required String responseId,
      required String commentId,
      required String postUserId,
      required String responseUserId,
      required String type,
      required String billBoardType,
      required String fromWhere,
      required int index,
      required BuildContext context,
      double? scale,
      Color? color,
      bool? enabled,
      String? image,
      String? title,
      String? description,
      required Function initFunction,
      required TextEditingController controller,
      required StateSetter modelSetState,
      required bool notUse}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<LikeButtonListWidgetBloc, LikeButtonListWidgetState>(
      builder: (context, state) {
        if (state is LikeButtonListLoadedState) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: enabled == false
                      ? () {}
                      : () async {
                          if (mainSkipValue) {
                            commonFlushBar(context: context, initFunction: initFunction);
                          } else {
                            context.read<LikeButtonListWidgetBloc>().add(LikeButtonListInitialEvent(
                                id: id,
                                type: "likes",
                                index: index,
                                context: context,
                                initFunction: notUse ? initFunction : () {},
                                setState: modelSetState,
                                likeList: state.likeList,
                                dislikeList: state.dislikeList,
                                likeCountList: likeCountList,
                                dislikeCountList: dislikeCountList,
                                responseId: responseId,
                                commentId: commentId,
                                billBoardType: billBoardType,
                                valueMapList: state.valueMapList));
                          }
                        },
                  child: Center(
                    child: SvgPicture.asset(
                      state.valueMapList[index].like
                          ? isDarkTheme.value
                              ? "assets/home_screen/like_filled_dark.svg"
                              : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                          : isDarkTheme.value
                              ? "assets/home_screen/like_dark.svg"
                              : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                      height: height / 57.73,
                      width: width / 27.4,
                    ),
                  ),
                ),
                fromWhere == "response" || fromWhere == "comments" ? const SizedBox() : SizedBox(width: width / 25),
                fromWhere == "response" || fromWhere == "comments"
                    ? const SizedBox()
                    : billboardWidgetsMain.getShareRepostButton(
                        context: context,
                        id: id,
                        type: type,
                        imageUrl: image ?? "",
                        title: title ?? "",
                        description: description ?? "",
                        heightValue: height / 57.73,
                        widthValue: width / 27.4,
                        billBoardType: billBoardType,
                        repostUserName: valueMapList[index].username,
                        profileType: valueMapList[index].profileType,
                        tickerId: valueMapList[index].tickerId,
                        postUserId: postUserId,
                        category: valueMapList[index].category),
                SizedBox(width: width / 25),
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<LikeButtonListWidgetBloc>().add(LikeButtonListInitialEvent(
                                  id: id,
                                  type: 'dislikes',
                                  dislikeList: state.dislikeList,
                                  likeList: state.likeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                  valueMapList: state.valueMapList));
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        state.valueMapList[index].dislike
                            ? isDarkTheme.value
                                ? "assets/home_screen/dislike_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/dislike_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                        height: height / 57.73,
                        width: width / 27.4,
                      ),
                    )),
                SizedBox(width: width / 25),
                billboardWidgetsMain.getCommentButton(
                  heightValue: height / 57.73,
                  widthValue: width / 27.4,
                  fromWhere: fromWhere,
                  context: context,
                  controller: controller,
                  billBoardId: id,
                  postUserId: postUserId,
                  responseId: responseId,
                  responseUserId: responseUserId,
                  commentId: "",
                  callFunction: initFunction,
                  responseFocusList: responseFocusList ?? [],
                  index: index,
                  modelSetState: modelSetState,
                  billBoardType: billBoardType,
                ),
              ],
            ),
          );
        } else if (state is LikeButtonListLoadingState) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<LikeButtonListWidgetBloc>().add(LikeButtonListInitialEvent(
                                  id: id,
                                  type: "likes",
                                  likeList: likeList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  dislikeList: dislikeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                  valueMapList: valueMapList));
                              initFunction();
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        valueMapList[index].like
                            ? isDarkTheme.value
                                ? "assets/home_screen/like_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/like_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                        height: height / 57.73,
                        width: width / 27.4,
                      ),
                    )),
                fromWhere == "response" || fromWhere == "comments" ? const SizedBox() : SizedBox(width: width / 25),
                fromWhere == "response" || fromWhere == "comments"
                    ? const SizedBox()
                    : billboardWidgetsMain.getShareRepostButton(
                        context: context,
                        id: id,
                        type: type,
                        imageUrl: image ?? "",
                        title: title ?? "",
                        description: description ?? "",
                        heightValue: height / 57.73,
                        widthValue: width / 27.4,
                        repostUserName: valueMapList[index].username,
                        profileType: valueMapList[index].profileType,
                        tickerId: valueMapList[index].tickerId,
                        postUserId: postUserId,
                        billBoardType: billBoardType,
                        category: valueMapList[index].category),
                SizedBox(width: width / 25),
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<LikeButtonListWidgetBloc>().add(LikeButtonListInitialEvent(
                                  id: id,
                                  type: 'dislikes',
                                  dislikeList: dislikeList,
                                  likeList: likeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                  valueMapList: valueMapList));
                              initFunction();
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        valueMapList[index].dislike
                            ? isDarkTheme.value
                                ? "assets/home_screen/dislike_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/dislike_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                        height: height / 57.73,
                        width: width / 27.4,
                      ),
                    )),
                SizedBox(width: width / 25),
                billboardWidgetsMain.getCommentButton(
                    heightValue: height / 57.73,
                    widthValue: width / 27.4,
                    fromWhere: fromWhere,
                    context: context,
                    controller: controller,
                    billBoardId: id,
                    postUserId: postUserId,
                    responseId: responseId,
                    responseUserId: responseUserId,
                    commentId: "",
                    index: index,
                    callFunction: initFunction,
                    responseFocusList: responseFocusList ?? [],
                    modelSetState: modelSetState,
                    billBoardType: billBoardType),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget billBoardBookMarkWidget({
    required BuildContext context,
    required int index,
  }) {
    return GestureDetector(
        onTap: () async {
          bool response = await billBoardApiMain.bookMarkAddRemove(
              id: mainVariables.valueMapListProfilePage[index].id,
              type: mainVariables.valueMapListProfilePage[index].type == "byte" || mainVariables.valueMapListProfilePage[index].type == "blog"
                  ? "billboard"
                  : mainVariables.valueMapListProfilePage[index].type,
              context: context);
          if (response) {
            mainVariables.valueMapListProfilePage[index].bookmarks.value = !mainVariables.valueMapListProfilePage[index].bookmarks.value;
          }
        },
        child: Obx(
          () => Image.asset(
            mainVariables.valueMapListProfilePage[index].bookmarks.value
                ? isDarkTheme.value
                    ? "assets/home_screen/bookmark_filled_dark.png"
                    : "assets/home_screen/bookmark_filled.png"
                : isDarkTheme.value
                    ? "assets/home_screen/bookmark_dark.png"
                    : "assets/home_screen/bookmark.png",
            scale: mainVariables.valueMapListProfilePage[index].bookmarks.value ? 3.2 : 3.2,
            //color: const Color(0XFF169A0D),
          ),
        ));
  }

  Widget likeButtonListWidget(
      {required List<bool> likeList,
      required List<bool> dislikeList,
      required List<int> likeCountList,
      required List<int> dislikeCountList,
      List<FocusNode>? responseFocusList,
      required String id,
      required String responseId,
      required String commentId,
      required String postUserId,
      required String responseUserId,
      required String type,
      required String billBoardType,
      required String fromWhere,
      required String repostUserName,
      required String profileType,
      required String tickerId,
      required String category,
      required int index,
      required BuildContext context,
      double? scale,
      Color? color,
      bool? enabled,
      String? image,
      String? title,
      String? description,
      required Function initFunction,
      required TextEditingController controller,
      required StateSetter modelSetState,
      required bool notUse}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<LikeButtonAllWidgetBloc, LikeButtonAllWidgetState>(
      builder: (context, state) {
        if (state is LikeButtonAllLoadedState) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: enabled == false
                      ? () {}
                      : () async {
                          if (mainSkipValue) {
                            commonFlushBar(context: context, initFunction: initFunction);
                          } else {
                            context.read<LikeButtonAllWidgetBloc>().add(LikeButtonAllInitialEvent(
                                  id: id,
                                  type: "likes",
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  likeList: state.likeList,
                                  dislikeList: state.dislikeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                ));
                          }
                        },
                  child: Center(
                    child: SvgPicture.asset(
                      state.likeList[index]
                          ? isDarkTheme.value
                              ? "assets/home_screen/like_filled_dark.svg"
                              : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                          : isDarkTheme.value
                              ? "assets/home_screen/like_dark.svg"
                              : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                      height: height / 40.6,
                      width: width / 18.75,
                    ),
                  ),
                ),
                fromWhere == "response" || fromWhere == "comments" ? const SizedBox() : SizedBox(width: width / 25),
                fromWhere == "response" || fromWhere == "comments"
                    ? const SizedBox()
                    : billboardWidgetsMain.getShareRepostButton(
                        context: context,
                        id: id,
                        type: type,
                        imageUrl: image ?? "",
                        title: title ?? "",
                        description: description ?? "",
                        heightValue: height / 40.6,
                        widthValue: width / 18.75,
                        repostUserName: repostUserName,
                        profileType: profileType,
                        tickerId: tickerId,
                        postUserId: postUserId,
                        billBoardType: billBoardType,
                        category: category),
                SizedBox(width: width / 25),
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<LikeButtonAllWidgetBloc>().add(LikeButtonAllInitialEvent(
                                  id: id,
                                  type: 'dislikes',
                                  dislikeList: state.dislikeList,
                                  likeList: state.likeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType));
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        state.dislikeList[index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/dislike_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/dislike_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                SizedBox(width: width / 25),
                billboardWidgetsMain.getCommentButton(
                  heightValue: height / 40.6,
                  widthValue: width / 18.75,
                  fromWhere: fromWhere,
                  context: context,
                  controller: controller,
                  billBoardId: id,
                  postUserId: postUserId,
                  responseId: responseId,
                  responseUserId: responseUserId,
                  commentId: "",
                  callFunction: initFunction,
                  responseFocusList: responseFocusList ?? [],
                  index: index,
                  modelSetState: modelSetState,
                  billBoardType: billBoardType,
                ),
              ],
            ),
          );
        } else if (state is LikeButtonAllLoadingState) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<LikeButtonAllWidgetBloc>().add(LikeButtonAllInitialEvent(
                                  id: id,
                                  type: "likes",
                                  likeList: likeList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  dislikeList: dislikeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType));
                              initFunction();
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        likeList[index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/like_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/like_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                fromWhere == "response" || fromWhere == "comments" ? const SizedBox() : SizedBox(width: width / 25),
                fromWhere == "response" || fromWhere == "comments"
                    ? const SizedBox()
                    : billboardWidgetsMain.getShareRepostButton(
                        context: context,
                        id: id,
                        type: type,
                        imageUrl: image ?? "",
                        title: title ?? "",
                        description: description ?? "",
                        heightValue: height / 40.6,
                        widthValue: width / 18.75,
                        repostUserName: repostUserName,
                        profileType: profileType,
                        tickerId: tickerId,
                        postUserId: postUserId,
                        billBoardType: billBoardType,
                        category: category),
                SizedBox(width: width / 25),
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<LikeButtonAllWidgetBloc>().add(LikeButtonAllInitialEvent(
                                  id: id,
                                  type: 'dislikes',
                                  dislikeList: dislikeList,
                                  likeList: likeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType));
                              initFunction();
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        dislikeList[index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/dislike_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/dislike_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                SizedBox(width: width / 25),
                billboardWidgetsMain.getCommentButton(
                    heightValue: height / 40.6,
                    widthValue: width / 18.75,
                    fromWhere: fromWhere,
                    context: context,
                    controller: controller,
                    billBoardId: id,
                    postUserId: postUserId,
                    responseId: responseId,
                    responseUserId: responseUserId,
                    commentId: "",
                    index: index,
                    callFunction: initFunction,
                    responseFocusList: responseFocusList ?? [],
                    modelSetState: modelSetState,
                    billBoardType: billBoardType),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget multipleLikeButtonListWidget(
      {required List<List<bool>> likeList,
      required List<List<bool>> dislikeList,
      required List<List<int>> likeCountList,
      required List<List<int>> dislikeCountList,
      List<FocusNode>? responseFocusList,
      required String id,
      required String responseId,
      required String commentId,
      required String postUserId,
      required String responseUserId,
      required String type,
      required String billBoardType,
      required String fromWhere,
      required String repostUserName,
      required String profileType,
      required String tickerId,
      required String category,
      required int index,
      required int lockerIndex,
      required BuildContext context,
      double? scale,
      Color? color,
      bool? enabled,
      String? image,
      String? title,
      String? description,
      required Function initFunction,
      required TextEditingController controller,
      required StateSetter modelSetState,
      required bool notUse}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<MultipleLikeButtonBloc, MultipleLikeButtonState>(
      builder: (context, state) {
        if (state is MultipleLikeButtonListLoadedState) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<MultipleLikeButtonBloc>().add(MultipleLikeButtonListInitialEvent(
                                  id: id,
                                  type: "likes",
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  likeList: state.likeList,
                                  dislikeList: state.dislikeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                  lockerIndex: lockerIndex));
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        state.likeList[lockerIndex][index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/like_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/like_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                fromWhere == "response" || fromWhere == "comments" ? const SizedBox() : SizedBox(width: width / 25),
                fromWhere == "response" || fromWhere == "comments"
                    ? const SizedBox()
                    : billboardWidgetsMain.getShareRepostButton(
                        context: context,
                        id: id,
                        type: type,
                        imageUrl: image ?? "",
                        title: title ?? "",
                        description: description ?? "",
                        heightValue: height / 40.6,
                        widthValue: width / 18.75,
                        repostUserName: repostUserName,
                        profileType: profileType,
                        tickerId: tickerId,
                        postUserId: postUserId,
                        billBoardType: billBoardType,
                        category: category),
                SizedBox(width: width / 25),
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<MultipleLikeButtonBloc>().add(MultipleLikeButtonListInitialEvent(
                                  id: id,
                                  type: 'dislikes',
                                  dislikeList: state.dislikeList,
                                  likeList: state.likeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                  lockerIndex: lockerIndex));
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        state.dislikeList[lockerIndex][index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/dislike_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/dislike_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                SizedBox(width: width / 25),
                billboardWidgetsMain.getCommentButton(
                    heightValue: height / 40.6,
                    widthValue: width / 18.75,
                    fromWhere: fromWhere,
                    context: context,
                    controller: controller,
                    billBoardId: id,
                    postUserId: postUserId,
                    responseId: responseId,
                    responseUserId: responseUserId,
                    commentId: "",
                    index: index,
                    callFunction: initFunction,
                    responseFocusList: responseFocusList ?? [],
                    modelSetState: modelSetState,
                    billBoardType: billBoardType),
              ],
            ),
          );
        } else if (state is MultipleLikeButtonListLoadingState) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<MultipleLikeButtonBloc>().add(MultipleLikeButtonListInitialEvent(
                                  id: id,
                                  type: "likes",
                                  likeList: likeList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  dislikeList: dislikeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                  lockerIndex: lockerIndex));
                              initFunction();
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        likeList[lockerIndex][index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/like_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/like_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                fromWhere == "response" || fromWhere == "comments" ? const SizedBox() : SizedBox(width: width / 25),
                fromWhere == "response" || fromWhere == "comments"
                    ? const SizedBox()
                    : billboardWidgetsMain.getShareRepostButton(
                        context: context,
                        id: id,
                        type: type,
                        imageUrl: image ?? "",
                        title: title ?? "",
                        description: description ?? "",
                        heightValue: height / 40.6,
                        widthValue: width / 18.75,
                        repostUserName: repostUserName,
                        profileType: profileType,
                        tickerId: tickerId,
                        postUserId: postUserId,
                        billBoardType: billBoardType,
                        category: category),
                SizedBox(width: width / 25),
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<MultipleLikeButtonBloc>().add(MultipleLikeButtonListInitialEvent(
                                  id: id,
                                  type: 'dislikes',
                                  dislikeList: dislikeList,
                                  likeList: likeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType,
                                  lockerIndex: lockerIndex));
                              initFunction();
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        dislikeList[lockerIndex][index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/dislike_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/dislike_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                SizedBox(width: width / 25),
                billboardWidgetsMain.getCommentButton(
                    heightValue: height / 40.6,
                    widthValue: width / 18.75,
                    fromWhere: fromWhere,
                    context: context,
                    controller: controller,
                    billBoardId: id,
                    postUserId: postUserId,
                    responseId: responseId,
                    responseUserId: responseUserId,
                    commentId: "",
                    index: index,
                    callFunction: initFunction,
                    responseFocusList: responseFocusList ?? [],
                    modelSetState: modelSetState,
                    billBoardType: billBoardType),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget commentLikeButtonListWidget(
      {required List<bool> likeList,
      required List<bool> dislikeList,
      required List<int> likeCountList,
      required List<int> dislikeCountList,
      List<FocusNode>? responseFocusList,
      required String id,
      required String responseId,
      required String commentId,
      required String postUserId,
      required String responseUserId,
      required String type,
      required String billBoardType,
      required String fromWhere,
      required String repostUserName,
      required String profileType,
      required String tickerId,
      required String category,
      required int index,
      required BuildContext context,
      double? scale,
      Color? color,
      bool? enabled,
      String? image,
      String? title,
      String? description,
      required Function initFunction,
      required TextEditingController controller,
      required StateSetter modelSetState,
      required bool notUse}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<CommentLikeButtonBloc, CommentLikeButtonState>(
      builder: (context, state) {
        if (state is CommentLikeButtonListLoadedState) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<CommentLikeButtonBloc>().add(CommentLikeButtonListInitialEvent(
                                  id: id,
                                  type: "likes",
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  likeList: state.likeList,
                                  dislikeList: state.dislikeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType));
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        state.likeList[index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/like_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/like_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                fromWhere == "response" || fromWhere == "comments" ? const SizedBox() : SizedBox(width: width / 25),
                fromWhere == "response" || fromWhere == "comments"
                    ? const SizedBox()
                    : billboardWidgetsMain.getShareRepostButton(
                        context: context,
                        id: id,
                        type: type,
                        imageUrl: image ?? "",
                        title: title ?? "",
                        description: description ?? "",
                        heightValue: height / 40.6,
                        widthValue: width / 18.75,
                        repostUserName: repostUserName,
                        profileType: profileType,
                        tickerId: tickerId,
                        postUserId: postUserId,
                        billBoardType: billBoardType,
                        category: category),
                SizedBox(width: width / 25),
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<CommentLikeButtonBloc>().add(CommentLikeButtonListInitialEvent(
                                  id: id,
                                  type: 'dislikes',
                                  dislikeList: state.dislikeList,
                                  likeList: state.likeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType));
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        state.dislikeList[index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/dislike_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/dislike_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                SizedBox(width: width / 25),
                billboardWidgetsMain.getCommentButton(
                    heightValue: height / 40.6,
                    widthValue: width / 18.75,
                    fromWhere: fromWhere,
                    context: context,
                    controller: controller,
                    billBoardId: id,
                    postUserId: postUserId,
                    responseId: responseId,
                    responseUserId: responseUserId,
                    commentId: "",
                    index: index,
                    callFunction: initFunction,
                    responseFocusList: responseFocusList ?? [],
                    modelSetState: modelSetState,
                    billBoardType: billBoardType),
              ],
            ),
          );
        } else if (state is CommentLikeButtonListLoadingState) {
          return Container(
            margin: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<CommentLikeButtonBloc>().add(CommentLikeButtonListInitialEvent(
                                  id: id,
                                  type: "likes",
                                  likeList: likeList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  dislikeList: dislikeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType));
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        likeList[index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/like_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/like_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                fromWhere == "response" || fromWhere == "comments" ? const SizedBox() : SizedBox(width: width / 25),
                fromWhere == "response" || fromWhere == "comments"
                    ? const SizedBox()
                    : billboardWidgetsMain.getShareRepostButton(
                        context: context,
                        id: id,
                        type: type,
                        imageUrl: image ?? "",
                        title: title ?? "",
                        description: description ?? "",
                        heightValue: height / 40.6,
                        widthValue: width / 18.75,
                        repostUserName: repostUserName,
                        profileType: profileType,
                        tickerId: tickerId,
                        postUserId: postUserId,
                        billBoardType: billBoardType,
                        category: category),
                SizedBox(width: width / 25),
                GestureDetector(
                    onTap: enabled == false
                        ? () {}
                        : () async {
                            if (mainSkipValue) {
                              commonFlushBar(context: context, initFunction: initFunction);
                            } else {
                              context.read<CommentLikeButtonBloc>().add(CommentLikeButtonListInitialEvent(
                                  id: id,
                                  type: 'dislikes',
                                  dislikeList: dislikeList,
                                  likeList: likeList,
                                  likeCountList: likeCountList,
                                  dislikeCountList: dislikeCountList,
                                  index: index,
                                  context: context,
                                  initFunction: notUse ? initFunction : () {},
                                  setState: modelSetState,
                                  responseId: responseId,
                                  commentId: commentId,
                                  billBoardType: billBoardType));
                            }
                          },
                    child: Center(
                      child: SvgPicture.asset(
                        dislikeList[index]
                            ? isDarkTheme.value
                                ? "assets/home_screen/dislike_filled_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                            : isDarkTheme.value
                                ? "assets/home_screen/dislike_dark.svg"
                                : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                        height: height / 40.6,
                        width: width / 18.75,
                      ),
                    )),
                SizedBox(width: width / 25),
                billboardWidgetsMain.getCommentButton(
                    heightValue: height / 40.6,
                    widthValue: width / 18.75,
                    fromWhere: fromWhere,
                    context: context,
                    controller: controller,
                    billBoardId: id,
                    postUserId: postUserId,
                    responseId: responseId,
                    responseUserId: responseUserId,
                    index: index,
                    commentId: "",
                    billBoardType: billBoardType,
                    modelSetState: modelSetState,
                    responseFocusList: responseFocusList ?? [],
                    callFunction: initFunction),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget singleLikeButtonListWidget(
      {required List<bool> likeList,
      required List<bool> dislikeList,
      required List<int> likeCountList,
      required List<int> dislikeCountList,
      required FocusNode responseFocus,
      required String id,
      required String responseId,
      required String commentId,
      required String postUserId,
      required String responseUserId,
      required String type,
      required String billBoardType,
      required String fromWhere,
      required String repostUserName,
      required String profileType,
      required String tickerId,
      required String category,
      required int index,
      required BuildContext context,
      double? scale,
      Color? color,
      bool? enabled,
      String? image,
      String? title,
      String? description,
      required Function initFunction,
      required TextEditingController controller,
      required StateSetter modelSetState,
      required bool notUse}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BlocBuilder<SingleLikeButtonBloc, SingleLikeButtonState>(
      builder: (context, state) {
        if (state is SingleLikeButtonListLoadedState) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: enabled == false
                          ? () {}
                          : () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initFunction);
                              } else {
                                context.read<SingleLikeButtonBloc>().add(SingleLikeButtonListInitialEvent(
                                    id: id,
                                    type: "likes",
                                    index: index,
                                    context: context,
                                    initFunction: notUse ? initFunction : () {},
                                    setState: modelSetState,
                                    likeList: state.likeList,
                                    dislikeList: state.dislikeList,
                                    likeCountList: likeCountList,
                                    dislikeCountList: dislikeCountList,
                                    responseId: responseId,
                                    commentId: commentId,
                                    billBoardType: billBoardType));
                              }
                            },
                      child: Center(
                        child: SvgPicture.asset(
                          state.likeList[index]
                              ? isDarkTheme.value
                                  ? "assets/home_screen/like_filled_dark.svg"
                                  : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                              : isDarkTheme.value
                                  ? "assets/home_screen/like_dark.svg"
                                  : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                          height: height / 40.6,
                          width: width / 18.75,
                        ),
                      )),
                  fromWhere == "response" || fromWhere == "comments"
                      ? const SizedBox()
                      : billboardWidgetsMain.getShareRepostButton(
                          context: context,
                          id: id,
                          type: type,
                          imageUrl: image ?? "",
                          title: title ?? "",
                          description: description ?? "",
                          heightValue: height / 40.6,
                          widthValue: width / 18.75,
                          repostUserName: repostUserName,
                          profileType: profileType,
                          tickerId: tickerId,
                          postUserId: postUserId,
                          billBoardType: billBoardType,
                          category: category),
                  GestureDetector(
                      onTap: enabled == false
                          ? () {}
                          : () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initFunction);
                              } else {
                                context.read<SingleLikeButtonBloc>().add(SingleLikeButtonListInitialEvent(
                                    id: id,
                                    type: 'dislikes',
                                    dislikeList: state.dislikeList,
                                    likeList: state.likeList,
                                    likeCountList: likeCountList,
                                    dislikeCountList: dislikeCountList,
                                    index: index,
                                    context: context,
                                    initFunction: notUse ? initFunction : () {},
                                    setState: modelSetState,
                                    responseId: responseId,
                                    commentId: commentId,
                                    billBoardType: billBoardType));
                              }
                            },
                      child: Center(
                        child: SvgPicture.asset(
                          state.dislikeList[index]
                              ? isDarkTheme.value
                                  ? "assets/home_screen/dislike_filled_dark.svg"
                                  : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                              : isDarkTheme.value
                                  ? "assets/home_screen/dislike_dark.svg"
                                  : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                          height: height / 40.6,
                          width: width / 18.75,
                        ),
                      )),
                  billboardWidgetsMain.getCommentButton(
                      heightValue: height / 40.6,
                      widthValue: width / 18.75,
                      fromWhere: fromWhere,
                      context: context,
                      controller: controller,
                      billBoardId: id,
                      postUserId: postUserId,
                      responseId: responseId,
                      responseUserId: responseUserId,
                      commentId: "",
                      index: index,
                      callFunction: initFunction,
                      responseFocusList: [responseFocus],
                      modelSetState: modelSetState,
                      billBoardType: billBoardType),
                ],
              ),
            ),
          );
        } else if (state is SingleLikeButtonListLoadingState) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: enabled == false
                          ? () {}
                          : () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initFunction);
                              } else {
                                context.read<SingleLikeButtonBloc>().add(SingleLikeButtonListInitialEvent(
                                    id: id,
                                    type: "likes",
                                    likeList: likeList,
                                    index: index,
                                    context: context,
                                    initFunction: notUse ? initFunction : () {},
                                    setState: modelSetState,
                                    dislikeList: dislikeList,
                                    likeCountList: likeCountList,
                                    dislikeCountList: dislikeCountList,
                                    responseId: responseId,
                                    commentId: commentId,
                                    billBoardType: billBoardType));
                                initFunction();
                              }
                            },
                      child: Center(
                        child: SvgPicture.asset(
                          likeList[index]
                              ? isDarkTheme.value
                                  ? "assets/home_screen/like_filled_dark.svg"
                                  : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg"
                              : isDarkTheme.value
                                  ? "assets/home_screen/like_dark.svg"
                                  : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                          height: height / 40.6,
                          width: width / 18.75,
                        ),
                      )),
                  fromWhere == "response" || fromWhere == "comments"
                      ? const SizedBox()
                      : billboardWidgetsMain.getShareRepostButton(
                          context: context,
                          id: id,
                          type: type,
                          imageUrl: image ?? "",
                          title: title ?? "",
                          description: description ?? "",
                          heightValue: height / 40.6,
                          widthValue: width / 18.75,
                          repostUserName: repostUserName,
                          profileType: profileType,
                          tickerId: tickerId,
                          postUserId: postUserId,
                          billBoardType: billBoardType,
                          category: category),
                  GestureDetector(
                      onTap: enabled == false
                          ? () {}
                          : () async {
                              if (mainSkipValue) {
                                commonFlushBar(context: context, initFunction: initFunction);
                              } else {
                                context.read<SingleLikeButtonBloc>().add(SingleLikeButtonListInitialEvent(
                                    id: id,
                                    type: 'dislikes',
                                    dislikeList: dislikeList,
                                    likeList: likeList,
                                    likeCountList: likeCountList,
                                    dislikeCountList: dislikeCountList,
                                    index: index,
                                    context: context,
                                    initFunction: notUse ? initFunction : () {},
                                    setState: modelSetState,
                                    responseId: responseId,
                                    commentId: commentId,
                                    billBoardType: billBoardType));
                                initFunction();
                              }
                            },
                      child: Center(
                        child: SvgPicture.asset(
                          dislikeList[index]
                              ? isDarkTheme.value
                                  ? "assets/home_screen/dislike_filled_dark.svg"
                                  : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg"
                              : isDarkTheme.value
                                  ? "assets/home_screen/dislike_dark.svg"
                                  : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                          height: height / 40.6,
                          width: width / 18.75,
                        ),
                      )),
                  billboardWidgetsMain.getCommentButton(
                    heightValue: height / 40.6,
                    widthValue: width / 18.75,
                    fromWhere: fromWhere,
                    context: context,
                    controller: controller,
                    billBoardId: id,
                    postUserId: postUserId,
                    responseId: responseId,
                    responseUserId: responseUserId,
                    commentId: "",
                    index: index,
                    callFunction: initFunction,
                    billBoardType: billBoardType,
                    modelSetState: modelSetState,
                    responseFocusList: [responseFocus],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget getBelieveButton(
      {required double heightValue,
      required RxList<bool> isBelieved,
      required RxList<int> believersCount,
      required int index,
      required bool isSearchData,
      required String billboardUserid,
      required String billboardUserName,
      required BuildContext context,
      required StateSetter modelSetState,
      bool? background}) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: billboardUserid,
            name: billboardUserName,
          );
          if (responseData['message'] == "Believed successfully") {
            logEventFunc(name: "Believed_User_$billboardUserid", type: "BillBoard");
            mainVariables.believersCountMainMyself.value++;
            mainVariables.singleBelievedMain.value++;
            if (isSearchData) {
              mainVariables.userSearchDataList[index].believersCount++;
              mainVariables.userSearchDataList[index].believed = true;
              for (int i = 0; i < mainVariables.popularSearchDataMain!.value.response.length; i++) {
                if (mainVariables.popularSearchDataMain!.value.response[i].id == billboardUserid) {
                  mainVariables.popularSearchDataMain!.value.response[i].believed = true;
                  mainVariables.popularSearchDataMain!.value.response[i].believersCount++;
                }
              }
              modelSetState(() {});
              believersCount[index]++;
              isBelieved[index] = true;
            } else {
              for (int i = 0; i < mainVariables.popularSearchDataMain!.value.response.length; i++) {
                if (mainVariables.popularSearchDataMain!.value.response[i].id == billboardUserid) {
                  mainVariables.popularSearchDataMain!.value.response[i].believed = true;
                  mainVariables.popularSearchDataMain!.value.response[i].believersCount++;
                }
              }
              modelSetState(() {});
              believersCount[index]++;
              isBelieved[index] = true;
            }
          } else if (responseData['message'] == "Unbelieved successfully") {
            logEventFunc(name: "Unbelieved_User_$billboardUserid", type: "BillBoard");
            mainVariables.believersCountMainMyself.value--;
            mainVariables.singleBelievedMain.value--;
            if (isSearchData) {
              mainVariables.userSearchDataList[index].believersCount--;
              mainVariables.userSearchDataList[index].believed = false;
              for (int i = 0; i < mainVariables.popularSearchDataMain!.value.response.length; i++) {
                if (mainVariables.popularSearchDataMain!.value.response[i].id == billboardUserid) {
                  mainVariables.popularSearchDataMain!.value.response[i].believed = false;
                  mainVariables.popularSearchDataMain!.value.response[i].believersCount--;
                }
              }
              modelSetState(() {});
              believersCount[index]--;
              isBelieved[index] = false;
            } else {
              for (int i = 0; i < mainVariables.popularSearchDataMain!.value.response.length; i++) {
                if (mainVariables.popularSearchDataMain!.value.response[i].id == billboardUserid) {
                  mainVariables.popularSearchDataMain!.value.response[i].believed = false;
                  mainVariables.popularSearchDataMain!.value.response[i].believersCount--;
                }
              }
              modelSetState(() {});
              believersCount[index]--;
              isBelieved[index] = false;
            }
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: isBelieved[index] ? Colors.transparent : Colors.green,
                border: Border.all(color: isBelieved[index] ? const Color(0XFFD9D9D9) : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  isBelieved[index] ? "Believed" : "Believe",
                  style: TextStyle(color: isBelieved[index] ? Colors.black : Colors.white),
                ),
              ),
            )));
  }

  Widget getHomeBelieveButton(
      {required double heightValue,
      required List<bool> isBelieved,
      required int index,
      required String billboardUserid,
      required String billboardUserName,
      required BuildContext context,
      required StateSetter modelSetState,
      bool? background}) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: billboardUserid,
            name: billboardUserName,
          );
          if (responseData['message'] == "Believed successfully") {
            logEventFunc(name: "Believed_User_$billboardUserid", type: "BillBoard");
            mainVariables.believersCountMainMyself.value++;
            mainVariables.valueMapListProfilePage[index].believersCount++;
            mainVariables.userBelievedProfileSingle.value = true;
            for (int i = 0; i < mainVariables.popularSearchDataMain!.value.response.length; i++) {
              if (mainVariables.popularSearchDataMain!.value.response[i].id == billboardUserid) {
                mainVariables.popularSearchDataMain!.value.response[i].believed = true;
                mainVariables.popularSearchDataMain!.value.response[i].believersCount++;
              }
            }
            if (!context.mounted) {
              return;
            }
            billBoardApiMain.getSearchData(searchKey: mainVariables.billBoardSearchControllerMain.value.text, context: context);
            for (int i = 0; i < mainVariables.valueMapListProfilePage.length; i++) {
              if (mainVariables.valueMapListProfilePage[i].userId == billboardUserid) {
                mainVariables.valueMapListProfilePage[i].believed = true;
              }
              if (mainVariables.valueMapListProfilePage[i].repostUser == billboardUserid /*mainVariables.valueMapListProfilePage[index].userId*/) {
                mainVariables.valueMapListProfilePage[i].repostBelieved = true;
              }
            }
            modelSetState(() {});
          } else if (responseData['message'] == "Unbelieved successfully") {
            logEventFunc(name: "Unbelieved_User_$billboardUserid", type: "BillBoard");
            mainVariables.believersCountMainMyself.value--;
            mainVariables.valueMapListProfilePage[index].believersCount--;
            mainVariables.userBelievedProfileSingle.value = false;
            for (int i = 0; i < mainVariables.popularSearchDataMain!.value.response.length; i++) {
              if (mainVariables.popularSearchDataMain!.value.response[i].id == billboardUserid) {
                mainVariables.popularSearchDataMain!.value.response[i].believed = false;
                mainVariables.popularSearchDataMain!.value.response[i].believersCount--;
              }
            }
            if (!context.mounted) {
              return;
            }
            billBoardApiMain.getSearchData(searchKey: mainVariables.billBoardSearchControllerMain.value.text, context: context);
            for (int i = 0; i < mainVariables.valueMapListProfilePage.length; i++) {
              if (mainVariables.valueMapListProfilePage[i].userId == billboardUserid) {
                mainVariables.valueMapListProfilePage[i].believed = false;
              }
              if (mainVariables.valueMapListProfilePage[i].repostUser == billboardUserid) {
                mainVariables.valueMapListProfilePage[i].repostBelieved = false;
              }
            }
            modelSetState(() {});
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: mainVariables.valueMapListProfilePage[index].believed ? Colors.transparent : Colors.green,
                border: Border.all(color: mainVariables.valueMapListProfilePage[index].believed ? const Color(0XFFD9D9D9) : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  mainVariables.valueMapListProfilePage[index].believed ? "Believed" : "Believe",
                  style: TextStyle(
                      color: mainVariables.valueMapListProfilePage[index].believed
                          ? isDarkTheme.value
                              ? mainVariables.valueMapListProfilePage[index].type == "byte"?Colors.black:Colors.white
                              : Colors.white
                          : Colors.white),
                ),
              ),
            )));
  }

  Widget getRepostBelieveButton(
      {required double heightValue,
      required int index,
      required String billboardUserid,
      required String billboardUserName,
      required BuildContext context,
      required StateSetter modelSetState,
      bool? background}) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: billboardUserid,
            name: billboardUserName,
          );
          if (responseData['message'] == "Believed successfully") {
            logEventFunc(name: "Believed_User_$billboardUserid", type: "BillBoard");
            for (int i = 0; i < mainVariables.valueMapListProfilePage.length; i++) {
              if (mainVariables.valueMapListProfilePage[i].repostUser == billboardUserid) {
                mainVariables.valueMapListProfilePage[i].repostBelieved = true;
              }
            }
            modelSetState(() {});
          } else if (responseData['message'] == "Unbelieved successfully") {
            logEventFunc(name: "Unbelieved_User_$billboardUserid", type: "BillBoard");
            for (int i = 0; i < mainVariables.valueMapListProfilePage.length; i++) {
              if (mainVariables.valueMapListProfilePage[i].repostUser == billboardUserid) {
                mainVariables.valueMapListProfilePage[i].repostBelieved = false;
              }
            }
            modelSetState(() {});
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: mainVariables.valueMapListProfilePage[index].repostBelieved ? Colors.transparent : Colors.green,
                border: Border.all(color: mainVariables.valueMapListProfilePage[index].repostBelieved ? const Color(0XFFD9D9D9) : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  mainVariables.valueMapListProfilePage[index].repostBelieved ? "Believed" : "Believe",
                  style: TextStyle(
                      color: mainVariables.valueMapListProfilePage[index].repostBelieved
                          ? isDarkTheme.value
                          ? mainVariables.valueMapListProfilePage[index].type == "byte"?Colors.black:Colors.white
                          : Colors.white
                          : Colors.white),
                ),
              ),
            )));
  }

  Widget getUserActivityBelieveButton(
      {required double heightValue,
      required BuildContext context,
      required String id,
      required String name,
      required StateSetter modelSetState,
      bool? background}) {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(id: id, name: name);
          if (responseData['message'] == "Believed successfully") {
            var url = Uri.parse(baseurl + versions + activity);
            var response = await http.post(url, headers: {'authorization': kToken}, body: {"userId": id});
            Map<String, dynamic> notify = jsonDecode(response.body);
            mainVariables.fetchMaterialMain = (ActivityList.fromJson(notify)).obs;
            mainVariables.userBelievedProfileSingle.value = true;
            modelSetState(() {});
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              width: 150,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: mainVariables.userBelievedProfileSingle.value ? Colors.transparent : Colors.green,
                border: Border.all(color: mainVariables.userBelievedProfileSingle.value ? const Color(0XFFD9D9D9) : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  mainVariables.userBelievedProfileSingle.value ? "Believed" : "Believe",
                  style: TextStyle(
                      fontSize: text.scale(12),
                      color: mainVariables.userBelievedProfileSingle.value
                          ? background == true
                              ? Colors.white
                              : Colors.black
                          : Colors.white),
                ),
              ),
            )));
  }

  Widget getBottomSheetBelieveButton(
      {required double heightValue,
      required bool isBelieved,
      required bool isNotBelieved,
      required int index,
      required String billboardUserid,
      required String billboardUserName,
      required BuildContext context,
      required StateSetter modelSetState,
      bool? background}) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: billboardUserid,
            name: billboardUserName,
          );
          if (responseData['message'] == "Believed successfully") {
            logEventFunc(name: "Believed_User_$billboardUserid", type: "BillBoard");
            mainVariables.believersCountMainMyself.value++;
            isNotBelieved
                ? mainVariables.likeDisLikeUserSearchDataList[index].believed = true
                : isBelieved
                    ? mainVariables.believedUsersList[index].believed = true
                    : mainVariables.believedUsersList[index].believed = true;
            isNotBelieved
                ? mainVariables.likeDisLikeUserSearchDataList[index].believersCount++
                : isBelieved
                    ? mainVariables.believedUsersList[index].believersCount++
                    : mainVariables.believedUsersList[index].believersCount++;
            modelSetState(() {});
          } else if (responseData['message'] == "Unbelieved successfully") {
            logEventFunc(name: "Unbelieved_User_$billboardUserid", type: "BillBoard");
            mainVariables.believersCountMainMyself.value--;
            isNotBelieved
                ? mainVariables.likeDisLikeUserSearchDataList[index].believed = false
                : isBelieved
                    ? mainVariables.believedUsersList[index].believed = false
                    : mainVariables.believedUsersList[index].believed = false;
            isNotBelieved
                ? mainVariables.likeDisLikeUserSearchDataList[index].believersCount--
                : isBelieved
                    ? mainVariables.believedUsersList[index].believersCount--
                    : mainVariables.believedUsersList[index].believersCount--;
            modelSetState(() {});
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: isNotBelieved
                    ? mainVariables.likeDisLikeUserSearchDataList[index].believed
                        ? Colors.transparent
                        : Colors.green
                    : isBelieved
                        ? mainVariables.believedUsersList[index].believed
                            ? Colors.transparent
                            : Colors.green
                        : mainVariables.believedUsersList[index].believed
                            ? Colors.transparent
                            : Colors.green,
                border: Border.all(
                    color: isNotBelieved
                        ? mainVariables.likeDisLikeUserSearchDataList[index].believed
                            ? const Color(0XFFD9D9D9)
                            : Colors.transparent
                        : isBelieved
                            ? mainVariables.believedUsersList[index].believed
                                ? const Color(0XFFD9D9D9)
                                : Colors.transparent
                            : mainVariables.believedUsersList[index].believed
                                ? const Color(0XFFD9D9D9)
                                : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  isNotBelieved
                      ? mainVariables.likeDisLikeUserSearchDataList[index].believed
                          ? "Believed"
                          : "Believe"
                      : isBelieved
                          ? mainVariables.believedUsersList[index].believed
                              ? "Believed"
                              : "Believe"
                          : mainVariables.believedUsersList[index].believed
                              ? "Believed"
                              : "Believe",
                  style: TextStyle(
                      color: isNotBelieved
                          ? mainVariables.likeDisLikeUserSearchDataList[index].believed
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.background
                          : isBelieved
                              ? mainVariables.believedUsersList[index].believed
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.background
                              : mainVariables.believedUsersList[index].believed
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.background),
                ),
              ),
            )));
  }

  Widget getSendButton({
    required StateSetter modelSetState,
    required BuildContext context,
    required bool isFromShare,
    required String id,
  }) {
    return GestureDetector(
      onTap: () async {
        if (mainVariables.messageSentList.contains(id)) {
        } else {
          mainVariables.messageSentList.add(id);
          await dioMain.post(baseurl + versionChat + sendMessage,
              options: Options(headers: {
                "authorization": kToken,
              }),
              data: {
                "type": "private",
                "reciever_id": id,
                "message": isFromShare ? mainVariables.dynamicLink!.shortUrl.toString() : mainVariables.forwardMessage.value,
                "files": [],
                "group_id": "",
              });
          //Map<String, dynamic> responseData = response.data;
        }
        logEventFunc(name: "Shared_via_Message", type: "Link");
        modelSetState(() {});
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          decoration: BoxDecoration(
              color: mainVariables.messageSentList.contains(id) ? Colors.white : const Color(0XFF0EA102),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: mainVariables.messageSentList.contains(id) ? const Color(0XFF0EA102).withOpacity(0.5) : Colors.transparent),
              boxShadow: [
                BoxShadow(color: const Color(0XFF0EA102).withOpacity(0.1), blurRadius: 2, spreadRadius: 2, offset: const Offset(1.0, 1.0))
              ]),
          child: Text(
            mainVariables.messageSentList.contains(id) ? "Sent" : "Send",
            style:
                TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: mainVariables.messageSentList.contains(id) ? Colors.black : Colors.white),
          )),
    );
  }

  Widget getResponseSubmitButton({
    required BuildContext context,
    required StateSetter modelSetState,
    required TextEditingController controller,
    required String billBoardId,
    required String postUserId,
    required String responseId,
    required String urlTYpe,
    required String contentType,
    required String category,
    required int index,
    required List<int> responseCountList,
    required bool single,
    required Function callFunction,
    File? file,
  }) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: () async {
          if (controller.text.isNotEmpty || file != null) {
            bool response = await billBoardApiMain.getAddBillboardResponse(
              context: context,
              billBoardId: billBoardId,
              message: controller.text,
              postUserId: postUserId,
              responseId: responseId,
              file: file,
              urlType: urlTYpe,
              contentType: contentType,
              category: category,
            );
            if (response) {
              controller.clear();
              responseCountList[index]++;
              modelSetState(() {
                if (single) {
                  mainVariables.pickedFileSingle = null;
                  mainVariables.pickedImageSingle = null;
                  mainVariables.pickedVideoSingle = null;
                } else {
                  mainVariables.pickedFileMain[index] = null;
                  mainVariables.pickedImageMain[index] = null;
                  mainVariables.pickedVideoMain[index] = null;
                }
              });
              callFunction();
            }
          }
        },
        child: Container(
          height: height / 34.64,
          padding: EdgeInsets.symmetric(horizontal: width / 86.6),
          margin: EdgeInsets.symmetric(horizontal: width / 86.6),
          decoration: BoxDecoration(
            color: const Color(0XFF0EA102),
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Text(
              "Respond",
              style: TextStyle(
                color: Colors.white,
                fontSize: text.scale(10),
              ),
            ),
          ),
        ));
  }

  Widget getShareButton({
    required BuildContext context,
    required String id,
    required String type,
    required String imageUrl,
    required String title,
    required String billBoardType,
    required String description,
    double? heightValue,
    double? widthValue,
  }) {
    return GestureDetector(
        onTap: () async {
          billBoardFunctionsMain.commonShareFunc(
              context: context,
              id: id,
              type: type,
              imageUrl: imageUrl,
              title: title,
              billBoardType: billBoardType,
              description: description,
              category: '',
              filterId: '');
        },
        child: SvgPicture.asset(
          isDarkTheme.value ? "assets/home_screen/share_dark.svg" : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
          height: heightValue,
          width: widthValue,
        ));
  }

  Widget getShareRepostButton({
    required BuildContext context,
    required String id,
    required String type,
    required String billBoardType,
    required String imageUrl,
    required String title,
    required String description,
    required String postUserId,
    required String repostUserName,
    required String profileType,
    required String tickerId,
    required String category,
    double? heightValue,
    double? widthValue,
  }) {
    return add(
        context: context,
        key: GlobalKey(),
        heightValue: heightValue ?? 0.0,
        widthValue: widthValue ?? 0.0,
        id: id,
        type: type,
        billBoardType: billBoardType,
        imageUrl: imageUrl,
        title: title,
        description: description,
        repostUserName: repostUserName,
        profileType: profileType,
        tickerId: tickerId,
        postUserId: postUserId,
        category: category);
    /*GestureDetector(
        onTap: () async {
          billBoardFunctionsMain.commonShareFunc(
              context: context,
              id: id,
              type: type,
              imageUrl: imageUrl,
              title: title,
              description: description);
        },
        child: Container(
          child: SvgPicture.asset(
              isDarkTheme.value? "assets/home_screen/share_dark.svg": "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",,
            height:heightValue,
            width: widthValue,
          ),
        ));*/
  }

  Widget getResponseField({
    required BuildContext context,
    required StateSetter modelSetState,
    required String billBoardId,
    required String postUserId,
    required String responseId,
    required String contentType,
    required String category,
    required int index,
    required List<int> responseCountList,
    required String fromWhere,
    required Function callFunction,
  }) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          width: width / 1.3,
          child: TextFormField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                modelSetState(() {
                  String newResponseValue = value.trim();
                  if (newResponseValue.isNotEmpty) {
                    String messageText = newResponseValue;
                    if (messageText.startsWith("+")) {
                      if (messageText.substring(messageText.length - 1) == '+') {
                        modelSetState(() {
                          mainVariables.isUserTaggingList[index] = true;
                        });
                      } else {
                        if (mainVariables.isUserTaggingList[index]) {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                          modelSetState(() {});
                        } else {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                        }
                      }
                    } else {
                      if (messageText.contains(" +")) {
                        if (messageText.substring(messageText.length - 1) == '+') {
                          modelSetState(() {
                            mainVariables.isUserTaggingList[index] = true;
                          });
                        } else {
                          if (mainVariables.isUserTaggingList[index]) {
                            conversationFunctionsMain.conversationSearchData(
                              newResponseValue: newResponseValue,
                              newSetState: modelSetState,
                            );
                            modelSetState(() {});
                          } else {
                            conversationFunctionsMain.conversationSearchData(newResponseValue: newResponseValue, newSetState: modelSetState);
                          }
                        }
                      } else {
                        modelSetState(() {
                          mainVariables.isUserTaggingList[index] = false;
                        });
                      }
                    }
                  }
                });
              } else if (value.isEmpty) {
                modelSetState(() {
                  mainVariables.isUserTaggingList[index] = false;
                });
              } else {
                modelSetState(() {});
              }
            },
            controller: mainVariables.responseControllerList[index],
            cursorColor: Colors.green,
            focusNode: mainVariables.responseFocusList[index],
            //style: TextStyle(fontSize: text.scale(14), fontFamily: "Poppins"),
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.emailAddress,
            maxLines: fromWhere == "descriptionPage" ? 5 : 1,
            minLines: fromWhere == "descriptionPage" ? 4 : 1,
            decoration: InputDecoration(
                suffixIcon: fromWhere == "descriptionPage"
                    ? const SizedBox()
                    : SizedBox(
                        width: width / 3.425,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (mainVariables.pickedImageMain[index] == null &&
                                    mainVariables.pickedVideoMain[index] == null &&
                                    mainVariables.pickedFileMain[index] == null)
                                ? GestureDetector(
                                    onTap: () {
                                      showSheet(context: context, modelSetState: modelSetState, index: index, single: false);
                                    },
                                    child: Image.asset(
                                      "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                                      height: height / 34.64,
                                      width: width / 16.44,
                                    ))
                                : const SizedBox(),
                            getResponseSubmitButton(
                              context: context,
                              modelSetState: modelSetState,
                              controller: mainVariables.responseControllerList[index],
                              //controller[index],
                              postUserId: postUserId,
                              billBoardId: billBoardId,
                              responseId: responseId,
                              index: index,
                              file: mainVariables.pickedImageMain[index] ??
                                  (mainVariables.pickedVideoMain[index] ?? (mainVariables.pickedFileMain[index])),
                              urlTYpe: mainVariables.selectedUrlTypeMain[index],
                              callFunction: callFunction,
                              single: false,
                              contentType: contentType,
                              category: category,
                              responseCountList: responseCountList,
                            )
                          ],
                        ),
                      ),
                contentPadding: const EdgeInsets.all(8),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFFD8D8D8), width: isDarkTheme.value ? 0.1 : 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFFD8D8D8), width: isDarkTheme.value ? 0.1 : 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xFFD8D8D8), width: isDarkTheme.value ? 0.1 : 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                fillColor: Theme.of(context).colorScheme.background,
                filled: true,
                hintText: 'Add a response'),
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
        SizedBox(
          width: width / 1.35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (mainVariables.pickedImageMain[index] == null &&
                      mainVariables.pickedVideoMain[index] == null &&
                      mainVariables.pickedFileMain[index] == null)
                  ? fromWhere == "descriptionPage"
                      ? GestureDetector(
                          onTap: () {
                            showSheet(context: context, modelSetState: modelSetState, index: index, single: false);
                          },
                          child: Image.asset(
                            "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                            height: height / 34.64,
                            width: width / 16.44,
                          ))
                      : const SizedBox()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                      child: mainVariables.pickedImageMain[index] == null &&
                              mainVariables.pickedVideoMain[index] == null &&
                              mainVariables.docMain[index] == null
                          ? const SizedBox()
                          : Row(
                              children: [
                                mainVariables.pickedImageMain[index] == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          Text(
                                            mainVariables.pickedImageMain[index]!.path.split('/').last.toString(),
                                            style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                mainVariables.pickedImageMain[index] = null;
                                                mainVariables.pickedVideoMain[index] = null;
                                                mainVariables.docMain[index] = null;
                                                mainVariables.pickedFileMain[index] = null;
                                              });
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                mainVariables.pickedVideoMain[index] == null
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            mainVariables.pickedVideoMain[index]!.path.split('/').last.toString(),
                                            style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                mainVariables.pickedVideoMain[index] = null;
                                                mainVariables.pickedImageMain[index] = null;
                                                mainVariables.docMain[index] = null;
                                                mainVariables.pickedFileMain[index] = null;
                                              });
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                mainVariables.docMain[index] == null
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            mainVariables.docMain[index]!.files[0].path!.split('/').last.toString(),
                                            style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                mainVariables.pickedFileMain[index] = null;
                                                mainVariables.docMain[index] = null;
                                                mainVariables.pickedImageMain[index] = null;
                                                mainVariables.pickedVideoMain[index] = null;
                                              });
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                    ),
              fromWhere == "descriptionPage"
                  ? getResponseSubmitButton(
                      context: context,
                      modelSetState: modelSetState,
                      controller: mainVariables.responseControllerList[index],
                      //controller[index],
                      postUserId: postUserId,
                      billBoardId: billBoardId,
                      responseId: responseId,
                      index: index,
                      file: mainVariables.pickedImageMain[index] ?? (mainVariables.pickedVideoMain[index] ?? (mainVariables.pickedFileMain[index])),
                      urlTYpe: mainVariables.pickedImageMain[index] != null
                          ? "image"
                          : mainVariables.pickedVideoMain[index] != null
                              ? "video"
                              : mainVariables.pickedFileMain[index] != null
                                  ? "doc"
                                  : "",
                      callFunction: callFunction,
                      single: false,
                      contentType: contentType,
                      category: category,
                      responseCountList: responseCountList,
                    )
                  : const SizedBox()
            ],
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
      ],
    );
  }

  Widget getResponseRelatedField({
    required BuildContext context,
    required StateSetter modelSetState,
    required String billBoardId,
    required String postUserId,
    required String responseId,
    required String contentType,
    required String category,
    required int index,
    required List<int> responseCountList,
    required String fromWhere,
    required Function callFunction,
  }) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          width: width / 1.4,
          child: TextFormField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                modelSetState(() {
                  String newResponseValue = value.trim();
                  if (newResponseValue.isNotEmpty) {
                    String messageText = newResponseValue;
                    if (messageText.startsWith("+")) {
                      if (messageText.substring(messageText.length - 1) == '+') {
                        modelSetState(() {
                          mainVariables.isUserTaggingRelatedList[index] = true;
                        });
                      } else {
                        if (mainVariables.isUserTaggingRelatedList[index]) {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                          modelSetState(() {});
                        } else {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                        }
                      }
                    } else {
                      if (messageText.contains(" +")) {
                        if (messageText.substring(messageText.length - 1) == '+') {
                          modelSetState(() {
                            mainVariables.isUserTaggingRelatedList[index] = true;
                          });
                        } else {
                          if (mainVariables.isUserTaggingRelatedList[index]) {
                            conversationFunctionsMain.conversationSearchData(
                              newResponseValue: newResponseValue,
                              newSetState: modelSetState,
                            );
                            modelSetState(() {});
                          } else {
                            conversationFunctionsMain.conversationSearchData(newResponseValue: newResponseValue, newSetState: modelSetState);
                          }
                        }
                      } else {
                        modelSetState(() {
                          mainVariables.isUserTaggingRelatedList[index] = false;
                        });
                      }
                    }
                  }
                });
              } else if (value.isEmpty) {
                modelSetState(() {
                  mainVariables.isUserTaggingRelatedList[index] = false;
                });
              } else {
                modelSetState(() {});
              }
            },
            controller: mainVariables.responseControllerRelatedList[index],
            cursorColor: Colors.green,
            focusNode: mainVariables.responseFocusRelatedList[index],
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.emailAddress,
            maxLines: fromWhere == "descriptionPage" ? 5 : 1,
            minLines: fromWhere == "descriptionPage" ? 4 : 1,
            decoration: InputDecoration(
                suffixIcon: fromWhere == "descriptionPage"
                    ? const SizedBox()
                    : SizedBox(
                        width: width / 3.425,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            (mainVariables.pickedImageRelatedMain[index] == null &&
                                    mainVariables.pickedVideoRelatedMain[index] == null &&
                                    mainVariables.pickedFileRelatedMain[index] == null)
                                ? GestureDetector(
                                    onTap: () {
                                      showSheet(context: context, modelSetState: modelSetState, index: index, single: false);
                                    },
                                    child: Image.asset(
                                      "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                                      height: height / 34.64,
                                      width: width / 16.44,
                                    ))
                                : const SizedBox(),
                            getResponseSubmitButton(
                              context: context,
                              modelSetState: modelSetState,
                              controller: mainVariables.responseControllerRelatedList[index],
                              //controller[index],
                              postUserId: postUserId,
                              billBoardId: billBoardId,
                              responseId: responseId,
                              index: index,
                              file: mainVariables.pickedImageRelatedMain[index] ??
                                  (mainVariables.pickedVideoRelatedMain[index] ?? (mainVariables.pickedFileRelatedMain[index])),
                              urlTYpe: mainVariables.selectedUrlTypeRelatedMain[index],
                              callFunction: callFunction,
                              single: false,
                              contentType: contentType,
                              category: category,
                              responseCountList: responseCountList,
                            )
                          ],
                        ),
                      ),
                contentPadding: const EdgeInsets.all(5),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                filled: true,
                fillColor: Theme.of(context).colorScheme.tertiary,
                hintText: 'Add a response'),
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
        SizedBox(
          width: width / 1.35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (mainVariables.pickedImageRelatedMain[index] == null &&
                      mainVariables.pickedVideoRelatedMain[index] == null &&
                      mainVariables.pickedFileRelatedMain[index] == null)
                  ? fromWhere == "descriptionPage"
                      ? GestureDetector(
                          onTap: () {
                            showSheet(context: context, modelSetState: modelSetState, index: index, single: false);
                          },
                          child: Image.asset(
                            "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                            height: height / 34.64,
                            width: width / 16.44,
                          ))
                      : const SizedBox()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                      child: mainVariables.pickedImageRelatedMain[index] == null &&
                              mainVariables.pickedVideoRelatedMain[index] == null &&
                              mainVariables.docRelatedMain[index] == null
                          ? const SizedBox()
                          : Row(
                              children: [
                                mainVariables.pickedImageRelatedMain[index] == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          Text(
                                            mainVariables.pickedImageRelatedMain[index]!.path.split('/').last.toString(),
                                            style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                mainVariables.pickedImageRelatedMain[index] = null;
                                                mainVariables.pickedVideoRelatedMain[index] = null;
                                                mainVariables.docRelatedMain[index] = null;
                                                mainVariables.pickedFileRelatedMain[index] = null;
                                              });
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                mainVariables.pickedVideoRelatedMain[index] == null
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            mainVariables.pickedVideoRelatedMain[index]!.path.split('/').last.toString(),
                                            style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                mainVariables.pickedVideoRelatedMain[index] = null;
                                                mainVariables.pickedImageRelatedMain[index] = null;
                                                mainVariables.docRelatedMain[index] = null;
                                                mainVariables.pickedFileRelatedMain[index] = null;
                                              });
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                mainVariables.docRelatedMain[index] == null
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            mainVariables.docRelatedMain[index]!.files[0].path!.split('/').last.toString(),
                                            style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                mainVariables.pickedFileRelatedMain[index] = null;
                                                mainVariables.docRelatedMain[index] = null;
                                                mainVariables.pickedImageRelatedMain[index] = null;
                                                mainVariables.pickedVideoRelatedMain[index] = null;
                                              });
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                    ),
              fromWhere == "descriptionPage"
                  ? getResponseSubmitButton(
                      context: context,
                      modelSetState: modelSetState,
                      controller: mainVariables.responseControllerRelatedList[index],
                      //controller[index],
                      postUserId: postUserId,
                      billBoardId: billBoardId,
                      responseId: responseId,
                      index: index,
                      file: mainVariables.pickedImageRelatedMain[index] ??
                          (mainVariables.pickedVideoRelatedMain[index] ?? (mainVariables.pickedFileRelatedMain[index])),
                      urlTYpe: mainVariables.pickedImageRelatedMain[index] != null
                          ? "image"
                          : mainVariables.pickedVideoRelatedMain[index] != null
                              ? "video"
                              : mainVariables.pickedFileRelatedMain[index] != null
                                  ? "doc"
                                  : "",
                      callFunction: callFunction,
                      single: false,
                      contentType: contentType,
                      category: category,
                      responseCountList: responseCountList,
                    )
                  : const SizedBox()
            ],
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
      ],
    );
  }

  Widget getResponseFieldSingle({
    required BuildContext context,
    required FocusNode responseFocus,
    required StateSetter modelSetState,
    required String billBoardId,
    required String postUserId,
    required String responseId,
    required String contentType,
    required String category,
    required int index,
    required List<int> responseCountList,
    required String fromWhere,
    required Function callFunction,
  }) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          width: width / 1.45,
          child: TextFormField(
            controller: mainVariables.billboardSingleControllerMain.value,
            onChanged: (value) {
              if (value.isNotEmpty) {
                modelSetState(() {
                  String newResponseValue = value.trim();
                  if (newResponseValue.isNotEmpty) {
                    String messageText = newResponseValue;
                    if (messageText.startsWith("+")) {
                      if (messageText.substring(messageText.length - 1) == '+') {
                        modelSetState(() {
                          mainVariables.isUserTagged.value = true;
                        });
                      } else {
                        if (mainVariables.isUserTagged.value) {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                          modelSetState(() {});
                        } else {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                        }
                      }
                    } else {
                      if (messageText.contains(" +")) {
                        if (messageText.substring(messageText.length - 1) == '+') {
                          modelSetState(() {
                            mainVariables.isUserTagged.value = true;
                          });
                        } else {
                          if (mainVariables.isUserTagged.value) {
                            conversationFunctionsMain.conversationSearchData(
                              newResponseValue: newResponseValue,
                              newSetState: modelSetState,
                            );
                            modelSetState(() {});
                          } else {
                            conversationFunctionsMain.conversationSearchData(newResponseValue: newResponseValue, newSetState: modelSetState);
                          }
                        }
                      } else {
                        modelSetState(() {
                          mainVariables.isUserTagged.value = false;
                        });
                      }
                    }
                  }
                });
              } else if (value.isEmpty) {
                modelSetState(() {
                  mainVariables.isUserTagged.value = false;
                });
              } else {
                modelSetState(() {});
              }
            },
            cursorColor: Colors.green,
            focusNode: responseFocus,
            showCursor: true,
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.emailAddress,
            maxLines: 5,
            minLines: 4,
            decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.tertiary,
                filled: true,
                contentPadding: const EdgeInsets.all(5),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                hintText: 'Add a response'),
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
        SizedBox(
          width: width / 1.45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (mainVariables.pickedImageSingle == null && mainVariables.pickedVideoSingle == null && mainVariables.pickedFileSingle == null)
                  ? GestureDetector(
                      onTap: () {
                        showSheet(context: context, modelSetState: modelSetState, index: index, single: true);
                      },
                      child: Image.asset(
                        "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                        height: height / 34.64,
                        width: width / 16.44,
                      ))
                  : Container(
                      //margin: EdgeInsets.symmetric(horizontal: _width / 18.75),
                      child: mainVariables.pickedImageSingle == null && mainVariables.pickedVideoSingle == null && mainVariables.docSingle == null
                          ? const SizedBox()
                          : Row(
                              children: [
                                mainVariables.pickedImageSingle == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          Text(
                                            mainVariables.pickedImageSingle!.path.split('/').last.toString(),
                                            style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                mainVariables.pickedImageSingle = null;
                                                mainVariables.pickedVideoSingle = null;
                                                mainVariables.docSingle = null;
                                                mainVariables.pickedFileSingle = null;
                                              });
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                mainVariables.pickedVideoSingle == null
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            mainVariables.pickedVideoSingle!.path.split('/').last.toString(),
                                            style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                mainVariables.pickedVideoSingle = null;
                                                mainVariables.pickedImageSingle = null;
                                                mainVariables.docSingle = null;
                                                mainVariables.pickedFileSingle = null;
                                              });
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                mainVariables.docSingle == null
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            mainVariables.docSingle!.files[0].path!.split('/').last.toString(),
                                            style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                mainVariables.pickedFileSingle = null;
                                                mainVariables.docSingle = null;
                                                mainVariables.pickedImageSingle = null;
                                                mainVariables.pickedVideoSingle = null;
                                              });
                                            },
                                            child: Container(
                                                decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 12,
                                                  ),
                                                )),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                    ),
              getResponseSubmitButton(
                context: context,
                modelSetState: modelSetState,
                controller: mainVariables.billboardSingleControllerMain.value,
                postUserId: postUserId,
                billBoardId: billBoardId,
                responseId: responseId,
                index: 0,
                file: mainVariables.pickedImageSingle ?? (mainVariables.pickedVideoSingle ?? (mainVariables.pickedFileSingle)),
                urlTYpe: mainVariables.pickedImageSingle != null
                    ? "image"
                    : mainVariables.pickedVideoSingle != null
                        ? "video"
                        : mainVariables.pickedFileSingle != null
                            ? "doc"
                            : "",
                callFunction: callFunction,
                single: true,
                contentType: contentType,
                category: category,
                responseCountList: responseCountList,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget getCommentButton({
    required double heightValue,
    required double widthValue,
    required String fromWhere,
    required BuildContext context,
    required TextEditingController controller,
    required String billBoardId,
    required String responseId,
    required String commentId,
    required String postUserId,
    required String billBoardType,
    required String responseUserId,
    required int index,
    required Function callFunction,
    required StateSetter modelSetState,
    required List<FocusNode> responseFocusList,
  }) {
    return GestureDetector(
      onTap: fromWhere == "response" || fromWhere == "comments"
          ? () async {
              mainVariables.pickedImageSingle = null;
              mainVariables.pickedVideoSingle = null;
              mainVariables.pickedFileSingle = null;
              mainVariables.selectedUrlTypeSingle.value = "";
              controller.clear();
              await showAboutBottomSheet(
                context: context,
                controller: controller,
                billBoardId: billBoardId,
                postUserId: postUserId,
                responseId: responseId,
                responseUserId: responseUserId,
                commentId: commentId,
                callFunction: callFunction,
                modelSetState: modelSetState,
              ).then((value) => callFunction());
            }
          : fromWhere == "homePage" || fromWhere == "descriptionPage"
              ? () async {
                  if (billBoardType == "survey") {
                    String activeStatus = "";
                    bool answerStatus = false;
                    int answeredQuestion = 0;
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String mainUserId = prefs.getString('newUserId') ?? "";
                    String mainUserToken = prefs.getString('newUserToken') ?? "";
                    var url = Uri.parse(baseurl + versionSurvey + surveyStatusCheck);
                    var response = await http.post(url, headers: {
                      'Authorization': mainUserToken
                    }, body: {
                      'survey_id': billBoardId,
                    });
                    var responseData = json.decode(response.body);
                    if (responseData["status"]) {
                      activeStatus = responseData["response"]["status"];

                      if (activeStatus == "active") {
                        var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                        var response = await http.post(url, headers: {
                          'Authorization': mainUserToken
                        }, body: {
                          'survey_id': billBoardId,
                        });
                        var responseData = json.decode(response.body);
                        if (responseData["status"]) {
                          answerStatus = responseData["response"][0]["final_question"];
                          answeredQuestion = responseData["response"][0]["question_number"];
                        } else {
                          answerStatus = false;
                          answeredQuestion = 0;
                        }
                      }
                    }
                    if (!context.mounted) {
                      return;
                    }
                    mainUserId == postUserId
                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                            return AnalyticsPage(
                              surveyId: billBoardId,
                              activity: false,
                              surveyTitle: "",
                              navBool: false,
                              fromWhere: 'similar',
                            );
                          }))
                        : activeStatus == 'active'
                            ? answerStatus
                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                    return AnalyticsPage(
                                        surveyId: billBoardId, activity: false, navBool: false, fromWhere: 'similar', surveyTitle: "");
                                  }))
                                : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                    return QuestionnairePage(
                                      surveyId: billBoardId,
                                      defaultIndex: answeredQuestion,
                                    );
                                  }))
                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return AnalyticsPage(
                                  surveyId: billBoardId,
                                  activity: false,
                                  surveyTitle: "",
                                  navBool: false,
                                  fromWhere: 'similar',
                                );
                              }));
                  } else {
                    responseFocusList[index].requestFocus();
                  }
                }
              : () {},
      child: SvgPicture.asset(
        "lib/Constants/Assets/SMLogos/messageCircle.svg",
        colorFilter: ColorFilter.mode(isDarkTheme.value ? const Color(0XFFD6D6D6) : const Color(0XFF0EA102), BlendMode.srcIn),
        height: heightValue,
        width: widthValue,
      ),
    );
  }

  bottomSheet({
    required BuildContext context1,
    required bool myself,
    required StateSetter modelSetState,
    required String billboardId,
    required String billboardUserId,
    required String type,
    required String contentType,
    required String category,
    required String responseId,
    required String responseUserId,
    required String commentId,
    required String commentUserId,
    required Function callFunction,
    required dynamic responseDetail,
    required int index,
    List<BillboardMainModelResponse>? valueMapList,
    String? isDescription,
  }) {
    double width = MediaQuery.of(context1).size.width;
    double height = MediaQuery.of(context1).size.height;
    TextScaler text = MediaQuery.of(context1).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context1,
        builder: (BuildContext context2) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context2).viewInsets.bottom),
              child: myself
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        contentType == "survey"
                            ? const SizedBox()
                            : ListTile(
                                onTap: () async {
                                  Navigator.pop(context2);
                                  mainVariables.selectedBillboardIdMain.value = billboardId;
                                  switch (contentType) {
                                    case "blog":
                                      {
                                        bool response = await Navigator.push(
                                            context1, MaterialPageRoute(builder: (BuildContext context) => const BlogPostEditPage()));
                                        if (response) {
                                          callFunction();
                                        }
                                        break;
                                      }
                                    case "blog_response":
                                      {
                                        mainVariables.selectedUrlTypeSingle.value = "";
                                        showAlertDialog11(
                                          context: context1,
                                          editDetails: responseDetail,
                                          contentType: contentType,
                                          popUpAttach: false,
                                          category: category,
                                          billBoardId: billboardId,
                                          billBoardUserId: billboardUserId,
                                          callFunction: callFunction,
                                          responseId: responseId,
                                          responseUserId: responseUserId,
                                        );
                                        break;
                                      }
                                    case "blog_comments":
                                      {
                                        mainVariables.selectedUrlTypeSingle.value = "";
                                        showAlertDialog11(
                                          context: context1,
                                          editDetails: responseDetail,
                                          contentType: contentType,
                                          popUpAttach: false,
                                          category: category,
                                          billBoardId: billboardId,
                                          billBoardUserId: billboardUserId,
                                          callFunction: callFunction,
                                          responseId: responseId,
                                          responseUserId: responseUserId,
                                        );
                                        break;
                                      }
                                    case "forums":
                                      {
                                        bool response = await Navigator.push(
                                            context1,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    ForumPostEditPage(text: "", filterId: "", catIdList: const [], forumId: billboardId)));
                                        if (response) {
                                          callFunction();
                                        }
                                        break;
                                      }
                                    case "byte":
                                      {
                                        /*bool? response = await Navigator.push(
                                            context1, MaterialPageRoute(builder: (BuildContext context) => const BytesEditPage()));
                                        if (response != null && response == true) {
                                          callFunction();
                                        }*/
                                        break;
                                      }
                                    default:
                                      {
                                        break;
                                      }
                                  }
                                },
                                minLeadingWidth: width / 25,
                                leading: const Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                                title: Text(
                                  "Edit Post",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                                ),
                              ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context2);
                            showDialog(
                                barrierDismissible: false,
                                context: context2,
                                builder: (BuildContext context3) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                    child: Container(
                                      height: height / 6,
                                      margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                              child: Text("Delete Post",
                                                  style: TextStyle(
                                                      color: const Color(0XFF0EA102),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: text.scale(18),
                                                      fontFamily: "Poppins"))),
                                          const Divider(),
                                          const Center(child: Text("Are you sure to Delete this Post")),
                                          const Spacer(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width / 25),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context3);
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                        fontSize: text.scale(12)),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(18.0),
                                                    ),
                                                    backgroundColor: const Color(0XFF0EA102),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.pop(context3);
                                                    bool response = await billBoardApiMain.getDeleteBillboardResponse(
                                                        context: context1,
                                                        billBoardId: billboardId,
                                                        type: type,
                                                        responseId: responseId,
                                                        commentId: commentId,
                                                        contentType: contentType);
                                                    if (response) {
                                                      if (!context1.mounted) {
                                                        return;
                                                      }
                                                      if (isDescription == "yes") {
                                                        Navigator.push(context1, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const MainBottomNavigationPage(
                                                              caseNo1: 2,
                                                              text: "",
                                                              excIndex: 1,
                                                              newIndex: 0,
                                                              countryIndex: 0,
                                                              isHomeFirstTym: false,
                                                              tType: true);
                                                        }));
                                                      } else {
                                                        valueMapList == null
                                                            ? await callFunction()
                                                            : valueMapList != []
                                                                ? valueMapList.removeAt(index)
                                                                : debugPrint("nothing");
                                                        modelSetState(() {});
                                                      }
                                                    }
                                                  },
                                                  child: Text(
                                                    "Continue",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                        fontSize: text.scale(12)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          minLeadingWidth: width / 25,
                          leading: const Icon(
                            Icons.delete,
                            size: 20,
                          ),
                          title: Text(
                            "Delete Post",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () async {
                            Navigator.pop(context2);
                            showAlertDialog(
                              context: context1,
                              modelSetState: modelSetState,
                              id: billboardId,
                              userId: billboardUserId,
                              responseId: responseId,
                              responseUserId: responseUserId,
                              commentId: commentId,
                              commentUserId: commentUserId,
                              contentType: contentType,
                              actionType: 'Report',
                            );
                          },
                          minLeadingWidth: width / 25,
                          leading: const Icon(
                            Icons.shield,
                            size: 20,
                          ),
                          title: Text(
                            "Report Post",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                          ),
                        ),
                        const Divider(
                          thickness: 0.0,
                          height: 0.0,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context2);
                            showAlertDialog(
                              context: context1,
                              modelSetState: modelSetState,
                              id: billboardId,
                              userId: billboardUserId,
                              responseId: responseId,
                              responseUserId: responseUserId,
                              commentId: commentId,
                              commentUserId: commentUserId,
                              contentType: contentType,
                              actionType: 'Block',
                            );
                          },
                          minLeadingWidth: width / 25,
                          leading: const Icon(
                            Icons.flag,
                            size: 20,
                          ),
                          title: Text(
                            "Block Post",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        });
  }

  void showAlertDialog11({
    required BuildContext context,
    required String contentType,
    required String category,
    required dynamic editDetails,
    required bool popUpAttach,
    required String billBoardId,
    required String billBoardUserId,
    required String responseId,
    required String responseUserId,
    required Function callFunction,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    TextEditingController editController = TextEditingController(text: editDetails.message);
    if (contentType == "blog_response") {
      BlogResponse editData = editDetails;
      String urlType = editData.fileType;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                content: SizedBox(
                  height: height / 1.732,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                modelSetState(() {
                                  popUpAttach = false;
                                  mainVariables.selectedUrlTypeSingle.value = "";
                                });

                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.clear, size: 24, color: Color(0xff000000)),
                            ),
                          ],
                        ),
                        popUpAttach
                            ? mainVariables.selectedUrlTypeSingle.value == ""
                                ? GestureDetector(
                                    onTap: () {
                                      modelSetState(() {
                                        popUpAttach = true;
                                      });
                                      showSheet(
                                          context: context,
                                          modelSetState: modelSetState,
                                          index: 0,
                                          single: true); // showSheet11(newSetState: modelSetState);
                                    },
                                    child: Center(
                                      child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                          height: height / 8.82,
                                          width: width / 4.07,
                                          child: Image.asset(
                                            "assets/settings/add_file.png",
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      mainVariables.selectedUrlTypeSingle.value == ""
                                          ? const SizedBox()
                                          : mainVariables.selectedUrlTypeSingle.value == "image"
                                              ? Container(
                                                  padding: const EdgeInsets.only(top: 8, right: 5),
                                                  height: height / 6.76,
                                                  width: width / 3.12,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    image: FileImage(mainVariables.pickedImageSingle!),
                                                    fit: BoxFit.fill,
                                                  )),
                                                )
                                              : mainVariables.selectedUrlTypeSingle.value == "video"
                                                  ? Container(
                                                      color: Colors.red,
                                                      width: width / 1.7,
                                                      child: playerScreen(urlLink: mainVariables.pickedVideoSingle!.path) //newUrlLink: pickedVideo!),
                                                      )
                                                  : mainVariables.selectedUrlTypeSingle.value == "document"
                                                      ? Column(
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
                                                                      url: mainVariables.pickedFileSingle!.path,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: width / 2.5,
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(color: const Color(0xffD8D8D8).withOpacity(0.5))),
                                                                    child: Text(
                                                                      mainVariables.pickedFileSingle!.path.split('/').last.toString(),
                                                                      style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
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
                                                        )
                                                      : const SizedBox(),
                                    ],
                                  )
                            : urlType == ""
                                ? GestureDetector(
                                    onTap: () {
                                      modelSetState(() {
                                        popUpAttach = true;
                                      });
                                      showSheet(context: context, modelSetState: modelSetState, index: 0, single: true);
                                      //  showSheet11(newSetState: modelSetState);
                                    },
                                    child: Center(
                                      child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                          height: height / 8.82,
                                          width: width / 4.07,
                                          child: Image.asset(
                                            "assets/settings/add_file.png",
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      urlType == ""
                                          ? const SizedBox()
                                          : urlType == "image"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return FullScreenImage(
                                                        imageUrl: editData.files[0],
                                                        tag: "generate_a_unique_tag",
                                                      );
                                                    }));
                                                  },
                                                  child: Container(
                                                      padding: const EdgeInsets.only(top: 8, right: 5),
                                                      height: height / 6.76,
                                                      width: width / 3.12,
                                                      child: Image.network(
                                                        editData.files[0],
                                                        fit: BoxFit.fill,
                                                      )),
                                                )
                                              : urlType == "video"
                                                  ? Container(
                                                      color: Colors.red,
                                                      width: width / 1.7,
                                                      child: playerScreen(urlLink: editData.files[0]),
                                                    )
                                                  : urlType == "document"
                                                      ? Column(
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
                                                                      url: editData.files[0],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                      vertical: height / 86.6,
                                                                      horizontal: width / 41.1,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(color: const Color(0xffD8D8D8).withOpacity(0.5))),
                                                                    child: Text(
                                                                      editData.files[0].split('/').last.toString(),
                                                                      style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: width / 82.2),
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
                                                        )
                                                      : const SizedBox(),
                                    ],
                                  ),
                        SizedBox(
                          height: height / 86.6,
                        ),
                        popUpAttach
                            ? mainVariables.selectedUrlTypeSingle.value == ""
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      mainVariables.selectedUrlTypeSingle.value == "image"
                                          ? Row(
                                              children: [
                                                Text(
                                                  mainVariables.pickedImageSingle!.path.split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                SizedBox(
                                                  width: width / 20.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      mainVariables.pickedImageSingle = null;
                                                      mainVariables.selectedUrlTypeSingle.value = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      mainVariables.selectedUrlTypeSingle.value == "video"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  mainVariables.pickedVideoSingle!.path.split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                SizedBox(
                                                  width: width / 20.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      mainVariables.pickedVideoSingle = null;
                                                      mainVariables.selectedUrlTypeSingle.value = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      mainVariables.selectedUrlTypeSingle.value == "document"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  mainVariables.pickedFileSingle!.path.split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                SizedBox(
                                                  width: width / 20.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      mainVariables.pickedFileSingle = null;
                                                      mainVariables.selectedUrlTypeSingle.value = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox()
                                    ],
                                  )
                            : urlType == ""
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      urlType == "image"
                                          ? Row(
                                              children: [
                                                Text(
                                                  editData.files[0].split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(12)),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      urlType = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      urlType == "video"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  editData.files[0].split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                SizedBox(
                                                  width: width / 20.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      urlType = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      urlType == "document"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  editData.files[0].split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      urlType = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                        SizedBox(
                          height: height / 86.6,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 7, spreadRadius: 5)],
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100)),
                            width: width / 1.45,
                            height: height / 9.90,
                            child: TextFormField(
                              /* onChanged: (value){
                              if(value.isNotEmpty){
                                setState(() {
                                  newResponseValue1=value.trim();
                                  if (newResponseValue1.isNotEmpty) {
                                    textCount1 = newResponseValue1.length;
                                    messageText1 = newResponseValue1;
                                    if(messageText1.startsWith("+")){
                                      if (messageText1.substring(messageText1.length - 1) == '+') {
                                        modelSetState(() {
                                          showList1 = true;
                                          showLoader1=true;
                                        });
                                      }
                                      else {
                                        if(showList1){
                                          searchData(newResponseValue:newResponseValue1,value: true,newSetState: modelSetState);
                                          modelSetState(() {
                                            showLoader1=false;
                                          });
                                        }
                                      }
                                    }
                                    else{
                                      if(messageText1.contains(" +")){
                                        if (messageText1.substring(messageText1.length - 1) == '+') {
                                          modelSetState(() {
                                            showList1 = true;
                                            showLoader1=true;
                                          });
                                        }
                                        else {
                                          if(showList1){
                                            searchData(newResponseValue:newResponseValue1,value: true,newSetState: modelSetState);
                                            modelSetState(() {
                                              showLoader1=false;
                                            });
                                          }
                                        }
                                      }
                                      else{
                                        modelSetState(() {
                                          showList1 = false;
                                          showLoader1=true;
                                        });
                                      }
                                    }
                                  }
                                });
                              }
                              else if(value.length==0 ){
                                modelSetState(() {
                                  showList1=false;
                                  newResponseValue1=value;
                                });
                              }
                              else{
                                modelSetState(() {
                                  showList1=false;
                                  newResponseValue1=value;
                                });
                              }
                            },*/
                              style: TextStyle(
                                  color: const Color(0XFFB0B0B0), fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                              controller: editController,
                              keyboardType: TextInputType.name,
                              maxLines: 4,
                              minLines: 3,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 81.2),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText: "Enter a description...",
                                  hintStyle: TextStyle(
                                      color: const Color(0XFFB0B0B0), fontSize: text.scale(10), fontFamily: "Poppins", fontWeight: FontWeight.w400)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 33.82,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            bool response = await billBoardApiMain.getAddBillboardResponse(
                                context: context,
                                contentType: contentType,
                                billBoardId: billBoardId,
                                message: editController.text,
                                postUserId: billBoardUserId,
                                responseId: editData.id,
                                urlType: popUpAttach ? mainVariables.selectedUrlTypeSingle.value : urlType,
                                category: category,
                                file: popUpAttach
                                    ? mainVariables.selectedUrlTypeSingle.value == "image"
                                        ? mainVariables.pickedImageSingle!
                                        : mainVariables.selectedUrlTypeSingle.value == "video"
                                            ? mainVariables.pickedVideoSingle!
                                            : mainVariables.selectedUrlTypeSingle.value == "document"
                                                ? mainVariables.pickedFileSingle!
                                                : null
                                    : null);
                            if (response) {
                              callFunction();
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: Color(0XFF0EA102),
                            ),
                            height: height / 18.45,
                            child: Center(
                              child: Text(
                                "Send",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(12), fontFamily: "Poppins"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      CommentsResponse editData = editDetails;
      String urlType = editData.fileType;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                content: SizedBox(
                  height: height / 1.732,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                modelSetState(() {
                                  popUpAttach = false;
                                  mainVariables.selectedUrlTypeSingle.value = "";
                                });

                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.clear, size: 24, color: Color(0xff000000)),
                            ),
                          ],
                        ),
                        popUpAttach
                            ? mainVariables.selectedUrlTypeSingle.value == ""
                                ? GestureDetector(
                                    onTap: () {
                                      modelSetState(() {
                                        popUpAttach = true;
                                      });
                                      showSheet(
                                          context: context,
                                          modelSetState: modelSetState,
                                          index: 0,
                                          single: true); // showSheet11(newSetState: modelSetState);
                                    },
                                    child: Center(
                                      child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                          height: height / 8.82,
                                          width: width / 4.07,
                                          child: Image.asset(
                                            "assets/settings/add_file.png",
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      mainVariables.selectedUrlTypeSingle.value == ""
                                          ? const SizedBox()
                                          : mainVariables.selectedUrlTypeSingle.value == "image"
                                              ? Container(
                                                  padding: const EdgeInsets.only(top: 8, right: 5),
                                                  height: height / 6.76,
                                                  width: width / 3.12,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                    image: FileImage(mainVariables.pickedImageSingle!),
                                                    fit: BoxFit.fill,
                                                  )),
                                                )
                                              : mainVariables.selectedUrlTypeSingle.value == "video"
                                                  ? Container(
                                                      color: Colors.red,
                                                      width: width / 1.7,
                                                      child: playerScreen(urlLink: mainVariables.pickedVideoSingle!.path) //newUrlLink: pickedVideo!),
                                                      )
                                                  : mainVariables.selectedUrlTypeSingle.value == "document"
                                                      ? Column(
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
                                                                      url: mainVariables.pickedFileSingle!.path,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: width / 2.5,
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(color: const Color(0xffD8D8D8).withOpacity(0.5))),
                                                                    child: Text(
                                                                      mainVariables.pickedFileSingle!.path.split('/').last.toString(),
                                                                      style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
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
                                                        )
                                                      : const SizedBox(),
                                    ],
                                  )
                            : urlType == ""
                                ? GestureDetector(
                                    onTap: () {
                                      modelSetState(() {
                                        popUpAttach = true;
                                      });
                                      showSheet(context: context, modelSetState: modelSetState, index: 0, single: true);
                                      //  showSheet11(newSetState: modelSetState);
                                    },
                                    child: Center(
                                      child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                          height: height / 8.82,
                                          width: width / 4.07,
                                          child: Image.asset(
                                            "assets/settings/add_file.png",
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      urlType == ""
                                          ? const SizedBox()
                                          : urlType == "image"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return FullScreenImage(
                                                        imageUrl: editData.files[0],
                                                        tag: "generate_a_unique_tag",
                                                      );
                                                    }));
                                                  },
                                                  child: Container(
                                                      padding: const EdgeInsets.only(top: 8, right: 5),
                                                      height: height / 6.76,
                                                      width: width / 3.12,
                                                      child: Image.network(
                                                        editData.files[0],
                                                        fit: BoxFit.fill,
                                                      )),
                                                )
                                              : urlType == "video"
                                                  ? Container(
                                                      color: Colors.red,
                                                      width: width / 1.7,
                                                      child: playerScreen(urlLink: editData.files[0]),
                                                    )
                                                  : urlType == "document"
                                                      ? Column(
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
                                                                      url: editData.files[0],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    padding: const EdgeInsets.all(10),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(color: const Color(0xffD8D8D8).withOpacity(0.5))),
                                                                    child: Text(
                                                                      editData.files[0].split('/').last.toString(),
                                                                      style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: width / 82.2),
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
                                                        )
                                                      : const SizedBox(),
                                    ],
                                  ),
                        SizedBox(
                          height: height / 86.6,
                        ),
                        popUpAttach
                            ? mainVariables.selectedUrlTypeSingle.value == ""
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      mainVariables.selectedUrlTypeSingle.value == "image"
                                          ? Row(
                                              children: [
                                                Text(
                                                  mainVariables.pickedImageSingle!.path.split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                SizedBox(
                                                  width: width / 20.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      mainVariables.pickedImageSingle = null;
                                                      mainVariables.selectedUrlTypeSingle.value = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      mainVariables.selectedUrlTypeSingle.value == "video"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  mainVariables.pickedVideoSingle!.path.split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                SizedBox(
                                                  width: width / 20.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      mainVariables.pickedVideoSingle = null;
                                                      mainVariables.selectedUrlTypeSingle.value = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      mainVariables.selectedUrlTypeSingle.value == "document"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  mainVariables.pickedFileSingle!.path.split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                SizedBox(
                                                  width: width / 20.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      mainVariables.pickedFileSingle = null;
                                                      mainVariables.selectedUrlTypeSingle.value = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox()
                                    ],
                                  )
                            : urlType == ""
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      urlType == "image"
                                          ? Row(
                                              children: [
                                                Text(
                                                  editData.files[0].split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                SizedBox(
                                                  width: width / 20.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      urlType = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      urlType == "video"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  editData.files[0].split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                SizedBox(
                                                  width: width / 20.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      urlType = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      urlType == "document"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  editData.files[0].split('/').last.toString(),
                                                  style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                                ),
                                                SizedBox(
                                                  width: width / 20.55,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    modelSetState(() {
                                                      urlType = "";
                                                    });
                                                  },
                                                  child: Container(
                                                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                        SizedBox(
                          height: height / 86.6,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 7, spreadRadius: 5)],
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100)),
                            width: width / 1.45,
                            height: height / 9.90,
                            child: TextFormField(
                              /* onChanged: (value){
                              if(value.isNotEmpty){
                                setState(() {
                                  newResponseValue1=value.trim();
                                  if (newResponseValue1.isNotEmpty) {
                                    textCount1 = newResponseValue1.length;
                                    messageText1 = newResponseValue1;
                                    if(messageText1.startsWith("+")){
                                      if (messageText1.substring(messageText1.length - 1) == '+') {
                                        modelSetState(() {
                                          showList1 = true;
                                          showLoader1=true;
                                        });
                                      }
                                      else {
                                        if(showList1){
                                          searchData(newResponseValue:newResponseValue1,value: true,newSetState: modelSetState);
                                          modelSetState(() {
                                            showLoader1=false;
                                          });
                                        }
                                      }
                                    }
                                    else{
                                      if(messageText1.contains(" +")){
                                        if (messageText1.substring(messageText1.length - 1) == '+') {
                                          modelSetState(() {
                                            showList1 = true;
                                            showLoader1=true;
                                          });
                                        }
                                        else {
                                          if(showList1){
                                            searchData(newResponseValue:newResponseValue1,value: true,newSetState: modelSetState);
                                            modelSetState(() {
                                              showLoader1=false;
                                            });
                                          }
                                        }
                                      }
                                      else{
                                        modelSetState(() {
                                          showList1 = false;
                                          showLoader1=true;
                                        });
                                      }
                                    }
                                  }
                                });
                              }
                              else if(value.length==0 ){
                                modelSetState(() {
                                  showList1=false;
                                  newResponseValue1=value;
                                });
                              }
                              else{
                                modelSetState(() {
                                  showList1=false;
                                  newResponseValue1=value;
                                });
                              }
                            },*/
                              style: TextStyle(
                                  color: const Color(0XFFB0B0B0), fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                              controller: editController,
                              keyboardType: TextInputType.name,
                              maxLines: 4,
                              minLines: 3,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 81.2),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  hintText: "Enter a description...",
                                  hintStyle: TextStyle(
                                      color: const Color(0XFFB0B0B0), fontSize: text.scale(10), fontFamily: "Poppins", fontWeight: FontWeight.w400)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 33.82,
                        ),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            if (contentType == "blog_response") {
                              bool response = await billBoardApiMain.getAddBillboardResponse(
                                  context: context,
                                  contentType: contentType,
                                  billBoardId: billBoardId,
                                  message: editController.text,
                                  postUserId: billBoardUserId,
                                  responseId: editData.id,
                                  urlType: popUpAttach ? mainVariables.selectedUrlTypeSingle.value : urlType,
                                  category: category,
                                  file: popUpAttach
                                      ? mainVariables.selectedUrlTypeSingle.value == "image"
                                          ? mainVariables.pickedImageSingle!
                                          : mainVariables.selectedUrlTypeSingle.value == "video"
                                              ? mainVariables.pickedVideoSingle!
                                              : mainVariables.selectedUrlTypeSingle.value == "document"
                                                  ? mainVariables.pickedFileSingle!
                                                  : null
                                      : null);
                              if (response) {
                                callFunction();
                              }
                            } else {
                              bool response = await billBoardApiMain.getAddBillboardResponseComments(
                                context: context,
                                billBoardId: billBoardId,
                                message: editController.text,
                                postUserId: billBoardUserId,
                                responseId: responseId,
                                responseUserId: responseUserId,
                                commentId: editData.id,
                                urlType: mainVariables.selectedUrlTypeSingle.value,
                                file: mainVariables.selectedUrlTypeSingle.value == "image"
                                    ? mainVariables.pickedImageSingle!
                                    : mainVariables.selectedUrlTypeSingle.value == "video"
                                        ? mainVariables.pickedVideoSingle!
                                        : mainVariables.selectedUrlTypeSingle.value == "document"
                                            ? mainVariables.pickedFileSingle!
                                            : null,
                              );
                              if (response) {
                                callFunction();
                              }
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: Color(0XFF0EA102),
                            ),
                            height: height / 18.45,
                            child: Center(
                              child: Text(
                                "Send",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(12), fontFamily: "Poppins"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  Widget playerScreen({required String urlLink}) {
    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enablePip: false,
          enableOverflowMenu: false,
          enablePlayPause: false,
          enableQualities: false,
          enableAudioTracks: false,
          enableMute: false,
          enableSkips: false,
          enablePlaybackSpeed: false,
          enableProgressText: false,
        ));
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      urlLink,
    );
    BetterPlayerController betterPlayerController2 = BetterPlayerController(betterPlayerConfiguration);
    betterPlayerController2.setupDataSource(dataSource);
    return BetterPlayer(
      controller: betterPlayerController2,
    );
  }

  filtersBottomSheet(
      {required BuildContext context,
      required bool checkBox,
      required bool profile,
      required List<Widget> imageList,
      required List<BottomListModel> textList,
      required List<bool> boolList,
      required String selectedProfile,
      required String heading,
      required int selectedIndex,
      required StateSetter newSetState}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isScrollControlled: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 57.73,
                      ),
                      Text(heading,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall /*TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16), color: const Color(0XFF3C3C3C)),*/
                          ),
                      SizedBox(
                        height: height / 57.73,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: textList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                checkBox
                                    ? CheckboxListTile(
                                        onChanged: (value) {
                                          modelSetState(() {
                                            boolList[index] = !boolList[index];
                                          });
                                        },
                                        //height: height / 21.65, width: width / 10.275,
                                        secondary: SizedBox(
                                            height: isDarkTheme.value ? height / 21.65 : height / 34.64,
                                            width: isDarkTheme.value ? width / 10.275 : width / 16.44,
                                            child: imageList[index]),
                                        title: Text(
                                          textList[index].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: text.scale(12),
                                          ),
                                        ),
                                        value: boolList[index],
                                        activeColor: Colors.green,
                                        checkboxShape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      )
                                    : RadioListTile(
                                        value: index,
                                        groupValue: selectedIndex,
                                        //profile? textList.indexOf(selectedProfile): textList.indexOf(selectedContentType),
                                        controlAffinity: ListTileControlAffinity.trailing,
                                        title: Text(
                                          textList[index].name,
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                                        ),
                                        secondary: imageList.isEmpty
                                            ? const SizedBox()
                                            : SizedBox(
                                                height: isDarkTheme.value ? height / 21.65 : height / 34.64,
                                                width: isDarkTheme.value ? width / 10.275 : width / 16.44,
                                                child: imageList[index]),
                                        onChanged: (value) {
                                          modelSetState(() {
                                            selectedIndex = index;
                                          });
                                        }),
                                Divider(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  height: 0.0,
                                  thickness: 0.5,
                                )
                              ],
                            );
                          }),
                      SizedBox(
                        height: height / 57.73,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  newSetState(() {});

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: width / 8.22, vertical: height / 57.73),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0XFFC1C1C1), width: 1),
                                      color: const Color(0XFFFFFFFF),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF0EA102)),
                                  ),
                                )),
                            GestureDetector(
                                onTap: () {
                                  if (checkBox == true) {
                                    mainVariables.contentCategoriesMain.clear();
                                    for (int i = 0; i < boolList.length; i++) {
                                      boolList[i] ? mainVariables.contentCategoriesMain.add(textList[i].tag) : debugPrint("do nothing");
                                    }
                                  } else {
                                    if (imageList.isEmpty) {
                                      profile
                                          ? mainVariables.sentimentTypeMain.value = textList[selectedIndex].tag
                                          : mainVariables.sortTypeMain.value = textList[selectedIndex].tag;
                                    } else {
                                      profile
                                          ? mainVariables.selectedProfileMain.value = textList[selectedIndex].tag
                                          : mainVariables.contentTypeMain.value = textList[selectedIndex].tag;
                                    }
                                  }

                                  Navigator.pop(context);
                                  newSetState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: width / 8.22, vertical: height / 57.73),
                                  decoration: BoxDecoration(color: const Color(0XFF0EA102), borderRadius: BorderRadius.circular(12)),
                                  child: Text(
                                    "Apply",
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFFFFFFFF)),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 28.86,
                      )
                    ],
                  ));
            },
          );
        });
  }

  filtersBottomSheetCalender({required BuildContext context, required String heading, required StateSetter newSetState}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return Container(
                  height: height / 1.732,
                  margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height / 57.73,
                      ),
                      Text(
                        heading,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16), color: const Color(0XFF3C3C3C)),
                      ),
                      SizedBox(
                        height: height / 57.73,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
                          BoxShadow(color: Colors.black26.withOpacity(0.1), offset: const Offset(0.0, -0.5), blurRadius: 1.0, spreadRadius: 1.0)
                        ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SfDateRangePicker(
                              view: DateRangePickerView.month,
                              monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                              selectionMode: DateRangePickerSelectionMode.range,
                              onSelectionChanged: functionsMain.onSelectionChanged,
                            ),
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0XFFDFDFDF), width: 1.5)),
                                padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 86.6),
                                child: Obx(() => Text(
                                      mainVariables.dateRangeMain.value == ""
                                          ? DateTime.now().toString().substring(0, 10)
                                          : mainVariables.dateRangeMain.value,
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: Colors.black),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 57.73,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  newSetState(() {});

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: width / 10.275, vertical: height / 86.6),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0XFFC1C1C1), width: 1),
                                      color: const Color(0XFFFFFFFF),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF0EA102)),
                                  ),
                                )),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  newSetState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: width / 10.275, vertical: height / 86.6),
                                  decoration: BoxDecoration(color: const Color(0XFF0EA102), borderRadius: BorderRadius.circular(15)),
                                  child: Text(
                                    "Apply",
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFFFFFFFF)),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 57.73,
                      ),
                    ],
                  ));
            },
          );
        });
  }

  showSheet({required BuildContext context, required StateSetter modelSetState, required int index, required bool single}) {
    ImagePicker picker = ImagePicker();
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
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
                        modelSetState(() {
                          if (single) {
                            mainVariables.pickedImageSingle = File(image.path);
                            mainVariables.selectedUrlTypeSingle.value = "image";
                            mainVariables.pickedVideoSingle = null;
                          } else {
                            mainVariables.pickedImageMain[index] = File(image.path);
                            mainVariables.selectedUrlTypeMain[index] = "image";
                            mainVariables.pickedVideoMain[index] = null;
                          }
                        });
                      }
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context).pop();
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
                      final video = await picker.pickVideo(source: ImageSource.gallery);
                      if (video != null) {
                        modelSetState(() {
                          if (single) {
                            mainVariables.pickedVideoSingle = File(video.path);
                            mainVariables.pickedImageSingle = null;
                            mainVariables.selectedUrlTypeSingle.value = "video";
                          } else {
                            mainVariables.pickedVideoMain[index] = File(video.path);
                            mainVariables.pickedImageMain[index] = null;
                            mainVariables.selectedUrlTypeMain[index] = "video";
                          }
                        });
                      }
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context).pop();
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
                      if (single) {
                        mainVariables.docSingle = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'docx'],
                        );
                        if (mainVariables.docSingle != null) {
                          modelSetState(() {
                            mainVariables.docFilesSingle = mainVariables.docSingle!.paths.map((path) => File(path!)).toList();
                            mainVariables.pickedFileSingle = mainVariables.docFilesSingle[0];
                            mainVariables.selectedUrlTypeSingle.value = "document";
                          });
                        }
                      } else {
                        mainVariables.docMain[index] = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'docx'],
                        );
                        if (mainVariables.docMain[index] != null) {
                          modelSetState(() {
                            mainVariables.docFilesMain[index] = mainVariables.docMain[index]!.paths.map((path) => File(path!)).toList();
                            mainVariables.pickedFileMain[index] = mainVariables.docFilesMain[index][0];
                            mainVariables.selectedUrlTypeMain[index] = "document";
                          });
                        }
                      }
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.of(context).pop();
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

  Future commentsBottomSheet({
    required BuildContext context,
    required String responseId,
    required String billBoardPostUser,
    required String responsePostUser,
    required String category,
  }) async {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        context: context,
        builder: (BuildContext context) {
          return BlogCommentsBottomSheetPage(
            responseId: responseId,
            billBoardPostUser: billBoardPostUser,
            responsePostUser: responsePostUser,
            category: category,
          );
        });
  }

  Future showAboutBottomSheet({
    required BuildContext context,
    required TextEditingController controller,
    required String billBoardId,
    required String responseId,
    required String commentId,
    required String postUserId,
    required String responseUserId,
    required Function callFunction,
    required StateSetter modelSetState,
  }) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    controller.clear();
    mainVariables.pickedImageSingle = null;
    mainVariables.pickedVideoSingle = null;
    mainVariables.pickedFileSingle = null;
    mainVariables.selectedUrlTypeSingle.value = "";
    FocusNode controllerFocus = FocusNode();
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        backgroundColor: Theme.of(context).colorScheme.background,
        isDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: _width / 18.75),
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height / 86.6,
                        ),
                        SizedBox(
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Offstage(
                                  offstage: false,
                                  child: Container(
                                    height: height / 24.74,
                                    margin: EdgeInsets.only(top: height / 86.6),
                                    padding: EdgeInsets.symmetric(horizontal: width / 41.1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: isDarkTheme.value ? Theme.of(context).colorScheme.background.withOpacity(0.1) : Colors.grey.shade50,
                                    ),
                                    child: EmojiPicker(
                                      onEmojiSelected: (category, emoji) {
                                        controller.text += emoji.emoji;
                                        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                                      },
                                      config: Config(
                                        columns: 11,
                                        emojiSizeMax: 26,
                                        verticalSpacing: 0,
                                        horizontalSpacing: 0,
                                        gridPadding: EdgeInsets.zero,
                                        initCategory: Category.SMILEYS,
                                        bgColor: Colors.grey.shade50,
                                        indicatorColor: Colors.blue,
                                        iconColor: Colors.grey,
                                        iconColorSelected: Colors.blue,
                                        backspaceColor: Colors.blue,
                                        skinToneDialogBgColor: Colors.white,
                                        skinToneIndicatorColor: Colors.grey,
                                        enableSkinTones: false,
                                        recentTabBehavior: RecentTabBehavior.NONE,
                                        recentsLimit: 28,
                                        replaceEmojiOnLimitExceed: false,
                                        noRecents: Text(
                                          'No Recents',
                                          style: TextStyle(fontSize: text.scale(20), color: Colors.black26),
                                          textAlign: TextAlign.center,
                                        ),
                                        loadingIndicator: const SizedBox.shrink(),
                                        tabIndicatorAnimDuration: kTabScrollDuration,
                                        categoryIcons: const CategoryIcons(),
                                        buttonMode: ButtonMode.MATERIAL,
                                        checkPlatformCompatibility: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              /*    GestureDetector(
                                  onTap: (){
                                if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                mainVariables.pickedImageSingle = null ;
                                mainVariables.pickedVideoSingle= null;
                                mainVariables.pickedFileSingle = null;
                                mainVariables.selectedUrlTypeSingle.value = "";
                                controller.clear();
                              },
                                  child: Icon(Icons.highlight_remove,size: 25,color: Colors.red,)
                              )*/
                            ],
                          ),
                        ),
                        TextFormField(
                          style: TextStyle(
                            fontSize: text.scale(14),
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                          autofocus: true,
                          showCursor: true,
                          focusNode: controllerFocus,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: controller,
                          keyboardType: TextInputType.emailAddress,
                          maxLines: null,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: height / 57.73, horizontal: width / 27.4),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.1) : Colors.transparent,
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.1) : Colors.transparent,
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.1) : Colors.transparent,
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.1) : Colors.transparent,
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.1) : Colors.transparent,
                                  width: 0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintStyle: TextStyle(
                                color: const Color(0XFFA5A5A5), fontSize: text.scale(12), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                            hintText: 'add your comment here',
                            suffixIcon: SizedBox(
                              width: width / 5.48,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (mainVariables.pickedImageSingle == null &&
                                          mainVariables.pickedVideoSingle == null &&
                                          mainVariables.pickedFileSingle == null)
                                      ? GestureDetector(
                                          onTap: () {
                                            showSheet(context: context, modelSetState: modelSetState, index: 0, single: true);
                                          },
                                          child: Image.asset(
                                            "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                                            scale: 2,
                                          ))
                                      : const SizedBox(),
                                  IconButton(
                                      onPressed: () async {
                                        if (controller.text.isEmpty) {
                                          Flushbar(
                                            message: "Message content is empty",
                                            duration: const Duration(seconds: 2),
                                          ).show(context);
                                        } else {
                                          Navigator.pop(context);
                                          bool response = await billBoardApiMain.getAddBillboardResponseComments(
                                            context: context,
                                            billBoardId: billBoardId,
                                            message: controller.text,
                                            postUserId: postUserId,
                                            responseId: responseId,
                                            responseUserId: responseUserId,
                                            commentId: commentId,
                                            urlType: mainVariables.selectedUrlTypeSingle.value,
                                            file: mainVariables.selectedUrlTypeSingle.value == "image"
                                                ? mainVariables.pickedImageSingle!
                                                : mainVariables.selectedUrlTypeSingle.value == "video"
                                                    ? mainVariables.pickedVideoSingle!
                                                    : mainVariables.selectedUrlTypeSingle.value == "document"
                                                        ? mainVariables.pickedFileSingle!
                                                        : null,
                                          );
                                          if (response) {
                                            callFunction();
                                          }
                                        }
                                      },
                                      icon: const Icon(Icons.send, size: 25, color: Color(0XFF0EA102))),
                                ],
                              ),
                            ),
                            /*   prefixIcon: IconButton(
                              onPressed: () {
                                modelSetState((){
                                  emojiShowing = !emojiShowing;
                                  if (emojiShowing) {
                                    controllerFocus.unfocus();
                                  }
                                  else {
                                    FocusScope.of(context).requestFocus(controllerFocus);
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.tag_faces,
                                color: Colors.grey,
                              ),
                            ),*/
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        (mainVariables.pickedImageSingle == null && mainVariables.pickedVideoSingle == null && mainVariables.pickedFileSingle == null)
                            ? const SizedBox()
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                child: mainVariables.pickedImageSingle == null &&
                                        mainVariables.pickedVideoSingle == null &&
                                        mainVariables.docSingle == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          mainVariables.pickedImageSingle == null
                                              ? const SizedBox()
                                              : Row(
                                                  children: [
                                                    Text(
                                                      mainVariables.pickedImageSingle!.path.split('/').last.toString(),
                                                      style: TextStyle(color: Colors.black, fontSize: text.scale(8)),
                                                    ),
                                                    SizedBox(
                                                      width: width / 41.1,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        modelSetState(() {
                                                          mainVariables.pickedImageSingle = null;
                                                          mainVariables.pickedVideoSingle = null;
                                                          mainVariables.docSingle = null;
                                                          mainVariables.pickedFileSingle = null;
                                                          mainVariables.selectedUrlTypeSingle.value = "";
                                                        });
                                                      },
                                                      child: Container(
                                                          decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              color: Colors.white,
                                                              size: 12,
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                          mainVariables.pickedVideoSingle == null
                                              ? const SizedBox()
                                              : Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      mainVariables.pickedVideoSingle!.path.split('/').last.toString(),
                                                      style: TextStyle(color: Colors.black, fontSize: text.scale(8)),
                                                    ),
                                                    SizedBox(
                                                      width: width / 41.1,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        modelSetState(() {
                                                          mainVariables.pickedVideoSingle = null;
                                                          mainVariables.pickedImageSingle = null;
                                                          mainVariables.docSingle = null;
                                                          mainVariables.pickedFileSingle = null;
                                                          mainVariables.selectedUrlTypeSingle.value = "";
                                                        });
                                                      },
                                                      child: Container(
                                                          decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              color: Colors.white,
                                                              size: 12,
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                          mainVariables.docSingle == null
                                              ? const SizedBox()
                                              : Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      mainVariables.docSingle!.files[0].path!.split('/').last.toString(),
                                                      style: TextStyle(color: Colors.black, fontSize: text.scale(8)),
                                                    ),
                                                    SizedBox(
                                                      width: width / 41.1,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        modelSetState(() {
                                                          mainVariables.pickedFileSingle = null;
                                                          mainVariables.docSingle = null;
                                                          mainVariables.pickedImageSingle = null;
                                                          mainVariables.pickedVideoSingle = null;
                                                          mainVariables.selectedUrlTypeSingle.value = "";
                                                        });
                                                      },
                                                      child: Container(
                                                          decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              color: Colors.white,
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
                          height: height / 57.73,
                        ),
                      ],
                    )),
              );
            },
          );
        });
  }

  Future commentsFilterBottomSheet({required BuildContext context}) async {
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
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<String>(
                        title: Text(
                          "General",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: 'general',
                        groupValue: mainVariables.selectedCommentsFilter.value,
                        onChanged: (value) {
                          modelSetState(() {
                            mainVariables.selectedCommentsFilter.value = value ?? "";
                          });

                          Navigator.pop(context);
                        },
                      ),
                      const Divider(
                        thickness: 0.0,
                        height: 0.0,
                      ),
                      RadioListTile<String>(
                        title: Text(
                          "Believers",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: "believed",
                        groupValue: mainVariables.selectedCommentsFilter.value,
                        onChanged: (value) {
                          modelSetState(() {
                            mainVariables.selectedCommentsFilter.value = value ?? "";
                          });

                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void showAlertDialog({
    required BuildContext context,
    required StateSetter modelSetState,
    required String contentType,
    required String id,
    required String userId,
    required String responseId,
    required String responseUserId,
    required String commentId,
    required String commentUserId,
    required String actionType,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        List<String> actionList = ["Report", "Block"];
        List<String> whyList = ["Scam", "Abusive Content", "Spam", "Other"];
        String actionValue = actionType;
        String whyValue = "Scam";
        TextEditingController controller = TextEditingController();
        return SingleChildScrollView(
          reverse: true,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            content: SizedBox(
              height: height / 1.18,
              width: width / 1.09,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: SizedBox(
                      height: height / 3.67,
                      width: width / 1.96,
                      child: Image.asset(
                        actionValue == "Report"
                            ? isDarkTheme.value
                                ? "assets/settings/report_dark.png"
                                : "assets/settings/report_light.png"
                            : isDarkTheme.value
                                ? "assets/settings/block_dark.png"
                                : "assets/settings/block_light.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 20.3,
                  ),
                  Center(
                    child: Text(
                      'Help us understand why?',
                      style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: height / 27.06,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Action:",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400),
                            )),
                            SizedBox(
                              width: width / 2.3,
                              child: DropdownButtonFormField<String>(
                                alignment: AlignmentDirectional.center,
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: actionList
                                    .map((label) => DropdownMenuItem<String>(
                                        value: label,
                                        child: Text(
                                          label,
                                          style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                        )))
                                    .toList(),
                                value: actionValue,
                                onChanged: (String? value) {
                                  modelSetState(() {
                                    actionValue = value!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height / 108.25,
                      ),
                      SizedBox(
                        height: height / 27.06,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Why?",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400),
                            )),
                            SizedBox(
                              width: width / 2.3,
                              child: DropdownButtonFormField<String>(
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: whyList
                                    .map((label) => DropdownMenuItem<String>(
                                          value: label,
                                          child: Text(
                                            label,
                                            style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                          ),
                                        ))
                                    .toList(),
                                value: whyValue,
                                onChanged: (String? value) {
                                  modelSetState(() {
                                    whyValue = value!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  TextFormField(
                    controller: controller,
                    minLines: 4,
                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFFA0AEC0)),
                    keyboardType: TextInputType.name,
                    maxLines: 4,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: width / 26.78, vertical: height / 50.75),
                      hintText: "Enter a description...",
                      hintStyle: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFFA0AEC0)),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  GestureDetector(
                    onTap: () {
                      logEventFunc(name: actionValue == "Report" ? 'Reported_Post' : 'Blocked_Post', type: contentType.toString().capitalizeFirst!);
                      billBoardApiMain.getReportOrBlockPost(
                          action: actionValue,
                          why: whyValue,
                          description: controller.text,
                          id: id,
                          userId: userId,
                          context: context,
                          contentType: contentType);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: isDarkTheme.value
                            ? const Color(0xff464646)
                            : actionValue == "Report"
                                ? const Color(0XFF0EA102)
                                : const Color(0xffFF0000),
                      ),
                      height: height / 18.45,
                      child: Center(
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(14), fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getVideoPlayer({
    required ChewieController cvController,
    required double heightValue,
    required double widthValue,
  }) {
    return Container(
      height: heightValue,
      // _height/5.4,
      width: widthValue,
      // _width/1.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.hardEdge,
      child: Chewie(
        controller: cvController,
      ),
    );
  }

  Widget getSearchPage({
    required BuildContext context,
    required StateSetter modelSetState,
    Function? getBillBoardListData,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      // color: Colors.white,
      color: Theme.of(context).colorScheme.background,
      child: ListView(
        children: [
          SizedBox(
            height: height / 57.73,
          ),
          Obx(() => SizedBox(
                height: mainVariables.userSearchDataList.isEmpty
                    ? height / 17.32
                    : mainVariables.userSearchDataList.length == 1
                        ? height / 11.54
                        : height / 5.77,
                child: mainVariables.userSearchDataList.isEmpty
                    ? Center(
                        child: Text(
                          "No matched profiles found",
                          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w400, fontSize: text.scale(12)),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const ScrollPhysics(),
                        itemCount: mainVariables.userSearchDataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () async {
                              mainVariables.billBoardSearchControllerMain.value.clear();
                              if (mainVariables.userSearchDataList[index].profileType != "user" ||
                                  mainVariables.userSearchDataList[index].profileType != "intermediate") {
                                mainVariables.selectedTickerId.value = mainVariables.userSearchDataList[index].tickerId;
                              }
                              bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                return mainVariables.userSearchDataList[index].profileType == "intermediate"
                                    ? IntermediaryBillBoardProfilePage(userId: mainVariables.userSearchDataList[index].id)
                                    : mainVariables.userSearchDataList[index].profileType != "user"
                                        ? const BusinessProfilePage()
                                        : UserBillBoardProfilePage(userId: mainVariables.userSearchDataList[index].id);
                              }));
                              if (response && getBillBoardListData != null) {
                                getBillBoardListData();
                              }
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: billboardWidgetsMain.getProfile(
                                context: context,
                                heightValue: height / 19.24,
                                widthValue: width / 9.13,
                                myself: false,
                                avatar: mainVariables.userSearchDataList[index].avatar,
                                userId: mainVariables.userSearchDataList[index].profileType == "intermediate"
                                    ? mainVariables.userSearchDataList[index].id
                                    : mainVariables.userSearchDataList[index].profileType != "user"
                                        ? mainVariables.userSearchDataList[index].tickerId
                                        : mainVariables.userSearchDataList[index].id,
                                isProfile: mainVariables.userSearchDataList[index].profileType,
                                getBillBoardListData: getBillBoardListData),
                            trailing: SizedBox(
                              width: width / 4,
                              child: billboardWidgetsMain.getBelieveButton(
                                heightValue: height / 33.76,
                                isBelieved:
                                    RxList.generate(mainVariables.userSearchDataList.length, (ind) => mainVariables.userSearchDataList[ind].believed),
                                billboardUserid: mainVariables.userSearchDataList[index].id,
                                billboardUserName: mainVariables.userSearchDataList[index].username,
                                context: context,
                                modelSetState: modelSetState,
                                index: index,
                                believersCount: RxList.generate(
                                    mainVariables.userSearchDataList.length, (ind) => mainVariables.userSearchDataList[ind].believersCount),
                                isSearchData: true,
                              ),
                            ),
                            title: Text(
                              mainVariables.userSearchDataList[index].username,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: text.scale(12),
                                color: Theme.of(context).colorScheme.onPrimary, //const Color(0XFF1D1D1D),
                                //color: const Color(0XFF1D1D1D),
                              ),
                            ),
                            subtitle: IntrinsicHeight(
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      billboardWidgetsMain.believersTabBottomSheet(
                                        context: context,
                                        id: mainVariables.userSearchDataList[index].id,
                                        isBelieversList: true,
                                      );
                                    },
                                    child: Text("${mainVariables.userSearchDataList[index].believersCount} Believers",
                                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: text.scale(10), color: const Color(0XFFAFAFAF))),
                                  ),
                                  SizedBox(
                                    width: width / 82.2,
                                  ),
                                  const VerticalDivider(
                                    thickness: 1.5,
                                  ),
                                  Text(
                                      mainVariables.userSearchDataList[index].profileType == "intermediate"
                                          ? "Intermediary"
                                          : mainVariables.userSearchDataList[index].profileType.toString().capitalizeFirst!,
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: text.scale(10), color: const Color(0XFF0EA102))),
                                ],
                              ),
                            ),
                          );
                        }),
              )),
          SizedBox(
            height: height / 57.73,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Popular Traders",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall //TextStyle(fontSize: text.scale(16), color: const Color(0XFF212121), fontWeight: FontWeight.w700),
                  ),
              InkWell(
                onTap: () {
                  mainVariables.billBoardSearchControllerMain.value.clear();
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return const PopularTradersPage(
                      fromWhere: 'billBoardHome',
                    );
                  }));
                },
                child: Text(
                  "see more",
                  style: TextStyle(fontSize: text.scale(12), color: const Color(0XFFC0C0C0), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height / 57.73,
          ),
          Obx(() => SizedBox(
                height: height / 3.84,
                child: ListView.builder(
                    itemCount: mainVariables.popularSearchDataMain!.value.response.length,
                    scrollDirection: Axis.horizontal,
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          mainVariables.billBoardSearchControllerMain.value.clear();
                          if (mainVariables.popularSearchDataMain!.value.response[index].profileType != "user" ||
                              mainVariables.popularSearchDataMain!.value.response[index].profileType != "intermediate") {
                            mainVariables.selectedTickerId.value = mainVariables.popularSearchDataMain!.value.response[index].tickerId;
                          }
                          bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                            return mainVariables.popularSearchDataMain!.value.response[index].profileType == "intermediate"
                                ? IntermediaryBillBoardProfilePage(userId: mainVariables.popularSearchDataMain!.value.response[index].id)
                                : mainVariables.popularSearchDataMain!.value.response[index].profileType != "user"
                                    ? const BusinessProfilePage()
                                    : UserBillBoardProfilePage(userId: mainVariables.popularSearchDataMain!.value.response[index].id);
                          }));
                          if (response && getBillBoardListData != null) {
                            getBillBoardListData();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: index == 0 ? 5 : 7.5,
                              right: index == mainVariables.popularSearchDataMain!.value.response.length - 1 ? 15 : 5,
                              top: 15,
                              bottom: 15),
                          padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 20.55),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: isDarkTheme.value ? const Color(0XFF1E1E1F) : Colors.white,
                              boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              billboardWidgetsMain.getProfile(
                                  context: context,
                                  heightValue: height / 11.39,
                                  widthValue: width / 5.40,
                                  myself: false,
                                  isProfile: mainVariables.popularSearchDataMain!.value.response[index].profileType,
                                  avatar: mainVariables.popularSearchDataMain!.value.response[index].avatar,
                                  userId: mainVariables.popularSearchDataMain!.value.response[index].profileType == "intermediate"
                                      ? mainVariables.popularSearchDataMain!.value.response[index].id
                                      : mainVariables.popularSearchDataMain!.value.response[index].profileType != "user"
                                          ? mainVariables.popularSearchDataMain!.value.response[index].tickerId
                                          : mainVariables.popularSearchDataMain!.value.response[index].id,
                                  getBillBoardListData: getBillBoardListData),
                              SizedBox(
                                height: height / 173.2,
                              ),
                              Center(
                                child: SizedBox(
                                  width: width / 3.288,
                                  child: Text(
                                    "${mainVariables.popularSearchDataMain!.value.response[index].firstName} ${mainVariables.popularSearchDataMain!.value.response[index].lastName} ",
                                    style: Theme.of(context).textTheme.labelLarge,
                                    /*TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: text.scale(12),
                                        color: const Color(0XFF1D1D1D),
                                        overflow: TextOverflow.ellipsis)*/
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 173.2,
                              ),
                              Text(
                                mainVariables.popularSearchDataMain!.value.response[index].username,
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: text.scale(10), color: const Color(0XFFAFAFAF)),
                              ),
                              SizedBox(
                                height: height / 173.2,
                              ),
                              InkWell(
                                onTap: () {
                                  billboardWidgetsMain.believersTabBottomSheet(
                                    context: context,
                                    id: mainVariables.searchDataMain!.value.response[index].id,
                                    isBelieversList: true,
                                  );
                                },
                                child: Text(
                                  "${mainVariables.popularSearchDataMain!.value.response[index].believersCount} Believers",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: text.scale(10), color: const Color(0XFFAFAFAF)),
                                ),
                              ),
                              SizedBox(
                                height: height / 173.2,
                              ),
                              SizedBox(
                                width: width / 4,
                                child: billboardWidgetsMain.getBelieveButton(
                                    heightValue: height / 33.76,
                                    isBelieved: RxList.generate(mainVariables.popularSearchDataMain!.value.response.length,
                                        (ind) => mainVariables.popularSearchDataMain!.value.response[ind].believed),
                                    billboardUserid: mainVariables.popularSearchDataMain!.value.response[index].id,
                                    billboardUserName: mainVariables.popularSearchDataMain!.value.response[index].username,
                                    context: context,
                                    modelSetState: modelSetState,
                                    index: index,
                                    believersCount:
                                        RxList.generate(1, (index) => mainVariables.popularSearchDataMain!.value.response[index].believersCount),
                                    isSearchData: false),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )),
        ],
      ),
    );
  }

  getLikeDislikeUsersList({
    required BuildContext context,
    required String billBoardId,
    required String responseId,
    required String commentId,
    required String billBoardType,
    required String action,
    required String likeCount,
    required String disLikeCount,
    required String viewCount,
    required int index,
    required bool isViewIncluded,
  }) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isDismissible: false,
        builder: (BuildContext context) => LikeDisLikeUsersList(
              billBoardId: billBoardId,
              responseId: responseId,
              commentId: commentId,
              billBoardType: billBoardType,
              action: action,
              likeCount: likeCount,
              disLikeCount: disLikeCount,
              index: index,
              isViewIncluded: isViewIncluded,
              viewCount: viewCount,
            ));
  }

  Widget translationWidget({
    required List<BillboardMainModelResponse> valueMapList,
    required String id,
    required String type,
    required int index,
    required BuildContext context,
    double? scale,
    Color? color,
    bool? enabled,
    required Function initFunction,
    required StateSetter modelSetState,
    required bool notUse,
  }) {
    return BlocBuilder<BillBoardTranslationBloc, BillBoardTranslationState>(
      builder: (context, state) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        if (state is BillBoardLoadedTranslationState) {
          return GestureDetector(
              onTap: enabled == false
                  ? () {}
                  : () async {
                      if (mainSkipValue) {
                        commonFlushBar(context: context, initFunction: initFunction);
                      } else {
                        context.read<BillBoardTranslationBloc>().add(BillBoardInitialTranslationEvent(
                            id: id,
                            type: type,
                            index: index,
                            context: context,
                            initFunction: notUse ? initFunction : () {},
                            setState: modelSetState,
                            valueMapList: state.valueMapList));
                      }
                    },
              child: Card(
                elevation: 1.0,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
                child: Container(
                  height: height / 34.64,
                  width: width / 16.44,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Image.asset(state.valueMapList[index].translation
                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                        : "lib/Constants/Assets/Settings/translation.png"),
                  ),
                ),
              ));
        } else {
          return GestureDetector(
              onTap: enabled == false
                  ? () {}
                  : () async {
                      if (mainSkipValue) {
                        commonFlushBar(context: context, initFunction: initFunction);
                      } else {
                        context.read<BillBoardTranslationBloc>().add(BillBoardInitialTranslationEvent(
                            id: id,
                            type: type,
                            index: index,
                            context: context,
                            initFunction: notUse ? initFunction : () {},
                            setState: modelSetState,
                            valueMapList: valueMapList));
                      }
                    },
              child: Card(
                elevation: 1.0,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
                child: Container(
                  height: height / 34.64,
                  width: width / 16.44,
                  padding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Image.asset(valueMapList[index].translation
                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                        : "lib/Constants/Assets/Settings/translation.png"),
                  ),
                ),
              ));
        }
      },
    );
  }

  believersTabBottomSheet({required BuildContext context, required String id, required bool isBelieversList}) async {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return BelieversTabBottomPage(id: id, isBelieversList: isBelieversList);
        });
  }

  believedTabBottomSheet({
    required BuildContext context,
    required String id,
    String? type,
  }) async {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return BelievedTabPage(
            id: id,
            type: type ?? "",
          );
        });
  }

  Widget verticalMenuButton({
    required BuildContext context,
    required String userId,
    required int index,
    required bool isBelieved,
    required StateSetter modelSetState,
  }) {
    return InkWell(
      onTap: () {
        showMenuSheet(context: context, userId: userId, modelSetState: modelSetState, index: index, isBelieved: isBelieved);
      },
      child: const Icon(Icons.more_vert),
    );
  }

  showMenuSheet({
    required BuildContext context,
    required String userId,
    required int index,
    required bool isBelieved,
    required StateSetter modelSetState,
  }) {
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
                      Navigator.pop(context);
                      await mainShowAlertDialog(
                          context: context, userId: userId, modelSetState: modelSetState, index: index, actionType: "Report", isBelieved: isBelieved);
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.shield,
                      size: 20,
                    ),
                    title: Text(
                      "Report User",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      await mainShowAlertDialog(
                          context: context, userId: userId, modelSetState: modelSetState, index: index, actionType: "Block", isBelieved: isBelieved);
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.flag,
                      size: 20,
                    ),
                    title: Text(
                      "Block User",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  mainShowAlertDialog({
    required BuildContext context,
    required String userId,
    required int index,
    required String actionType,
    required StateSetter modelSetState,
    required bool isBelieved,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    mainVariables.actionValueMain = actionType;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          reverse: true,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            content: SizedBox(
              height: height / 1.18,
              width: width / 1.09,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: SizedBox(
                      height: height / 3.67,
                      width: width / 1.96,
                      child: Image.asset(
                        mainVariables.actionValueMain == "Report"
                            ? isDarkTheme.value
                                ? "assets/settings/report_dark.png"
                                : "assets/settings/report_light.png"
                            : isDarkTheme.value
                                ? "assets/settings/block_dark.png"
                                : "assets/settings/block_light.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 20.3,
                  ),
                  Center(
                    child: Text(
                      'Help us understand why?',
                      style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: height / 27.06,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Action:",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400),
                            )),
                            SizedBox(
                              width: width / 2.3,
                              child: DropdownButtonFormField<String>(
                                alignment: AlignmentDirectional.center,
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: mainVariables.actionListMain
                                    .map((label) => DropdownMenuItem<String>(
                                        value: label,
                                        child: Text(
                                          label,
                                          style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                        )))
                                    .toList(),
                                value: mainVariables.actionValueMain,
                                onChanged: (String? value) {
                                  modelSetState(() {
                                    mainVariables.actionValueMain = value!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: height / 27.06,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              "Why?",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w400),
                            )),
                            SizedBox(
                              width: width / 2.3,
                              child: DropdownButtonFormField<String>(
                                icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(left: 15),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: mainVariables.whyListMain
                                    .map((label) => DropdownMenuItem<String>(
                                          value: label,
                                          child: Text(
                                            label,
                                            style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                          ),
                                        ))
                                    .toList(),
                                value: mainVariables.whyValueMain,
                                onChanged: (String? value) {
                                  modelSetState(() {
                                    mainVariables.whyValueMain = value!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  TextFormField(
                    controller: mainVariables.barController,
                    minLines: 4,
                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFFA0AEC0)),
                    keyboardType: TextInputType.name,
                    maxLines: 4,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: width / 26.78, vertical: height / 50.75),
                      hintText: "Enter a description...",
                      hintStyle: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, color: const Color(0XFFA0AEC0)),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0XFFE2E8F0), width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 33.82,
                  ),
                  GestureDetector(
                    onTap: () async {
                      logEventFunc(name: mainVariables.actionValueMain == "Report" ? 'Reported_Users' : 'Blocked_Users', type: 'User');
                      await functionsMain.reportUser(
                          action: mainVariables.actionValueMain,
                          why: mainVariables.whyValueMain,
                          description: mainVariables.barController.text,
                          userId: userId,
                          context: context);
                      if (mainVariables.actionValueMain == "Report") {
                        index == 2
                            ? debugPrint("likes")
                            : isBelieved
                                ? billBoardApiMain.getBelievedListApiFunc(id: userId, type: '', skip: "0")
                                : billBoardApiMain.getBelieversListApiFunc(id: userId, index: index, skip: '0');
                      } else {
                        isBelieved
                            ? billBoardApiMain.getBelievedListApiFunc(id: userId, type: '', skip: "0")
                            : billBoardApiMain.getBelieversListApiFunc(id: userId, index: index, skip: '0');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        color: isDarkTheme.value
                            ? const Color(0xff464646)
                            : mainVariables.actionValueMain == "Report"
                                ? const Color(0XFF0EA102)
                                : const Color(0xffFF0000),
                      ),
                      height: height / 18.45,
                      child: Center(
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(14), fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget add({
    required BuildContext context,
    required GlobalKey key,
    required double heightValue,
    required double widthValue,
    required String id,
    required String type,
    required String billBoardType,
    required String imageUrl,
    required String title,
    required String postUserId,
    required String repostUserName,
    required String profileType,
    required String tickerId,
    required String category,
    required String description,
  }) {
    return ContextualMenu(
      targetWidgetKey: key,
      ctx: context,
      backgroundColor: Colors.white,
      highlightColor: Colors.white,
      lineColor: Colors.transparent,
      onDismiss: () {},
      items: [
        CustomPopupMenuItem(
          press: postUserId == userIdMain
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You are trying to repost your own post")));
                }
              : () async {
                  logEventFunc(name: "Repost", type: type);
                  await billBoardApiMain.getRepostFunction(
                      context: context,
                      id: id,
                      type: type,
                      avatar: imageUrl,
                      repostUserName: repostUserName,
                      profileType: profileType,
                      tickerId: tickerId);
                },
          title: 'Repost',
          textAlign: TextAlign.justify,
          textStyle: TextStyle(color: postUserId == userIdMain ? Colors.grey.shade300 : Colors.black),
          image: Opacity(
            opacity: postUserId == userIdMain ? 0.3 : 1,
            child: SvgPicture.asset(
              "lib/Constants/Assets/BillBoard/repost.svg",
              height: heightValue,
              width: widthValue,
            ),
          ),
        ),
        CustomPopupMenuItem(
          press: () async {
            await billBoardFunctionsMain.linkGeneratingFunc(
                context: context,
                id: id,
                type: type,
                imageUrl: imageUrl,
                title: title,
                billBoardType: billBoardType,
                category: category,
                filterId: "",
                description: description);
            if (!context.mounted) {
              return;
            }
            linkSharingTabBottomSheet(context: context, isFromShare: true);
            /*billBoardPageName.value = "conversation";
            gettingPageRoute(pageName: billBoardPageName.value);*/
          },
          title: 'Message',
          textAlign: TextAlign.justify,
          textStyle: const TextStyle(color: Colors.black),
          image: SvgPicture.asset(
            "lib/Constants/Assets/BillBoard/messageSymbol.svg",
            height: heightValue,
            width: widthValue,
          ),
        ),
        CustomPopupMenuItem(
          press: () {
            logEventFunc(name: "Share", type: type);
            billBoardFunctionsMain.commonShareFunc(
                context: context,
                id: id,
                type: type,
                imageUrl: imageUrl,
                title: title,
                description: description,
                billBoardType: billBoardType,
                category: category,
                filterId: '');
          },
          title: 'Others',
          textAlign: TextAlign.justify,
          textStyle: const TextStyle(color: Colors.black),
          image: SvgPicture.asset(
            "lib/Constants/Assets/BillBoard/others.svg",
            height: heightValue,
            width: widthValue,
          ),
        ),
      ],
      child: SvgPicture.asset(
        isDarkTheme.value ? "assets/home_screen/share_dark.svg" : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
        height: heightValue,
        width: widthValue,
        key: key,
      ),
    );
  }

  Widget profileShare({
    required BuildContext context,
    required double heightValue,
    required double widthValue,
    required String id,
    required String type,
  }) {
    GlobalKey key = GlobalKey();
    return ContextualMenu(
      targetWidgetKey: key,
      ctx: context,
      backgroundColor: Colors.white,
      highlightColor: Colors.white,
      lineColor: Colors.transparent,
      maxColumns: 2,
      onDismiss: () {},
      items: [
        CustomPopupMenuItem(
          press: () async {
            await billBoardFunctionsMain.linkGeneratingProfileFunc(context: context, id: id, type: type);
            if (!context.mounted) {
              return;
            }
            linkSharingTabBottomSheet(context: context, isFromShare: true);
          },
          title: 'Message',
          textAlign: TextAlign.justify,
          textStyle: const TextStyle(color: Colors.black),
          image: SvgPicture.asset(
            "lib/Constants/Assets/BillBoard/messageSymbol.svg",
            height: heightValue,
            width: widthValue,
          ),
        ),
        CustomPopupMenuItem(
          press: () {
            billBoardFunctionsMain.commonShareProfileFunc(context: context, id: id, type: type);
          },
          title: 'Others',
          textAlign: TextAlign.justify,
          textStyle: const TextStyle(color: Colors.black),
          image: SvgPicture.asset(
            "lib/Constants/Assets/BillBoard/others.svg",
            height: heightValue,
            width: widthValue,
          ),
        ),
      ],
      child: SvgPicture.asset(
        isDarkTheme.value ? "assets/home_screen/share_dark.svg" : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
        height: heightValue,
        width: widthValue,
        key: key,
      ),
    );
  }

  linkSharingTabBottomSheet({required BuildContext context, required bool isFromShare}) async {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return LinkSharingBottomSheet(
            isFromShare: isFromShare,
          );
        });
  }

  Widget getSendMessageListSearchField({
    required BuildContext context,
    required String id,
    required String type,
    required StateSetter modelSetState,
    bool? isGeneral,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => TextFormField(
          controller: mainVariables.sendMessageListSearchControllerMain.value,
          onChanged: (value) async {
            if (value.isEmpty || value.isEmpty) {
              await conversationApiMain.conversationUsersList(
                  type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: 0, fromWhere: 'billboard');
              modelSetState(() {});
              FocusManager.instance.primaryFocus?.unfocus();
            } else {
              if (isGeneral != null) {
                await conversationApiMain.conversationUsersList(
                    type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: 0, fromWhere: 'billboard');
              } else {
                await conversationApiMain.conversationUsersList(
                    type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: 0, fromWhere: 'billboard');
              }
              modelSetState(() {});
            }
          },
          cursorColor: Colors.green,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              suffixIcon: mainVariables.sendMessageListSearchControllerMain.value.text.isEmpty
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () async {
                        mainVariables.sendMessageListSearchControllerMain.value.clear();
                        await conversationApiMain.conversationUsersList(
                            type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: 0, fromWhere: 'billboard');
                        modelSetState(() {});
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: const Icon(Icons.cancel, size: 22, color: Colors.black),
                    ),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
                child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
              ),
              contentPadding: EdgeInsets.zero,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
              filled: true,
              hintText: 'Search here',
              errorStyle: TextStyle(fontSize: text.scale(10))),
        ));
  }
}

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: const Color(0XFFFFFFFF),
      color: Theme.of(context).colorScheme.background,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PDF From Url'),
          backgroundColor: Colors.black,
        ),
        body: const PDF().fromUrl(
          url,
          placeholder: (double progress) => Center(child: Text('$progress %')),
          errorWidget: (dynamic error) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}

class LikeDisLikeUsersList extends StatefulWidget {
  final String billBoardId;
  final String responseId;
  final String commentId;
  final String billBoardType;
  final String action;
  final String likeCount;
  final String disLikeCount;
  final String viewCount;
  final int index;
  final bool isViewIncluded;

  const LikeDisLikeUsersList({
    Key? key,
    required this.billBoardId,
    required this.responseId,
    required this.commentId,
    required this.billBoardType,
    required this.action,
    required this.likeCount,
    required this.disLikeCount,
    required this.index,
    required this.isViewIncluded,
    required this.viewCount,
  }) : super(key: key);

  @override
  State<LikeDisLikeUsersList> createState() => _LikeDisLikeUsersListState();
}

class _LikeDisLikeUsersListState extends State<LikeDisLikeUsersList> {
  int skipLimit = 0;
  String action = "";
  int selectedIndex = 0;
  bool loader = false;
  bool contentLoader = false;

  @override
  void initState() {
    selectedIndex = widget.index;
    action = widget.action;
    getData(
        billBoardId: widget.billBoardId,
        skipLimit: skipLimit,
        billBoardType: widget.billBoardType,
        action: action,
        responseId: widget.responseId,
        commentId: widget.commentId);
    super.initState();
  }

  getData(
      {required String billBoardType,
      required String billBoardId,
      required String responseId,
      required String commentId,
      required String action,
      required int skipLimit}) async {
    selectedIndex == 0
        ? await billBoardApiMain.getViewUsersList(
            skipLimit: skipLimit,
            billBoardId: billBoardId,
            billBoardType: billBoardType,
          )
        : await billBoardApiMain.getLikeDisLikeUsersList(
            billBoardType: billBoardType,
            action: action,
            skipLimit: skipLimit,
            billBoardId: billBoardId,
            responseId: responseId,
            commentId: commentId,
          );
    setState(() {
      contentLoader = true;
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        margin: EdgeInsets.symmetric(vertical: height / 57.73, horizontal: width / 27.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                if (!mounted) {
                  return;
                }
                Navigator.pop(context);
                mainVariables.listDislikeUsersSearchControllerMain.value.clear();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            widget.isViewIncluded
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            contentLoader = false;
                          });
                          selectedIndex = 0;
                          action = "views";
                          skipLimit = 0;
                          await getData(
                              billBoardType: widget.billBoardType,
                              action: action,
                              billBoardId: widget.billBoardId,
                              responseId: widget.responseId,
                              commentId: widget.commentId,
                              skipLimit: skipLimit);
                          setState(() {
                            contentLoader = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 13.7, vertical: height / 86.6),
                          decoration: BoxDecoration(
                              color: selectedIndex == 0 ? Colors.green.shade50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: selectedIndex == 0 ? Colors.green : Colors.transparent)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: width / 25),
                                  child: const Center(
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.green,
                                    ),
                                  )),
                              Text(widget.viewCount)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            contentLoader = false;
                          });
                          selectedIndex = 1;
                          action = widget.billBoardType == "forums" ? "liked" : "likes";
                          skipLimit = 0;
                          await getData(
                              billBoardType: widget.billBoardType,
                              action: action,
                              billBoardId: widget.billBoardId,
                              responseId: widget.responseId,
                              commentId: widget.commentId,
                              skipLimit: skipLimit);
                          setState(() {
                            contentLoader = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 13.7, vertical: height / 86.6),
                          decoration: BoxDecoration(
                              color: selectedIndex == 1 ? Colors.green.shade50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: selectedIndex == 1 ? Colors.green : Colors.transparent)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: width / 25),
                                  height: height / 40.6,
                                  width: width / 18.75,
                                  child: SvgPicture.asset(
                                    isDarkTheme.value
                                        ? "assets/home_screen/like_filled_dark.svg"
                                        : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                  )),
                              Text(widget.likeCount)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            contentLoader = false;
                          });
                          selectedIndex = 2;
                          action = widget.billBoardType == "forums" ? "disliked" : "dislikes";
                          skipLimit = 0;
                          await getData(
                              billBoardType: widget.billBoardType,
                              action: action,
                              billBoardId: widget.billBoardId,
                              responseId: widget.responseId,
                              commentId: widget.commentId,
                              skipLimit: skipLimit);
                          setState(() {
                            contentLoader = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 13.7, vertical: height / 86.6),
                          decoration: BoxDecoration(
                              color: selectedIndex == 2 ? Colors.green.shade50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: selectedIndex == 2 ? Colors.green : Colors.transparent)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: width / 25),
                                  height: height / 40.6,
                                  width: width / 18.75,
                                  child: SvgPicture.asset(
                                    isDarkTheme.value
                                        ? "assets/home_screen/dislike_filled_dark.svg"
                                        : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                  )),
                              Text(widget.disLikeCount)
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            contentLoader = false;
                          });
                          selectedIndex = 1;
                          action = widget.billBoardType == "forums" ? "liked" : "likes";
                          skipLimit = 0;
                          await getData(
                              billBoardType: widget.billBoardType,
                              action: action,
                              billBoardId: widget.billBoardId,
                              responseId: widget.responseId,
                              commentId: widget.commentId,
                              skipLimit: skipLimit);
                          setState(() {
                            contentLoader = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 13.7, vertical: height / 86.6),
                          decoration: BoxDecoration(
                              color: selectedIndex == 1 ? Colors.green.shade50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: selectedIndex == 1 ? Colors.green : Colors.transparent)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: width / 25),
                                  height: height / 40.6,
                                  width: width / 18.75,
                                  child: SvgPicture.asset(
                                    isDarkTheme.value
                                        ? "assets/home_screen/like_filled_dark.svg"
                                        : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                  )),
                              Text(widget.likeCount)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            contentLoader = false;
                          });
                          selectedIndex = 2;
                          action = widget.billBoardType == "forums" ? "disliked" : "dislikes";
                          skipLimit = 0;
                          await getData(
                              billBoardType: widget.billBoardType,
                              action: action,
                              billBoardId: widget.billBoardId,
                              responseId: widget.responseId,
                              commentId: widget.commentId,
                              skipLimit: skipLimit);
                          setState(() {
                            contentLoader = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 13.7, vertical: height / 86.6),
                          decoration: BoxDecoration(
                              color: selectedIndex == 2 ? Colors.green.shade50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: selectedIndex == 2 ? Colors.green : Colors.transparent)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: width / 25),
                                  height: height / 40.6,
                                  width: width / 18.75,
                                  child: SvgPicture.asset(
                                    isDarkTheme.value
                                        ? "assets/home_screen/dislike_filled_dark.svg"
                                        : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                  )),
                              Text(widget.disLikeCount)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
            SizedBox(
              height: height / 86.6,
            ),
            SizedBox(
              height: height / 18,
              child: billboardWidgetsMain.getLikeDisLikeUsersSearchField(
                  context: context,
                  modelSetState: setState,
                  billBoardType: widget.billBoardType,
                  billBoardId: widget.billBoardId,
                  responseId: widget.responseId,
                  commentId: widget.commentId,
                  action: action,
                  skipLimit: 0,
                  selectedIndex: selectedIndex),
            ),
            SizedBox(
              height: height / 86.6,
            ),
            SizedBox(
                height: height / 2.47,
                child: Obx(
                  () => mainVariables.likeDisLikeUserSearchDataList.isEmpty
                      ? Center(
                          child: Text(
                            selectedIndex == 0
                                ? "No users viewed this post"
                                : selectedIndex == 1
                                    ? "No users liked this post"
                                    : "No users disliked this post",
                            style: TextStyle(color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontSize: text.scale(12)),
                          ),
                        )
                      : contentLoader
                          ? SmartRefresher(
                              controller: mainVariables.likeDislikeRefreshController,
                              enablePullDown: false,
                              enablePullUp: true,
                              footer: const ClassicFooter(
                                loadStyle: LoadStyle.ShowWhenLoading,
                              ),
                              onLoading: () async {
                                setState(() {
                                  skipLimit = skipLimit + 20;
                                });
                                await getData(
                                    billBoardType: widget.billBoardType,
                                    action: action,
                                    billBoardId: widget.billBoardId,
                                    responseId: widget.responseId,
                                    commentId: widget.commentId,
                                    skipLimit: skipLimit);
                                loadingRefreshController.loadComplete();
                                setState(() {});
                              },
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: mainVariables.likeDisLikeUserSearchDataList.length,
                                  physics: const ScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                            onTap: () async {
                                              if (mainVariables.likeDisLikeUserSearchDataList[index].profileType != "user" &&
                                                  mainVariables.likeDisLikeUserSearchDataList[index].profileType != "intermediate") {
                                                mainVariables.selectedTickerId.value = mainVariables.likeDisLikeUserSearchDataList[index].tickerId;
                                              }
                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return mainVariables.likeDisLikeUserSearchDataList[index].profileType == "intermediate"
                                                    ? IntermediaryBillBoardProfilePage(
                                                        userId: mainVariables.likeDisLikeUserSearchDataList[index].userId)
                                                    : mainVariables.likeDisLikeUserSearchDataList[index].profileType != "user"
                                                        ? const BusinessProfilePage()
                                                        : UserBillBoardProfilePage(userId: mainVariables.likeDisLikeUserSearchDataList[index].userId);
                                              }));
                                            },
                                            minLeadingWidth: width / 25,
                                            leading: Container(
                                                height: height / 24.74,
                                                width: width / 11.74,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(mainVariables.likeDisLikeUserSearchDataList[index].avatar),
                                                        fit: BoxFit.fill))),
                                            title: Text(
                                              "${mainVariables.likeDisLikeUserSearchDataList[index].firstName} ${mainVariables.likeDisLikeUserSearchDataList[index].lastName}",
                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14)),
                                            ),
                                            subtitle: IntrinsicHeight(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    mainVariables.likeDisLikeUserSearchDataList[index].username,
                                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: text.scale(10)),
                                                  ),
                                                  const VerticalDivider(
                                                    thickness: 1.5,
                                                  ),
                                                  Text(
                                                    "${mainVariables.likeDisLikeUserSearchDataList[index].believersCount} Believers",
                                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: text.scale(10)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            trailing: mainVariables.likeDisLikeUserSearchDataList[index].userId == userIdMain
                                                ? const SizedBox()
                                                : SizedBox(
                                                    width: width / 3.5,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        billboardWidgetsMain.getBottomSheetBelieveButton(
                                                          heightValue: height / 33.76,
                                                          index: index,
                                                          billboardUserid: mainVariables.likeDisLikeUserSearchDataList[index].userId,
                                                          billboardUserName: mainVariables.likeDisLikeUserSearchDataList[index].username,
                                                          context: context,
                                                          modelSetState: setState,
                                                          isBelieved: false,
                                                          isNotBelieved: true,
                                                        ),
                                                        billboardWidgetsMain.verticalMenuButton(
                                                          context: context,
                                                          userId: mainVariables.likeDisLikeUserSearchDataList[index].userId,
                                                          modelSetState: setState,
                                                          index: 2,
                                                          isBelieved: false,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                            /*Container(
                                          margin: EdgeInsets.only(
                                              right: _width / 25),
                                          height: _height / 40.6,
                                          width: _width / 18.75,
                                          child: selectedIndex == 0
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      right: _width / 25),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.remove_red_eye,
                                                      color: Colors.green,
                                                    ),
                                                  ))
                                              : SvgPicture.asset(selectedIndex ==
                                                      1
                                                  ? isDarkTheme.value? "assets/home_screen/like_filled_dark.svg": "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                  : isDarkTheme.value? "assets/home_screen/dislike_filled_dark.svg": "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",))*/
                                            ),
                                        const Divider(
                                          thickness: 0.0,
                                          height: 0.0,
                                        ),
                                      ],
                                    );
                                  }),
                            )
                          : Center(
                              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                            ),
                )),
          ],
        ),
      ),
    );
  }
}

class BelieversTabBottomPage extends StatefulWidget {
  final String id;
  final bool isBelieversList;

  const BelieversTabBottomPage({
    Key? key,
    required this.id,
    required this.isBelieversList,
  }) : super(key: key);

  @override
  State<BelieversTabBottomPage> createState() => _BelieversTabBottomPageState();
}

class _BelieversTabBottomPageState extends State<BelieversTabBottomPage> with SingleTickerProviderStateMixin {
  bool loader = false;
  bool contentLoader = false;
  TabController? _tabController;
  bool isBelieversList = true;

  @override
  void initState() {
    isBelieversList = widget.isBelieversList;
    _tabController = TabController(initialIndex: isBelieversList ? 0 : 1, length: 2, vsync: this);
    getData();
    super.initState();
  }

  getData() async {
    await billBoardApiMain.getBelieversListApiFunc(id: widget.id, index: isBelieversList ? 0 : 1, skip: '0');
    setState(() {
      contentLoader = true;
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: height / 1.732,
              width: width,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBelieversList ? "Believers" : "Profile Visits",
                        style: TextStyle(color: Colors.black, fontSize: text.scale(18), fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          onPressed: () {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.highlight_remove_sharp))
                    ],
                  ),
                  widget.id == userIdMain ? SizedBox(height: height / 57.73) : const SizedBox(),
                  widget.id == userIdMain
                      ? TabBar(
                          isScrollable: false,
                          controller: _tabController,
                          labelPadding: const EdgeInsets.all(0),
                          indicatorColor: Colors.green,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelColor: Colors.black,
                          unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          labelColor: Colors.green,
                          dividerColor: Colors.transparent,
                          dividerHeight: 0.0,
                          labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          tabs: const [
                            Tab(
                              text: "Believers",
                            ),
                            Tab(text: "Profile visits"),
                          ],
                          onTap: (index) async {
                            setState(() {
                              contentLoader = false;
                            });
                            await billBoardApiMain.getBelieversListApiFunc(id: widget.id, index: index, skip: '0');
                            setState(() {
                              isBelieversList = !isBelieversList;
                              contentLoader = true;
                            });
                          },
                        )
                      : const SizedBox(),
                  SizedBox(height: height / 57.73),
                  billboardWidgetsMain.getBelieversListSearchField(
                    context: context,
                    id: widget.id,
                    modelSetState: setState,
                    index: _tabController!.index,
                  ),
                  SizedBox(height: height / 57.73),
                  Obx(
                    () => mainVariables.believedUsersList.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: isBelieversList ? 'Still no users believed this profile' : 'No profiles visited this profile',
                                          style: const TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: contentLoader
                                ? ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: const ScrollPhysics(),
                                    itemCount: mainVariables.believedUsersList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          if (mainVariables.believedUsersList[index].profileType == "business") {
                                            mainVariables.selectedTickerId.value = mainVariables.believedUsersList[index].tickerId;
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => mainVariables.believedUsersList[index].profileType == "user"
                                                      ? UserBillBoardProfilePage(userId: mainVariables.believedUsersList[index].userId)
                                                      : mainVariables.believedUsersList[index].profileType == "business"
                                                          ? const BusinessProfilePage()
                                                          : mainVariables.believedUsersList[index].profileType == "intermediate"
                                                              ? IntermediaryBillBoardProfilePage(
                                                                  userId: mainVariables.believedUsersList[index].userId)
                                                              : Container()));
                                        },
                                        child: Container(
                                          height: height / 14.32,
                                          width: width,
                                          margin: EdgeInsets.symmetric(vertical: height / 86.6),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage: NetworkImage(mainVariables.believedUsersList[index].avatar),
                                                  ),
                                                  SizedBox(
                                                    width: width / 27.4,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${mainVariables.believedUsersList[index].firstName.toString().capitalizeFirst!} ${mainVariables.believedUsersList[index].lastName.toString().capitalizeFirst!}",
                                                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Colors.black),
                                                      ),
                                                      Text(
                                                        mainVariables.believedUsersList[index].username,
                                                        style: TextStyle(
                                                            fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF737373)),
                                                      ),
                                                      IntrinsicHeight(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "${mainVariables.believedUsersList[index].believersCount} Believers",
                                                              style: TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  fontWeight: FontWeight.w500,
                                                                  color: const Color(0XFF737373)),
                                                            ),
                                                            mainVariables.believedUsersList[index].visitedDateTime != ""
                                                                ? const VerticalDivider(
                                                                    thickness: 1.5,
                                                                  )
                                                                : const SizedBox(),
                                                            mainVariables.believedUsersList[index].visitedDateTime != ""
                                                                ? Text(
                                                                    mainVariables.believedUsersList[index].visitedDateTime,
                                                                    style: const TextStyle(
                                                                        fontWeight: FontWeight.w500, fontSize: 10, color: Color(0XFF737373)),
                                                                  )
                                                                : const SizedBox(),
                                                            const VerticalDivider(
                                                              thickness: 1.5,
                                                            ),
                                                            Text(
                                                              mainVariables.believedUsersList[index].profileType == "intermediate"
                                                                  ? "Intermediary"
                                                                  : mainVariables.believedUsersList[index].profileType.toString().capitalizeFirst!,
                                                              style: const TextStyle(
                                                                  fontWeight: FontWeight.w500, fontSize: 10, color: Color(0XFF737373)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              mainVariables.believedUsersList[index].userId == userIdMain
                                                  ? const SizedBox()
                                                  : Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        billboardWidgetsMain.getBottomSheetBelieveButton(
                                                          heightValue: height / 33.76,
                                                          index: index,
                                                          billboardUserid: mainVariables.believedUsersList[index].userId,
                                                          billboardUserName: mainVariables.believedUsersList[index].username,
                                                          context: context,
                                                          modelSetState: setState,
                                                          isBelieved: false,
                                                          isNotBelieved: false,
                                                        ),
                                                        billboardWidgetsMain.verticalMenuButton(
                                                          context: context,
                                                          userId: mainVariables.believedUsersList[index].userId,
                                                          modelSetState: setState,
                                                          index: isBelieversList ? 0 : 1,
                                                          isBelieved: false,
                                                        ),
                                                      ],
                                                    )
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : Center(
                                    child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                                  ),
                          ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: height / 1.732,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
            decoration: const BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
            child: Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
            ),
          );
  }
}

class BelievedTabPage extends StatefulWidget {
  final String id;
  final String type;

  const BelievedTabPage({Key? key, required this.id, required this.type}) : super(key: key);

  @override
  State<BelievedTabPage> createState() => _BelievedTabPageState();
}

class _BelievedTabPageState extends State<BelievedTabPage> {
  bool loader = false;
  int skipCount = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await billBoardApiMain.getBelievedListApiFunc(id: widget.id, type: widget.type, skip: skipCount.toString());
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: height / 1.732,
              width: width,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 57.73,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.type == "" ? "My Believed List" : "Reposted Users",
                        style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                          onPressed: () {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.highlight_remove_sharp))
                    ],
                  ),
                  SizedBox(height: height / 57.73),
                  billboardWidgetsMain.getBelievedListSearchField(
                    context: context,
                    id: widget.id,
                    modelSetState: setState,
                    type: widget.type,
                  ),
                  SizedBox(height: height / 57.73),
                  Obx(
                    () => mainVariables.believedUsersList.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'No believed users found',
                                          style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: SmartRefresher(
                            controller: loadingRefreshControllerBelievedUsersList,
                            enablePullDown: false,
                            enablePullUp: true,
                            footer: const ClassicFooter(
                              loadStyle: LoadStyle.ShowWhenLoading,
                            ),
                            onLoading: () async {
                              skipCount = skipCount + 10;
                              getData();
                              if (mounted) {
                                setState(() {});
                              }
                              loadingRefreshControllerBelievedUsersList.loadComplete();
                              setState(() {});
                            },
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const ScrollPhysics(),
                                itemCount: mainVariables.believedUsersList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      if (mainVariables.believedUsersList[index].profileType == "business") {
                                        mainVariables.selectedTickerId.value = mainVariables.believedUsersList[index].tickerId;
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => mainVariables.believedUsersList[index].profileType == "user"
                                                  ? UserBillBoardProfilePage(userId: mainVariables.believedUsersList[index].userId)
                                                  : mainVariables.believedUsersList[index].profileType == "business"
                                                      ? const BusinessProfilePage()
                                                      : mainVariables.believedUsersList[index].profileType == "intermediate"
                                                          ? IntermediaryBillBoardProfilePage(userId: mainVariables.believedUsersList[index].userId)
                                                          : Container()));
                                    },
                                    child: Container(
                                      height: height / 14.32,
                                      width: width,
                                      margin: EdgeInsets.symmetric(vertical: height / 86.6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundImage: NetworkImage(mainVariables.believedUsersList[index].avatar),
                                              ),
                                              SizedBox(
                                                width: width / 27.4,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: width / 2.25,
                                                    child: Text(
                                                      "${mainVariables.believedUsersList[index].firstName.toString().capitalizeFirst!} ${mainVariables.believedUsersList[index].lastName.toString().capitalizeFirst!}",
                                                      style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                  Text(
                                                    mainVariables.believedUsersList[index].username,
                                                    style: TextStyle(
                                                        fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF737373)),
                                                  ),
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${mainVariables.believedUsersList[index].believersCount} believers",
                                                          style: TextStyle(
                                                              fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF737373)),
                                                        ),
                                                        mainVariables.believedUsersList[index].visitedDateTime != ""
                                                            ? const VerticalDivider()
                                                            : const SizedBox(),
                                                        Text(
                                                          mainVariables.believedUsersList[index].visitedDateTime,
                                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 8),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              mainVariables.believedUsersList[index].userId == userIdMain
                                                  ? const SizedBox()
                                                  : billboardWidgetsMain.getBottomSheetBelieveButton(
                                                      heightValue: height / 33.76,
                                                      index: index,
                                                      billboardUserid: mainVariables.believedUsersList[index].userId,
                                                      billboardUserName: mainVariables.believedUsersList[index].username,
                                                      context: context,
                                                      modelSetState: setState,
                                                      isBelieved: true,
                                                      isNotBelieved: false,
                                                    ),
                                              billboardWidgetsMain.verticalMenuButton(
                                                context: context,
                                                userId: mainVariables.believedUsersList[index].userId,
                                                modelSetState: setState,
                                                index: 0,
                                                isBelieved: true,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )),
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: height / 1.732,
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
            child: Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
            ),
          );
  }
}

class LinkSharingBottomSheet extends StatefulWidget {
  final bool isFromShare;

  const LinkSharingBottomSheet({Key? key, required this.isFromShare}) : super(key: key);

  @override
  State<LinkSharingBottomSheet> createState() => _LinkSharingBottomSheetState();
}

class _LinkSharingBottomSheetState extends State<LinkSharingBottomSheet> with TickerProviderStateMixin {
  bool loader = false;
  bool isCreateGroup = false;
  int skipCount = 0;
  bool isGeneral = false;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  getData() async {
    await conversationApiMain.conversationUsersList(
        type: mainVariables.isGeneralConversationList.value ? "general" : "believers", skipCount: skipCount, fromWhere: 'conversation');
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SizedBox(
        height: height / 1.23,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height / 41.23,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                    child: Text(
                      "Share",
                      style: TextStyle(color: const Color(0XFF222222), fontSize: text.scale(20), fontWeight: FontWeight.w900),
                    )),
                IconButton(
                    onPressed: () {
                      mainVariables.messageSentList.clear();
                      mainVariables.sendMessageListSearchControllerMain.value.clear();
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.clear))
              ],
            ),
            SizedBox(
              height: height / 57.73,
            ),
            PreferredSize(
                preferredSize: Size.fromWidth(width / 29.2),
                child: SizedBox(
                  height: height / 20.55,
                  child: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      unselectedLabelColor: const Color(0XFF303030),
                      labelColor: const Color(0XFF11AA04),
                      indicatorColor: Colors.transparent,
                      indicatorWeight: 0.1,
                      dividerColor: Colors.transparent,
                      dividerHeight: 0.0,
                      onTap: (value) {
                        mainVariables.sendMessageListSearchControllerMain.value.clear();
                        getData();
                      },
                      tabs: [
                        Tab(
                          child: Text(
                            'Believers',
                            style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'General',
                            style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ]),
                )),
            SizedBox(
              height: height / 57.73,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              child: billboardWidgetsMain.getSendMessageListSearchField(
                  context: context, id: userIdMain, modelSetState: setState, type: "", isGeneral: isGeneral),
            ),
            SizedBox(
              height: height / 57.73,
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.only(top: height / 54.125),
                  decoration: BoxDecoration(
                      color: const Color(0XFFF9FFF9),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(color: Colors.black26.withOpacity(0.1), offset: const Offset(0.0, -1.0), blurRadius: 1.0, spreadRadius: 2.0)
                      ]),
                  child: TabBarView(
                    controller: _tabController,
                    physics: const ScrollPhysics(),
                    clipBehavior: Clip.hardEdge,
                    children: [
                      BelieversTabConversationSendMessageList(isFromShare: widget.isFromShare),
                      GeneralTabConversationSendMessageList(isFromShare: widget.isFromShare),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
