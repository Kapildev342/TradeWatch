import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:tradewatchfinal/Screens/Module1/HomeScreen/home_search_model.dart';
import 'package:tradewatchfinal/Screens/Module1/HomeScreen/home_search_ticker_model.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_main_page_model.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/videos_main_page_model.dart';
import 'package:tradewatchfinal/Screens/Module1/my_activity_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forums_main_page_model.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_main_page_model.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkOverAll/book_mark_over_view_model.dart';
import 'package:tradewatchfinal/Screens/Module4/LTICalculator/LTIPageModel/lti_page_initial_model.dart';
import 'package:tradewatchfinal/Screens/Module4/LTICalculator/lti_calculator_functions.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerCalculatorScreen/calculator_page_design_model.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerEssentialPage/LockerEssentialModels/exchange_list_model.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerEssentialPage/LockerEssentialModels/locker_dividend_essential_model.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerEssentialPage/LockerEssentialModels/locker_dividend_history_model.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerEssentialPage/LockerEssentialModels/locker_essential_model_file.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerEssentialPage/LockerEssentialModels/locker_ipo_essential_model.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerEssentialPage/LockerEssentialModels/locker_split_essential_model.dart';
import 'package:tradewatchfinal/Screens/Module4/LockerScreen/locker_screen_model.dart';
import 'package:tradewatchfinal/Screens/Module5/Charts/FinalChartPage/over_view_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/believers_list_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_features_list_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_like_dislike_users_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_main_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_repost_list_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/popular_traders_model.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/user_search_data_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/focused_menu.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/contact_users_list_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_users_list_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/get_documets_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/messages_list_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/categories_list_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/commodity_countries_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_comments_initial_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_description_responses_list_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_details_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_list_page_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_page_initial_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_post_list_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_post_request_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_response_list_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/crypto_industries_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/exchanges_list_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/industries_list_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/members_list_api_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/post_limitation_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/tickers_list_page_model.dart';
import 'package:tradewatchfinal/Screens/Module8/Payment/plan_choosing_initial_model.dart';

class CommonVariable {
  //Rx model
  Rx<UserSearchDataModel>? searchDataMain;
  Rx<PopularTradersModel>? popularSearchDataMain;
  Rx<OverViewModel>? overViewMain;
  Rx<NewsMainPageModel>? newsDataMain;
  Rx<VideosMainPageModel>? videosDataMain;
  Rx<SurveyMainPageModel>? surveyDataMain;
  Rx<ForumsMainPageModel>? forumDataMain;
  Rx<BillboardMainModel>? billBoardDataProfilePage;
  Rx<BillboardFeaturesListModel>? billBoardFeaturesList;
  Rx<BookMarkOverviewModel>? bookMarkOverViewAllMain;
  Rx<BillBoardLikeDisLikeUsersModel>? usersLikeDislikeViewList;
  Rx<BillBoardRepostListModel>? billBoardRepostList;
  Rx<MessageListModel>? messagesList;
  Rx<GetDocumentsModel>? getDocument;
  Rx<ReceivedSocketDataModel>? receivedSocketData;
  Rx<ConversationUsersListModel>? conversationUsers;
  Rx<ConversationUsersListModel>? activeUsers;
  Rx<ActivityList>? fetchMaterialMain;
  Rx<ConversationUserData> conversationUserData =
      ConversationUserData(userId: "", avatar: "", firstName: "", lastName: "", userName: "", isBelieved: false).obs;

  //Rx List Classes
  RxList<ChatMessage> messagesListMain = RxList<ChatMessage>([]);

  //Rx bool List
  RxList<bool> popularSearchDataBelievedList = RxList<bool>([]);
  RxList<bool> isUserTaggingList = RxList<bool>([]);
  RxList<bool> isUserTaggingRelatedList = RxList<bool>([]);
  RxList<List<bool>> allCategoriesLikesListMain = RxList<List<bool>>([]);
  RxList<List<bool>> allCategoriesDislikesListMain = RxList<List<bool>>([]);
  RxList<List<bool>> allCategoriesBookmarksListMain = RxList<List<bool>>([]);
  RxList<List<bool>> allCategoriesTranslationListMain = RxList<List<bool>>([]);
  RxList<List<bool>> bookMarKTotalList = RxList<List<bool>>([]);
  RxList<bool> isCheckedConversationList = RxList<bool>([]);
  RxList<bool> isActiveStatusList = RxList<bool>([]);
  RxList<bool> isActiveStatusSendList = RxList<bool>([]);
  RxList<bool> isActiveStatusUsersList = RxList<bool>([]);
  RxList<String> isLastActiveUsersList = RxList<String>([]);
  RxList<String> isLastActiveList = RxList<String>([]);
  RxList<String> isLastActiveSendList = RxList<String>([]);
  RxList<BillBoardLikeDisLikeUsersResponse> likeDisLikeUserSearchDataList = RxList<BillBoardLikeDisLikeUsersResponse>([]);
  RxList<IndividualChatUserResponse> chatUserList = RxList<IndividualChatUserResponse>([]);
  RxList<IndividualChatUserResponse> chatUserSendList = RxList<IndividualChatUserResponse>([]);
  RxList<IndividualChatUserResponse> activeUserList = RxList<IndividualChatUserResponse>([]);
  RxList<ContactUsersListResponse> usersList = RxList<ContactUsersListResponse>([]);
  RxList<UsersListResponse> believedUsersList = RxList<UsersListResponse>([]); //believed,believers,nonbelievers,repost users all

