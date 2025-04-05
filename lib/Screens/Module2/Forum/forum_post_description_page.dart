import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:river_player/river_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/Api.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_description_page.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/related_news_model.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/related_videos_model.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/detailed_forum_image_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/related_survey_model.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/DoubleOne/book_mark_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/SingleOne/book_mark_single_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/DoubleOne/translation_widget_single_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_widgets.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';

import 'forum_post_edit_page.dart';
import 'forum_response_model.dart';
import 'related_forums_model.dart';
import 'response_forum_response_model.dart';

List<String> listForumsIds = [];
RxString currentForumsId = "".obs;
RxInt idForumIndex = 0.obs;
String titleMain = "";
String descriptionMain = "";

class ForumPostDescriptionPage extends StatefulWidget {
  final String? topic;
  final String forumId;
  final String comeFrom;
  final List<String> idList;

  const ForumPostDescriptionPage({Key? key, required this.idList, required this.comeFrom, required this.forumId, this.topic}) : super(key: key);

  @override
  State<ForumPostDescriptionPage> createState() => _ForumPostDescriptionPageState();
}

class _ForumPostDescriptionPageState extends State<ForumPostDescriptionPage> {
  File? pickedImage;
  File? pickedVideo;
  FocusNode textFocusNode = FocusNode();
  bool responseLoader = false;
  String selectedValue = "Recents";
  final List<String> _choose = ["Recents", "Most Liked", "Most Disliked"];
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  bool playVideo = false;
  bool playerNew = false;
  bool emptyBool = false;
  bool emptyBoolResponses = true;
  bool popUpAttach = false;
  bool noSimilarData = false;
  bool refreshLoader = false;
  bool showList = false;
  bool showList1 = false;
  bool showLoader = false;
  bool showLoader1 = false;
  bool searchNoList = false;
  FilePickerResult? doc;
  String mainUserToken = "";
  String mainUserId = "";
  late Uri newLink;
  String userName = "";
  String avatar = "";
  String selectedUrlType = "";
  String selectedPopUpUrlType = "";
  File? pickedFile;
  List<File> file1 = [];
  Map<String, dynamic> data = {};
  Map<String, dynamic> dataUpdate = {};
  Map<String, dynamic> dataNew = {};
  Map<String, dynamic> dataUpdateNew = {};
  List forumImagesList = [];
  List resForumImagesList = [];
  List resForumTaggedUserIdList = [];
  List<String> relatedForumIdList = [];
  List<String> relatedForumDescriptionList = [];
  List resForumTaggedUserList = [];
  List resForumSourceNameList = [];
  List resForumTitlesList = [];
  List<String> resForumIdList = [];
  List<int> resForumLikeList = [];
  List<int> resForumDislikeList = [];
  List<bool> resForumUseList = [];
  List<dynamic> resForumObjectList = [];
  List<bool> resForumUseDisList = [];
  List<String> resForumUserIdList = [];
  List<String> resForumDescriptionList = [];
  List<String> resForumUrlList = [];
  List<String> resForumUrlTypeList = [];
  List<bool> resForumMyList = [];
  List<String> resForumTimeList = [];
  List forumSourceNameList = [];
  List<String> forumTitlesList = [];
  List<bool> forumTranslationList = [];
  List<String> forumIdList = [];
  List<String> mainForumIdList = [];
  List<String> forumCompanyList = [];
  List<int> forumViewsList = [];
  List<dynamic> forumObjectList = [];
  dynamic forumObject;
  dynamic resForumObject;
  List<int> forumResponseList = [];
  List<String> forumUserIdList = [];
  List<int> forumLikeList = [];
  List<int> forumDislikeList = [];
  List<bool> forumUseList = [];
  List<bool> forumUseDisList = [];
  List<bool> forumMyList = [];
  List<String> actionList = ["Report", "Block"];
  List<String> whyList = ["Scam", "Abusive Content", "Spam", "Other"];
  String actionValue = "Report";
  String newUrlLink = "";
  String whyValue = "Scam";
  String mainTime = "";
  String newTime = "";
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerController _betterPlayerController1;
  late BetterPlayerController _betterPlayerController2;
  List<String> networkUrls = [];
  List<BetterPlayerController> betterPlayerList = [];
  List<bool> playerConditions = [];
  List<String> playerVideoId = [];
  Map<String, dynamic> data1 = {};
  Map<String, dynamic> data1New = {};
  String typeNew = "";
  List<String> forumLikedImagesList = [];
  List<String> forumLikedIdList = [];
  List<String> forumLikedSourceNameList = [];
  List<String> forumViewedImagesList = [];
  List<String> forumViewedIdList = [];
  List<String> forumViewedSourceNameList = [];
  List<String> searchResult = [];
  List<String> searchIdResult = [];
  List<String> searchLogo = [];
  String newResponseValue = "";
  String newResponseValue1 = "";
  int textCount = 0;
  int textCount1 = 0;
  String messageText = "";
  String messageText1 = "";
  String searchUserId = "";
  String relatedForumId = "";
  String relatedForumDescription = "";
  List<String> splitOne = [];
  List<String> splitOne1 = [];
  List<String> addedTags = [];
  List<String> forumResponseLikedImagesList = [];
  List<String> forumResponseLikedIdList = [];
  List<String> forumResponseLikedSourceNameList = [];
  String swipeDirection = "";
  bool loadingRelated = false;
  bool isLiked = false;
  bool isDisliked = false;
  int viewCount = 0;
  int likeCount = 0;
  int shareCount = 0;
  int disLikeCount = 0;
  int responseCount = 0;
  List<String> exchangeValueList = [];
  late ForumsResponseModel _forumsResponse;
  late RelatedNewsModel _newsRelatedResponse;
  late RelatedVideosModel _videosRelatedResponse;
  late RelatedForumsModel _forumsRelatedResponse;
  late RelatedSurveyModel _surveysRelatedResponse;
  late ResponseForumsResponseModel _responseForums;
  List<String> idListNew = [];
  bool forLottie = false;
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

  @override
  void initState() {
    getNotifyCountAndImage();
    getAllDataMain(name: 'Forum_Description_Page');
    getAwaitData();
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adVariables.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('$BannerAd loaded.');
            setState(() {
              _bannerAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            debugPrint('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => debugPrint('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => debugPrint('$BannerAd onAdClosed.'),
        ),
        request: const AdRequest())
      ..load();
  }

  getAwaitData() async {
    await listCreations();
    await getAllData();
  }

  listCreations() async {
    idListNew.addAll(widget.idList);
    listForumsIds.clear();
    if (idListNew.isEmpty) {
      listForumsIds.add(widget.forumId);
    } else {
      listForumsIds.addAll(idListNew);
    }
    idForumIndex = listForumsIds.indexOf(widget.forumId).obs;
    relatedTopicText = "Forums".obs;
    relatedOnPage = 'forums'.obs;
    currentForumsId = listForumsIds[idForumIndex.value].obs;
    listRelatedIds.clear();
  }

  getAllData() async {
    //await getValues();
    setState(() {
      refreshLoader = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    await getIdData(id: currentForumsId.value, type: "forums");
    _forumsResponse.response.urlType == 'video' ? playerFunc(urlLink: _forumsResponse.response.url) : debugPrint("nothing");
    titleMain = _forumsResponse.response.title;
    descriptionMain = _forumsResponse.response.description;
    isLiked = _forumsResponse.response.likes;
    isDisliked = _forumsResponse.response.dislikes;
    likeCount = _forumsResponse.response.likesCount;
    shareCount = _forumsResponse.response.shareCount;
    viewCount = _forumsResponse.response.viewsCount;
    responseCount = _forumsResponse.response.responseCount;
    disLikeCount = _forumsResponse.response.disLikesCount;
    await getOwnUserData();
    await getResponses(forumId: currentForumsId.value, type: selectedValue);
    //getRelatedForums(forumId: currentForumsId.value, category: widget.text,);
    await getRelatedData();
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    if (diff.inSeconds >= 0 && diff.inSeconds <= 59) {
      mainTime = "few sec ago";
    } else if (diff.inMinutes >= 0 && diff.inMinutes <= 59) {
      mainTime = "${diff.inMinutes} min ago";
    } else if (diff.inHours >= 0 && diff.inHours <= 23) {
      mainTime = mainTime = "${diff.inHours} hrs ago";
    } else if (diff.inDays >= 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        mainTime = '${diff.inDays} day ago';
      } else {
        mainTime = '${diff.inDays} days ago';
      }
    } else {
      if (diff.inDays >= 7 && diff.inDays <= 13) {
        mainTime = '${(diff.inDays / 7).floor()} week ago';
      } else if (diff.inDays > 13 && diff.inDays <= 29) {
        mainTime = '${(diff.inDays / 7).floor()} weeks ago';
      } else if (diff.inDays > 29 && diff.inDays <= 59) {
        mainTime = '${(diff.inDays / 30).floor()} month ago';
      } else if (diff.inDays > 59 && diff.inDays <= 360) {
        mainTime = '${(diff.inDays / 30).floor()} months ago';
      } else {
        mainTime = "a year ago";
      }
    }
    return mainTime;
  }

  String readTimestamp1(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    if (diff.inSeconds >= 0 && diff.inSeconds <= 59) {
      newTime = "few sec ago";
    } else if (diff.inMinutes >= 0 && diff.inMinutes <= 59) {
      newTime = "${diff.inMinutes} min ago";
    } else if (diff.inHours >= 0 && diff.inHours <= 23) {
      newTime = newTime = "${diff.inHours} hrs ago";
    } else if (diff.inDays >= 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        newTime = '${diff.inDays} day ago';
      } else {
        newTime = '${diff.inDays} days ago';
      }
    } else {
      if (diff.inDays >= 7 && diff.inDays <= 13) {
        newTime = '${(diff.inDays / 7).floor()} week ago';
      } else if (diff.inDays > 13 && diff.inDays <= 29) {
        newTime = '${(diff.inDays / 7).floor()} weeks ago';
      } else if (diff.inDays > 29 && diff.inDays <= 59) {
        newTime = '${(diff.inDays / 30).floor()} month ago';
      } else if (diff.inDays > 59 && diff.inDays <= 360) {
        newTime = '${(diff.inDays / 30).floor()} months ago';
      } else {
        newTime = "a year ago";
      }
    }
    resForumTimeList.add(newTime);
    return newTime;
  }

  editMessage({required String messageId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionForum + responseEdit);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      "message_id": messageId,
      "forum_id": _forumsResponse.response.id,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      _editController.text = responseData["response"]["message"];
    }
  }

