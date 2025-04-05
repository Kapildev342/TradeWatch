import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/you_tube_player_landscape_screen.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_edit_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/questionnaire_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkSeeAll/book_mark_see_all_view.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/MultipleOne/book_mark_multiple_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Bytes/bytes_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';

class BookMarksView extends StatefulWidget {
  const BookMarksView({super.key});

  @override
  State<BookMarksView> createState() => _BookMarksViewState();
}

class _BookMarksViewState extends State<BookMarksView> {
  bool loader = false;
  late Uri newLink;
  final CarouselController _carController = CarouselController();
  int carouselIndexGlobal = 0;

  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

  @override
  void initState() {
    getAllDataMain(name: 'Bookmark_View');
    getData();
    super.initState();
  }

  @override
  void dispose() {
    mainVariables.bookMarKTotalList.clear();
    super.dispose();
  }

  getData() async {
    context.read<BookMarkMultipleWidgetBloc>().add(const MultipleLoadingEvent());
    getNotifyCountAndImage();
    await apiFunctionsMain.bookMarkInitialFunction();
    mainVariables.bookMarKTotalList.add(List.generate(mainVariables.bookMarkOverViewAllMain!.value.response[0].news.length,
        (i) => mainVariables.bookMarkOverViewAllMain!.value.response[0].news[i].bookmark));
    mainVariables.bookMarKTotalList.add(List.generate(mainVariables.bookMarkOverViewAllMain!.value.response[0].videos.length,
        (i) => mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[i].bookmark));
    mainVariables.bookMarKTotalList.add(List.generate(mainVariables.bookMarkOverViewAllMain!.value.response[0].forums.length,
        (i) => mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[i].bookmark));
    mainVariables.bookMarKTotalList.add(List.generate(mainVariables.bookMarkOverViewAllMain!.value.response[0].survey.length,
        (i) => mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[i].bookmark));
    mainVariables.bookMarKTotalList.add(List.generate(mainVariables.bookMarkOverViewAllMain!.value.response[0].users.length,
        (i) => mainVariables.bookMarkOverViewAllMain!.value.response[0].users[i].bookmark));
    mainVariables.bookMarKTotalList.add(List.generate(mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
        (i) => mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[i].bookmarks.value));
    setState(() {
      loader = true;
    });
  }

  Future<bool> likeFunction({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = Uri.parse(baseurl + versionLocker + likes);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type,
    });
    var responseData = jsonDecode(response.body);
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