  //Rx List Model
  RxList<BillboardMainModelResponse> valueMapListProfilePage = RxList<BillboardMainModelResponse>([]);
  RxList<BillboardMainModelResponse> valueMapListProfileRelatedPage = RxList<BillboardMainModelResponse>([]);
  RxList<UserSearchDataResponse> userSearchDataList = RxList<UserSearchDataResponse>([]);

  //Rx String List
  RxList<List<String>> allCategoriesIdListMain = RxList<List<String>>([]);
  RxList<List<String>> allCategoriesTitleListMain = RxList<List<String>>([]);
  RxList<String> contentCategoriesMain = RxList<String>([]);
  RxList<String> selectedUrlTypeMain = RxList<String>([]);
  RxList<String> selectedUrlTypeRelatedMain = RxList<String>([]);
  RxList<String> messageSentList = RxList<String>([]);
  RxList<String> searchResultMain = RxList<String>([]);
  RxList<String> searchLogoMain = RxList<String>([]);
  RxList<String> searchIdResultMain = RxList<String>([]);
  RxList<List<String>> allCategoriesUserNameListMain = RxList<List<String>>([]);
  RxList<List<String>> allCategoriesProfileTypeListMain = RxList<List<String>>([]);
  RxList<List<String>> allCategoriesTickerIdListMain = RxList<List<String>>([]);

  //Rx int List
  RxList<List<int>> allCategoriesLikesCountListMain = RxList<List<int>>([]);
  RxList<List<int>> allCategoriesDislikesCountListMain = RxList<List<int>>([]);
  RxList<List<int>> allCategoriesResponseCountListMain = RxList<List<int>>([]);
  RxList<List<int>> allCategoriesViewsCountListMain = RxList<List<int>>([]);

  //Rx String
  RxString selectedUrlTypeSingle = "".obs;
  RxString selectedBillBoardTypeMain = "".obs;
  RxString searchTabMain = 'user'.obs;
  RxString contentTypeMain = "".obs;
  RxString dateRangeMain = "".obs;
  RxString sortTypeMain = "".obs;
  RxString selectedProfileMain = "user".obs;
  RxString sentimentTypeMain = "".obs;
  RxString activeTypeMain = 'trending'.obs;
  RxString selectedBillboardIdMain = ''.obs;
  RxString selectedResponseSortTypeMain = ''.obs;
  RxString selectedCommentsSortTypeMain = ''.obs;
  RxString selectedCommentsFilter = 'general'.obs;
  RxString selectedTickerId = "".obs;
  RxString isBelievedBefore = "before".obs;
  RxString isEditingMessageId = "".obs;
  RxString isReplyingMessageId = "".obs;
  RxString isReplyingMessage = "".obs;
  RxString isLastActiveTime = "".obs;
  RxString currentScrollPositionTime = "".obs;
  RxString searchUserIdMain = "".obs;
  RxString recentMessageChangeDate = "".obs;
  RxString initialPostDate = "".obs;
  RxString initialPostRelatedDate = "".obs;
  RxString forwardMessage = "".obs;

  //Rx Bool
  RxBool isFirstTime = true.obs;
  RxBool userBelievedProfileSingle = false.obs;
  RxBool isJourney = false.obs;
  RxBool isGroupCreated = false.obs;
  RxBool isChatOpen = false.obs;
  RxBool isRecording = false.obs;
  RxBool isReplying = false.obs;
  RxBool isUserTagging = false.obs;
  RxBool isUserTaggingLoader = false.obs;
  RxBool isEditing = false.obs;
  RxBool isGeneralConversationList = true.obs;
  RxBool isUserActive = false.obs;
  RxBool isMicPressed = false.obs;
  RxBool isUserTagged = false.obs;
  RxBool isUserResponseTagged = false.obs;

  //Rx Int
  RxInt selectedControllerIndex = 0.obs;
  RxInt selectedUserControllerIndex = 0.obs;
  RxInt selectedIntermediaryControllerIndex = 0.obs;
  RxInt believersCountMainMyself = 0.obs;
  RxInt recordingIndexMain = 0.obs;
  RxInt editingIndexMain = 0.obs;
  RxInt messageListSkipCount = 0.obs;
  RxInt latestFeedCounts = 0.obs;
  RxInt singleBelievedMain = 0.obs;

  //Rx TextEditing Controller
  Rx<TextEditingController> billBoardSearchControllerMain = TextEditingController().obs;
  Rx<TextEditingController> popularSearchControllerMain = TextEditingController().obs;
  Rx<TextEditingController> billBoardListSearchControllerMain = TextEditingController().obs;
  Rx<TextEditingController> listDislikeUsersSearchControllerMain = TextEditingController().obs;
  Rx<TextEditingController> believersListSearchControllerMain = TextEditingController().obs;
  Rx<TextEditingController> believedListSearchControllerMain = TextEditingController().obs;
  Rx<TextEditingController> sendMessageListSearchControllerMain = TextEditingController().obs;
  Rx<TextEditingController> messageControllerMain = TextEditingController().obs;
  Rx<TextEditingController> billboardSingleControllerMain = TextEditingController().obs;

