import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/Api.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/related_videos_model.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/related_forums_model.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/related_survey_model.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/SingleOne/book_mark_single_widget_bloc.dart';
import 'Demo/demo_view.dart';
import 'news_single_model.dart';
import 'related_news_model.dart';

List<String> listIds = [];
List<String> listRelatedIds = [];
RxString currentNewsId = "".obs;
RxInt idIndex = 0.obs;

class NewsDescriptionPage extends StatefulWidget {
  final String id;
  final String comeFrom;
  final List<String> idList;
  final List<String> descriptionList;
  final List<String> snippetList;

  const NewsDescriptionPage(
      {Key? key, required this.id, required this.comeFrom, required this.idList, required this.descriptionList, required this.snippetList})
      : super(key: key);

  @override
  State<NewsDescriptionPage> createState() => _NewsDescriptionPageState();
}

class _NewsDescriptionPageState extends State<NewsDescriptionPage> {
  final TextEditingController _controller = TextEditingController();
  bool loading = false;
  bool loadingRelated = false;
  String mainUserId = "";
  String mainUserToken = "";
  late NewsSingleModel _newsResponse;
  late RelatedNewsModel _newsRelatedResponse;
  late RelatedVideosModel _videosRelatedResponse;
  late RelatedForumsModel _forumsRelatedResponse;
  late RelatedSurveyModel _surveysRelatedResponse;
  String exchangeValue = "";
  List<String> exchangeValueList = [];
  bool isLiked = false;
  bool isDisliked = false;
  int likeCount = 0;
  int disLikeCount = 0;
  late Uri newLink;
  List<String> actionList = ["Report", "Block"];
  List<String> whyList = ["Scam", "Abusive Content", "Spam", "Other"];
  String actionValue = "Report";
  String whyValue = "Scam";
  String swipeDirection = "";
  bool forLottie = false;
  bool emptyBool = false;
  bool engageStatus = true;
  List<String> idListNew = [];

  @override
  void initState() {
    getAwaitData();
    super.initState();
  }

  getAwaitData() async {
    await listCreation();
    await getAllData();
  }

