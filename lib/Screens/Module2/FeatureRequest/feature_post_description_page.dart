import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/DoubleOne/translation_widget_single_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_widgets.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';

import 'feature_request_page.dart';
import 'feature_response_model.dart';
import 'related_feature_response_model.dart';
import 'response_feature_response_model.dart';

List<String> listFeatureIds = [];
RxString currentFeatureId = "".obs;
RxInt idFeatureIndex = 0.obs;

class FeaturePostDescriptionPage extends StatefulWidget {
  final String sortValue;
  final String featureId;
  final String navBool;
  final dynamic featureDetail;
  final List<String> idList;

  const FeaturePostDescriptionPage(
      {Key? key, required this.sortValue, required this.featureId, required this.featureDetail, required this.idList, required this.navBool})
      : super(key: key);

  @override
  State<FeaturePostDescriptionPage> createState() => _FeaturePostDescriptionPageState();
}

class _FeaturePostDescriptionPageState extends State<FeaturePostDescriptionPage> {
  String mainUserToken = "";
  String mainUserId = "";
  String searchValue = "";
  String selectedValue = "Recent";
  List<dynamic> featureObjectList = [];
  List<String> mainFeatureIdList = [];
  dynamic featureObject;
  String userName = "";
  String avatar = "";
  List<String> networkUrls = [];
  List<BetterPlayerController> betterPlayerList = [];
  List resFeatureImagesList = [];
  List resFeatureTaggedUserList = [];
  List resFeatureTaggedUserIdList = [];
  List resFeatureSourceNameList = [];
  List resFeatureTitlesList = [];
  List<String> resFeatureIdList = [];
  List<int> resFeatureLikeList = [];
  List<int> resFeatureDislikeList = [];
  List<bool> resFeatureUseList = [];
  List<dynamic> resFeatureObjectList = [];
  List<bool> resFeatureUseDisList = [];
  List<String> resFeatureUserIdList = [];
  List<String> resFeatureDescriptionList = [];
  List<String> resFeatureUrlList = [];
  List<String> resFeatureUrlTypeList = [];
  List<bool> resFeatureMyList = [];
  bool emptyBool = false;
  List<bool> playerConditions = [];
  List<String> playerVideoId = [];
  List featureSourceNameList = [];
  List<String> featureTitlesList = [];
  List<bool> featureTranslationList = [];
  List<String> featureCategoryList = [];
  List<String> featureIdList = [];
  List<int> featureViewsList = [];
  dynamic resFeatureObject;
  List<int> featureResponseList = [];
  List<String> featureUserIdList = [];
  List<int> featureLikeList = [];
  List<int> featureDislikeList = [];
  List<bool> featureUseList = [];
  List<bool> featureUseDisList = [];
  List<bool> featureMyList = [];
  List featureImagesList = [];
  bool noSimilarData = false;
  late BetterPlayerController _betterPlayerController;
  late BetterPlayerController _betterPlayerController1;
  late BetterPlayerController _betterPlayerController2;
  Map<String, dynamic> data = {};
  Map<String, dynamic> dataUpdate = {};
  Map<String, dynamic> dataNew = {};
  Map<String, dynamic> dataUpdateNew = {};
  File? pickedImage;
  File? pickedVideo;
  File? pickedFile;
  FilePickerResult? doc;
  String selectedPopUpUrlType = "";
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  String selectedUrlType = "";
  String typeNew = "";
  Map<String, dynamic> data1 = {};
  Map<String, dynamic> data1New = {};
  List<File> file1 = [];
  List<String> actionList = ["Report", "Block"];
  List<String> whyList = ["Scam", "Abusive Content", "Spam", "Other"];
  String actionValue = "Report";
  String newUrlLink = "";
  String whyValue = "Scam";
  bool popUpAttach = false;
  bool responseLoader = false;
  bool refreshLoader = false;
  bool showList = false;
  bool showLoader = false;
  bool searchNoList = false;
  late Uri newLink;
  String newTime = "";
  String newResponseValue = "";
  String messageText = "";
  String searchUserId = "";
  List<String> splitOne = [];
  int textCount = 0;
  List<String> resFeatureTimeList = [];
  final List<String> _choose = ["Recent", "Most Liked", "Most Disliked"];
  List<String> featureLikedImagesList = [];
  List<String> featureLikedIdList = [];
  List<String> featureLikedSourceNameList = [];
  List<String> featureViewedImagesList = [];
  List<String> featureViewedIdList = [];
  List<String> featureViewedSourceNameList = [];
  List<String> searchResult = [];
  List<String> searchIdResult = [];
  List<String> searchLogo = [];
  String relatedFeatureId = "";
  String relatedFeatureDescription = "";
  List<String> relatedFeatureIdList = [];
  List<String> relatedFeatureDescriptionList = [];
  List<String> featureResponseLikedImagesList = [];
  List<String> featureResponseLikedIdList = [];
  List<String> featureResponseLikedSourceNameList = [];
  bool showList1 = false;
  bool showLoader1 = false;
  List<String> splitOne1 = [];
  String newResponseValue1 = "";
  int textCount1 = 0;
  String messageText1 = "";
  late FeatureResponseModel _featureResponse;
  late ResponseFeatureResponseModel _responseFeature;
  bool isLiked = false;
  bool isDisliked = false;
  int viewCount = 0;
  int likeCount = 0;
  int shareCount = 0;
  int disLikeCount = 0;
  int responseCount = 0;
  List<String> exchangeValueList = [];
  bool emptyBoolResponses = true;
  bool loadingRelated = false;
  late RelatedFeatureModel _featuresRelatedResponse;
  String swipeDirection = "";
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
    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
    context.read<TranslationWidgetSingleBloc>().add(const LoadingTranslationSingleEvent());
    getAllDataMain(name: 'Feature_Description_Page');
    getNotifyCountAndImage();
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
    listFeatureIds.clear();
    if (widget.idList.isEmpty) {
      listFeatureIds.add(widget.featureId);
    } else {
      listFeatureIds.addAll(widget.idList);
    }
    idFeatureIndex = listFeatureIds.indexOf(widget.featureId).obs;
    currentFeatureId = listFeatureIds[idFeatureIndex.value].obs;
  }

  getAllData() async {
    setState(() {
      refreshLoader = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    await getIdData(id: currentFeatureId.value, type: "feature");
    _featureResponse.response.urlType == 'video' ? await playerFunc(urlLink: _featureResponse.response.url) : debugPrint("nothing");
    titleMain = _featureResponse.response.title;
    isLiked = _featureResponse.response.likes;
    isDisliked = _featureResponse.response.dislikes;
    likeCount = _featureResponse.response.likesCount;
    shareCount = _featureResponse.response.shareCount;
    viewCount = _featureResponse.response.viewsCount;
    responseCount = _featureResponse.response.responseCount;
    disLikeCount = _featureResponse.response.disLikesCount;
    await getOwnUserData();
    await getResponses(featureId: currentFeatureId.value, type: selectedValue);
    await getRelatedFeatures(featureId: currentFeatureId.value, category: finalisedCategory.toLowerCase());
  }

  getIdData({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"id": id, "type": type});
    var responseData = json.decode(response.body);
    _featureResponse = FeatureResponseModel.fromJson(responseData);

    //  _forumsResponse=ForumsResponseModel.fromJson(responseData);
    /*if (responseData["status"]) {
      if (mounted)
        setState(() {
          forumObject=responseData["response"];
          relatedForumId=responseData["response"]['user']["_id"];
          if(responseData["response"].containsKey("description")){
            relatedForumDescription=responseData["response"]["description"];
          }
          else{
            relatedForumDescription="";
          }
          if(responseData["response"].containsKey("createdAt")){
            DateTime dt = DateTime.parse(responseData["response"]["createdAt"]);
            final timestamp1 = dt.millisecondsSinceEpoch;
            readTimestamp(timestamp1);
          }
          else{
            mainTime="";
          }
        });
    }*/
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

  getResponses({required String featureId, required String type}) async {
    type == "Recent"
        ? typeNew = ""
        : type == "Most Liked"
            ? typeNew = 'like'
            : type == "Most Disliked"
                ? typeNew = 'dislike'
                : typeNew = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionFeature + responses);
    var response = await http.post(url, headers: {'Authorization': mainUserToken}, body: {"feature_id": featureId, 'type': typeNew});
    var responseData = json.decode(response.body);
    _responseFeature = ResponseFeatureResponseModel.fromJson(responseData);
    if (_responseFeature.status) {
      if (_responseFeature.response.isEmpty) {
        setState(() {
          emptyBoolResponses = true;
        });
      } else {
        emptyBoolResponses = false;
        for (int i = 0; i < _responseFeature.response.length; i++) {
          resFeatureUseList.add(_responseFeature.response[i].likes);
          resFeatureUseDisList.add(_responseFeature.response[i].dislikes);
          resFeatureLikeList.add(_responseFeature.response[i].likesCount);
          resFeatureDislikeList.add(_responseFeature.response[i].disLikesCount);
          resFeatureUrlTypeList.add(_responseFeature.response[i].urlType);
          resFeatureUrlList.add(_responseFeature.response[i].url);
          resFeatureMyList.add(mainUserId == _responseFeature.response[i].user.id);
          if (_responseFeature.response[i].urlType == 'video') {
            networkUrls.add(_responseFeature.response[i].url);
            playerConditions.add(false);
            playerVideoId.add(_responseFeature.response[i].id);
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
      }
    }
    /* _responseForums=ResponseForumsResponseModel.fromJson(responseData);
    if(_responseForums.status){
      if(_responseForums.response.isEmpty){
        setState(() {
          emptyBoolResponses = true;
          refreshLoader = true;
        });
      }
      else{
        emptyBoolResponses = false;
        for(int i=0;i<_responseForums.response.length;i++){
          resForumUseList.add(_responseForums.response[i].likes);
          resForumUseDisList.add(_responseForums.response[i].dislikes);
          resForumLikeList.add(_responseForums.response[i].likesCount);
          resForumDislikeList.add(_responseForums.response[i].disLikesCount);
          resForumUrlTypeList.add(_responseForums.response[i].urlType);
          resForumUrlList.add(_responseForums.response[i].url);
          resForumMyList.add(mainUserId ==_responseForums.response[i].user.id);
          if(_responseForums.response[i].urlType=='video'){
            networkUrls.add(_responseForums.response[i].url);
            playerConditions.add(false);
            playerVideoId.add(_responseForums.response[i].id);
          }else{
            networkUrls.add("a");
            playerConditions.add(false);
            playerVideoId.add(responseData["response"][i]["_id"]);
          }
        }
        networkUrls.forEach((element) {
          betterPlayerList.add(BetterPlayer.network(
            element,
            betterPlayerConfiguration: BetterPlayerConfiguration(
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
                )
            ),
          ).controller,
          );
        });
        setState(() {
          refreshLoader = true;
        });
      }
    }*/
    /*if (responseData["status"]) {
      networkUrls.clear();
      betterPlayerList.clear();
      resForumImagesList.clear();
      resForumTaggedUserList.clear();
      resForumTaggedUserIdList.clear();
      resForumObjectList.clear();
      resForumSourceNameList.clear();
      resForumTitlesList.clear();
      resForumIdList.clear();
      resForumUserIdList.clear();
      resForumLikeList.clear();
      resForumDislikeList.clear();
      resForumUseList.clear();
      resForumUseDisList.clear();
      resForumDescriptionList.clear();
      resForumUserIdList.clear();
      resForumUrlList.clear();
      resForumUrlTypeList.clear();
      resForumMyList.clear();
      resForumTimeList.clear();
      if (responseData["response"].length == 0) {
        setState(() {
          emptyBool = true;
        });
      }
      else {
        setState(() {
          emptyBool = false;
        });
        for (int i = 0; i < responseData["response"].length; i++) {
          if (responseData["response"][i]["user"].containsKey("avatar")) {
            resForumImagesList.add(responseData["response"][i]["user"]["avatar"]);
          } else {
            resForumImagesList.add("https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png");
          }

          if (responseData["response"][i].containsKey("tagged_user")) {
            resForumTaggedUserList.add(responseData["response"][i]["tagged_user"]["username"]);
            resForumTaggedUserIdList.add(responseData["response"][i]["tagged_user"]["_id"]);
          }
          else{
            resForumTaggedUserList.add("");
            resForumTaggedUserIdList.add("");
          }

          resForumObjectList.add(responseData["response"][i]);
          resForumSourceNameList.add(responseData["response"][i]["user"]["username"]);
          resForumDescriptionList.add(responseData["response"][i]["message"]);
          resForumUseList.add(responseData["response"][i]["likes"]);
          resForumUseDisList.add(responseData["response"][i]["dislikes"]);
          resForumIdList.add(responseData["response"][i]["_id"]);
          resForumLikeList.add(responseData["response"][i]["likes_count"]);
          resForumDislikeList.add(responseData["response"][i]["dis_likes_count"]);
          resForumUserIdList.add(responseData["response"][i]["user"]["_id"]);
          DateTime dt = DateTime.parse(responseData["response"][i]["createdAt"]);
          final timestamp1 = dt.millisecondsSinceEpoch;
          readTimestamp1(timestamp1);
          if (responseData["response"][i].containsKey("url_type")) {
            resForumUrlTypeList.add(responseData["response"][i]["url_type"]);
            resForumUrlList.add(responseData["response"][i]["url"]);
            if (responseData["response"][i]["url_type"] == 'video') {
              networkUrls.add(responseData["response"][i]["url"]);
              playerConditions.add(false);
              playerVideoId.add(responseData["response"][i]["_id"]);
            } else {
              networkUrls.add("a");
              playerConditions.add(false);
              playerVideoId.add(responseData["response"][i]["_id"]);
            }
          }
          else {
            resForumUrlTypeList.add("");
            resForumUrlList.add("");
          }
          if (mainUserId == resForumUserIdList[i]) {
            resForumMyList.add(true);
          }
          else {
            resForumMyList.add(false);
          }
        }

        networkUrls.forEach((element) {
              betterPlayerList.add(BetterPlayer.network(
                element,
              betterPlayerConfiguration: BetterPlayerConfiguration(
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
                  )
              ),
            ).controller,
              );
            }
        );
      }
    }*/
  }

  getRelatedFeatures({required String featureId, required String category}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    forFeaturesLottieCount++;
    prefs.setInt('forFeaturesCount', forFeaturesLottieCount);
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionFeature + relatedFeatures);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      "feature_id": featureId,
      "category": _featureResponse.response.category,
      "feature_user": _featureResponse.response.user.id //relatedFeatureId
    });
    var responseData = json.decode(response.body);
    _featuresRelatedResponse = RelatedFeatureModel.fromJson(responseData);
    if (_featuresRelatedResponse.status) {
      if (_featuresRelatedResponse.response.isEmpty) {
        setState(() {
          noSimilarData = true;
          refreshLoader = true;
        });
      } else {
        setState(() {
          noSimilarData = false;
          for (int i = 0; i < _featuresRelatedResponse.response.length; i++) {
            featureUseList.add(_featuresRelatedResponse.response[i].likes);
            featureUseDisList.add(_featuresRelatedResponse.response[i].dislikes);
            featureLikeList.add(_featuresRelatedResponse.response[i].likesCount);
            featureDislikeList.add(_featuresRelatedResponse.response[i].disLikesCount);
            featureTitlesList.add(_featuresRelatedResponse.response[i].title);
            featureTranslationList.add(false);
          }
          refreshLoader = true;
        });
      }
    }
    setState(() {
      forLottie = forFeaturesLottieCount <= 5 ? true : false;
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        forLottie = false;
      });
    });
    /*if (responseData["status"]) {
      featureImagesList.clear();
      featureSourceNameList.clear();
      featureTitlesList.clear();
      featureCategoryList.clear();
      featureIdList.clear();
      //featureCompanyList.clear();
      featureLikeList.clear();
      featureDislikeList.clear();
      featureUseList.clear();
      featureUseDisList.clear();
      featureMyList.clear();
      featureViewsList.clear();
      featureResponseList.clear();
      featureUserIdList.clear();
      if (responseData["response"].length == 0) {
        setState(() {
          noSimilarData = true;
          // searchLoader = false;
        });
      } else {
        setState(() {
          noSimilarData = false;
        });
        for (int i = 0; i < responseData["response"].length; i++) {
          if(responseData["response"][i]["user"].containsKey("avatar")){
            featureImagesList.add(responseData["response"][i]["user"]["avatar"]);
          }else{
            featureImagesList.add("");
          }
          featureTitlesList.add(responseData["response"][i]["title"]);
          featureSourceNameList.add(responseData["response"][i]["user"]["username"]);
          featureCategoryList.add(responseData["response"][i]["category"]);
          featureIdList.add(responseData["response"][i]["_id"]);
          featureViewsList.add(responseData["response"][i]["views_count"]);
          //featureCompanyList.add(responseData["response"][i]["company_name"]);
          featureResponseList.add(responseData["response"][i]["response_count"]);
          featureUserIdList.add(responseData["response"][i]["user"]["_id"]);
          featureUseList.add(responseData["response"][i]["likes"]);
          featureUseDisList.add(responseData["response"][i]["dislikes"]);
          featureLikeList.add(responseData["response"][i]["likes_count"]);
          featureDislikeList.add(responseData["response"][i]["dis_likes_count"]);
          if (mainUserId == featureUserIdList[i]) {
            featureMyList.add(true);
          } else {
            featureMyList.add(false);
          }
        }
      }
    }*/
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
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
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
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
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
      required String text,
      required String description}) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/FeaturePostDescriptionPage/$id/$type/$text'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));

    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  addResponseFunc({
    required String category,
    required String featureId,
    required String cId,
    required String message,
    required String urlType,
    required String messageId,
    required bool selectedBool,
  }) async {
    dataNew = {
      "category": category,
      "feature_id": featureId,
      "category_id": cId,
      "message": message,
      "url_type": urlType,
      "message_id": messageId,
    };
    data = {
      "category": category,
      "feature_id": featureId,
      "category_id": cId,
      "message": message,
      "url_type": urlType,
    };
    dataUpdate = {
      "category": category,
      "feature_id": featureId,
      "category_id": cId,
      "message": message,
    };
    dataUpdateNew = {
      "category": category,
      "feature_id": featureId,
      "category_id": cId,
      "message": message,
      "message_id": messageId,
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = baseurl + versionFeature + responseAdd;
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

  @override
  void dispose() {
    _bannerAd!.dispose();
    _betterPlayerController.dispose();
    _betterPlayerController1.dispose();
    _betterPlayerController2.dispose();
    for (var controller in betterPlayerList) {
      controller.dispose();
    }
    super.dispose();
  }

  editMessage({required String messageId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionFeature + responseEdit);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      "message_id": messageId,
      "feature_id": featureObject["_id"],
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      _editController.text = responseData["response"]["message"];
    }
  }

  reportPost(
      {required String action,
      required String why,
      required String description,
      required String featureId,
      required String messageId,
      required String featureUserId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
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
        var url = Uri.parse(baseurl + versionFeature + addReport);
        data1 = {
          "action": action,
          "why": why,
          "description": description,
          "feature_id": featureId,
          "feature_user": featureUserId,
        };
        data1New = {
          "action": action,
          "why": why,
          "description": description,
          "feature_id": featureId,
          "feature_user": featureUserId,
          "message_id": messageId
        };
        var responseNew = await http.post(url, body: messageId == "" ? data1 : data1New, headers: {'Authorization': mainUserToken});
        var responseDataNew = json.decode(responseNew.body);
        if (responseDataNew["status"]) {
          if (actionValue == "Report") {
            if (!mounted) {
              return;
            }
            Navigator.pop(context);
          } else {
            if (!mounted) {
              return false;
            }
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return const FeatureRequestPage();
            }));
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
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
      var url = Uri.parse(baseurl + versionFeature + addReport);
      data1 = {
        "action": action,
        "why": why,
        "description": description,
        "feature_id": featureId,
        "feature_user": featureUserId,
      };
      data1New = {
        "action": action,
        "why": why,
        "description": description,
        "feature_id": featureId,
        "feature_user": featureUserId,
        "message_id": messageId
      };
      var responseNew = await http.post(url, body: messageId == "" ? data1 : data1New, headers: {'Authorization': mainUserToken});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew["status"]) {
        if (actionValue == "Report") {
          if (!mounted) {
            return;
          }
          Navigator.pop(context);
        } else {
          if (!mounted) {
            return false;
          }
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const FeatureRequestPage();
          }));
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
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

  reportResponsePost(
      {required String action,
      required String why,
      required String description,
      required String featureId,
      required String messageId,
      required String featureUserId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
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
        var url = Uri.parse(baseurl + versionFeature + responseReport);
        data1New = {
          "action": action,
          "why": why,
          "description": description,
          "feature_id": featureId,
          "feature_user": featureUserId,
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
              return false;
            }
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return const FeatureRequestPage();
            }));
          }
          Flushbar(
            message: responseDataNew["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
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
      var url = Uri.parse(baseurl + versionFeature + responseReport);

      data1New = {
        "action": action,
        "why": why,
        "description": description,
        "feature_id": featureId,
        "feature_user": featureUserId,
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
            return false;
          }
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const FeatureRequestPage();
          }));
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
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

  deletePost({required String featureId, required bool similarNew}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionFeature + featureDelete);
    var responseNew = await http.post(url, body: {"feature_id": featureId}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      if (similarNew) {
      } else {
        if (widget.navBool == 'feature') {
          if (!mounted) {
            return false;
          }
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const FeatureRequestPage();
          }));
        } else {
          if (!mounted) {
            return false;
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
        return false;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
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

  deletePost11({required String featureId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versionFeature + responseDelete);
    var responseNew = await http.post(url, body: {"message_id": featureId}, headers: {'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    if (responseDataNew["status"]) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseDataNew["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
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

  getValuesData({required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId')!;
    mainUserToken = prefs.getString('newUserToken')!;
    var url = Uri.parse(baseurl + versions + getUserData);
    var newResponse = await http.post(url, headers: {'Authorization': mainUserToken}, body: {'username': value});
    var newResponseData = jsonDecode(newResponse.body.toString());
    if (newResponseData['status'] == true) {
      if (!mounted) {
        return false;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return UserBillBoardProfilePage(
            userId: newResponseData['data']['_id']) /*UserProfilePage(id: newResponseData['data']['_id'], type: 'feature', index: 2,)*/;
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
        swipeDirection = listFeatureIds.length <= 1
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
            if (idFeatureIndex < listFeatureIds.length - 1) {
              idFeatureIndex.value = idFeatureIndex.value + 1;
              currentFeatureId.value = listFeatureIds[idFeatureIndex.value];
            } else {
              idFeatureIndex.value = 0;
              currentFeatureId.value = listIds[idFeatureIndex.value];
            }
          });
          getAllData();
        }
        if (swipeDirection == 'right') {
          setState(() {
            if (idFeatureIndex > 0) {
              idFeatureIndex.value = idFeatureIndex.value - 1;
              currentFeatureId.value = listFeatureIds[idFeatureIndex.value];
            } else {
              idFeatureIndex.value = listFeatureIds.length - 1;
              currentFeatureId.value = listFeatureIds[idFeatureIndex.value];
            }
          });
          getAllData();
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          popUpAttach = false;
          if (widget.navBool == 'feature') {
            //Navigator.pop(context,true);
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return const FeatureRequestPage(
                fromWhere: 'FeaturePostDescription',
              );
            }));
          } else if (widget.navBool == 'main') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
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
          } else {
            Navigator.pop(context, true);
          }
          return false;
        },
        child: Container(
          // color: const Color(0XFFFFFFFF),
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Scaffold(
              //backgroundColor: const Color(0XFFFFFFFF),
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                //backgroundColor: const Color(0XFFFFFFFF),
                backgroundColor: Theme.of(context).colorScheme.background,
                toolbarHeight: height / 9.44,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    if (widget.navBool == 'feature') {
                      //Navigator.pop(context,true);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return const FeatureRequestPage(
                          fromWhere: 'FeaturePostDescription',
                        );
                      }));
                    } else if (widget.navBool == 'main') {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                        return const MainBottomNavigationPage(
                          tType: true,
                          text: "",
                          caseNo1: 0,
                          newIndex: 0,
                          countryIndex: 0,
                          excIndex: 0,
                          isHomeFirstTym: false,
                        );
                      }));
                    } else {
                      Navigator.pop(context, true);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                  ),
                ),
                title: Text(
                  "Feature Request",
                  //style: TextStyle(fontSize: text.scale(24), color: Colors.black, fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                actions: [
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
                  SizedBox(
                    width: width / 23.43,
                  ),
                ],
              ),
              body: refreshLoader
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            color: Theme.of(context).colorScheme.background, //const Color(0XFFFFFFFF),
                            margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height / 33.83,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).colorScheme.tertiary,
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                          )
                                        ],
                                        color: Theme.of(context).colorScheme.onBackground /*Colors.white*/,
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
                                            width: width / 1.35,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return UserBillBoardProfilePage(userId: _featureResponse.response.user.id)
                                                          /*UserProfilePage(
                                                              id: _featureResponse.response.user.id,
                                                              type: 'feature',
                                                              index: 2)*/
                                                          ;
                                                    }));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: NetworkImage(_featureResponse.response.user.avatar), fit: BoxFit.fill)),
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
                                                      width: width / 1.85,
                                                      child: Text(
                                                        titleMain,
                                                        //_featureResponse.response.title,
                                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(16)),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return UserBillBoardProfilePage(userId: _featureResponse.response.user.id)
                                                              /*UserProfilePage(
                                                                  id:  _featureResponse.response.user.id,
                                                                  type: 'feature',
                                                                  index: 2)*/
                                                              ;
                                                        }));
                                                      },
                                                      child: Text(
                                                        _featureResponse.response.user.username,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w500, fontSize: text.scale(10), color: const Color(0XFFA5A5A5)),
                                                      ),
                                                    ),
                                                    Text(
                                                      _featureResponse.response.createdAt,
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
                                                        child: mainUserId == _featureResponse.response.user.id
                                                            ? ListTile(
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
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                          //this right here
                                                                          child: Container(
                                                                            height: height / 6,
                                                                            margin: EdgeInsets.symmetric(
                                                                                vertical: height / 54.13, horizontal: width / 25),
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              //crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                              featureId: _featureResponse.response.id,
                                                                                              similarNew: false);
                                                                                          await getResponses(
                                                                                              featureId: _featureResponse.response.id,
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
                                                                          featureId: _featureResponse.response.id,
                                                                          featureUserId: _featureResponse.response.user.id,
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
                                                                  const Divider(
                                                                    thickness: 0.0,
                                                                    height: 0.0,
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
                                                                          featureId: _featureResponse.response.id,
                                                                          featureUserId: _featureResponse.response.user.id,
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
                                      SizedBox(
                                        width: width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _featureResponse.response.description,
                                                style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: height / 50.75,
                                      ),
                                      _featureResponse.response.urlType == ""
                                          ? const SizedBox(
                                              height: 10,
                                            )
                                          : Row(
                                              mainAxisAlignment: _featureResponse.response.urlType == "document"
                                                  ? MainAxisAlignment.start
                                                  : MainAxisAlignment.center,
                                              children: [
                                                _featureResponse.response.urlType == ""
                                                    ? const SizedBox()
                                                    : _featureResponse.response.urlType == "image"
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                                return FullScreenImage(
                                                                  imageUrl: _featureResponse.response.url,
                                                                  tag: "generate_a_unique_tag",
                                                                );
                                                              }));
                                                            },
                                                            child: SizedBox(
                                                                height: height / 4,
                                                                width: width / 1.25,
                                                                child: Image.network(
                                                                  _featureResponse.response.url,
                                                                  fit: BoxFit.cover,
                                                                )),
                                                          )
                                                        : _featureResponse.response.urlType == "video"
                                                            ? SizedBox(
                                                                width: width / 1.25,
                                                                child: BetterPlayer(controller: _betterPlayerController),
                                                              )
                                                            : _featureResponse.response.urlType == "document"
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
                                                                                url: _featureResponse.response.url,
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
                                                                                _featureResponse.response.url.split('/').last.toString(),
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
                                            SizedBox(
                                              height: height / 45.11,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      bool response1 = await likeFunction(id: _featureResponse.response.id, type: "feature");
                                                      if (response1) {
                                                        logEventFunc(name: "Likes", type: "Feature");
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
                                                      margin: EdgeInsets.only(right: width / 25),
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
                                                      logEventFunc(name: "Share", type: "Feature");
                                                      newLink = await getLinK(
                                                          id: _featureResponse.response.id,
                                                          type: "feature",
                                                          description: '',
                                                          imageUrl: "",
                                                          title: _featureResponse.response.title,
                                                          text: widget.sortValue);
                                                      ShareResult result = await Share.share(
                                                        "Look what I was able to find on Tradewatch: ${_featureResponse.response.title} ${newLink.toString()}",
                                                      );
                                                      if (result.status == ShareResultStatus.success) {
                                                        setState(() {
                                                          shareCount += 1;
                                                        });
                                                        await shareFunction(id: _featureResponse.response.id, type: "feature");
                                                      }
                                                    },
                                                    child: Container(
                                                        height: height / 40.6,
                                                        width: width / 18.75,
                                                        margin: EdgeInsets.only(right: width / 25),
                                                        child: SvgPicture.asset(
                                                          isDarkTheme.value
                                                              ? "assets/home_screen/share_dark.svg"
                                                              : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                        )),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      bool response3 = await disLikeFunction(id: _featureResponse.response.id, type: "feature");
                                                      if (response3) {
                                                        logEventFunc(name: "Dislikes", type: "Feature");
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
                                                      margin: EdgeInsets.only(right: width / 25),
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
                                            ),
                                            widgetsMain.translationWidgetSingle(
                                              translation: false,
                                              id: _featureResponse.response.id,
                                              type: 'feature',
                                              index: 0,
                                              initFunction: getAllData,
                                              context: context,
                                              modelSetState: setState,
                                              notUse: false,
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
                                              child: Text(
                                                  _featureResponse.response.category == "general"
                                                      ? "General"
                                                      : _featureResponse.response.category == "stocks"
                                                          ? "Stocks"
                                                          : _featureResponse.response.category == "crypto"
                                                              ? "Crypto"
                                                              : _featureResponse.response.category == "commodity"
                                                                  ? "Commodity"
                                                                  : "Forex",
                                                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700, color: Colors.blue)),
                                            ),
                                            SizedBox(width: width / 37.5),
                                            GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  kUserSearchController.clear();
                                                  onTapType = "Views";
                                                  onTapId = _featureResponse.response.id;
                                                  onLike = false;
                                                  onDislike = false;
                                                  onViews = true;
                                                  idKeyMain = "feature_id";
                                                  apiMain = baseurl + versionFeature + viewsCount;
                                                  onTapIdMain = _featureResponse.response.id;
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
                                                  onTapId = _featureResponse.response.id;
                                                  onLike = true;
                                                  onDislike = false;
                                                  onViews = false;
                                                  idKeyMain = "feature_id";
                                                  apiMain = baseurl + versionFeature + likeDislikeUsers;
                                                  onTapIdMain = _featureResponse.response.id;
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
                                                  onTapId = _featureResponse.response.id;
                                                  onLike = false;
                                                  onDislike = true;
                                                  onViews = false;
                                                  idKeyMain = "feature_id";
                                                  apiMain = baseurl + versionFeature + likeDislikeUsers;
                                                  onTapIdMain = _featureResponse.response.id;
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
                                                style:
                                                    TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w700, color: const Color(0XFFB0B0B0))),
                                            Text(
                                              " Responses",
                                              style: TextStyle(fontSize: text.scale(8), fontWeight: FontWeight.w500, color: const Color(0XFFB0B0B0)),
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
                                      boxShadow: [
                                        BoxShadow(
                                            color: Theme.of(context).colorScheme.tertiary /*Colors.grey.withOpacity(0.1)*/,
                                            blurRadius: 4,
                                            spreadRadius: 0)
                                      ],
                                      color: Theme.of(context).colorScheme.onBackground /*Colors.white*/,
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
                                                return UserBillBoardProfilePage(
                                                    userId: mainUserId) /*UserProfilePage(id:mainUserId,type:'feature',index:2)*/;
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
                                                                  searchData(newResponseValue: newResponseValue, value: false, newSetState: setState);
                                                                  setState(() {
                                                                    showLoader = false;
                                                                  });
                                                                } else {
                                                                  searchData(newResponseValue: newResponseValue, value: false, newSetState: setState);
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
                                                                                color: Theme.of(context).colorScheme.onPrimary,
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
                                                                                color: Theme.of(context).colorScheme.onPrimary,
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
                                                    logEventFunc(name: 'Responses', type: "Feature");
                                                    setState(() {
                                                      responseLoader = true;
                                                    });
                                                    await addResponseFunc(
                                                        urlType: selectedUrlType,
                                                        featureId: _featureResponse.response.id,
                                                        category: _featureResponse.response.category,
                                                        cId: _featureResponse.response.category == "stocks"
                                                            ? mainCatIdList[0]
                                                            : _featureResponse.response.category == "crypto"
                                                                ? mainCatIdList[1]
                                                                : _featureResponse.response.category == "commodity"
                                                                    ? mainCatIdList[2]
                                                                    : _featureResponse.response.category == "forex"
                                                                        ? mainCatIdList[3]
                                                                        : "",
                                                        message: _descriptionController.text,
                                                        messageId: "",
                                                        selectedBool: false);
                                                    await getResponses(featureId: _featureResponse.response.id, type: selectedValue);
                                                    setState(() {
                                                      responseLoader = false;
                                                      showList = false;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: height / 28.14,
                                                    width: width / 4.76,
                                                    margin: const EdgeInsets.only(right: 15),
                                                    decoration: BoxDecoration(color: const Color(0XFF0EA102), borderRadius: BorderRadius.circular(5)),
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
                                    Text("Response order",
                                        //style: TextStyle(fontSize: text.scale(10), color: const Color(0XFFB0B0B0)),
                                        style: Theme.of(context).textTheme.labelSmall),
                                    SizedBox(
                                      width: width / 53.57,
                                    ),
                                    Icon(Icons.access_time,
                                        size: width / 37.5, color: Theme.of(context).colorScheme.primary /*const Color(0XFF000000)*/),
                                    SizedBox(
                                      width: width / 75,
                                    ),
                                    SizedBox(
                                      width: width / 3.40,
                                      child: DropdownButtonFormField<String>(
                                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                        decoration: const InputDecoration(focusedBorder: InputBorder.none, enabledBorder: InputBorder.none),
                                        items: _choose
                                            .map((label) => DropdownMenuItem<String>(
                                                value: label,
                                                child: Text(
                                                  label,
                                                  // style: TextStyle(fontSize: text.scale(11), fontWeight: FontWeight.w500),
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: text.scale(11)),
                                                )))
                                            .toList(),
                                        value: selectedValue,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedValue = value!;
                                          });
                                          getResponses(featureId: _featureResponse.response.id, type: selectedValue);
                                        },
                                        dropdownColor: Theme.of(context).colorScheme.tertiary,
                                      ),
                                    ),
                                  ],
                                ),
                                _responseFeature.response.isEmpty
                                    ? const SizedBox()
                                    : SizedBox(
                                        height: height / 33.83,
                                      ),
                                _responseFeature.response.isEmpty
                                    ? Center(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: 'No response to display...',
                                                      //style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .copyWith(fontWeight: FontWeight.w500, color: const Color(0XFF0EA102))),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _responseFeature.response.length,
                                        shrinkWrap: true,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            margin: EdgeInsets.only(bottom: height / 35),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.onBackground /*Colors.white*/,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Theme.of(context).colorScheme.tertiary,
                                                      blurRadius: 4,
                                                      spreadRadius:
                                                          0 /*color: Colors.grey.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 7, spreadRadius: 5*/)
                                                ]),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: height / 47.9,
                                                ),
                                                Container(
                                                  color: Theme.of(context).colorScheme.onBackground /*Colors.white*/,
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
                                                                  uId: _responseFeature.response[index].userId,
                                                                  uType: 'feature',
                                                                  mainUserToken: mainUserToken,
                                                                  context: context,
                                                                  index: 2);
                                                            },
                                                            child: Container(
                                                              height: height / 20.3,
                                                              width: width / 9.35,
                                                              margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Colors.grey,
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                        _responseFeature.response[index].user.avatar,
                                                                      ),
                                                                      fit: BoxFit.fill)),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              /*Container(
                                                      width: _width / 1.95,
                                                      child: Text(
                                                        featureObject["title"],
                                                        style: TextStyle(
                                                            fontSize:
                                                            _text.scale(100)12,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600),
                                                      )),*/
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  /*Navigator.push(context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (BuildContext
                                                                                  context) {
                                                                    return UserProfilePage(
                                                                        id: resFeatureUserIdList[
                                                                            index],
                                                                        type: 'feature',
                                                                        index: 2);
                                                                  }));*/
                                                                  await checkUser(
                                                                      uId: _responseFeature.response[index].user.id,
                                                                      uType: 'feature',
                                                                      mainUserToken: mainUserToken,
                                                                      context: context,
                                                                      index: 2);
                                                                },
                                                                child: SizedBox(
                                                                    height: height / 54.13,
                                                                    child: Text(
                                                                      _responseFeature.response[index].user.username.toString().capitalizeFirst!,
                                                                      style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600),
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                // color: Colors.yellow,
                                                                width: width / 1.7,
                                                                child: Text(
                                                                  _responseFeature.response[index].createdAt,
                                                                  textAlign: TextAlign.justify,
                                                                  style: TextStyle(fontSize: text.scale(7), fontWeight: FontWeight.w400),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 50.75,
                                                              ),
                                                              SizedBox(
                                                                //color: Colors.yellow,
                                                                width: width / 1.7,
                                                                child: /*Text(
                                                                  resFeatureDescriptionList[index],
                                                                  textAlign:
                                                                      TextAlign.justify,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          _text.scale(100)10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                )*/
                                                                    RichText(
                                                                  textAlign: TextAlign.justify,
                                                                  text: TextSpan(
                                                                      children: spanList(
                                                                    message: _responseFeature.response[index].message,
                                                                    context: context,
                                                                  )),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: height / 50.75,
                                                              ),
                                                              _responseFeature.response[index].urlType == ""
                                                                  ? const SizedBox()
                                                                  : Row(
                                                                      mainAxisAlignment: _responseFeature.response[index].urlType == "document"
                                                                          ? MainAxisAlignment.start
                                                                          : MainAxisAlignment.center,
                                                                      children: [
                                                                        _responseFeature.response[index].urlType == ""
                                                                            ? const SizedBox()
                                                                            : _responseFeature.response[index].urlType == "image"
                                                                                ? GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                                                        return FullScreenImage(
                                                                                          imageUrl: _responseFeature.response[index].url,
                                                                                          tag: "generate_a_unique_tag",
                                                                                        );
                                                                                      }));
                                                                                    },
                                                                                    child: Container(
                                                                                        padding: const EdgeInsets.only(top: 8, right: 5),
                                                                                        height: height / 6.76,
                                                                                        width: width / 3.12,
                                                                                        child: Image.network(
                                                                                          _responseFeature.response[index].url,
                                                                                          fit: BoxFit.fill,
                                                                                        )),
                                                                                  )
                                                                                : _responseFeature.response[index].urlType == "video"
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
                                                                                                      // betterPlayerList[i].videoPlayerController?.setMixWithOthers(false);
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
                                                                                    : _responseFeature.response[index].urlType == "document"
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
                                                                                                        url: _responseFeature.response[index].url,
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
                                                                                                        _responseFeature.response[index].url
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
                                                                            id: _responseFeature.response[index].id, type: "feature response");
                                                                        if (response1) {
                                                                          logEventFunc(name: "Likes", type: "Feature Responses");
                                                                          setState(() {
                                                                            if (resFeatureUseList[index] == true) {
                                                                              if (resFeatureUseDisList[index] == true) {
                                                                              } else {
                                                                                resFeatureLikeList[index] -= 1;
                                                                              }
                                                                            } else {
                                                                              if (resFeatureUseDisList[index] == true) {
                                                                                resFeatureDislikeList[index] -= 1;
                                                                                resFeatureLikeList[index] += 1;
                                                                              } else {
                                                                                resFeatureLikeList[index] += 1;
                                                                              }
                                                                            }
                                                                            resFeatureUseList[index] = !resFeatureUseList[index];
                                                                            resFeatureUseDisList[index] = false;
                                                                          });
                                                                        } else {}
                                                                      },
                                                                      child: Container(
                                                                        margin: EdgeInsets.only(right: width / 25),
                                                                        height: height / 40.6,
                                                                        width: width / 18.75,
                                                                        child: resFeatureUseList[index]
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
                                                                            id: _responseFeature.response[index].id, type: "feature response");
                                                                        if (response3) {
                                                                          logEventFunc(name: "Dislikes", type: "Feature Responses");
                                                                          setState(() {
                                                                            if (resFeatureUseDisList[index] == true) {
                                                                              if (resFeatureUseList[index] == true) {
                                                                              } else {
                                                                                resFeatureDislikeList[index] -= 1;
                                                                              }
                                                                            } else {
                                                                              if (resFeatureUseList[index] == true) {
                                                                                resFeatureLikeList[index] -= 1;
                                                                                resFeatureDislikeList[index] += 1;
                                                                              } else {
                                                                                resFeatureDislikeList[index] += 1;
                                                                              }
                                                                            }
                                                                            resFeatureUseDisList[index] = !resFeatureUseDisList[index];
                                                                            resFeatureUseList[index] = false;
                                                                          });
                                                                        } else {}
                                                                      },
                                                                      child: Container(
                                                                        height: height / 40.6,
                                                                        width: width / 18.75,
                                                                        margin: EdgeInsets.only(right: width / 25),
                                                                        child: resFeatureUseDisList[index]
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
                                                                          onTapId = _responseFeature.response[index].id;
                                                                          onLike = true;
                                                                          onDislike = false;
                                                                          idKeyMain = "response_id";
                                                                          apiMain = baseurl + versionFeature + responseLikeDislikeCount;
                                                                          onTapIdMain = _responseFeature.response[index].id;
                                                                          onTapTypeMain = "liked";
                                                                          haveLikesMain = resFeatureLikeList[index] > 0 ? true : false;
                                                                          haveDisLikesMain = resFeatureDislikeList[index] > 0 ? true : false;
                                                                          likesCountMain = resFeatureLikeList[index];
                                                                          dislikesCountMain = resFeatureDislikeList[index];
                                                                          kToken = mainUserToken;
                                                                          loaderMain = false;
                                                                        });
                                                                        await customShowSheetNew3(
                                                                          context: context,
                                                                          responseCheck: 'feature',
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Text(resFeatureLikeList[index].toString(),
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
                                                                          onTapId = _responseFeature.response[index].id;
                                                                          onLike = false;
                                                                          onDislike = true;
                                                                          idKeyMain = "response_id";
                                                                          apiMain = baseurl + versionFeature + responseLikeDislikeCount;
                                                                          onTapIdMain = _responseFeature.response[index].id;
                                                                          onTapTypeMain = "disliked";
                                                                          haveLikesMain = resFeatureLikeList[index] > 0 ? true : false;
                                                                          haveDisLikesMain = resFeatureDislikeList[index] > 0 ? true : false;
                                                                          likesCountMain = resFeatureLikeList[index];
                                                                          dislikesCountMain = resFeatureDislikeList[index];
                                                                          kToken = mainUserToken;
                                                                          loaderMain = false;
                                                                        });
                                                                        await customShowSheetNew3(
                                                                          context: context,
                                                                          responseCheck: 'feature',
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Text(resFeatureDislikeList[index].toString(),
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
                                                      _featureResponse.response.id == mainUserId || resFeatureMyList[index]
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
                                                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                          child: resFeatureMyList[index]
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
                                                                                        editMessage(messageId: _responseFeature.response[index].id);
                                                                                        showAlertDialog11(
                                                                                            context: context,
                                                                                            url: _responseFeature.response[index].url,
                                                                                            urlType: _responseFeature.response[index].urlType,
                                                                                            message: _responseFeature.response[index].message,
                                                                                            messageId: _responseFeature.response[index].id);
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
                                                                                        showDialog(
                                                                                            barrierDismissible: false,
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return Dialog(
                                                                                                shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                        20.0)), //this right here
                                                                                                child: Container(
                                                                                                  height: height / 5,
                                                                                                  margin: EdgeInsets.symmetric(
                                                                                                      vertical: height / 54.13,
                                                                                                      horizontal: width / 25),
                                                                                                  child: Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    // crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                                                    featureId: _responseFeature
                                                                                                                        .response[index].id);
                                                                                                                await getResponses(
                                                                                                                    featureId:
                                                                                                                        _featureResponse.response.id,
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
                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                        20.0)), //this right here
                                                                                                child: Container(
                                                                                                  height: height / 5,
                                                                                                  margin: EdgeInsets.symmetric(
                                                                                                      vertical: height / 54.13,
                                                                                                      horizontal: width / 25),
                                                                                                  child: Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    //crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                                                    featureId: _responseFeature
                                                                                                                        .response[index].id);
                                                                                                                await getResponses(
                                                                                                                    featureId:
                                                                                                                        _featureResponse.response.id,
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
                                                                                        showAlertDialog(
                                                                                            context: context,
                                                                                            featureId: _featureResponse.response.id,
                                                                                            featureUserId: _featureResponse.response.user.id,
                                                                                            messageId: _responseFeature.response[index].id,
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
                                                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                          child: ListTile(
                                                                            onTap: () {
                                                                              if (!mounted) {
                                                                                return;
                                                                              }
                                                                              Navigator.pop(context);
                                                                              showAlertDialog(
                                                                                  context: context,
                                                                                  featureId: _featureResponse.response.id,
                                                                                  featureUserId: _responseFeature.response[index].user.id,
                                                                                  messageId: _responseFeature.response[index].id,
                                                                                  checkWhich: 'response');
                                                                            },
                                                                            minLeadingWidth: width / 25,
                                                                            leading: const Icon(
                                                                              Icons.shield,
                                                                              size: 20,
                                                                            ),
                                                                            title: Text(
                                                                              "Report",
                                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
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
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 0.0,
                                  thickness: 0.0,
                                ),
                                SizedBox(
                                  height: height / 33.83,
                                ),
                                Text(
                                  "Similar topics:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: text.scale(16),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 58,
                                ),
                                /* loadingRelated
                                    ? emptyBool
                                    ? Center(
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 150,
                                          width: 150,
                                          child: SvgPicture
                                              .asset(
                                              "lib/Constants/Assets/SMLogos/no respone.svg")),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                'No similar posts found',
                                                style: TextStyle(
                                                    fontFamily:
                                                    "Poppins",
                                                    color:
                                                    Color(0XFF0EA102),
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : similarDataFunc(context: context,
                                  data: relatedTopicText.value.toLowerCase() == "news"
                                      ? _newsRelatedResponse
                                      : relatedTopicText.value.toLowerCase() == "videos"
                                      ? _videosRelatedResponse
                                      : relatedTopicText.value.toLowerCase() == "forums"
                                      ? _forumsRelatedResponse : relatedTopicText.value.toLowerCase() == "surveys"
                                      ? _surveysRelatedResponse
                                      : _newsRelatedResponse,
                                  initFunction:
                                  getAllData,
                                  modelSetState:
                                  setState,
                                  exchangeList:
                                  exchangeValueList,)
                                    : Container(
                                    height: 200,
                                    child: Center(
                                      child: Lottie.asset(
                                          'lib/Constants/Assets/SMLogos/loading.json',
                                          height: 100,
                                          width: 100),
                                    )),*/
                                noSimilarData
                                    ? Center(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 150, width: 150, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: 'No similar posts found',
                                                      //style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                                                      style: Theme.of(context).textTheme.labelLarge!.copyWith(color: const Color(0XFF0EA102))),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : NotificationListener<OverscrollIndicatorNotification>(
                                        onNotification: (overflow) {
                                          overflow.disallowIndicator();
                                          return true;
                                        },
                                        child: ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _featuresRelatedResponse.response.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return GestureDetector(
                                                onTap: () async {
                                                  currentFeatureId.value = _featuresRelatedResponse.response[index].id;
                                                  getAllData();
                                                  /* Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return FeaturePostDescriptionPage(
                                                    sortValue: widget.sortValue,
                                                    featureId: _featuresRelatedResponse.response[index].id,
                                                    featureDetail: "",
                                                    navBool: 'feature', idList:featureIdList,
                                                  );
                                                }));*/
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(bottom: height / 35),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.onBackground /*Colors.white*/,
                                                    borderRadius: BorderRadius.circular(20),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Theme.of(context).colorScheme.tertiary /*Colors.grey.withOpacity(0.1)*/,
                                                          blurRadius: 4,
                                                          spreadRadius: 0)
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: height / 47.9,
                                                      ),
                                                      Container(
                                                        color: Theme.of(context).colorScheme.onBackground, //Colors.white,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return UserBillBoardProfilePage(
                                                                              userId: _featuresRelatedResponse.response[index].id)
                                                                          /*UserProfilePage(
                                                                        id: _featuresRelatedResponse.response[index].id,
                                                                        type: 'feature',
                                                                        index: 2)*/
                                                                          ;
                                                                    }));
                                                                  },
                                                                  child: Container(
                                                                    height: height / 13.53,
                                                                    width: width / 6.25,
                                                                    margin: EdgeInsets.symmetric(horizontal: width / 23.43),
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color: Colors.grey,
                                                                        image: DecorationImage(
                                                                            image: NetworkImage(_featuresRelatedResponse.response[index].user.avatar),
                                                                            fit: BoxFit.fill)),
                                                                  ),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    SizedBox(
                                                                        width: width / 1.95,
                                                                        child: Text(
                                                                          featureTitlesList[index],
                                                                          //  _featuresRelatedResponse.response[index].title,gf/.fj;
                                                                          style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                                        )),
                                                                    GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return UserBillBoardProfilePage(
                                                                                  userId: _featuresRelatedResponse.response[index].user.id)
                                                                              /*UserProfilePage(
                                                                            id:  _featuresRelatedResponse.response[index].user.id,
                                                                            type:
                                                                                'feature',
                                                                            index:
                                                                                2)*/
                                                                              ;
                                                                        }));
                                                                      },
                                                                      child: SizedBox(
                                                                          height: height / 54.13,
                                                                          child: Text(
                                                                            _featuresRelatedResponse.response[index].user.username
                                                                                .toString()
                                                                                .capitalizeFirst!,
                                                                            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500),
                                                                          )),
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
                                                                                  id: _featuresRelatedResponse.response[index].id, type: "feature");
                                                                              if (response1) {
                                                                                logEventFunc(name: "Likes", type: "Feature");
                                                                                setState(() {
                                                                                  if (featureUseList[index] == true) {
                                                                                    if (featureUseDisList[index] == true) {
                                                                                    } else {
                                                                                      featureLikeList[index] -= 1;
                                                                                    }
                                                                                  } else {
                                                                                    if (featureUseDisList[index] == true) {
                                                                                      featureDislikeList[index] -= 1;
                                                                                      featureLikeList[index] += 1;
                                                                                    } else {
                                                                                      featureLikeList[index] += 1;
                                                                                    }
                                                                                  }
                                                                                  featureUseList[index] = !featureUseList[index];
                                                                                  featureUseDisList[index] = false;
                                                                                });
                                                                              } else {}
                                                                            },
                                                                            child: Container(
                                                                              margin: EdgeInsets.only(right: width / 25),
                                                                              height: height / 40.6,
                                                                              width: width / 18.75,
                                                                              child: featureUseList[index]
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
                                                                              logEventFunc(name: "Share", type: "Feature");
                                                                              newLink = await getLinK(
                                                                                  id: _featuresRelatedResponse.response[index].id,
                                                                                  type: "feature",
                                                                                  description: '',
                                                                                  imageUrl: "",
                                                                                  title: _featuresRelatedResponse.response[index].title,
                                                                                  text: widget.sortValue);
                                                                              ShareResult result = await Share.share(
                                                                                "Look what I was able to find on Tradewatch: ${_featuresRelatedResponse.response[index].title} ${newLink.toString()}",
                                                                              );
                                                                              if (result.status == ShareResultStatus.success) {
                                                                                await shareFunction(
                                                                                    id: _featuresRelatedResponse.response[index].id, type: "feature");
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                                height: height / 40.6,
                                                                                width: width / 18.75,
                                                                                margin: EdgeInsets.only(right: width / 25),
                                                                                child: SvgPicture.asset(
                                                                                  isDarkTheme.value
                                                                                      ? "assets/home_screen/share_dark.svg"
                                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                                )),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              bool response3 = await disLikeFunction(
                                                                                  id: _featuresRelatedResponse.response[index].id, type: "feature");
                                                                              if (response3) {
                                                                                logEventFunc(name: "Dislikes", type: "Feature");
                                                                                setState(() {
                                                                                  if (featureUseDisList[index] == true) {
                                                                                    if (featureUseList[index] == true) {
                                                                                    } else {
                                                                                      featureDislikeList[index] -= 1;
                                                                                    }
                                                                                  } else {
                                                                                    if (featureUseList[index] == true) {
                                                                                      featureLikeList[index] -= 1;
                                                                                      featureDislikeList[index] += 1;
                                                                                    } else {
                                                                                      featureDislikeList[index] += 1;
                                                                                    }
                                                                                  }
                                                                                  featureUseDisList[index] = !featureUseDisList[index];
                                                                                  featureUseList[index] = false;
                                                                                });
                                                                              } else {}
                                                                            },
                                                                            child: Container(
                                                                              height: height / 40.6,
                                                                              width: width / 18.75,
                                                                              margin: EdgeInsets.only(right: width / 25),
                                                                              child: featureUseDisList[index]
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
                                                                          Container(
                                                                              height: height / 40.6,
                                                                              width: width / 18.75,
                                                                              margin: EdgeInsets.only(right: width / 25),
                                                                              child: SvgPicture.asset(
                                                                                "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                                colorFilter: ColorFilter.mode(
                                                                                    isDarkTheme.value
                                                                                        ? const Color(0XFFD6D6D6)
                                                                                        : const Color(0XFF0EA102),
                                                                                    BlendMode.srcIn),
                                                                              )),
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
                                                                          SizedBox(
                                                                            width: width / 7.5,
                                                                            child: Text(_featuresRelatedResponse.response[index].category,
                                                                                style: TextStyle(
                                                                                    fontSize: text.scale(10),
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Colors.blue)),
                                                                          ),
                                                                          SizedBox(width: width / 22.05),
                                                                          GestureDetector(
                                                                            onTap: () async {
                                                                              setState(() {
                                                                                viewCountMain = _featuresRelatedResponse.response[index].viewsCount;
                                                                                kUserSearchController.clear();
                                                                                onTapType = "Views";
                                                                                onTapId = _featuresRelatedResponse.response[index].id;
                                                                                onLike = false;
                                                                                onDislike = false;
                                                                                onViews = true;
                                                                                idKeyMain = "feature_id";
                                                                                apiMain = baseurl + versionFeature + viewsCount;
                                                                                onTapIdMain = _featuresRelatedResponse.response[index].id;
                                                                                onTapTypeMain = "Views";
                                                                                haveViewsMain =
                                                                                    _featuresRelatedResponse.response[index].viewsCount > 0
                                                                                        ? true
                                                                                        : false;
                                                                                viewCountMain = _featuresRelatedResponse.response[index].viewsCount;
                                                                                kToken = mainUserToken;
                                                                              });
                                                                              //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionFeature + viewsCount, idKey: 'feature_id', setState: setState);
                                                                              bool data =
                                                                                  await likeCountFunc(context: context, newSetState: setState);
                                                                              if (data) {
                                                                                if (!mounted) {
                                                                                  return;
                                                                                }
                                                                                customShowSheet1(context: context);
                                                                                setState(() {
                                                                                  loaderMain = true;
                                                                                });
                                                                              } else {
                                                                                if (!mounted) {
                                                                                  return;
                                                                                }
                                                                                Flushbar(
                                                                                  message: "Still no one has viewed this post",
                                                                                  duration: const Duration(seconds: 2),
                                                                                ).show(context);
                                                                              }
                                                                            },
                                                                            child: Row(
                                                                              children: [
                                                                                Text(_featuresRelatedResponse.response[index].viewsCount.toString(),
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                                Text(" views",
                                                                                    style: TextStyle(
                                                                                        fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(width: width / 22.05),
                                                                          Text(_featuresRelatedResponse.response[index].responseCount.toString(),
                                                                              style:
                                                                                  TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                          Text(" Response",
                                                                              style:
                                                                                  TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
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
                                                                              padding:
                                                                                  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                              child: mainUserId == _featuresRelatedResponse.response[index].user.id
                                                                                  ? ListTile(
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
                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                        20.0)), //this right here
                                                                                                child: Container(
                                                                                                  height: height / 6,
                                                                                                  margin: EdgeInsets.symmetric(
                                                                                                      vertical: height / 54.13,
                                                                                                      horizontal: width / 25),
                                                                                                  child: Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      const Center(
                                                                                                          child: Text("Delete Respond",
                                                                                                              style: TextStyle(
                                                                                                                  color: Color(0XFF0EA102),
                                                                                                                  fontWeight: FontWeight.bold,
                                                                                                                  fontSize: 20,
                                                                                                                  fontFamily: "Poppins"))),
                                                                                                      const Divider(),
                                                                                                      const Center(
                                                                                                          child: Text(
                                                                                                              "Are you sure to Delete this Post")),
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
                                                                                                                // await deletePost(featureId: _featuresRelatedResponse.response[index].id, similarNew: true);
                                                                                                                //await getResponses(featureId: _featureResponse.response.id, type: selectedValue);
                                                                                                                await getRelatedFeatures(
                                                                                                                    featureId: currentFeatureId.value,
                                                                                                                    category: _featureResponse
                                                                                                                        .response.category);
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
                                                                                        style: TextStyle(
                                                                                            fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                                                                      ),
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
                                                                                                featureId:
                                                                                                    _featuresRelatedResponse.response[index].id,
                                                                                                featureUserId:
                                                                                                    _featuresRelatedResponse.response[index].user.id,
                                                                                                messageId: "",
                                                                                                checkWhich: 'similar');
                                                                                          },
                                                                                          minLeadingWidth: width / 25,
                                                                                          leading: const Icon(
                                                                                            Icons.shield,
                                                                                            size: 20,
                                                                                          ),
                                                                                          title: Text(
                                                                                            "Report Post",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontSize: text.scale(14)),
                                                                                          ),
                                                                                        ),
                                                                                        const Divider(
                                                                                          thickness: 0.0,
                                                                                          height: 0.0,
                                                                                        ),
                                                                                        ListTile(
                                                                                          onTap: () {
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
                                                                                                featureId:
                                                                                                    _featuresRelatedResponse.response[index].id,
                                                                                                featureUserId:
                                                                                                    _featuresRelatedResponse.response[index].user.id,
                                                                                                messageId: "",
                                                                                                checkWhich: 'similar');
                                                                                          },
                                                                                          minLeadingWidth: width / 25,
                                                                                          leading: const Icon(
                                                                                            Icons.flag,
                                                                                            size: 20,
                                                                                          ),
                                                                                          title: Text(
                                                                                            "Block Post",
                                                                                            style: TextStyle(
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontSize: text.scale(14)),
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
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(right: width / 24),
                                                                  child: widgetsMain.translationWidget(
                                                                    id: _featuresRelatedResponse.response[index].id,
                                                                    type: 'feature',
                                                                    index: index,
                                                                    initFunction: getAllData,
                                                                    context: context,
                                                                    modelSetState: setState,
                                                                    notUse: false,
                                                                    translationList: featureTranslationList,
                                                                    titleList: featureTitlesList,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height / 47.9,
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                              ],
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
                          file1 = doc!.paths.map((path) => File(path!)).toList(); //file1 is a global variable which i created
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
      {required BuildContext context,
      required String featureId,
      required String featureUserId,
      required String messageId,
      required String checkWhich}) {
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
                        logEventFunc(
                            name: actionValue == "Report" ? 'Reported_Feature_response' : 'Blocked_Feature_response', type: 'Feature Response');
                        await reportResponsePost(
                            messageId: messageId,
                            featureUserId: featureUserId,
                            why: whyValue,
                            description: _controller.text,
                            featureId: featureId,
                            action: actionValue);
                      } else {
                        logEventFunc(name: actionValue == "Report" ? 'Reported_Post' : 'Blocked_Post', type: 'Feature');
                        await reportPost(
                            action: actionValue,
                            why: whyValue,
                            description: _controller.text,
                            featureId: featureId,
                            messageId: messageId,
                            featureUserId: featureUserId);
                      }
                      if (checkWhich == 'similar') {
                        // await getRelatedFeatures(featureId: featureObject['_id'], category: featureObject['category']);
                        await getResponses(featureId: _featureResponse.response.id, type: selectedValue);
                      } else {
                        await getResponses(featureId: _featureResponse.response.id, type: selectedValue);
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
            return SingleChildScrollView(
              child: AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                content: Column(
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
                                                Navigator.push(context, MaterialPageRoute(builder: (_) {
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
                          style:
                              TextStyle(color: const Color(0XFFB0B0B0), fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400),
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
                    /*TextFormField(
                      controller: _editController,
                      minLines: 4,
                      style: TextStyle(
                          fontSize: _text.scale(100)14,
                          fontWeight: FontWeight.w500,
                          color: Color(0XFFA0AEC0)),
                      keyboardType: TextInputType.name,
                      maxLines: 4,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: _width / 26.78,
                            vertical: _height / 50.75),
                        hintText: "Enter a description...",
                        hintStyle: TextStyle(
                            fontSize: _text.scale(100)14,
                            fontWeight: FontWeight.w500,
                            color: Color(0XFFA0AEC0)),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0XFFE2E8F0), width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0XFFE2E8F0), width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0XFFE2E8F0), width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0XFFE2E8F0), width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),*/
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
                            featureId: _featureResponse.response.id,
                            category: _featureResponse.response.category,
                            cId: _featureResponse.response.category == "stocks"
                                ? mainCatIdList[0]
                                : _featureResponse.response.category == "crypto"
                                    ? mainCatIdList[1]
                                    : _featureResponse.response.category == "commodity"
                                        ? mainCatIdList[2]
                                        : _featureResponse.response.category == "forex"
                                            ? mainCatIdList[3]
                                            : "",
                            message: _editController.text,
                            messageId: messageId,
                            selectedBool: true);
                        await getResponses(featureId: _featureResponse.response.id, type: selectedValue);
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
            );
          },
        );
      },
    );
  }

  List<TextSpan> spanList({
    required String message,
    required BuildContext context,
  }) {
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
