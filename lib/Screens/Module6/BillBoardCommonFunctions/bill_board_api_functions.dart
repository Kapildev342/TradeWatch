import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/Api.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_main_page_model.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/videos_main_page_model.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forums_main_page_model.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_main_page_model.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/final_chart_page.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/over_view_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/believers_list_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_comments_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_description_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_features_list_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_like_dislike_users_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_main_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_repost_list_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_response_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_similar_content_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/popular_traders_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/user_search_data_model.dart';

class BillBoardApiFunctions {
  Future<bool> likeAddOrRemoveApiFunc({
    required BuildContext context,
    required String likeType,
    required String id,
    required String responseId,
    required String commentId,
    required bool removalStatus,
    required String billBoardType,
  }) async {
    String uri;
    Map<String, dynamic>? data = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    if (billBoardType == "news" || billBoardType == "videos") {
      uri = likeType == "likes" ? baseurl + versionLocker + likes : baseurl + versionLocker + dislikes;
      data = {
        "id": id,
        "type": billBoardType,
      };
    } else {
      uri = commentId != ""
          ? baseurl + versionBillBoard + billBoardComments + likeDislike
          : responseId != ""
              ? baseurl + versionBillBoard + billBoardResponse + likeDislike
              : baseurl + versionBillBoard + likeDislike;
      data = {
        "type": likeType,
        "billboard_id": id,
        "response_id": responseId,
        "comment_id": commentId,
        "action": removalStatus,
        "post_type": billBoardType,
      };
    }
    var response = await dioMain.post(uri,
        options: Options(
          headers: {
            "authorization": mainUserToken,
          },
        ),
        data: data);
    var responseData = response.data;

    if (responseData['status'] == true) {
      switch (responseData['message']) {
        case "likes added successfully":
          logEventFunc(name: "Likes", type: billBoardType);
          break;
        case "likes removed successfully":
          logEventFunc(name: "Like_Removed", type: billBoardType);
          break;
        case "dislikes added successfully":
          logEventFunc(name: "Dislikes", type: billBoardType);
          break;
        case "dislikes removed successfully":
          logEventFunc(name: "Dislike_Removed", type: billBoardType);
          break;
        default:
          logEventFunc(name: "Likes", type: billBoardType);
          break;
      }
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<bool> shareFunction({required BuildContext context, required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = Uri.parse(baseurl + versionLocker + share);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == false) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<bool> getRepostFunction({
    required BuildContext context,
    required String id,
    required String type,
    required String avatar,
    required String repostUserName,
    required String profileType,
    required String tickerId,
  }) async {
    var uri = Uri.parse(baseurl + versionBillBoard + addRepost);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "type": type == "byte" || type == "blog" ? "billboard" : type,
      "post_id": id,
      "avatar": avatar,
      "repost_username": repostUserName,
      "profile_type": profileType,
      "ticker_id": tickerId,
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData["status"] == false) {
      if (!context.mounted) {
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData["message"])));
    }
    return responseData["status"];
  }

  Future<bool> getRepostListFunction({
    required String userId,
    required String skipCount,
  }) async {
    var uri = Uri.parse(baseurl + versionBillBoard + repostList);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "userId": userId,
      "skip": skipCount,
      "limit": "10",
      "search": mainVariables.billBoardListSearchControllerMain.value.text
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    mainVariables.billBoardRepostList = (BillBoardRepostListModel.fromJson(responseData)).obs;
    return responseData["status"];
  }

  Future<bool> getFeatureListFunction({
    required String userId,
    required String tickerId,
    required String skipCount,
  }) async {
    var uri = Uri.parse(baseurl + versionBillBoard + featuresList);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "userId": userId,
      "ticker_id": tickerId,
      "skip": skipCount,
      "limit": "10",
      "search": mainVariables.billBoardListSearchControllerMain.value.text
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    mainVariables.billBoardFeaturesList = (BillboardFeaturesListModel.fromJson(responseData)).obs;
    return responseData["status"];
  }