  //String List
  List<String> aboutMeListMain = [];
  List<String> avatarListMain = [];
  List<String> actionListMain = ["Report", "Block"];
  List<String> whyListMain = ["Scam", "Abusive Content", "Spam", "Other"];

  //FocusNode List
  List<FocusNode> focusNodes = List<FocusNode>.generate(
    18,
    (int i) => FocusNode(debugLabel: 'Onboarding Focus Node $i'),
    growable: false,
  );
  List<FocusNode> responseFocusList = [];
  List<FocusNode> responseFocusRelatedList = [];

  //Image Picking
  List<File?> pickedImageMain = [];
  List<File?> pickedImageRelatedMain = [];
  File? pickedImageSingle;
  List<File?> pickedVideoMain = [];
  List<File?> pickedVideoRelatedMain = [];
  File? pickedVideoSingle;
  List<File?> pickedFileMain = [];
  List<File?> pickedFileRelatedMain = [];
  File? pickedFileSingle;
  List<FilePickerResult?> docMain = [];
  List<FilePickerResult?> docRelatedMain = [];
  FilePickerResult? docSingle;
  List<List<File>> docFilesMain = [];
  List<List<File>> docFilesRelatedMain = [];
  List<File> docFilesSingle = [];

  File? pickedImageGroupSingle;

  //String
  String userNameMyselfMain = "";
  String firstNameMyselfMain = "";
  String lastNameMyselfMain = "";
  String actionValueMain = "Report";
  String whyValueMain = "Scam";

  //Refresh Controller
  RefreshController likeDislikeRefreshController = RefreshController(initialRefresh: false, initialLoadStatus: LoadStatus.idle);

  //TextEditingController
  TextEditingController barController = TextEditingController();
  RecorderController recorderController = RecorderController()
    ..androidEncoder = AndroidEncoder.aac
    ..androidOutputFormat = AndroidOutputFormat.mpeg4
    ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
    ..sampleRate = 44100;

  //Socket
  io.Socket? socket;

  //Directory
  Directory? appDirectory;
  List<FileElement> attachmentEditFiles = [];
  RxList<AudioPlayer> audioPlayerList = RxList<AudioPlayer>([]);
  RxList<bool> isPlayingList = RxList<bool>([]);
  RxList<bool> isLoadingList = RxList<bool>([]);
  RxList<int> totalTimeList = RxList<int>([]);
  RxList<int> currentTimeList = RxList<int>([]);

  ReplyUser replyUserDataMain = ReplyUser.fromJson({});
  ShortDynamicLink? dynamicLink;
  List<TextEditingController> responseControllerList = [];
  List<TextEditingController> responseControllerRelatedList = [];
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  int maxFailedLoadAttempts = 3;
}

class CommonHomeVariable {
  Rx<TextEditingController> searchControllerMain = TextEditingController().obs;

  Rx<HomeSearchModel>? homeSearchDataMain;
  Rx<HomeSearchTickerModel> homeSearchTickerDataMain =
      HomeSearchTickerModel.fromJson({"status": false, "message": "ticker not found", "response": []}).obs;

  RxList<HomeSearchResponse> homeSearchResponseData = RxList<HomeSearchResponse>([]);

  RxString activeStatusMain = "".obs;
  RxString searchTabType = "news".obs;

  RxInt answeredQuestionMain = 0.obs;
  RxInt homeCategoriesTabIndexMain = 0.obs;
  RxInt homeExchangesTabIndexMain = 0.obs;
  RxInt homeCountriesTabIndexMain = 0.obs;

  RxBool answerStatusMain = false.obs;
  RxBool tabSearchLoader = false.obs;
  RxBool bannerAdIsLoadedMain = false.obs;
}

class CommonWatchListVariable {
  RxInt watchListCountTotalMain = 0.obs;
  RxInt alertCountCountTotalMain = 0.obs;
  RxInt billBoardSearchCountCountTotalMain = 0.obs;
  RxInt chartModificationCountTotalMain = 0.obs;
  RxInt postCountTotalMain = 0.obs;
}

class CommonAdVariables {
  AdRequest request = const AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  Rx<int> numInterstitialLoadAttempts = 0.obs;
  Rx<int> maxFailedLoadAttemptsMain = 3.obs;

  Rx<bool> adShown = true.obs;

  ///Live
   String bannerAdUnitId =Platform.isAndroid
      ? 'ca-app-pub-1999123438283650/4543441748'
      : 'ca-app-pub-1999123438283650/8833457382';

  String nativeAdUnitId =Platform.isAndroid
      ? 'ca-app-pub-1999123438283650/2298877193'
      : 'ca-app-pub-1999123438283650/6653166542';

  String interstitialAdUnitId =Platform.isAndroid
      ? 'ca-app-pub-1999123438283650/7553576440'
      : 'ca-app-pub-1999123438283650/8398343113';

