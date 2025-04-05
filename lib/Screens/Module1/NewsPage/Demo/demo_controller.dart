import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:share_plus/share_plus.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'api_response_model.dart';
import 'initial_data_model.dart';

class DemoController extends GetxController {
  dynamic argumentData = Get.arguments;
  late WebViewController wvController;
  bool fromLink = false;

  /*Map<String, dynamic> initialData = {
    "id": "",
    "type": "news",
    "title": "",
    "link": "",
    "intermediary_profile_id": "",
    "news_ticker_id": "",
    "news_ticker_category_id": "",
    "news_ticker_exchange_id": "",
    "isLiked": false,
    "isDisliked": false,
    "bookmark": false,
    "loading": false,
    "app_bar_loading": false
  };*/
  DemoInitialData initialModelData = DemoInitialData.fromJson({});

  @override
  void onInit() {
    getAllDataMain(name: 'News_Open_Web_Page');
    initialModelData.id = argumentData['id'];
    initialModelData.type = argumentData['type'];
    initialModelData.link = argumentData['url'];
    fromLink = argumentData['fromLink'] ?? false;
    getData();
    super.onInit();
  }

  getData() async {
    if (initialModelData.id == "") {
      initialModelData.link = argumentData['url'];
    } else if (kToken != "") {
      await getIdData(type: initialModelData.type, id: initialModelData.id);
    } else {
      await getIdData(type: initialModelData.type, id: initialModelData.id);
    }
    wvController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(initialModelData.link));
    initialModelData.appBarLoading = true;
    initialModelData.loading = true;
    this.update();
  }

  getIdData({required String id, required String type}) async {
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    var response = await http.post(url, headers: {'Authorization': kToken}, body: {"id": id, "type": type});
    var responseData = json.decode(response.body);
    DemoResponseModel demoResponse = DemoResponseModel.fromJson(responseData);
    if (responseData["status"]) {
      initialModelData.title = demoResponse.response.title;
      initialModelData.link = demoResponse.response.newsUrl;
      initialModelData.intermediaryProfileId = demoResponse.response.userId; // responseData["response"]["user_id"] ?? "";
      initialModelData.newsTickerId = demoResponse.response.tickerIds.isEmpty
          ? ""
          : demoResponse.response.tickerIds[0]; // responseData["response"]["tickerIds"].isEmpty ? "" : responseData["response"]["tickerIds"][0];
      initialModelData.newsTickerCategoryId = demoResponse.response.categoryId; //responseData["response"]["category_id"] ?? "";
      initialModelData.newsTickerExchangeId = demoResponse.response.exchangeId; //responseData["response"]["exchange_id"] ?? "";
      initialModelData.bookmark = demoResponse.response.bookmark; //responseData["response"]["bookmark"] ?? false;
      initialModelData.isLiked = demoResponse.response.likes.contains(userIdMain); //responseData["response"]['likes'].contains(userIdMain);
      initialModelData.isDisliked = demoResponse.response.dislikes.contains(userIdMain); //responseData["response"]['dislikes'].contains(userIdMain);
    }
  }

  likePressingFunction({required BuildContext context}) async {
    if (mainSkipValue) {
      commonFlushBar(context: context, initFunction: onInit);
    } else {
      bool response1 = await likeFunction(id: initialModelData.id, type: "news");
      if (response1) {
        logEventFunc(name: "Likes", type: "News");
        initialModelData.isLiked = !initialModelData.isLiked;
        initialModelData.isDisliked = false;
      } else {}
      this.update();
    }
  }

  Future<bool> likeFunction({required String id, required String type}) async {
    var uri = Uri.parse(baseurl + versionLocker + likes);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "id": id,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
    return responseData['status'];
  }

  dislikePressingFunction({required BuildContext context}) async {
    if (mainSkipValue) {
      commonFlushBar(context: context, initFunction: onInit);
    } else {
      bool response1 = await disLikeFunction(id: initialModelData.id, type: "news");
      if (response1) {
        logEventFunc(name: "Dislikes", type: "News");
        initialModelData.isDisliked = !initialModelData.isDisliked;
        initialModelData.isLiked = false;
      } else {}
      this.update();
    }
  }

  Future<bool> disLikeFunction({required String id, required String type}) async {
    var uri = Uri.parse(baseurl + versionLocker + dislikes);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "id": id,
      "type": type
    });
    var responseData = jsonDecode(response.body);
    return responseData['status'];
  }

  sharePressingFunction() async {
    logEventFunc(name: 'Share', type: 'News');
    Uri newLink = await getLinK(
      id: initialModelData.id,
      type: "news",
    );
    ShareResult result = await Share.share(
      "Look what I was able to find on Tradewatch: ${initialModelData.title} ${newLink.toString()}",
    );
    if (result.status == ShareResultStatus.success) {
      await shareFunction(id: initialModelData.id, type: "news");
    }
  }

  Future<bool> shareFunction({required String id, required String type}) async {
    var uri = Uri.parse(baseurl + versionLocker + share);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "id": id,
      "type": type
    });
    var responseData = jsonDecode(response.body);
    return responseData['status'];
  }

  Future<Uri> getLinK({required String id, required String type}) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/DemoPage/$id/$type'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  bookmarkPressingFunction({required BuildContext context}) async {
    if (mainSkipValue) {
      commonFlushBar(context: context, initFunction: onInit);
    } else {
      bool response = await bookMarkAddRemove(id: initialModelData.id, type: initialModelData.type, context: context);
      if (response) {
        initialModelData.bookmark = !initialModelData.bookmark;
      }
      this.update();
    }
  }

  Future<bool> bookMarkAddRemove({
    required String id,
    required String type,
    required BuildContext context,
  }) async {
    Uri uri = Uri.parse(baseurl + versionBookMark + addRemove);
    var response = await http.post(uri, headers: {
      "authorization": kToken,
    }, body: {
      "post_id": id,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
    if (responseData["message"] == "Bookmark removed") {
      logEventFunc(name: "Bookmark removed", type: type);
    } else {
      logEventFunc(name: "Bookmark added", type: type);
    }
    return responseData["status"];
  }
}