  Future<bool> disLikeFunction({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
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
    String mainUserToken = prefs.getString('newUserToken') ?? "";
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

  Future<Uri> getLinkNews({
    required String id,
    required String type,
    required String imageUrl,
    required String title,
    required String description,
  }) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/DemoPage/$id/$type'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
    ShortDynamicLink dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  Future<Uri> getLinkVideos({
    required String id,
    required String type,
    required String imageUrl,
    required String title,
    required String description,
  }) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/VideoDescriptionPage/$id/$type'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  Future<Uri> getLinkForums(
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

  Future<Uri> getLinKSurvey({
    required String id,
    required String type,
    required String imageUrl,
    required String title,
    required String description,
  }) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/AnalyticsPage/$id/$type/$title'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
        child: Scaffold(
      //backgroundColor: const Color(0XFFFFFFFF),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        //backgroundColor: const Color(0XFFFFFFFF),
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        toolbarHeight: height / 13.90,
        leading: IconButton(
          onPressed: () {
            if (!mounted) {
              return;
            }
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "My Bookmarks",
              style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
            )
          ],
        ),
      ),
      body: loader
          ? Container(
              width: width,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  // color: const Color(0XFFF9FFF9),
                  color: Theme.of(context).colorScheme.onBackground,
                  //border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                    )
                  ]),
              child: SingleChildScrollView(
                child: mainVariables.bookMarkOverViewAllMain!.value.response[0].news.isEmpty &&
                        mainVariables.bookMarkOverViewAllMain!.value.response[0].videos.isEmpty &&
                        mainVariables.bookMarkOverViewAllMain!.value.response[0].forums.isEmpty &&
                        mainVariables.bookMarkOverViewAllMain!.value.response[0].survey.isEmpty &&
                        mainVariables.bookMarkOverViewAllMain!.value.response[0].users.isEmpty &&
                        mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/noResponse_green.svg", width: 150),
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Looks like no content add yet.',
                                    style: TextStyle(fontFamily: "Poppins", color: Color(0XFF0EA102), fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: height / 54.75,
                          ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].news.isEmpty
                              ? const SizedBox()
                              : Container(
                                  margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "News",
                                        style: TextStyle(/*color: const Color(0XFF3E3939),*/ fontSize: text.scale(16), fontWeight: FontWeight.w600),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (BuildContext context) => const BookMarkSeeAllView(type: 'news')));
                                          },
                                          child: Text(
                                            "See all",
                                            style: TextStyle(color: const Color(0XFF8C8C8C), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].news.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 54.75,
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].news.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 4.38,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: mainVariables.bookMarkOverViewAllMain!.value.response[0].news.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.only(left: index == 0 ? 15 : 0, right: 15),
                                        width: width / 1.28,
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                /* if (bookMarkOverView.response[0]
                                .news[index].description ==
                                "" &&
                                bookMarkOverView.response[0]
                                    .news[index].snippet ==
                                    "") {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) {
                                        return DemoPage(
                                          url: bookMarkOverView
                                              .response[0]
                                              .news[index]
                                              .newsUrl,
                                          text: bookMarkOverView
                                              .response[0]
                                              .news[index]
                                              .category,
                                          image: "",
                                          id: bookMarkOverView
                                              .response[0].news[index].postId,
                                          type: 'news',
                                          activity: true,
                                          checkMain: false,
                                        );
                                      }));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder:
                                          (BuildContext context) =>
                                          NewsDescriptionPage(
                                            comeFrom: 'newsMain',
                                            id: bookMarkOverView
                                                .response[0]
                                                .news[index]
                                                .postId,
                                            idList:
                                            newsIdList,
                                            descriptionList:newsDescriptionList,
                                            snippetList: newsSnippetList,
                                          )));
                            }*/

                                                ///need to change it soon
                                                /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                return DemoPage(
                                                  url: mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].newsUrl,
                                                  text: mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].category,
                                                  image: "",
                                                  id: mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].postId,
                                                  type: 'news',
                                                  activity: true,
                                                  checkMain: false,
                                                );
                                              }));*/
                                                Get.to(const DemoView(), arguments: {
                                                  "id": mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].postId,
                                                  "type": "news",
                                                  "url": mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].newsUrl
                                                });
                                              },
                                              child: Stack(
                                                alignment: Alignment.bottomLeft,
                                                children: [
                                                  Container(
                                                    height: height / 6,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          spreadRadius: 0.0,
                                                          blurRadius: 4.0,
                                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                                                        ),
                                                      ],
                                                      image: DecorationImage(
                                                        image: NetworkImage(mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index]
                                                            .imageUrl /*newsImagesList[index]*/),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height / 22.37,
                                                    width: width,
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black12.withOpacity(0.3),
                                                    ),
                                                    child: Text(
                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].title,
                                                      //newsTitlesList[index],
                                                      style: TextStyle(
                                                          fontSize: text.scale(9),
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: "Poppins",
                                                          overflow: TextOverflow.ellipsis),
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: height / 20,
                                                      width: width,
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                        //  color: Colors.black12.withOpacity(0.3),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          sentimentButton(
                                                              context: context,
                                                              text: mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index]
                                                                  .sentiment /*newsSentimentList[index]*/),
                                                          excLabelButton(
                                                              text:
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].labelExchange,
                                                              context: context /*newsExchangeList[index]*/)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: height / 18.25,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background,
                                                  borderRadius:
                                                      const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        spreadRadius: 0.0,
                                                        blurRadius: 4.0,
                                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3))
                                                  ]),
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(vertical: 5),
                                                padding: EdgeInsets.only(left: width / 27.4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].sourceName
                                                                    .capitalizeFirst ??
                                                                "", //newsSourceNameList[index].toString().capitalizeFirst!,
                                                            style: TextStyle(
                                                                fontSize: text.scale(10),
                                                                color: const Color(0XFFF7931A),
                                                                fontWeight: FontWeight.w500,
                                                                fontFamily: "Poppins",
                                                                overflow: TextOverflow.ellipsis),
                                                            maxLines: 1,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                mainVariables
                                                                    .bookMarkOverViewAllMain!.value.response[0].news[index].date, // timeList[index],
                                                                style: TextStyle(
                                                                    fontSize: text.scale(9),
                                                                    color: const Color(0XFFB0B0B0),
                                                                    fontWeight: FontWeight.w500,
                                                                    fontFamily: "Poppins"),
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  kUserSearchController.clear();
                                                                  onTapType = "liked";
                                                                  onTapId =
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].postId;
                                                                  onLike = true;
                                                                  onDislike = false;
                                                                  idKeyMain = "news_id";
                                                                  apiMain = baseurl + versionLocker + newsLikeDislikeCount;
                                                                  onTapIdMain =
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].postId;
                                                                  onTapTypeMain = "liked";
                                                                  haveLikesMain = mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].news[index].likesCount >
                                                                          0
                                                                      ? true
                                                                      : false;
                                                                  haveDisLikesMain = mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].news[index].disLikesCount >
                                                                          0
                                                                      ? true
                                                                      : false;
                                                                  likesCountMain =
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].likesCount;
                                                                  dislikesCountMain = mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].news[index].disLikesCount;
                                                                  kToken = kToken;
                                                                  loaderMain = false;
                                                                  await customShowSheetNew3(
                                                                    context: context,
                                                                    responseCheck: 'feature',
                                                                  );
                                                                },
                                                                child: Text(
                                                                  "${mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].likesCount} Likes",
                                                                  //"${newsLikeList[index]} Likes",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(9),
                                                                      color: const Color(0XFFB0B0B0),
                                                                      fontWeight: FontWeight.w900,
                                                                      fontFamily: "Poppins"),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  kUserSearchController.clear();
                                                                  onTapType = "disliked";
                                                                  onTapId =
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].postId;
                                                                  onLike = false;
                                                                  onDislike = true;
                                                                  idKeyMain = "news_id";
                                                                  apiMain = baseurl + versionLocker + newsLikeDislikeCount;
                                                                  onTapIdMain =
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].postId;
                                                                  onTapTypeMain = "disliked";
                                                                  haveLikesMain = mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].news[index].likesCount >
                                                                          0
                                                                      ? true
                                                                      : false;
                                                                  haveDisLikesMain = mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].news[index].disLikesCount >
                                                                          0
                                                                      ? true
                                                                      : false;
                                                                  likesCountMain =
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].likesCount;
                                                                  dislikesCountMain = mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].news[index].disLikesCount;
                                                                  kToken = kToken;
                                                                  loaderMain = false;
                                                                  await customShowSheetNew3(
                                                                    context: context,
                                                                    responseCheck: 'feature',
                                                                  );
                                                                },
                                                                child: Text(
                                                                  "${mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].disLikesCount} DisLikes", //"${newsDislikeList[index]} Dislikes",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(9),
                                                                      color: const Color(0XFFB0B0B0),
                                                                      fontWeight: FontWeight.w900,
                                                                      fontFamily: "Poppins"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: width / 51.375),
                                                      width: width / 3,
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () async {
                                                                bool response1 = await likeFunction(
                                                                    id: mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].postId,
                                                                    type: "news");
                                                                if (response1) {
                                                                  logEventFunc(name: "Likes", type: "News");
                                                                  setState(() {
                                                                    if (mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].likes ==
                                                                        true) {
                                                                      if (mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].news[index].dislikes ==
                                                                          true) {
                                                                      } else {
                                                                        mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].news[index].likesCount -= 1;
                                                                      }
                                                                    } else {
                                                                      if (mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].news[index].dislikes ==
                                                                          true) {
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index]
                                                                            .disLikesCount -= 1;
                                                                        mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].news[index].likesCount += 1;
                                                                      } else {
                                                                        mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].news[index].likesCount += 1;
                                                                      }
                                                                    }
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].likes =
                                                                        !mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].likes;
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].dislikes =
                                                                        false;
                                                                  });
                                                                }
                                                              },
                                                              child: Container(
                                                                child: mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].likes
                                                                    ? SvgPicture.asset(
                                                                        isDarkTheme.value
                                                                            ? "assets/home_screen/like_filled_dark.svg"
                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                        height: height / 58.4,
                                                                        width: width / 27.4)
                                                                    : SvgPicture.asset(
                                                                        isDarkTheme.value
                                                                            ? "assets/home_screen/like_dark.svg"
                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                        height: height / 58.4,
                                                                        width: width / 27.4,
                                                                      ),
                                                              )),
                                                          SizedBox(width: width / 20),
                                                          GestureDetector(
                                                              onTap: () async {
                                                                logEventFunc(name: 'Share', type: 'News');
                                                                newLink = await getLinkNews(
                                                                    id: mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].postId,
                                                                    type: "news",
                                                                    description: '',
                                                                    imageUrl:
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].imageUrl,
                                                                    title:
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].title);
                                                                ShareResult result = await Share.share(
                                                                  "Look what I was able to find on Tradewatch: ${mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].title} ${newLink.toString()}",
                                                                );
                                                                if (result.status == ShareResultStatus.success) {
                                                                  await shareFunction(
                                                                      id: mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].postId,
                                                                      type: "news");
                                                                }
                                                              },
                                                              child: SvgPicture.asset(
                                                                isDarkTheme.value
                                                                    ? "assets/home_screen/share_dark.svg"
                                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                height: height / 58.4,
                                                                width: width / 27.4,
                                                              )),
                                                          SizedBox(width: width / 20),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              bool response3 = await disLikeFunction(
                                                                  id: mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].postId,
                                                                  type: "news");
                                                              if (response3) {
                                                                logEventFunc(name: "Dislikes", type: "News");
                                                                setState(() {
                                                                  if (mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].dislikes ==
                                                                      true) {
                                                                    if (mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].likes ==
                                                                        true) {
                                                                    } else {
                                                                      mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].news[index].disLikesCount -= 1;
                                                                    }
                                                                  } else {
                                                                    if (mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].likes ==
                                                                        true) {
                                                                      mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].news[index].likesCount -= 1;
                                                                      mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].news[index].disLikesCount += 1;
                                                                    } else {
                                                                      mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].news[index].disLikesCount += 1;
                                                                    }
                                                                  }
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].dislikes =
                                                                      !mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].dislikes;
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].likes = false;
                                                                });
                                                              } else {}
                                                            },
                                                            child: mainVariables.bookMarkOverViewAllMain!.value.response[0].news[index].dislikes
                                                                ? SvgPicture.asset(
                                                                    isDarkTheme.value
                                                                        ? "assets/home_screen/dislike_filled_dark.svg"
                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                    height: height / 58.4,
                                                                    width: width / 27.4,
                                                                  )
                                                                : SvgPicture.asset(
                                                                    isDarkTheme.value
                                                                        ? "assets/home_screen/dislike_dark.svg"
                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                    height: height / 58.4,
                                                                    width: width / 27.4,
                                                                  ),
                                                          ),
                                                          SizedBox(width: width / 20),
                                                          bookMarkWidgetMultiple(
                                                            bookMark: mainVariables.bookMarKTotalList,
                                                            context: context,
                                                            scale: 4,
                                                            id: mainVariables
                                                                .bookMarkOverViewAllMain!.value.response[0].news[index].postId /*forumIdList[index]*/,
                                                            type: 'news',
                                                            index: index,
                                                            initFunction: getData,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          SizedBox(
                            height: height / 54.75,
                          ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].videos.isEmpty
                              ? const SizedBox()
                              : Container(
                                  margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Videos",
                                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (BuildContext context) => const BookMarkSeeAllView(type: 'videos')));
                                          },
                                          child: Text(
                                            "See all",
                                            style: TextStyle(color: const Color(0XFF8C8C8C), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].videos.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 54.75,
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].videos.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 4.38,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: mainVariables.bookMarkOverViewAllMain!.value.response[0].videos.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.only(left: index == 0 ? 15 : 0, right: 15),
                                        width: width / 1.28,
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return YoutubePlayerLandscapeScreen(
                                                    id: mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].postId,
                                                    comeFrom: 'bookmark',
                                                  );
                                                }));
                                              },
                                              child: Stack(
                                                alignment: Alignment.bottomLeft,
                                                children: [
                                                  Container(
                                                    height: height / 6,
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            spreadRadius: 0.0,
                                                            blurRadius: 4.0,
                                                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3))
                                                      ],
                                                      image: DecorationImage(
                                                        image: NetworkImage(mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index]
                                                            .imageUrl /*newsImagesList[index]*/),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius:
                                                          const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            width: width / 13.7,
                                                            height: height / 29.2,
                                                            //padding: EdgeInsets.all(10),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.black12.withOpacity(0.3),
                                                            ),
                                                            child: const Center(
                                                                child: Icon(
                                                              Icons.play_arrow,
                                                              color: Colors.white,
                                                            )),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        height: height / 22.37,
                                                        width: width,
                                                        padding: const EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black12.withOpacity(0.3),
                                                        ),
                                                        child: Text(
                                                          mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index]
                                                              .title, //newsTitlesList[index],
                                                          style: TextStyle(
                                                              fontSize: text.scale(9),
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: "Poppins",
                                                              overflow: TextOverflow.ellipsis),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: height / 20,
                                                      width: width,
                                                      padding: const EdgeInsets.all(10),
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                        //  color: Colors.black12.withOpacity(0.3),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          sentimentButton(
                                                              context: context,
                                                              text: mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index]
                                                                  .sentiment /*newsSentimentList[index]*/),
                                                          excLabelButton(
                                                              text: mainVariables
                                                                  .bookMarkOverViewAllMain!.value.response[0].videos[index].labelExchange,
                                                              context: context /*newsExchangeList[index]*/)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: height / 18.25,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background,
                                                  borderRadius:
                                                      const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        spreadRadius: 0.0,
                                                        blurRadius: 4.0,
                                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3))
                                                  ]),
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(vertical: 5),
                                                padding: EdgeInsets.only(left: width / 27.4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].sourceName
                                                                    .toString()
                                                                    .capitalizeFirst ??
                                                                '', //newsSourceNameList[index].toString().capitalizeFirst!,
                                                            style: TextStyle(
                                                                fontSize: text.scale(10),
                                                                color: const Color(0XFFF7931A),
                                                                fontWeight: FontWeight.w500,
                                                                fontFamily: "Poppins",
                                                                overflow: TextOverflow.ellipsis),
                                                            maxLines: 1,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index]
                                                                    .date, // timeList[index],
                                                                style: TextStyle(
                                                                    fontSize: text.scale(9),
                                                                    color: const Color(0XFFB0B0B0),
                                                                    fontWeight: FontWeight.w500,
                                                                    fontFamily: "Poppins"),
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  kUserSearchController.clear();
                                                                  onTapType = "Views";
                                                                  onTapId =
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].postId;
                                                                  onLike = false;
                                                                  onDislike = false;
                                                                  onViews = true;
                                                                  idKeyMain = "video_id";
                                                                  apiMain = baseurl + versionLocker + videoViewCount;
                                                                  onTapIdMain =
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].postId;
                                                                  onTapTypeMain = "Views";
                                                                  haveLikesMain = mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].videos[index].likesCount >
                                                                          0
                                                                      ? true
                                                                      : false;
                                                                  haveDisLikesMain = mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                              .videos[index].disLikesCount >
                                                                          0
                                                                      ? true
                                                                      : false;
                                                                  haveViewsMain = mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].videos[index].viewsCount >
                                                                          0
                                                                      ? true
                                                                      : false;
                                                                  likesCountMain = mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].videos[index].likesCount;
                                                                  dislikesCountMain = mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].videos[index].disLikesCount;
                                                                  viewCountMain = mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].videos[index].viewsCount;
                                                                  kToken = kToken;
                                                                  //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionLocker + videoViewCount, idKey: 'video_id', setState: setState);
                                                                  bool data =
                                                                      await likeCountFunc(context: context, newSetState: (void Function() fn) {});
                                                                  if (data) {
                                                                    if (!mounted) {
                                                                      return;
                                                                    }
                                                                    customShowSheet1(context: context);
                                                                    loaderMain = true;
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
                                                                child: Text(
                                                                  "${mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].viewsCount} Views",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(9),
                                                                      color: const Color(0XFFB0B0B0),
                                                                      fontWeight: FontWeight.w500,
                                                                      fontFamily: "Poppins"),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: width / 51.375),
                                                      width: width / 3,
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () async {
                                                                bool response1 = await likeFunction(
                                                                    id: mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].postId,
                                                                    type: "videos");
                                                                if (response1) {
                                                                  logEventFunc(name: "Likes", type: "Videos");
                                                                  setState(() {
                                                                    if (mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].videos[index].likes ==
                                                                        true) {
                                                                      if (mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].videos[index].dislikes ==
                                                                          true) {
                                                                      } else {
                                                                        mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].videos[index].likesCount -= 1;
                                                                      }
                                                                    } else {
                                                                      if (mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].videos[index].dislikes ==
                                                                          true) {
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index]
                                                                            .disLikesCount -= 1;
                                                                        mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].videos[index].likesCount += 1;
                                                                      } else {
                                                                        mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].videos[index].likesCount += 1;
                                                                      }
                                                                    }
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].likes =
                                                                        !mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].likes;
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].dislikes =
                                                                        false;
                                                                  });
                                                                } else {}
                                                              },
                                                              child: Container(
                                                                child: mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].likes
                                                                    ? SvgPicture.asset(
                                                                        isDarkTheme.value
                                                                            ? "assets/home_screen/like_filled_dark.svg"
                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                                                        height: height / 58.4,
                                                                        width: width / 27.4)
                                                                    : SvgPicture.asset(
                                                                        isDarkTheme.value
                                                                            ? "assets/home_screen/like_dark.svg"
                                                                            : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                                                        height: height / 58.4,
                                                                        width: width / 27.4),
                                                              )),
                                                          SizedBox(width: width / 20),
                                                          GestureDetector(
                                                              onTap: () async {
                                                                logEventFunc(name: 'Share', type: 'Videos');
                                                                newLink = await getLinkVideos(
                                                                    id: mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].postId,
                                                                    type: "videos",
                                                                    description: '',
                                                                    imageUrl: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].videos[index].imageUrl,
                                                                    title:
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].title);
                                                                ShareResult result = await Share.share(
                                                                  "Look what I was able to find on Tradewatch: ${mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].title} ${newLink.toString()}",
                                                                );
                                                                if (result.status == ShareResultStatus.success) {
                                                                  await shareFunction(
                                                                      id: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].videos[index].postId,
                                                                      type: "news");
                                                                }
                                                              },
                                                              child: SvgPicture.asset(
                                                                  isDarkTheme.value
                                                                      ? "assets/home_screen/share_dark.svg"
                                                                      : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                                                  height: height / 58.4,
                                                                  width: width / 27.4)),
                                                          SizedBox(width: width / 20),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              bool response3 = await disLikeFunction(
                                                                  id: mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].postId,
                                                                  type: "videos");
                                                              if (response3) {
                                                                logEventFunc(name: "Dislikes", type: "Videos");
                                                                setState(() {
                                                                  if (mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].videos[index].dislikes ==
                                                                      true) {
                                                                    if (mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].videos[index].likes ==
                                                                        true) {
                                                                    } else {
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index]
                                                                          .disLikesCount -= 1;
                                                                    }
                                                                  } else {
                                                                    if (mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].videos[index].likes ==
                                                                        true) {
                                                                      mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].videos[index].likesCount -= 1;
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index]
                                                                          .disLikesCount += 1;
                                                                    } else {
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index]
                                                                          .disLikesCount += 1;
                                                                    }
                                                                  }
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].dislikes =
                                                                      !mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].videos[index].dislikes;
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].likes =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                            child: mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index].dislikes
                                                                ? SvgPicture.asset(
                                                                    isDarkTheme.value
                                                                        ? "assets/home_screen/dislike_filled_dark.svg"
                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                                    height: height / 58.4,
                                                                    width: width / 27.4)
                                                                : SvgPicture.asset(
                                                                    isDarkTheme.value
                                                                        ? "assets/home_screen/dislike_dark.svg"
                                                                        : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                                    height: height / 58.4,
                                                                    width: width / 27.4),
                                                          ),
                                                          SizedBox(width: width / 20),
                                                          bookMarkWidgetMultiple(
                                                            bookMark: mainVariables.bookMarKTotalList,
                                                            context: context,
                                                            scale: 4,
                                                            id: mainVariables.bookMarkOverViewAllMain!.value.response[0].videos[index]
                                                                .postId /*forumIdList[index]*/,
                                                            type: 'videos',
                                                            initFunction: getData,
                                                            index: index,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          SizedBox(
                            height: height / 54.75,
                          ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].forums.isEmpty
                              ? const SizedBox()
                              : Container(
                                  margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Forums",
                                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) => const BookMarkSeeAllView(
                                                          type: 'forums',
                                                        )));
                                          },
                                          child: Text(
                                            "See all",
                                            style: TextStyle(color: const Color(0XFF8C8C8C), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].forums.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 54.75,
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].forums.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 5.84,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: mainVariables.bookMarkOverViewAllMain!.value.response[0].forums.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () async {
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return ForumPostDescriptionPage(
                                                forumId: mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index].postId,
                                                comeFrom: "bookmark",
                                                idList: List.generate(mainVariables.bookMarkOverViewAllMain!.value.response[0].forums.length,
                                                    (index) => mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index].postId),
                                              );
                                            }));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: index == 0 ? 15 : 0, right: 15, top: 5, bottom: 5),
                                            width: width / 1.28,
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                                                      blurRadius: 4.0,
                                                      spreadRadius: 0.0)
                                                ]),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: height / 87.6,
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
                                                              /*Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext
                                                  context) {
                                                    return UserProfilePage(
                                                        id: bookMarkOverView
                                                            .response[0]
                                                            .forums[index]
                                                            .user
                                                            .id,
                                                        type: 'forums',
                                                        index: 0);
                                                  }));*/
                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return UserBillBoardProfilePage(
                                                                  userId:
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index].user.id,
                                                                );
                                                              }));
                                                            },
                                                            child: Container(
                                                              height: height / 13.53,
                                                              width: width / 8,
                                                              margin: EdgeInsets.symmetric(vertical: height / 87.6, horizontal: width / 41.1),
                                                              /*  margin: EdgeInsets.fromLTRB(
                                                    _width / 23.43,
                                                    _height / 203,
                                                    _width / 37.5,
                                                    _height / 27.06),*/
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Colors.grey,
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index].user
                                                                            .avatar /*forumImagesList[index]*/,
                                                                      ),
                                                                      fit: BoxFit.fill)),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                      width: width / 2.055,
                                                                      child: Text(
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                            .title /*forumTitlesList[index]*/,
                                                                        style: TextStyle(
                                                                            fontSize: text.scale(12),
                                                                            fontWeight: FontWeight.w600,
                                                                            overflow: TextOverflow.ellipsis),
                                                                        maxLines: 2,
                                                                      )),
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
                                                                                child: userIdMain ==
                                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                            .forums[index].user.id
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
                                                                                              Navigator.push(context,
                                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                                return ForumPostEditPage(
                                                                                                  text: finalisedCategory.toString().capitalizeFirst!,
                                                                                                  catIdList: const [],
                                                                                                  filterId: finalisedFilterId,
                                                                                                  forumId: mainVariables.bookMarkOverViewAllMain!
                                                                                                      .value.response[0].forums[index].postId,
                                                                                                );
                                                                                              }));
                                                                                            },
                                                                                            minLeadingWidth: width / 25,
                                                                                            leading: const Icon(
                                                                                              Icons.edit,
                                                                                              size: 20,
                                                                                            ),
                                                                                            title: Text(
                                                                                              "Edit Post",
                                                                                              style: TextStyle(
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontSize: text.scale(14)),
                                                                                            ),
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
                                                                                                                child: Text("Delete Post",
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
                                                                                                                            BorderRadius.circular(
                                                                                                                                18.0),
                                                                                                                      ),
                                                                                                                      backgroundColor:
                                                                                                                          const Color(0XFF0EA102),
                                                                                                                    ),
                                                                                                                    onPressed: () async {
                                                                                                                      deletePostMain(
                                                                                                                          context: context,
                                                                                                                          id: mainVariables
                                                                                                                              .bookMarkOverViewAllMain!
                                                                                                                              .value
                                                                                                                              .response[0]
                                                                                                                              .forums[index]
                                                                                                                              .postId,
                                                                                                                          locker: 'forum');
                                                                                                                      if (!mounted) {
                                                                                                                        return;
                                                                                                                      }
                                                                                                                      Navigator.pop(context);
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
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  fontSize: text.scale(14)),
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
                                                                                              mainVariables.barController.clear();
                                                                                              mainVariables.actionValueMain = "Report";
                                                                                              showAlertDialogMain(
                                                                                                context: context,
                                                                                                initFunction: getData,
                                                                                                modelSetState: (void Function() fn) {},
                                                                                                locker: 'forum',
                                                                                                id: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                    .response[0].forums[index].postId,
                                                                                                userId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                    .response[0].forums[index].user.id,
                                                                                              );
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
                                                                                              mainVariables.barController.clear();
                                                                                              mainVariables.actionValueMain = "Block";
                                                                                              if (!mounted) {
                                                                                                return;
                                                                                              }
                                                                                              Navigator.pop(context);
                                                                                              showAlertDialogMain(
                                                                                                context: context,
                                                                                                initFunction: getData,
                                                                                                modelSetState: (void Function() fn) {},
                                                                                                locker: 'forum',
                                                                                                id: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                    .response[0].forums[index].postId,
                                                                                                userId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                    .response[0].forums[index].user.id,
                                                                                              );
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
                                                                ],
                                                              ),
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  /*  Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (BuildContext
                                                      context) {
                                                        return UserProfilePage(
                                                            id: bookMarkOverView
                                                                .response[0]
                                                                .forums[index]
                                                                .user
                                                                .id,
                                                            type: 'forums',
                                                            index: 0);
                                                      }));*/
                                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return UserBillBoardProfilePage(
                                                                      userId: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].forums[index].user.id,
                                                                    );
                                                                  }));
                                                                },
                                                                child: SizedBox(
                                                                    height: height / 54.13,
                                                                    child: Text(
                                                                      mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].forums[index].user.username
                                                                          .toString()
                                                                          .capitalizeFirst!,
                                                                      style: TextStyle(fontSize: text.scale(9), fontWeight: FontWeight.w500),
                                                                    )),
                                                              ),
                                                              SizedBox(height: height / 54.13),
                                                              SizedBox(
                                                                height: height / 45.11,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        bool response1 = await likeFunction(
                                                                            id: mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].forums[index].postId,
                                                                            type: "forums");
                                                                        if (response1) {
                                                                          logEventFunc(name: "Likes", type: "Forum");
                                                                          setState(() {
                                                                            if (mainVariables
                                                                                    .bookMarkOverViewAllMain!.value.response[0].forums[index].likes ==
                                                                                true) {
                                                                              if (mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                      .forums[index].dislikes ==
                                                                                  true) {
                                                                              } else {
                                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                    .likesCount -= 1;
                                                                              }
                                                                            } else {
                                                                              if (mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                      .forums[index].dislikes ==
                                                                                  true) {
                                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                    .disLikesCount -= 1;
                                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                    .likesCount += 1;
                                                                              } else {
                                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                    .likesCount += 1;
                                                                              }
                                                                            }
                                                                            mainVariables
                                                                                    .bookMarkOverViewAllMain!.value.response[0].forums[index].likes =
                                                                                !mainVariables
                                                                                    .bookMarkOverViewAllMain!.value.response[0].forums[index].likes;
                                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                .dislikes = false;
                                                                          });
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        margin: EdgeInsets.only(right: width / 25),
                                                                        height: 15,
                                                                        width: 15,
                                                                        child: mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].forums[index].likes
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
                                                                        newLink = await getLinkForums(
                                                                            id: mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].forums[index].postId,
                                                                            type: "forums",
                                                                            description: '',
                                                                            imageUrl: "",
                                                                            title: mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].forums[index].title,
                                                                            category: mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].forums[index].category,
                                                                            filterId: finalisedFilterId);
                                                                        ShareResult result = await Share.share(
                                                                          "Look what I was able to find on Tradewatch: ${mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index].title} ${newLink.toString()}",
                                                                        );
                                                                        if (result.status == ShareResultStatus.success) {
                                                                          await shareFunction(
                                                                              id: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].forums[index].postId,
                                                                              type: "forums");
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                          height: 15,
                                                                          width: 15,
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
                                                                            id: mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].forums[index].postId,
                                                                            type: "forums");
                                                                        if (response3) {
                                                                          logEventFunc(name: "Dislikes", type: "Forum");
                                                                          setState(() {
                                                                            if (mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                    .dislikes ==
                                                                                true) {
                                                                              if (mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                      .forums[index].likes ==
                                                                                  true) {
                                                                              } else {
                                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                    .likesCount -= 1;
                                                                              }
                                                                            } else {
                                                                              if (mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                      .forums[index].likes ==
                                                                                  true) {
                                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                    .likesCount -= 1;
                                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                    .disLikesCount += 1;
                                                                              } else {
                                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                    .likesCount += 1;
                                                                              }
                                                                            }
                                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                    .dislikes =
                                                                                !mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .forums[index].dislikes;
                                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                .likes = false;
                                                                          });
                                                                        } else {}
                                                                      },
                                                                      child: Container(
                                                                        height: 15,
                                                                        width: 15,
                                                                        margin: EdgeInsets.only(right: width / 25),
                                                                        child: mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].forums[index].dislikes
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
                                                                        height: 15,
                                                                        width: 15,
                                                                        margin: EdgeInsets.only(right: width / 25),
                                                                        child: SvgPicture.asset(
                                                                          "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                                                          colorFilter: ColorFilter.mode(
                                                                              isDarkTheme.value ? const Color(0XFFD6D6D6) : const Color(0XFF0EA102),
                                                                              BlendMode.srcIn),
                                                                        )),
                                                                    bookMarkWidgetMultiple(
                                                                      bookMark: mainVariables.bookMarKTotalList,
                                                                      context: context,
                                                                      scale: 4,
                                                                      id: mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                          .postId /*forumIdList[index]*/,
                                                                      type: 'forums',
                                                                      initFunction: getData,
                                                                      index: index,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: height / 81.2),
                                                              SizedBox(
                                                                height: height / 54.13,
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                        width: width / 7.5,
                                                                        child: Text(
                                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].forums[index]
                                                                                .companyName /*forumCompanyList[index]*/,
                                                                            style: TextStyle(
                                                                                fontSize: text.scale(10),
                                                                                fontWeight: FontWeight.w700,
                                                                                color: Colors.blue))),
                                                                    SizedBox(width: width / 22.05),
                                                                    GestureDetector(
                                                                      onTap: () async {
                                                                        kUserSearchController.clear();
                                                                        onTapType = "Views";
                                                                        onTapId = mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].forums[index].postId;
                                                                        onLike = false;
                                                                        onDislike = false;
                                                                        onViews = true;
                                                                        idKeyMain = "forum_id";
                                                                        apiMain = baseurl + versionForum + viewsCount;
                                                                        onTapIdMain = mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].forums[index].postId;
                                                                        onTapTypeMain = "Views";
                                                                        haveViewsMain = mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .forums[index].viewsCount >
                                                                                0
                                                                            ? true
                                                                            : false;
                                                                        viewCountMain = mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].forums[index].viewsCount;
                                                                        kToken = kToken;

                                                                        //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionForum + viewsCount, idKey: 'forum_id', setState: setState);
                                                                        bool data = await likeCountFunc(
                                                                            context: context, newSetState: (void Function() fn) {});
                                                                        if (data) {
                                                                          if (!mounted) {
                                                                            return;
                                                                          }
                                                                          customShowSheet1(context: context);
                                                                          loaderMain = true;
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
                                                                          Text("0" /*forumViewsList[index].toString()*/,
                                                                              style:
                                                                                  TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                          Text(" views",
                                                                              style:
                                                                                  TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(width: width / 22.05),
                                                                    Text("0" /*forumResponseList[index].toString()*/,
                                                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                    Text(" Response",
                                                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 87.6,
                                                ),
                                              ],
                                            ),
                                          ));
                                    },
                                  ),
                                ),
                          SizedBox(
                            height: height / 54.75,
                          ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].survey.isEmpty
                              ? const SizedBox()
                              : Container(
                                  margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Surveys",
                                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (BuildContext context) => const BookMarkSeeAllView(type: 'survey')));
                                          },
                                          child: Text(
                                            "See all",
                                            style: TextStyle(color: const Color(0XFF8C8C8C), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].survey.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 54.75,
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].survey.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 7,
                                  child: ListView.builder(
                                    /*    options: CarouselOptions(enlargeCenterPage: true,enableInfiniteScroll: false),*/
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: mainVariables.bookMarkOverViewAllMain!.value.response[0].survey.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () async {
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
                                              'survey_id': mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].postId,
                                            });
                                            var responseData = json.decode(response.body);
                                            if (responseData["status"]) {
                                              activeStatus = responseData["response"]["status"];
                                              if (activeStatus == "active") {
                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                var response = await http.post(url, headers: {
                                                  'Authorization': mainUserToken
                                                }, body: {
                                                  'survey_id': mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].postId,
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
                                            if (!mounted) {
                                              return;
                                            }
                                            mainUserId == mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].users.id
                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return AnalyticsPage(
                                                      surveyId: mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].postId,
                                                      activity: false,
                                                      surveyTitle: mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].title,
                                                      navBool: false,
                                                      fromWhere: 'similar',
                                                    );
                                                  }))
                                                : activeStatus == 'active'
                                                    ? answerStatus
                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId:
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].postId,
                                                                activity: false,
                                                                navBool: false,
                                                                fromWhere: 'similar',
                                                                surveyTitle:
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].title);
                                                          }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return QuestionnairePage(
                                                              surveyId: mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].postId,
                                                              defaultIndex: answeredQuestion,
                                                            );
                                                          }))
                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].postId,
                                                          activity: false,
                                                          surveyTitle: mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].title,
                                                          navBool: false,
                                                          fromWhere: 'similar',
                                                        );
                                                      }));
                                          },
                                          child: Container(
                                            // margin: EdgeInsets.only(bottom: _height/35),
                                            margin: EdgeInsets.only(left: index == 0 ? width / 27.4 : 0, right: width / 27.4, top: 5, bottom: 5),
                                            width: width / 1.28,
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                                                      blurRadius: 4.0,
                                                      spreadRadius: 0.0)
                                                ]),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: height / 87.6,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            /*await Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext
                                            context) {
                                              return UserProfilePage(
                                                  id: bookMarkOverView
                                                      .response[0]
                                                      .survey[index]
                                                      .users
                                                      .id,
                                                  type: 'forums',
                                                  index: 0);
                                            }));*/
                                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                              return UserBillBoardProfilePage(
                                                                userId:
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].users.id,
                                                              );
                                                            }));
                                                          },
                                                          child: Container(
                                                            height: height / 13.53,
                                                            width: width / 8,
                                                            margin: EdgeInsets.symmetric(vertical: height / 87.6, horizontal: width / 41.1),
                                                            /*margin: EdgeInsets.fromLTRB(
                                                  _width / 23.43,
                                                  _height / 203,
                                                  _width / 37.5,
                                                  _height / 27.06),*/
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.grey,
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index].users
                                                                          .avatar /*forumImagesList[index]*/,
                                                                    ),
                                                                    fit: BoxFit.fill)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 10.95,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                      width: width / 2.055,
                                                                      child: Text(
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index]
                                                                            .title /*forumTitlesList[index]*/,
                                                                        style: TextStyle(
                                                                          fontSize: text.scale(12),
                                                                          fontWeight: FontWeight.w600,
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                        maxLines: 2,
                                                                      )),
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
                                                                                child: userIdMain ==
                                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                            .survey[index].users.id
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
                                                                                                            child: Text("Delete Post",
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
                                                                                                                  backgroundColor:
                                                                                                                      const Color(0XFF0EA102),
                                                                                                                ),
                                                                                                                onPressed: () async {
                                                                                                                  deletePostMain(
                                                                                                                      context: context,
                                                                                                                      id: mainVariables
                                                                                                                          .bookMarkOverViewAllMain!
                                                                                                                          .value
                                                                                                                          .response[0]
                                                                                                                          .survey[index]
                                                                                                                          .postId,
                                                                                                                      locker: 'survey');
                                                                                                                  if (!mounted) {
                                                                                                                    return;
                                                                                                                  }
                                                                                                                  Navigator.pop(context);
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
                                                                                              mainVariables.barController.clear();
                                                                                              mainVariables.actionValueMain = "Report";
                                                                                              showAlertDialogMain(
                                                                                                context: context,
                                                                                                modelSetState: (void Function() fn) {},
                                                                                                locker: 'survey',
                                                                                                id: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                    .response[0].survey[index].postId,
                                                                                                userId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                    .response[0].survey[index].users.id,
                                                                                                initFunction: (void Function() fn) {},
                                                                                              );
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
                                                                                              mainVariables.barController.clear();
                                                                                              mainVariables.actionValueMain = "Block";
                                                                                              if (!mounted) {
                                                                                                return;
                                                                                              }
                                                                                              Navigator.pop(context);
                                                                                              showAlertDialogMain(
                                                                                                context: context,
                                                                                                modelSetState: (void Function() fn) {},
                                                                                                locker: 'survey',
                                                                                                id: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                    .response[0].survey[index].postId,
                                                                                                userId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                    .response[0].survey[index].users.id,
                                                                                                initFunction: getData,
                                                                                              );
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
                                                                ],
                                                              ),
                                                              GestureDetector(
                                                                onTap: () async {
                                                                  /* await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (BuildContext
                                                      context) {
                                                        return UserProfilePage(
                                                            id: bookMarkOverView
                                                                .response[0]
                                                                .survey[index]
                                                                .users
                                                                .id,
                                                            type: 'forums',
                                                            index: 0);
                                                      }));*/
                                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return UserBillBoardProfilePage(
                                                                      userId: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].survey[index].users.id,
                                                                    );
                                                                  }));
                                                                },
                                                                child: SizedBox(
                                                                    height: height / 54.13,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].survey[index].users.username
                                                                              .toString()
                                                                              .capitalizeFirst!,
                                                                          //forumSourceNameList[index].toString().capitalizeFirst!,
                                                                          style: TextStyle(fontSize: text.scale(9), fontWeight: FontWeight.w500),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Container(
                                                                          height: 5,
                                                                          width: 5,
                                                                          decoration:
                                                                              const BoxDecoration(shape: BoxShape.circle, color: Color(0xffA5A5A5)),
                                                                        ),
                                                                        const SizedBox(
                                                                          width: 5,
                                                                        ),
                                                                        Text(
                                                                          mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].survey[index].questionsCount
                                                                              .toString() /*surveyQuestionList[index]*/
                                                                              .toString(),
                                                                          style: TextStyle(fontSize: text.scale(9), fontWeight: FontWeight.w500),
                                                                        ),
                                                                        Text(
                                                                          " Questions",
                                                                          style: TextStyle(fontSize: text.scale(9), fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: width / 2.055,
                                                                    child: Row(
                                                                      children: [
                                                                        SizedBox(
                                                                            width: width / 7.5,
                                                                            child: Text(
                                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index]
                                                                                    .companyName /*forumCompanyList[index]*/,
                                                                                style: TextStyle(
                                                                                    fontSize: text.scale(10),
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Colors.blue))),
                                                                        SizedBox(width: width / 28),
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            kUserSearchController.clear();
                                                                            onTapType = "Views";
                                                                            onTapId = mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].survey[index].postId;
                                                                            onLike = false;
                                                                            onDislike = false;
                                                                            onViews = true;
                                                                            idKeyMain = "forum_id";
                                                                            apiMain = baseurl + versionForum + viewsCount;
                                                                            onTapIdMain = mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].survey[index].postId;
                                                                            onTapTypeMain = "Views";
                                                                            haveViewsMain = mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                        .survey[index].viewsCount >
                                                                                    0
                                                                                ? true
                                                                                : false;
                                                                            viewCountMain = mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].survey[index].viewsCount;
                                                                            kToken = kToken;

                                                                            //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionForum + viewsCount, idKey: 'forum_id', setState: setState);
                                                                            bool data = await likeCountFunc(
                                                                                context: context, newSetState: (void Function() fn) {});
                                                                            if (data) {
                                                                              if (!mounted) {
                                                                                return;
                                                                              }
                                                                              customShowSheet1(context: context);
                                                                              loaderMain = true;
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
                                                                              Text(
                                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                      .survey[index].viewsCount
                                                                                      .toString() /*forumViewsList[index].toString()*/,
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                              Text(" views",
                                                                                  style: TextStyle(
                                                                                      fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: width / 28),
                                                                        Text(
                                                                            mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].survey[index].answersCount
                                                                                .toString() /*forumResponseList[index].toString()*/,
                                                                            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w700)),
                                                                        Text(" Answers",
                                                                            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  bookMarkWidgetMultiple(
                                                                    bookMark: mainVariables.bookMarKTotalList,
                                                                    context: context,
                                                                    scale: 4,
                                                                    id: mainVariables.bookMarkOverViewAllMain!.value.response[0].survey[index]
                                                                        .postId /*forumIdList[index]*/,
                                                                    type: 'survey',
                                                                    initFunction: getData,
                                                                    index: index,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: height / 87.6,
                                                ),
                                              ],
                                            ),
                                          ));
                                    },
                                  ),
                                ),
                          SizedBox(
                            height: height / 54.75,
                          ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].users.isEmpty
                              ? const SizedBox()
                              : Container(
                                  margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Users",
                                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (BuildContext context) => const BookMarkSeeAllView(type: 'users')));
                                          },
                                          child: Text(
                                            "See all",
                                            style: TextStyle(color: const Color(0XFF8C8C8C), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].users.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 54.75,
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].users.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 7,
                                  child: ListView.builder(
                                    itemCount: mainVariables.bookMarkOverViewAllMain!.value.response[0].users.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () {
                                            /*Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return UserProfilePage(
                                  id: bookMarkOverView.response[0]
                                      .users[index].postId,
                                  type: 'forums',
                                  index: 0);
                            }));*/
                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                              return UserBillBoardProfilePage(
                                                userId: mainVariables.bookMarkOverViewAllMain!.value.response[0].users[index].postId,
                                              );
                                            }));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(left: index == 0 ? width / 27.4 : 0, right: width / 27.4, top: 5, bottom: 5),
                                            width: width / 1.28,
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                                                      blurRadius: 4.0,
                                                      spreadRadius: 0.0)
                                                ]),
                                            /*width: width / 1.67,
                                            margin: EdgeInsets.symmetric(vertical: height / 35, horizontal: width / 41.1),
                                            // margin: EdgeInsets.symmetric(horizontal: 5),
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.background,
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                                                      blurRadius: 4.0,
                                                      spreadRadius: 0.0)
                                                ]),*/
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    /*Navigator.push(context,
                                    MaterialPageRoute(builder:
                                        (BuildContext context) {
                                      return UserProfilePage(
                                          id: bookMarkOverView
                                              .response[0]
                                              .users[index]
                                              .postId,
                                          type: 'forums',
                                          index: 0);
                                    }));*/
                                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return UserBillBoardProfilePage(
                                                        userId: mainVariables.bookMarkOverViewAllMain!.value.response[0].users[index].postId,
                                                      );
                                                    }));
                                                  },
                                                  child: Container(
                                                    height: height / 13.53,
                                                    width: width / 6.5,
                                                    margin: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey,
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                              mainVariables.bookMarkOverViewAllMain!.value.response[0].users[index]
                                                                  .avatar /*forumImagesList[index]*/,
                                                            ),
                                                            fit: BoxFit.fill)),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: width / 2.74,
                                                      child: Text(
                                                        "${mainVariables.bookMarkOverViewAllMain!.value.response[0].users[index].firstName} ${mainVariables.bookMarkOverViewAllMain!.value.response[0].users[index].lastName}" /*forumTitlesList[index]*/,
                                                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].users[index]
                                                          .username, //forumSourceNameList[index].toString().capitalizeFirst!,
                                                      style: TextStyle(
                                                          fontSize: text.scale(9), color: const Color(0XFFAFAFAF), fontWeight: FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    SizedBox(
                                                      width: width / 2.74,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                /*Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                                  return UserProfilePage(
                                                      id: bookMarkOverView
                                                          .response[0]
                                                          .users[index]
                                                          .postId,
                                                      type: 'forums',
                                                      index: 0);
                                                }));*/
                                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return UserBillBoardProfilePage(
                                                                    userId:
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].users[index].postId,
                                                                  );
                                                                }));
                                                              },
                                                              child: Container(
                                                                  height: height / 35.04,
                                                                  width: width / 6.85,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(5), color: const Color(0XFF0CA202)),
                                                                  child: Center(
                                                                      child: Text(
                                                                    "Visit profile",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(9),
                                                                        color: const Color(0XFFFFFFFF),
                                                                        fontWeight: FontWeight.w600),
                                                                  )))),
                                                          Row(
                                                            children: [
                                                              bookMarkWidgetMultiple(
                                                                bookMark: mainVariables.bookMarKTotalList,
                                                                context: context,
                                                                scale: 4,
                                                                id: mainVariables.bookMarkOverViewAllMain!.value.response[0].users[index]
                                                                    .postId /*forumIdList[index]*/,
                                                                type: 'users',
                                                                initFunction: getData,
                                                                index: index,
                                                              ),
                                                              SizedBox(
                                                                width: width / 27.4,
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ));
                                    },
                                  ),
                                ),
                          SizedBox(
                            height: height / 54.75,
                          ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.isEmpty
                              ? const SizedBox()
                              : Container(
                                  margin: EdgeInsets.symmetric(horizontal: width / 27.4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "BillBoard",
                                        style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (BuildContext context) => const BookMarkSeeAllView(type: 'billboard')));
                                          },
                                          child: Text(
                                            "See all",
                                            style: TextStyle(color: const Color(0XFF8C8C8C), fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 54.75,
                                ),
                          mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: height / 4.15,
                                  child: ListView.builder(
                                    itemCount: mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      return Container(
                                        /*margin: EdgeInsets.only(left: index == 0 ? 15 : 0, right: 15),
                                        width: width / 1.28,*/
                                        margin: EdgeInsets.only(left: index == 0 ? width / 27.4 : 0, right: width / 27.4, bottom: 2.5),
                                        width: width / 1.28,
                                        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                        decoration: BoxDecoration(
                                          //color: Theme.of(context).colorScheme.background,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                                              blurRadius: 4.0,
                                              spreadRadius: 0.0,
                                            ),
                                          ],
                                        ),
                                        child: mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type == "byte"
                                            ? mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].files.isEmpty
                                                ? Column(
                                                    children: [
                                                      Container(
                                                        height: height / 20,
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(context).colorScheme.background,
                                                            borderRadius:
                                                                const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                                                                blurRadius: 4.0,
                                                                spreadRadius: 0.0,
                                                              )
                                                            ]),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: height / 173.2,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                SizedBox(
                                                                  width: width / 41.1,
                                                                ),
                                                                billboardWidgetsMain.getProfile(
                                                                    context: context,
                                                                    heightValue: height / 28.86,
                                                                    widthValue: width / 13.7,
                                                                    myself: false,
                                                                    isProfile: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].profileType,
                                                                    avatar: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].avatar,
                                                                    userId: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId),
                                                                SizedBox(
                                                                  width: width / 41.1,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap: () {
                                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return UserBillBoardProfilePage(
                                                                                userId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .billBoard[index].userId);
                                                                          }));
                                                                        },
                                                                        child: Text(
                                                                          mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].username
                                                                              .toString()
                                                                              .capitalizeFirst!,
                                                                          style: TextStyle(
                                                                              fontSize: text.scale(10),
                                                                              fontWeight: FontWeight.w700,
                                                                              fontFamily: "Poppins"),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index]
                                                                                .createdAt,
                                                                            style: TextStyle(
                                                                                fontSize: text.scale(8),
                                                                                color: const Color(0XFF737373),
                                                                                fontWeight: FontWeight.w400,
                                                                                fontFamily: "Poppins"),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 3,
                                                                          ),
                                                                          Text(
                                                                            " | ",
                                                                            style: TextStyle(
                                                                              fontSize: text.scale(8),
                                                                              color: const Color(0XFF737373),
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 3,
                                                                          ),
                                                                          InkWell(
                                                                            onTap: () {
                                                                              billboardWidgetsMain.believersTabBottomSheet(
                                                                                context: context,
                                                                                id: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .billBoard[index].userId,
                                                                                isBelieversList: true,
                                                                              );
                                                                            },
                                                                            child: Text(
                                                                              "${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].believersCount} Believers",
                                                                              style: TextStyle(
                                                                                  fontSize: text.scale(8),
                                                                                  color: const Color(0XFF737373),
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontFamily: "Poppins"),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: height / 173.2),
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          switch (mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type) {
                                                            case "blog":
                                                              {
                                                                mainVariables.selectedBillboardIdMain.value =
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext context) => const BlogDescriptionPage(
                                                                              fromWhere: "profile",
                                                                            )));
                                                                break;
                                                              }
                                                            case "byte":
                                                              {
                                                                mainVariables.selectedBillboardIdMain.value =
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext context) =>
                                                                            const BytesDescriptionPage(fromWhere: "profile")));
                                                                break;
                                                              }
                                                            case "forums":
                                                              {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                            idList: List.generate(
                                                                                mainVariables
                                                                                    .bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                                (ind) => mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .billBoard[ind].postId),
                                                                            comeFrom: "billBoardHome",
                                                                            forumId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                .billBoard[index].postId)));
                                                                break;
                                                              }
                                                            case "survey":
                                                              {
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
                                                                  'survey_id': mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                });
                                                                var responseData = json.decode(response.body);
                                                                if (responseData["status"]) {
                                                                  activeStatus = responseData["response"]["status"];
                                                                  if (activeStatus == "active") {
                                                                    var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                    var response = await http.post(url, headers: {
                                                                      'Authorization': mainUserToken
                                                                    }, body: {
                                                                      'survey_id': mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
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
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                mainUserId ==
                                                                        mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId
                                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                          surveyId: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                          activity: false,
                                                                          surveyTitle: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].title,
                                                                          navBool: false,
                                                                          fromWhere: 'similar',
                                                                        );
                                                                      }))
                                                                    : activeStatus == 'active'
                                                                        ? answerStatus
                                                                            ? Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return AnalyticsPage(
                                                                                    surveyId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                        .billBoard[index].postId,
                                                                                    activity: false,
                                                                                    navBool: false,
                                                                                    fromWhere: 'similar',
                                                                                    surveyTitle: mainVariables.bookMarkOverViewAllMain!.value
                                                                                        .response[0].billBoard[index].title);
                                                                              }))
                                                                            : Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return QuestionnairePage(
                                                                                  surveyId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                      .billBoard[index].postId,
                                                                                  defaultIndex: answeredQuestion,
                                                                                );
                                                                              }))
                                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                              surveyId: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                              activity: false,
                                                                              surveyTitle: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].title,
                                                                              navBool: false,
                                                                              fromWhere: 'similar',
                                                                            );
                                                                          }));
                                                                break;
                                                              }
                                                            default:
                                                              {
                                                                break;
                                                              }
                                                          }
                                                        },
                                                        child: Container(
                                                          height: height / 8,
                                                          color: Theme.of(context).colorScheme.onBackground,
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(12.0),
                                                            child: Text(
                                                              mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].title
                                                                  .toString()
                                                                  .capitalizeFirst!,
                                                              style: TextStyle(
                                                                fontSize: text.scale(12),
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                              textAlign: TextAlign.justify,
                                                              maxLines: 3,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).colorScheme.background,
                                                          borderRadius: const BorderRadius.only(
                                                              bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              height: height / 173.2,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(children: [
                                                                  SizedBox(
                                                                    width: width / 82.2,
                                                                  ),
                                                                  billboardWidgetsMain.likeButtonBookMarkListWidget(
                                                                    likeList: List.generate(
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                        (ind) => mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].like),
                                                                    id: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                    index: index,
                                                                    context: context,
                                                                    initFunction: () {},
                                                                    modelSetState: setState,
                                                                    notUse: true,
                                                                    dislikeList: List.generate(
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                        (ind) => mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].dislike),
                                                                    likeCountList: List.generate(
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                        (ind) => mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].likesCount),
                                                                    dislikeCountList: List.generate(
                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                        (ind) => mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].disLikesCount),
                                                                    type: 'billboard',
                                                                    billBoardType: mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                            'survey'
                                                                        ? 'survey'
                                                                        : 'billboard',
                                                                    image: "",
                                                                    title: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].title,
                                                                    description: "",
                                                                    fromWhere: 'homePage',
                                                                    responseId: '',
                                                                    controller: TextEditingController(),
                                                                    commentId: '',
                                                                    postUserId: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId,
                                                                    responseFocusList: [],
                                                                    responseUserId: '',
                                                                    valueMapList: mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard,
                                                                  ),
                                                                  SizedBox(
                                                                    width: width / 27.4,
                                                                  ),
                                                                  bookMarkWidgetMultiple(
                                                                    bookMark: mainVariables.bookMarKTotalList,
                                                                    context: context,
                                                                    scale: 4,
                                                                    id: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                    type: 'billboard',
                                                                    index: index,
                                                                    initFunction: getData,
                                                                  ),
                                                                ]),
                                                              ],
                                                            ),
                                                            SizedBox(height: height / 173.2),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].companyName,
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: const Color(0xFF017FDB),
                                                                        fontWeight: FontWeight.bold),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                                          context: context,
                                                                          billBoardId: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                          responseId: "",
                                                                          commentId: "",
                                                                          billBoardType: "billboard",
                                                                          action: "views",
                                                                          likeCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount
                                                                              .toString(),
                                                                          disLikeCount: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                              .billBoard[index].disLikesCount
                                                                              .toString(),
                                                                          index: 0,
                                                                          viewCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount
                                                                              .toString(),
                                                                          isViewIncluded: true);
                                                                    },
                                                                    child: Text(
                                                                      " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount} views ",
                                                                      style: TextStyle(fontSize: text.scale(10)),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                                          context: context,
                                                                          billBoardId: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                          responseId: "",
                                                                          commentId: "",
                                                                          billBoardType: "billboard",
                                                                          action: "likes",
                                                                          likeCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount
                                                                              .toString(),
                                                                          disLikeCount: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                              .billBoard[index].disLikesCount
                                                                              .toString(),
                                                                          index: 1,
                                                                          viewCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount
                                                                              .toString(),
                                                                          isViewIncluded: true);
                                                                    },
                                                                    child: Text(
                                                                      " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount} likes ",
                                                                      style: TextStyle(fontSize: text.scale(10)),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                                          context: context,
                                                                          billBoardId: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                          responseId: "",
                                                                          commentId: "",
                                                                          billBoardType: "billboard",
                                                                          action: "dislikes",
                                                                          likeCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount
                                                                              .toString(),
                                                                          disLikeCount: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                              .billBoard[index].disLikesCount
                                                                              .toString(),
                                                                          index: 2,
                                                                          viewCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount
                                                                              .toString(),
                                                                          isViewIncluded: true);
                                                                    },
                                                                    child: Text(
                                                                      " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].disLikesCount} DisLikes ",
                                                                      style: TextStyle(fontSize: text.scale(10)),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      switch (mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type) {
                                                                        case "blog":
                                                                          {
                                                                            mainVariables.selectedBillboardIdMain.value = mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (BuildContext context) =>
                                                                                        const BlogDescriptionPage(fromWhere: "profile")));
                                                                            break;
                                                                          }
                                                                        case "byte":
                                                                          {
                                                                            mainVariables.selectedBillboardIdMain.value = mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (BuildContext context) =>
                                                                                        const BytesDescriptionPage(fromWhere: "profile")));
                                                                            break;
                                                                          }
                                                                        case "forums":
                                                                          {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                        idList: List.generate(
                                                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                                .billBoard.length,
                                                                                            (ind) => mainVariables.bookMarkOverViewAllMain!.value
                                                                                                .response[0].billBoard[ind].postId),
                                                                                        comeFrom: "billBoardHome",
                                                                                        forumId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                            .response[0].billBoard[index].postId)));
                                                                            break;
                                                                          }
                                                                        case "survey":
                                                                          {
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
                                                                              'survey_id': mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                            });
                                                                            var responseData = json.decode(response.body);
                                                                            if (responseData["status"]) {
                                                                              activeStatus = responseData["response"]["status"];
                                                                              if (activeStatus == "active") {
                                                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                                var response = await http.post(url, headers: {
                                                                                  'Authorization': mainUserToken
                                                                                }, body: {
                                                                                  'survey_id': mainVariables.bookMarkOverViewAllMain!.value
                                                                                      .response[0].billBoard[index].postId,
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
                                                                            if (!mounted) {
                                                                              return;
                                                                            }
                                                                            mainUserId ==
                                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                        .billBoard[index].userId
                                                                                ? Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                    return AnalyticsPage(
                                                                                      surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                          .response[0].billBoard[index].postId,
                                                                                      activity: false,
                                                                                      surveyTitle: mainVariables.bookMarkOverViewAllMain!.value
                                                                                          .response[0].billBoard[index].title,
                                                                                      navBool: false,
                                                                                      fromWhere: 'similar',
                                                                                    );
                                                                                  }))
                                                                                : activeStatus == 'active'
                                                                                    ? answerStatus
                                                                                        ? Navigator.push(context,
                                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                                            return AnalyticsPage(
                                                                                                surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                    .response[0].billBoard[index].postId,
                                                                                                activity: false,
                                                                                                navBool: false,
                                                                                                fromWhere: 'similar',
                                                                                                surveyTitle: mainVariables.bookMarkOverViewAllMain!
                                                                                                    .value.response[0].billBoard[index].title);
                                                                                          }))
                                                                                        : Navigator.push(context,
                                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                                            return QuestionnairePage(
                                                                                              surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                  .response[0].billBoard[index].postId,
                                                                                              defaultIndex: answeredQuestion,
                                                                                            );
                                                                                          }))
                                                                                    : Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                        return AnalyticsPage(
                                                                                          surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                              .response[0].billBoard[index].postId,
                                                                                          activity: false,
                                                                                          surveyTitle: mainVariables.bookMarkOverViewAllMain!.value
                                                                                              .response[0].billBoard[index].title,
                                                                                          navBool: false,
                                                                                          fromWhere: 'similar',
                                                                                        );
                                                                                      }));
                                                                            break;
                                                                          }
                                                                        default:
                                                                          {
                                                                            break;
                                                                          }
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].responseCount} Responses ",
                                                                      style: TextStyle(fontSize: text.scale(10)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: height / 173.2),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          switch (mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type) {
                                                            case "blog":
                                                              {
                                                                mainVariables.selectedBillboardIdMain.value =
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext context) =>
                                                                            const BlogDescriptionPage(fromWhere: "profile")));
                                                                break;
                                                              }
                                                            case "byte":
                                                              {
                                                                mainVariables.selectedBillboardIdMain.value =
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext context) =>
                                                                            const BytesDescriptionPage(fromWhere: "profile")));
                                                                break;
                                                              }
                                                            case "forums":
                                                              {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                            idList: List.generate(
                                                                                mainVariables
                                                                                    .bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                                (ind) => mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .billBoard[ind].postId),
                                                                            comeFrom: "billBoardHome",
                                                                            forumId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                .billBoard[index].postId)));
                                                                break;
                                                              }
                                                            case "survey":
                                                              {
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
                                                                  'survey_id': mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                });
                                                                var responseData = json.decode(response.body);
                                                                if (responseData["status"]) {
                                                                  activeStatus = responseData["response"]["status"];

                                                                  if (activeStatus == "active") {
                                                                    var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                    var response = await http.post(url, headers: {
                                                                      'Authorization': mainUserToken
                                                                    }, body: {
                                                                      'survey_id': mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
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
                                                                if (!mounted) {
                                                                  return;
                                                                }
                                                                mainUserId ==
                                                                        mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId
                                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                          surveyId: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                          activity: false,
                                                                          surveyTitle: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].title,
                                                                          navBool: false,
                                                                          fromWhere: 'similar',
                                                                        );
                                                                      }))
                                                                    : activeStatus == 'active'
                                                                        ? answerStatus
                                                                            ? Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return AnalyticsPage(
                                                                                    surveyId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                        .billBoard[index].postId,
                                                                                    activity: false,
                                                                                    navBool: false,
                                                                                    fromWhere: 'similar',
                                                                                    surveyTitle: mainVariables.bookMarkOverViewAllMain!.value
                                                                                        .response[0].billBoard[index].title);
                                                                              }))
                                                                            : Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return QuestionnairePage(
                                                                                  surveyId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                      .billBoard[index].postId,
                                                                                  defaultIndex: answeredQuestion,
                                                                                );
                                                                              }))
                                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                              surveyId: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                              activity: false,
                                                                              surveyTitle: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].title,
                                                                              navBool: false,
                                                                              fromWhere: 'similar',
                                                                            );
                                                                          }));
                                                                break;
                                                              }
                                                            default:
                                                              {
                                                                break;
                                                              }
                                                          }
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                                height: height / 6,
                                                                width: width,
                                                                decoration: const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                                ),
                                                                child: CarouselSlider.builder(
                                                                  carouselController: _carController,
                                                                  options: CarouselOptions(
                                                                      enableInfiniteScroll: false,
                                                                      enlargeCenterPage: false,
                                                                      onPageChanged: (int index, CarouselPageChangedReason reason) {
                                                                        setState(() {
                                                                          carouselIndexGlobal = index;
                                                                        });
                                                                      }),
                                                                  itemCount: mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].billBoard[index].files.length,
                                                                  itemBuilder: (BuildContext context, int carouselIndex, int realIndex) {
                                                                    return mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index]
                                                                                .files[carouselIndex].type ==
                                                                            "image"
                                                                        ? Image.network(
                                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index]
                                                                                .files[carouselIndex].file,
                                                                            fit: BoxFit.fill,
                                                                          )
                                                                        : mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index]
                                                                                    .files[carouselIndex].type ==
                                                                                "video"
                                                                            ? Stack(
                                                                                alignment: Alignment.center,
                                                                                children: [
                                                                                  Image.asset(
                                                                                    "lib/Constants/Assets/Settings/coverImage_default.png",
                                                                                    fit: BoxFit.fill,
                                                                                    height: height / 3.97,
                                                                                  ),
                                                                                  Container(
                                                                                      height: 50,
                                                                                      width: 50,
                                                                                      decoration: BoxDecoration(
                                                                                          shape: BoxShape.circle,
                                                                                          color: Colors.black26.withOpacity(0.7)),
                                                                                      child: const Icon(
                                                                                        Icons.play_arrow_sharp,
                                                                                        color: Colors.white,
                                                                                        size: 40,
                                                                                      ))
                                                                                ],
                                                                              )
                                                                            : mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                        .billBoard[index].files[carouselIndex].type ==
                                                                                    "document"
                                                                                ? Stack(
                                                                                    alignment: Alignment.center,
                                                                                    children: [
                                                                                      Image.asset(
                                                                                        "lib/Constants/Assets/Settings/coverImage.png",
                                                                                        fit: BoxFit.fill,
                                                                                        height: height / 3.97,
                                                                                      ),
                                                                                      Container(
                                                                                        height: 50,
                                                                                        width: 50,
                                                                                        decoration: BoxDecoration(
                                                                                          shape: BoxShape.circle,
                                                                                          color: Colors.black26.withOpacity(0.3),
                                                                                        ),
                                                                                        child: Center(
                                                                                          child: Image.asset(
                                                                                            "lib/Constants/Assets/BillBoard/document.png",
                                                                                            color: Colors.white,
                                                                                            height: 25,
                                                                                            width: 25,
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                : const SizedBox();
                                                                  },
                                                                )),
                                                            Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              child: Container(
                                                                height: height / 18,
                                                                width: width / 1.29,
                                                                padding: EdgeInsets.only(
                                                                  left: width / 27.4,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black26.withOpacity(0.3),
                                                                  borderRadius: const BorderRadius.only(
                                                                    topLeft: Radius.circular(15),
                                                                    topRight: Radius.circular(15),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        bookMarkWidgetMultiple(
                                                                          bookMark: mainVariables.bookMarKTotalList,
                                                                          context: context,
                                                                          scale: 4,
                                                                          id: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                              .billBoard[index].postId /*forumIdList[index]*/,
                                                                          type: 'billboard',
                                                                          index: index,
                                                                          initFunction: getData,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].files.length > 1
                                                                ? Positioned(
                                                                    bottom: 75,
                                                                    left: (width / 2) - 35,
                                                                    child: SizedBox(
                                                                      height: 5,
                                                                      child: ListView.builder(
                                                                          shrinkWrap: true,
                                                                          scrollDirection: Axis.horizontal,
                                                                          physics: const NeverScrollableScrollPhysics(),
                                                                          itemCount: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                              .billBoard[index].files.length,
                                                                          itemBuilder: (BuildContext context, int index1) {
                                                                            return Container(
                                                                              height: 5,
                                                                              width: carouselIndexGlobal == index1 ? 20 : 5,
                                                                              margin: const EdgeInsets.symmetric(horizontal: 3),
                                                                              decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                  color: carouselIndexGlobal == index1
                                                                                      ? const Color(0XFF0EA102)
                                                                                      : Colors.white),
                                                                            );
                                                                          }),
                                                                    ))
                                                                : const SizedBox(),
                                                            Positioned(
                                                              bottom: 0,
                                                              left: 0,
                                                              child: Container(
                                                                height: height / 20,
                                                                width: width,
                                                                padding: EdgeInsets.only(
                                                                    top: height / 86.6,
                                                                    bottom: height / 86.6,
                                                                    right: width / 13.7,
                                                                    left: width / 41.1),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.black12.withOpacity(0.3),
                                                                ),
                                                                child: Text(
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].title
                                                                      .toString()
                                                                      .capitalizeFirst!,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(12),
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontFamily: "Poppins",
                                                                      overflow: TextOverflow.ellipsis),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          color: Theme.of(context).colorScheme.background,
                                                          borderRadius: const BorderRadius.only(
                                                              bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            SizedBox(
                                                              height: height / 173.2,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                SizedBox(
                                                                  width: width / 82.2,
                                                                ),
                                                                billboardWidgetsMain.getProfile(
                                                                    context: context,
                                                                    heightValue: height / 28.86,
                                                                    widthValue: width / 13.7,
                                                                    myself: false,
                                                                    avatar: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].avatar,
                                                                    isProfile: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].profileType,
                                                                    userId: mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId),
                                                                SizedBox(
                                                                  width: width / 41.1,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap: () {
                                                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return UserBillBoardProfilePage(
                                                                                userId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .billBoard[index].userId);
                                                                          }));
                                                                        },
                                                                        child: Text(
                                                                          mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].username
                                                                              .toString()
                                                                              .capitalizeFirst!,
                                                                          style: TextStyle(
                                                                              fontSize: text.scale(10),
                                                                              fontWeight: FontWeight.w700,
                                                                              fontFamily: "Poppins"),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 5,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index]
                                                                                .createdAt,
                                                                            style: TextStyle(
                                                                                fontSize: text.scale(8),
                                                                                color: const Color(0XFF737373),
                                                                                fontWeight: FontWeight.w400,
                                                                                fontFamily: "Poppins"),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 3,
                                                                          ),
                                                                          Text(
                                                                            " | ",
                                                                            style: TextStyle(
                                                                              fontSize: text.scale(8),
                                                                              color: const Color(0XFF737373),
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 3,
                                                                          ),
                                                                          InkWell(
                                                                            onTap: () async {
                                                                              billboardWidgetsMain.believersTabBottomSheet(
                                                                                context: context,
                                                                                id: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .billBoard[index].userId,
                                                                                isBelieversList: true,
                                                                              );
                                                                            },
                                                                            child: Text(
                                                                              "${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].believersCount} Believers",
                                                                              style: TextStyle(
                                                                                  fontSize: text.scale(8),
                                                                                  color: const Color(0XFF737373),
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontFamily: "Poppins"),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                billboardWidgetsMain.likeButtonBookMarkListWidget(
                                                                  likeList: List.generate(
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                      (ind) => mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].like),
                                                                  id: mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                  index: index,
                                                                  context: context,
                                                                  initFunction: () {},
                                                                  modelSetState: setState,
                                                                  notUse: true,
                                                                  dislikeList: List.generate(
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                      (ind) => mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].dislike),
                                                                  likeCountList: List.generate(
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                      (ind) => mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].likesCount),
                                                                  dislikeCountList: List.generate(
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                      (ind) => mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].disLikesCount),
                                                                  type: 'billboard',
                                                                  billBoardType: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                          'survey'
                                                                      ? 'survey'
                                                                      : 'billboard',
                                                                  image: "",
                                                                  title:
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].title,
                                                                  description: "",
                                                                  fromWhere: 'homePage',
                                                                  responseId: '',
                                                                  controller: TextEditingController(),
                                                                  commentId: '',
                                                                  postUserId: mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId,
                                                                  responseFocusList: [],
                                                                  responseUserId: '',
                                                                  valueMapList: mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard,
                                                                ),
                                                                SizedBox(
                                                                  width: width / 41.1,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: height / 173.2),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    mainVariables
                                                                        .bookMarkOverViewAllMain!.value.response[0].billBoard[index].companyName,
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(8),
                                                                        color: const Color(0xFF017FDB),
                                                                        fontWeight: FontWeight.bold),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                                          context: context,
                                                                          billBoardId: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                          responseId: "",
                                                                          commentId: "",
                                                                          billBoardType: "billboard",
                                                                          action: "views",
                                                                          likeCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount
                                                                              .toString(),
                                                                          disLikeCount: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                              .billBoard[index].disLikesCount
                                                                              .toString(),
                                                                          index: 0,
                                                                          viewCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount
                                                                              .toString(),
                                                                          isViewIncluded: true);
                                                                    },
                                                                    child: Text(
                                                                      " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount} views ",
                                                                      style: TextStyle(fontSize: text.scale(8)),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                                          context: context,
                                                                          billBoardId: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                          responseId: "",
                                                                          commentId: "",
                                                                          billBoardType: "billboard",
                                                                          action: "likes",
                                                                          likeCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount
                                                                              .toString(),
                                                                          disLikeCount: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                              .billBoard[index].disLikesCount
                                                                              .toString(),
                                                                          index: 1,
                                                                          viewCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount
                                                                              .toString(),
                                                                          isViewIncluded: true);
                                                                    },
                                                                    child: Text(
                                                                      " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount} likes ",
                                                                      style: TextStyle(fontSize: text.scale(8)),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                                          context: context,
                                                                          billBoardId: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                          responseId: "",
                                                                          commentId: "",
                                                                          billBoardType: "billboard",
                                                                          action: "dislikes",
                                                                          likeCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount
                                                                              .toString(),
                                                                          disLikeCount: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                              .billBoard[index].disLikesCount
                                                                              .toString(),
                                                                          index: 2,
                                                                          viewCount: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount
                                                                              .toString(),
                                                                          isViewIncluded: true);
                                                                    },
                                                                    child: Text(
                                                                      " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].disLikesCount} DisLikes ",
                                                                      style: TextStyle(fontSize: text.scale(8)),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      switch (mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type) {
                                                                        case "blog":
                                                                          {
                                                                            mainVariables.selectedBillboardIdMain.value = mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (BuildContext context) =>
                                                                                        const BlogDescriptionPage(fromWhere: "profile")));
                                                                            break;
                                                                          }
                                                                        case "byte":
                                                                          {
                                                                            mainVariables.selectedBillboardIdMain.value = mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (BuildContext context) =>
                                                                                        const BytesDescriptionPage(fromWhere: "profile")));
                                                                            break;
                                                                          }
                                                                        case "forums":
                                                                          {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                        idList: List.generate(
                                                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                                .billBoard.length,
                                                                                            (ind) => mainVariables.bookMarkOverViewAllMain!.value
                                                                                                .response[0].billBoard[index].postId),
                                                                                        comeFrom: "billBoardHome",
                                                                                        forumId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                            .response[0].billBoard[index].postId)));
                                                                            break;
                                                                          }
                                                                        case "survey":
                                                                          {
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
                                                                              'survey_id': mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                            });
                                                                            var responseData = json.decode(response.body);
                                                                            if (responseData["status"]) {
                                                                              activeStatus = responseData["response"]["status"];
                                                                              if (activeStatus == "active") {
                                                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                                var response = await http.post(url, headers: {
                                                                                  'Authorization': mainUserToken
                                                                                }, body: {
                                                                                  'survey_id': mainVariables.bookMarkOverViewAllMain!.value
                                                                                      .response[0].billBoard[index].postId,
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
                                                                            if (!mounted) {
                                                                              return;
                                                                            }
                                                                            mainUserId ==
                                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                        .billBoard[index].userId
                                                                                ? Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                    return AnalyticsPage(
                                                                                      surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                          .response[0].billBoard[index].postId,
                                                                                      activity: false,
                                                                                      surveyTitle: mainVariables.bookMarkOverViewAllMain!.value
                                                                                          .response[0].billBoard[index].title,
                                                                                      navBool: false,
                                                                                      fromWhere: 'similar',
                                                                                    );
                                                                                  }))
                                                                                : activeStatus == 'active'
                                                                                    ? answerStatus
                                                                                        ? Navigator.push(context,
                                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                                            return AnalyticsPage(
                                                                                                surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                    .response[0].billBoard[index].postId,
                                                                                                activity: false,
                                                                                                navBool: false,
                                                                                                fromWhere: 'similar',
                                                                                                surveyTitle: mainVariables.bookMarkOverViewAllMain!
                                                                                                    .value.response[0].billBoard[index].title);
                                                                                          }))
                                                                                        : Navigator.push(context,
                                                                                            MaterialPageRoute(builder: (BuildContext context) {
                                                                                            return QuestionnairePage(
                                                                                              surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                  .response[0].billBoard[index].postId,
                                                                                              defaultIndex: answeredQuestion,
                                                                                            );
                                                                                          }))
                                                                                    : Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                        return AnalyticsPage(
                                                                                          surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                              .response[0].billBoard[index].postId,
                                                                                          activity: false,
                                                                                          surveyTitle: mainVariables.bookMarkOverViewAllMain!.value
                                                                                              .response[0].billBoard[index].title,
                                                                                          navBool: false,
                                                                                          fromWhere: 'similar',
                                                                                        );
                                                                                      }));
                                                                            break;
                                                                          }
                                                                        default:
                                                                          {
                                                                            break;
                                                                          }
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].responseCount} Responses ",
                                                                      style: TextStyle(fontSize: text.scale(8)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: height / 173.2),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                            : Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      switch (mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type) {
                                                        case "blog":
                                                          {
                                                            mainVariables.selectedBillboardIdMain.value =
                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) =>
                                                                        const BlogDescriptionPage(fromWhere: "profile")));
                                                            break;
                                                          }
                                                        case "byte":
                                                          {
                                                            mainVariables.selectedBillboardIdMain.value =
                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) =>
                                                                        const BytesDescriptionPage(fromWhere: "profile")));
                                                            break;
                                                          }
                                                        case "forums":
                                                          {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                        idList: List.generate(
                                                                            mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                            (ind) => mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].postId),
                                                                        comeFrom: "billBoardHome",
                                                                        forumId: mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId)));
                                                            break;
                                                          }
                                                        case "survey":
                                                          {
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
                                                              'survey_id':
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                            });
                                                            var responseData = json.decode(response.body);
                                                            if (responseData["status"]) {
                                                              activeStatus = responseData["response"]["status"];

                                                              if (activeStatus == "active") {
                                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                var response = await http.post(url, headers: {
                                                                  'Authorization': mainUserToken
                                                                }, body: {
                                                                  'survey_id': mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
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
                                                            if (!mounted) {
                                                              return;
                                                            }
                                                            mainUserId ==
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId
                                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                      activity: false,
                                                                      surveyTitle: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].title,
                                                                      navBool: false,
                                                                      fromWhere: 'similar',
                                                                    );
                                                                  }))
                                                                : activeStatus == 'active'
                                                                    ? answerStatus
                                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                                surveyId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .billBoard[index].postId,
                                                                                activity: false,
                                                                                navBool: false,
                                                                                fromWhere: 'similar',
                                                                                surveyTitle: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .billBoard[index].title);
                                                                          }))
                                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return QuestionnairePage(
                                                                              surveyId: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                              defaultIndex: answeredQuestion,
                                                                            );
                                                                          }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                          surveyId: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                          activity: false,
                                                                          surveyTitle: mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].title,
                                                                          navBool: false,
                                                                          fromWhere: 'similar',
                                                                        );
                                                                      }));
                                                            break;
                                                          }
                                                        case "news":
                                                          {
                                                            /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                          return DemoPage(
                                                            url: "",
                                                            text: "",
                                                            image: "",
                                                            id: mainVariables
                                                                .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                            type: 'news',
                                                            activity: true,
                                                            checkMain: false,
                                                          );
                                                        }));*/
                                                            Get.to(const DemoView(), arguments: {
                                                              "id": mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                              "type": "news",
                                                              "url": ""
                                                            });
                                                            break;
                                                          }
                                                        default:
                                                          {
                                                            break;
                                                          }
                                                      }
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: height / 6,
                                                          decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius.only(
                                                                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                              gradient: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                      "blog"
                                                                  ? const RadialGradient(
                                                                      colors: [Color.fromRGBO(23, 25, 27, 0.90), Color.fromRGBO(85, 85, 85, 0.00)],
                                                                      radius: 15.0,
                                                                    )
                                                                  : mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                          "forums"
                                                                      ? const RadialGradient(
                                                                          colors: [
                                                                            Color.fromRGBO(0, 92, 175, 0.90),
                                                                            Color.fromRGBO(13, 155, 1, 0.00)
                                                                          ],
                                                                          radius: 15.0,
                                                                        )
                                                                      : mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                              "survey"
                                                                          ? const RadialGradient(
                                                                              colors: [
                                                                                Color.fromRGBO(10, 122, 1, 0.90),
                                                                                Color.fromRGBO(13, 155, 1, 0.00)
                                                                              ],
                                                                              radius: 15.0,
                                                                            )
                                                                          : const RadialGradient(
                                                                              colors: [
                                                                                Color.fromRGBO(255, 255, 255, 1),
                                                                                Color.fromRGBO(255, 255, 255, 1)
                                                                              ],
                                                                              radius: 15.0,
                                                                            ),
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                            "news"
                                                                        ? mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[index].newsImage
                                                                        : "",
                                                                  ),
                                                                  fit: BoxFit.fill)),
                                                          child: Center(
                                                            child: Text(
                                                              mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type == "news"
                                                                  ? ""
                                                                  : mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                          "forums"
                                                                      ? mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type
                                                                          .toString()
                                                                          .capitalizeFirst!
                                                                          .substring(
                                                                              0,
                                                                              mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                      .billBoard[index].type.length -
                                                                                  1)
                                                                      : mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type
                                                                          .toString()
                                                                          .capitalizeFirst!,
                                                              style: TextStyle(
                                                                  fontSize: text.scale(40),
                                                                  fontWeight: FontWeight.w900,
                                                                  color: const Color(0XFFFFFFFF)),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 10,
                                                          left: 10,
                                                          child: bookMarkWidgetMultiple(
                                                            bookMark: mainVariables.bookMarKTotalList,
                                                            context: context,
                                                            scale: 4,
                                                            id: mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                            type: 'billboard',
                                                            index: index,
                                                            initFunction: getData,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          child: Container(
                                                            height: height / 25,
                                                            width: width / 1.28,
                                                            padding: EdgeInsets.only(right: width / 13.7, left: width / 41.1),
                                                            decoration: BoxDecoration(
                                                              color: Colors.black12.withOpacity(0.3),
                                                            ),
                                                            child: Text(
                                                              mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].title
                                                                  .toString()
                                                                  .capitalizeFirst!,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontSize: text.scale(12),
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: "Poppins",
                                                                  overflow: TextOverflow.ellipsis),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.onBackground,
                                                      borderRadius:
                                                          const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: height / 173.2,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            SizedBox(
                                                              width: width / 82.2,
                                                            ),
                                                            billboardWidgetsMain.getProfile(
                                                                context: context,
                                                                heightValue: height / 28.86,
                                                                widthValue: width / 13.7,
                                                                myself: false,
                                                                avatar:
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].avatar,
                                                                isProfile: mainVariables
                                                                    .bookMarkOverViewAllMain!.value.response[0].billBoard[index].profileType,
                                                                userId:
                                                                    mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId),
                                                            SizedBox(
                                                              width: width / 41.1,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return UserBillBoardProfilePage(
                                                                            userId: mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId);
                                                                      }));
                                                                    },
                                                                    child: Text(
                                                                      mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].username
                                                                          .toString()
                                                                          .capitalizeFirst!,
                                                                      style: TextStyle(
                                                                          fontSize: text.scale(10),
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: "Poppins"),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[index].createdAt,
                                                                        style: TextStyle(
                                                                            fontSize: text.scale(8),
                                                                            color: const Color(0XFF737373),
                                                                            fontWeight: FontWeight.w400,
                                                                            fontFamily: "Poppins"),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 3,
                                                                      ),
                                                                      Text(
                                                                        " | ",
                                                                        style: TextStyle(
                                                                          fontSize: text.scale(8),
                                                                          color: const Color(0XFF737373),
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 3,
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () async {
                                                                          billboardWidgetsMain.believersTabBottomSheet(
                                                                            context: context,
                                                                            id: mainVariables
                                                                                .bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId,
                                                                            isBelieversList: true,
                                                                          );
                                                                        },
                                                                        child: Text(
                                                                          "${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].believersCount} Believers",
                                                                          style: TextStyle(
                                                                              fontSize: text.scale(8),
                                                                              color: const Color(0XFF737373),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: "Poppins"),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            billboardWidgetsMain.likeButtonBookMarkListWidget(
                                                              likeList: List.generate(
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                  (ind) =>
                                                                      mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[ind].like),
                                                              id: mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                              index: index,
                                                              context: context,
                                                              initFunction: () {},
                                                              modelSetState: setState,
                                                              notUse: true,
                                                              dislikeList: List.generate(
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                  (ind) => mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].dislike),
                                                              likeCountList: List.generate(
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                  (ind) => mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].likesCount),
                                                              dislikeCountList: List.generate(
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard.length,
                                                                  (ind) => mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].billBoard[ind].disLikesCount),
                                                              type: 'billboard',
                                                              billBoardType:
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                          'survey'
                                                                      ? 'survey'
                                                                      : 'billboard',
                                                              image: "",
                                                              title: mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].title,
                                                              description: "",
                                                              fromWhere: 'homePage',
                                                              responseId: '',
                                                              controller: TextEditingController(),
                                                              commentId: '',
                                                              postUserId:
                                                                  mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].userId,
                                                              responseUserId: '',
                                                              responseFocusList: [],
                                                              valueMapList: mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard,
                                                            ),
                                                            SizedBox(
                                                              width: width / 41.1,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: height / 173.2),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].companyName,
                                                                style: TextStyle(
                                                                    fontSize: text.scale(8),
                                                                    color: const Color(0xFF017FDB),
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                                      context: context,
                                                                      billBoardId: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                      responseId: "",
                                                                      commentId: "",
                                                                      billBoardType: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                              "forums"
                                                                          ? "forums"
                                                                          : mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index]
                                                                                      .type ==
                                                                                  "survey"
                                                                              ? "survey"
                                                                              : "billboard",
                                                                      action: "views",
                                                                      likeCount: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount
                                                                          .toString(),
                                                                      disLikeCount: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].disLikesCount
                                                                          .toString(),
                                                                      index: 0,
                                                                      viewCount: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount
                                                                          .toString(),
                                                                      isViewIncluded: true);
                                                                },
                                                                child: Text(
                                                                  " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount} views ",
                                                                  style: TextStyle(fontSize: text.scale(8)),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                                      context: context,
                                                                      billBoardId: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                      responseId: "",
                                                                      commentId: "",
                                                                      billBoardType: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                              "forums"
                                                                          ? "forums"
                                                                          : mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index]
                                                                                      .type ==
                                                                                  "survey"
                                                                              ? "survey"
                                                                              : "billboard",
                                                                      action: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                              "forums"
                                                                          ? "liked"
                                                                          : "likes",
                                                                      likeCount: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount
                                                                          .toString(),
                                                                      disLikeCount: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].disLikesCount
                                                                          .toString(),
                                                                      index: 1,
                                                                      viewCount: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount
                                                                          .toString(),
                                                                      isViewIncluded: true);
                                                                },
                                                                child: Text(
                                                                  " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount} likes ",
                                                                  style: TextStyle(fontSize: text.scale(8)),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                                      context: context,
                                                                      billBoardId: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                      responseId: "",
                                                                      commentId: "",
                                                                      billBoardType: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                              "forums"
                                                                          ? "forums"
                                                                          : mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index]
                                                                                      .type ==
                                                                                  "survey"
                                                                              ? "survey"
                                                                              : "billboard",
                                                                      action: mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type ==
                                                                              "forums"
                                                                          ? "disliked"
                                                                          : "dislikes",
                                                                      likeCount: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].likesCount
                                                                          .toString(),
                                                                      disLikeCount: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].disLikesCount
                                                                          .toString(),
                                                                      index: 2,
                                                                      viewCount: mainVariables
                                                                          .bookMarkOverViewAllMain!.value.response[0].billBoard[index].viewsCount
                                                                          .toString(),
                                                                      isViewIncluded: true);
                                                                },
                                                                child: Text(
                                                                  " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].disLikesCount} DisLikes ",
                                                                  style: TextStyle(fontSize: text.scale(8)),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  switch (mainVariables
                                                                      .bookMarkOverViewAllMain!.value.response[0].billBoard[index].type) {
                                                                    case "blog":
                                                                      {
                                                                        mainVariables.selectedBillboardIdMain.value = mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) =>
                                                                                    const BlogDescriptionPage(fromWhere: "profile")));
                                                                        break;
                                                                      }
                                                                    case "byte":
                                                                      {
                                                                        mainVariables.selectedBillboardIdMain.value = mainVariables
                                                                            .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId;
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) =>
                                                                                    const BytesDescriptionPage(fromWhere: "profile")));
                                                                        break;
                                                                      }
                                                                    case "forums":
                                                                      {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                    idList: List.generate(
                                                                                        mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                            .billBoard.length,
                                                                                        (ind) => mainVariables.bookMarkOverViewAllMain!.value
                                                                                            .response[0].billBoard[ind].postId),
                                                                                    comeFrom: "billBoardHome",
                                                                                    forumId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                        .billBoard[index].postId)));
                                                                        break;
                                                                      }
                                                                    case "survey":
                                                                      {
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
                                                                          'survey_id': mainVariables
                                                                              .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
                                                                        });
                                                                        var responseData = json.decode(response.body);
                                                                        if (responseData["status"]) {
                                                                          activeStatus = responseData["response"]["status"];

                                                                          if (activeStatus == "active") {
                                                                            var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                            var response = await http.post(url, headers: {
                                                                              'Authorization': mainUserToken
                                                                            }, body: {
                                                                              'survey_id': mainVariables
                                                                                  .bookMarkOverViewAllMain!.value.response[0].billBoard[index].postId,
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
                                                                        if (!mounted) {
                                                                          return;
                                                                        }
                                                                        mainUserId ==
                                                                                mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                    .billBoard[index].userId
                                                                            ? Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return AnalyticsPage(
                                                                                  surveyId: mainVariables.bookMarkOverViewAllMain!.value.response[0]
                                                                                      .billBoard[index].postId,
                                                                                  activity: false,
                                                                                  surveyTitle: mainVariables.bookMarkOverViewAllMain!.value
                                                                                      .response[0].billBoard[index].title,
                                                                                  navBool: false,
                                                                                  fromWhere: 'similar',
                                                                                );
                                                                              }))
                                                                            : activeStatus == 'active'
                                                                                ? answerStatus
                                                                                    ? Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                        return AnalyticsPage(
                                                                                            surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                .response[0].billBoard[index].postId,
                                                                                            activity: false,
                                                                                            navBool: false,
                                                                                            fromWhere: 'similar',
                                                                                            surveyTitle: mainVariables.bookMarkOverViewAllMain!.value
                                                                                                .response[0].billBoard[index].title);
                                                                                      }))
                                                                                    : Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                        return QuestionnairePage(
                                                                                          surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                              .response[0].billBoard[index].postId,
                                                                                          defaultIndex: answeredQuestion,
                                                                                        );
                                                                                      }))
                                                                                : Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                    return AnalyticsPage(
                                                                                      surveyId: mainVariables.bookMarkOverViewAllMain!.value
                                                                                          .response[0].billBoard[index].postId,
                                                                                      activity: false,
                                                                                      surveyTitle: mainVariables.bookMarkOverViewAllMain!.value
                                                                                          .response[0].billBoard[index].title,
                                                                                      navBool: false,
                                                                                      fromWhere: 'similar',
                                                                                    );
                                                                                  }));
                                                                        break;
                                                                      }
                                                                    default:
                                                                      {
                                                                        break;
                                                                      }
                                                                  }
                                                                },
                                                                child: Text(
                                                                  " ${mainVariables.bookMarkOverViewAllMain!.value.response[0].billBoard[index].responseCount} Responses ",
                                                                  style: TextStyle(fontSize: text.scale(8)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 173.2,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                      );
                                    },
                                  ),
                                ),
                          SizedBox(
                            height: height / 54.75,
                          ),
                        ],
                      ),
              ),
            )
          : Center(
              child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.76, width: width / 4.11),
            ),
    ));
  }
}