  Future<Map<String, dynamic>> getUserBelieve({
    required String id,
    required String name,
  }) async {
    var uri = Uri.parse(baseurl + versions + believeUser);
    print("uri");
    print(uri);
    print({
      "authorization": kToken,
    });
    print({"believed_id": id, "believed_name": name});
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "believed_id": id,
      "believed_name": name
    });
    Map<String, dynamic> responseData = jsonDecode(response.body);
    print("responseData");
    print(responseData);
    return responseData;
  }

  getPopularTraderData({
    required String searchValue,
    required BuildContext context,
    String? skip,
    String? limit,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = Uri.parse(baseurl + versions + popularTradersList);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "search": searchValue,
      "skip": skip ?? "0",
      "limit": limit ?? "100",
    });
    var responseData = jsonDecode(response.body);
    mainVariables.popularSearchDataMain = PopularTradersModel.fromJson(responseData).obs;
    if (mainVariables.popularSearchDataMain!.value.status == false) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: mainVariables.popularSearchDataMain!.value.message,
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      mainVariables.popularSearchDataBelievedList.clear();
      mainVariables.popularSearchDataBelievedList.addAll(List.generate(mainVariables.popularSearchDataMain!.value.response.length,
          (index) => mainVariables.popularSearchDataMain!.value.response[index].believed));
    }
  }

  getBillBoardListApiFunc({
    required BuildContext context,
    required RxList<String> category,
    required String contentType,
    required String profile,
    required String userId,
    String? tickerId,
    required int skipBillBoardCount,
    required int skipSurveyCount,
    required int skipForumCount,
    required int skipNewsCount,
    required List<String> tickers,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = baseurl + versionBillBoard + billboardList;
    var response = await dioMain.post(uri,
        options: Options(headers: {
          "authorization": mainUserToken,
        }),
        data: {
          "category": category,
          "content_type": contentType,
          "select_profile": profile,
          "action": mainVariables.activeTypeMain.value,
          "limit": 10,
          "skip_billboard": skipBillBoardCount,
          "skip_survey": skipSurveyCount,
          "skip_forum": skipForumCount,
          "skip_news": skipNewsCount,
          "tickers": tickers,
          "userId": userId,
          "search": mainVariables.billBoardListSearchControllerMain.value.text,
          "ticker_id": tickerId ?? "",
          "post_date": mainVariables.initialPostDate.value,
        });
    Map<String, dynamic> responseData = response.data;
    if (responseData['status'] == true) {
      mainVariables.billBoardDataProfilePage = (BillboardMainModel.fromJson(responseData)).obs;
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  Future<bool> getAddBillboardResponse({
    required BuildContext context,
    required String contentType,
    required String billBoardId,
    required String message,
    required String postUserId,
    required String responseId,
    required String urlType,
    required String category,
    File? file,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    if (file == null) {
      var uri = contentType == "forums" ? Uri.parse(baseurl + versionForum + responseAdd) : Uri.parse(baseurl + versionBillBoard + responseAdd);
      Map<String, dynamic> data = contentType == "forums"
          ? {
              "category": category,
              "forum_id": billBoardId,
              "category_id": category == "stocks"
                  ? mainCatIdList[0]
                  : category == "crypto"
                      ? mainCatIdList[1]
                      : category == "commodity"
                          ? mainCatIdList[2]
                          : category == "forex"
                              ? mainCatIdList[3]
                              : "",
              "message": message,
              "message_id": responseId,
            }
          : {
              "billboard_id": billBoardId,
              "message": message,
              "post_user": postUserId,
              "response_id": responseId,
              "file_type": urlType,
            };
      var response = await http.post(uri,
          headers: {
            "authorization": mainUserToken,
          },
          body: data);
      var responseData = jsonDecode(response.body);

      if (responseData['status']) {
        logEventFunc(name: "Commented", type: contentType);
        if (!context.mounted) {
          return false;
        }
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (!context.mounted) {
          return false;
        }
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
      return responseData['status'];
    } else {
      var uri = contentType == "forums" ? baseurl + versionForum + responseAdd : baseurl + versionBillBoard + responseAdd;
      Map<String, dynamic> dataNew = contentType == "forums"
          ? {
              "category": category,
              "forum_id": billBoardId,
              "url_type": urlType,
              "category_id": category == "stocks"
                  ? mainCatIdList[0]
                  : category == "crypto"
                      ? mainCatIdList[1]
                      : category == "commodity"
                          ? mainCatIdList[2]
                          : category == "forex"
                              ? mainCatIdList[3]
                              : "",
              "message": message,
              "message_id": responseId,
            }
          : {
              "billboard_id": billBoardId,
              "message": message,
              "post_user": postUserId,
              "response_id": responseId,
              "file_type": urlType,
            };
      var res1 = await functionsMain.sendForm(uri, dataNew, {'file': file});
      if (res1.data["status"]) {
        logEventFunc(name: "Commented", type: contentType);
        if (!context.mounted) {
          return false;
        }
        Flushbar(
          message: res1.data["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (!context.mounted) {
          return false;
        }
        Flushbar(
          message: res1.data["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
      return res1.data['status'];
    }
  }

  Future<bool> getDeleteBillboardResponse({
    required BuildContext context,
    required String billBoardId,
    required String type,
    required String responseId,
    required String commentId,
    required String contentType,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    Map<String, dynamic> deleteBodyData = {};
    Uri uri = Uri.parse("");
    switch (contentType) {
      case 'blog':
        {
          uri = Uri.parse(baseurl + versionBillBoard + billBoardRemove);
          deleteBodyData = {"billboard_id": billBoardId, "type": type, "response_id": responseId, "comment_id": commentId};
          break;
        }
      case 'blog_response':
        {
          uri = Uri.parse(baseurl + versionBillBoard + billBoardRemove);
          deleteBodyData = {"billboard_id": billBoardId, "type": type, "response_id": responseId, "comment_id": commentId};
          break;
        }
      case 'blog_comments':
        {
          uri = Uri.parse(baseurl + versionBillBoard + billBoardRemove);
          deleteBodyData = {"billboard_id": billBoardId, "type": type, "response_id": responseId, "comment_id": commentId};
          break;
        }
      case 'forums':
        {
          uri = Uri.parse(baseurl + versionForum + forumDelete);
          deleteBodyData = {"forum_id": billBoardId};
          break;
        }
      case 'byte':
        {
          uri = Uri.parse(baseurl + versionBillBoard + billBoardRemove);
          deleteBodyData = {"billboard_id": billBoardId, "type": type, "response_id": responseId, "comment_id": commentId};
          break;
        }
      case 'survey':
        {
          uri = Uri.parse(baseurl + versionSurvey + deleteSurvey);
          deleteBodyData = {"survey_id": billBoardId};
          break;
        }
      default:
        {
          break;
        }
    }
    var response = await http.post(uri,
        headers: {
          "authorization": mainUserToken,
        },
        body: deleteBodyData);
    var responseData = jsonDecode(response.body);

    if (responseData['status']) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<String> fileUploadBillBoard({required File file, required BuildContext context}) async {
    var uri = baseurl + versionBillBoard + fileAdd;
    var res1 = await functionsMain.sendForm(uri, {"id": "1"}, {'file': file});
    if (res1.data["status"]) {
      return res1.data['response'][0];
    } else {
      return "";
    }
  }

  Future<bool> fileRemoveBillBoard({required BuildContext context, required String filePath}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = baseurl + versionBillBoard + fileRemove;
    var response = await dioMain.post(uri,
        options: Options(headers: {
          "authorization": mainUserToken,
        }),
        data: {
          "file_path": filePath,
        });
    Map<String, dynamic> responseData = response.data;
    if (responseData['status'] == true) {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<BillBoardDescriptionModel> getBillBoardSingleData({required BuildContext context, required String id}) async {
    BillBoardDescriptionModel? billboard;
    var uri = baseurl + versionBillBoard + getBillBoard;
    var response = await dioMain.post(uri,
        options: Options(headers: {
          "authorization": kToken,
        }),
        data: {
          "billboard_id": id,
        });
    Map<String, dynamic> responseData = response.data;
    if (responseData['status'] == true) {
      billboard = BillBoardDescriptionModel.fromJson(responseData);
    } else {
      if (!context.mounted) {
        return BillBoardDescriptionModel.fromJson({});
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return billboard!;
  }

  Future<BillBoardResponseModel> getBillBoardResponseData({
    required BuildContext context,
    required String id,
    required String sortType,
  }) async {
    BillBoardResponseModel? billboardResponse;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = baseurl + versionBillBoard + responseList;
    var response = await dioMain.post(uri,
        options: Options(headers: {
          "authorization": mainUserToken,
        }),
        data: {"billboard_id": id, "sort_type": mainVariables.selectedResponseSortTypeMain.value});
    Map<String, dynamic> responseData = response.data;
    if (responseData['status'] == true) {
      billboardResponse = BillBoardResponseModel.fromJson(responseData);
    } else {
      if (!context.mounted) {
        return BillBoardResponseModel.fromJson({});
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return billboardResponse!;
  }

  Future<BillBoardSimilarContentModel> getBillBoardRelatedData({
    required BuildContext context,
    required String id,
  }) async {
    BillBoardSimilarContentModel? billboardResponse;
    var uri = baseurl + versionBillBoard + similarContent;
    var response = await dioMain.post(uri,
        options: Options(headers: {
          "authorization": kToken,
        }),
        data: {"post_id": id});
    Map<String, dynamic> responseData = response.data;
    if (responseData['status'] == true) {
      billboardResponse = BillBoardSimilarContentModel.fromJson(responseData);
    } else {
      if (!context.mounted) {
        return BillBoardSimilarContentModel.fromJson({});
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return billboardResponse!;
  }

  Future<BillBoardCommentsModel> getBillBoardCommentsData({
    required BuildContext context,
    required String id,
    required String responseId,
  }) async {
    BillBoardCommentsModel? billboardComments;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = baseurl + versionBillBoard + commentsList;
    var response = await dioMain.post(uri,
        options: Options(headers: {
          "authorization": mainUserToken,
        }),
        data: {
          "billboard_id": id,
          "response_id": responseId,
          "sort_type": mainVariables.selectedResponseSortTypeMain.value,
          "filter": mainVariables.selectedCommentsFilter.value,
        });
    Map<String, dynamic> responseData = response.data;
    if (responseData['status'] == true) {
      billboardComments = BillBoardCommentsModel.fromJson(responseData);
    } else {
      if (!context.mounted) {
        return BillBoardCommentsModel.fromJson({});
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return billboardComments!;
  }

  Future<bool> getAddBillboardResponseComments({
    required BuildContext context,
    required String billBoardId,
    required String message,
    required String postUserId,
    required String responseId,
    required String responseUserId,
    required String commentId,
    required String urlType,
    File? file,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    if (file == null) {
      var uri = Uri.parse(baseurl + versionBillBoard + commentsAddUpdate);
      var response = await http.post(uri, headers: {
        "authorization": mainUserToken,
      }, body: {
        "billboard_id": billBoardId,
        "message": message,
        "billboard_user": postUserId,
        "response_user": responseUserId,
        "response_id": responseId,
        "comment_id": commentId,
        "file_type": urlType,
      });
      var responseData = jsonDecode(response.body);
      if (responseData['status']) {
        if (!context.mounted) {
          return false;
        }
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (!context.mounted) {
          return false;
        }
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
      return responseData['status'];
    } else {
      var uri = baseurl + versionBillBoard + commentsAddUpdate;
      Map<String, dynamic> dataNew = {
        "billboard_id": billBoardId,
        "message": message,
        "billboard_user": postUserId,
        "response_user": responseUserId,
        "response_id": responseId,
        "comment_id": commentId,
        "file_type": urlType,
      };
      var res1 = await functionsMain.sendForm(uri, dataNew, {'file': file});
      if (res1.data["status"]) {
        if (!context.mounted) {
          return false;
        }
        Flushbar(
          message: res1.data["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (!context.mounted) {
          return false;
        }
        Flushbar(
          message: res1.data["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
      return res1.data["status"];
    }
  }

  getReportOrBlockPost(
      {required BuildContext context,
      required String contentType,
      required String action,
      required String why,
      required String description,
      required String id,
      required String userId}) async {
    if (why == "Other") {
      if (description == "") {
        Flushbar(
          message: "Please describe the reason in the description ",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        var url = contentType == "forums"
            ? Uri.parse(baseurl + versionForum + addReport)
            : contentType == "survey"
                ? Uri.parse(baseurl + versionSurvey + surveyAddReport)
                : Uri.parse("");
        Map<String, dynamic> data = contentType == "forums"
            ? {"action": action, "why": why, "description": description, "forum_id": id, "forum_user": userId}
            : contentType == "survey"
                ? {"action": action, "why": why, "description": description, "survey_id": id, "survey_user": userId}
                : {"action": action, "why": why, "description": description, "billboard_id": id, "billboard_user": userId};
        var responseNew = await http.post(url, body: data, headers: {'Authorization': kToken});
        var responseDataNew = json.decode(responseNew.body);
        if (responseDataNew["status"]) {
          if (context.mounted) {
            Navigator.pop(context);
            Flushbar(
              message: responseDataNew["message"],
              duration: const Duration(seconds: 2),
            ).show(context);
          }

          // getForumValues(text: "",category: selectedValue,filterId: filterId);
        } else {
          if (!context.mounted) {
            return;
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      }
    } else {
      var url = contentType == "forums"
          ? Uri.parse(baseurl + versionForum + addReport)
          : contentType == "survey"
              ? Uri.parse(baseurl + versionSurvey + surveyAddReport)
              : Uri.parse(baseurl + versionBillBoard + billBoardBlockReport);
      Map<String, dynamic> data = contentType == "forums"
          ? {"action": action, "why": why, "description": description, "forum_id": id, "forum_user": userId}
          : contentType == "survey"
              ? {"action": action, "why": why, "description": description, "survey_id": id, "survey_user": userId}
              : {"action": action, "why": why, "description": description, "billboard_id": id, "billboard_user": userId};
      var responseNew = await http.post(url, body: data, headers: {'Authorization': kToken});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew["status"]) {
        if (!context.mounted) {
          return;
        }
        Navigator.pop(context);
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
        // getForumValues(text: "",category: selectedValue,filterId: filterId);
      } else {
        if (!context.mounted) {
          return;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  }

  getSearchData({required String searchKey, required BuildContext context}) async {
    var url = Uri.parse(baseurl + versions + tagSearch);
    var newResponse = await http.post(url, headers: {'Authorization': kToken}, body: {'search': searchKey});
    var newResponseData = jsonDecode(newResponse.body);

    mainVariables.searchDataMain = UserSearchDataModel.fromJson(newResponseData).obs;
    if (mainVariables.searchDataMain!.value.status) {
      mainVariables.userSearchDataList.clear();
      mainVariables.userSearchDataList.addAll(mainVariables.searchDataMain!.value.response);
    }
    mainVariables.searchDataMain!.refresh();
    mainVariables.userSearchDataList.refresh();
  }

  getLikeDisLikeUsersList({
    required String billBoardType,
    required String action,
    required String billBoardId,
    required String responseId,
    required String commentId,
    required int skipLimit,
  }) async {
    var url = billBoardType == "news"
        ? Uri.parse(baseurl + versionLocker + newsLikeDislikeCount)
        : billBoardType == "videos"
            ? Uri.parse(baseurl + versionLocker + videoLikeDislikeCount)
            : billBoardType == "forums"
                ? Uri.parse(baseurl + versionForum + likeDislikeUsers)
                : Uri.parse(baseurl + versionBillBoard + likeDislikeList);
    Map<String, dynamic> data = billBoardType == "news"
        ? {
            "type": action,
            "news_id": billBoardId,
            "skip": skipLimit.toString(),
            "search": mainVariables.listDislikeUsersSearchControllerMain.value.text
          }
        : billBoardType == "videos"
            ? {
                "type": action,
                "video_id": billBoardId,
                "skip": skipLimit.toString(),
                "search": mainVariables.listDislikeUsersSearchControllerMain.value.text
              }
            : billBoardType == "forums"
                ? {
                    "type": action,
                    "forum_id": billBoardId,
                    "skip": skipLimit.toString(),
                    "search": mainVariables.listDislikeUsersSearchControllerMain.value.text
                  }
                : {
                    "action": action,
                    "type": billBoardType,
                    "billboard_id": billBoardType != "survey" ? billBoardId : "",
                    "response_id": responseId,
                    "comment_id": commentId,
                    "search": mainVariables.listDislikeUsersSearchControllerMain.value.text,
                    "skip": skipLimit.toString(),
                    "survey_id": billBoardType == "survey" ? billBoardId : "",
                  };
    var newResponse = await http.post(url, headers: {'Authorization': kToken}, body: data);
    var newResponseData = jsonDecode(newResponse.body);
    mainVariables.usersLikeDislikeViewList = (BillBoardLikeDisLikeUsersModel.fromJson(newResponseData)).obs;
    if (skipLimit == 0) {
      mainVariables.likeDisLikeUserSearchDataList.clear();
    }
    if (mainVariables.usersLikeDislikeViewList!.value.response.isNotEmpty) {
      mainVariables.likeDisLikeUserSearchDataList.clear();
      mainVariables.likeDisLikeUserSearchDataList.addAll(mainVariables.usersLikeDislikeViewList!.value.response);
    } else {
      mainVariables.likeDisLikeUserSearchDataList.clear();
    }
  }

  getViewUsersList({
    required String billBoardType,
    required String billBoardId,
    required int skipLimit,
  }) async {
    var url = billBoardType == "news"
        ? baseurl + versionLocker + newsViewCount
        : billBoardType == "videos"
            ? baseurl + versionLocker + videoViewCount
            : billBoardType == "forums"
                ? baseurl + versionForum + viewsCount
                : billBoardType == "survey"
                    ? baseurl + versionSurvey + viewsCount
                    : baseurl + versionBillBoard + views;
    Map<String, dynamic> data = billBoardType == "news"
        ? {
            "news_id": billBoardId,
            "search": mainVariables.listDislikeUsersSearchControllerMain.value.text,
            "skip": skipLimit,
          }
        : billBoardType == "videos"
            ? {
                "video_id": billBoardId,
                "search": mainVariables.listDislikeUsersSearchControllerMain.value.text,
                "skip": skipLimit,
              }
            : billBoardType == "forums"
                ? {
                    "forum_id": billBoardId,
                    "search": mainVariables.listDislikeUsersSearchControllerMain.value.text,
                    "skip": skipLimit,
                  }
                : billBoardType == "survey"
                    ? {
                        "survey_id": billBoardId,
                        "search": mainVariables.listDislikeUsersSearchControllerMain.value.text,
                        "skip": skipLimit,
                      }
                    : {
                        "billboard_id": billBoardId,
                        "search": mainVariables.listDislikeUsersSearchControllerMain.value.text,
                        "skip": skipLimit,
                      };

    var newResponse = await dioMain.post(url, options: Options(headers: {'Authorization': kToken}), data: data);
    var newResponseData = newResponse.data;
    mainVariables.usersLikeDislikeViewList = (BillBoardLikeDisLikeUsersModel.fromJson(newResponseData)).obs;
    if (skipLimit == 0) {
      mainVariables.likeDisLikeUserSearchDataList.clear();
    }
    if (mainVariables.usersLikeDislikeViewList!.value.response.isNotEmpty) {
      mainVariables.likeDisLikeUserSearchDataList.clear();
      mainVariables.likeDisLikeUserSearchDataList.addAll(mainVariables.usersLikeDislikeViewList!.value.response);
    } else {
      mainVariables.likeDisLikeUserSearchDataList.clear();
    }
  }

  Future<OverViewModel> getTickerOverviewData({required String tickerId}) async {
    var url = Uri.parse(baseurl + versionCompare + overViewChart);
    var response = await http.post(url, headers: {'Authorization': kToken}, body: {"ticker_id": tickerId});
    var responseData = json.decode(response.body);

    mainVariables.overViewMain = OverViewModel.fromJson(responseData).obs;
    checkIndexExchange.value = mainVariables.overViewMain!.value.response.exchange == "INDX" ? true : false;
    return mainVariables.overViewMain!.value;
  }

  getAllCategoriesData({
    required String category,
    required String tickerId,
    required List<String> skipLimit,
  }) async {
    mainVariables.allCategoriesIdListMain.clear();
    mainVariables.allCategoriesTitleListMain.clear();
    mainVariables.allCategoriesResponseCountListMain.clear();
    mainVariables.allCategoriesTranslationListMain.clear();
    mainVariables.allCategoriesBookmarksListMain.clear();
    mainVariables.allCategoriesLikesListMain.clear();
    mainVariables.allCategoriesLikesCountListMain.clear();
    mainVariables.allCategoriesDislikesCountListMain.clear();
    mainVariables.allCategoriesDislikesListMain.clear();
    mainVariables.allCategoriesViewsCountListMain.clear();
    mainVariables.allCategoriesUserNameListMain.clear();
    mainVariables.allCategoriesProfileTypeListMain.clear();
    mainVariables.allCategoriesTickerIdListMain.clear();
    for (int i = 0; i < 4; i++) {
      mainVariables.allCategoriesIdListMain.add([]);
      mainVariables.allCategoriesTitleListMain.add([]);
      mainVariables.allCategoriesLikesListMain.add([]);
      mainVariables.allCategoriesDislikesListMain.add([]);
      mainVariables.allCategoriesBookmarksListMain.add([]);
      mainVariables.allCategoriesTranslationListMain.add([]);
      mainVariables.allCategoriesLikesCountListMain.add([]);
      mainVariables.allCategoriesDislikesCountListMain.add([]);
      mainVariables.allCategoriesResponseCountListMain.add([]);
      mainVariables.allCategoriesViewsCountListMain.add([]);
      mainVariables.allCategoriesUserNameListMain.add([]);
      mainVariables.allCategoriesProfileTypeListMain.add([]);
      mainVariables.allCategoriesTickerIdListMain.add([]);
    }
    await getNewsData(category: category, tickerId: tickerId, skipLimit: skipLimit[0]);
    await getVideosData(category: category, tickerId: tickerId, skipLimit: skipLimit[1]);
    await getSurveyData(category: category, tickerId: tickerId, skipLimit: skipLimit[2]);
    await getForumsData(category: category, tickerId: tickerId, skipLimit: skipLimit[3]);
  }

  getNewsData({
    required String category,
    required String tickerId,
    required String skipLimit,
  }) async {
    var url = Uri.parse(baseurl + versionLocker + getNewsZone);
    Map<String, dynamic> data = {
      'category': category,
      'search': mainVariables.popularSearchControllerMain.value.text,
      'skip': skipLimit,
      'ticker_id': tickerId
    };
    var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
    mainVariables.newsDataMain = NewsMainPageModel.fromJson(jsonDecode(response.body)).obs;
    for (int i = 0; i < mainVariables.newsDataMain!.value.response.length; i++) {
      mainVariables.allCategoriesIdListMain[0].add(mainVariables.newsDataMain!.value.response[i].id);
      mainVariables.allCategoriesTitleListMain[0].add(mainVariables.newsDataMain!.value.response[i].title);
      mainVariables.allCategoriesLikesListMain[0].add(mainVariables.newsDataMain!.value.response[i].likes);
      mainVariables.allCategoriesDislikesListMain[0].add(mainVariables.newsDataMain!.value.response[i].dislikes);
      mainVariables.allCategoriesBookmarksListMain[0].add(mainVariables.newsDataMain!.value.response[i].bookmark);
      mainVariables.allCategoriesTranslationListMain[0].add(mainVariables.newsDataMain!.value.response[i].translation);
      mainVariables.allCategoriesLikesCountListMain[0].add(mainVariables.newsDataMain!.value.response[i].likesCount);
      mainVariables.allCategoriesDislikesCountListMain[0].add(mainVariables.newsDataMain!.value.response[i].disLikesCount);
      mainVariables.allCategoriesResponseCountListMain[0].add(0);
      mainVariables.allCategoriesViewsCountListMain[0].add(mainVariables.newsDataMain!.value.response[i].viewsCount);
      mainVariables.allCategoriesUserNameListMain[0].add(mainVariables.newsDataMain!.value.response[i].sourceName);
      mainVariables.allCategoriesProfileTypeListMain[0].add("intermediate");
      mainVariables.allCategoriesTickerIdListMain[0].add(mainVariables.newsDataMain!.value.response[i].tickerId);
    }
  }

  getVideosData({
    required String category,
    required String tickerId,
    required String skipLimit,
  }) async {
    var url = Uri.parse(baseurl + versionLocker + getVideosZone);
    Map<String, dynamic> data = {
      'category': category,
      'search': mainVariables.popularSearchControllerMain.value.text,
      'skip': skipLimit,
      'ticker_id': tickerId
    };
    var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
    mainVariables.videosDataMain = VideosMainPageModel.fromJson(jsonDecode(response.body)).obs;
    for (int i = 0; i < mainVariables.videosDataMain!.value.response.length; i++) {
      mainVariables.allCategoriesIdListMain[1].add(mainVariables.videosDataMain!.value.response[i].id);
      mainVariables.allCategoriesTitleListMain[1].add(mainVariables.videosDataMain!.value.response[i].title);
      mainVariables.allCategoriesLikesListMain[1].add(mainVariables.videosDataMain!.value.response[i].likes);
      mainVariables.allCategoriesDislikesListMain[1].add(mainVariables.videosDataMain!.value.response[i].dislikes);
      mainVariables.allCategoriesBookmarksListMain[1].add(mainVariables.videosDataMain!.value.response[i].bookmark);
      mainVariables.allCategoriesTranslationListMain[1].add(mainVariables.videosDataMain!.value.response[i].translation);
      mainVariables.allCategoriesLikesCountListMain[1].add(mainVariables.videosDataMain!.value.response[i].likesCount);
      mainVariables.allCategoriesDislikesCountListMain[1].add(mainVariables.videosDataMain!.value.response[i].disLikesCount);
      mainVariables.allCategoriesResponseCountListMain[1].add(0);
      mainVariables.allCategoriesViewsCountListMain[1].add(mainVariables.videosDataMain!.value.response[i].viewsCount);
      mainVariables.allCategoriesUserNameListMain[1].add(mainVariables.videosDataMain!.value.response[i].sourceName);
      mainVariables.allCategoriesProfileTypeListMain[1].add("intermediate");
      mainVariables.allCategoriesTickerIdListMain[1].add(mainVariables.videosDataMain!.value.response[i].tickerId);
    }
  }

  getSurveyData({
    required String category,
    required String tickerId,
    required String skipLimit,
  }) async {
    var url = Uri.parse(baseurl + versionSurvey + surveyList);
    Map<String, dynamic> data = {
      'category': category,
      'search': mainVariables.popularSearchControllerMain.value.text,
      'skip': skipLimit,
      'ticker_id': tickerId,
    };
    var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
    mainVariables.surveyDataMain = SurveyMainPageModel.fromJson(jsonDecode(response.body)).obs;
    for (int i = 0; i < mainVariables.surveyDataMain!.value.response.length; i++) {
      mainVariables.allCategoriesIdListMain[2].add(mainVariables.surveyDataMain!.value.response[i].id);
      mainVariables.allCategoriesTitleListMain[2].add(mainVariables.surveyDataMain!.value.response[i].title);
      mainVariables.allCategoriesLikesListMain[2].add(mainVariables.surveyDataMain!.value.response[i].likes);
      mainVariables.allCategoriesDislikesListMain[2].add(mainVariables.surveyDataMain!.value.response[i].dislikes);
      mainVariables.allCategoriesBookmarksListMain[2].add(mainVariables.surveyDataMain!.value.response[i].bookmark);
      mainVariables.allCategoriesTranslationListMain[2].add(mainVariables.surveyDataMain!.value.response[i].translation);
      mainVariables.allCategoriesLikesCountListMain[2].add(mainVariables.surveyDataMain!.value.response[i].likesCount);
      mainVariables.allCategoriesDislikesCountListMain[2].add(mainVariables.surveyDataMain!.value.response[i].disLikesCount);
      mainVariables.allCategoriesResponseCountListMain[2].add(mainVariables.surveyDataMain!.value.response[i].answersCount);
      mainVariables.allCategoriesViewsCountListMain[2].add(mainVariables.surveyDataMain!.value.response[i].viewsCount);
      mainVariables.allCategoriesUserNameListMain[2].add(mainVariables.surveyDataMain!.value.response[i].user.username);
      mainVariables.allCategoriesProfileTypeListMain[2].add(mainVariables.surveyDataMain!.value.response[i].user.profileType);
      mainVariables.allCategoriesTickerIdListMain[2].add(mainVariables.surveyDataMain!.value.response[i].user.tickerId);
    }
  }

  getForumsData({
    required String category,
    required String tickerId,
    required String skipLimit,
  }) async {
    var url = Uri.parse(baseurl + versionForum + getForumZone);
    Map<String, dynamic> data = {
      'category': category,
      'search': mainVariables.popularSearchControllerMain.value.text,
      'skip': skipLimit,
      'type': "",
      'ticker_id': tickerId
    };
    var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
    mainVariables.forumDataMain = ForumsMainPageModel.fromJson(jsonDecode(response.body)).obs;
    for (int i = 0; i < mainVariables.forumDataMain!.value.response.length; i++) {
      mainVariables.allCategoriesIdListMain[3].add(mainVariables.forumDataMain!.value.response[i].id);
      mainVariables.allCategoriesTitleListMain[3].add(mainVariables.forumDataMain!.value.response[i].title);
      mainVariables.allCategoriesLikesListMain[3].add(mainVariables.forumDataMain!.value.response[i].likes);
      mainVariables.allCategoriesDislikesListMain[3].add(mainVariables.forumDataMain!.value.response[i].dislikes);
      mainVariables.allCategoriesBookmarksListMain[3].add(mainVariables.forumDataMain!.value.response[i].bookmark);
      mainVariables.allCategoriesTranslationListMain[3].add(mainVariables.forumDataMain!.value.response[i].translation);
      mainVariables.allCategoriesLikesCountListMain[3].add(mainVariables.forumDataMain!.value.response[i].likesCount);
      mainVariables.allCategoriesDislikesCountListMain[3].add(mainVariables.forumDataMain!.value.response[i].disLikesCount);
      mainVariables.allCategoriesResponseCountListMain[3].add(mainVariables.forumDataMain!.value.response[i].responseCount);
      mainVariables.allCategoriesViewsCountListMain[3].add(mainVariables.forumDataMain!.value.response[i].viewsCount);
      mainVariables.allCategoriesUserNameListMain[3].add(mainVariables.forumDataMain!.value.response[i].user.username);
      mainVariables.allCategoriesProfileTypeListMain[3].add(mainVariables.forumDataMain!.value.response[i].user.profileType);
      mainVariables.allCategoriesTickerIdListMain[3].add(mainVariables.forumDataMain!.value.response[i].user.tickerId);
    }
  }

  getBelieversListApiFunc({
    required String id,
    required int index,
    required String skip,
  }) async {
    var url = index == 0 ? Uri.parse(baseurl + versions + believersList) : Uri.parse(baseurl + versions + profileVisitList);
    var response = await http.post(url,
        headers: {'Authorization': kToken},
        body: {"userId": id, "skip": skip, "limit": "10", "search": mainVariables.believersListSearchControllerMain.value.text});
    var responseData = json.decode(response.body);
    if (skip == "0") {
      mainVariables.believedUsersList.clear();
    }
    BelieversListModel usersBelievedList = BelieversListModel.fromJson(responseData);
    mainVariables.believedUsersList.addAll(usersBelievedList.response);
  }

  getProfileVisitNotificationFunc({required String id}) async {
    var url = Uri.parse(baseurl + versions + profileVisit);
    await http.post(url, headers: {'Authorization': kToken}, body: {"userId": id});
  }

  getBelievedListApiFunc({
    required String id,
    required String type,
    required String skip,
  }) async {
    var url = type != "" ? Uri.parse(baseurl + versionBillBoard + repostUsers) : Uri.parse(baseurl + versions + believedList);
    Map<String, dynamic> data = type != ""
        ? {
            "type": type == 'byte' || type == 'blog' ? "billboard" : type,
            "post_id": id,
            "search": mainVariables.believedListSearchControllerMain.value.text
          }
        : {"search": mainVariables.believedListSearchControllerMain.value.text, "skip": skip, "limit": "10"};
    var response = await http.post(url, headers: {'Authorization': kToken}, body: data);
    var responseData = json.decode(response.body);
    if (skip == "0") {
      mainVariables.believedUsersList.clear();
    }
    BelieversListModel usersBelievedList = BelieversListModel.fromJson(responseData);
    mainVariables.believedUsersList.addAll(usersBelievedList.response);
  }

  getNotBelievedListApiFunc({
    required String id,
    required String skip,
  }) async {
    Uri url = Uri.parse(baseurl + versions + nonBelievedList);
    Map<String, dynamic> data = {"search": mainVariables.believedListSearchControllerMain.value.text, "skip": skip, "limit": "10"};
    var response = await http.post(url, headers: {'Authorization': kToken}, body: data);

    var responseData = json.decode(response.body);
    if (skip == "0") {
      mainVariables.believedUsersList.clear();
    }
    BelieversListModel usersBelievedList = BelieversListModel.fromJson(responseData);
    mainVariables.believedUsersList.addAll(usersBelievedList.response);
  }

  Future<bool> bookMarkAddRemove({required String id, required String type, required BuildContext context}) async {
    Uri uri = Uri.parse(baseurl + versionBookMark + addRemove);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "post_id": id,
      "type": type,
    });

    var responseData = jsonDecode(response.body);
    if (responseData["message"] == "Bookmark removed") {
      logEventFunc(name: "Bookmark_Removed", type: type);
    } else {
      logEventFunc(name: "Bookmark_Added", type: type);
    }
    if (!context.mounted) {
      return false;
    }
    Flushbar(
      message: responseData["message"],
      duration: const Duration(seconds: 2),
    ).show(context);
    return responseData["status"];
  }
}