  /*
  App Open- ca-app-pub-3940256099942544/9257395921
  Adaptive Banner- ca-app-pub-3940256099942544/9214589741
  Banner- ca-app-pub-3940256099942544/6300978111
  Interstitial- ca-app-pub-3940256099942544/1033173712
  Interstitial Video- ca-app-pub-3940256099942544/8691691433
  Rewarded- ca-app-pub-3940256099942544/5224354917
  Rewarded Interstitial- ca-app-pub-3940256099942544/5354046379
  Native Advanced- ca-app-pub-3940256099942544/2247696110
  Native Advanced Video- ca-app-pub-3940256099942544/1044960115*/

  ///debug
  /*String bannerAdUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716';

  String nativeAdUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/2247696110' : 'ca-app-pub-3940256099942544/3986624511';

  String interstitialAdUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/1033173712' : 'ca-app-pub-3940256099942544/4411468910';*/
}

class CommonLockerVariables {
  Rx<LockerEssentialModel>? lockerEssentials;
  Rx<LockerIpoEssentialModel>? lockerIPOEssentials;
  Rx<LockerSplitEssentialModel>? lockerSplitEssentials;
  Rx<LockerDividendEssentialModel>? lockerDividendEssentials;
  Rx<LockerDividendHistoryModel>? lockerDividendHistory;
  RxList<LockerEssentialResponse> lockerEssentialResponseList = RxList<LockerEssentialResponse>([]);
  RxList<LockerIpoEssentialResponse> lockerIpoEssentialResponseList = RxList<LockerIpoEssentialResponse>([]);
  RxList<LockerSplitEssentialResponse> lockerSplitEssentialResponseList = RxList<LockerSplitEssentialResponse>([]);
  RxList<LockerDividendEssentialResponse> lockerDividendEssentialResponseList = RxList<LockerDividendEssentialResponse>([]);
  RxList<LockerDividendHistoryResponse> lockerDividendHistoryResponseList = RxList<LockerDividendHistoryResponse>([]);
  RxList<Widget> titleRowMain = RxList<Widget>([]);
  RxList<Widget> titleDividendsHistoryRowMain = RxList<Widget>([]);
  RxList<String> titleColumnMain = RxList<String>([]);
  RxList<String> titleDividendsHistoryColumnMain = RxList<String>([]);
  RxList<String> sortListMain = RxList<String>([]);
  RxList<List<String>> matrixDataMain = RxList<List<String>>([]);
  RxList<List<String>> matrixDividendsHistoryDataMain = RxList<List<String>>([]);
  Rx<TextEditingController> searchEssentialControllerMain = TextEditingController().obs;
  Rx<String> selectedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()).obs;
  Rx<String> selectedPeriod = "quater".obs;
  Rx<String> selectedCategory = "general".obs;
  Rx<double> minValue = 0.0.obs;
  Rx<double> maxValue = 1.0.obs;
  Rx<double> initialValue = 0.15.obs;
  Rx<bool> isIndia = true.obs;
  RxList<bool> isDeletingEnabled = RxList<bool>([]);
  Rx<double> dollarValue = 0.0.obs;
  Rx<double> purchaseValue = 150000.00.obs;
  RxMap<String, dynamic> selectedSortValue = RxMap<String, dynamic>({});
  RxString selectedIPOSlugType = "start_date".obs;
  RxList<String> categoriesList = ["Stocks", "Crypto", "Commodity", "Forex"].obs;
  RxList<String> categoriesImagesList = [
    "lib/Constants/Assets/SMLogos/LockerScreen/Chart.svg",
    "lib/Constants/Assets/SMLogos/LockerScreen/Bitcoin.svg",
    "lib/Constants/Assets/SMLogos/LockerScreen/Commodity Icon (2).png",
    "lib/Constants/Assets/SMLogos/LockerScreen/Forex Icon.png"
  ].obs;
  RxList<ExchangesListResponse> industriesListMain = RxList<ExchangesListResponse>([]);
  RxList<String> selectedIndustriesListMain = RxList<String>([]);
  RxList<Widget> categoryImagesList = RxList<Widget>([]);
  Rx<Widget> selectedCategoryWidget = Container().obs;
  RxList<FocusedMenuItem> filterMenuList = RxList<FocusedMenuItem>([]);
  Rx<TextEditingController> searchControllerMain = TextEditingController().obs;
  Rx<TextEditingController> searchChartControllerMain = TextEditingController().obs;
  Rx<TextEditingController> searchIndustriesBottomSheetControllerMain = TextEditingController().obs;
  Rx<TextEditingController> calculatorTextControl = TextEditingController().obs;
  List<List<String>> calculatorSelectedTickersList = [];
  LockerScreenModel lockerScreenContents = LockerScreenModel.fromJson({
    "response": [
      {
        "topic": "Buzz",
        "responseList": [
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/news_buzz.png", "name": "News"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/videos_buzz.png", "name": "Videos"}
        ]
      },
      {
        "topic": "Essentials",
        "responseList": [
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/charts_essentials.png", "name": "Charts"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/earning_essentials.png", "name": "Earning"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/IPO_essentials.png", "name": "IPO"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/splits_essentials.png", "name": "Splits"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/dividends_essentials.png", "name": "Dividends"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/LTI_essentials.png", "name": "LTI"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/calculator_essentials.png", "name": "Calculator"}
        ]
      },
      {
        "topic": "Community",
        "responseList": [
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/forum_community.png", "name": "Forum"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/survey_community.png", "name": "Survey"}
        ]
      },
      {
        "topic": "Services",
        "responseList": [
          {"imageUrl": "lib/Constants/Assets/NewAssets/LockerScreen/broker_services.png", "name": "Brokers"}
        ]
      }
    ]
  });
  Map<String, dynamic> calculatorContentData = RxMap<String, dynamic>({
    "response": [
      {
        "topic": "Stocks",
        "imageUrl": "lib/Constants/Assets/SMLogos/LockerScreen/Chart.svg",
        "responseList": [
          {
            "name": "nse",
            "ticker": {
              "id": "6267870c8bbdb6e89bb687f3",
              "imageUrl": "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/tickers/1664222405848.png",
              "name": "Tata Motors Limited",
              "category": "stocks",
              "exchange": "NSE",
              "country": "India",
              "code": "TATAMOTORS",
              "value": "3714",
              "fromWhere": "calculator"
            }
          },
          {
            "name": "bse",
            "ticker": {
              "id": "626786bca8ba4d81b075d526",
              "imageUrl": "https://eodhistoricaldata.com/img/logos/BSE/500033.png",
              "name": "Force Motors Limited",
              "category": "stocks",
              "exchange": "BSE",
              "country": "India",
              "code": "500033",
              "value": "3714",
              "fromWhere": "calculator"
            }
          },
          {
            "name": "indx",
            "ticker": {
              "id": "626786bca8ba4d81b075d526",
              "imageUrl": "https://eodhistoricaldata.com/img/logos/BSE/500033.png",
              "name": "Force Motors Limited",
              "category": "stocks",
              "exchange": "INDX",
              "country": "India",
              "code": "500033",
              "value": "3714",
              "fromWhere": "calculator"
            }
          },
          {
            "name": "usastocks",
            "ticker": {
              "id": "626786bca8ba4d81b075d526",
              "imageUrl": "https://eodhistoricaldata.com/img/logos/BSE/500033.png",
              "name": "Force Motors Limited",
              "category": "stocks",
              "exchange": "USA",
              "country": "USA",
              "code": "500033",
              "value": "3714",
              "fromWhere": "calculator"
            }
          },
          {
            "name": "indx",
            "ticker": {
              "id": "626786bca8ba4d81b075d526",
              "imageUrl": "https://eodhistoricaldata.com/img/logos/BSE/500033.png",
              "name": "Force Motors Limited",
              "category": "stocks",
              "exchange": "INDX",
              "country": "USA",
              "code": "500033",
              "value": "3714",
              "fromWhere": "calculator"
            }
          }
        ]
      },
      {
        "topic": "Crypto",
        "imageUrl": "lib/Constants/Assets/SMLogos/LockerScreen/Bitcoin.svg",
        "responseList": [
          {
            "name": "coin",
            "ticker": {
              "id": "626786bca8ba4d81b075d526",
              "imageUrl": "https://eodhistoricaldata.com/img/logos/BSE/500033.png",
              "name": "Force Motors Limited",
              "category": "stocks",
              "exchange": "BSE",
              "country": "India",
              "code": "500033",
              "value": "3714",
              "fromWhere": "calculator"
            }
          },
          {
            "name": "token",
            "ticker": {
              "id": "626786bca8ba4d81b075d526",
              "imageUrl": "https://eodhistoricaldata.com/img/logos/BSE/500033.png",
              "name": "Force Motors Limited",
              "category": "stocks",
              "exchange": "BSE",
              "country": "India",
              "code": "500033",
              "value": "3714",
              "fromWhere": "calculator"
            }
          }
        ]
      },
      {
        "topic": "Commodity",
        "imageUrl": "lib/Constants/Assets/SMLogos/LockerScreen/Commodity Icon (2).png",
        "responseList": [
          {
            "name": "india",
            "ticker": {
              "id": "626786bca8ba4d81b075d526",
              "imageUrl": "https://eodhistoricaldata.com/img/logos/BSE/500033.png",
              "name": "Force Motors Limited",
              "category": "stocks",
              "exchange": "BSE",
              "country": "India",
              "code": "500033",
              "value": "3714",
              "fromWhere": "calculator"
            }
          },
          {
            "name": "usa",
            "ticker": {
              "id": "626786bca8ba4d81b075d526",
              "imageUrl": "https://eodhistoricaldata.com/img/logos/BSE/500033.png",
              "name": "Force Motors Limited",
              "category": "stocks",
              "exchange": "BSE",
              "country": "USA",
              "code": "500033",
              "value": "3714",
              "fromWhere": "calculator"
            }
          }
        ]
      },
      {
        "topic": "Forex",
        "imageUrl": "lib/Constants/Assets/SMLogos/LockerScreen/Forex Icon.png",
        "responseList": [
          {
            "name": "inrusd",
            "ticker": {
              "id": "626786bca8ba4d81b075d526",
              "imageUrl": "https://eodhistoricaldata.com/img/logos/BSE/500033.png",
              "name": "Force Motors Limited",
              "category": "stocks",
              "exchange": "BSE",
              "country": "India",
              "code": "500033",
              "value": "3714",
              "fromWhere": "calculator"
            }
          }
        ]
      }
    ]
  });
  Rx<CalculatorPageDesignModel>? calculatorPageContents;
  RxList<ResponseList> lockerBuzzList = RxList<ResponseList>([]);
  RxList<ResponseList> lockerEssentialsList = RxList<ResponseList>([]);
  RxList<ResponseList> lockerCommunityList = RxList<ResponseList>([]);
  RxList<ResponseList> lockerServicesList = RxList<ResponseList>([]);
  RxList<ResponseList> lockerBuzzListMain = RxList<ResponseList>([]);
  RxList<ResponseList> lockerEssentialsListMain = RxList<ResponseList>([]);
  RxList<ResponseList> lockerCommunityListMain = RxList<ResponseList>([]);
  RxList<ResponseList> lockerServicesListMain = RxList<ResponseList>([]);
  LockerScreenModel chartScreenContents = (LockerScreenModel.fromJson({
    "response": [
      {
        "topic": "Trend",
        "responseList": [
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/line_trend.png", "name": "Line", "id": "2"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/area_trend.png", "name": "Area", "id": "3"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/baseline_trend.png", "name": "Baseline", "id": "5"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/high_low_trend.png", "name": "High_Low", "id": "6"}
        ]
      },
      {
        "topic": "Volatility",
        "responseList": [
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/candle_volatility.png", "name": "Candle", "id": "1"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/hollow_volatility.png", "name": "Hallow", "id": "12"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/heikin_ashi_volatility.png", "name": "Heikin Ashi", "id": "11"}
        ]
      },
      {
        "topic": "Basic",
        "responseList": [
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/bar_basic.png", "name": "Bar", "id": "0"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/column_basic.png", "name": "Column", "id": "4"}
        ]
      },
      {
        "topic": "Pattern",
        "responseList": [
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/renko_pattern.png", "name": "Renko", "id": "7"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/point_fig_pattern.png", "name": "Point & Fig", "id": "9"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/kagi-pattern.png", "name": "Kagi", "id": "8"},
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/line_break_pattern.png", "name": "Line Break", "id": "10"}
        ]
      },
      {
        "topic": "Comparison",
        "responseList": [
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/compare_comparison.png", "name": "Compare", "id": "-1"}
        ]
      },
      {
        "topic": "Request",
        "responseList": [
          {"imageUrl": "lib/Constants/Assets/NewAssets/ChartsScreen/request.png", "name": "Request", "id": "14"}
        ]
      }
    ]
  }));
  RxList<ResponseList> chartsTrendList = RxList<ResponseList>([]);
  RxList<ResponseList> chartsVolatilityList = RxList<ResponseList>([]);
  RxList<ResponseList> chartsBasicList = RxList<ResponseList>([]);
  RxList<ResponseList> chartsPatternList = RxList<ResponseList>([]);
  RxList<ResponseList> chartsComparisonList = RxList<ResponseList>([]);
  RxList<ResponseList> chartsRequestList = RxList<ResponseList>([]);
  RxList<ResponseList> chartsTrendListMain = RxList<ResponseList>([]);
  RxList<ResponseList> chartsVolatilityListMain = RxList<ResponseList>([]);
  RxList<ResponseList> chartsBasicListMain = RxList<ResponseList>([]);
  RxList<ResponseList> chartsPatternListMain = RxList<ResponseList>([]);
  RxList<ResponseList> chartsComparisonListMain = RxList<ResponseList>([]);
  RxList<ResponseList> chartsRequestListMain = RxList<ResponseList>([]);

  Rx<LTIPageInitialModel>? longTermInitialData;
  Rx<TextEditingController> longTermDateController = TextEditingController().obs;
  Rx<TextEditingController> longTermCategory = TextEditingController().obs;
  Rx<TextEditingController> longTermTicker = TextEditingController().obs;
  Rx<TextEditingController> longTermInputAmount = TextEditingController().obs;
  Rx<TextEditingController> purchasedQuantityController = TextEditingController().obs;
  RxInt longTermSelectedCategoryIndex = 0.obs;
  RxList<ChartData> longTermChartDataList = RxList<ChartData>([]);
  Rx<int> minYValue = 0.obs;
  Rx<DateTime> minXValue = (DateTime.now()).obs;
  Rx<int> maxYValue = 0.obs;
  Rx<DateTime> maxXValue = (DateTime.now()).obs;
  Rx<bool> isLongTermPrice = true.obs;
}