  reportPost({required String action, required String why, required String description, required String forumId, required String forumUserId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    if (why == "Other") {
      if (description == "") {
        if (!mounted) {
          return;
        }
        Flushbar(
          message: "Please describe the reason in the description ",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        var url = Uri.parse(baseurl + versionForum + addReport);
        data1 = {
          "action": action,
          "why": why,
          "description": description,
          "forum_id": forumId,
          "forum_user": forumUserId,
        };
        var responseNew = await http.post(url, body: data1, headers: {'Authorization': mainUserToken});
        var responseDataNew = json.decode(responseNew.body);
        if (responseDataNew["status"]) {
          if (actionValue == "Report") {
            if (!mounted) {
              return;
            }
            Navigator.pop(context);
          } else {
            if (!mounted) {
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return ForumPage(text: finalisedCategory.toString().capitalizeFirst!);
            }));
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        } else {
          if (!mounted) {
            return;
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      }
    } else {
      var url = Uri.parse(baseurl + versionForum + addReport);
      data1 = {
        "action": action,
        "why": why,
        "description": description,
        "forum_id": forumId,
        "forum_user": forumUserId,
      };
      var responseNew = await http.post(url, body: data1, headers: {'Authorization': mainUserToken});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew["status"]) {
        if (actionValue == "Report") {
          if (!mounted) {
            return;
          }
          Navigator.pop(context);
        } else {
          if (!mounted) {
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ForumPage(text: finalisedCategory.toString().capitalizeFirst!);
          }));
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (!mounted) {
          return;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  }

  reportResponsePost(
      {required String action,
      required String why,
      required String description,
      required String forumId,
      required String messageId,
      required String forumUserId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    if (why == "Other") {
      if (description == "") {
        if (!mounted) {
          return;
        }
        Flushbar(
          message: "Please describe the reason in the description ",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        var url = Uri.parse(baseurl + versionForum + responseReport);
        data1New = {
          "action": action,
          "why": why,
          "description": description,
          "forum_id": forumId,
          "forum_user": forumUserId,
          "message_id": messageId
        };
        var responseNew = await http.post(url, body: data1New, headers: {'Authorization': mainUserToken});
        var responseDataNew = json.decode(responseNew.body);
        if (responseDataNew["status"]) {
          if (actionValue == "Report") {
            if (!mounted) {
              return;
            }
            Navigator.pop(context);
          } else {
            if (!mounted) {
              return;
            }
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return ForumPage(text: finalisedCategory.toString().capitalizeFirst!);
            }));
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        } else {
          if (!mounted) {
            return;
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      }
    } else {
      var url = Uri.parse(baseurl + versionForum + responseReport);
      data1New = {"action": action, "why": why, "description": description, "forum_id": forumId, "forum_user": forumUserId, "message_id": messageId};
      var responseNew = await http.post(url, body: data1New, headers: {'Authorization': mainUserToken});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew["status"]) {
        if (actionValue == "Report") {
          if (!mounted) {
            return;
          }
          Navigator.pop(context);
        } else {
          if (!mounted) {
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ForumPage(text: finalisedCategory.toString().capitalizeFirst!);
          }));
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (!mounted) {
          return;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
      }
    }
  }

  deletePost({required String forumId, required bool similarNew}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionForum + forumDelete);
    var responseNew = await http.post(url, body: {"forum_id": forumId}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      if (similarNew) {
      } else {
        if (widget.comeFrom == 'forum') {
          if (!mounted) {
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ForumPage(text: finalisedCategory.toString().capitalizeFirst!);
          }));
        } else if (widget.comeFrom == 'forumDetail') {
          if (!mounted) {
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return DetailedForumImagePage(
                text: finalisedCategory.toString().capitalizeFirst!,
                tickerId: '',
                tickerName: "",
                fromCompare: false,
                forumDetail: '',
                filterId: finalisedFilterId,
                catIdList: mainCatIdList,
                topic: widget.topic == null ? "Latest Topics" : widget.topic!,
                navBool: false,
                sendUserId: '');
          }));
        } else {
          if (!mounted) {
            return;
          }
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const MainBottomNavigationPage(
              tType: true,
              text: "",
              caseNo1: 0,
              newIndex: 0,
              excIndex: 0,
              countryIndex: 0,
              isHomeFirstTym: false,
            );
          }));
        }
      }
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  deletePost11({required String forumId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionForum + responseDelete);
    var responseNew = await http.post(url, body: {"message_id": forumId}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  getOwnUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + getUser);
    var response =
        await http.get(url, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'user_id': mainUserId, 'Authorization': mainUserToken});
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      userName = responseData["response"]["username"];
      avatar = responseData["response"]["avatar"];
    }
  }

  getRelatedData() async {
    setState(() {
      loadingRelated = false;
    });
    exchangeValueList.clear();
    listRelatedIds.clear();
    forumTitlesList.clear();
    forumTranslationList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    forForumsLottieCount++;
    prefs.setInt('forForumsCount', forForumsLottieCount);
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionLocker + relatedAll;
    var response = await dioMain.post(
      url,
      data: {
        'type': relatedTopicText.value.toLowerCase(),
        'tickers': _forumsResponse.response.tickers,
        'category': finalisedCategory.toLowerCase(),
        'exchange': _forumsResponse.response.exchange,
        'ticker_id': "",
        'post_id': _forumsResponse.response.id
      },
      options: Options(
        headers: {'Authorization': mainUserToken},
      ),
    );
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
    setState(() {
      forLottie = forForumsLottieCount <= 5 ? true : false;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        forLottie = false;
      });
    });
  }

  getIdData({required String id, required String type}) async {
    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
    context.read<TranslationWidgetSingleBloc>().add(const LoadingTranslationSingleEvent());
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    context.read<BookMarkSingleWidgetBloc>().add(const BookLoadingEvent());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"id": id, "type": type});
    var responseData = json.decode(response.body);
    _forumsResponse = ForumsResponseModel.fromJson(responseData);
    watchVariables.postCountTotalMain.value = _forumsResponse.postViewCounts;
    if (watchVariables.postCountTotalMain.value % 5 == 0) {
      debugPrint(" ad Started");
      functionsMain.createInterstitialAd(modelSetState: setState);
    }
  }

  getResponses({required String forumId, required String type}) async {
    type == "Recent"
        ? typeNew = ""
        : type == "Most Liked"
            ? typeNew = 'like'
            : type == "Most Disliked"
                ? typeNew = 'dislike'
                : typeNew = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionForum + responses);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"forum_id": forumId, 'type': typeNew});
    var responseData = json.decode(response.body);
    _responseForums = ResponseForumsResponseModel.fromJson(responseData);
    if (_responseForums.status) {
      if (_responseForums.response.isEmpty) {
        setState(() {
          emptyBoolResponses = true;
          refreshLoader = true;
        });
      } else {
        emptyBoolResponses = false;
        for (int i = 0; i < _responseForums.response.length; i++) {
          resForumUseList.add(_responseForums.response[i].likes);
          resForumUseDisList.add(_responseForums.response[i].dislikes);
          resForumLikeList.add(_responseForums.response[i].likesCount);
          resForumDislikeList.add(_responseForums.response[i].disLikesCount);
          resForumUrlTypeList.add(_responseForums.response[i].urlType);
          resForumUrlList.add(_responseForums.response[i].url);
          resForumMyList.add(mainUserId == _responseForums.response[i].user.id);
          if (_responseForums.response[i].urlType == 'video') {
            networkUrls.add(_responseForums.response[i].url);
            playerConditions.add(false);
            playerVideoId.add(_responseForums.response[i].id);
          } else {
            networkUrls.add("a");
            playerConditions.add(false);
            playerVideoId.add(responseData["response"][i]["_id"]);
          }
        }
        for (var element in networkUrls) {
          betterPlayerList.add(
            BetterPlayer.network(
              element,
              betterPlayerConfiguration: const BetterPlayerConfiguration(
                  aspectRatio: 16 / 9,
                  fit: BoxFit.contain,
                  autoDispose: true,
                  controlsConfiguration: BetterPlayerControlsConfiguration(
                    enablePip: false,
                    enableOverflowMenu: false,
                    enablePlayPause: false,
                    enableAudioTracks: false,
                    enableMute: false,
                    enableSkips: false,
                    enableProgressText: false,
                  )),
            ).controller,
          );
        }
        setState(() {
          refreshLoader = true;
        });
      }
    }
  }

  playerFunc({required String urlLink}) async {
    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enablePip: false,
          enableOverflowMenu: false,
          enableFullscreen: true,
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
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
  }

  Future<bool> likeFunction({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
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
        link: Uri.parse('$domainLink/ForumPostDescriptionPage/$id/$type/$category/$filterId'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  addResponseFunc({
    required String category,
    required String forumId,
    required String cId,
    required String message,
    required String urlType,
    required String messageId,
    required bool selectedBool,
  }) async {
    dataNew = {
      "category": category,
      "forum_id": forumId,
      "category_id": cId,
      "message": message,
      "url_type": urlType,
      "message_id": messageId,
      // "tagged_user": taggedUser,
    };
    data = {
      "category": category,
      "forum_id": forumId,
      "category_id": cId,
      "message": message,
      // "tagged_user": taggedUser,
      "url_type": urlType,
    };
    dataUpdate = {
      "category": category,
      "forum_id": forumId,
      "category_id": cId,
      "message": message,
      //"tagged_user": taggedUser,
    };
    dataUpdateNew = {
      "category": category,
      "forum_id": forumId,
      "category_id": cId,
      "message": message,
      "message_id": messageId,
      // "tagged_user": taggedUser,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versionForum + responseAdd;
    if (selectedBool) {
      if (urlType != "") {
        var res1 = await functionsMain.sendForm(url, dataNew, {
          'file': urlType == "image"
              ? pickedImage!
              : urlType == "video"
                  ? pickedVideo!
                  : pickedFile!
        });
        if (res1.data["status"]) {
          setState(() {
            pickedImage = null;
            pickedVideo = null;
            doc = null;
            selectedPopUpUrlType = "";
            _editController.clear();
          });
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: res1.data["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        } else {
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: res1.data["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      } else {
        var response = await dioMain.post(url,
            data: dataUpdateNew,
            options: Options(
              headers: {'Authorization': mainUserToken},
            ));
        var responseData = response.data;
        if (responseData["status"]) {
          setState(() {
            pickedImage = null;
            pickedVideo = null;
            doc = null;
            selectedPopUpUrlType = "";
            _editController.clear();
          });
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: responseData["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        } else {
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: responseData["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      }
    } else {
      if (urlType != "") {
        var res1 = await functionsMain.sendForm(url, data, {
          'file': urlType == "image"
              ? pickedImage!
              : urlType == "video"
                  ? pickedVideo!
                  : pickedFile!
        });
        if (res1.data["status"]) {
          setState(() {
            pickedImage = null;
            pickedVideo = null;
            doc = null;
            selectedUrlType = "";
            _descriptionController.clear();
          });
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: res1.data["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        } else {
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: res1.data["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      } else {
        var response = await dioMain.post(url,
            data: dataUpdate,
            options: Options(
              headers: {'Authorization': mainUserToken},
            ));
        var responseData = response.data;
        if (responseData["status"]) {
          setState(() {
            pickedImage = null;
            pickedVideo = null;
            doc = null;
            selectedUrlType = "";
            _descriptionController.clear();
          });
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: responseData["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        } else {
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: responseData["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
        }
      }
    }
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
    _betterPlayerController.dispose();
    _betterPlayerController1.dispose();
    _betterPlayerController2.dispose();
    context.read<BookMarkWidgetBloc>().add(const LoadingEvent());
    context.read<BookMarkSingleWidgetBloc>().add(const BookLoadingEvent());
    for (var controller in betterPlayerList) {
      controller.dispose();
    }
    listForumsIds.clear();
    currentForumsId.value = "";
    idForumIndex.value = 0;
    forumEntry = true;
    surveyEntry = true;
    isMainLiked.clear();
    isMainDisliked.clear();
    likeMainCount.clear();
    shareMainCount.clear();
    viewMainCount.clear();
    responseMainCount.clear();
    disLikeMainCount.clear();
    super.dispose();
  }

  Widget playerScreen(urlLink) {
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
    _betterPlayerController2 = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController2.setupDataSource(dataSource);
    return BetterPlayer(
      controller: _betterPlayerController2,
    );
  }

  Widget playerScreen11({required File newUrlLink}) {
    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        controlsConfiguration: BetterPlayerControlsConfiguration(
            enableFullscreen: false,
            enablePip: false,
            enableOverflowMenu: false,
            enablePlayPause: false,
            enableQualities: false,
            enableAudioTracks: false,
            enableMute: false,
            enableSkips: false,
            enablePlaybackSpeed: false,
            enableProgressText: false,
            controlsHideTime: Duration(milliseconds: 100)));
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.file,
      newUrlLink.path,
    );
    _betterPlayerController1 = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController1.setupDataSource(dataSource);

    return BetterPlayer(
      controller: _betterPlayerController1,
    );
  }

  searchData({required String newResponseValue, required bool value, required StateSetter newSetState}) async {
    var split = newResponseValue.split('+');
    var val = split[split.length - 1];
    var url = Uri.parse(baseurl + versions + tagSearch);
    var newResponse = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'search': val});
    var newResponseData = jsonDecode(newResponse.body.toString());
    if (newResponseData["status"]) {
      searchResult.clear();
      searchLogo.clear();
      searchIdResult.clear();
      if (newResponseData["response"].length == 0) {
        newSetState(() {
          if (value) {
            showList1 = false;
          } else {
            showList = false;
          }
        });
      } else {
        for (int i = 0; i < newResponseData["response"].length; i++) {
          newSetState(() {
            if (value) {
              showList1 = true;
            } else {
              showList = true;
            }
            searchResult.add(newResponseData["response"][i]["username"]);
            searchIdResult.add(newResponseData["response"][i]["_id"]);
            if (newResponseData["response"][i].containsKey("avatar")) {
              searchLogo.add(newResponseData["response"][i]["avatar"]);
            } else {
              searchLogo.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
            }
          });
        }
      }
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: newResponseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  getValuesData({required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + getUserData);
    var newResponse = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'username': value});
    var newResponseData = jsonDecode(newResponse.body.toString());
    if (newResponseData['status'] == true) {
      if (!mounted) {
        return false;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return UserBillBoardProfilePage(userId: newResponseData['data']['_id']);
      }));
    } else {
      if (!mounted) {
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Name is not valid")));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return GestureDetector(
      onPanUpdate: (details) {
        swipeDirection = listForumsIds.length <= 1
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
            if (idForumIndex < listForumsIds.length - 1) {
              idForumIndex.value = idForumIndex.value + 1;
              currentForumsId.value = listForumsIds[idForumIndex.value];
            } else {
              idForumIndex.value = 0;
              currentForumsId.value = listForumsIds[idForumIndex.value];
            }
          });
          getAllData();
        }
        if (swipeDirection == 'right') {
          setState(() {
            if (idForumIndex > 0) {
              idForumIndex.value = idForumIndex.value - 1;
              currentForumsId.value = listForumsIds[idForumIndex.value];
            } else {
              idForumIndex.value = listForumsIds.length - 1;
              currentForumsId.value = listForumsIds[idForumIndex.value];
            }
          });
          getAllData();
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          popUpAttach = false;
          if (widget.comeFrom == 'forum') {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return ForumPage(text: finalisedCategory.toString().capitalizeFirst!);
            }));
          } else if (widget.comeFrom == 'similar') {
            Navigator.pop(context);
          } else if (widget.comeFrom == 'forumDetail') {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return DetailedForumImagePage(
                  text: finalisedCategory.toString().capitalizeFirst!,
                  tickerId: '',
                  tickerName: "",
                  fromCompare: false,
                  forumDetail: '',
                  filterId: finalisedFilterId,
                  catIdList: mainCatIdList,
                  topic: widget.topic == null ? "Latest Topics" : widget.topic!,
                  navBool: false,
                  sendUserId: '');
            }));
          } else if (widget.comeFrom == 'main') {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return const MainBottomNavigationPage(
                tType: true,
                caseNo1: 0,
                text: "",
                excIndex: 1,
                newIndex: 0,
                countryIndex: 0,
                isHomeFirstTym: false,
              );
            }));
          } else if (widget.comeFrom == 'finalCharts') {
            // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context, true);
          }
          return false;
        },
        child: Container(
          //color: const Color(0XFFFFFFFF),
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Scaffold(
              // backgroundColor: const Color(0XFFFFFFFF),
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                //backgroundColor: const Color(0XFFFFFFFF),
                backgroundColor: Theme.of(context).colorScheme.background,
                toolbarHeight: height / 9.44,
                automaticallyImplyLeading: false,
                title: Column(
                  children: [
                    SizedBox(height: height / 50.75),
                    SizedBox(
                      height: height / 15.03,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    if (widget.comeFrom == 'forum') {
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                        return ForumPage(text: finalisedCategory.toString().capitalizeFirst!);
                                      }));
                                    } else if (widget.comeFrom == 'similar') {
                                      if (!mounted) {
                                        return;
                                      }
                                      Navigator.pop(context);
                                    } else if (widget.comeFrom == 'forumDetail') {
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                        return DetailedForumImagePage(
                                            text: finalisedCategory.toString().capitalizeFirst!,
                                            tickerId: '',
                                            tickerName: "",
                                            fromCompare: false,
                                            forumDetail: '',
                                            filterId: finalisedFilterId,
                                            catIdList: mainCatIdList,
                                            topic: widget.topic == null ? "Latest Topics" : widget.topic!,
                                            navBool: false,
                                            sendUserId: '');
                                      }));
                                    } else if (widget.comeFrom == 'main') {
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                        return const MainBottomNavigationPage(
                                          tType: true,
                                          caseNo1: 0,
                                          text: "",
                                          excIndex: 1,
                                          newIndex: 0,
                                          countryIndex: 0,
                                          isHomeFirstTym: false,
                                        );
                                      }));
                                    } else if (widget.comeFrom == 'finalCharts') {
                                      //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                                      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                                      Navigator.pop(context, true);
                                    } else {
                                      Navigator.pop(context, true);
                                    }
                                    //Navigator.pop(context,true);
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    size: 30,
                                  )),
                              Text(
                                "Forum",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge /*TextStyle(fontSize: text.scale(26), color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins")*/,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return const NotificationsPage();
                                    }));
                                    if (response) {
                                      await functionsMain.getNotifyCount();
                                      setState(() {});
                                    }
                                  },
                                  child: widgetsMain.getNotifyBadge(context: context)),
                              SizedBox(
                                width: width / 23.43,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return mainSkipValue ? const SettingsSkipView() : const SettingsView();
                                    }));
                                  },
                                  child: widgetsMain.getProfileImage(context: context, isLogged: mainSkipValue)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height / 50.75),
                  ],
                ),
                elevation: 1.0,
                //shadowColor: Colors.white54,
              ),
              body: refreshLoader
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: height,
                          child: SingleChildScrollView(
                            child: Container(
                              color: Theme.of(context).colorScheme.background,
                              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: height / 33.83,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)],
                                          color: Theme.of(context).colorScheme.background,
                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      padding: EdgeInsets.symmetric(horizontal: width / 23.43),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        SizedBox(
                                          height: height / 36.90,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: width / 1.4,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return UserBillBoardProfilePage(userId: _forumsResponse.response.user.id);
                                                      }));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                              image: NetworkImage(_forumsResponse.response.user.avatar),
                                                              //forumObject["user"]["avatar"],
                                                              fit: BoxFit.fill)),
                                                      width: width / 6.69,
                                                      height: height / 14.5,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 23.43,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: width / 1.92,
                                                        child: Text(
                                                          titleMain,
                                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16)),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return UserBillBoardProfilePage(userId: _forumsResponse.response.user.id);
                                                          }));
                                                        },
                                                        child: Text(
                                                          _forumsResponse.response.user.username,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500, fontSize: text.scale(10), color: const Color(0XFFA5A5A5)),
                                                        ),
                                                      ),
                                                      Text(
                                                        _forumsResponse.response.createdAt,
                                                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 8, color: Color(0XFFB0B0B0)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
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
                                                          child: mainUserId == _forumsResponse.response.user.id //forumObject["user"]["_id"]
                                                              ? Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    ListTile(
                                                                      onTap: () async {
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.pop(context);
                                                                        bool response = await Navigator.push(context,
                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                          return ForumPostEditPage(
                                                                              text: finalisedCategory.toString().capitalizeFirst!,
                                                                              catIdList: mainCatIdList,
                                                                              filterId: finalisedFilterId,
                                                                              forumId: _forumsResponse.response.id);
                                                                        }));
                                                                        if (response) {
                                                                          await getIdData(id: currentForumsId.value, type: "forums");
                                                                        }
                                                                      },
                                                                      minLeadingWidth: width / 25,
                                                                      leading: const Icon(
                                                                        Icons.edit,
                                                                        size: 20,
                                                                      ),
                                                                      title: Text(
                                                                        "Edit Post",
                                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      color: Theme.of(context).colorScheme.tertiary,
                                                                      thickness: 0.8,
                                                                    ),
                                                                    ListTile(
                                                                      onTap: () {
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.pop(context);
                                                                        showDialog(
                                                                            barrierDismissible: false,
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              return Dialog(
                                                                                shape:
                                                                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                                child: Container(
                                                                                  height: height / 6,
                                                                                  margin: EdgeInsets.symmetric(
                                                                                      vertical: height / 54.13, horizontal: width / 25),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      const Center(
                                                                                          child: Text("Delete Post",
                                                                                              style: TextStyle(
                                                                                                  color: Color(0XFF0EA102),
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                  fontSize: 20,
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
                                                                                                if (!mounted) {
                                                                                                  return;
                                                                                                }
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: const Text(
                                                                                                "Cancel",
                                                                                                style: TextStyle(
                                                                                                    color: Colors.grey,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontFamily: "Poppins",
                                                                                                    fontSize: 15),
                                                                                              ),
                                                                                            ),
                                                                                            ElevatedButton(
                                                                                              style: ElevatedButton.styleFrom(
                                                                                                shape: RoundedRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(18.0),
                                                                                                ),
                                                                                                backgroundColor: Colors.green,
                                                                                              ),
                                                                                              onPressed: () async {
                                                                                                if (!mounted) {
                                                                                                  return;
                                                                                                }
                                                                                                Navigator.pop(context);
                                                                                                await deletePost(
                                                                                                  forumId: _forumsResponse.response.id,
                                                                                                  similarNew: false,
                                                                                                );
                                                                                                await getResponses(
                                                                                                    forumId: _forumsResponse.response.id,
                                                                                                    type: selectedValue);
                                                                                              },
                                                                                              child: const Text(
                                                                                                "Continue",
                                                                                                style: TextStyle(
                                                                                                    color: Colors.white,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    fontFamily: "Poppins",
                                                                                                    fontSize: 15),
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
                                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : Column(
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
                                                                        showAlertDialog(
                                                                            context: context,
                                                                            forumId: _forumsResponse.response.id,
                                                                            forumUserId: _forumsResponse.response.user.id,
                                                                            messageId: "",
                                                                            checkWhich: '');
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
                                                                    Divider(
                                                                      color: Theme.of(context).colorScheme.tertiary,
                                                                      thickness: 0.8,
                                                                    ),
                                                                    ListTile(
                                                                      onTap: () async {
                                                                        _controller.clear();
                                                                        setState(() {
                                                                          actionValue = "Block";
                                                                        });
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        Navigator.pop(context);
                                                                        showAlertDialog(
                                                                            context: context,
                                                                            forumId: _forumsResponse.response.id,
                                                                            forumUserId: _forumsResponse.response.user.id,
                                                                            messageId: "",
                                                                            checkWhich: '');
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
                                              },
                                              child: const Icon(
                                                Icons.more_horiz,
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height / 50.75,
                                        ),
                                        Text(
                                          descriptionMain, //_forumsResponse.response.description,
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400),
                                        ),
                                        SizedBox(
                                          height: height / 50.75,
                                        ),
                                        _forumsResponse.response.urlType == ""
                                            ? const SizedBox(
                                                height: 10,
                                              )
                                            : Row(
                                                mainAxisAlignment: _forumsResponse.response.urlType == "document"
                                                    ? MainAxisAlignment.start
                                                    : MainAxisAlignment.center,
                                                children: [
                                                  _forumsResponse.response.urlType == ""
                                                      ? const SizedBox()
                                                      : _forumsResponse.response.urlType == "image"
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return FullScreenImage(
                                                                    imageUrl: _forumsResponse.response.url,
                                                                    tag: "generate_a_unique_tag",
                                                                  );
                                                                }));
                                                              },
                                                              child: SizedBox(
                                                                  height: height / 4,
                                                                  width: width / 1.25,
                                                                  child: Image.network(
                                                                    _forumsResponse.response.url,
                                                                    fit: BoxFit.cover,
                                                                  )),
                                                            )
                                                          : _forumsResponse.response.urlType == "video"
                                                              ? SizedBox(
                                                                  width: width / 1.25,
                                                                  child: BetterPlayer(controller: _betterPlayerController),
                                                                )
                                                              : _forumsResponse.response.urlType == "document"
                                                                  ? Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute<dynamic>(
                                                                                builder: (_) => PDFViewerFromUrl(
                                                                                  url: _forumsResponse.response.url,
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child: Row(
                                                                            children: [
                                                                              Container(
                                                                                padding: const EdgeInsets.all(10),
                                                                                decoration: BoxDecoration(
                                                                                    border:
                                                                                        Border.all(color: const Color(0xffD8D8D8).withOpacity(0.5))),
                                                                                child: Text(
                                                                                  _forumsResponse.response.url.split('/').last.toString(),
                                                                                  style: const TextStyle(color: Colors.black, fontSize: 13),
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
                                                                        const SizedBox(
                                                                          height: 10,
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : const SizedBox(),
                                                ],
                                              ),
                                        SizedBox(
                                          height: height / 50.75,
                                        ),
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  bool response1 = await likeFunction(id: _forumsResponse.response.id, type: "forums");
                                                  if (response1) {
                                                    logEventFunc(name: "Likes", type: "Forum");
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
                                                child: SizedBox(
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
                                                      id: _forumsResponse.response.id,
                                                      type: "forums",
                                                      description: '',
                                                      imageUrl: "",
                                                      title: _forumsResponse.response.title,
                                                      category: finalisedCategory.toString().capitalizeFirst!,
                                                      filterId: finalisedFilterId);
                                                  ShareResult result = await Share.share(
                                                    "Look what I was able to find on Tradewatch: ${_forumsResponse.response.title} ${newLink.toString()}",
                                                  );
                                                  if (result.status == ShareResultStatus.success) {
                                                    setState(() {
                                                      shareCount += 1;
                                                    });
                                                    await shareFunction(id: _forumsResponse.response.id, type: "forums");
                                                  }
                                                },
                                                child: SizedBox(
                                                    height: height / 40.6,
                                                    width: width / 18.75,
                                                    child: SvgPicture.asset(
                                                      isDarkTheme.value
                                                          ? "assets/home_screen/share_dark.svg"
                                                          : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                    )),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  bool response3 = await disLikeFunction(id: _forumsResponse.response.id, type: "forums");
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
                                                child: SizedBox(
                                                  height: height / 40.6,
                                                  width: width / 18.75,
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
                                              GestureDetector(
                                                onTap: () {
                                                  textFocusNode.requestFocus();
                                                },
                                                child: SvgPicture.asset(
                                                  "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                  colorFilter: ColorFilter.mode(
                                                      isDarkTheme.value ? const Color(0XFFD6D6D6) : const Color(0XFF0EA102), BlendMode.srcIn),
                                                  height: height / 40.6,
                                                  width: width / 18.75,
                                                ),
                                              ),
                                              bookMarkWidgetSingle(
                                                  bookMark: [_forumsResponse.response.bookmark],
                                                  id: _forumsResponse.response.id,
                                                  type: 'forums',
                                                  context: context,
                                                  scale: 3.2,
                                                  modelSetState: setState,
                                                  index: 0),
                                              widgetsMain.translationWidgetSingle(
                                                translation: false,
                                                id: _forumsResponse.response.id,
                                                type: 'forums',
                                                index: 0,
                                                initFunction: getAllData,
                                                context: context,
                                                modelSetState: setState,
                                                notUse: false,
                                                color: Colors.black,
                                                title: titleMain,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 50.75,
                                        ),
                                        SizedBox(
                                          height: height / 54.13,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: width / 7.5,
                                                child: Text(_forumsResponse.response.companyName,
                                                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700, color: Colors.blue)),
                                              ),
                                              SizedBox(width: width / 37.5),
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    kUserSearchController.clear();
                                                    onTapType = "Views";
                                                    onTapId = _forumsResponse.response.id;
                                                    onLike = false;
                                                    onDislike = false;
                                                    onViews = true;
                                                    idKeyMain = "forum_id";
                                                    apiMain = baseurl + versionForum + viewsCount;
                                                    onTapIdMain = _forumsResponse.response.id;
                                                    onTapTypeMain = "Views";
                                                    haveLikesMain = likeCount > 0 ? true : false;
                                                    haveDisLikesMain = disLikeCount > 0 ? true : false;
                                                    haveViewsMain = viewCount > 0 ? true : false;
                                                    likesCountMain = likeCount;
                                                    dislikesCountMain = disLikeCount;
                                                    viewCountMain = viewCount;
                                                    kToken = mainUserToken;
                                                    loaderMain = false;
                                                  });
                                                  await customShowSheetNew2(
                                                    context: context,
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(viewCount.toString(),
                                                        style: TextStyle(
                                                            fontSize: text.scale(8), fontWeight: FontWeight.w700, color: const Color(0XFFB0B0B0))),
                                                    Text(" views",
                                                        style: TextStyle(
                                                            fontSize: text.scale(8), fontWeight: FontWeight.w500, color: const Color(0XFFB0B0B0))),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: width / 37.5),
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    kUserSearchController.clear();
                                                    onTapType = "liked";
                                                    onTapId = _forumsResponse.response.id;
                                                    onLike = true;
                                                    onDislike = false;
                                                    onViews = false;
                                                    idKeyMain = "forum_id";
                                                    apiMain = baseurl + versionForum + likeDislikeUsers;
                                                    onTapIdMain = _forumsResponse.response.id;
                                                    onTapTypeMain = "liked";
                                                    haveLikesMain = likeCount > 0 ? true : false;
                                                    haveDisLikesMain = disLikeCount > 0 ? true : false;
                                                    haveViewsMain = viewCount > 0 ? true : false;
                                                    likesCountMain = likeCount;
                                                    dislikesCountMain = disLikeCount;
                                                    viewCountMain = viewCount;
                                                    kToken = mainUserToken;
                                                    loaderMain = false;
                                                  });
                                                  await customShowSheetNew2(
                                                    context: context,
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(likeCount.toString(),
                                                        style: TextStyle(
                                                            fontSize: text.scale(8), fontWeight: FontWeight.w700, color: const Color(0XFFB0B0B0))),
                                                    Text(
                                                      " Likes",
                                                      style: TextStyle(
                                                          fontSize: text.scale(8), fontWeight: FontWeight.w500, color: const Color(0XFFB0B0B0)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: width / 37.5),
                                              GestureDetector(
                                                onTap: () {
                                                  Flushbar(
                                                    message: "Shares not visible due to privacy",
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(shareCount.toString(),
                                                        style: TextStyle(
                                                            fontSize: text.scale(8), fontWeight: FontWeight.w700, color: const Color(0XFFB0B0B0))),
                                                    Text(
                                                      " Shares",
                                                      style: TextStyle(
                                                          fontSize: text.scale(8), fontWeight: FontWeight.w500, color: const Color(0XFFB0B0B0)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: width / 37.5),
                                              GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    kUserSearchController.clear();
                                                    onTapType = "disliked";
                                                    onTapId = _forumsResponse.response.id;
                                                    onLike = false;
                                                    onDislike = true;
                                                    onViews = false;
                                                    idKeyMain = "forum_id";
                                                    apiMain = baseurl + versionForum + likeDislikeUsers;
                                                    onTapIdMain = _forumsResponse.response.id;
                                                    onTapTypeMain = "disliked";
                                                    haveLikesMain = likeCount > 0 ? true : false;
                                                    haveDisLikesMain = disLikeCount > 0 ? true : false;
                                                    haveViewsMain = viewCount > 0 ? true : false;
                                                    likesCountMain = likeCount;
                                                    dislikesCountMain = disLikeCount;
                                                    viewCountMain = viewCount;
                                                    kToken = mainUserToken;
                                                    loaderMain = false;
                                                  });
                                                  await customShowSheetNew2(
                                                    context: context,
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(disLikeCount.toString(),
                                                        style: TextStyle(
                                                            fontSize: text.scale(8), fontWeight: FontWeight.w700, color: const Color(0XFFB0B0B0))),
                                                    Text(
                                                      " Dislikes",
                                                      style: TextStyle(
                                                          fontSize: text.scale(8), fontWeight: FontWeight.w500, color: const Color(0XFFB0B0B0)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: width / 37.5),
                                              Text(responseCount.toString(),
                                                  style: TextStyle(
                                                      fontSize: text.scale(8), fontWeight: FontWeight.w700, color: const Color(0XFFB0B0B0))),
                                              Text(
                                                " Responses",
                                                style:
                                                    TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500, color: const Color(0XFFB0B0B0)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: height / 36.90,
                                        ),
                                      ])),
                                  SizedBox(
                                    height: height / 29,
                                  ),
                                  showList
                                      ? showLoader
                                          ? const SizedBox()
                                          : Container(
                                              margin: const EdgeInsets.only(
                                                left: 70,
                                              ),
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background,
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                                boxShadow: [BoxShadow(spreadRadius: 0, blurRadius: 4, color: Theme.of(context).colorScheme.tertiary)],
                                              ),
                                              child: ListView.builder(
                                                  itemCount: searchResult.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Container(
                                                      height: 35,
                                                      margin: index == searchResult.length - 1
                                                          ? const EdgeInsets.only(bottom: 15)
                                                          : const EdgeInsets.all(0),
                                                      child: ListTile(
                                                        onTap: () {
                                                          setState(() {
                                                            showList = false;
                                                            splitOne = _descriptionController.text.split("+");
                                                            searchUserId = searchIdResult[index];
                                                          });
                                                          String controllerText = "";
                                                          for (int i = 0; i < splitOne.length; i++) {
                                                            if (splitOne.length <= 2) {
                                                              if (i != splitOne.length - 1) {
                                                                setState(() {
                                                                  controllerText = "$controllerText ${splitOne[i]}";
                                                                  showList = false;
                                                                });
                                                              } else {
                                                                _descriptionController.text = "$controllerText +${searchResult[index]} ";
                                                                _descriptionController.selection = TextSelection.fromPosition(
                                                                    TextPosition(offset: _descriptionController.text.length));
                                                                setState(() {
                                                                  showList = false;
                                                                });
                                                              }
                                                            } else {
                                                              if (i == 0) {
                                                                setState(() {
                                                                  controllerText = "$controllerText ${splitOne[i]}";
                                                                  showList = false;
                                                                });
                                                              } else if (i != splitOne.length - 1) {
                                                                setState(() {
                                                                  controllerText = "$controllerText +${splitOne[i]}";
                                                                  showList = false;
                                                                });
                                                              } else {
                                                                _descriptionController.text = "$controllerText +${searchResult[index]} ";
                                                                _descriptionController.selection = TextSelection.fromPosition(
                                                                    TextPosition(offset: _descriptionController.text.length));
                                                                setState(() {
                                                                  showList = false;
                                                                });
                                                              }
                                                            }
                                                          }
                                                          setState(() {
                                                            showList = false;
                                                          });
                                                        },
                                                        title: Text(
                                                          searchResult[index],
                                                          style:
                                                              TextStyle(fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                                                        ),
                                                        trailing: CircleAvatar(
                                                          backgroundImage: NetworkImage(
                                                            searchLogo[index],
                                                          ),
                                                          radius: 15,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            )
                                      : const SizedBox(),
                                  Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)],
                                        color: Theme.of(context).colorScheme.background,
                                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height / 47.76,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return UserBillBoardProfilePage(userId: mainUserId);
                                                }));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(avatar), fit: BoxFit.fill)),
                                                margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                height: height / 20.3,
                                                width: width / 8.93,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      border: Border.all(color: Colors.transparent),
                                                      color: Theme.of(context).colorScheme.background,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Theme.of(context).colorScheme.tertiary /*Colors.grey.withOpacity(0.1)*/,
                                                            blurRadius: 4,
                                                            spreadRadius: 0)
                                                      ]),
                                                  width: width / 1.5,
                                                  height: height / 9.90,
                                                  margin: EdgeInsets.only(right: width / 34.25),
                                                  child: TextFormField(
                                                    focusNode: textFocusNode,
                                                    onChanged: (value) {
                                                      if (value.isNotEmpty) {
                                                        setState(() {
                                                          newResponseValue = value.trim();
                                                          if (newResponseValue.isNotEmpty) {
                                                            textCount = newResponseValue.length;
                                                            messageText = newResponseValue;
                                                            if (messageText.startsWith("+")) {
                                                              if (messageText.substring(messageText.length - 1) == '+') {
                                                                setState(() {
                                                                  showList = true;
                                                                  showLoader = true;
                                                                });
                                                              } else {
                                                                if (showList) {
                                                                  searchData(newResponseValue: newResponseValue, value: false, newSetState: setState);
                                                                  setState(() {
                                                                    showLoader = false;
                                                                  });
                                                                } else {
                                                                  searchData(newResponseValue: newResponseValue, value: false, newSetState: setState);
                                                                }
                                                              }
                                                            } else {
                                                              if (messageText.contains(" +")) {
                                                                if (messageText.substring(messageText.length - 1) == '+') {
                                                                  setState(() {
                                                                    showList = true;
                                                                    showLoader = true;
                                                                  });
                                                                } else {
                                                                  if (showList) {
                                                                    searchData(
                                                                        newResponseValue: newResponseValue, value: false, newSetState: setState);
                                                                    setState(() {
                                                                      showLoader = false;
                                                                    });
                                                                  } else {
                                                                    searchData(
                                                                        newResponseValue: newResponseValue, value: false, newSetState: setState);
                                                                  }
                                                                }
                                                              } else {
                                                                setState(() {
                                                                  showList = false;
                                                                  showLoader = true;
                                                                });
                                                              }
                                                            }
                                                          }
                                                        });
                                                      } else if (value.isEmpty) {
                                                        setState(() {
                                                          showList = false;
                                                          newResponseValue = value;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          showList = false;
                                                          newResponseValue = value;
                                                        });
                                                      }
                                                    },
                                                    style: TextStyle(
                                                        color: const Color(0XFFB0B0B0),
                                                        fontSize: text.scale(12),
                                                        fontFamily: "Poppins",
                                                        fontWeight: FontWeight.w400),
                                                    controller: _descriptionController,
                                                    keyboardType: TextInputType.name,
                                                    maxLines: 4,
                                                    minLines: 3,
                                                    decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 81.2),
                                                        focusedBorder: InputBorder.none,
                                                        enabledBorder: InputBorder.none,
                                                        hintText: "Enter a description...",
                                                        hintStyle: TextStyle(
                                                            color: const Color(0XFFB0B0B0),
                                                            fontSize: text.scale(12),
                                                            fontFamily: "Poppins",
                                                            fontWeight: FontWeight.w400)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            (pickedImage == null && pickedVideo == null && pickedFile == null)
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      showSheet();
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: width / 5),
                                                      child: Image.asset(
                                                        "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                                                        height: height / 32.48,
                                                        width: width / 15,
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
                                                                  : Row(
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
                                                            ],
                                                          ),
                                                  ),
                                            responseLoader
                                                ? Container(
                                                    margin: const EdgeInsets.only(right: 15),
                                                    height: 20,
                                                    width: 20,
                                                    child: const CircularProgressIndicator(
                                                      color: Color(0XFF0EA102),
                                                      strokeWidth: 2,
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () async {
                                                      logEventFunc(name: 'Responses', type: "Forum");
                                                      setState(() {
                                                        responseLoader = true;
                                                      });
                                                      await addResponseFunc(
                                                          urlType: selectedUrlType,
                                                          forumId: _forumsResponse.response.id,
                                                          category: finalisedCategory.toLowerCase(),
                                                          cId: finalisedCategory.toString().capitalizeFirst! == "Stocks"
                                                              ? mainCatIdList[0]
                                                              : finalisedCategory.toString().capitalizeFirst! == "Crypto"
                                                                  ? mainCatIdList[1]
                                                                  : finalisedCategory.toString().capitalizeFirst! == "Commodity"
                                                                      ? mainCatIdList[2]
                                                                      : finalisedCategory.toString().capitalizeFirst! == "Forex"
                                                                          ? mainCatIdList[3]
                                                                          : "",
                                                          message: _descriptionController.text,
                                                          // taggedUser: searchUserId,
                                                          messageId: "",
                                                          selectedBool: false);
                                                      await getResponses(forumId: _forumsResponse.response.id, type: selectedValue);
                                                      addedTags.clear();
                                                      setState(() {
                                                        responseLoader = false;
                                                        showList = false;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: height / 28.14,
                                                      width: width / 4.76,
                                                      margin: const EdgeInsets.only(right: 15),
                                                      decoration:
                                                          BoxDecoration(color: const Color(0XFF0EA102), borderRadius: BorderRadius.circular(5)),
                                                      child: Center(
                                                        child: Text(
                                                          "Respond",
                                                          style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w600, color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                          ],
                                        ),
                                        SizedBox(
                                          height: height / 47.76,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Response order",
                                        style: TextStyle(fontSize: text.scale(10), color: const Color(0XFFB0B0B0)),
                                      ),
                                      SizedBox(
                                        width: width / 53.57,
                                      ),
                                      Icon(Icons.access_time, size: width / 37.5, color: Theme.of(context).colorScheme.onPrimary),
                                      SizedBox(
                                        width: width / 75,
                                      ),
                                      SizedBox(
                                        width: width / 3.40,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            isExpanded: true,
                                            isDense: true,
                                            items: _choose
                                                .map((item) => DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(
                                                        item,
                                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                      ),
                                                    ))
                                                .toList(),
                                            value: selectedValue,
                                            onChanged: (String? value) async {
                                              setState(() {
                                                selectedValue = value!;
                                              });
                                              getResponses(forumId: _forumsResponse.response.id, type: selectedValue);
                                            },
                                            iconStyleData: IconStyleData(
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),
                                                iconSize: 12,
                                                iconEnabledColor: Theme.of(context).colorScheme.onPrimary,
                                                iconDisabledColor: Theme.of(context).colorScheme.onPrimary),
                                            buttonStyleData: const ButtonStyleData(height: 50, width: 125, elevation: 0),
                                            menuItemStyleData: const MenuItemStyleData(height: 40),
                                            dropdownStyleData: DropdownStyleData(
                                                maxHeight: 200,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    color: Theme.of(context).colorScheme.background,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Theme.of(context).colorScheme.tertiary,
                                                        blurRadius: 4,
                                                        spreadRadius: 0,
                                                      )
                                                    ]),
                                                elevation: 8,
                                                offset: const Offset(-20, 0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  emptyBoolResponses
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 33.83,
                                        ),
                                  emptyBoolResponses
                                      ? Center(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                  height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                              SizedBox(
                                                height: height / 86.6,
                                              ),
                                              RichText(
                                                text: const TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text: 'No response to display...',
                                                        style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: _responseForums.response.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              margin: EdgeInsets.only(bottom: height / 35),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background,
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4, spreadRadius: 0)
                                                  ]),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: height / 47.9,
                                                  ),
                                                  Container(
                                                    color: Theme.of(context).colorScheme.background,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                await checkUser(
                                                                    uId: _responseForums.response[index].user.id,
                                                                    uType: 'forums',
                                                                    mainUserToken: mainUserToken,
                                                                    context: context,
                                                                    index: 0);
                                                              },
                                                              child: Container(
                                                                height: height / 20.3,
                                                                width: width / 9.35,
                                                                margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.grey,
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(_responseForums.response[index].user.avatar),
                                                                        fit: BoxFit.fill)),
                                                              ),
                                                            ),
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () async {
                                                                    await checkUser(
                                                                        uId: _responseForums.response[index].user.id,
                                                                        uType: 'forums',
                                                                        mainUserToken: mainUserToken,
                                                                        context: context,
                                                                        index: 0);
                                                                  },
                                                                  child: SizedBox(
                                                                      height: height / 54.13,
                                                                      child: Text(
                                                                        _responseForums.response[index].user.username.toString().capitalizeFirst!,
                                                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600),
                                                                      )),
                                                                ),
                                                                SizedBox(
                                                                  width: width / 1.7,
                                                                  child: Text(
                                                                    _responseForums.response[index].createdAt,
                                                                    textAlign: TextAlign.justify,
                                                                    style: TextStyle(fontSize: text.scale(7), fontWeight: FontWeight.w400),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: height / 50.75,
                                                                ),
                                                                SizedBox(
                                                                  width: width / 1.7,
                                                                  child: RichText(
                                                                    textAlign: TextAlign.justify,
                                                                    text: TextSpan(
                                                                        children: spanList(
                                                                      message: _responseForums.response[index].message,
                                                                      context: context,
                                                                    )),
                                                                  ),
                                                                ),
                                                                _responseForums.response[index].urlType == ""
                                                                    ? const SizedBox()
                                                                    : Row(
                                                                        mainAxisAlignment: _responseForums.response[index].urlType == "document"
                                                                            ? MainAxisAlignment.start
                                                                            : MainAxisAlignment.center,
                                                                        children: [
                                                                          _responseForums.response[index].urlType == ""
                                                                              ? const SizedBox()
                                                                              : _responseForums.response[index].urlType == "image"
                                                                                  ? GestureDetector(
                                                                                      onTap: () {
                                                                                        Navigator.push(context,
                                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                                          return FullScreenImage(
                                                                                              imageUrl: _responseForums.response[index].url,
                                                                                              tag: "generate_a_unique_tag");
                                                                                        }));
                                                                                      },
                                                                                      child: Container(
                                                                                          padding: const EdgeInsets.only(top: 8, right: 5),
                                                                                          height: height / 6.76,
                                                                                          width: width / 3.12,
                                                                                          child: Image.network(
                                                                                            _responseForums.response[index].url,
                                                                                            fit: BoxFit.fill,
                                                                                          )),
                                                                                    )
                                                                                  : _responseForums.response[index].urlType == "video"
                                                                                      ? SizedBox(
                                                                                          width: width / 1.7,
                                                                                          child: Stack(
                                                                                            alignment: Alignment.center,
                                                                                            children: [
                                                                                              BetterPlayer(
                                                                                                controller: betterPlayerList[index],
                                                                                              ),
                                                                                              GestureDetector(
                                                                                                  onTap: () {
                                                                                                    for (int i = 0; i < networkUrls.length; i++) {
                                                                                                      if (index == i) {
                                                                                                        if (betterPlayerList[i].isPlaying() == true) {
                                                                                                          betterPlayerList[i].pause();
                                                                                                        } else if (betterPlayerList[i]
                                                                                                                .videoPlayerController
                                                                                                                ?.value
                                                                                                                .duration ==
                                                                                                            betterPlayerList[i]
                                                                                                                .videoPlayerController
                                                                                                                ?.value
                                                                                                                .position) {
                                                                                                          betterPlayerList[i]
                                                                                                              .seekTo(const Duration(seconds: 0));
                                                                                                        } else {
                                                                                                          betterPlayerList[index].play();
                                                                                                        }
                                                                                                      } else {
                                                                                                        betterPlayerList[i].pause();
                                                                                                        betterPlayerList[i]
                                                                                                            .seekTo(const Duration(seconds: 0));
                                                                                                      }
                                                                                                    }
                                                                                                  },
                                                                                                  child: const Center(
                                                                                                      child: Icon(
                                                                                                    Icons.play_circle_fill_rounded,
                                                                                                    color: Colors.transparent,
                                                                                                    size: 30,
                                                                                                  )))
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      : _responseForums.response[index].urlType == "document"
                                                                                          ? Column(
                                                                                              children: [
                                                                                                const SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                                GestureDetector(
                                                                                                  onTap: () {
                                                                                                    Navigator.push(
                                                                                                      context,
                                                                                                      MaterialPageRoute<dynamic>(
                                                                                                        builder: (_) => PDFViewerFromUrl(
                                                                                                          url: _responseForums.response[index].url,
                                                                                                        ),
                                                                                                      ),
                                                                                                    );
                                                                                                  },
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Container(
                                                                                                        padding: const EdgeInsets.all(10),
                                                                                                        decoration: BoxDecoration(
                                                                                                            border: Border.all(
                                                                                                                color: const Color(0xffD8D8D8)
                                                                                                                    .withOpacity(0.5))),
                                                                                                        child: Text(
                                                                                                          _responseForums.response[index].url
                                                                                                              .split('/')
                                                                                                              .last
                                                                                                              .toString(),
                                                                                                          style: const TextStyle(
                                                                                                              color: Colors.black, fontSize: 13),
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
                                                                                                const SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                              ],
                                                                                            )
                                                                                          : const SizedBox(),
                                                                        ],
                                                                      ),
                                                                SizedBox(
                                                                  height: height / 54.13,
                                                                ),
                                                                SizedBox(
                                                                  height: height / 45.11,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () async {
                                                                          bool response1 = await likeFunction(
                                                                              id: _responseForums.response[index].id, type: "forum response");
                                                                          if (response1) {
                                                                            logEventFunc(name: "Likes", type: "Forum Responses");
                                                                            setState(() {
                                                                              if (resForumUseList[index] == true) {
                                                                                if (resForumUseDisList[index] == true) {
                                                                                } else {
                                                                                  resForumLikeList[index] -= 1;
                                                                                }
                                                                              } else {
                                                                                if (resForumUseDisList[index] == true) {
                                                                                  resForumDislikeList[index] -= 1;
                                                                                  resForumLikeList[index] += 1;
                                                                                } else {
                                                                                  resForumLikeList[index] += 1;
                                                                                }
                                                                              }
                                                                              resForumUseList[index] = !resForumUseList[index];
                                                                              resForumUseDisList[index] = false;
                                                                            });
                                                                          } else {}
                                                                        },
                                                                        child: Container(
                                                                          margin: EdgeInsets.only(right: width / 25),
                                                                          height: height / 40.6,
                                                                          width: width / 18.75,
                                                                          child: resForumUseList[index]
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
                                                                          bool response3 = await disLikeFunction(
                                                                              id: _responseForums.response[index].id, type: "forum response");
                                                                          if (response3) {
                                                                            logEventFunc(name: "Dislikes", type: "Forum Responses");
                                                                            setState(() {
                                                                              if (resForumUseDisList[index] == true) {
                                                                                if (resForumUseList[index] == true) {
                                                                                } else {
                                                                                  resForumDislikeList[index] -= 1;
                                                                                }
                                                                              } else {
                                                                                if (resForumUseList[index] == true) {
                                                                                  resForumLikeList[index] -= 1;
                                                                                  resForumDislikeList[index] += 1;
                                                                                } else {
                                                                                  resForumDislikeList[index] += 1;
                                                                                }
                                                                              }
                                                                              resForumUseDisList[index] = !resForumUseDisList[index];
                                                                              resForumUseList[index] = false;
                                                                            });
                                                                          } else {}
                                                                        },
                                                                        child: Container(
                                                                          height: height / 40.6,
                                                                          width: width / 18.75,
                                                                          margin: EdgeInsets.only(right: width / 25),
                                                                          child: resForumUseDisList[index]
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
                                                                ),
                                                                SizedBox(
                                                                  height: height / 81.2,
                                                                ),
                                                                SizedBox(
                                                                  height: height / 54.13,
                                                                  child: Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap: () async {
                                                                          setState(() {
                                                                            kUserSearchController.clear();
                                                                            onTapType = "liked";
                                                                            onTapId = _responseForums.response[index].id;
                                                                            onLike = true;
                                                                            onDislike = false;
                                                                            idKeyMain = "response_id";
                                                                            apiMain = baseurl + versionForum + responseLikeDislikeCount;
                                                                            onTapIdMain = _responseForums.response[index].id;
                                                                            onTapTypeMain = "liked";
                                                                            haveLikesMain = resForumLikeList[index] > 0 ? true : false;
                                                                            haveDisLikesMain = resForumDislikeList[index] > 0 ? true : false;
                                                                            likesCountMain = resForumLikeList[index];
                                                                            dislikesCountMain = resForumDislikeList[index];
                                                                            kToken = mainUserToken;
                                                                            loaderMain = false;
                                                                          });
                                                                          await customShowSheetNew3(
                                                                            context: context,
                                                                            responseCheck: 'forum',
                                                                          );
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Text(resForumLikeList[index].toString(),
                                                                                style: TextStyle(
                                                                                    fontSize: text.scale(8),
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: const Color(0XFFB0B0B0))),
                                                                            Text(" Likes",
                                                                                style: TextStyle(
                                                                                    fontSize: text.scale(8),
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: const Color(0XFFB0B0B0))),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(width: width / 22.05),
                                                                      InkWell(
                                                                        onTap: () async {
                                                                          setState(() {
                                                                            kUserSearchController.clear();
                                                                            onTapType = "disliked";
                                                                            onTapId = _responseForums.response[index].id;
                                                                            onLike = false;
                                                                            onDislike = true;
                                                                            idKeyMain = "response_id";
                                                                            apiMain = baseurl + versionForum + responseLikeDislikeCount;
                                                                            onTapIdMain = _responseForums.response[index].id;
                                                                            onTapTypeMain = "disliked";
                                                                            haveLikesMain = resForumLikeList[index] > 0 ? true : false;
                                                                            haveDisLikesMain = resForumDislikeList[index] > 0 ? true : false;
                                                                            likesCountMain = resForumLikeList[index];
                                                                            dislikesCountMain = resForumDislikeList[index];
                                                                            kToken = mainUserToken;
                                                                            loaderMain = false;
                                                                          });
                                                                          await customShowSheetNew3(
                                                                            context: context,
                                                                            responseCheck: "forum",
                                                                          );
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Text(resForumDislikeList[index].toString(),
                                                                                style: TextStyle(
                                                                                    fontSize: text.scale(8),
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: const Color(0XFFB0B0B0))),
                                                                            Text(" DisLikes",
                                                                                style: TextStyle(
                                                                                    fontSize: text.scale(8),
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: const Color(0XFFB0B0B0))),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        _forumsResponse.response.user.id == mainUserId || resForumMyList[index] == true
                                                            ? GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
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
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                            child: resForumMyList[index]
                                                                                ? Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      ListTile(
                                                                                        onTap: () {
                                                                                          if (!mounted) {
                                                                                            return;
                                                                                          }
                                                                                          Navigator.pop(context);
                                                                                          editMessage(messageId: _responseForums.response[index].id);
                                                                                          showAlertDialog11(
                                                                                              context: context,
                                                                                              url: resForumUrlList[index],
                                                                                              urlType: resForumUrlTypeList[index],
                                                                                              message: _responseForums.response[index].message,
                                                                                              messageId: _responseForums.response[index].id);
                                                                                        },
                                                                                        minLeadingWidth: width / 25,
                                                                                        leading: const Icon(
                                                                                          Icons.edit,
                                                                                          size: 20,
                                                                                        ),
                                                                                        title: Text(
                                                                                          "Edit",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                                        ),
                                                                                      ),
                                                                                      Divider(
                                                                                        color: Theme.of(context).colorScheme.tertiary,
                                                                                        thickness: 0.8,
                                                                                      ),
                                                                                      ListTile(
                                                                                        onTap: () async {
                                                                                          if (!mounted) {
                                                                                            return;
                                                                                          }
                                                                                          Navigator.pop(context);
                                                                                          showDialog(
                                                                                              barrierDismissible: false,
                                                                                              context: context,
                                                                                              builder: (BuildContext context) {
                                                                                                return Dialog(
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                      borderRadius: BorderRadius.circular(20.0)),
                                                                                                  //this right here
                                                                                                  child: Container(
                                                                                                    height: height / 5,
                                                                                                    margin: EdgeInsets.symmetric(
                                                                                                        vertical: height / 54.13,
                                                                                                        horizontal: width / 25),
                                                                                                    child: Column(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        const Center(
                                                                                                            child: Text("Delete",
                                                                                                                style: TextStyle(
                                                                                                                    color: Color(0XFF0EA102),
                                                                                                                    fontWeight: FontWeight.bold,
                                                                                                                    fontSize: 20,
                                                                                                                    fontFamily: "Poppins"))),
                                                                                                        const Divider(),
                                                                                                        const Center(
                                                                                                            child: Text(
                                                                                                                "Are you sure to Delete this Response")),
                                                                                                        const Spacer(),
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets.symmetric(
                                                                                                              horizontal: width / 25),
                                                                                                          child: Row(
                                                                                                            mainAxisAlignment:
                                                                                                                MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              TextButton(
                                                                                                                onPressed: () {
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
                                                                                                                },
                                                                                                                child: const Text(
                                                                                                                  "Cancel",
                                                                                                                  style: TextStyle(
                                                                                                                      color: Colors.grey,
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      fontFamily: "Poppins",
                                                                                                                      fontSize: 15),
                                                                                                                ),
                                                                                                              ),
                                                                                                              ElevatedButton(
                                                                                                                style: ElevatedButton.styleFrom(
                                                                                                                  shape: RoundedRectangleBorder(
                                                                                                                    borderRadius:
                                                                                                                        BorderRadius.circular(18.0),
                                                                                                                  ),
                                                                                                                  backgroundColor: Colors.green,
                                                                                                                ),
                                                                                                                onPressed: () async {
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
                                                                                                                  await deletePost11(
                                                                                                                      forumId: _responseForums
                                                                                                                          .response[index].id);
                                                                                                                  await getResponses(
                                                                                                                      forumId:
                                                                                                                          _forumsResponse.response.id,
                                                                                                                      type: selectedValue);
                                                                                                                },
                                                                                                                child: const Text(
                                                                                                                  "Continue",
                                                                                                                  style: TextStyle(
                                                                                                                      color: Colors.white,
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      fontFamily: "Poppins",
                                                                                                                      fontSize: 15),
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
                                                                                          "Delete",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                : Column(
                                                                                    children: [
                                                                                      ListTile(
                                                                                        onTap: () {
                                                                                          if (!mounted) {
                                                                                            return;
                                                                                          }
                                                                                          Navigator.pop(context);
                                                                                          showDialog(
                                                                                              barrierDismissible: false,
                                                                                              context: context,
                                                                                              builder: (BuildContext context) {
                                                                                                return Dialog(
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                      borderRadius: BorderRadius.circular(20.0)),
                                                                                                  //this right here
                                                                                                  child: Container(
                                                                                                    height: height / 5,
                                                                                                    margin: EdgeInsets.symmetric(
                                                                                                        vertical: height / 54.13,
                                                                                                        horizontal: width / 25),
                                                                                                    child: Column(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        const Center(
                                                                                                            child: Text("Delete",
                                                                                                                style: TextStyle(
                                                                                                                    color: Color(0XFF0EA102),
                                                                                                                    fontWeight: FontWeight.bold,
                                                                                                                    fontSize: 20,
                                                                                                                    fontFamily: "Poppins"))),
                                                                                                        const Divider(),
                                                                                                        const Center(
                                                                                                            child: Text(
                                                                                                                "Are you sure to Delete this Response")),
                                                                                                        const Spacer(),
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets.symmetric(
                                                                                                              horizontal: width / 25),
                                                                                                          child: Row(
                                                                                                            mainAxisAlignment:
                                                                                                                MainAxisAlignment.spaceBetween,
                                                                                                            children: [
                                                                                                              TextButton(
                                                                                                                onPressed: () {
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
                                                                                                                },
                                                                                                                child: const Text(
                                                                                                                  "Cancel",
                                                                                                                  style: TextStyle(
                                                                                                                      color: Colors.grey,
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      fontFamily: "Poppins",
                                                                                                                      fontSize: 15),
                                                                                                                ),
                                                                                                              ),
                                                                                                              ElevatedButton(
                                                                                                                style: ElevatedButton.styleFrom(
                                                                                                                  shape: RoundedRectangleBorder(
                                                                                                                    borderRadius:
                                                                                                                        BorderRadius.circular(18.0),
                                                                                                                  ),
                                                                                                                  backgroundColor: Colors.green,
                                                                                                                ),
                                                                                                                onPressed: () async {
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
                                                                                                                  await deletePost11(
                                                                                                                      forumId: _responseForums
                                                                                                                          .response[index].id);
                                                                                                                  await getResponses(
                                                                                                                      forumId:
                                                                                                                          _forumsResponse.response.id,
                                                                                                                      type: selectedValue);
                                                                                                                },
                                                                                                                child: const Text(
                                                                                                                  "Continue",
                                                                                                                  style: TextStyle(
                                                                                                                      color: Colors.white,
                                                                                                                      fontWeight: FontWeight.w600,
                                                                                                                      fontFamily: "Poppins",
                                                                                                                      fontSize: 15),
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
                                                                                          "Delete",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                                        ),
                                                                                      ),
                                                                                      Divider(
                                                                                        color: Theme.of(context).colorScheme.tertiary,
                                                                                        thickness: 0.8,
                                                                                      ),
                                                                                      ListTile(
                                                                                        onTap: () {
                                                                                          if (!mounted) {
                                                                                            return;
                                                                                          }
                                                                                          Navigator.pop(context);
                                                                                          showAlertDialog(
                                                                                              context: context,
                                                                                              forumId: _forumsResponse.response.id,
                                                                                              forumUserId: _forumsResponse.response.user.id,
                                                                                              messageId: _responseForums.response[index].id,
                                                                                              checkWhich: 'response');
                                                                                        },
                                                                                        minLeadingWidth: width / 25,
                                                                                        leading: const Icon(
                                                                                          Icons.shield,
                                                                                          size: 20,
                                                                                        ),
                                                                                        title: Text(
                                                                                          "Report",
                                                                                          style: TextStyle(
                                                                                              fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                child: Container(
                                                                    padding: EdgeInsets.only(right: width / 23.4375),
                                                                    child: const Icon(
                                                                      Icons.more_horiz,
                                                                      size: 20,
                                                                    )),
                                                              )
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
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
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                            child: ListTile(
                                                                              onTap: () {
                                                                                if (!mounted) {
                                                                                  return;
                                                                                }
                                                                                Navigator.pop(context);
                                                                                showAlertDialog(
                                                                                    context: context,
                                                                                    forumId: _forumsResponse.response.id,
                                                                                    forumUserId: _responseForums.response[index].user.id,
                                                                                    messageId: _responseForums.response[index].id,
                                                                                    checkWhich: 'response');
                                                                              },
                                                                              minLeadingWidth: width / 25,
                                                                              leading: const Icon(
                                                                                Icons.shield,
                                                                                size: 20,
                                                                              ),
                                                                              title: Text(
                                                                                "Report",
                                                                                style:
                                                                                    TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                },
                                                                child: Container(
                                                                    padding: EdgeInsets.only(right: width / 23.4375),
                                                                    child: const Icon(
                                                                      Icons.more_horiz,
                                                                      size: 20,
                                                                    )),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height / 47.9,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                  SizedBox(
                                    height: height / 33.83,
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  ),
                                  SizedBox(
                                    height: height / 33.83,
                                  ),
                                  Obx(() => RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                              text: "Similar ",
                                              style: TextStyle(
                                                  fontSize: text.scale(14),
                                                  color: isDarkTheme.value ? Theme.of(context).colorScheme.onPrimary : const Color(0XFF3C413B),
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
                                  const Divider(
                                    thickness: 0.5,
                                  ),
                                  SizedBox(
                                    height: height / 54.13,
                                  ),
                                  loadingRelated
                                      ? emptyBool
                                          ? Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                      height: 150,
                                                      width: 150,
                                                      child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        _bannerAdIsLoaded && _bannerAd != null
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                child: SizedBox(
                                  width: _bannerAd!.size.width.toDouble(),
                                  height: _bannerAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAd!),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    )
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
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
                          file1 = doc!.paths.map((path) => File(path!)).toList();
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

  showSheet11({required StateSetter newSetState}) {
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
                        newSetState(() {
                          pickedImage = File(image.path);
                          selectedPopUpUrlType = "image";
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
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      final video = await picker.pickVideo(source: ImageSource.gallery);
                      if (video != null) {
                        newSetState(() {
                          pickedVideo = File(video.path);
                          pickedImage = null;
                          selectedPopUpUrlType = "video";
                        });
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
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      doc = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'docx'],
                      );
                      if (doc != null) {
                        newSetState(() {
                          file1 = doc!.paths.map((path) => File(path!)).toList();
                          pickedFile = file1[0];
                          selectedPopUpUrlType = "document";
                          Navigator.of(context).pop();
                        });
                        newUrlLink = doc!.files[0].path!;
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

  void showAlertDialog(
      {required BuildContext context, required String forumId, required String forumUserId, required String messageId, required String checkWhich}) {
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
                    onTap: () async {
                      if (checkWhich == "response") {
                        logEventFunc(name: actionValue == "Report" ? 'Reported_Forum_response' : 'Blocked_Forum_response', type: 'Forum Response');
                        await reportResponsePost(
                            messageId: messageId,
                            forumUserId: forumUserId,
                            why: whyValue,
                            description: _controller.text,
                            forumId: forumId,
                            action: actionValue);
                      } else {
                        logEventFunc(name: actionValue == "Report" ? 'Reported_Post' : 'Blocked_Post', type: 'Forum');
                        await reportPost(
                            action: actionValue, why: whyValue, description: _controller.text, forumId: forumId, forumUserId: forumUserId);
                      }

                      if (checkWhich == 'similar') {
                        await getRelatedData();
                      } else {
                        await getResponses(forumId: _forumsResponse.response.id, type: selectedValue);
                      }
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

  void showAlertDialog11({
    required BuildContext context,
    required String url,
    required String urlType,
    required String message,
    required String messageId,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, modelSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              content: SizedBox(
                height: 500,
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
                                selectedPopUpUrlType = "";
                              });
                              if (!mounted) {
                                return;
                              }
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear, size: 24, color: Color(0xff000000)),
                          ),
                        ],
                      ),
                      popUpAttach
                          ? selectedPopUpUrlType == ""
                              ? GestureDetector(
                                  onTap: () {
                                    modelSetState(() {
                                      popUpAttach = true;
                                    });
                                    showSheet11(newSetState: modelSetState);
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
                                    selectedPopUpUrlType == ""
                                        ? const SizedBox()
                                        : selectedPopUpUrlType == "image"
                                            ? Container(
                                                padding: const EdgeInsets.only(top: 8, right: 5),
                                                height: height / 6.76,
                                                width: width / 3.12,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                  image: FileImage(pickedImage!),
                                                  fit: BoxFit.fill,
                                                )),
                                              )
                                            : selectedPopUpUrlType == "video"
                                                ? Container(
                                                    color: Colors.red,
                                                    width: width / 1.7,
                                                    child: playerScreen11(newUrlLink: pickedVideo!),
                                                  )
                                                : selectedPopUpUrlType == "document"
                                                    ? Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute<dynamic>(
                                                                  builder: (_) => PDFViewerFromUrl(
                                                                    url: pickedFile!.path,
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
                                                                    pickedFile!.path.split('/').last.toString(),
                                                                    style: const TextStyle(color: Colors.black, fontSize: 13),
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
                                                          const SizedBox(
                                                            height: 10,
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
                                    showSheet11(newSetState: modelSetState);
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
                                                      imageUrl: url,
                                                      tag: "generate_a_unique_tag",
                                                    );
                                                  }));
                                                },
                                                child: Container(
                                                    padding: const EdgeInsets.only(top: 8, right: 5),
                                                    height: height / 6.76,
                                                    width: width / 3.12,
                                                    child: Image.network(
                                                      url,
                                                      fit: BoxFit.fill,
                                                    )),
                                              )
                                            : urlType == "video"
                                                ? Container(
                                                    color: Colors.red,
                                                    width: width / 1.7,
                                                    child: playerScreen(url),
                                                  )
                                                : urlType == "document"
                                                    ? Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute<dynamic>(
                                                                  builder: (_) => PDFViewerFromUrl(
                                                                    url: url,
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
                                                                    url.split('/').last.toString(),
                                                                    style: const TextStyle(color: Colors.black, fontSize: 13),
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
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                  ],
                                ),
                      const SizedBox(
                        height: 10,
                      ),
                      urlType == ""
                          ? const SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                urlType == "image"
                                    ? Row(
                                        children: [
                                          Text(
                                            url.split('/').last.toString(),
                                            style: const TextStyle(color: Colors.black, fontSize: 12),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                url = "";
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
                                            url.split('/').last.toString(),
                                            style: const TextStyle(color: Colors.black, fontSize: 12),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                url = "";
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
                                            url.split('/').last.toString(),
                                            style: const TextStyle(color: Colors.black, fontSize: 12),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              modelSetState(() {
                                                url = "";
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
                      const SizedBox(
                        height: 10,
                      ),
                      showList1
                          ? showLoader1
                              ? const SizedBox()
                              : Container(
                                  height: 150,
                                  width: 350,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                    boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 1, color: Colors.grey.shade300)],
                                  ),
                                  child: ListView.builder(
                                      itemCount: searchResult.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Container(
                                          height: 35,
                                          margin: index == searchResult.length - 1 ? const EdgeInsets.only(bottom: 15) : const EdgeInsets.all(0),
                                          child: ListTile(
                                            onTap: () {
                                              modelSetState(() {
                                                showList1 = false;
                                                splitOne1 = _editController.text.split("+");
                                                //searchUserId=searchIdResult[index];
                                              });
                                              String controllerText1 = "";
                                              for (int i = 0; i < splitOne1.length; i++) {
                                                if (splitOne1.length <= 2) {
                                                  if (i != splitOne1.length - 1) {
                                                    modelSetState(() {
                                                      controllerText1 = "$controllerText1 ${splitOne1[i]}";
                                                      showList1 = false;
                                                    });
                                                  } else {
                                                    _editController.text = "$controllerText1 +${searchResult[index]} ";
                                                    _editController.selection =
                                                        TextSelection.fromPosition(TextPosition(offset: _editController.text.length));
                                                    modelSetState(() {
                                                      showList1 = false;
                                                    });
                                                  }
                                                } else {
                                                  if (i == 0) {
                                                    modelSetState(() {
                                                      controllerText1 = "$controllerText1 ${splitOne1[i]}";
                                                      showList1 = false;
                                                    });
                                                  } else if (i != splitOne1.length - 1) {
                                                    modelSetState(() {
                                                      controllerText1 = "$controllerText1 +${splitOne1[i]}";
                                                      showList1 = false;
                                                    });
                                                  } else {
                                                    _editController.text = "$controllerText1 +${searchResult[index]} ";
                                                    _editController.selection =
                                                        TextSelection.fromPosition(TextPosition(offset: _editController.text.length));
                                                    modelSetState(() {
                                                      showList1 = false;
                                                    });
                                                  }
                                                }
                                              }
                                              modelSetState(() {
                                                showList1 = false;
                                              });
                                            },
                                            title: Text(
                                              searchResult[index],
                                              style: TextStyle(
                                                  color: const Color(0XFFB0B0B0),
                                                  fontSize: text.scale(12),
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            trailing: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                searchLogo[index],
                                              ),
                                              radius: 15,
                                            ),
                                          ),
                                        );
                                      }),
                                )
                          : const SizedBox(),
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
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  newResponseValue1 = value.trim();
                                  if (newResponseValue1.isNotEmpty) {
                                    textCount1 = newResponseValue1.length;
                                    messageText1 = newResponseValue1;
                                    if (messageText1.startsWith("+")) {
                                      if (messageText1.substring(messageText1.length - 1) == '+') {
                                        modelSetState(() {
                                          showList1 = true;
                                          showLoader1 = true;
                                        });
                                      } else {
                                        if (showList1) {
                                          searchData(newResponseValue: newResponseValue1, value: true, newSetState: modelSetState);
                                          modelSetState(() {
                                            showLoader1 = false;
                                          });
                                        }
                                      }
                                    } else {
                                      if (messageText1.contains(" +")) {
                                        if (messageText1.substring(messageText1.length - 1) == '+') {
                                          modelSetState(() {
                                            showList1 = true;
                                            showLoader1 = true;
                                          });
                                        } else {
                                          if (showList1) {
                                            searchData(newResponseValue: newResponseValue1, value: true, newSetState: modelSetState);
                                            modelSetState(() {
                                              showLoader1 = false;
                                            });
                                          }
                                        }
                                      } else {
                                        modelSetState(() {
                                          showList1 = false;
                                          showLoader1 = true;
                                        });
                                      }
                                    }
                                  }
                                });
                              } else if (value.isEmpty) {
                                modelSetState(() {
                                  showList1 = false;
                                  newResponseValue1 = value;
                                });
                              } else {
                                modelSetState(() {
                                  showList1 = false;
                                  newResponseValue1 = value;
                                });
                              }
                            },
                            style: TextStyle(
                                color: const Color(0XFFB0B0B0), fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                            controller: _editController,
                            keyboardType: TextInputType.name,
                            maxLines: 4,
                            minLines: 3,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: width / 25, vertical: height / 81.2),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                hintText: "Enter a description...",
                                hintStyle: TextStyle(
                                    color: const Color(0XFFB0B0B0), fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 33.82,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                          await addResponseFunc(
                              urlType: selectedPopUpUrlType,
                              forumId: _forumsResponse.response.id,
                              category: finalisedCategory.toLowerCase(),
                              cId: finalisedCategory.toLowerCase() == "stocks"
                                  ? mainCatIdList[0]
                                  : finalisedCategory.toLowerCase() == "crypto"
                                      ? mainCatIdList[1]
                                      : finalisedCategory.toLowerCase() == "commodity"
                                          ? mainCatIdList[2]
                                          : finalisedCategory.toLowerCase() == "forex"
                                              ? mainCatIdList[3]
                                              : "",
                              message: _editController.text,
                              //  taggedUser: searchUserId,
                              messageId: messageId,
                              selectedBool: true);
                          await getResponses(forumId: _forumsResponse.response.id, type: selectedValue);
                          modelSetState(() {
                            popUpAttach = false;
                            selectedPopUpUrlType = "";
                          });
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
      },
    );
  }

  List<TextSpan> spanList({required String message, required BuildContext context}) {
    TextScaler text = MediaQuery.of(context).textScaler;
    List<TextSpan> textSpan = [];
    List<String> newSplit = message.split(' ');
    for (int i = 0; i < newSplit.length; i++) {
      if (newSplit[i].contains("+")) {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(10), fontFamily: "Poppins", fontWeight: FontWeight.w400),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                getValuesData(value: newSplit[i].substring(1));
              }));
      } else if ((RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?"))
          .hasMatch(newSplit[i])) {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(
                color: Colors.blue,
                fontSize: text.scale(10),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DemoPage(url: newSplit[i], text: "", image: "", id: "", type: "", activity: false)));*/
                Get.to(const DemoView(), arguments: {"id": "", "type": "news", "url": newSplit[i]});
                //getValuesData(value: newSplit[i].substring(1));
              }));
      } else {
        textSpan
            .add(TextSpan(text: "${newSplit[i]} ", style: TextStyle(fontSize: text.scale(10), fontFamily: "Poppins", fontWeight: FontWeight.w400)));
      }
    }
    return textSpan;
  }
}