  getAllData() async {
    setState(() {
      loading = false;
      loadingRelated = false;
    });
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    context.read<BookMarkSingleWidgetBloc>().add(const BookLoadingEvent());
    _newsResponse = await getData();
    isLiked = _newsResponse.response.likes;
    isDisliked = _newsResponse.response.dislikes;
    likeCount = _newsResponse.response.likesCount;
    disLikeCount = _newsResponse.response.disLikesCount;
    if (finalisedCategory.toLowerCase() == 'stocks') {
      if (_newsResponse.response.exchange == 'NSE' || _newsResponse.response.exchange == "BSE" || _newsResponse.response.exchange == "INDX") {
        exchangeValue = _newsResponse.response.exchange.toLowerCase();
      } else {
        exchangeValue = 'usastocks';
      }
    } else if (finalisedCategory.toLowerCase() == 'crypto') {
      exchangeValue = _newsResponse.response.industry.isEmpty ? "coin" : _newsResponse.response.industry[0].name.toLowerCase();
    } else if (finalisedCategory.toLowerCase() == 'commodity') {
      exchangeValue = _newsResponse.response.country.toLowerCase();
    } else {
      exchangeValue = "inrusd";
    }
    forNewsLottieCount++;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('forNewsCount', forNewsLottieCount);
    setState(() {
      loading = true;
      forLottie = forNewsLottieCount <= 5 ? true : false;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        forLottie = false;
      });
    });
    await getRelatedData();
  }

  listCreation() async {
    idListNew.addAll(widget.idList);
    listIds.clear();
    if (idListNew.isEmpty) {
      listIds.add(widget.id);
    } else {
      for (int i = 0; i < idListNew.length; i++) {
        if (widget.descriptionList[i] == "" && widget.snippetList[i] == "") {
        } else {
          listIds.add(idListNew[i]);
        }
      }
    }
    idIndex = listIds.indexOf(widget.id).obs;
    relatedTopicText = "News".obs;
    relatedOnPage = 'news'.obs;
    currentNewsId = listIds[idIndex.value].obs;
    listRelatedIds.clear();
  }

  Future<NewsSingleModel> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + getSingleNews);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'news_id': currentNewsId.value});
    var responseData = json.decode(response.body);
    return NewsSingleModel.fromJson(responseData);
  }

  getRelatedData() async {
    setState(() {
      loadingRelated = false;
    });
    exchangeValueList.clear();
    listRelatedIds.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionLocker + relatedAll;
    var response = await dioMain.post(url,
        options: Options(
          headers: {'Authorization': mainUserToken},
        ),
        data: {
          'type': relatedTopicText.value.toLowerCase(),
          'tickers': _newsResponse.response.tickers,
          'category': finalisedCategory.toLowerCase(),
          'exchange': _newsResponse.response.exchange,
          'ticker_id': _newsResponse.response.tickerId,
          'post_id': _newsResponse.response.id
        });
    var responseData = response.data;
    if (relatedTopicText.value.toLowerCase() == 'news') {
      _newsRelatedResponse = RelatedNewsModel.fromJson(responseData);
      if (_newsRelatedResponse.response.isEmpty) {
        setState(() {
          emptyBool = true;
          loadingRelated = true;
        });
      } else {
        emptyBool = false;
        for (int i = 0; i < _newsRelatedResponse.response.length; i++) {
          listRelatedIds.add(_newsRelatedResponse.response[i].id);
          if (finalisedCategory.toLowerCase() == 'stocks') {
            if (_newsRelatedResponse.response[i].exchange == 'NSE' ||
                _newsRelatedResponse.response[i].exchange == "BSE" ||
                _newsRelatedResponse.response[i].exchange == "INDX") {
              exchangeValueList.add(_newsRelatedResponse.response[i].exchange.toLowerCase());
            } else {
              exchangeValueList.add('usastocks');
            }
          } else if (finalisedCategory.toLowerCase() == 'crypto') {
            exchangeValueList
                .add(_newsRelatedResponse.response[i].industry.isEmpty ? "coin" : _newsRelatedResponse.response[i].industry[0].name.toLowerCase());
          } else if (finalisedCategory.toLowerCase() == 'commodity') {
            exchangeValueList.add(_newsRelatedResponse.response[i].country.toLowerCase());
          } else {
            exchangeValueList.add("inrusd");
          }
        }
        setState(() {
          loadingRelated = true;
        });
      }
    } else if (relatedTopicText.value.toLowerCase() == 'videos') {
      _videosRelatedResponse = RelatedVideosModel.fromJson(responseData);
      if (_videosRelatedResponse.response.isEmpty) {
        setState(() {
          emptyBool = true;
          loadingRelated = true;
        });
      } else {
        emptyBool = false;
        for (int i = 0; i < _videosRelatedResponse.response.length; i++) {
          listRelatedIds.add(_videosRelatedResponse.response[i].id);
          if (finalisedCategory.toLowerCase() == 'stocks') {
            if (_videosRelatedResponse.response[i].exchange == 'NSE' ||
                _videosRelatedResponse.response[i].exchange == "BSE" ||
                _videosRelatedResponse.response[i].exchange == "INDX") {
              exchangeValueList.add(_videosRelatedResponse.response[i].exchange.toLowerCase());
            } else {
              exchangeValueList.add('usastocks');
            }
          } else if (finalisedCategory.toLowerCase() == 'crypto') {
            exchangeValueList.add(
                _videosRelatedResponse.response[i].industry.isEmpty ? "coin" : _videosRelatedResponse.response[i].industry[0].name.toLowerCase());
          } else if (finalisedCategory.toLowerCase() == 'commodity') {
            exchangeValueList.add(_videosRelatedResponse.response[i].country.toLowerCase());
          } else {
            exchangeValueList.add("inrusd");
          }
        }
        setState(() {
          loadingRelated = true;
        });
      }
    } else if (relatedTopicText.value.toLowerCase() == 'forums') {
      _forumsRelatedResponse = RelatedForumsModel.fromJson(responseData);
      if (_forumsRelatedResponse.response.isEmpty) {
        setState(() {
          emptyBool = true;
          loadingRelated = true;
        });
      } else {
        emptyBool = false;
        for (int i = 0; i < _forumsRelatedResponse.response.length; i++) {
          listRelatedIds.add(_forumsRelatedResponse.response[i].id);
          if (finalisedCategory.toLowerCase() == 'stocks') {
            if (_forumsRelatedResponse.response[i].exchange == 'NSE' ||
                _forumsRelatedResponse.response[i].exchange == "BSE" ||
                _forumsRelatedResponse.response[i].exchange == "INDX") {
              exchangeValueList.add(_forumsRelatedResponse.response[i].exchange.toLowerCase());
            } else {
              exchangeValueList.add('usastocks');
            }
          } else if (finalisedCategory.toLowerCase() == 'crypto') {
            exchangeValueList.add(
                _forumsRelatedResponse.response[i].industry.isEmpty ? "coin" : _forumsRelatedResponse.response[i].industry[0].name.toLowerCase());
          } else if (finalisedCategory.toLowerCase() == 'commodity') {
            exchangeValueList.add(_forumsRelatedResponse.response[i].country.toLowerCase());
          } else {
            exchangeValueList.add("inrusd");
          }
        }
        setState(() {
          loadingRelated = true;
        });
      }
    } else if (relatedTopicText.value.toLowerCase() == 'surveys') {
      _surveysRelatedResponse = RelatedSurveyModel.fromJson(responseData);
      if (_surveysRelatedResponse.response.isEmpty) {
        setState(() {
          emptyBool = true;
          loadingRelated = true;
        });
      } else {
        emptyBool = false;
        for (int i = 0; i < _surveysRelatedResponse.response.length; i++) {
          listRelatedIds.add(_surveysRelatedResponse.response[i].id);
          if (finalisedCategory.toLowerCase() == 'stocks') {
            if (_surveysRelatedResponse.response[i].exchange == 'NSE' ||
                _surveysRelatedResponse.response[i].exchange == "BSE" ||
                _surveysRelatedResponse.response[i].exchange == "INDX") {
              exchangeValueList.add(_surveysRelatedResponse.response[i].exchange.toLowerCase());
            } else {
              exchangeValueList.add('usastocks');
            }
          } else if (finalisedCategory.toLowerCase() == 'crypto') {
            exchangeValueList.add(
                _surveysRelatedResponse.response[i].industry.isEmpty ? "coin" : _surveysRelatedResponse.response[i].industry[0].name.toLowerCase());
          } else if (finalisedCategory.toLowerCase() == 'commodity') {
            exchangeValueList.add(_surveysRelatedResponse.response[i].country.toLowerCase());
          } else {
            exchangeValueList.add("inrusd");
          }
        }
        setState(() {
          loadingRelated = true;
        });
      }
    } else {}
  }

  Future<bool> likeFunction({required String id, required String type}) async {
    var uri = Uri.parse(baseurl + versionLocker + likes);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<bool> disLikeFunction({required String id, required String type}) async {
    var uri = Uri.parse(baseurl + versionLocker + dislikes);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<bool> shareFunction({required String id, required String type}) async {
    var uri = Uri.parse(baseurl + versionLocker + share);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<Uri> getLinK(
      {required String id,
      required String type,
      required String imageUrl,
      required String title,
      required String description,
      required String category,
      required String filterId}) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/DemoPage/$id/$type'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  reportPost({
    required String action,
    required String why,
    required String description,
    required String newsId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    if (why == "Other") {
      if (description == "") {
        if (!mounted) {
          return false;
        }
        Flushbar(
          message: "Please describe the reason in the description ",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        var url = Uri.parse(baseurl + versionLocker + reportNews);
        var responseNew = await http.post(url, body: {
          "action": action,
          "why": why,
          "description": description,
          "news_id": newsId,
        }, headers: {
          'Authorization': mainUserToken
        });
        var responseDataNew = json.decode(responseNew.body);
        if (responseDataNew["status"]) {
          if (!mounted) {
            return;
          }
          Navigator.pop(context);
          Navigator.pop(context, true);
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
          //getForumValues(text: "",category: selectedValue,filterId: filterId);
        } else {
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      }
    } else {
      var url = Uri.parse(baseurl + versionLocker + reportNews);
      var responseNew = await http.post(url, body: {
        "action": action,
        "why": why,
        "description": description,
        "news_id": newsId,
      }, headers: {
        'Authorization': mainUserToken
      });
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew["status"]) {
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
        Navigator.pop(context, true);
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
        //getForumValues(text: "",category: selectedValue,filterId: filterId);
      } else {
        if (!mounted) {
          return false;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  }

  @override
  void dispose() {
    listIds.clear();
    listRelatedIds.clear();
    currentNewsId.value = "";
    idIndex.value = 0;
    forumEntry = true;
    surveyEntry = true;
    isMainLiked.clear();
    isMainDisliked.clear();
    likeMainCount.clear();
    shareMainCount.clear();
    viewMainCount.clear();
    responseMainCount.clear();
    disLikeMainCount.clear();
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    context.read<BookMarkSingleWidgetBloc>().add(const BookLoadingEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return GestureDetector(
      onPanUpdate: (details) {
        swipeDirection = listIds.length <= 1
            ? ""
            : details.delta.dx < 0
                ? 'left'
                : 'right';
      },
      onPanEnd: (details) {
        if (swipeDirection == "") {
          return;
        }
        if (swipeDirection == 'left') {
          setState(() {
            if (idIndex < listIds.length - 1) {
              idIndex.value = idIndex.value + 1;
              currentNewsId.value = listIds[idIndex.value];
            } else {
              idIndex.value = 0;
              currentNewsId.value = listIds[idIndex.value];
            }
          });
          getAllData();
        }
        if (swipeDirection == 'right') {
          setState(() {
            if (idIndex > 0) {
              idIndex.value = idIndex.value - 1;
              currentNewsId.value = listIds[idIndex.value];
            } else {
              idIndex.value = listIds.length - 1;
              currentNewsId.value = listIds[idIndex.value];
            }
          });
          getAllData();
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          if (widget.comeFrom == 'similar') {
            /*if (!mounted) {
              return false;
            }*/
            Navigator.pop(context);
          } else if (widget.comeFrom == 'main') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const MainBottomNavigationPage(
                        caseNo1: 0, text: "", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
          } else if (widget.comeFrom == 'finalCharts') {
            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
            /* if (!mounted) {
              return false;
            }*/
            Navigator.pop(context);
          } else {
            Navigator.pop(context, engageStatus);
          }
          return false;
        },
        child: Container(
          //color: Colors.white,
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Scaffold(
                //backgroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  //backgroundColor: Colors.white,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  leading: loading
                      ? IconButton(
                          onPressed: () {
                            if (widget.comeFrom == 'similar') {
                              if (!mounted) {
                                return;
                              }
                              Navigator.pop(context);
                            } else if (widget.comeFrom == 'main') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => const MainBottomNavigationPage(
                                          caseNo1: 0, text: "", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
                            } else if (widget.comeFrom == 'finalCharts') {
                              SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                              if (!mounted) {
                                return;
                              }
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context, engageStatus);
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        )
                      : const SizedBox(),
                  actions: [
                    loading
                        ? bookMarkWidgetSingle(
                            bookMark: [_newsResponse.response.bookmark],
                            context: context,
                            id: _newsResponse.response.id,
                            type: 'news',
                            modelSetState: setState,
                            index: 0)
                        : const SizedBox(),
                    loading
                        ? IconButton(
                            onPressed: () {
                              showSheet(context: context);
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.black,
                            ))
                        : const SizedBox()
                  ],
                ),
                body: loading
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ListView(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: height / 20.5,
                                margin: EdgeInsets.symmetric(horizontal: width / 25),
                                child: Row(
                                  children: [
                                    Container(
                                      height: height / 23.67,
                                      width: width / 11.10,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            //image: AssetImage("lib/Constants/Assets/NewsPageImage/newsImageLogo.png")
                                            image: AssetImage("lib/Constants/Assets/SMLogos/newsImage.png")),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 27.4,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _newsResponse.response.sourceName.toString().capitalizeFirst!,
                                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16), color: const Color(0XFF353131)),
                                            ),
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '$likeCount Like ',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400, fontSize: text.scale(10), color: const Color(0XFFB7B7B7)),
                                                  ),
                                                  SizedBox(
                                                    width: width / 51.375,
                                                  ),
                                                  VerticalDivider(
                                                    color: const Color(0XFFB7B7B7),
                                                    width: width / 20.55,
                                                  ),
                                                  SizedBox(
                                                    width: width / 51.375,
                                                  ),
                                                  Text(
                                                    '$disLikeCount Dislike ',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400, fontSize: text.scale(10), color: const Color(0XFFB7B7B7)),
                                                  ),
                                                  SizedBox(
                                                    width: width / 51.375,
                                                  ),
                                                  VerticalDivider(
                                                    width: width / 20.55,
                                                    color: const Color(0XFFB7B7B7),
                                                  ),
                                                  SizedBox(
                                                    width: width / 51.375,
                                                  ),
                                                  Text(
                                                    '${_newsResponse.response.shareCount}  Shared',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w400, fontSize: text.scale(10), color: const Color(0XFFB7B7B7)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height / 31.28,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: width / 25),
                                child: RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: "${_newsResponse.response.title} ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: text.scale(14),
                                          color: const Color(0XFF353131),
                                          fontFamily: "Poppins"),
                                    ),
                                    TextSpan(
                                      text: '${_newsResponse.response.date} ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: text.scale(8),
                                          color: const Color(0XFFB7B7B7),
                                          fontFamily: "Poppins"),
                                    ),
                                    WidgetSpan(
                                        child: _newsResponse.response.sentiment == 'positive'
                                            ? Container(
                                                margin: const EdgeInsets.only(left: 8.0),
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(3),
                                                  color: const Color(0XFF39B12F),
                                                ),
                                                child: Text(
                                                  "Positive",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: text.scale(10),
                                                      color: Colors.white,
                                                      fontFamily: "Poppins"),
                                                ),
                                              )
                                            : _newsResponse.response.sentiment == 'negative'
                                                ? Container(
                                                    margin: const EdgeInsets.only(left: 8.0),
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(3),
                                                      color: const Color(0XFFFA3133),
                                                    ),
                                                    child: Text(
                                                      "Negative",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: text.scale(10),
                                                          color: Colors.white,
                                                          fontFamily: "Poppins"),
                                                    ),
                                                  )
                                                : _newsResponse.response.sentiment == 'neutral'
                                                    ? Container(
                                                        margin: const EdgeInsets.only(left: 8.0),
                                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(3),
                                                          color: const Color(0XFFE4C452),
                                                        ),
                                                        child: Text(
                                                          "Neutral",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: text.scale(10),
                                                              color: Colors.white,
                                                              fontFamily: "Poppins"),
                                                        ),
                                                      )
                                                    : const SizedBox())
                                  ]),
                                ),
                              ),
                              SizedBox(
                                height: height / 54.75,
                              ),
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    width: width,
                                    height: height / 3.71,
                                    margin: EdgeInsets.symmetric(horizontal: width / 34.25),
                                    decoration:
                                        BoxDecoration(image: DecorationImage(image: NetworkImage(_newsResponse.response.imageUrl), fit: BoxFit.fill)),
                                  ),
                                  Positioned(top: height / 58.4, right: width / 16.44, child: excLabelButton(text: exchangeValue, context: context)),
                                ],
                              ),
                              SizedBox(
                                height: height / 54.75,
                              ),
                              Card(
                                elevation: 10.0,
                                shape: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                                    borderSide: BorderSide(color: Colors.white)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: width / 25),
                                  decoration: BoxDecoration(
                                    color: const Color(0XFFF9FFF9),
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                                    border: Border.all(color: Colors.white),
                                    /*   boxShadow: [
                                  BoxShadow(
                                    color: Color(0XFF11AA04).withOpacity(0.05),
                                    offset: Offset(
                                      0.0,
                                      -5.0,
                                    ),
                                    blurRadius: 1.0,
                                    spreadRadius: 1.0,
                                  ),
                                ]*/
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _newsResponse.response.description == ""
                                          ? const SizedBox()
                                          : SizedBox(
                                              height: height / 36.5,
                                            ),
                                      _newsResponse.response.description == ""
                                          ? const SizedBox()
                                          : SizedBox(
                                              width: width,
                                              child: Text(
                                                _newsResponse.response.description,
                                                style:
                                                    TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w400, color: const Color(0XFF484848)),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                      _newsResponse.response.snippet == ""
                                          ? const SizedBox()
                                          : SizedBox(
                                              height: height / 87.6,
                                            ),
                                      _newsResponse.response.snippet == ""
                                          ? const SizedBox()
                                          : SizedBox(
                                              width: width,
                                              child: Text(
                                                _newsResponse.response.snippet,
                                                style:
                                                    TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w400, color: const Color(0XFF484848)),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                      SizedBox(
                                        height: height / 27.375,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'To read full article',
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(16), color: const Color(0XFF353131)),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  return DemoPage(
                                                    url: _newsResponse.response.newsUrl,
                                                    text: _newsResponse.response.title,
                                                    image: _newsResponse.response.imageUrl,
                                                    id: widget.id,
                                                    type: 'news',
                                                    activity: true,
                                                    checkMain: false,
                                                  );
                                                }));*/
                                                Get.to(const DemoView(),
                                                    arguments: {"id": widget.id, "type": "news", "url": _newsResponse.response.newsUrl});
                                              },
                                              child: Text(
                                                'Click Here',
                                                style:
                                                    TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF0EA102)),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: height / 25.76,
                                      ),
                                      const Divider(
                                        color: Color(0XFFEDEAEA),
                                        thickness: 0.8,
                                      ),
                                      Obx(() => RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                  text: "Similar ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(14),
                                                      color: const Color(0XFF3C413B),
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "Poppins")),
                                              TextSpan(
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      lockerCategories(
                                                        context: context,
                                                        initFunction: getRelatedData,
                                                      );
                                                    },
                                                  text: "${relatedTopicText.value} ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(16),
                                                      color: const Color(0XFF0EA102),
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: "Poppins")),
                                            ]),
                                          )),
                                      //Text('Similar News to you',style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*14,color: Color(0XFF3C413B)),),
                                      SizedBox(
                                        height: height / 125.14,
                                      ),
                                      loadingRelated
                                          ? emptyBool
                                              ? Center(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                          height: 150,
                                                          width: 150,
                                                          child: SvgPicture.asset("lib/Constants/Assets/SMLogos/noResponse_green.svg")),
                                                      RichText(
                                                        text: const TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text: 'No similar posts found',
                                                                style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : similarDataFunc(
                                                  context: context,
                                                  data: relatedTopicText.value.toLowerCase() == "news"
                                                      ? _newsRelatedResponse
                                                      : relatedTopicText.value.toLowerCase() == "videos"
                                                          ? _videosRelatedResponse
                                                          : relatedTopicText.value.toLowerCase() == "forums"
                                                              ? _forumsRelatedResponse
                                                              : relatedTopicText.value.toLowerCase() == "surveys"
                                                                  ? _surveysRelatedResponse
                                                                  : _newsRelatedResponse,
                                                  initFunction: getAllData,
                                                  modelSetState: setState,
                                                  exchangeList: exchangeValueList,
                                                )
                                          : SizedBox(
                                              height: 200,
                                              child: Center(
                                                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                              )),
                                      /*ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 5,
                                    itemBuilder: (BuildContext context, int index){
                                      return  Column(
                                        children: [
                                          Container(
                                            height: _height/8.42,
                                            width: _width,
                                            margin: EdgeInsets.only(top:_height/51.52,bottom: _height/73),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: _width/2.41,
                                                  decoration: BoxDecoration(
                                                    borderRadius:BorderRadius.circular(15),
                                                      image: DecorationImage(
                                                          image: AssetImage("lib/Constants/Assets/NewsPageImage/RelatedNewsImage.png"),
                                                          fit: BoxFit.fill
                                                      )
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: _width/27.4,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('CNBC-TV18 Market Live: Sensex Turns Range-Bound, Nifty Around 11,050 Sensex Turns Range-Bound, Nifty Around .',style: TextStyle(fontWeight: FontWeight.w600,fontSize: _text*10,color: Color(0XFF1D1919),),textAlign: TextAlign.justify,),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('28 mins ago',style: TextStyle(fontWeight: FontWeight.w500,fontSize: _text*8,color: Color(0XFFB7B7B7)),),
                                                          IntrinsicHeight(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text('128  Like ',style: TextStyle(fontWeight: FontWeight.w400,fontSize: _text*8,color: Color(0XFFB7B7B7)),),
                                                                SizedBox(width: _width/102.75,),
                                                                VerticalDivider(color:Color(0XFFB7B7B7),
                                                                  width: _width/41.1,),
                                                                SizedBox(width: _width/102.75,),
                                                                Text('18 Dislike ',style: TextStyle(fontWeight: FontWeight.w400,fontSize: _text*8,color: Color(0XFFB7B7B7)),),
                                                                SizedBox(width: _width/102.75,),
                                                                VerticalDivider(
                                                                  width: _width/41.1,
                                                                  color: Color(0XFFB7B7B7),
                                                                ),
                                                                SizedBox(width: _width/102.75,),
                                                                Text('250  Shared',style: TextStyle(fontWeight: FontWeight.w400,fontSize: _text*8,color: Color(0XFFB7B7B7)),),
                                                              ],
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
                                          Divider(color: Color(0XFFEDEAEA),thickness: 0.8,),
                                        ],
                                      );
                                    }),*/
                                      SizedBox(
                                        height: height / 11.68,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          /*forLottie?
                    Positioned(
                    right: 0,
                      top: 30,
                    child:   Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:[ swipeLeftAnimation(),]),):
                    SizedBox(),*/
                          Material(
                            elevation: 10,
                            child: Container(
                              height: height / 11.68,
                              width: width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  border: Border.all(color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(color: const Color(0XFF11AA04).withOpacity(0.03), blurRadius: 5, spreadRadius: 5),
                                  ]),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: mainSkipValue
                                            ? () {
                                                commonFlushBar(context: context, initFunction: initState);
                                              }
                                            : () async {
                                                bool response1 = await likeFunction(id: _newsResponse.response.id, type: "news");
                                                if (response1) {
                                                  logEventFunc(name: "Likes", type: "news");
                                                  setState(() {
                                                    if (isLiked == true) {
                                                      if (isDisliked == true) {
                                                      } else {
                                                        likeCount -= 1;
                                                      }
                                                    } else {
                                                      if (isDisliked == true) {
                                                        disLikeCount -= 1;
                                                        likeCount += 1;
                                                      } else {
                                                        likeCount += 1;
                                                      }
                                                    }
                                                    isLiked = !isLiked;
                                                    isDisliked = false;
                                                  });
                                                } else {}
                                              },
                                        child: Container(
                                          margin: EdgeInsets.only(left: width / 25, right: width / 25),
                                          height: height / 40.6,
                                          width: width / 18.75,
                                          child: isLiked
                                              ? SvgPicture.asset(
                                                  isDarkTheme.value
                                                      ? "assets/home_screen/like_filled_dark.svg"
                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                )
                                              : SvgPicture.asset(
                                                  isDarkTheme.value
                                                      ? "assets/home_screen/like_dark.svg"
                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          logEventFunc(name: "Share", type: "Forum");
                                          newLink = await getLinK(
                                              id: _newsResponse.response.id,
                                              type: "news",
                                              description: '',
                                              imageUrl: "",
                                              title: _newsResponse.response.title,
                                              category: finalisedCategory.toLowerCase(),
                                              filterId: finalisedFilterId);
                                          ShareResult result = await Share.share(
                                            "Look what I was able to find on Tradewatch: ${_newsResponse.response.title} ${newLink.toString()}",
                                          );
                                          if (result.status == ShareResultStatus.success) {
                                            await shareFunction(id: _newsResponse.response.id, type: "news");
                                          }
                                        },
                                        child: Container(
                                            height: height / 40.6,
                                            width: width / 18.75,
                                            margin: EdgeInsets.only(left: width / 25, right: width / 25),
                                            child: SvgPicture.asset(
                                              isDarkTheme.value
                                                  ? "assets/home_screen/share_dark.svg"
                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                            )),
                                      ),
                                      GestureDetector(
                                        onTap: mainSkipValue
                                            ? () {
                                                commonFlushBar(context: context, initFunction: initState);
                                              }
                                            : () async {
                                                bool response3 = await disLikeFunction(id: _newsResponse.response.id, type: "news");
                                                if (response3) {
                                                  logEventFunc(name: "Dislikes", type: "Forum");
                                                  setState(() {
                                                    if (isDisliked == true) {
                                                      if (isLiked == true) {
                                                      } else {
                                                        disLikeCount -= 1;
                                                      }
                                                    } else {
                                                      if (isLiked == true) {
                                                        likeCount -= 1;
                                                        disLikeCount += 1;
                                                      } else {
                                                        disLikeCount += 1;
                                                      }
                                                    }
                                                    isDisliked = !isDisliked;
                                                    isLiked = false;
                                                  });
                                                } else {}
                                              },
                                        child: Container(
                                          height: height / 40.6,
                                          width: width / 18.75,
                                          margin: EdgeInsets.only(left: width / 25, right: width / 25),
                                          child: isDisliked
                                              ? SvgPicture.asset(
                                                  isDarkTheme.value
                                                      ? "assets/home_screen/dislike_filled_dark.svg"
                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                )
                                              : SvgPicture.asset(
                                                  isDarkTheme.value
                                                      ? "assets/home_screen/dislike_dark.svg"
                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Card(
                                          elevation: 2.0,
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Image.asset("lib/Constants/Assets/NewsPageImage/headphone.png"),
                                                SizedBox(
                                                  width: width / 51.75,
                                                ),
                                                Text(
                                                  'Audio',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500, fontSize: text.scale(12), color: const Color(0XFF817E7E)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width / 17.86,
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Card(
                                          elevation: 2.0,
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white)),
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                "lib/Constants/Assets/NewsPageImage/translate.png",
                                                scale: 4,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width / 21.63,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                      )),
          ),
        ),
      ),
    );
  }

  showSheet({required BuildContext context}) {
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
                    onTap: () {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      _controller.clear();
                      setState(() {
                        actionValue = "Report";
                      });
                      showAlertDialog(context: context, newsId: _newsResponse.response.id);
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.shield,
                      size: 20,
                    ),
                    title: Text(
                      "Report Post",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      _controller.clear();
                      setState(() {
                        actionValue = "Block";
                      });
                      showAlertDialog(context: context, newsId: _newsResponse.response.id);
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.flag,
                      size: 20,
                    ),
                    title: Text(
                      "Block Post",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showAlertDialog({required BuildContext context, required String newsId}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
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
                          if (!mounted) {
                            return;
                          }
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
                                  setState(() {
                                    actionValue = value!;
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
                                  setState(() {
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
                    controller: _controller,
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
                      logEventFunc(name: actionValue == "Report" ? 'Reported_Post' : 'Blocked_Post', type: 'News');
                      reportPost(action: actionValue, why: whyValue, description: _controller.text, newsId: _newsResponse.response.id);
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
}