class CommonCommunityVariables {
  Rx<CommunitiesListInitialPage> communityHomeList = (CommunitiesListInitialPage.fromJson({"trending_data": [], "community_list_data": []})).obs;
  Rx<bool> isSeeAllViewEnabled = false.obs;

  File? selectedImageForCommunity;
  Rx<TextEditingController> communityController = TextEditingController().obs;
  Rx<TextEditingController> aboutController = TextEditingController().obs;
  Rx<TextEditingController> rulesController = TextEditingController().obs;
  Rx<TextEditingController> categoriesController = TextEditingController().obs;
  Rx<CategoriesListModel> categoriesList = (CategoriesListModel.fromJson({
    "response": [
      {"name": "General", "id": "", "slug": "general", "image_url": "lib/Constants/Assets/SMLogos/LockerScreen/charts.png"},
      {"name": "Stocks", "id": "625feb5da30e9baa64758043", "slug": "stocks", "image_url": "lib/Constants/Assets/SMLogos/LockerScreen/Chart.svg"},
      {"name": "Crypto", "id": "625feb95a30e9baa6475804d", "slug": "crypto", "image_url": "lib/Constants/Assets/SMLogos/LockerScreen/Bitcoin.svg"},
      {
        "name": "Commodity",
        "id": "625fec39a30e9baa6475806a",
        "slug": "commodity",
        "image_url": "lib/Constants/Assets/SMLogos/LockerScreen/Commodity Icon (2).png"
      },
      {"name": "Forex", "id": "625febb4a30e9baa64758053", "slug": "forex", "image_url": "lib/Constants/Assets/SMLogos/LockerScreen/Forex Icon.png"}
    ]
  })).obs;
  Rx<CategoriesListModelResponse> selectedCategoryForCommunity = (CategoriesListModelResponse.fromJson(
          {"name": "Stocks", "id": "625feb5da30e9baa64758043", "slug": "stocks", "image_url": "lib/Constants/Assets/SMLogos/LockerScreen/Chart.svg"}))
      .obs;
  Rx<TextEditingController> exchangeController = TextEditingController().obs;
  Rx<ExchangeListModel>? exchangeList;
  Rx<ExchangeListResponse> selectedExchangeForCommunity = (ExchangeListResponse.fromJson({
    "_id": "625e59ec49d900f6585bc683",
    "name": "NSE (India)",
    "code": "NSE",
    "OperatingMIC": "XNSE",
    "Country": "India",
    "Currency": "INR",
    "status": 1,
    "createdAt": "2022-04-19T06:42:52.216Z",
    "updatedAt": "2022-04-19T06:42:52.216Z"
  })).obs;
  Rx<TextEditingController> industriesController = TextEditingController().obs;
  RxList<IndustriesListResponse> industriesListForCommunity = RxList<IndustriesListResponse>([]);
  RxList<String> selectedIndustriesListForCommunity = RxList<String>([]);
  Rx<bool> isIndustriesSelectedAll = false.obs;
  Rx<TextEditingController> textController = TextEditingController().obs;
  Rx<TextEditingController> cryptoTypeController = TextEditingController().obs;
  Rx<CryptoIndustriesModel>? cryptoIndustriesList;
  Rx<CryptoIndustriesResponse> selectedCryptoTypeForCommunity =
      (CryptoIndustriesResponse.fromJson({"_id": "626e72a52e4273c969ed6206", "name": "coin", "category_id": "625feb95a30e9baa6475804d"})).obs;
  Rx<TextEditingController> countryController = TextEditingController().obs;
  Rx<CommodityCountriesModel>? commodityCountriesList;
  Rx<CommoditiesCountriesResponse> selectedCountryForCommunity = (CommoditiesCountriesResponse.fromJson({"_id": "India", "name": "India"})).obs;
  Rx<TextEditingController> tickerController = TextEditingController().obs;
  Rx<TickersListModel>? tickersList;
  RxList<TickersListResponse> tickersListForCommunity = RxList<TickersListResponse>([]);
  RxList<String> selectedTickersListForCommunity = RxList<String>([]);
  Rx<bool> isTickerSelectedAll = false.obs;
  Rx<TextEditingController> tickerTextController = TextEditingController().obs;
  Rx<PostLimitationModel> postLimitationData = PostLimitationModel.fromJson({
    "status": true,
    "response": [
      {
        "name": "Open",
        "slug": "open",
        "options": [
          {"name": "Any one can post community", "slug": "anyone"}
        ]
      },
      {
        "name": "Flexible",
        "slug": "flexible",
        "options": [
          {"name": "Get approved from admin", "slug": "admin"},
          {"name": "Get approved from Sub-Admin", "slug": "subadmin"},
          {"name": "Get approved from Moderated", "slug": "moderator"}
        ]
      },
      {
        "name": "Restricted",
        "slug": "restricted",
        "options": [
          {"name": "Only content posted by Admin, sub-admin and moderators ", "slug": "admin,sub_admin,moderators"}
        ]
      }
    ]
  }).obs;
  Rx<PostLimitationResponse> selectedPostLimitValue = PostLimitationResponse.fromJson({
    "name": "Open",
    "slug": "open",
    "options": [
      {"name": "Any one can post community", "slug": "anyone"}
    ]
  }).obs;
  RxList<String> selectedPostLimitResponseOptionValue = RxList<String>([]);
  RxString selectedSubscriptionType = "Free".obs;
  Rx<PostLimitationModel> subscriptionPeriodData = PostLimitationModel.fromJson({
    "status": true,
    "response": [
      {"name": "Monthly", "slug": "month"},
      {"name": "Quarterly", "slug": "quater"},
      {"name": "Semester", "slug": "semester"},
      {"name": "Yearly", "slug": "year"}
    ]
  }).obs;
  RxList<String> periodDataSlugList = RxList<String>([]);
  RxList<PostLimitationResponse> selectedSubscriptionPeriodValue = RxList<PostLimitationResponse>([]);
  Rx<PostLimitationModel> trailAvailableData = PostLimitationModel.fromJson({
    "status": true,
    "response": [
      {"name": "Yes", "slug": "yes"},
      {"name": "No", "slug": "no"}
    ]
  }).obs;
  RxList<PostLimitationResponse> selectedTrailAvailableValue = RxList<PostLimitationResponse>([]);
  Rx<PostLimitationModel> trailFreeData = PostLimitationModel.fromJson({
    "status": true,
    "response": [
      {"name": "7 days", "slug": "7"},
      {"name": "14 days", "slug": "14"},
      {"name": "30 days", "slug": "30"}
    ]
  }).obs;
  RxList<PostLimitationResponse> selectedTrailFreeValue = RxList<PostLimitationResponse>([]);
  RxList<TextEditingController> paymentController = RxList<TextEditingController>([]);
  RxList<bool> isDiscountAvailable = RxList<bool>([]);
  RxList<TextEditingController> discountController = RxList<TextEditingController>([]);
  RxBool isDisclaimerChecked = false.obs;

