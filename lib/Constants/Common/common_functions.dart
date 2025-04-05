import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tradewatchfinal/Constants/API/API.dart';
import 'package:tradewatchfinal/Constants/Common/general_data_model.dart';
import 'package:tradewatchfinal/Edited_Packages/chewieLibrary/src/chewie_player.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:video_player/video_player.dart';

class CommonFunctions {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String deviceId = "";
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String fireBasToken = "";
  String fbToken = "";

  getGeneralData() async {
    String url = baseurl + versionHome + general;
    var response = await dioMain.get(url);
    GeneralDataModel generalData = GeneralDataModel.fromJson(response.data);
    mainVariables.aboutMeListMain = generalData.response.general.about;
    mainVariables.avatarListMain = generalData.response.avatars;
  }

  getNotifyCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionHome + liveCheck;
    var response = await dioMain.post(url, options: Options(headers: {'Authorization': mainUserToken}), data: {
      "category": "stocks",
      "type": "NSE",
    });
    var responseData = response.data;
    if (responseData["status"]) {
      streamController.add(responseData["response"]);
      badgeNotifyCount.value = responseData["notification_count"];
      badgeMessageCount.value = responseData["message_count"];
    }
  }

  userInsightFunc({required String typeData, required String aliasData}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString("newUserToken") ?? "";
    var url = Uri.parse(baseurl + versions + userInsightUpdate);
    await http.post(url,
        body: {"alias": aliasData, "type": typeData}, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Authorization': mainUserToken});
  }

  Future<void> fireBaseCloudMessagingListeners() async {
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor!;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      deviceId = androidDeviceInfo.id;
    }
    firebaseMessaging.getToken().then((token) async {
      fireBasToken = token!;
      fireBasTokenMain = token;
      saveValue(token: fireBasToken);
      checkDeviceFunc();
    });
  }

  checkDeviceFunc() async {
    var url = Uri.parse(baseurl + versions + userDevice);
    await http.post(
      url,
      body: {
        "device_id": deviceId,
        "device_type": Platform.isIOS ? "ios" : 'android',
        "device_token": fireBasToken,
        "app_version": appVersion,
      },
    );
  }

  saveValue({required String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FBToken1', token);
    prefs.setString('DeviceIDD', deviceId);
    fbToken = prefs.getString('FBToken1')!;
  }

  ImageProvider badgeImage({required String type, required String activity}) {
    ImageProvider image;
    if (type == "billboard-response") {
      switch (activity) {
        case "liked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/like.png");
            break;
          }
        case "disliked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/dislike.png");
            break;
          }
        case "viewed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/view.png");
            break;
          }
        case "dislike removed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/dislike_remove.png");
            break;
          }
        case "like removed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/like_remove.png");
            break;
          }
        case "update":
          {
            image = const AssetImage("lib/Constants/Assets/activity/profile_update.png");
            break;
          }
        case "answered":
          {
            image = const AssetImage("lib/Constants/Assets/activity/answer.png");
            break;
          }
        case "Delete":
          {
            image = const AssetImage("lib/Constants/Assets/activity/delete.png");
            break;
          }
        case "responded":
          {
            image = const AssetImage("lib/Constants/Assets/activity/respond.png");
            break;
          }
        case "reported":
          {
            image = const AssetImage("lib/Constants/Assets/activity/report.png");
            break;
          }
        case "response removed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/response.png");
            break;
          }
        case "blocked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/block.png");
            break;
          }
        case "unblocked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/unblock.png");
            break;
          }
        case "shared":
          {
            image = const AssetImage("lib/Constants/Assets/activity/share.png");
            break;
          }
        case "Create":
          {
            image = const AssetImage("lib/Constants/Assets/activity/response.png");
            break;
          }
        default:
          {
            image = const AssetImage("lib/Constants/Assets/activity/response.png");
            break;
          }
      }
    } else if (type == "billboard") {
      switch (activity) {
        case "liked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/like.png");
            break;
          }
        case "disliked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/dislike.png");
            break;
          }
        case "viewed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/view.png");
            break;
          }
        case "dislike removed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/dislike_remove.png");
            break;
          }
        case "like removed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/like_remove.png");
            break;
          }
        case "update":
          {
            image = const AssetImage("lib/Constants/Assets/activity/profile_update.png");
            break;
          }
        case "answered":
          {
            image = const AssetImage("lib/Constants/Assets/activity/answer.png");
            break;
          }
        case "Delete":
          {
            image = const AssetImage("lib/Constants/Assets/activity/delete.png");
            break;
          }
        case "responded":
          {
            image = const AssetImage("lib/Constants/Assets/activity/respond.png");
            break;
          }
        case "reported":
          {
            image = const AssetImage("lib/Constants/Assets/activity/report.png");
            break;
          }
        case "response removed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/response.png");
            break;
          }
        case "blocked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/block.png");
            break;
          }
        case "unblocked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/unblock.png");
            break;
          }
        case "shared":
          {
            image = const AssetImage("lib/Constants/Assets/activity/share.png");
            break;
          }
        case "Create":
          {
            image = const AssetImage("lib/Constants/Assets/activity/response.png");
            break;
          }
        default:
          {
            image = const AssetImage("lib/Constants/Assets/activity/response.png");
            break;
          }
      }
    } else {
      switch (activity) {
        case "liked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/like.png");
            break;
          }
        case "disliked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/dislike.png");
            break;
          }
        case "shared":
          {
            image = const AssetImage("lib/Constants/Assets/activity/share.png");
            break;
          }
        case "viewed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/view.png");
            break;
          }
        case "dislike removed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/dislike_remove.png");
            break;
          }
        case "like removed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/like_remove.png");
            break;
          }
        case "Create":
          {
            image = const AssetImage("lib/Constants/Assets/activity/watchlist_create.png");
            break;
          }
        case "update":
          {
            image = const AssetImage("lib/Constants/Assets/activity/profile_update.png");
            break;
          }
        case "answered":
          {
            image = const AssetImage("lib/Constants/Assets/activity/answer.png");
            break;
          }
        case "Delete":
          {
            image = const AssetImage("lib/Constants/Assets/activity/delete.png");
            break;
          }
        case "responded":
          {
            image = const AssetImage("lib/Constants/Assets/activity/respond.png");
            break;
          }
        case "change password":
          {
            image = const AssetImage("lib/Constants/Assets/activity/password_Change.png");
            break;
          }
        case "unblocked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/unblock.png");
            break;
          }
        case "blocked":
          {
            image = const AssetImage("lib/Constants/Assets/activity/block.png");
            break;
          }
        case "reported":
          {
            image = const AssetImage("lib/Constants/Assets/activity/report.png");
            break;
          }
        case "response removed":
          {
            image = const AssetImage("lib/Constants/Assets/activity/response.png");
            break;
          }
        default:
          {
            image = const AssetImage("lib/Constants/Assets/activity/liked.png");
            break;
          }
      }
    }
    return image;
  }

  Future<Response> sendForm(String url, Map<String, dynamic> data, Map<String, File> files) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mainUserToken = prefs.getString('newUserToken') ?? "";
    Map<String, MultipartFile> fileMap = {};
    for (MapEntry fileEntry in files.entries) {
      File file = fileEntry.value;
      String fileName = file.path;
      //fileMap[fileEntry.key] = MultipartFile.fromFile(file.openRead(), await file.length(), filename: fileName);
      fileMap[fileEntry.key] = await MultipartFile.fromFile(file.path, filename: fileName);
    }
    data.addAll(fileMap);
    var formData = FormData.fromMap(data);
    return await dioMain.post(
      url,
      data: formData,
      options: Options(
        method: 'POST',
        headers: {HttpHeaders.authorizationHeader: mainUserToken, 'content-Type': 'multipart/form-data'},
      ),
    );
  }

  Future<Response> sendMultipleFileForm({required List<Map<String, File>> selectedFiles}) async {
    String url = baseurl + versionChat + fileAdd;
    Map<String, dynamic> data = {};
    Map<String, MultipartFile> fileMap = {};
    for (int i = 0; i < selectedFiles.length; i++) {
      for (MapEntry fileEntry in selectedFiles[i].entries) {
        File file = fileEntry.value;
        String fileName = file.path;
        //fileMap[fileEntry.key] = MultipartFile(file.openRead(), await file.length(), filename: fileName);
        fileMap[fileEntry.key] = await MultipartFile.fromFile(file.path, filename: fileName);
      }
      data.addAll(fileMap);
    }
    var formData = FormData.fromMap(data);
    return await dioMain.post(
      url,
      data: formData,
      options: Options(
        method: 'POST',
        headers: {HttpHeaders.authorizationHeader: kToken, 'content-Type': 'multipart/form-data'},
      ),
    );
  }

  Future<VideoPlayerController> getPreviousVideoPlayer({required String url}) async {
    VideoPlayerController vpController = VideoPlayerController.networkUrl(
      Uri.parse(url),
    );
    vpController.initialize();
    return vpController;
  }

  Future<ChewieController> getVideoPlayer({
    required String url,
  }) async {
    ChewieController cvController = ChewieController(
        videoPlayerController: await getPreviousVideoPlayer(url: url), aspectRatio: 1.777, allowedScreenSleep: false, showOptions: false);
    return cvController;
  }

  onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      mainVariables.dateRangeMain.value = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
          // ignore: lines_longer_than_80_chars
          ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
    }
  }

  onInitialValue(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      mainVariables.dateRangeMain.value = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
          // ignore: lines_longer_than_80_chars
          ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
    }
  }

  reportUser({
    required BuildContext context,
    required String action,
    required String why,
    required String description,
    required String userId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    if (why == "Other") {
      if (description == "") {
        if (!context.mounted) {
          return;
        }
        Flushbar(
          message: "Please describe the reason in the description ",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        var url = Uri.parse(baseurl + versions + report);
        var responseNew = await http.post(url,
            body: {"action": action, "why": why, "description": description, "reported_user": userId}, headers: {'Authorization': mainUserToken});
        var responseDataNew = json.decode(responseNew.body);
        if (responseDataNew["status"]) {
          if (!context.mounted) {
            return;
          }
          Navigator.pop(context);
          /*Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return MainBottomNavigationPage(
                  tType: true,
                  text: "",
                  caseNo1: 0,
                  newIndex: 0,
                  isHomeFirstTym:false,
                  excIndex: 0,
                  countryIndex: 0,
                );
              }));*/
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
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
      var url = Uri.parse(baseurl + versions + report);
      var responseNew = await http.post(url,
          body: {"action": action, "why": why, "description": description, "reported_user": userId}, headers: {'Authorization': mainUserToken});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew["status"]) {
        if (!context.mounted) {
          return;
        }
        Navigator.pop(context);
        /*Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
              return MainBottomNavigationPage(
                tType: true,
                text: "",
                caseNo1: 0,
                newIndex: 0,
                excIndex: 0,
                isHomeFirstTym:false,
                countryIndex: 0,
              );
            }));*/
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (!context.mounted) {
          return false;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  }

  createInterstitialAd({required StateSetter modelSetState}) {
    InterstitialAd? interstitialAdMain;
    InterstitialAd.load(
        adUnitId: adVariables.interstitialAdUnitId,
        request: adVariables.request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interstitialAdMain = ad;
            adVariables.numInterstitialLoadAttempts.value = 0;
            interstitialAdMain!.setImmersiveMode(true);
            modelSetState(() {});
            Future.delayed(const Duration(seconds: 2), () {
              functionsMain.showInterstitialAd(modelSetState: modelSetState, interstitialAdMain: interstitialAdMain!);
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            adVariables.numInterstitialLoadAttempts.value += 1;
            interstitialAdMain = null;
            if (adVariables.numInterstitialLoadAttempts.value < adVariables.maxFailedLoadAttemptsMain.value) {
              functionsMain.createInterstitialAd(modelSetState: modelSetState);
              Future.delayed(const Duration(seconds: 2), () {
                if (interstitialAdMain != null) {
                  functionsMain.showInterstitialAd(modelSetState: modelSetState, interstitialAdMain: interstitialAdMain!);
                }
              });
            }
          },
        ));
  }

  showInterstitialAd({
    required StateSetter modelSetState,
    required InterstitialAd? interstitialAdMain,
  }) {
    if (interstitialAdMain == null) {
      return;
    }
    interstitialAdMain.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd(modelSetState: modelSetState);
      },
    );
    interstitialAdMain.show();
    adVariables.adShown.value = false;
    interstitialAdMain = null;
  }
}