  Rx<CommunitiesPageInitialModel> communitiesPageInitialData = (CommunitiesPageInitialModel.fromJson({
    "community_data": {
      "image": "",
      "is_detail_shown": false,
      "is_joined": false,
      "name": "",
      "code": "",
      "total_members": [],
      "members_list": [],
      "isPaidSubscription": false,
      "user_authority": "",
      "about": "",
      "roles": [],
      "creation_date": "2024-01-01T07:12:09.946Z",
      "average_post": "",
      "category": "",
      "exchange": "",
      "type": "",
      "country": "",
      "industry": [],
      "tickers": [],
      "rules": "",
      "post_requests": [],
      "post_contents": [],
    }
  })).obs;
  Rx<CommunitiesDescriptionResponseListModel> communitiesDescriptionPageResponseList = (CommunitiesDescriptionResponseListModel.fromJson({
    "responses_list": [
      {
        "_id": "65c5f5691b09a07d03aa44b0",
        "likes_count": 0,
        "dislikes_count": 0,
        "files": [],
        "message": "Hello flutter team",
        "username": "flutterteam",
        "first_name": "Flutter",
        "last_name": "Team1",
        "avatar": "https://live.tradewatch.in/uploads/avatars/dood.png",
        "believed_count": 10,
        "believers_count": 5,
        "likes": false,
        "dislikes": false
      }
    ]
  })).obs;
  Rx<CommunitiesDetailsApiModel>? communitiesDetail;
  Rx<MembersListApiModel>? communitiesMembersList;
  Rx<CommunitiesPostResponseModel>? communitiesPostRequestList;
  Rx<CommunitiesPostListApiModel>? communitiesPostList;
  Rx<CommunitiesResponseListApiModel>? communitiesPostResponsesList;
  Rx<TextEditingController> postRequestSearchController = TextEditingController().obs;
  Rx<int> communitiesPostSortValue = 0.obs;
  RxList<Map<String, dynamic>> addedFilesList = RxList<Map<String, dynamic>>([]);
  Rx<CommunitiesCommentsInitialModel>? communitiesCommentsInitialData;
  Rx<TextEditingController> communityCommentsController = TextEditingController().obs;

  RxBool checkValue = false.obs;
  RxBool deleteCheckValue = false.obs;
  RxList<int> subAdminPerson = RxList<int>([]);
  RxList<int> moderatorPerson = RxList<int>([]);
  RxList<int> memberPerson = RxList<int>([]);
  RxList<int> removePerson = RxList<int>([]);
  Rx<String> makeAdminPerson = "".obs;
  Rx<bool> isAdminChanged = false.obs;

  Rx<PlanChoosingInitialModel> planChoosingInitialData = (PlanChoosingInitialModel.fromJson({
    "response": [
      {
        "subscription_period": "01 Month",
        "payment_amount": 1499,
        "discount": 10,
        "trail_period": 7,
        "initial_color": const Color(0XFF5ACAFA), //.withOpacity(0.0),
        "end_color": const Color(0XFF564FDD) //.withOpacity(1.2174)
      },
      {
        "subscription_period": "03 Months",
        "payment_amount": 2499,
        "discount": 15,
        "trail_period": 14,
        "initial_color": const Color(0XFFFFD361),
        "end_color": const Color(0XFFEDA130)
      },
      {
        "subscription_period": "06 Months",
        "payment_amount": 3499,
        "discount": 15,
        "trail_period": 21,
        "initial_color": const Color(0XFF6CC38E), //.withOpacity(0),
        "end_color": const Color(0XFF18786D) //.withOpacity(1)
      },
      {
        "subscription_period": "01 Year",
        "payment_amount": 4499,
        "discount": 15,
        "trail_period": 28,
        "initial_color": const Color(0XFFFD492E), //.withOpacity(0.0),
        "end_color": const Color(0XFFD81756) //.withOpacity(1.0)
      }
    ]
  })).obs;
  RxInt chosenSubscriptionPlan = 0.obs;
  Rx<bool> createButtonLoader = false.obs;
  Map<String, dynamic>? paymentIntent;
}
