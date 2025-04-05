import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/API.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/questionnaire_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Blog/blog_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/BusinessProfile/business_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Bytes/bytes_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/Intermediary/intermediary.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_widgets.dart';

class BillBoardHomeWidget2 {
  TextEditingController bottomSheetController = TextEditingController();
  final CarouselController _carController = CarouselController();
  int carouselIndexGlobal = 0;

  Widget selectedNormalWidget(
      {required BuildContext context,
      required int index,
      required List<NativeAd> nativeAdList,
      required nativeAdIsLoadedList,
      required Function getBillBoardListData,
      required Function getData,
      required StateSetter modelSetState}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
        padding: EdgeInsets.only(left: width / 41.1, right: width / 41.1),
        child: Column(children: [
          Stack(
            children: [
              mainVariables.valueMapListProfilePage[index].type == "byte"
                  ? mainVariables.valueMapListProfilePage[index].files.isEmpty
                      ? mainVariables.valueMapListProfilePage[index].postType == "repost"
                          ? mainVariables.activeTypeMain.value == "believed"
                              ? mainVariables.valueMapListProfilePage[index].repostStatus == 1
                                  ? mainVariables.valueMapListProfilePage[index].repostType == "private"
                                      ? mainVariables.valueMapListProfilePage[index].repostBelieved
                                          ? Container(
                                              padding: const EdgeInsets.all(1.5),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                                BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)
                                                /*BoxShadow(
                                                    color: Colors.black26.withOpacity(0.1),
                                                    offset: const Offset(0.0, -0.5),
                                                    blurRadius: 1.0,
                                                    spreadRadius: 1.0)*/
                                              ]),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background.withOpacity(0.5), //Colors.grey.shade200,
                                                      borderRadius:
                                                          const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: height / 86.6,
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
                                                              heightValue: height / 17.32,
                                                              widthValue: width / 8.22,
                                                              myself: false,
                                                              isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                                              avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                                              userId: mainVariables.valueMapListProfilePage[index].userId,
                                                              repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                                              repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                                              isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                                              getBillBoardListData: getBillBoardListData,
                                                            ),
                                                            SizedBox(
                                                              width: width / 41.1,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                              id:valueMapList[index].userId,type:'forums',index:0);}));*/
                                                                      /*bool response = await Navigator.push(context,
                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                        return UserBillBoardProfilePage(
                                                                            userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                      }));*/
                                                                      if (mainVariables.valueMapListProfilePage[index].profileType !=
                                                                              "intermediate" ||
                                                                          mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                        mainVariables.selectedTickerId.value =
                                                                            mainVariables.valueMapListProfilePage[index].userId;
                                                                      }
                                                                      bool response = await Navigator.push(context,
                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                        return mainVariables.valueMapListProfilePage[index].profileType ==
                                                                                "intermediate"
                                                                            ? IntermediaryBillBoardProfilePage(
                                                                                userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                            : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                                ? const BusinessProfilePage()
                                                                                : UserBillBoardProfilePage(
                                                                                    userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                      }));
                                                                      if (response) {
                                                                        getBillBoardListData();
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      mainVariables.valueMapListProfilePage[index].username
                                                                          .toString()
                                                                          .capitalizeFirst!,
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .labelLarge /*TextStyle(
                                                                          fontSize: text.scale(12),
                                                                          color: const Color(0XFF202020),
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: "Poppins")*/
                                                                      ,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        mainVariables.valueMapListProfilePage[index].createdAt,
                                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: const Color(0XFF737373),
                                                                            ), /*TextStyle(
                                                                            fontSize: text.scale(10),
                                                                            color: const Color(0XFF737373),
                                                                            fontWeight: FontWeight.w400,
                                                                            fontFamily: "Poppins"),*/
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 3,
                                                                      ),
                                                                      Text(
                                                                        " | ",
                                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: const Color(0XFF737373),
                                                                            ), /*TextStyle(
                                                                          fontSize: text.scale(11),
                                                                          color: const Color(0XFF737373),
                                                                          fontWeight: FontWeight.w400,
                                                                        ),*/
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 3,
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () {
                                                                          billboardWidgetsMain.believersTabBottomSheet(
                                                                            context: context,
                                                                            id: mainVariables.valueMapListProfilePage[index].userId,
                                                                            isBelieversList: true,
                                                                          );
                                                                        },
                                                                        child: Text(
                                                                          "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                                fontWeight: FontWeight.w400,
                                                                                color: const Color(0XFF737373),
                                                                              ), /*TextStyle(
                                                                              fontSize: text.scale(10),
                                                                              color: const Color(0XFF737373),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: "Poppins"),*/
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                                ? billboardWidgetsMain.getHomeBelieveButton(
                                                                    heightValue: height / 33.76,
                                                                    isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                        (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                                    billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                                    billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                                    context: context,
                                                                    modelSetState: modelSetState,
                                                                    index: index,
                                                                    background: false,
                                                                  )
                                                                : const SizedBox(),

                                                            ///more_vert
                                                            IconButton(
                                                                onPressed: () {
                                                                  billboardWidgetsMain.bottomSheet(
                                                                    context1: context,
                                                                    myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                                    billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                                    billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                    type: "billboard",
                                                                    responseId: "",
                                                                    responseUserId: "",
                                                                    commentId: "",
                                                                    commentUserId: "",
                                                                    callFunction: getData,
                                                                    contentType: mainVariables.valueMapListProfilePage[index].type,
                                                                    modelSetState: modelSetState,
                                                                    responseDetail: {},
                                                                    category: mainVariables.valueMapListProfilePage[index].category,
                                                                    valueMapList: mainVariables.valueMapListProfilePage,
                                                                    index: index,
                                                                  );
                                                                },
                                                                icon: Icon(
                                                                  Icons.more_vert,
                                                                  color: Theme.of(context).colorScheme.onPrimary,
                                                                  size: 25,
                                                                ))
                                                          ],
                                                        ),
                                                        SizedBox(height: height / 64),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      switch (mainVariables.valueMapListProfilePage[index].type) {
                                                        case "blog":
                                                          {
                                                            mainVariables.selectedBillboardIdMain.value =
                                                                mainVariables.valueMapListProfilePage[index].id;
                                                            Navigator.push(context,
                                                                MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                            break;
                                                          }
                                                        case "byte":
                                                          {
                                                            mainVariables.selectedBillboardIdMain.value =
                                                                mainVariables.valueMapListProfilePage[index].id;
                                                            Navigator.push(context,
                                                                MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                            break;
                                                          }
                                                        case "forums":
                                                          {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                        idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                            (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                        comeFrom: "billBoardHome",
                                                                        forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                            });
                                                            var responseData = json.decode(response.body);
                                                            if (responseData["status"]) {
                                                              activeStatus = responseData["response"]["status"];
                                                              if (activeStatus == "active") {
                                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                var response = await http.post(url, headers: {
                                                                  'Authorization': mainUserToken
                                                                }, body: {
                                                                  'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                            mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                      activity: false,
                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                      navBool: false,
                                                                      fromWhere: 'similar',
                                                                    );
                                                                  }))
                                                                : activeStatus == 'active'
                                                                    ? answerStatus
                                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                                surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                activity: false,
                                                                                navBool: false,
                                                                                fromWhere: 'similar',
                                                                                surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                          }))
                                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return QuestionnairePage(
                                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                              defaultIndex: answeredQuestion,
                                                                            );
                                                                          }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                          activity: false,
                                                                          surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                      height: height / 9,
                                                      color: Theme.of(context).colorScheme.background,
                                                      alignment: Alignment.topLeft,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: RichText(
                                                          textAlign: TextAlign.left,
                                                          text: TextSpan(
                                                            children: conversationFunctionsMain.spanListBillBoardHome(
                                                                message: mainVariables.valueMapListProfilePage[index].title.length > 140
                                                                    ? mainVariables.valueMapListProfilePage[index].title.substring(0, 140)
                                                                    : mainVariables.valueMapListProfilePage[index].title,
                                                                context: context,
                                                                isByte: true),
                                                          ),
                                                        ) /*Text( mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                     style:TextStyle(
                                                       fontSize: _text.scale(14),
                                                       fontWeight: FontWeight.w400,
                                                       color: Color(0XFF403D3D),
                                                     ),
                                                     textAlign: TextAlign.justify,
                                                     maxLines: 3,
                                                     overflow: TextOverflow.ellipsis,
                                                   )*/
                                                        ,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                                      borderRadius:
                                                          const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: height / 86.6,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(children: [
                                                              SizedBox(
                                                                width: width / 41.1,
                                                              ),
                                                              billboardWidgetsMain.likeButtonHomeListWidget(
                                                                likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                                                id: mainVariables.valueMapListProfilePage[index].id,
                                                                index: index,
                                                                context: context,
                                                                initFunction: () {},
                                                                modelSetState: modelSetState,
                                                                notUse: true,
                                                                dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                                                likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                                                dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                                                type: mainVariables.valueMapListProfilePage[index].type,
                                                                billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                    ? "news"
                                                                    : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                        ? "forums"
                                                                        : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                            ? "survey"
                                                                            : "billboard",
                                                                /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                                                image: mainVariables.valueMapListProfilePage[index].avatar,
                                                                title: mainVariables.valueMapListProfilePage[index].title,
                                                                description: "",
                                                                fromWhere: 'homePage',
                                                                responseId: '',
                                                                controller: bottomSheetController,
                                                                commentId: '',
                                                                postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                responseFocusList: mainVariables.responseFocusList,
                                                                responseUserId: '',
                                                                valueMapList: mainVariables.valueMapListProfilePage,
                                                              ),
                                                              SizedBox(
                                                                width: width / 27.4,
                                                              ),
                                                              /*bookMarkWidget(
                                                        bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) =>  mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                        context: context,
                                                        scale: 3.2,
                                                        id: mainVariables.valueMapListProfilePage[index].id,
                                                        type:mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                        modelSetState: modelSetState,
                                                        index: index,
                                                        initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                        notUse: false,
                                                      ),*/
                                                              billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                            ]),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                                        mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                                                    ? const SizedBox()
                                                                    : GestureDetector(
                                                                        onTap: () {
                                                                          billboardWidgetsMain.believedTabBottomSheet(
                                                                              context: context,
                                                                              id: mainVariables.valueMapListProfilePage[index].repostId,
                                                                              type: mainVariables.valueMapListProfilePage[index].type);
                                                                        },
                                                                        child: Stack(
                                                                          children: [
                                                                            const SizedBox(
                                                                              height: 30,
                                                                              width: 30,
                                                                            ),
                                                                            Positioned(
                                                                              left: 0,
                                                                              bottom: 0,
                                                                              child: Container(
                                                                                height: 25,
                                                                                width: 25,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                    image: const DecorationImage(
                                                                                      image: AssetImage(
                                                                                          "lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: 0,
                                                                              right: 0,
                                                                              child: Container(
                                                                                height: 15,
                                                                                width: 15,
                                                                                decoration:
                                                                                    const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                                                child: Center(
                                                                                    child: Text(
                                                                                  mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                                      ? "9+"
                                                                                      : mainVariables.valueMapListProfilePage[index].repostCount
                                                                                          .toString(),
                                                                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                                )),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                SizedBox(
                                                                  width: width / 27.4,
                                                                ),
                                                                SizedBox(
                                                                  height: 35,
                                                                  width: 35,
                                                                  child: billboardWidgetsMain.translationWidget(
                                                                      id: mainVariables.valueMapListProfilePage[index].id,
                                                                      type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                          ? "forums"
                                                                          : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                              ? "survey"
                                                                              : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                                  ? "news"
                                                                                  : 'billboard',
                                                                      index: index,
                                                                      initFunction: getData,
                                                                      context: context,
                                                                      modelSetState: modelSetState,
                                                                      notUse: false,
                                                                      valueMapList: mainVariables.valueMapListProfilePage),
                                                                ),
                                                                SizedBox(
                                                                  width: width / 27.4,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: height / 64),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                mainVariables.valueMapListProfilePage[index].companyName,
                                                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                                      fontWeight: FontWeight.w700,
                                                                      color: const Color(0xFF017FDB),
                                                                    ), /*TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0xFF017FDB),
                                                                    fontWeight: FontWeight.bold),*/
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                                      context: context,
                                                                      billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                      responseId: "",
                                                                      commentId: "",
                                                                      billBoardType: "billboard",
                                                                      action: "views",
                                                                      likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                      disLikeCount:
                                                                          mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                      index: 0,
                                                                      viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                      isViewIncluded: true);
                                                                },
                                                                child: Text(
                                                                  " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: Theme.of(context).colorScheme.tertiary /*Colors.black54*/),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                                      context: context,
                                                                      billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                      responseId: "",
                                                                      commentId: "",
                                                                      billBoardType: "billboard",
                                                                      action: "likes",
                                                                      likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                      disLikeCount:
                                                                          mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                      index: 1,
                                                                      viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                      isViewIncluded: true);
                                                                },
                                                                child: Text(
                                                                  " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: Theme.of(context).colorScheme.tertiary /*Colors.black54*/),
                                                                ),
                                                              ),
                                                              /*InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:"billboard",
                                                          action:"dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                              InkWell(
                                                                onTap: () async {
                                                                  switch (mainVariables.valueMapListProfilePage[index].type) {
                                                                    case "blog":
                                                                      {
                                                                        mainVariables.selectedBillboardIdMain.value =
                                                                            mainVariables.valueMapListProfilePage[index].id;
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) => const BlogDescriptionPage()));
                                                                        break;
                                                                      }
                                                                    case "byte":
                                                                      {
                                                                        mainVariables.selectedBillboardIdMain.value =
                                                                            mainVariables.valueMapListProfilePage[index].id;
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) => const BytesDescriptionPage()));
                                                                        break;
                                                                      }
                                                                    case "forums":
                                                                      {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                    idList: List.generate(
                                                                                        mainVariables.valueMapListProfilePage.length,
                                                                                        (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                                    comeFrom: "billBoardHome",
                                                                                    forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                                        });
                                                                        var responseData = json.decode(response.body);
                                                                        if (responseData["status"]) {
                                                                          activeStatus = responseData["response"]["status"];
                                                                          if (activeStatus == "active") {
                                                                            var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                            var response = await http.post(url, headers: {
                                                                              'Authorization': mainUserToken
                                                                            }, body: {
                                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                                        mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                            ? Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return AnalyticsPage(
                                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                  activity: false,
                                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                                  navBool: false,
                                                                                  fromWhere: 'similar',
                                                                                );
                                                                              }))
                                                                            : activeStatus == 'active'
                                                                                ? answerStatus
                                                                                    ? Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                        return AnalyticsPage(
                                                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                            activity: false,
                                                                                            navBool: false,
                                                                                            fromWhere: 'similar',
                                                                                            surveyTitle:
                                                                                                mainVariables.valueMapListProfilePage[index].title);
                                                                                      }))
                                                                                    : Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                        return QuestionnairePage(
                                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                          defaultIndex: answeredQuestion,
                                                                                        );
                                                                                      }))
                                                                                : Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                    return AnalyticsPage(
                                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                      activity: false,
                                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                                  " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: Theme.of(context).colorScheme.tertiary /*Colors.black54*/),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: height / 42.6),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  /*bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return UserBillBoardProfilePage(
                                                                      userId: userIdMain,
                                                                    );
                                                                  }));*/
                                                                  if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                                      mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                    mainVariables.selectedTickerId.value =
                                                                        mainVariables.valueMapListProfilePage[index].userId;
                                                                  }
                                                                  bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                        ? IntermediaryBillBoardProfilePage(
                                                                            userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                        : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                            ? const BusinessProfilePage()
                                                                            : UserBillBoardProfilePage(
                                                                                userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                  }));
                                                                  if (response) {
                                                                    getBillBoardListData();
                                                                  }
                                                                },
                                                                child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                              ),
                                                              SizedBox(
                                                                width: width / 41.1,
                                                              ),
                                                              billboardWidgetsMain.getResponseField(
                                                                context: context,
                                                                modelSetState: modelSetState,
                                                                billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                responseId: "",
                                                                index: index,
                                                                fromWhere: 'homePage',
                                                                callFunction: () {},
                                                                contentType: mainVariables.valueMapListProfilePage[index].type,
                                                                category: mainVariables.valueMapListProfilePage[index].category,
                                                                responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : //final //believed, private, status1, believedCategory, NoFiles, byte
                                          Container(
                                              padding: const EdgeInsets.all(1.5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                                  boxShadow: [
                                                    BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)
                                                  ]),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 100.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                          width: width / 1.2,
                                                          child: Text(
                                                            "Exclusive Content: This post is private and only visible to those who believe. Believe ${mainVariables.valueMapListProfilePage[index].username} to unveil the full content.",
                                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                color: Theme.of(context)
                                                                    .colorScheme
                                                                    .background) /*const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)*/,
                                                            textAlign: TextAlign.center,
                                                          )),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      SizedBox(
                                                        width: width / 3.5,
                                                        child: userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                            ? billboardWidgetsMain.getRepostBelieveButton(
                                                                heightValue: height / 33.76,
                                                                billboardUserid: mainVariables.valueMapListProfilePage[index].repostUser,
                                                                billboardUserName: mainVariables.valueMapListProfilePage[index].repostUserName,
                                                                context: context,
                                                                modelSetState: modelSetState,
                                                                index: index,
                                                                background: true,
                                                              )
                                                            : const SizedBox(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                      : //exclusive //notBelieved, private, status1, believedCategory, NoFiles, byte
                                      Container(
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                            BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)
                                          ]),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: height / 86.6,
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
                                                          heightValue: height / 17.32,
                                                          widthValue: width / 8.22,
                                                          myself: false,
                                                          isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                                          avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                                          userId: mainVariables.valueMapListProfilePage[index].userId,
                                                          repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                                          repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                                          isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                                          getBillBoardListData: getBillBoardListData,
                                                        ),
                                                        SizedBox(
                                                          width: width / 41.1,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                              id:valueMapList[index].userId,type:'forums',index:0);}));*/
                                                                  /*bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return UserBillBoardProfilePage(
                                                                        userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                  }));*/
                                                                  if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                                      mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                    mainVariables.selectedTickerId.value =
                                                                        mainVariables.valueMapListProfilePage[index].userId;
                                                                  }
                                                                  bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                        ? IntermediaryBillBoardProfilePage(
                                                                            userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                        : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                            ? const BusinessProfilePage()
                                                                            : UserBillBoardProfilePage(
                                                                                userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                  }));
                                                                  if (response) {
                                                                    getBillBoardListData();
                                                                  }
                                                                },
                                                                child: Text(
                                                                    mainVariables.valueMapListProfilePage[index].username.toString().capitalizeFirst!,
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .labelLarge /*TextStyle(
                                                                      fontSize: text.scale(12),
                                                                      color: const Color(0XFF202020),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontFamily: "Poppins"),*/
                                                                    ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    mainVariables.valueMapListProfilePage[index].createdAt,
                                                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                          fontWeight: FontWeight.w400,
                                                                          color: const Color(0XFF737373),
                                                                        ), /*TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: const Color(0XFF737373),
                                                                        fontWeight: FontWeight.w400,
                                                                        fontFamily: "Poppins"),*/
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Text(
                                                                    " | ",
                                                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                          fontWeight: FontWeight.w400,
                                                                          color: const Color(0XFF737373),
                                                                        ), /*TextStyle(
                                                                      fontSize: text.scale(11),
                                                                      color: const Color(0XFF737373),
                                                                      fontWeight: FontWeight.w400,
                                                                    ),*/
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      billboardWidgetsMain.believersTabBottomSheet(
                                                                        context: context,
                                                                        id: mainVariables.valueMapListProfilePage[index].userId,
                                                                        isBelieversList: true,
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                      "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                            fontWeight: FontWeight.w400,
                                                                            color: const Color(0XFF737373),
                                                                          ), /*TextStyle(
                                                                          fontSize: text.scale(10),
                                                                          color: const Color(0XFF737373),
                                                                          fontWeight: FontWeight.w400,
                                                                          fontFamily: "Poppins"),*/
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                            ? billboardWidgetsMain.getHomeBelieveButton(
                                                                heightValue: height / 33.76,
                                                                isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                                billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                                billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                                context: context,
                                                                modelSetState: modelSetState,
                                                                index: index,
                                                                background: false,
                                                              )
                                                            : const SizedBox(),

                                                        ///more_vert
                                                        IconButton(
                                                            onPressed: () {
                                                              billboardWidgetsMain.bottomSheet(
                                                                context1: context,
                                                                myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                                billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                                billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                type: "billboard",
                                                                responseId: "",
                                                                responseUserId: "",
                                                                commentId: "",
                                                                commentUserId: "",
                                                                callFunction: getData,
                                                                contentType: mainVariables.valueMapListProfilePage[index].type,
                                                                modelSetState: modelSetState,
                                                                responseDetail: {},
                                                                category: mainVariables.valueMapListProfilePage[index].category,
                                                                valueMapList: mainVariables.valueMapListProfilePage,
                                                                index: index,
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons.more_vert,
                                                              color: Theme.of(context).colorScheme.onPrimary /*Colors.black*/,
                                                              size: 25,
                                                            ))
                                                      ],
                                                    ),
                                                    SizedBox(height: height / 64),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  switch (mainVariables.valueMapListProfilePage[index].type) {
                                                    case "blog":
                                                      {
                                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                        break;
                                                      }
                                                    case "byte":
                                                      {
                                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                        break;
                                                      }
                                                    case "forums":
                                                      {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                    idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                        (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                    comeFrom: "billBoardHome",
                                                                    forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                        });
                                                        var responseData = json.decode(response.body);
                                                        if (responseData["status"]) {
                                                          activeStatus = responseData["response"]["status"];
                                                          if (activeStatus == "active") {
                                                            var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                            var response = await http.post(url, headers: {
                                                              'Authorization': mainUserToken
                                                            }, body: {
                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                        mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                  activity: false,
                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                  navBool: false,
                                                                  fromWhere: 'similar',
                                                                );
                                                              }))
                                                            : activeStatus == 'active'
                                                                ? answerStatus
                                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                            activity: false,
                                                                            navBool: false,
                                                                            fromWhere: 'similar',
                                                                            surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                      }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return QuestionnairePage(
                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                          defaultIndex: answeredQuestion,
                                                                        );
                                                                      }))
                                                                : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                      activity: false,
                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                  height: height / 9,
                                                  color: Theme.of(context).colorScheme.background,
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(12.0),
                                                    child: RichText(
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: conversationFunctionsMain.spanListBillBoardHome(
                                                            message: mainVariables.valueMapListProfilePage[index].title.length > 140
                                                                ? mainVariables.valueMapListProfilePage[index].title.substring(0, 140)
                                                                : mainVariables.valueMapListProfilePage[index].title,
                                                            context: context,
                                                            isByte: true),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                                  borderRadius:
                                                      const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: height / 86.6,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Row(children: [
                                                          SizedBox(
                                                            width: width / 41.1,
                                                          ),
                                                          billboardWidgetsMain.likeButtonHomeListWidget(
                                                            likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            index: index,
                                                            context: context,
                                                            initFunction: () {},
                                                            modelSetState: modelSetState,
                                                            notUse: true,
                                                            dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                                            likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                                            dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                                            type: mainVariables.valueMapListProfilePage[index].type,
                                                            billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                ? "news"
                                                                : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                    ? "forums"
                                                                    : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                        ? "survey"
                                                                        : "billboard",
                                                            /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                                            image: mainVariables.valueMapListProfilePage[index].avatar,
                                                            title: mainVariables.valueMapListProfilePage[index].title,
                                                            description: "",
                                                            fromWhere: 'homePage',
                                                            responseId: '',
                                                            controller: bottomSheetController,
                                                            commentId: '',
                                                            postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                            responseFocusList: mainVariables.responseFocusList,
                                                            responseUserId: '',
                                                            valueMapList: mainVariables.valueMapListProfilePage,
                                                          ),
                                                          SizedBox(
                                                            width: width / 27.4,
                                                          ),
                                                          /*bookMarkWidget(
                                                        bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) =>  mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                        context: context,
                                                        scale: 3.2,
                                                        id: mainVariables.valueMapListProfilePage[index].id,
                                                        type:mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                        modelSetState: modelSetState,
                                                        index: index,
                                                        initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                        notUse: false,
                                                      ),*/
                                                          billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                        ]),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                                    mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                                                ? const SizedBox()
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      billboardWidgetsMain.believedTabBottomSheet(
                                                                          context: context,
                                                                          id: mainVariables.valueMapListProfilePage[index].repostId,
                                                                          type: mainVariables.valueMapListProfilePage[index].type);
                                                                    },
                                                                    child: Stack(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height: 30,
                                                                          width: 30,
                                                                        ),
                                                                        Positioned(
                                                                          left: 0,
                                                                          bottom: 0,
                                                                          child: Container(
                                                                            height: 25,
                                                                            width: 25,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                image: const DecorationImage(
                                                                                  image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                                )),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          top: 0,
                                                                          right: 0,
                                                                          child: Container(
                                                                            height: 15,
                                                                            width: 15,
                                                                            decoration:
                                                                                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                                            child: Center(
                                                                                child: Text(
                                                                              mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                                  ? "9+"
                                                                                  : mainVariables.valueMapListProfilePage[index].repostCount
                                                                                      .toString(),
                                                                              style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                            )),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                            SizedBox(
                                                              width: width / 27.4,
                                                            ),
                                                            SizedBox(
                                                              height: 35,
                                                              width: 35,
                                                              child: billboardWidgetsMain.translationWidget(
                                                                  id: mainVariables.valueMapListProfilePage[index].id,
                                                                  type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                      ? "forums"
                                                                      : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                          ? "survey"
                                                                          : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                              ? "news"
                                                                              : 'billboard',
                                                                  index: index,
                                                                  initFunction: getData,
                                                                  context: context,
                                                                  modelSetState: modelSetState,
                                                                  notUse: false,
                                                                  valueMapList: mainVariables.valueMapListProfilePage),
                                                            ),
                                                            SizedBox(
                                                              width: width / 27.4,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: height / 64),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            mainVariables.valueMapListProfilePage[index].companyName,
                                                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                                  fontWeight: FontWeight.w700,
                                                                  color: const Color(0xFF017FDB),
                                                                ), /*TextStyle(
                                                                fontSize: text.scale(10),
                                                                color: const Color(0xFF017FDB),
                                                                fontWeight: FontWeight.bold),*/
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              billboardWidgetsMain.getLikeDislikeUsersList(
                                                                  context: context,
                                                                  billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                  responseId: "",
                                                                  commentId: "",
                                                                  billBoardType: "billboard",
                                                                  action: "views",
                                                                  likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                  disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                  index: 0,
                                                                  viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                  isViewIncluded: true);
                                                            },
                                                            child: Text(
                                                              " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                              style: TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: Theme.of(context).colorScheme.tertiary /*Colors.black54*/),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              billboardWidgetsMain.getLikeDislikeUsersList(
                                                                  context: context,
                                                                  billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                  responseId: "",
                                                                  commentId: "",
                                                                  billBoardType: "billboard",
                                                                  action: "likes",
                                                                  likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                  disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                  index: 1,
                                                                  viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                  isViewIncluded: true);
                                                            },
                                                            child: Text(
                                                              " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                              style: TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: Theme.of(context).colorScheme.tertiary /*Colors.black54*/),
                                                            ),
                                                          ),
                                                          /* InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:"billboard",
                                                          action:"dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                          InkWell(
                                                            onTap: () async {
                                                              switch (mainVariables.valueMapListProfilePage[index].type) {
                                                                case "blog":
                                                                  {
                                                                    mainVariables.selectedBillboardIdMain.value =
                                                                        mainVariables.valueMapListProfilePage[index].id;
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext context) => const BlogDescriptionPage()));

                                                                    break;
                                                                  }
                                                                case "byte":
                                                                  {
                                                                    mainVariables.selectedBillboardIdMain.value =
                                                                        mainVariables.valueMapListProfilePage[index].id;
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext context) => const BytesDescriptionPage()));
                                                                    break;
                                                                  }
                                                                case "forums":
                                                                  {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                                comeFrom: "billBoardHome",
                                                                                forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                                      'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                                    });
                                                                    var responseData = json.decode(response.body);
                                                                    if (responseData["status"]) {
                                                                      activeStatus = responseData["response"]["status"];
                                                                      if (activeStatus == "active") {
                                                                        var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                        var response = await http.post(url, headers: {
                                                                          'Authorization': mainUserToken
                                                                        }, body: {
                                                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                                    mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                              activity: false,
                                                                              surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                              navBool: false,
                                                                              fromWhere: 'similar',
                                                                            );
                                                                          }))
                                                                        : activeStatus == 'active'
                                                                            ? answerStatus
                                                                                ? Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                    return AnalyticsPage(
                                                                                        surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                        activity: false,
                                                                                        navBool: false,
                                                                                        fromWhere: 'similar',
                                                                                        surveyTitle:
                                                                                            mainVariables.valueMapListProfilePage[index].title);
                                                                                  }))
                                                                                : Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                    return QuestionnairePage(
                                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                      defaultIndex: answeredQuestion,
                                                                                    );
                                                                                  }))
                                                                            : Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return AnalyticsPage(
                                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                  activity: false,
                                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                              " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                              style: TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: Theme.of(context).colorScheme.tertiary /*Colors.black54*/),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: height / 42.6),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              /*bool response =
                                                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return UserBillBoardProfilePage(
                                                                  userId: userIdMain,
                                                                );
                                                              }));*/
                                                              if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                                  mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                mainVariables.selectedTickerId.value =
                                                                    mainVariables.valueMapListProfilePage[index].userId;
                                                              }
                                                              bool response =
                                                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                    ? IntermediaryBillBoardProfilePage(
                                                                        userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                    : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                        ? const BusinessProfilePage()
                                                                        : UserBillBoardProfilePage(
                                                                            userId: mainVariables.valueMapListProfilePage[index].userId);
                                                              }));
                                                              if (response) {
                                                                getBillBoardListData();
                                                              }
                                                            },
                                                            child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                          ),
                                                          SizedBox(
                                                            width: width / 41.1,
                                                          ),
                                                          billboardWidgetsMain.getResponseField(
                                                            context: context,
                                                            modelSetState: modelSetState,
                                                            billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                            postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                            responseId: "",
                                                            index: index,
                                                            fromWhere: 'homePage',
                                                            callFunction: () {},
                                                            contentType: mainVariables.valueMapListProfilePage[index].type,
                                                            category: mainVariables.valueMapListProfilePage[index].category,
                                                            responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                  : //final  //public, status1, believedCategory, NoFiles, byte
                                  Container(
                                      padding: const EdgeInsets.all(1.5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)]),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 50.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: width / 1.2,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "lib/Constants/Assets/BillBoard/failImage.png",
                                                        scale: 2,
                                                      ),
                                                      Text(
                                                        "whoops!",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(fontStyle: FontStyle.italic, color: Theme.of(context).colorScheme.background),
                                                        /* TextStyle(
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.w900,
                                                            color: Colors.white,
                                                            fontStyle: FontStyle.italic),*/
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  )),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              SizedBox(
                                                  width: width / 1.2,
                                                  child: Text(
                                                    "Content might be deleted or no longer active to display",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(color: Theme.of(context).colorScheme.background),
                                                    /*TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),*/
                                                    textAlign: TextAlign.center,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                              : //exclusive  //status0, believedCategory, NoFiles, byte
                              Container(
                                  padding: const EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)]),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: height / 86.6,
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
                                                  heightValue: height / 17.32,
                                                  widthValue: width / 8.22,
                                                  myself: false,
                                                  isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                                  avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                                  userId: mainVariables.valueMapListProfilePage[index].userId,
                                                  repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                                  repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                                  isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                                  getBillBoardListData: getBillBoardListData,
                                                ),
                                                SizedBox(
                                                  width: width / 41.1,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                              id:valueMapList[index].userId,type:'forums',index:0);}));*/
                                                          /*bool response =
                                                              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return UserBillBoardProfilePage(
                                                                userId: mainVariables.valueMapListProfilePage[index].userId);
                                                          }));*/
                                                          if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                              mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                            mainVariables.selectedTickerId.value =
                                                                mainVariables.valueMapListProfilePage[index].userId;
                                                          }
                                                          bool response =
                                                              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                ? IntermediaryBillBoardProfilePage(
                                                                    userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                    ? const BusinessProfilePage()
                                                                    : UserBillBoardProfilePage(
                                                                        userId: mainVariables.valueMapListProfilePage[index].userId);
                                                          }));
                                                          if (response) {
                                                            getBillBoardListData();
                                                          }
                                                        },
                                                        child: Text(mainVariables.valueMapListProfilePage[index].username.toString().capitalizeFirst!,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .labelLarge /*TextStyle(
                                                              fontSize: text.scale(12),
                                                              color: const Color(0XFF202020),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Poppins"),*/
                                                            ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            mainVariables.valueMapListProfilePage[index].createdAt,
                                                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                  fontWeight: FontWeight.w400,
                                                                  color: const Color(0XFF737373),
                                                                ), /*TextStyle(
                                                                fontSize: text.scale(10),
                                                                color: const Color(0XFF737373),
                                                                fontWeight: FontWeight.w400,
                                                                fontFamily: "Poppins"),*/
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            " | ",
                                                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                  fontWeight: FontWeight.w400,
                                                                  color: const Color(0XFF737373),
                                                                ), /*TextStyle(
                                                              fontSize: text.scale(11),
                                                              color: const Color(0XFF737373),
                                                              fontWeight: FontWeight.w400,
                                                            ),*/
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              billboardWidgetsMain.believersTabBottomSheet(
                                                                context: context,
                                                                id: mainVariables.valueMapListProfilePage[index].userId,
                                                                isBelieversList: true,
                                                              );
                                                            },
                                                            child: Text(
                                                              "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                    fontWeight: FontWeight.w400,
                                                                    color: const Color(0XFF737373),
                                                                  ), /*TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: const Color(0XFF737373),
                                                                  fontWeight: FontWeight.w400,
                                                                  fontFamily: "Poppins"),*/
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                    ? billboardWidgetsMain.getHomeBelieveButton(
                                                        heightValue: height / 33.76,
                                                        isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                            (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                        billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                        billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                        context: context,
                                                        modelSetState: modelSetState,
                                                        index: index,
                                                        background: false,
                                                      )
                                                    : const SizedBox(),

                                                ///more_vert
                                                IconButton(
                                                    onPressed: () {
                                                      billboardWidgetsMain.bottomSheet(
                                                        context1: context,
                                                        myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                        billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                        billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                        type: "billboard",
                                                        responseId: "",
                                                        responseUserId: "",
                                                        commentId: "",
                                                        commentUserId: "",
                                                        callFunction: getData,
                                                        contentType: mainVariables.valueMapListProfilePage[index].type,
                                                        modelSetState: modelSetState,
                                                        responseDetail: {},
                                                        category: mainVariables.valueMapListProfilePage[index].category,
                                                        valueMapList: mainVariables.valueMapListProfilePage,
                                                        index: index,
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.more_vert,
                                                      color: Theme.of(context).colorScheme.onPrimary /*Colors.black*/,
                                                      size: 25,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(height: height / 64),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          switch (mainVariables.valueMapListProfilePage[index].type) {
                                            case "blog":
                                              {
                                                mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                Navigator.push(
                                                    context, MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                break;
                                              }
                                            case "byte":
                                              {
                                                mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                Navigator.push(
                                                    context, MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                break;
                                              }
                                            case "forums":
                                              {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext context) => ForumPostDescriptionPage(
                                                            idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                            comeFrom: "billBoardHome",
                                                            forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                  'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                });
                                                var responseData = json.decode(response.body);
                                                if (responseData["status"]) {
                                                  activeStatus = responseData["response"]["status"];
                                                  if (activeStatus == "active") {
                                                    var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                    var response = await http.post(url, headers: {
                                                      'Authorization': mainUserToken
                                                    }, body: {
                                                      'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                          activity: false,
                                                          surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                          navBool: false,
                                                          fromWhere: 'similar',
                                                        );
                                                      }))
                                                    : activeStatus == 'active'
                                                        ? answerStatus
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                    surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                    activity: false,
                                                                    navBool: false,
                                                                    fromWhere: 'similar',
                                                                    surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                              }))
                                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return QuestionnairePage(
                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                  defaultIndex: answeredQuestion,
                                                                );
                                                              }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                              activity: false,
                                                              surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                          height: height / 9,
                                          color: Theme.of(context).colorScheme.background,
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: RichText(
                                              textAlign: TextAlign.left,
                                              text: TextSpan(
                                                children: conversationFunctionsMain.spanListBillBoardHome(
                                                    message: mainVariables.valueMapListProfilePage[index].title.length > 140
                                                        ? mainVariables.valueMapListProfilePage[index].title.substring(0, 140)
                                                        : mainVariables.valueMapListProfilePage[index].title,
                                                    context: context,
                                                    isByte: true),
                                              ),
                                            ) /*Text( mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                     style:TextStyle(
                                                       fontSize: _text.scale(14),
                                                       fontWeight: FontWeight.w400,
                                                       color: Color(0XFF403D3D),
                                                     ),
                                                     textAlign: TextAlign.justify,
                                                     maxLines: 3,
                                                     overflow: TextOverflow.ellipsis,
                                                   )*/
                                            ,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: height / 86.6,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(children: [
                                                  SizedBox(
                                                    width: width / 41.1,
                                                  ),
                                                  billboardWidgetsMain.likeButtonHomeListWidget(
                                                    likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                        (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                                    id: mainVariables.valueMapListProfilePage[index].id,
                                                    index: index,
                                                    context: context,
                                                    initFunction: () {},
                                                    modelSetState: modelSetState,
                                                    notUse: true,
                                                    dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                        (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                                    likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                        (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                                    dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                        (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                                    type: mainVariables.valueMapListProfilePage[index].type,
                                                    billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                        ? "news"
                                                        : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                            ? "forums"
                                                            : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                ? "survey"
                                                                : "billboard",
                                                    /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                                    image: mainVariables.valueMapListProfilePage[index].avatar,
                                                    title: mainVariables.valueMapListProfilePage[index].title,
                                                    description: "",
                                                    fromWhere: 'homePage',
                                                    responseId: '',
                                                    controller: bottomSheetController,
                                                    commentId: '',
                                                    postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                    responseFocusList: mainVariables.responseFocusList,
                                                    responseUserId: '',
                                                    valueMapList: mainVariables.valueMapListProfilePage,
                                                  ),
                                                  SizedBox(
                                                    width: width / 27.4,
                                                  ),
                                                  /*bookMarkWidget(
                                                        bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) =>  mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                        context: context,
                                                        scale: 3.2,
                                                        id: mainVariables.valueMapListProfilePage[index].id,
                                                        type:mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                        modelSetState: modelSetState,
                                                        index: index,
                                                        initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                        notUse: false,
                                                      ),*/
                                                  billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                ]),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                            mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                                        ? const SizedBox()
                                                        : GestureDetector(
                                                            onTap: () {
                                                              billboardWidgetsMain.believedTabBottomSheet(
                                                                  context: context,
                                                                  id: mainVariables.valueMapListProfilePage[index].repostId,
                                                                  type: mainVariables.valueMapListProfilePage[index].type);
                                                            },
                                                            child: Stack(
                                                              children: [
                                                                const SizedBox(
                                                                  height: 30,
                                                                  width: 30,
                                                                ),
                                                                Positioned(
                                                                  left: 0,
                                                                  bottom: 0,
                                                                  child: Container(
                                                                    height: 25,
                                                                    width: 25,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(5),
                                                                        image: const DecorationImage(
                                                                          image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                        )),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 0,
                                                                  right: 0,
                                                                  child: Container(
                                                                    height: 15,
                                                                    width: 15,
                                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                                    child: Center(
                                                                        child: Text(
                                                                      mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                          ? "9+"
                                                                          : mainVariables.valueMapListProfilePage[index].repostCount.toString(),
                                                                      style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                    )),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      width: width / 27.4,
                                                    ),
                                                    SizedBox(
                                                      height: 35,
                                                      width: 35,
                                                      child: billboardWidgetsMain.translationWidget(
                                                          id: mainVariables.valueMapListProfilePage[index].id,
                                                          type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                              ? "forums"
                                                              : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                  ? "survey"
                                                                  : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                      ? "news"
                                                                      : 'billboard',
                                                          index: index,
                                                          initFunction: getData,
                                                          context: context,
                                                          modelSetState: modelSetState,
                                                          notUse: false,
                                                          valueMapList: mainVariables.valueMapListProfilePage),
                                                    ),
                                                    SizedBox(
                                                      width: width / 27.4,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: height / 64),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    mainVariables.valueMapListProfilePage[index].companyName,
                                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                          fontWeight: FontWeight.w700,
                                                          color: const Color(0xFF017FDB),
                                                        ),
                                                    /*TextStyle(
                                                        fontSize: text.scale(10), color: const Color(0xFF017FDB), fontWeight: FontWeight.bold),*/
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                          responseId: "",
                                                          commentId: "",
                                                          billBoardType: "billboard",
                                                          action: "views",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 0,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true);
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                      style: TextStyle(
                                                          fontSize: text.scale(10),
                                                          color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                          responseId: "",
                                                          commentId: "",
                                                          billBoardType: "billboard",
                                                          action: "likes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 1,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true);
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                      style: TextStyle(
                                                          fontSize: text.scale(10),
                                                          color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                    ),
                                                  ),
                                                  /*  InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:"billboard",
                                                          action:"dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                  InkWell(
                                                    onTap: () async {
                                                      switch (mainVariables.valueMapListProfilePage[index].type) {
                                                        case "blog":
                                                          {
                                                            mainVariables.selectedBillboardIdMain.value =
                                                                mainVariables.valueMapListProfilePage[index].id;
                                                            Navigator.push(context,
                                                                MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                            break;
                                                          }
                                                        case "byte":
                                                          {
                                                            mainVariables.selectedBillboardIdMain.value =
                                                                mainVariables.valueMapListProfilePage[index].id;
                                                            Navigator.push(context,
                                                                MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                            break;
                                                          }
                                                        case "forums":
                                                          {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                        idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                            (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                        comeFrom: "billBoardHome",
                                                                        forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                            });
                                                            var responseData = json.decode(response.body);
                                                            if (responseData["status"]) {
                                                              activeStatus = responseData["response"]["status"];
                                                              if (activeStatus == "active") {
                                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                var response = await http.post(url, headers: {
                                                                  'Authorization': mainUserToken
                                                                }, body: {
                                                                  'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                            mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                      activity: false,
                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                      navBool: false,
                                                                      fromWhere: 'similar',
                                                                    );
                                                                  }))
                                                                : activeStatus == 'active'
                                                                    ? answerStatus
                                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                                surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                activity: false,
                                                                                navBool: false,
                                                                                fromWhere: 'similar',
                                                                                surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                          }))
                                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return QuestionnairePage(
                                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                              defaultIndex: answeredQuestion,
                                                                            );
                                                                          }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                          activity: false,
                                                                          surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                      " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                      style: TextStyle(
                                                          fontSize: text.scale(10),
                                                          color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: height / 42.6),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      /*bool response =
                                                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return UserBillBoardProfilePage(
                                                          userId: userIdMain,
                                                        );
                                                      }));*/
                                                      if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                          mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                        mainVariables.selectedTickerId.value = mainVariables.valueMapListProfilePage[index].userId;
                                                      }
                                                      bool response =
                                                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                            ? IntermediaryBillBoardProfilePage(
                                                                userId: mainVariables.valueMapListProfilePage[index].userId)
                                                            : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                ? const BusinessProfilePage()
                                                                : UserBillBoardProfilePage(
                                                                    userId: mainVariables.valueMapListProfilePage[index].userId);
                                                      }));
                                                      if (response) {
                                                        getBillBoardListData();
                                                      }
                                                    },
                                                    child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                  ),
                                                  SizedBox(
                                                    width: width / 41.1,
                                                  ),
                                                  billboardWidgetsMain.getResponseField(
                                                    context: context,
                                                    modelSetState: modelSetState,
                                                    billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                    postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                    responseId: "",
                                                    index: index,
                                                    fromWhere: 'homePage',
                                                    callFunction: () {},
                                                    contentType: mainVariables.valueMapListProfilePage[index].type,
                                                    category: mainVariables.valueMapListProfilePage[index].category,
                                                    responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                        (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                          : //final //NonBelievedCategory, NoFiles, byte
                          Container(
                              padding: const EdgeInsets.all(1.5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                //BoxShadow(color: Colors.black26.withOpacity(0.1), offset: const Offset(0.0, -0.5), blurRadius: 1.0, spreadRadius: 1.0)
                                BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)
                              ]),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height / 86.6,
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
                                              heightValue: height / 17.32,
                                              widthValue: width / 8.22,
                                              myself: false,
                                              isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                              avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                              userId: mainVariables.valueMapListProfilePage[index].userId,
                                              repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                              repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                              isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                              getBillBoardListData: getBillBoardListData,
                                            ),
                                            SizedBox(
                                              width: width / 41.1,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                                                return UserProfilePage(
                                                                  id:valueMapList[index].userId,type:'forums',index:0);}));*/
                                                      /*bool response =
                                                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return UserBillBoardProfilePage(userId: mainVariables.valueMapListProfilePage[index].userId);
                                                      }));*/
                                                      if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                          mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                        mainVariables.selectedTickerId.value = mainVariables.valueMapListProfilePage[index].userId;
                                                      }
                                                      bool response =
                                                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                            ? IntermediaryBillBoardProfilePage(
                                                                userId: mainVariables.valueMapListProfilePage[index].userId)
                                                            : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                ? const BusinessProfilePage()
                                                                : UserBillBoardProfilePage(
                                                                    userId: mainVariables.valueMapListProfilePage[index].userId);
                                                      }));
                                                      if (response) {
                                                        getBillBoardListData();
                                                      }
                                                    },
                                                    child: Text(mainVariables.valueMapListProfilePage[index].username.toString().capitalizeFirst!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge /*TextStyle(
                                                          fontSize: text.scale(12),
                                                          color: const Color(0XFF202020),
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: "Poppins"),*/
                                                        ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        mainVariables.valueMapListProfilePage[index].createdAt,
                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                              fontWeight: FontWeight.w400,
                                                              color: const Color(0XFF737373),
                                                            ), /* TextStyle(
                                                            fontSize: text.scale(10),
                                                            color: const Color(0XFF737373),
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: "Poppins"),*/
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        " | ",
                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                              fontWeight: FontWeight.w400,
                                                              color: const Color(0XFF737373),
                                                            ), /*TextStyle(
                                                          fontSize: text.scale(11),
                                                          color: const Color(0XFF737373),
                                                          fontWeight: FontWeight.w400,
                                                        ),*/
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          billboardWidgetsMain.believersTabBottomSheet(
                                                            context: context,
                                                            id: mainVariables.valueMapListProfilePage[index].userId,
                                                            isBelieversList: true,
                                                          );
                                                        },
                                                        child: Text(
                                                          "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                fontWeight: FontWeight.w400,
                                                                color: const Color(0XFF737373),
                                                              ), /*TextStyle(
                                                              fontSize: text.scale(10),
                                                              color: const Color(0XFF737373),
                                                              fontWeight: FontWeight.w400,
                                                              fontFamily: "Poppins"),*/
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                ? billboardWidgetsMain.getHomeBelieveButton(
                                                    heightValue: height / 33.76,
                                                    isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                        (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                    billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                    billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                    context: context,
                                                    modelSetState: modelSetState,
                                                    index: index,
                                                    background: false,
                                                  )
                                                : const SizedBox(),

                                            ///more_vert
                                            IconButton(
                                                onPressed: () {
                                                  billboardWidgetsMain.bottomSheet(
                                                    context1: context,
                                                    myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                    billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                    billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                    type: "billboard",
                                                    responseId: "",
                                                    responseUserId: "",
                                                    commentId: "",
                                                    commentUserId: "",
                                                    callFunction: getData,
                                                    contentType: mainVariables.valueMapListProfilePage[index].type,
                                                    modelSetState: modelSetState,
                                                    responseDetail: {},
                                                    category: mainVariables.valueMapListProfilePage[index].category,
                                                    valueMapList: mainVariables.valueMapListProfilePage,
                                                    index: index,
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: Theme.of(context).colorScheme.onPrimary /* Colors.black*/,
                                                  size: 25,
                                                ))
                                          ],
                                        ),
                                        SizedBox(height: height / 64),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      switch (mainVariables.valueMapListProfilePage[index].type) {
                                        case "blog":
                                          {
                                            mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                            break;
                                          }
                                        case "byte":
                                          {
                                            mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                            break;
                                          }
                                        case "forums":
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) => ForumPostDescriptionPage(
                                                        idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                            (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                        comeFrom: "billBoardHome",
                                                        forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                            });
                                            var responseData = json.decode(response.body);
                                            if (responseData["status"]) {
                                              activeStatus = responseData["response"]["status"];
                                              if (activeStatus == "active") {
                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                var response = await http.post(url, headers: {
                                                  'Authorization': mainUserToken
                                                }, body: {
                                                  'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                            mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return AnalyticsPage(
                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                      activity: false,
                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                      navBool: false,
                                                      fromWhere: 'similar',
                                                    );
                                                  }))
                                                : activeStatus == 'active'
                                                    ? answerStatus
                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                activity: false,
                                                                navBool: false,
                                                                fromWhere: 'similar',
                                                                surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                          }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return QuestionnairePage(
                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                              defaultIndex: answeredQuestion,
                                                            );
                                                          }))
                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                          activity: false,
                                                          surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                      height: height / 9,
                                      color: Theme.of(context).colorScheme.background,
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            children: conversationFunctionsMain.spanListBillBoardHome(
                                                message: mainVariables.valueMapListProfilePage[index].title.length > 140
                                                    ? mainVariables.valueMapListProfilePage[index].title.substring(0, 140)
                                                    : mainVariables.valueMapListProfilePage[index].title,
                                                context: context,
                                                isByte: true),
                                          ),
                                        ) /*Text( mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                     style:TextStyle(
                                                       fontSize: _text.scale(14),
                                                       fontWeight: FontWeight.w400,
                                                       color: Color(0XFF403D3D),
                                                     ),
                                                     textAlign: TextAlign.justify,
                                                     maxLines: 3,
                                                     overflow: TextOverflow.ellipsis,
                                                   )*/
                                        ,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height / 86.6,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(children: [
                                              SizedBox(
                                                width: width / 41.1,
                                              ),
                                              billboardWidgetsMain.likeButtonHomeListWidget(
                                                likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                    (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                                id: mainVariables.valueMapListProfilePage[index].id,
                                                index: index,
                                                context: context,
                                                initFunction: () {},
                                                modelSetState: modelSetState,
                                                notUse: true,
                                                dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                    (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                                likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                    (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                                dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                    (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                                type: mainVariables.valueMapListProfilePage[index].type,
                                                billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                    ? "news"
                                                    : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                        ? "forums"
                                                        : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                            ? "survey"
                                                            : "billboard",
                                                /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                                image: mainVariables.valueMapListProfilePage[index].avatar,
                                                title: mainVariables.valueMapListProfilePage[index].title,
                                                description: "",
                                                fromWhere: 'homePage',
                                                responseId: '',
                                                controller: bottomSheetController,
                                                commentId: '',
                                                postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                responseFocusList: mainVariables.responseFocusList,
                                                responseUserId: '',
                                                valueMapList: mainVariables.valueMapListProfilePage,
                                              ),
                                              SizedBox(
                                                width: width / 27.4,
                                              ),
                                              /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) =>  mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3.2,
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type:mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false,
                                                          ),*/
                                              billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                            ]),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                        mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                                    ? const SizedBox()
                                                    : GestureDetector(
                                                        onTap: () {
                                                          billboardWidgetsMain.believedTabBottomSheet(
                                                              context: context,
                                                              id: mainVariables.valueMapListProfilePage[index].repostId,
                                                              type: mainVariables.valueMapListProfilePage[index].type);
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            const SizedBox(
                                                              height: 30,
                                                              width: 30,
                                                            ),
                                                            Positioned(
                                                              left: 0,
                                                              bottom: 0,
                                                              child: Container(
                                                                height: 25,
                                                                width: 25,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    image: const DecorationImage(
                                                                      image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                    )),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: Container(
                                                                height: 15,
                                                                width: 15,
                                                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                                child: Center(
                                                                    child: Text(
                                                                  mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                      ? "9+"
                                                                      : mainVariables.valueMapListProfilePage[index].repostCount.toString(),
                                                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                )),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: width / 27.4,
                                                ),
                                                SizedBox(
                                                  height: 35,
                                                  width: 35,
                                                  child: billboardWidgetsMain.translationWidget(
                                                      id: mainVariables.valueMapListProfilePage[index].id,
                                                      type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                          ? "forums"
                                                          : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                              ? "survey"
                                                              : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                  ? "news"
                                                                  : 'billboard',
                                                      index: index,
                                                      initFunction: getData,
                                                      context: context,
                                                      modelSetState: modelSetState,
                                                      notUse: false,
                                                      valueMapList: mainVariables.valueMapListProfilePage),
                                                ),
                                                SizedBox(
                                                  width: width / 27.4,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: height / 64),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                mainVariables.valueMapListProfilePage[index].companyName,
                                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                      color: const Color(0xFF017FDB),
                                                    ),
                                                /*TextStyle(fontSize: text.scale(10), color: const Color(0xFF017FDB), fontWeight: FontWeight.bold),*/
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                      context: context,
                                                      billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                      responseId: "",
                                                      commentId: "",
                                                      billBoardType: "billboard",
                                                      action: "views",
                                                      likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                      disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                      index: 0,
                                                      viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                      isViewIncluded: true);
                                                },
                                                child: Text(
                                                  " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                      context: context,
                                                      billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                      responseId: "",
                                                      commentId: "",
                                                      billBoardType: "billboard",
                                                      action: "likes",
                                                      likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                      disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                      index: 1,
                                                      viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                      isViewIncluded: true);
                                                },
                                                child: Text(
                                                  " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                ),
                                              ),
                                              /* InkWell(
                                                        onTap: () async {
                                                          billboardWidgetsMain.getLikeDislikeUsersList(
                                                              context: context,
                                                              billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                              responseId:"",
                                                              commentId:"",
                                                              billBoardType:"billboard",
                                                              action:"dislikes",
                                                              likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                              disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                              index: 2,
                                                              viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                              isViewIncluded: true
                                                          );
                                                        },
                                                        child: Text(
                                                          " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                          style: TextStyle(
                                                              fontSize: _text.scale(10),
                                                              color: Colors.black54),
                                                        ),
                                                      ),*/
                                              InkWell(
                                                onTap: () async {
                                                  switch (mainVariables.valueMapListProfilePage[index].type) {
                                                    case "blog":
                                                      {
                                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                        break;
                                                      }
                                                    case "byte":
                                                      {
                                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                        break;
                                                      }
                                                    case "forums":
                                                      {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                    idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                        (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                    comeFrom: "billBoardHome",
                                                                    forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                        });
                                                        var responseData = json.decode(response.body);
                                                        if (responseData["status"]) {
                                                          activeStatus = responseData["response"]["status"];
                                                          if (activeStatus == "active") {
                                                            var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                            var response = await http.post(url, headers: {
                                                              'Authorization': mainUserToken
                                                            }, body: {
                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                        mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                  activity: false,
                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                  navBool: false,
                                                                  fromWhere: 'similar',
                                                                );
                                                              }))
                                                            : activeStatus == 'active'
                                                                ? answerStatus
                                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                            activity: false,
                                                                            navBool: false,
                                                                            fromWhere: 'similar',
                                                                            surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                      }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return QuestionnairePage(
                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                          defaultIndex: answeredQuestion,
                                                                        );
                                                                      }))
                                                                : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                      activity: false,
                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                  " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: height / 42.6),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  /*bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return UserBillBoardProfilePage(
                                                      userId: userIdMain,
                                                    );
                                                  }));*/
                                                  if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                      mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                    mainVariables.selectedTickerId.value = mainVariables.valueMapListProfilePage[index].userId;
                                                  }
                                                  bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                        ? IntermediaryBillBoardProfilePage(
                                                            userId: mainVariables.valueMapListProfilePage[index].userId)
                                                        : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                            ? const BusinessProfilePage()
                                                            : UserBillBoardProfilePage(userId: mainVariables.valueMapListProfilePage[index].userId);
                                                  }));
                                                  if (response) {
                                                    getBillBoardListData();
                                                  }
                                                },
                                                child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                              ),
                                              SizedBox(
                                                width: width / 41.1,
                                              ),
                                              billboardWidgetsMain.getResponseField(
                                                context: context,
                                                modelSetState: modelSetState,
                                                billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                responseId: "",
                                                index: index,
                                                fromWhere: 'homePage',
                                                callFunction: () {},
                                                contentType: mainVariables.valueMapListProfilePage[index].type,
                                                category: mainVariables.valueMapListProfilePage[index].category,
                                                responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                    (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : mainVariables.valueMapListProfilePage[index].postType == "repost"
                          ? mainVariables.activeTypeMain.value == "believed"
                              ? mainVariables.valueMapListProfilePage[index].repostStatus == 1
                                  ? mainVariables.valueMapListProfilePage[index].repostType == "private"
                                      ? mainVariables.valueMapListProfilePage[index].repostBelieved
                                          ? Container(
                                              padding: const EdgeInsets.all(1.5),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                                BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)
                                              ]),
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      switch (mainVariables.valueMapListProfilePage[index].type) {
                                                        case "blog":
                                                          {
                                                            mainVariables.selectedBillboardIdMain.value =
                                                                mainVariables.valueMapListProfilePage[index].id;
                                                            Navigator.push(context,
                                                                MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                            break;
                                                          }
                                                        case "byte":
                                                          {
                                                            mainVariables.selectedBillboardIdMain.value =
                                                                mainVariables.valueMapListProfilePage[index].id;
                                                            Navigator.push(context,
                                                                MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                            break;
                                                          }
                                                        case "forums":
                                                          {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                        idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                            (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                        comeFrom: "billBoardHome",
                                                                        forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                            });
                                                            var responseData = json.decode(response.body);
                                                            if (responseData["status"]) {
                                                              activeStatus = responseData["response"]["status"];

                                                              if (activeStatus == "active") {
                                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                var response = await http.post(url, headers: {
                                                                  'Authorization': mainUserToken
                                                                }, body: {
                                                                  'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                            mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                      activity: false,
                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                      navBool: false,
                                                                      fromWhere: 'similar',
                                                                    );
                                                                  }))
                                                                : activeStatus == 'active'
                                                                    ? answerStatus
                                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                                surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                activity: false,
                                                                                navBool: false,
                                                                                fromWhere: 'similar',
                                                                                surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                          }))
                                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return QuestionnairePage(
                                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                              defaultIndex: answeredQuestion,
                                                                            );
                                                                          }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                          activity: false,
                                                                          surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                            height: height / 3.97,
                                                            decoration: const BoxDecoration(
                                                              color: Colors.black,
                                                              borderRadius:
                                                                  BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                            ),
                                                            child: CarouselSlider.builder(
                                                              carouselController: _carController,
                                                              options: CarouselOptions(
                                                                  enableInfiniteScroll: false,
                                                                  enlargeCenterPage: false,
                                                                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                                                                    modelSetState(() {
                                                                      carouselIndexGlobal = index;
                                                                    });
                                                                  }),
                                                              itemCount: mainVariables.valueMapListProfilePage[index].files.length,
                                                              itemBuilder: (BuildContext context, int carouselIndex, int realIndex) {
                                                                return mainVariables.valueMapListProfilePage[index].files[carouselIndex].type ==
                                                                        "image"
                                                                    ? Image.network(
                                                                        mainVariables.valueMapListProfilePage[index].files[carouselIndex].file,
                                                                        fit: BoxFit.fill, errorBuilder: (context, __, error) {
                                                                        return Image.asset("lib/Constants/Assets/Settings/coverImage_default.png");
                                                                      })
                                                                    : mainVariables.valueMapListProfilePage[index].files[carouselIndex].type ==
                                                                            "video"
                                                                        ? Stack(
                                                                            alignment: Alignment.center,
                                                                            children: [
                                                                              Image.asset(
                                                                                "lib/Constan,kits/Assets/Settings/coverImage_default.png",
                                                                                fit: BoxFit.fill,
                                                                                height: height / 3.97,
                                                                              ),
                                                                              Container(
                                                                                  height: 50,
                                                                                  width: 50,
                                                                                  decoration: BoxDecoration(
                                                                                      shape: BoxShape.circle, color: Colors.black26.withOpacity(0.7)),
                                                                                  child: const Icon(
                                                                                    Icons.play_arrow_sharp,
                                                                                    color: Colors.white,
                                                                                    size: 40,
                                                                                  ))
                                                                            ],
                                                                          )
                                                                        : mainVariables.valueMapListProfilePage[index].files[carouselIndex].type ==
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
                                                            width: width / 1.06,
                                                            padding: EdgeInsets.only(
                                                              left: width / 27.4,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color: Colors.black12.withOpacity(0.3),
                                                              borderRadius: const BorderRadius.only(
                                                                topLeft: Radius.circular(15),
                                                                topRight: Radius.circular(15),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) => mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3,
                                                            color: Colors.white,
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type:mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false
                                                        ),*/
                                                                    billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                                    const SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    billboardWidgetsMain.translationWidget(
                                                                        id: mainVariables.valueMapListProfilePage[index].id,
                                                                        type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                            ? "forums"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                ? "survey"
                                                                                : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                                    ? "news"
                                                                                    : 'billboard',
                                                                        index: index,
                                                                        initFunction: getData,
                                                                        context: context,
                                                                        modelSetState: modelSetState,
                                                                        notUse: false,
                                                                        valueMapList: mainVariables.valueMapListProfilePage),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                                        ? billboardWidgetsMain.getHomeBelieveButton(
                                                                            heightValue: height / 33.76,
                                                                            isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                                (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                                            billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                                            billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                                            context: context,
                                                                            modelSetState: modelSetState,
                                                                            index: index,
                                                                            background: true,
                                                                          )
                                                                        : const SizedBox(),

                                                                    ///more_vert
                                                                    IconButton(
                                                                        onPressed: () {
                                                                          billboardWidgetsMain.bottomSheet(
                                                                            context1: context,
                                                                            myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                                            billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                                            billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                            type: "billboard",
                                                                            responseId: "",
                                                                            responseUserId: "",
                                                                            commentId: "",
                                                                            commentUserId: "",
                                                                            callFunction: getData,
                                                                            contentType: mainVariables.valueMapListProfilePage[index].type,
                                                                            modelSetState: modelSetState,
                                                                            responseDetail: {},
                                                                            category: mainVariables.valueMapListProfilePage[index].category,
                                                                            valueMapList: mainVariables.valueMapListProfilePage,
                                                                            index: index,
                                                                          );
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons.more_vert,
                                                                          color: Colors.white,
                                                                          size: 25,
                                                                        ))
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        mainVariables.valueMapListProfilePage[index].files.length > 1
                                                            ? Positioned(
                                                                bottom: 75,
                                                                left: (width / 2) - 35,
                                                                child: SizedBox(
                                                                  height: 5,
                                                                  child: ListView.builder(
                                                                      shrinkWrap: true,
                                                                      scrollDirection: Axis.horizontal,
                                                                      physics: const NeverScrollableScrollPhysics(),
                                                                      itemCount: mainVariables.valueMapListProfilePage[index].files.length,
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
                                                        mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                                mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                                            ? const SizedBox()
                                                            : Positioned(
                                                                top: height / 15,
                                                                right: 15,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    billboardWidgetsMain.believedTabBottomSheet(
                                                                        context: context,
                                                                        id: mainVariables.valueMapListProfilePage[index].repostId,
                                                                        type: mainVariables.valueMapListProfilePage[index].type);
                                                                  },
                                                                  child: Stack(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 35,
                                                                        width: 35,
                                                                      ),
                                                                      Positioned(
                                                                        left: 0,
                                                                        bottom: 0,
                                                                        child: Container(
                                                                          height: 30,
                                                                          width: 30,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              image: const DecorationImage(
                                                                                image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 0,
                                                                        right: 0,
                                                                        child: Container(
                                                                          height: 15,
                                                                          width: 15,
                                                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                                          child: Center(
                                                                              child: Text(
                                                                            mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                                ? "9+"
                                                                                : mainVariables.valueMapListProfilePage[index].repostCount.toString(),
                                                                            style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                          )),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                        Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          child: Container(
                                                            height: height / 14,
                                                            width: width,
                                                            padding: EdgeInsets.only(
                                                                top: height / 86.6, bottom: height / 86.6, right: width / 13.7, left: width / 41.1),
                                                            decoration: BoxDecoration(
                                                              color: Colors.black12.withOpacity(0.3),
                                                            ),
                                                            child: RichText(
                                                              textAlign: TextAlign.left,
                                                              text: TextSpan(
                                                                children: conversationFunctionsMain.spanListBillBoardHome(
                                                                    message: mainVariables.valueMapListProfilePage[index].title.length > 100
                                                                        ? mainVariables.valueMapListProfilePage[index].title.substring(0, 100)
                                                                        : mainVariables.valueMapListProfilePage[index].title,
                                                                    context: context,
                                                                    isByte: false),
                                                              ),
                                                            ) /*Text(
                                                         mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                         maxLines: 2,
                                                         style: TextStyle(
                                                             fontSize: _text*14,
                                                             color: Colors.white,
                                                             fontWeight: FontWeight.w500,
                                                             fontFamily: "Poppins",
                                                             overflow: TextOverflow.ellipsis
                                                         ),
                                                       )*/
                                                            ,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).colorScheme.background,
                                                      borderRadius:
                                                          const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: height / 86.6,
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
                                                              heightValue: height / 17.32,
                                                              widthValue: width / 8.22,
                                                              myself: false,
                                                              avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                                              isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                                              userId: mainVariables.valueMapListProfilePage[index].userId,
                                                              repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                                              repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                                              isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                                              getBillBoardListData: getBillBoardListData,
                                                            ),
                                                            SizedBox(
                                                              width: width / 41.1,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      /*Navigator.push(context,
                                                              MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                                id:valueMapList[index].userId,
                                                                type:'forums',
                                                                index:0);}));*/
                                                                      /*bool response = await Navigator.push(context,
                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                        return UserBillBoardProfilePage(
                                                                            userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                      }));*/
                                                                      if (mainVariables.valueMapListProfilePage[index].profileType !=
                                                                              "intermediate" ||
                                                                          mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                        mainVariables.selectedTickerId.value =
                                                                            mainVariables.valueMapListProfilePage[index].userId;
                                                                      }
                                                                      bool response = await Navigator.push(context,
                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                        return mainVariables.valueMapListProfilePage[index].profileType ==
                                                                                "intermediate"
                                                                            ? IntermediaryBillBoardProfilePage(
                                                                                userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                            : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                                ? const BusinessProfilePage()
                                                                                : UserBillBoardProfilePage(
                                                                                    userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                      }));
                                                                      if (response) {
                                                                        getBillBoardListData();
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      mainVariables.valueMapListProfilePage[index].username
                                                                          .toString()
                                                                          .capitalizeFirst!,
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .bodyLarge, /*TextStyle(
                                                                          fontSize: text.scale(12),
                                                                          color: const Color(0XFF202020),
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: "Poppins"),*/
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        mainVariables.valueMapListProfilePage[index].createdAt,
                                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: const Color(0XFF737373),
                                                                            ), /*TextStyle(
                                                                            fontSize: text.scale(10),
                                                                            color: const Color(0XFF737373),
                                                                            fontWeight: FontWeight.w400,
                                                                            fontFamily: "Poppins"),*/
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 3,
                                                                      ),
                                                                      Text(
                                                                        " | ",
                                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                              fontWeight: FontWeight.w400,
                                                                              color: const Color(0XFF737373),
                                                                            ), /*TextStyle(
                                                                          fontSize: text.scale(11),
                                                                          color: const Color(0XFF737373),
                                                                          fontWeight: FontWeight.w400,
                                                                        ),*/
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 3,
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () async {
                                                                          billboardWidgetsMain.believersTabBottomSheet(
                                                                            context: context,
                                                                            id: mainVariables.valueMapListProfilePage[index].userId,
                                                                            isBelieversList: true,
                                                                          );
                                                                        },
                                                                        child: Text(
                                                                          "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                                fontWeight: FontWeight.w400,
                                                                                color: const Color(0XFF737373),
                                                                              ), /*TextStyle(
                                                                              fontSize: text.scale(10),
                                                                              color: const Color(0XFF737373),
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: "Poppins"),*/
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            billboardWidgetsMain.likeButtonHomeListWidget(
                                                              likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                  (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                                              id: mainVariables.valueMapListProfilePage[index].id,
                                                              index: index,
                                                              context: context,
                                                              initFunction: () {},
                                                              modelSetState: modelSetState,
                                                              notUse: true,
                                                              dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                  (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                                              likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                  (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                                              dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                  (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                                              type: mainVariables.valueMapListProfilePage[index].type,
                                                              billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                  ? "news"
                                                                  : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                      ? "forums"
                                                                      : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                          ? "survey"
                                                                          : "billboard",
                                                              /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                                              image: mainVariables.valueMapListProfilePage[index].avatar,
                                                              title: mainVariables.valueMapListProfilePage[index].title,
                                                              description: "",
                                                              fromWhere: 'homePage',
                                                              responseId: '',
                                                              controller: bottomSheetController,
                                                              commentId: '',
                                                              postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                              responseFocusList: mainVariables.responseFocusList,
                                                              responseUserId: '',
                                                              valueMapList: mainVariables.valueMapListProfilePage,
                                                            ),
                                                            SizedBox(
                                                              width: width / 41.1,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: height / 64),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                mainVariables.valueMapListProfilePage[index].companyName,
                                                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                                      fontWeight: FontWeight.w700,
                                                                      color: const Color(0xFF017FDB),
                                                                    ), /*TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0xFF017FDB),
                                                                    fontWeight: FontWeight.bold),*/
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                                      context: context,
                                                                      billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                      responseId: "",
                                                                      commentId: "",
                                                                      billBoardType: "billboard",
                                                                      action: "views",
                                                                      likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                      disLikeCount:
                                                                          mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                      index: 0,
                                                                      viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                      isViewIncluded: true);
                                                                },
                                                                child: Text(
                                                                  " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                                      context: context,
                                                                      billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                      responseId: "",
                                                                      commentId: "",
                                                                      billBoardType: "billboard",
                                                                      action: "likes",
                                                                      likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                      disLikeCount:
                                                                          mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                      index: 1,
                                                                      viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                      isViewIncluded: true);
                                                                },
                                                                child: Text(
                                                                  " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                                ),
                                                              ),
                                                              /*  InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:"billboard",
                                                          action:"dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                              InkWell(
                                                                onTap: () async {
                                                                  switch (mainVariables.valueMapListProfilePage[index].type) {
                                                                    case "blog":
                                                                      {
                                                                        mainVariables.selectedBillboardIdMain.value =
                                                                            mainVariables.valueMapListProfilePage[index].id;
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) => const BlogDescriptionPage()));
                                                                        break;
                                                                      }
                                                                    case "byte":
                                                                      {
                                                                        mainVariables.selectedBillboardIdMain.value =
                                                                            mainVariables.valueMapListProfilePage[index].id;
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) => const BytesDescriptionPage()));
                                                                        break;
                                                                      }
                                                                    case "forums":
                                                                      {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                    idList: List.generate(
                                                                                        mainVariables.valueMapListProfilePage.length,
                                                                                        (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                                    comeFrom: "billBoardHome",
                                                                                    forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                                        });
                                                                        var responseData = json.decode(response.body);
                                                                        if (responseData["status"]) {
                                                                          activeStatus = responseData["response"]["status"];
                                                                          if (activeStatus == "active") {
                                                                            var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                            var response = await http.post(url, headers: {
                                                                              'Authorization': mainUserToken
                                                                            }, body: {
                                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                                        mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                            ? Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return AnalyticsPage(
                                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                  activity: false,
                                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                                  navBool: false,
                                                                                  fromWhere: 'similar',
                                                                                );
                                                                              }))
                                                                            : activeStatus == 'active'
                                                                                ? answerStatus
                                                                                    ? Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                        return AnalyticsPage(
                                                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                            activity: false,
                                                                                            navBool: false,
                                                                                            fromWhere: 'similar',
                                                                                            surveyTitle:
                                                                                                mainVariables.valueMapListProfilePage[index].title);
                                                                                      }))
                                                                                    : Navigator.push(context,
                                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                                        return QuestionnairePage(
                                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                          defaultIndex: answeredQuestion,
                                                                                        );
                                                                                      }))
                                                                                : Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                    return AnalyticsPage(
                                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                      activity: false,
                                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                                  " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: height / 42.6),
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                                      mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                    mainVariables.selectedTickerId.value =
                                                                        mainVariables.valueMapListProfilePage[index].userId;
                                                                  }
                                                                  bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                        ? IntermediaryBillBoardProfilePage(
                                                                            userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                        : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                            ? const BusinessProfilePage()
                                                                            : UserBillBoardProfilePage(
                                                                                userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                  }));
                                                                  /*bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return UserBillBoardProfilePage(
                                                                      userId: userIdMain,
                                                                    );
                                                                  }));*/
                                                                  if (response) {
                                                                    getBillBoardListData();
                                                                  }
                                                                },
                                                                child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                              ),
                                                              SizedBox(
                                                                width: width / 41.1,
                                                              ),
                                                              billboardWidgetsMain.getResponseField(
                                                                context: context,
                                                                modelSetState: modelSetState,
                                                                billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                responseId: "",
                                                                index: index,
                                                                fromWhere: 'homePage',
                                                                callFunction: () {},
                                                                contentType: mainVariables.valueMapListProfilePage[index].type,
                                                                category: mainVariables.valueMapListProfilePage[index].category,
                                                                responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : //final //believed, private, status1, believedCategory, files, byte
                                          Container(
                                              padding: const EdgeInsets.all(1.5),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                                BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)
                                              ]),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 100.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                          width: width / 1.2,
                                                          child: Text(
                                                            "Exclusive Content: This post is private and only visible to those who believe. Believe ${mainVariables.valueMapListProfilePage[index].username} to unveil the full content.",
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(color: Theme.of(context).colorScheme.background),
                                                            /*const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)*/
                                                            textAlign: TextAlign.center,
                                                          )),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      SizedBox(
                                                        width: width / 3.5,
                                                        child: userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                            ? billboardWidgetsMain.getRepostBelieveButton(
                                                                heightValue: height / 33.76,
                                                                billboardUserid: mainVariables.valueMapListProfilePage[index].repostUser,
                                                                billboardUserName: mainVariables.valueMapListProfilePage[index].repostUserName,
                                                                context: context,
                                                                modelSetState: modelSetState,
                                                                index: index,
                                                                background: true,
                                                              )
                                                            : const SizedBox(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                      : //exclusive //notBelieved, private, status1, believedCategory, files, byte
                                      Container(
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                            BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)
                                          ]),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  switch (mainVariables.valueMapListProfilePage[index].type) {
                                                    case "blog":
                                                      {
                                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                        break;
                                                      }
                                                    case "byte":
                                                      {
                                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                        break;
                                                      }
                                                    case "forums":
                                                      {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                    idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                        (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                    comeFrom: "billBoardHome",
                                                                    forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                        });
                                                        var responseData = json.decode(response.body);
                                                        if (responseData["status"]) {
                                                          activeStatus = responseData["response"]["status"];

                                                          if (activeStatus == "active") {
                                                            var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                            var response = await http.post(url, headers: {
                                                              'Authorization': mainUserToken
                                                            }, body: {
                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                        mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                  activity: false,
                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                  navBool: false,
                                                                  fromWhere: 'similar',
                                                                );
                                                              }))
                                                            : activeStatus == 'active'
                                                                ? answerStatus
                                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                            activity: false,
                                                                            navBool: false,
                                                                            fromWhere: 'similar',
                                                                            surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                      }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return QuestionnairePage(
                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                          defaultIndex: answeredQuestion,
                                                                        );
                                                                      }))
                                                                : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                      activity: false,
                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                        height: height / 3.97,
                                                        decoration: const BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                        ),
                                                        child: CarouselSlider.builder(
                                                          carouselController: _carController,
                                                          options: CarouselOptions(
                                                              enableInfiniteScroll: false,
                                                              enlargeCenterPage: false,
                                                              onPageChanged: (int index, CarouselPageChangedReason reason) {
                                                                modelSetState(() {
                                                                  carouselIndexGlobal = index;
                                                                });
                                                              }),
                                                          itemCount: mainVariables.valueMapListProfilePage[index].files.length,
                                                          itemBuilder: (BuildContext context, int carouselIndex, int realIndex) {
                                                            return mainVariables.valueMapListProfilePage[index].files[carouselIndex].type == "image"
                                                                ? Image.network(
                                                                    mainVariables.valueMapListProfilePage[index].files[carouselIndex].file,
                                                                    fit: BoxFit.fill, errorBuilder: (context, __, error) {
                                                                    return Image.asset("lib/Constants/Assets/Settings/coverImage_default.png");
                                                                  })
                                                                : mainVariables.valueMapListProfilePage[index].files[carouselIndex].type == "video"
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
                                                                                  shape: BoxShape.circle, color: Colors.black26.withOpacity(0.7)),
                                                                              child: const Icon(
                                                                                Icons.play_arrow_sharp,
                                                                                color: Colors.white,
                                                                                size: 40,
                                                                              ))
                                                                        ],
                                                                      )
                                                                    : mainVariables.valueMapListProfilePage[index].files[carouselIndex].type ==
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
                                                        width: width / 1.06,
                                                        padding: EdgeInsets.only(
                                                          left: width / 27.4,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black12.withOpacity(0.3),
                                                          borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(15),
                                                            topRight: Radius.circular(15),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) => mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3,
                                                            color: Colors.white,
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type:mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false
                                                        ),*/
                                                                billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                billboardWidgetsMain.translationWidget(
                                                                    id: mainVariables.valueMapListProfilePage[index].id,
                                                                    type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                        ? "forums"
                                                                        : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                            ? "survey"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                                ? "news"
                                                                                : 'billboard',
                                                                    index: index,
                                                                    initFunction: getData,
                                                                    context: context,
                                                                    modelSetState: modelSetState,
                                                                    notUse: false,
                                                                    valueMapList: mainVariables.valueMapListProfilePage),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                                    ? billboardWidgetsMain.getHomeBelieveButton(
                                                                        heightValue: height / 33.76,
                                                                        isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                            (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                                        billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                                        billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                                        context: context,
                                                                        modelSetState: modelSetState,
                                                                        index: index,
                                                                        background: true,
                                                                      )
                                                                    : const SizedBox(),

                                                                ///more_vert
                                                                IconButton(
                                                                    onPressed: () {
                                                                      billboardWidgetsMain.bottomSheet(
                                                                        context1: context,
                                                                        myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                                        billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                                        billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                        type: "billboard",
                                                                        responseId: "",
                                                                        responseUserId: "",
                                                                        commentId: "",
                                                                        commentUserId: "",
                                                                        callFunction: getData,
                                                                        contentType: mainVariables.valueMapListProfilePage[index].type,
                                                                        modelSetState: modelSetState,
                                                                        responseDetail: {},
                                                                        category: mainVariables.valueMapListProfilePage[index].category,
                                                                        valueMapList: mainVariables.valueMapListProfilePage,
                                                                        index: index,
                                                                      );
                                                                    },
                                                                    icon: const Icon(
                                                                      Icons.more_vert,
                                                                      color: Colors.white,
                                                                      size: 25,
                                                                    ))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    mainVariables.valueMapListProfilePage[index].files.length > 1
                                                        ? Positioned(
                                                            bottom: 75,
                                                            left: (width / 2) - 35,
                                                            child: SizedBox(
                                                              height: 5,
                                                              child: ListView.builder(
                                                                  shrinkWrap: true,
                                                                  scrollDirection: Axis.horizontal,
                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                  itemCount: mainVariables.valueMapListProfilePage[index].files.length,
                                                                  itemBuilder: (BuildContext context, int index1) {
                                                                    return Container(
                                                                      height: 5,
                                                                      width: carouselIndexGlobal == index1 ? 20 : 5,
                                                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                          color:
                                                                              carouselIndexGlobal == index1 ? const Color(0XFF0EA102) : Colors.white),
                                                                    );
                                                                  }),
                                                            ))
                                                        : const SizedBox(),
                                                    mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                            mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                                        ? const SizedBox()
                                                        : Positioned(
                                                            top: height / 15,
                                                            right: 15,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                billboardWidgetsMain.believedTabBottomSheet(
                                                                    context: context,
                                                                    id: mainVariables.valueMapListProfilePage[index].repostId,
                                                                    type: mainVariables.valueMapListProfilePage[index].type);
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 35,
                                                                    width: 35,
                                                                  ),
                                                                  Positioned(
                                                                    left: 0,
                                                                    bottom: 0,
                                                                    child: Container(
                                                                      height: 30,
                                                                      width: 30,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          image: const DecorationImage(
                                                                            image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                          )),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 0,
                                                                    right: 0,
                                                                    child: Container(
                                                                      height: 15,
                                                                      width: 15,
                                                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                                      child: Center(
                                                                          child: Text(
                                                                        mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                            ? "9+"
                                                                            : mainVariables.valueMapListProfilePage[index].repostCount.toString(),
                                                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                      )),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      child: Container(
                                                        height: height / 14,
                                                        width: width,
                                                        padding: EdgeInsets.only(
                                                            top: height / 86.6, bottom: height / 86.6, right: width / 13.7, left: width / 41.1),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black12.withOpacity(0.3),
                                                        ),
                                                        child: RichText(
                                                          textAlign: TextAlign.left,
                                                          text: TextSpan(
                                                            children: conversationFunctionsMain.spanListBillBoardHome(
                                                                message: mainVariables.valueMapListProfilePage[index].title.length > 100
                                                                    ? mainVariables.valueMapListProfilePage[index].title.substring(0, 100)
                                                                    : mainVariables.valueMapListProfilePage[index].title,
                                                                context: context,
                                                                isByte: false),
                                                          ),
                                                        ) /*Text(
                                                         mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                         maxLines: 2,
                                                         style: TextStyle(
                                                             fontSize: _text*14,
                                                             color: Colors.white,
                                                             fontWeight: FontWeight.w500,
                                                             fontFamily: "Poppins",
                                                             overflow: TextOverflow.ellipsis
                                                         ),
                                                       )*/
                                                        ,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background,
                                                  borderRadius:
                                                      const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: height / 86.6,
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
                                                          heightValue: height / 17.32,
                                                          widthValue: width / 8.22,
                                                          myself: false,
                                                          avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                                          isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                                          userId: mainVariables.valueMapListProfilePage[index].userId,
                                                          repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                                          repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                                          isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                                          getBillBoardListData: getBillBoardListData,
                                                        ),
                                                        SizedBox(
                                                          width: width / 41.1,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  /*Navigator.push(context,
                                                              MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                                id:valueMapList[index].userId,
                                                                type:'forums',
                                                                index:0);}));*/
                                                                  /*bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return UserBillBoardProfilePage(
                                                                        userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                  }));*/
                                                                  if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                                      mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                    mainVariables.selectedTickerId.value =
                                                                        mainVariables.valueMapListProfilePage[index].userId;
                                                                  }
                                                                  bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                        ? IntermediaryBillBoardProfilePage(
                                                                            userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                        : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                            ? const BusinessProfilePage()
                                                                            : UserBillBoardProfilePage(
                                                                                userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                  }));
                                                                  if (response) {
                                                                    getBillBoardListData();
                                                                  }
                                                                },
                                                                child: Text(
                                                                    mainVariables.valueMapListProfilePage[index].username.toString().capitalizeFirst!,
                                                                    style: Theme.of(context)
                                                                        .textTheme
                                                                        .bodyLarge /*TextStyle(
                                                                      fontSize: text.scale(12),
                                                                      color: const Color(0XFF202020),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontFamily: "Poppins"),*/
                                                                    ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    mainVariables.valueMapListProfilePage[index].createdAt,
                                                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                          fontWeight: FontWeight.w400,
                                                                          color: const Color(0XFF737373),
                                                                        ), /*TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: const Color(0XFF737373),
                                                                        fontWeight: FontWeight.w400,
                                                                        fontFamily: "Poppins"),*/
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Text(
                                                                    " | ",
                                                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                          fontWeight: FontWeight.w400,
                                                                          color: const Color(0XFF737373),
                                                                        ), /*TextStyle(
                                                                      fontSize: text.scale(11),
                                                                      color: const Color(0XFF737373),
                                                                      fontWeight: FontWeight.w400,
                                                                    ),*/
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      billboardWidgetsMain.believersTabBottomSheet(
                                                                        context: context,
                                                                        id: mainVariables.valueMapListProfilePage[index].userId,
                                                                        isBelieversList: true,
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                      "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                            fontWeight: FontWeight.w400,
                                                                            color: const Color(0XFF737373),
                                                                          ), /*TextStyle(
                                                                          fontSize: text.scale(10),
                                                                          color: const Color(0XFF737373),
                                                                          fontWeight: FontWeight.w400,
                                                                          fontFamily: "Poppins"),*/
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        billboardWidgetsMain.likeButtonHomeListWidget(
                                                          likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                              (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                                          id: mainVariables.valueMapListProfilePage[index].id,
                                                          index: index,
                                                          context: context,
                                                          initFunction: () {},
                                                          modelSetState: modelSetState,
                                                          notUse: true,
                                                          dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                              (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                                          likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                              (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                                          dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                              (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                                          type: mainVariables.valueMapListProfilePage[index].type,
                                                          billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                              ? "news"
                                                              : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                  ? "forums"
                                                                  : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                      ? "survey"
                                                                      : "billboard",
                                                          /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                                          image: mainVariables.valueMapListProfilePage[index].avatar,
                                                          title: mainVariables.valueMapListProfilePage[index].title,
                                                          description: "",
                                                          fromWhere: 'homePage',
                                                          responseId: '',
                                                          controller: bottomSheetController,
                                                          commentId: '',
                                                          postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                          responseFocusList: mainVariables.responseFocusList,
                                                          responseUserId: '',
                                                          valueMapList: mainVariables.valueMapListProfilePage,
                                                        ),
                                                        SizedBox(
                                                          width: width / 41.1,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: height / 64),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            mainVariables.valueMapListProfilePage[index].companyName,
                                                            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                                  fontWeight: FontWeight.w700,
                                                                  color: const Color(0xFF017FDB),
                                                                ), /*TextStyle(
                                                                fontSize: text.scale(10),
                                                                color: const Color(0xFF017FDB),
                                                                fontWeight: FontWeight.bold),*/
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              billboardWidgetsMain.getLikeDislikeUsersList(
                                                                  context: context,
                                                                  billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                  responseId: "",
                                                                  commentId: "",
                                                                  billBoardType: "billboard",
                                                                  action: "views",
                                                                  likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                  disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                  index: 0,
                                                                  viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                  isViewIncluded: true);
                                                            },
                                                            child: Text(
                                                              " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                              style: TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              billboardWidgetsMain.getLikeDislikeUsersList(
                                                                  context: context,
                                                                  billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                  responseId: "",
                                                                  commentId: "",
                                                                  billBoardType: "billboard",
                                                                  action: "likes",
                                                                  likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                  disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                  index: 1,
                                                                  viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                  isViewIncluded: true);
                                                            },
                                                            child: Text(
                                                              " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                              style: TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                            ),
                                                          ),
                                                          /*  InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:"billboard",
                                                          action:"dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                          InkWell(
                                                            onTap: () async {
                                                              switch (mainVariables.valueMapListProfilePage[index].type) {
                                                                case "blog":
                                                                  {
                                                                    mainVariables.selectedBillboardIdMain.value =
                                                                        mainVariables.valueMapListProfilePage[index].id;
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext context) => const BlogDescriptionPage()));
                                                                    break;
                                                                  }
                                                                case "byte":
                                                                  {
                                                                    mainVariables.selectedBillboardIdMain.value =
                                                                        mainVariables.valueMapListProfilePage[index].id;
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext context) => const BytesDescriptionPage()));
                                                                    break;
                                                                  }
                                                                case "forums":
                                                                  {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                                comeFrom: "billBoardHome",
                                                                                forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                                      'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                                    });
                                                                    var responseData = json.decode(response.body);
                                                                    if (responseData["status"]) {
                                                                      activeStatus = responseData["response"]["status"];
                                                                      if (activeStatus == "active") {
                                                                        var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                        var response = await http.post(url, headers: {
                                                                          'Authorization': mainUserToken
                                                                        }, body: {
                                                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                                    mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                              activity: false,
                                                                              surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                              navBool: false,
                                                                              fromWhere: 'similar',
                                                                            );
                                                                          }))
                                                                        : activeStatus == 'active'
                                                                            ? answerStatus
                                                                                ? Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                    return AnalyticsPage(
                                                                                        surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                        activity: false,
                                                                                        navBool: false,
                                                                                        fromWhere: 'similar',
                                                                                        surveyTitle:
                                                                                            mainVariables.valueMapListProfilePage[index].title);
                                                                                  }))
                                                                                : Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (BuildContext context) {
                                                                                    return QuestionnairePage(
                                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                      defaultIndex: answeredQuestion,
                                                                                    );
                                                                                  }))
                                                                            : Navigator.push(context,
                                                                                MaterialPageRoute(builder: (BuildContext context) {
                                                                                return AnalyticsPage(
                                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                  activity: false,
                                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                              " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                              style: TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: height / 42.6),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                                  mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                mainVariables.selectedTickerId.value =
                                                                    mainVariables.valueMapListProfilePage[index].userId;
                                                              }
                                                              bool response =
                                                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                    ? IntermediaryBillBoardProfilePage(
                                                                        userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                    : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                        ? const BusinessProfilePage()
                                                                        : UserBillBoardProfilePage(
                                                                            userId: mainVariables.valueMapListProfilePage[index].userId);
                                                              }));
                                                              /*bool response =
                                                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return UserBillBoardProfilePage(
                                                                  userId: userIdMain,
                                                                );
                                                              }));*/
                                                              if (response) {
                                                                getBillBoardListData();
                                                              }
                                                            },
                                                            child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                          ),
                                                          SizedBox(
                                                            width: width / 41.1,
                                                          ),
                                                          billboardWidgetsMain.getResponseField(
                                                            context: context,
                                                            modelSetState: modelSetState,
                                                            billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                            postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                            responseId: "",
                                                            index: index,
                                                            fromWhere: 'homePage',
                                                            callFunction: () {},
                                                            contentType: mainVariables.valueMapListProfilePage[index].type,
                                                            category: mainVariables.valueMapListProfilePage[index].category,
                                                            responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                  : //final  //public, status1, believedCategory, files, byte
                                  Container(
                                      padding: const EdgeInsets.all(1.5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)]),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 50.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: width / 1.2,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "lib/Constants/Assets/BillBoard/failImage.png",
                                                        scale: 2,
                                                      ),
                                                      Text(
                                                        "whoops!",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(fontStyle: FontStyle.italic, color: Theme.of(context).colorScheme.background),
                                                        /*TextStyle(
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.w900,
                                                            color: Colors.white,
                                                            fontStyle: FontStyle.italic),*/
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  )),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              SizedBox(
                                                  width: width / 1.2,
                                                  child: Text(
                                                    "Content might be deleted or no longer active to display",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(color: Theme.of(context).colorScheme.background),
                                                    /*TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),*/
                                                    textAlign: TextAlign.center,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                              : //exclusive  //status0, believedCategory, files, byte
                              Container(
                                  padding: const EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                    BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)
                                    /*BoxShadow(
                                        color: Colors.black26.withOpacity(0.1), offset: const Offset(0.0, 0.0), blurRadius: 1.0, spreadRadius: 1.0)*/
                                  ]),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          switch (mainVariables.valueMapListProfilePage[index].type) {
                                            case "blog":
                                              {
                                                mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                Navigator.push(
                                                    context, MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                break;
                                              }
                                            case "byte":
                                              {
                                                mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                Navigator.push(
                                                    context, MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                break;
                                              }
                                            case "forums":
                                              {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext context) => ForumPostDescriptionPage(
                                                            idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                            comeFrom: "billBoardHome",
                                                            forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                  'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                });
                                                var responseData = json.decode(response.body);
                                                if (responseData["status"]) {
                                                  activeStatus = responseData["response"]["status"];

                                                  if (activeStatus == "active") {
                                                    var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                    var response = await http.post(url, headers: {
                                                      'Authorization': mainUserToken
                                                    }, body: {
                                                      'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                          activity: false,
                                                          surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                          navBool: false,
                                                          fromWhere: 'similar',
                                                        );
                                                      }))
                                                    : activeStatus == 'active'
                                                        ? answerStatus
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                    surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                    activity: false,
                                                                    navBool: false,
                                                                    fromWhere: 'similar',
                                                                    surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                              }))
                                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return QuestionnairePage(
                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                  defaultIndex: answeredQuestion,
                                                                );
                                                              }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                              activity: false,
                                                              surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                height: height / 3.97,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                ),
                                                child: CarouselSlider.builder(
                                                  carouselController: _carController,
                                                  options: CarouselOptions(
                                                      enableInfiniteScroll: false,
                                                      enlargeCenterPage: false,
                                                      onPageChanged: (int index, CarouselPageChangedReason reason) {
                                                        modelSetState(() {
                                                          carouselIndexGlobal = index;
                                                        });
                                                      }),
                                                  itemCount: mainVariables.valueMapListProfilePage[index].files.length,
                                                  itemBuilder: (BuildContext context, int carouselIndex, int realIndex) {
                                                    return mainVariables.valueMapListProfilePage[index].files[carouselIndex].type == "image"
                                                        ? Image.network(mainVariables.valueMapListProfilePage[index].files[carouselIndex].file,
                                                            fit: BoxFit.fill, errorBuilder: (context, __, error) {
                                                            return Image.asset("lib/Constants/Assets/Settings/coverImage_default.png");
                                                          })
                                                        : mainVariables.valueMapListProfilePage[index].files[carouselIndex].type == "video"
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
                                                                          shape: BoxShape.circle, color: Colors.black26.withOpacity(0.7)),
                                                                      child: const Icon(
                                                                        Icons.play_arrow_sharp,
                                                                        color: Colors.white,
                                                                        size: 40,
                                                                      ))
                                                                ],
                                                              )
                                                            : mainVariables.valueMapListProfilePage[index].files[carouselIndex].type == "document"
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
                                                width: width / 1.06,
                                                padding: EdgeInsets.only(
                                                  left: width / 27.4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black12.withOpacity(0.3),
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(15),
                                                    topRight: Radius.circular(15),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) => mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3,
                                                            color: Colors.white,
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type:mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false
                                                        ),*/
                                                        billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        billboardWidgetsMain.translationWidget(
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                ? "forums"
                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                    ? "survey"
                                                                    : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                        ? "news"
                                                                        : 'billboard',
                                                            index: index,
                                                            initFunction: getData,
                                                            context: context,
                                                            modelSetState: modelSetState,
                                                            notUse: false,
                                                            valueMapList: mainVariables.valueMapListProfilePage),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                            ? billboardWidgetsMain.getHomeBelieveButton(
                                                                heightValue: height / 33.76,
                                                                isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                                billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                                billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                                context: context,
                                                                modelSetState: modelSetState,
                                                                index: index,
                                                                background: true,
                                                              )
                                                            : const SizedBox(),

                                                        ///more_vert
                                                        IconButton(
                                                            onPressed: () {
                                                              billboardWidgetsMain.bottomSheet(
                                                                context1: context,
                                                                myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                                billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                                billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                type: "billboard",
                                                                responseId: "",
                                                                responseUserId: "",
                                                                commentId: "",
                                                                commentUserId: "",
                                                                callFunction: getData,
                                                                contentType: mainVariables.valueMapListProfilePage[index].type,
                                                                modelSetState: modelSetState,
                                                                responseDetail: {},
                                                                category: mainVariables.valueMapListProfilePage[index].category,
                                                                valueMapList: mainVariables.valueMapListProfilePage,
                                                                index: index,
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons.more_vert,
                                                              color: Colors.white,
                                                              size: 25,
                                                            ))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            mainVariables.valueMapListProfilePage[index].files.length > 1
                                                ? Positioned(
                                                    bottom: 75,
                                                    left: (width / 2) - 35,
                                                    child: SizedBox(
                                                      height: 5,
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.horizontal,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          itemCount: mainVariables.valueMapListProfilePage[index].files.length,
                                                          itemBuilder: (BuildContext context, int index1) {
                                                            return Container(
                                                              height: 5,
                                                              width: carouselIndexGlobal == index1 ? 20 : 5,
                                                              margin: const EdgeInsets.symmetric(horizontal: 3),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  color: carouselIndexGlobal == index1 ? const Color(0XFF0EA102) : Colors.white),
                                                            );
                                                          }),
                                                    ))
                                                : const SizedBox(),
                                            mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                    mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                                ? const SizedBox()
                                                : Positioned(
                                                    top: height / 15,
                                                    right: 15,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        billboardWidgetsMain.believedTabBottomSheet(
                                                            context: context,
                                                            id: mainVariables.valueMapListProfilePage[index].repostId,
                                                            type: mainVariables.valueMapListProfilePage[index].type);
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          const SizedBox(
                                                            height: 35,
                                                            width: 35,
                                                          ),
                                                          Positioned(
                                                            left: 0,
                                                            bottom: 0,
                                                            child: Container(
                                                              height: 30,
                                                              width: 30,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  image: const DecorationImage(
                                                                    image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                  )),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            child: Container(
                                                              height: 15,
                                                              width: 15,
                                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                              child: Center(
                                                                  child: Text(
                                                                mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                    ? "9+"
                                                                    : mainVariables.valueMapListProfilePage[index].repostCount.toString(),
                                                                style: const TextStyle(color: Colors.white, fontSize: 10),
                                                              )),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              child: Container(
                                                height: height / 14,
                                                width: width,
                                                padding: EdgeInsets.only(
                                                    top: height / 86.6, bottom: height / 86.6, right: width / 13.7, left: width / 41.1),
                                                decoration: BoxDecoration(
                                                  color: Colors.black12.withOpacity(0.3),
                                                ),
                                                child: RichText(
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                    children: conversationFunctionsMain.spanListBillBoardHome(
                                                        message: mainVariables.valueMapListProfilePage[index].title.length > 100
                                                            ? mainVariables.valueMapListProfilePage[index].title.substring(0, 100)
                                                            : mainVariables.valueMapListProfilePage[index].title,
                                                        context: context,
                                                        isByte: false),
                                                  ),
                                                ) /*Text(
                                                         mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                         maxLines: 2,
                                                         style: TextStyle(
                                                             fontSize: _text*14,
                                                             color: Colors.white,
                                                             fontWeight: FontWeight.w500,
                                                             fontFamily: "Poppins",
                                                             overflow: TextOverflow.ellipsis
                                                         ),
                                                       )*/
                                                ,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.background,
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: height / 86.6,
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
                                                  heightValue: height / 17.32,
                                                  widthValue: width / 8.22,
                                                  myself: false,
                                                  avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                                  isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                                  userId: mainVariables.valueMapListProfilePage[index].userId,
                                                  repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                                  repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                                  isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                                  getBillBoardListData: getBillBoardListData,
                                                ),
                                                SizedBox(
                                                  width: width / 41.1,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          /*Navigator.push(context,
                                                              MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                                id:valueMapList[index].userId,
                                                                type:'forums',
                                                                index:0);}));*/
                                                          if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                              mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                            mainVariables.selectedTickerId.value =
                                                                mainVariables.valueMapListProfilePage[index].userId;
                                                          }
                                                          bool response =
                                                              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                ? IntermediaryBillBoardProfilePage(
                                                                    userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                    ? const BusinessProfilePage()
                                                                    : UserBillBoardProfilePage(
                                                                        userId: mainVariables.valueMapListProfilePage[index].userId);
                                                          }));
                                                          /*bool response =
                                                              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return UserBillBoardProfilePage(
                                                                userId: mainVariables.valueMapListProfilePage[index].userId);
                                                          }));*/
                                                          if (response) {
                                                            getBillBoardListData();
                                                          }
                                                        },
                                                        child: Text(mainVariables.valueMapListProfilePage[index].username.toString().capitalizeFirst!,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge /*TextStyle(
                                                              fontSize: text.scale(12),
                                                              color: const Color(0XFF202020),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Poppins"),*/
                                                            ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            mainVariables.valueMapListProfilePage[index].createdAt,
                                                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                  fontWeight: FontWeight.w400,
                                                                  color: const Color(0XFF737373),
                                                                ), /*TextStyle(
                                                                fontSize: text.scale(10),
                                                                color: const Color(0XFF737373),
                                                                fontWeight: FontWeight.w400,
                                                                fontFamily: "Poppins"),*/
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          Text(
                                                            " | ",
                                                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                  fontWeight: FontWeight.w400,
                                                                  color: const Color(0XFF737373),
                                                                ), /*TextStyle(
                                                              fontSize: text.scale(11),
                                                              color: const Color(0XFF737373),
                                                              fontWeight: FontWeight.w400,
                                                            ),*/
                                                          ),
                                                          const SizedBox(
                                                            width: 3,
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              billboardWidgetsMain.believersTabBottomSheet(
                                                                context: context,
                                                                id: mainVariables.valueMapListProfilePage[index].userId,
                                                                isBelieversList: true,
                                                              );
                                                            },
                                                            child: Text(
                                                              "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                    fontWeight: FontWeight.w400,
                                                                    color: const Color(0XFF737373),
                                                                  ), /*TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: const Color(0XFF737373),
                                                                  fontWeight: FontWeight.w400,
                                                                  fontFamily: "Poppins"),*/
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                billboardWidgetsMain.likeButtonHomeListWidget(
                                                  likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                      (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                                  id: mainVariables.valueMapListProfilePage[index].id,
                                                  index: index,
                                                  context: context,
                                                  initFunction: () {},
                                                  modelSetState: modelSetState,
                                                  notUse: true,
                                                  dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                      (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                                  likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                      (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                                  dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                      (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                                  type: mainVariables.valueMapListProfilePage[index].type,
                                                  billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                      ? "news"
                                                      : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                          ? "forums"
                                                          : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                              ? "survey"
                                                              : "billboard",
                                                  /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                                  image: mainVariables.valueMapListProfilePage[index].avatar,
                                                  title: mainVariables.valueMapListProfilePage[index].title,
                                                  description: "",
                                                  fromWhere: 'homePage',
                                                  responseId: '',
                                                  controller: bottomSheetController,
                                                  commentId: '',
                                                  postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                  responseFocusList: mainVariables.responseFocusList,
                                                  responseUserId: '',
                                                  valueMapList: mainVariables.valueMapListProfilePage,
                                                ),
                                                SizedBox(
                                                  width: width / 41.1,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: height / 64),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    mainVariables.valueMapListProfilePage[index].companyName,
                                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                          fontWeight: FontWeight.w700,
                                                          color: const Color(0xFF017FDB),
                                                        ), /*TextStyle(
                                                        fontSize: text.scale(10), color: const Color(0xFF017FDB), fontWeight: FontWeight.bold),*/
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                          responseId: "",
                                                          commentId: "",
                                                          billBoardType: "billboard",
                                                          action: "views",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 0,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true);
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                      style: TextStyle(
                                                          fontSize: text.scale(10),
                                                          color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                          responseId: "",
                                                          commentId: "",
                                                          billBoardType: "billboard",
                                                          action: "likes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 1,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true);
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                      style: TextStyle(
                                                          fontSize: text.scale(10),
                                                          color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                    ),
                                                  ),
                                                  /* InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:"billboard",
                                                          action:"dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                  InkWell(
                                                    onTap: () async {
                                                      switch (mainVariables.valueMapListProfilePage[index].type) {
                                                        case "blog":
                                                          {
                                                            mainVariables.selectedBillboardIdMain.value =
                                                                mainVariables.valueMapListProfilePage[index].id;
                                                            Navigator.push(context,
                                                                MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                            break;
                                                          }
                                                        case "byte":
                                                          {
                                                            mainVariables.selectedBillboardIdMain.value =
                                                                mainVariables.valueMapListProfilePage[index].id;
                                                            Navigator.push(context,
                                                                MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                            break;
                                                          }
                                                        case "forums":
                                                          {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                        idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                            (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                        comeFrom: "billBoardHome",
                                                                        forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                            });
                                                            var responseData = json.decode(response.body);
                                                            if (responseData["status"]) {
                                                              activeStatus = responseData["response"]["status"];
                                                              if (activeStatus == "active") {
                                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                var response = await http.post(url, headers: {
                                                                  'Authorization': mainUserToken
                                                                }, body: {
                                                                  'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                            mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                      activity: false,
                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                      navBool: false,
                                                                      fromWhere: 'similar',
                                                                    );
                                                                  }))
                                                                : activeStatus == 'active'
                                                                    ? answerStatus
                                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return AnalyticsPage(
                                                                                surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                activity: false,
                                                                                navBool: false,
                                                                                fromWhere: 'similar',
                                                                                surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                          }))
                                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                            return QuestionnairePage(
                                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                              defaultIndex: answeredQuestion,
                                                                            );
                                                                          }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                          activity: false,
                                                                          surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                      " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                      style: TextStyle(
                                                          fontSize: text.scale(10),
                                                          color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: height / 42.6),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                          mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                        mainVariables.selectedTickerId.value = mainVariables.valueMapListProfilePage[index].userId;
                                                      }
                                                      bool response =
                                                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                            ? IntermediaryBillBoardProfilePage(
                                                                userId: mainVariables.valueMapListProfilePage[index].userId)
                                                            : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                ? const BusinessProfilePage()
                                                                : UserBillBoardProfilePage(
                                                                    userId: mainVariables.valueMapListProfilePage[index].userId);
                                                      }));
                                                      /*bool response =
                                                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return UserBillBoardProfilePage(
                                                          userId: userIdMain,
                                                        );
                                                      }));*/
                                                      if (response) {
                                                        getBillBoardListData();
                                                      }
                                                    },
                                                    child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                  ),
                                                  SizedBox(
                                                    width: width / 41.1,
                                                  ),
                                                  billboardWidgetsMain.getResponseField(
                                                    context: context,
                                                    modelSetState: modelSetState,
                                                    billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                    postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                    responseId: "",
                                                    index: index,
                                                    fromWhere: 'homePage',
                                                    callFunction: () {},
                                                    contentType: mainVariables.valueMapListProfilePage[index].type,
                                                    category: mainVariables.valueMapListProfilePage[index].category,
                                                    responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                        (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                          : //final //NonBelievedCategory, files, byte
                          Container(
                              padding: const EdgeInsets.all(1.5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)]),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      switch (mainVariables.valueMapListProfilePage[index].type) {
                                        case "blog":
                                          {
                                            mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                            break;
                                          }
                                        case "byte":
                                          {
                                            mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                            break;
                                          }
                                        case "forums":
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) => ForumPostDescriptionPage(
                                                        idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                            (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                        comeFrom: "billBoardHome",
                                                        forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                            });
                                            var responseData = json.decode(response.body);
                                            if (responseData["status"]) {
                                              activeStatus = responseData["response"]["status"];

                                              if (activeStatus == "active") {
                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                var response = await http.post(url, headers: {
                                                  'Authorization': mainUserToken
                                                }, body: {
                                                  'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                            mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return AnalyticsPage(
                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                      activity: false,
                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                      navBool: false,
                                                      fromWhere: 'similar',
                                                    );
                                                  }))
                                                : activeStatus == 'active'
                                                    ? answerStatus
                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                activity: false,
                                                                navBool: false,
                                                                fromWhere: 'similar',
                                                                surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                          }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return QuestionnairePage(
                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                              defaultIndex: answeredQuestion,
                                                            );
                                                          }))
                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                          activity: false,
                                                          surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                            height: height / 3.97,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                            ),
                                            child: CarouselSlider.builder(
                                              carouselController: _carController,
                                              options: CarouselOptions(
                                                  enableInfiniteScroll: false,
                                                  enlargeCenterPage: false,
                                                  onPageChanged: (int index, CarouselPageChangedReason reason) {
                                                    modelSetState(() {
                                                      carouselIndexGlobal = index;
                                                    });
                                                  }),
                                              itemCount: mainVariables.valueMapListProfilePage[index].files.length,
                                              itemBuilder: (BuildContext context, int carouselIndex, int realIndex) {
                                                return mainVariables.valueMapListProfilePage[index].files[carouselIndex].type == "image"
                                                    ? Image.network(mainVariables.valueMapListProfilePage[index].files[carouselIndex].file,
                                                        fit: BoxFit.fill, errorBuilder: (context, __, error) {
                                                        return Image.asset("lib/Constants/Assets/Settings/coverImage_default.png");
                                                      })
                                                    : mainVariables.valueMapListProfilePage[index].files[carouselIndex].type == "video"
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
                                                                  decoration:
                                                                      BoxDecoration(shape: BoxShape.circle, color: Colors.black26.withOpacity(0.7)),
                                                                  child: const Icon(
                                                                    Icons.play_arrow_sharp,
                                                                    color: Colors.white,
                                                                    size: 40,
                                                                  ))
                                                            ],
                                                          )
                                                        : mainVariables.valueMapListProfilePage[index].files[carouselIndex].type == "document"
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
                                            width: width / 1.06,
                                            padding: EdgeInsets.only(
                                              left: width / 27.4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black12.withOpacity(0.3),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) => mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3,
                                                            color: Colors.white,
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type:mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false
                                                        ),*/
                                                    billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    billboardWidgetsMain.translationWidget(
                                                        id: mainVariables.valueMapListProfilePage[index].id,
                                                        type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                            ? "forums"
                                                            : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                ? "survey"
                                                                : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                    ? "news"
                                                                    : 'billboard',
                                                        index: index,
                                                        initFunction: getData,
                                                        context: context,
                                                        modelSetState: modelSetState,
                                                        notUse: false,
                                                        valueMapList: mainVariables.valueMapListProfilePage),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                        ? billboardWidgetsMain.getHomeBelieveButton(
                                                            heightValue: height / 33.76,
                                                            isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                            billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                            billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                            context: context,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            background: true,
                                                          )
                                                        : const SizedBox(),

                                                    ///more_vert
                                                    IconButton(
                                                        onPressed: () {
                                                          billboardWidgetsMain.bottomSheet(
                                                            context1: context,
                                                            myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                            billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                            billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                            type: "billboard",
                                                            responseId: "",
                                                            responseUserId: "",
                                                            commentId: "",
                                                            commentUserId: "",
                                                            callFunction: getData,
                                                            contentType: mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            responseDetail: {},
                                                            category: mainVariables.valueMapListProfilePage[index].category,
                                                            valueMapList: mainVariables.valueMapListProfilePage,
                                                            index: index,
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.more_vert,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        mainVariables.valueMapListProfilePage[index].files.length > 1
                                            ? Positioned(
                                                bottom: 75,
                                                left: (width / 2) - 35,
                                                child: SizedBox(
                                                  height: 5,
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection: Axis.horizontal,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemCount: mainVariables.valueMapListProfilePage[index].files.length,
                                                      itemBuilder: (BuildContext context, int index1) {
                                                        return Container(
                                                          height: 5,
                                                          width: carouselIndexGlobal == index1 ? 20 : 5,
                                                          margin: const EdgeInsets.symmetric(horizontal: 3),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(8),
                                                              color: carouselIndexGlobal == index1 ? const Color(0XFF0EA102) : Colors.white),
                                                        );
                                                      }),
                                                ))
                                            : const SizedBox(),
                                        mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                            ? const SizedBox()
                                            : Positioned(
                                                top: height / 15,
                                                right: 15,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    billboardWidgetsMain.believedTabBottomSheet(
                                                        context: context,
                                                        id: mainVariables.valueMapListProfilePage[index].repostId,
                                                        type: mainVariables.valueMapListProfilePage[index].type);
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      const SizedBox(
                                                        height: 35,
                                                        width: 35,
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        bottom: 0,
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              image: const DecorationImage(
                                                                image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                              )),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          height: 15,
                                                          width: 15,
                                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                          child: Center(
                                                              child: Text(
                                                            mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                ? "9+"
                                                                : mainVariables.valueMapListProfilePage[index].repostCount.toString(),
                                                            style: const TextStyle(color: Colors.white, fontSize: 10),
                                                          )),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Container(
                                            height: height / 14,
                                            width: width,
                                            padding:
                                                EdgeInsets.only(top: height / 86.6, bottom: height / 86.6, right: width / 13.7, left: width / 41.1),
                                            decoration: BoxDecoration(
                                              color: Colors.black12.withOpacity(0.3),
                                            ),
                                            child: RichText(
                                              textAlign: TextAlign.left,
                                              text: TextSpan(
                                                children: conversationFunctionsMain.spanListBillBoardHome(
                                                    message: mainVariables.valueMapListProfilePage[index].title.length > 100
                                                        ? mainVariables.valueMapListProfilePage[index].title.substring(0, 100)
                                                        : mainVariables.valueMapListProfilePage[index].title,
                                                    context: context,
                                                    isByte: false),
                                              ),
                                            ) /*Text(
                                                         mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                         maxLines: 2,
                                                         style: TextStyle(
                                                             fontSize: _text*14,
                                                             color: Colors.white,
                                                             fontWeight: FontWeight.w500,
                                                             fontFamily: "Poppins",
                                                             overflow: TextOverflow.ellipsis
                                                         ),
                                                       )*/
                                            ,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.background,
                                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height / 86.6,
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
                                              heightValue: height / 17.32,
                                              widthValue: width / 8.22,
                                              myself: false,
                                              avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                              isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                              userId: mainVariables.valueMapListProfilePage[index].userId,
                                              repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                              repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                              isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                              getBillBoardListData: getBillBoardListData,
                                            ),
                                            SizedBox(
                                              width: width / 41.1,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      /*Navigator.push(context,
                                                              MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                                id:valueMapList[index].userId,
                                                                type:'forums',
                                                                index:0);}));*/
                                                      /*bool response =
                                                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return UserBillBoardProfilePage(userId: mainVariables.valueMapListProfilePage[index].userId);
                                                      }));*/
                                                      if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                          mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                        mainVariables.selectedTickerId.value = mainVariables.valueMapListProfilePage[index].userId;
                                                      }
                                                      bool response =
                                                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                            ? IntermediaryBillBoardProfilePage(
                                                                userId: mainVariables.valueMapListProfilePage[index].userId)
                                                            : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                ? const BusinessProfilePage()
                                                                : UserBillBoardProfilePage(
                                                                    userId: mainVariables.valueMapListProfilePage[index].userId);
                                                      }));
                                                      if (response) {
                                                        getBillBoardListData();
                                                      }
                                                    },
                                                    child: Text(
                                                      mainVariables.valueMapListProfilePage[index].username.toString().capitalizeFirst!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge, /*TextStyle(
                                                          fontSize: text.scale(12),
                                                          color: const Color(0XFF202020),
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: "Poppins"),*/
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        mainVariables.valueMapListProfilePage[index].createdAt,
                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                              fontWeight: FontWeight.w400,
                                                              color: const Color(0XFF737373),
                                                            ), /*TextStyle(
                                                            fontSize: text.scale(10),
                                                            color: const Color(0XFF737373),
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: "Poppins"),*/
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        " | ",
                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                              fontWeight: FontWeight.w400,
                                                              color: const Color(0XFF737373),
                                                            ), /*TextStyle(
                                                          fontSize: text.scale(11),
                                                          color: const Color(0XFF737373),
                                                          fontWeight: FontWeight.w400,
                                                        ),*/
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          billboardWidgetsMain.believersTabBottomSheet(
                                                            context: context,
                                                            id: mainVariables.valueMapListProfilePage[index].userId,
                                                            isBelieversList: true,
                                                          );
                                                        },
                                                        child: Text(
                                                          "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                fontWeight: FontWeight.w400,
                                                                color: const Color(0XFF737373),
                                                              ), /*TextStyle(
                                                              fontSize: text.scale(10),
                                                              color: const Color(0XFF737373),
                                                              fontWeight: FontWeight.w400,
                                                              fontFamily: "Poppins"),*/
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            billboardWidgetsMain.likeButtonHomeListWidget(
                                              likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                  (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                              id: mainVariables.valueMapListProfilePage[index].id,
                                              index: index,
                                              context: context,
                                              initFunction: () {},
                                              modelSetState: modelSetState,
                                              notUse: true,
                                              dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                  (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                              likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                  (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                              dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                  (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                              type: mainVariables.valueMapListProfilePage[index].type,
                                              billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                  ? "news"
                                                  : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                      ? "forums"
                                                      : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                          ? "survey"
                                                          : "billboard",
                                              /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                              image: mainVariables.valueMapListProfilePage[index].avatar,
                                              title: mainVariables.valueMapListProfilePage[index].title,
                                              description: "",
                                              fromWhere: 'homePage',
                                              responseId: '',
                                              controller: bottomSheetController,
                                              commentId: '',
                                              postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                              responseFocusList: mainVariables.responseFocusList,
                                              responseUserId: '',
                                              valueMapList: mainVariables.valueMapListProfilePage,
                                            ),
                                            SizedBox(
                                              width: width / 41.1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: height / 64),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                mainVariables.valueMapListProfilePage[index].companyName,
                                                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                      fontWeight: FontWeight.w700,
                                                      color: const Color(0xFF017FDB),
                                                    ),
                                                /*TextStyle(fontSize: text.scale(10), color: const Color(0xFF017FDB), fontWeight: FontWeight.bold),*/
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                      context: context,
                                                      billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                      responseId: "",
                                                      commentId: "",
                                                      billBoardType: "billboard",
                                                      action: "views",
                                                      likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                      disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                      index: 0,
                                                      viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                      isViewIncluded: true);
                                                },
                                                child: Text(
                                                  " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  billboardWidgetsMain.getLikeDislikeUsersList(
                                                      context: context,
                                                      billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                      responseId: "",
                                                      commentId: "",
                                                      billBoardType: "billboard",
                                                      action: "likes",
                                                      likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                      disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                      index: 1,
                                                      viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                      isViewIncluded: true);
                                                },
                                                child: Text(
                                                  " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                ),
                                              ),
                                              /*  InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:"billboard",
                                                          action:"dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                              InkWell(
                                                onTap: () async {
                                                  switch (mainVariables.valueMapListProfilePage[index].type) {
                                                    case "blog":
                                                      {
                                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                        break;
                                                      }
                                                    case "byte":
                                                      {
                                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                        break;
                                                      }
                                                    case "forums":
                                                      {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                    idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                        (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                    comeFrom: "billBoardHome",
                                                                    forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                        });
                                                        var responseData = json.decode(response.body);
                                                        if (responseData["status"]) {
                                                          activeStatus = responseData["response"]["status"];
                                                          if (activeStatus == "active") {
                                                            var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                            var response = await http.post(url, headers: {
                                                              'Authorization': mainUserToken
                                                            }, body: {
                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                        mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                  activity: false,
                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                  navBool: false,
                                                                  fromWhere: 'similar',
                                                                );
                                                              }))
                                                            : activeStatus == 'active'
                                                                ? answerStatus
                                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                            activity: false,
                                                                            navBool: false,
                                                                            fromWhere: 'similar',
                                                                            surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                      }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return QuestionnairePage(
                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                          defaultIndex: answeredQuestion,
                                                                        );
                                                                      }))
                                                                : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                      activity: false,
                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                  " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: height / 42.6),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                      mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                    mainVariables.selectedTickerId.value = mainVariables.valueMapListProfilePage[index].userId;
                                                  }
                                                  bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                        ? IntermediaryBillBoardProfilePage(
                                                            userId: mainVariables.valueMapListProfilePage[index].userId)
                                                        : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                            ? const BusinessProfilePage()
                                                            : UserBillBoardProfilePage(userId: mainVariables.valueMapListProfilePage[index].userId);
                                                  }));
                                                  /*bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return UserBillBoardProfilePage(
                                                      userId: userIdMain,
                                                    );
                                                  }));*/
                                                  if (response) {
                                                    getBillBoardListData();
                                                  }
                                                },
                                                child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                              ),
                                              SizedBox(
                                                width: width / 41.1,
                                              ),
                                              billboardWidgetsMain.getResponseField(
                                                context: context,
                                                modelSetState: modelSetState,
                                                billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                responseId: "",
                                                index: index,
                                                fromWhere: 'homePage',
                                                callFunction: () {},
                                                contentType: mainVariables.valueMapListProfilePage[index].type,
                                                category: mainVariables.valueMapListProfilePage[index].category,
                                                responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                    (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                  : mainVariables.valueMapListProfilePage[index].postType == "repost"
                      ? mainVariables.activeTypeMain.value == "believed"
                          ? mainVariables.valueMapListProfilePage[index].repostStatus == 1
                              ? mainVariables.valueMapListProfilePage[index].repostType == "private"
                                  ? mainVariables.valueMapListProfilePage[index].repostBelieved
                                      ? Container(
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                            BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)
                                          ]),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  switch (mainVariables.valueMapListProfilePage[index].type) {
                                                    case "blog":
                                                      {
                                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                        break;
                                                      }
                                                    case "byte":
                                                      {
                                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                        break;
                                                      }
                                                    case "forums":
                                                      {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                    idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                        (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                    comeFrom: "billBoardHome",
                                                                    forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                        });
                                                        var responseData = json.decode(response.body);
                                                        if (responseData["status"]) {
                                                          activeStatus = responseData["response"]["status"];

                                                          if (activeStatus == "active") {
                                                            var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                            var response = await http.post(url, headers: {
                                                              'Authorization': mainUserToken
                                                            }, body: {
                                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                        mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                  activity: false,
                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                  navBool: false,
                                                                  fromWhere: 'similar',
                                                                );
                                                              }))
                                                            : activeStatus == 'active'
                                                                ? answerStatus
                                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return AnalyticsPage(
                                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                            activity: false,
                                                                            navBool: false,
                                                                            fromWhere: 'similar',
                                                                            surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                      }))
                                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return QuestionnairePage(
                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                          defaultIndex: answeredQuestion,
                                                                        );
                                                                      }))
                                                                : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                      activity: false,
                                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type: 'news',
                                                            activity: true,
                                                            checkMain: false,
                                                          );
                                                        }));*/
                                                        Get.to(const DemoView(), arguments: {
                                                          "id": mainVariables.valueMapListProfilePage[index].id,
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
                                                      height: height / 3.97,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                          gradient: mainVariables.valueMapListProfilePage[index].type == "blog"
                                                              ? const RadialGradient(
                                                                  colors: [Color.fromRGBO(23, 25, 27, 0.90), Color.fromRGBO(85, 85, 85, 0.00)],
                                                                  radius: 15.0,
                                                                )
                                                              : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                  ? const RadialGradient(
                                                                      colors: [Color.fromRGBO(0, 92, 175, 0.90), Color.fromRGBO(13, 155, 1, 0.00)],
                                                                      radius: 15.0,
                                                                    )
                                                                  : mainVariables.valueMapListProfilePage[index].type == "survey"
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
                                                              mainVariables.valueMapListProfilePage[index].type == "news"
                                                                  ? mainVariables.valueMapListProfilePage[index].newsImage
                                                                  : "",
                                                            ),
                                                            fit: BoxFit.fill,
                                                          )),
                                                      child: Center(
                                                        child: Text(
                                                          mainVariables.valueMapListProfilePage[index].type == "news"
                                                              ? ""
                                                              : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                  ? mainVariables.valueMapListProfilePage[index].type
                                                                      .toString()
                                                                      .capitalizeFirst!
                                                                      .substring(0, mainVariables.valueMapListProfilePage[index].type.length - 1)
                                                                  : mainVariables.valueMapListProfilePage[index].type.toString().capitalizeFirst!,
                                                          style: TextStyle(
                                                              fontSize: text.scale(40), fontWeight: FontWeight.w900, color: const Color(0XFFFFFFFF)),
                                                        ),
                                                      ),
                                                    ),
                                                    mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                            mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                                        ? const SizedBox()
                                                        : Positioned(
                                                            top: height / 15,
                                                            right: 15,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                billboardWidgetsMain.believedTabBottomSheet(
                                                                    context: context,
                                                                    id: mainVariables.valueMapListProfilePage[index].repostId,
                                                                    type: mainVariables.valueMapListProfilePage[index].type);
                                                              },
                                                              child: Stack(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 35,
                                                                    width: 35,
                                                                  ),
                                                                  Positioned(
                                                                    left: 0,
                                                                    bottom: 0,
                                                                    child: Container(
                                                                      height: 30,
                                                                      width: 30,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          image: const DecorationImage(
                                                                            image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                          )),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 0,
                                                                    right: 0,
                                                                    child: Container(
                                                                      height: 15,
                                                                      width: 15,
                                                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                                      child: Center(
                                                                          child: Text(
                                                                        mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                            ? "9+"
                                                                            : mainVariables.valueMapListProfilePage[index].repostCount.toString(),
                                                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                      )),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                    Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      child: Container(
                                                        height: height / 18,
                                                        width: width / 1.06,
                                                        padding: EdgeInsets.only(
                                                          left: width / 27.4,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black12.withOpacity(0.3),
                                                          borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(15),
                                                            topRight: Radius.circular(15),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) => mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3,
                                                            color: Colors.white,
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type: mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false
                                                        ),*/
                                                                billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                billboardWidgetsMain.translationWidget(
                                                                    id: mainVariables.valueMapListProfilePage[index].id,
                                                                    type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                        ? "forums"
                                                                        : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                            ? "survey"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                                ? "news"
                                                                                : 'billboard',
                                                                    index: index,
                                                                    initFunction: getData,
                                                                    context: context,
                                                                    modelSetState: modelSetState,
                                                                    notUse: false,
                                                                    valueMapList: mainVariables.valueMapListProfilePage),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                                    ? billboardWidgetsMain.getHomeBelieveButton(
                                                                        heightValue: height / 33.76,
                                                                        isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                            (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                                        billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                                        billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                                        context: context,
                                                                        modelSetState: modelSetState,
                                                                        index: index,
                                                                        background: true,
                                                                      )
                                                                    : const SizedBox(),

                                                                ///more_vert
                                                                IconButton(
                                                                    onPressed: () {
                                                                      billboardWidgetsMain.bottomSheet(
                                                                        context1: context,
                                                                        myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                                        billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                                        billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                        type: "billboard",
                                                                        responseId: "",
                                                                        responseUserId: "",
                                                                        commentId: "",
                                                                        commentUserId: "",
                                                                        callFunction: getData,
                                                                        contentType: mainVariables.valueMapListProfilePage[index].type,
                                                                        modelSetState: modelSetState,
                                                                        responseDetail: {},
                                                                        category: mainVariables.valueMapListProfilePage[index].category,
                                                                        valueMapList: mainVariables.valueMapListProfilePage,
                                                                        index: index,
                                                                      );
                                                                    },
                                                                    icon: const Icon(
                                                                      Icons.more_vert,
                                                                      color: Colors.white,
                                                                      size: 25,
                                                                    ))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      child: Container(
                                                        height: height / 14,
                                                        width: width,
                                                        padding: EdgeInsets.only(
                                                            top: height / 86.6, bottom: height / 86.6, right: width / 13.7, left: width / 41.1),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black12.withOpacity(0.3),
                                                        ),
                                                        child: RichText(
                                                          textAlign: TextAlign.left,
                                                          text: TextSpan(
                                                            children: conversationFunctionsMain.spanListBillBoardHome(
                                                                message: mainVariables.valueMapListProfilePage[index].title.length > 100
                                                                    ? mainVariables.valueMapListProfilePage[index].title.substring(0, 100)
                                                                    : mainVariables.valueMapListProfilePage[index].title,
                                                                context: context,
                                                                isByte: false),
                                                          ),
                                                        ) /*Text(
                                                         mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                         maxLines: 2,
                                                         style: TextStyle(
                                                             fontSize: _text*14,
                                                             color: Colors.white,
                                                             fontWeight: FontWeight.w500,
                                                             fontFamily: "Poppins",
                                                             overflow: TextOverflow.ellipsis
                                                         ),
                                                       )*/
                                                        ,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.background,
                                                  borderRadius:
                                                      const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: height / 86.6,
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
                                                          heightValue: height / 17.32,
                                                          widthValue: width / 8.22,
                                                          myself: false,
                                                          avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                                          isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                                          userId: mainVariables.valueMapListProfilePage[index].userId,
                                                          repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                                          repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                                          isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                                          getBillBoardListData: getBillBoardListData,
                                                        ),
                                                        SizedBox(
                                                          width: width / 41.1,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: () async {
                                                                  /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                                id:valueMapList[index].userId,
                                                                type:'forums',
                                                                index:0
                                                            );
                                                          }));*/
                                                                  /* bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return UserBillBoardProfilePage(
                                                                        userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                  }));*/
                                                                  if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                                      mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                    mainVariables.selectedTickerId.value =
                                                                        mainVariables.valueMapListProfilePage[index].userId;
                                                                  }
                                                                  bool response = await Navigator.push(context,
                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                    return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                        ? IntermediaryBillBoardProfilePage(
                                                                            userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                        : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                            ? const BusinessProfilePage()
                                                                            : UserBillBoardProfilePage(
                                                                                userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                  }));
                                                                  if (response) {
                                                                    getBillBoardListData();
                                                                  }
                                                                },
                                                                child: Text(
                                                                  mainVariables.valueMapListProfilePage[index].username.toString().capitalizeFirst!,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .bodyLarge, /*TextStyle(
                                                                      fontSize: text.scale(14),
                                                                      color: const Color(0XFF202020),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontFamily: "Poppins"),*/
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    mainVariables.valueMapListProfilePage[index].createdAt,
                                                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                          fontWeight: FontWeight.w400,
                                                                          color: const Color(0XFF737373),
                                                                        ), /*TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: const Color(0XFF737373),
                                                                        fontWeight: FontWeight.w400,
                                                                        fontFamily: "Poppins"),*/
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Text(
                                                                    " | ",
                                                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                          fontWeight: FontWeight.w400,
                                                                          color: const Color(0XFF737373),
                                                                        ), /*TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: const Color(0XFF737373),
                                                                      fontWeight: FontWeight.w400,
                                                                    ),*/
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      billboardWidgetsMain.believersTabBottomSheet(
                                                                        context: context,
                                                                        id: mainVariables.valueMapListProfilePage[index].userId,
                                                                        isBelieversList: true,
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                      "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                            fontWeight: FontWeight.w400,
                                                                            color: const Color(0XFF737373),
                                                                          ), /*TextStyle(
                                                                          fontSize: text.scale(10),
                                                                          color: const Color(0XFF737373),
                                                                          fontWeight: FontWeight.w400,
                                                                          fontFamily: "Poppins"),*/
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        billboardWidgetsMain.likeButtonHomeListWidget(
                                                          likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                              (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                                          id: mainVariables.valueMapListProfilePage[index].id,
                                                          index: index,
                                                          context: context,
                                                          initFunction: () {},
                                                          modelSetState: modelSetState,
                                                          notUse: true,
                                                          dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                              (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                                          likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                              (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                                          dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                              (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                                          type: mainVariables.valueMapListProfilePage[index].type,
                                                          billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                              ? "news"
                                                              : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                  ? "forums"
                                                                  : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                      ? "survey"
                                                                      : "billboard",
                                                          /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                                          image: mainVariables.valueMapListProfilePage[index].avatar,
                                                          title: mainVariables.valueMapListProfilePage[index].title,
                                                          description: "",
                                                          fromWhere: 'homePage',
                                                          responseId: '',
                                                          controller: bottomSheetController,
                                                          commentId: '',
                                                          postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                          responseUserId: '',
                                                          responseFocusList: mainVariables.responseFocusList,
                                                          valueMapList: mainVariables.valueMapListProfilePage,
                                                        ),
                                                        SizedBox(
                                                          width: width / 41.1,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: height / 64),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                      child: mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                          ? Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  mainVariables.valueMapListProfilePage[index].companyName == ""
                                                                      ? mainVariables.valueMapListProfilePage[index].category.capitalizeFirst!
                                                                      : mainVariables.valueMapListProfilePage[index].companyName.capitalizeFirst!,
                                                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                                        fontWeight: FontWeight.w700,
                                                                        color: const Color(0xFF017FDB),
                                                                      ), /*TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: const Color(0xFF017FDB),
                                                                      fontWeight: FontWeight.bold),*/
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    billboardWidgetsMain.getLikeDislikeUsersList(
                                                                        context: context,
                                                                        billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                        responseId: "",
                                                                        commentId: "",
                                                                        billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                            ? "news"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                                ? "forums"
                                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                    ? "survey"
                                                                                    : "billboard",
                                                                        action: "views",
                                                                        likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                        disLikeCount:
                                                                            mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                        index: 0,
                                                                        viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                        isViewIncluded: true);
                                                                  },
                                                                  child: Text(
                                                                    " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    billboardWidgetsMain.getLikeDislikeUsersList(
                                                                        context: context,
                                                                        billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                        responseId: "",
                                                                        commentId: "",
                                                                        billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                            ? "news"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                                ? "forums"
                                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                    ? "survey"
                                                                                    : "billboard",
                                                                        action: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                            ? "liked"
                                                                            : "likes",
                                                                        likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                        disLikeCount:
                                                                            mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                        index: 1,
                                                                        viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                        isViewIncluded: true);
                                                                  },
                                                                  child: Text(
                                                                    " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    billboardWidgetsMain.getLikeDislikeUsersList(
                                                                        context: context,
                                                                        billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                        responseId: "",
                                                                        commentId: "",
                                                                        billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                            ? "news"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                                ? "forums"
                                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                    ? "survey"
                                                                                    : "billboard",
                                                                        action: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                            ? "disliked"
                                                                            : "dislikes",
                                                                        likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                        disLikeCount:
                                                                            mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                        index: 2,
                                                                        viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                        isViewIncluded: true);
                                                                  },
                                                                  child: Text(
                                                                    " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                                  ),
                                                                ),
                                                                /*InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:mainVariables.valueMapListProfilePage[index].type=="news"
                                                              ?"news":mainVariables.valueMapListProfilePage[index].type=="forums"
                                                              ?"forums": mainVariables.valueMapListProfilePage[index].type=="survey"
                                                              ?"survey":"billboard",
                                                          action:mainVariables.valueMapListProfilePage[index].type=="forums"?"disliked": "dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                              ],
                                                            )
                                                          : Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  mainVariables.valueMapListProfilePage[index].companyName == ""
                                                                      ? mainVariables.valueMapListProfilePage[index].category.capitalizeFirst!
                                                                      : mainVariables.valueMapListProfilePage[index].companyName.capitalizeFirst!,
                                                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                                        fontWeight: FontWeight.w700,
                                                                        color: const Color(0xFF017FDB),
                                                                      ), /*TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: const Color(0xFF017FDB),
                                                                      fontWeight: FontWeight.bold),*/
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    billboardWidgetsMain.getLikeDislikeUsersList(
                                                                        context: context,
                                                                        billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                        responseId: "",
                                                                        commentId: "",
                                                                        billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                            ? "news"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                                ? "forums"
                                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                    ? "survey"
                                                                                    : "billboard",
                                                                        action: "views",
                                                                        likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                        disLikeCount:
                                                                            mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                        index: 0,
                                                                        viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                        isViewIncluded: true);
                                                                  },
                                                                  child: Text(
                                                                    " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () async {
                                                                    billboardWidgetsMain.getLikeDislikeUsersList(
                                                                        context: context,
                                                                        billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                        responseId: "",
                                                                        commentId: "",
                                                                        billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                            ? "news"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                                ? "forums"
                                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                    ? "survey"
                                                                                    : "billboard",
                                                                        action: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                            ? "liked"
                                                                            : "likes",
                                                                        likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                        disLikeCount:
                                                                            mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                        index: 1,
                                                                        viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                        isViewIncluded: true);
                                                                  },
                                                                  child: Text(
                                                                    " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                                  ),
                                                                ),
                                                                /*InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:mainVariables.valueMapListProfilePage[index].type=="news"
                                                              ?"news":mainVariables.valueMapListProfilePage[index].type=="forums"
                                                              ?"forums": mainVariables.valueMapListProfilePage[index].type=="survey"
                                                              ?"survey":"billboard",
                                                          action:mainVariables.valueMapListProfilePage[index].type=="forums"?"disliked": "dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                                InkWell(
                                                                  onTap: () async {
                                                                    switch (mainVariables.valueMapListProfilePage[index].type) {
                                                                      case "blog":
                                                                        {
                                                                          mainVariables.selectedBillboardIdMain.value =
                                                                              mainVariables.valueMapListProfilePage[index].id;
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (BuildContext context) => const BlogDescriptionPage()));
                                                                          break;
                                                                        }
                                                                      case "byte":
                                                                        {
                                                                          mainVariables.selectedBillboardIdMain.value =
                                                                              mainVariables.valueMapListProfilePage[index].id;
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (BuildContext context) => const BytesDescriptionPage()));
                                                                          break;
                                                                        }
                                                                      case "forums":
                                                                        {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                      idList: List.generate(
                                                                                          mainVariables.valueMapListProfilePage.length,
                                                                                          (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                                      comeFrom: "billBoardHome",
                                                                                      forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                                            'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                                          });
                                                                          var responseData = json.decode(response.body);
                                                                          if (responseData["status"]) {
                                                                            activeStatus = responseData["response"]["status"];

                                                                            if (activeStatus == "active") {
                                                                              var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                              var response = await http.post(url, headers: {
                                                                                'Authorization': mainUserToken
                                                                              }, body: {
                                                                                'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                                          mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                              ? Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                  return AnalyticsPage(
                                                                                    surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                    activity: false,
                                                                                    surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                                    navBool: false,
                                                                                    fromWhere: 'similar',
                                                                                  );
                                                                                }))
                                                                              : activeStatus == 'active'
                                                                                  ? answerStatus
                                                                                      ? Navigator.push(context,
                                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                                          return AnalyticsPage(
                                                                                              surveyId:
                                                                                                  mainVariables.valueMapListProfilePage[index].id,
                                                                                              activity: false,
                                                                                              navBool: false,
                                                                                              fromWhere: 'similar',
                                                                                              surveyTitle:
                                                                                                  mainVariables.valueMapListProfilePage[index].title);
                                                                                        }))
                                                                                      : Navigator.push(context,
                                                                                          MaterialPageRoute(builder: (BuildContext context) {
                                                                                          return QuestionnairePage(
                                                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                            defaultIndex: answeredQuestion,
                                                                                          );
                                                                                        }))
                                                                                  : Navigator.push(context,
                                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                                      return AnalyticsPage(
                                                                                        surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                        activity: false,
                                                                                        surveyTitle:
                                                                                            mainVariables.valueMapListProfilePage[index].title,
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
                                                                    " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(10),
                                                                        color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                    ),
                                                    SizedBox(height: height / 42.6),
                                                    mainVariables.valueMapListProfilePage[index].type == 'survey' ||
                                                            mainVariables.valueMapListProfilePage[index].type == 'news'
                                                        ? const SizedBox()
                                                        : Container(
                                                            padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () async {
                                                                    /* bool response = await Navigator.push(context,
                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                      return UserBillBoardProfilePage(
                                                                        userId: userIdMain,
                                                                      );
                                                                    }));*/
                                                                    if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                                        mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                      mainVariables.selectedTickerId.value =
                                                                          mainVariables.valueMapListProfilePage[index].userId;
                                                                    }
                                                                    bool response = await Navigator.push(context,
                                                                        MaterialPageRoute(builder: (BuildContext context) {
                                                                      return mainVariables.valueMapListProfilePage[index].profileType ==
                                                                              "intermediate"
                                                                          ? IntermediaryBillBoardProfilePage(
                                                                              userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                          : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                              ? const BusinessProfilePage()
                                                                              : UserBillBoardProfilePage(
                                                                                  userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                    }));
                                                                    if (response) {
                                                                      getBillBoardListData();
                                                                    }
                                                                  },
                                                                  child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                                ),
                                                                SizedBox(
                                                                  width: width / 41.1,
                                                                ),
                                                                billboardWidgetsMain.getResponseField(
                                                                  context: context,
                                                                  modelSetState: modelSetState,
                                                                  billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                  postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                  responseId: "",
                                                                  index: index,
                                                                  fromWhere: 'homePage',
                                                                  callFunction: () {},
                                                                  contentType: mainVariables.valueMapListProfilePage[index].type,
                                                                  category: mainVariables.valueMapListProfilePage[index].category,
                                                                  responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                      (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : //final //believed, private, status1, believedCategory, NonFiles, nonByte
                                      Container(
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                            BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)
                                          ]),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 100.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      width: width / 1.2,
                                                      child: Text(
                                                        "Exclusive Content: This post is private and only visible to those who believe. Believe ${mainVariables.valueMapListProfilePage[index].username} to unveil the full content.",
                                                        //style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(color: Theme.of(context).colorScheme.background),
                                                        textAlign: TextAlign.center,
                                                      )),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  SizedBox(
                                                    width: width / 3.5,
                                                    child: userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                        ? billboardWidgetsMain.getRepostBelieveButton(
                                                            heightValue: height / 33.76,
                                                            billboardUserid: mainVariables.valueMapListProfilePage[index].repostUser,
                                                            billboardUserName: mainVariables.valueMapListProfilePage[index].repostUserName,
                                                            context: context,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            background: true,
                                                          )
                                                        : const SizedBox(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                  : //exclusive //notBelieved, private, status1, believedCategory, NonFiles, nonByte
                                  Container(
                                      padding: const EdgeInsets.all(1.5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)]),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              switch (mainVariables.valueMapListProfilePage[index].type) {
                                                case "blog":
                                                  {
                                                    mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                    Navigator.push(
                                                        context, MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                    break;
                                                  }
                                                case "byte":
                                                  {
                                                    mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                                    Navigator.push(
                                                        context, MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                    break;
                                                  }
                                                case "forums":
                                                  {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                    (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                comeFrom: "billBoardHome",
                                                                forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                      'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                    });
                                                    var responseData = json.decode(response.body);
                                                    if (responseData["status"]) {
                                                      activeStatus = responseData["response"]["status"];

                                                      if (activeStatus == "active") {
                                                        var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                        var response = await http.post(url, headers: {
                                                          'Authorization': mainUserToken
                                                        }, body: {
                                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                    mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                              activity: false,
                                                              surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                              navBool: false,
                                                              fromWhere: 'similar',
                                                            );
                                                          }))
                                                        : activeStatus == 'active'
                                                            ? answerStatus
                                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return AnalyticsPage(
                                                                        surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                        activity: false,
                                                                        navBool: false,
                                                                        fromWhere: 'similar',
                                                                        surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                  }))
                                                                : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                    return QuestionnairePage(
                                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                      defaultIndex: answeredQuestion,
                                                                    );
                                                                  }))
                                                            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return AnalyticsPage(
                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                  activity: false,
                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                        id: mainVariables.valueMapListProfilePage[index].id,
                                                        type: 'news',
                                                        activity: true,
                                                        checkMain: false,
                                                      );
                                                    }));*/
                                                    Get.to(const DemoView(), arguments: {
                                                      "id": mainVariables.valueMapListProfilePage[index].id,
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
                                                  height: height / 3.97,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                      gradient: mainVariables.valueMapListProfilePage[index].type == "blog"
                                                          ? const RadialGradient(
                                                              colors: [Color.fromRGBO(23, 25, 27, 0.90), Color.fromRGBO(85, 85, 85, 0.00)],
                                                              radius: 15.0,
                                                            )
                                                          : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                              ? const RadialGradient(
                                                                  colors: [Color.fromRGBO(0, 92, 175, 0.90), Color.fromRGBO(13, 155, 1, 0.00)],
                                                                  radius: 15.0,
                                                                )
                                                              : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                  ? const RadialGradient(
                                                                      colors: [Color.fromRGBO(10, 122, 1, 0.90), Color.fromRGBO(13, 155, 1, 0.00)],
                                                                      radius: 15.0,
                                                                    )
                                                                  : const RadialGradient(
                                                                      colors: [Color.fromRGBO(255, 255, 255, 1), Color.fromRGBO(255, 255, 255, 1)],
                                                                      radius: 15.0,
                                                                    ),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                            mainVariables.valueMapListProfilePage[index].type == "news"
                                                                ? mainVariables.valueMapListProfilePage[index].newsImage
                                                                : "",
                                                          ),
                                                          fit: BoxFit.fill)),
                                                  child: Center(
                                                    child: Text(
                                                      mainVariables.valueMapListProfilePage[index].type == "news"
                                                          ? ""
                                                          : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                              ? mainVariables.valueMapListProfilePage[index].type
                                                                  .toString()
                                                                  .capitalizeFirst!
                                                                  .substring(0, mainVariables.valueMapListProfilePage[index].type.length - 1)
                                                              : mainVariables.valueMapListProfilePage[index].type.toString().capitalizeFirst!,
                                                      style: TextStyle(
                                                          fontSize: text.scale(40), fontWeight: FontWeight.w900, color: const Color(0XFFFFFFFF)),
                                                    ),
                                                  ),
                                                ),
                                                mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                        mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                                    ? const SizedBox()
                                                    : Positioned(
                                                        top: height / 15,
                                                        right: 15,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            billboardWidgetsMain.believedTabBottomSheet(
                                                                context: context,
                                                                id: mainVariables.valueMapListProfilePage[index].repostId,
                                                                type: mainVariables.valueMapListProfilePage[index].type);
                                                          },
                                                          child: Stack(
                                                            children: [
                                                              const SizedBox(
                                                                height: 35,
                                                                width: 35,
                                                              ),
                                                              Positioned(
                                                                left: 0,
                                                                bottom: 0,
                                                                child: Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(5),
                                                                      image: const DecorationImage(
                                                                        image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                                      )),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                top: 0,
                                                                right: 0,
                                                                child: Container(
                                                                  height: 15,
                                                                  width: 15,
                                                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                                  child: Center(
                                                                      child: Text(
                                                                    mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                        ? "9+"
                                                                        : mainVariables.valueMapListProfilePage[index].repostCount.toString(),
                                                                    style: const TextStyle(color: Colors.white, fontSize: 10),
                                                                  )),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                    height: height / 18,
                                                    width: width / 1.06,
                                                    padding: EdgeInsets.only(
                                                      left: width / 27.4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black12.withOpacity(0.3),
                                                      borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(15),
                                                        topRight: Radius.circular(15),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) => mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3,
                                                            color: Colors.white,
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type: mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false
                                                        ),*/
                                                            billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            billboardWidgetsMain.translationWidget(
                                                                id: mainVariables.valueMapListProfilePage[index].id,
                                                                type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                    ? "forums"
                                                                    : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                        ? "survey"
                                                                        : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                            ? "news"
                                                                            : 'billboard',
                                                                index: index,
                                                                initFunction: getData,
                                                                context: context,
                                                                modelSetState: modelSetState,
                                                                notUse: false,
                                                                valueMapList: mainVariables.valueMapListProfilePage),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                                ? billboardWidgetsMain.getHomeBelieveButton(
                                                                    heightValue: height / 33.76,
                                                                    isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                        (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                                    billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                                    billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                                    context: context,
                                                                    modelSetState: modelSetState,
                                                                    index: index,
                                                                    background: true,
                                                                  )
                                                                : const SizedBox(),

                                                            ///more_vert
                                                            IconButton(
                                                                onPressed: () {
                                                                  billboardWidgetsMain.bottomSheet(
                                                                    context1: context,
                                                                    myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                                    billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                                    billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                                    type: "billboard",
                                                                    responseId: "",
                                                                    responseUserId: "",
                                                                    commentId: "",
                                                                    commentUserId: "",
                                                                    callFunction: getData,
                                                                    contentType: mainVariables.valueMapListProfilePage[index].type,
                                                                    modelSetState: modelSetState,
                                                                    responseDetail: {},
                                                                    category: mainVariables.valueMapListProfilePage[index].category,
                                                                    valueMapList: mainVariables.valueMapListProfilePage,
                                                                    index: index,
                                                                  );
                                                                },
                                                                icon: const Icon(
                                                                  Icons.more_vert,
                                                                  color: Colors.white,
                                                                  size: 25,
                                                                ))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  child: Container(
                                                    height: height / 14,
                                                    width: width,
                                                    padding: EdgeInsets.only(
                                                        top: height / 86.6, bottom: height / 86.6, right: width / 13.7, left: width / 41.1),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black12.withOpacity(0.3),
                                                    ),
                                                    child: RichText(
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: conversationFunctionsMain.spanListBillBoardHome(
                                                            message: mainVariables.valueMapListProfilePage[index].title.length > 100
                                                                ? mainVariables.valueMapListProfilePage[index].title.substring(0, 100)
                                                                : mainVariables.valueMapListProfilePage[index].title,
                                                            context: context,
                                                            isByte: false),
                                                      ),
                                                    ) /*Text(
                                                         mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                         maxLines: 2,
                                                         style: TextStyle(
                                                             fontSize: _text*14,
                                                             color: Colors.white,
                                                             fontWeight: FontWeight.w500,
                                                             fontFamily: "Poppins",
                                                             overflow: TextOverflow.ellipsis
                                                         ),
                                                       )*/
                                                    ,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.background,
                                              borderRadius:
                                                  const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: height / 86.6,
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
                                                      heightValue: height / 17.32,
                                                      widthValue: width / 8.22,
                                                      myself: false,
                                                      avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                                      isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                                      userId: mainVariables.valueMapListProfilePage[index].userId,
                                                      repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                                      repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                                      isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                                      getBillBoardListData: getBillBoardListData,
                                                    ),
                                                    SizedBox(
                                                      width: width / 41.1,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                                id:valueMapList[index].userId,
                                                                type:'forums',
                                                                index:0
                                                            );
                                                          }));*/
                                                              /*bool response =
                                                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return UserBillBoardProfilePage(
                                                                    userId: mainVariables.valueMapListProfilePage[index].userId);
                                                              }));*/
                                                              if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                                  mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                mainVariables.selectedTickerId.value =
                                                                    mainVariables.valueMapListProfilePage[index].userId;
                                                              }
                                                              bool response =
                                                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                    ? IntermediaryBillBoardProfilePage(
                                                                        userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                    : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                        ? const BusinessProfilePage()
                                                                        : UserBillBoardProfilePage(
                                                                            userId: mainVariables.valueMapListProfilePage[index].userId);
                                                              }));
                                                              if (response) {
                                                                getBillBoardListData();
                                                              }
                                                            },
                                                            child: Text(
                                                              mainVariables.valueMapListProfilePage[index].username.toString().capitalizeFirst!,
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge, /* TextStyle(
                                                                  fontSize: text.scale(14),
                                                                  color: const Color(0XFF202020),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontFamily: "Poppins")*/
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                mainVariables.valueMapListProfilePage[index].createdAt,
                                                                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                      fontWeight: FontWeight.w400,
                                                                      color: const Color(0XFF737373),
                                                                    ), /*TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0XFF737373),
                                                                    fontWeight: FontWeight.w400,
                                                                    fontFamily: "Poppins"),*/
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              Text(
                                                                " | ",
                                                                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                      fontWeight: FontWeight.w400,
                                                                      color: const Color(0XFF737373),
                                                                    ), /*TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: const Color(0XFF737373),
                                                                  fontWeight: FontWeight.w400,
                                                                ),*/
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              ),
                                                              InkWell(
                                                                onTap: () async {
                                                                  billboardWidgetsMain.believersTabBottomSheet(
                                                                    context: context,
                                                                    id: mainVariables.valueMapListProfilePage[index].userId,
                                                                    isBelieversList: true,
                                                                  );
                                                                },
                                                                child: Text(
                                                                  "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                        fontWeight: FontWeight.w400,
                                                                        color: const Color(0XFF737373),
                                                                      ), /*TextStyle(
                                                                      fontSize: text.scale(10),
                                                                      color: const Color(0XFF737373),
                                                                      fontWeight: FontWeight.w400,
                                                                      fontFamily: "Poppins"),*/
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    billboardWidgetsMain.likeButtonHomeListWidget(
                                                      likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                          (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                                      id: mainVariables.valueMapListProfilePage[index].id,
                                                      index: index,
                                                      context: context,
                                                      initFunction: () {},
                                                      modelSetState: modelSetState,
                                                      notUse: true,
                                                      dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                          (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                                      likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                          (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                                      dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                          (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                                      type: mainVariables.valueMapListProfilePage[index].type,
                                                      billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                          ? "news"
                                                          : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                              ? "forums"
                                                              : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                  ? "survey"
                                                                  : "billboard",
                                                      /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                                      image: mainVariables.valueMapListProfilePage[index].avatar,
                                                      title: mainVariables.valueMapListProfilePage[index].title,
                                                      description: "",
                                                      fromWhere: 'homePage',
                                                      responseId: '',
                                                      controller: bottomSheetController,
                                                      commentId: '',
                                                      postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                      responseUserId: '',
                                                      responseFocusList: mainVariables.responseFocusList,
                                                      valueMapList: mainVariables.valueMapListProfilePage,
                                                    ),
                                                    SizedBox(
                                                      width: width / 41.1,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: height / 64),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                  child: mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                      ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              mainVariables.valueMapListProfilePage[index].companyName == ""
                                                                  ? mainVariables.valueMapListProfilePage[index].category.capitalizeFirst!
                                                                  : mainVariables.valueMapListProfilePage[index].companyName.capitalizeFirst!,
                                                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                                    fontWeight: FontWeight.w700,
                                                                    color: const Color(0xFF017FDB),
                                                                  ),
                                                              /*TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: const Color(0xFF017FDB),
                                                                  fontWeight: FontWeight.bold),*/
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                billboardWidgetsMain.getLikeDislikeUsersList(
                                                                    context: context,
                                                                    billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                    responseId: "",
                                                                    commentId: "",
                                                                    billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                        ? "news"
                                                                        : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                            ? "forums"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                ? "survey"
                                                                                : "billboard",
                                                                    action: "views",
                                                                    likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                    disLikeCount:
                                                                        mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                    index: 0,
                                                                    viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                    isViewIncluded: true);
                                                              },
                                                              child: Text(
                                                                " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                                style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                billboardWidgetsMain.getLikeDislikeUsersList(
                                                                    context: context,
                                                                    billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                    responseId: "",
                                                                    commentId: "",
                                                                    billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                        ? "news"
                                                                        : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                            ? "forums"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                ? "survey"
                                                                                : "billboard",
                                                                    action: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                        ? "liked"
                                                                        : "likes",
                                                                    likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                    disLikeCount:
                                                                        mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                    index: 1,
                                                                    viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                    isViewIncluded: true);
                                                              },
                                                              child: Text(
                                                                " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                                style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                billboardWidgetsMain.getLikeDislikeUsersList(
                                                                    context: context,
                                                                    billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                    responseId: "",
                                                                    commentId: "",
                                                                    billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                        ? "news"
                                                                        : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                            ? "forums"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                ? "survey"
                                                                                : "billboard",
                                                                    action: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                        ? "disliked"
                                                                        : "dislikes",
                                                                    likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                    disLikeCount:
                                                                        mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                    index: 2,
                                                                    viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                    isViewIncluded: true);
                                                              },
                                                              child: Text(
                                                                " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                                style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                              ),
                                                            ),
                                                            /*InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:mainVariables.valueMapListProfilePage[index].type=="news"
                                                              ?"news":mainVariables.valueMapListProfilePage[index].type=="forums"
                                                              ?"forums": mainVariables.valueMapListProfilePage[index].type=="survey"
                                                              ?"survey":"billboard",
                                                          action:mainVariables.valueMapListProfilePage[index].type=="forums"?"disliked": "dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              mainVariables.valueMapListProfilePage[index].companyName == ""
                                                                  ? mainVariables.valueMapListProfilePage[index].category.capitalizeFirst!
                                                                  : mainVariables.valueMapListProfilePage[index].companyName.capitalizeFirst!,
                                                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                                    fontWeight: FontWeight.w700,
                                                                    color: const Color(0xFF017FDB),
                                                                  ),
                                                              /*TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: const Color(0xFF017FDB),
                                                                  fontWeight: FontWeight.bold),*/
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                billboardWidgetsMain.getLikeDislikeUsersList(
                                                                    context: context,
                                                                    billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                    responseId: "",
                                                                    commentId: "",
                                                                    billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                        ? "news"
                                                                        : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                            ? "forums"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                ? "survey"
                                                                                : "billboard",
                                                                    action: "views",
                                                                    likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                    disLikeCount:
                                                                        mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                    index: 0,
                                                                    viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                    isViewIncluded: true);
                                                              },
                                                              child: Text(
                                                                " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                                style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                billboardWidgetsMain.getLikeDislikeUsersList(
                                                                    context: context,
                                                                    billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                                    responseId: "",
                                                                    commentId: "",
                                                                    billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                        ? "news"
                                                                        : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                            ? "forums"
                                                                            : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                                ? "survey"
                                                                                : "billboard",
                                                                    action: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                        ? "liked"
                                                                        : "likes",
                                                                    likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                                    disLikeCount:
                                                                        mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                                    index: 1,
                                                                    viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                                    isViewIncluded: true);
                                                              },
                                                              child: Text(
                                                                " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                                style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                              ),
                                                            ),
                                                            /*InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:mainVariables.valueMapListProfilePage[index].type=="news"
                                                              ?"news":mainVariables.valueMapListProfilePage[index].type=="forums"
                                                              ?"forums": mainVariables.valueMapListProfilePage[index].type=="survey"
                                                              ?"survey":"billboard",
                                                          action:mainVariables.valueMapListProfilePage[index].type=="forums"?"disliked": "dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                            InkWell(
                                                              onTap: () async {
                                                                switch (mainVariables.valueMapListProfilePage[index].type) {
                                                                  case "blog":
                                                                    {
                                                                      mainVariables.selectedBillboardIdMain.value =
                                                                          mainVariables.valueMapListProfilePage[index].id;
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (BuildContext context) => const BlogDescriptionPage()));
                                                                      break;
                                                                    }
                                                                  case "byte":
                                                                    {
                                                                      mainVariables.selectedBillboardIdMain.value =
                                                                          mainVariables.valueMapListProfilePage[index].id;
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (BuildContext context) => const BytesDescriptionPage()));
                                                                      break;
                                                                    }
                                                                  case "forums":
                                                                    {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                                  idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                                      (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                                  comeFrom: "billBoardHome",
                                                                                  forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                                        'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                                      });
                                                                      var responseData = json.decode(response.body);
                                                                      if (responseData["status"]) {
                                                                        activeStatus = responseData["response"]["status"];

                                                                        if (activeStatus == "active") {
                                                                          var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                          var response = await http.post(url, headers: {
                                                                            'Authorization': mainUserToken
                                                                          }, body: {
                                                                            'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                                      mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                          ? Navigator.push(context,
                                                                              MaterialPageRoute(builder: (BuildContext context) {
                                                                              return AnalyticsPage(
                                                                                surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                activity: false,
                                                                                surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                                navBool: false,
                                                                                fromWhere: 'similar',
                                                                              );
                                                                            }))
                                                                          : activeStatus == 'active'
                                                                              ? answerStatus
                                                                                  ? Navigator.push(context,
                                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                                      return AnalyticsPage(
                                                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                          activity: false,
                                                                                          navBool: false,
                                                                                          fromWhere: 'similar',
                                                                                          surveyTitle:
                                                                                              mainVariables.valueMapListProfilePage[index].title);
                                                                                    }))
                                                                                  : Navigator.push(context,
                                                                                      MaterialPageRoute(builder: (BuildContext context) {
                                                                                      return QuestionnairePage(
                                                                                        surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                        defaultIndex: answeredQuestion,
                                                                                      );
                                                                                    }))
                                                                              : Navigator.push(context,
                                                                                  MaterialPageRoute(builder: (BuildContext context) {
                                                                                  return AnalyticsPage(
                                                                                    surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                    activity: false,
                                                                                    surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                                " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                                style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                                SizedBox(height: height / 42.6),
                                                mainVariables.valueMapListProfilePage[index].type == 'survey' ||
                                                        mainVariables.valueMapListProfilePage[index].type == 'news'
                                                    ? const SizedBox()
                                                    : Container(
                                                        padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                /*bool response =
                                                                    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return UserBillBoardProfilePage(
                                                                    userId: userIdMain,
                                                                  );
                                                                }));*/
                                                                if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                                    mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                                  mainVariables.selectedTickerId.value =
                                                                      mainVariables.valueMapListProfilePage[index].userId;
                                                                }
                                                                bool response =
                                                                    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                                      ? IntermediaryBillBoardProfilePage(
                                                                          userId: mainVariables.valueMapListProfilePage[index].userId)
                                                                      : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                          ? const BusinessProfilePage()
                                                                          : UserBillBoardProfilePage(
                                                                              userId: mainVariables.valueMapListProfilePage[index].userId);
                                                                }));
                                                                if (response) {
                                                                  getBillBoardListData();
                                                                }
                                                              },
                                                              child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                            ),
                                                            SizedBox(
                                                              width: width / 41.1,
                                                            ),
                                                            billboardWidgetsMain.getResponseField(
                                                              context: context,
                                                              modelSetState: modelSetState,
                                                              billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                              postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                              responseId: "",
                                                              index: index,
                                                              fromWhere: 'homePage',
                                                              callFunction: () {},
                                                              contentType: mainVariables.valueMapListProfilePage[index].type,
                                                              category: mainVariables.valueMapListProfilePage[index].category,
                                                              responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                  (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                              : //final  //public, status1, believedCategory, NonFiles, nonByte
                              Container(
                                  padding: const EdgeInsets.all(1.5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                      boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0)]),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: width / 1.2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "lib/Constants/Assets/BillBoard/failImage.png",
                                                    scale: 2,
                                                  ),
                                                  Text(
                                                    "whoops!",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(fontStyle: FontStyle.italic, color: Theme.of(context).colorScheme.background),
                                                    /*TextStyle(
                                                        fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic),*/
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              )),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                              width: width / 1.2,
                                              child: Text(
                                                "Content might be deleted or no longer active to display",
                                                style:
                                                    Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.background),
                                                //TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                                textAlign: TextAlign.center,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          : //final  // status0, believedCategory, NonFiles, nonByte
                          Container(
                              padding: const EdgeInsets.all(1.5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
                                BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0),
                              ]),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      switch (mainVariables.valueMapListProfilePage[index].type) {
                                        case "blog":
                                          {
                                            mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                            break;
                                          }
                                        case "byte":
                                          {
                                            mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                            break;
                                          }
                                        case "forums":
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) => ForumPostDescriptionPage(
                                                        idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                            (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                        comeFrom: "billBoardHome",
                                                        forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                            });
                                            var responseData = json.decode(response.body);
                                            if (responseData["status"]) {
                                              activeStatus = responseData["response"]["status"];

                                              if (activeStatus == "active") {
                                                var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                var response = await http.post(url, headers: {
                                                  'Authorization': mainUserToken
                                                }, body: {
                                                  'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                            mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return AnalyticsPage(
                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                      activity: false,
                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                      navBool: false,
                                                      fromWhere: 'similar',
                                                    );
                                                  }))
                                                : activeStatus == 'active'
                                                    ? answerStatus
                                                        ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return AnalyticsPage(
                                                                surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                activity: false,
                                                                navBool: false,
                                                                fromWhere: 'similar',
                                                                surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                          }))
                                                        : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                            return QuestionnairePage(
                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                              defaultIndex: answeredQuestion,
                                                            );
                                                          }))
                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                          activity: false,
                                                          surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                id: mainVariables.valueMapListProfilePage[index].id,
                                                type: 'news',
                                                activity: true,
                                                checkMain: false,
                                              );
                                            }));*/
                                            Get.to(const DemoView(),
                                                arguments: {"id": mainVariables.valueMapListProfilePage[index].id, "type": "news", "url": ""});
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
                                          height: height / 3.97,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                              gradient: mainVariables.valueMapListProfilePage[index].type == "blog"
                                                  ? const RadialGradient(
                                                      colors: [Color.fromRGBO(23, 25, 27, 0.90), Color.fromRGBO(85, 85, 85, 0.00)],
                                                      radius: 15.0,
                                                    )
                                                  : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                      ? const RadialGradient(
                                                          colors: [Color.fromRGBO(0, 92, 175, 0.90), Color.fromRGBO(13, 155, 1, 0.00)],
                                                          radius: 15.0,
                                                        )
                                                      : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                          ? const RadialGradient(
                                                              colors: [Color.fromRGBO(10, 122, 1, 0.90), Color.fromRGBO(13, 155, 1, 0.00)],
                                                              radius: 15.0,
                                                            )
                                                          : const RadialGradient(
                                                              colors: [Color.fromRGBO(255, 255, 255, 1), Color.fromRGBO(255, 255, 255, 1)],
                                                              radius: 15.0,
                                                            ),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    mainVariables.valueMapListProfilePage[index].type == "news"
                                                        ? mainVariables.valueMapListProfilePage[index].newsImage
                                                        : "",
                                                  ),
                                                  fit: BoxFit.fill)),
                                          child: Center(
                                            child: Text(
                                              mainVariables.valueMapListProfilePage[index].type == "news"
                                                  ? ""
                                                  : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                      ? mainVariables.valueMapListProfilePage[index].type
                                                          .toString()
                                                          .capitalizeFirst!
                                                          .substring(0, mainVariables.valueMapListProfilePage[index].type.length - 1)
                                                      : mainVariables.valueMapListProfilePage[index].type.toString().capitalizeFirst!,
                                              style: TextStyle(fontSize: text.scale(40), fontWeight: FontWeight.w900, color: const Color(0XFFFFFFFF)),
                                            ),
                                          ),
                                        ),
                                        mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                                mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                            ? const SizedBox()
                                            : Positioned(
                                                top: height / 15,
                                                right: 15,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    billboardWidgetsMain.believedTabBottomSheet(
                                                        context: context,
                                                        id: mainVariables.valueMapListProfilePage[index].repostId,
                                                        type: mainVariables.valueMapListProfilePage[index].type);
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      const SizedBox(
                                                        height: 35,
                                                        width: 35,
                                                      ),
                                                      Positioned(
                                                        left: 0,
                                                        bottom: 0,
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              image: const DecorationImage(
                                                                image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                              )),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          height: 15,
                                                          width: 15,
                                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                          child: Center(
                                                              child: Text(
                                                            mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                                ? "9+"
                                                                : mainVariables.valueMapListProfilePage[index].repostCount.toString(),
                                                            style: const TextStyle(color: Colors.white, fontSize: 10),
                                                          )),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            height: height / 18,
                                            width: width / 1.06,
                                            padding: EdgeInsets.only(
                                              left: width / 27.4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black12.withOpacity(0.3),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) => mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3,
                                                            color: Colors.white,
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type: mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false
                                                        ),*/
                                                    billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    billboardWidgetsMain.translationWidget(
                                                        id: mainVariables.valueMapListProfilePage[index].id,
                                                        type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                            ? "forums"
                                                            : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                ? "survey"
                                                                : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                    ? "news"
                                                                    : 'billboard',
                                                        index: index,
                                                        initFunction: getData,
                                                        context: context,
                                                        modelSetState: modelSetState,
                                                        notUse: false,
                                                        valueMapList: mainVariables.valueMapListProfilePage),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                        ? billboardWidgetsMain.getHomeBelieveButton(
                                                            heightValue: height / 33.76,
                                                            isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                            billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                            billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                            context: context,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            background: true,
                                                          )
                                                        : const SizedBox(),

                                                    ///more_vert
                                                    IconButton(
                                                        onPressed: () {
                                                          billboardWidgetsMain.bottomSheet(
                                                            context1: context,
                                                            myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                            billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                            billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                            type: "billboard",
                                                            responseId: "",
                                                            responseUserId: "",
                                                            commentId: "",
                                                            commentUserId: "",
                                                            callFunction: getData,
                                                            contentType: mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            responseDetail: {},
                                                            category: mainVariables.valueMapListProfilePage[index].category,
                                                            valueMapList: mainVariables.valueMapListProfilePage,
                                                            index: index,
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.more_vert,
                                                          color: Colors.white,
                                                          size: 25,
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          child: Container(
                                            height: height / 14,
                                            width: width,
                                            padding:
                                                EdgeInsets.only(top: height / 86.6, bottom: height / 86.6, right: width / 13.7, left: width / 41.1),
                                            decoration: BoxDecoration(
                                              color: Colors.black12.withOpacity(0.3),
                                            ),
                                            child: RichText(
                                              textAlign: TextAlign.left,
                                              text: TextSpan(
                                                children: conversationFunctionsMain.spanListBillBoardHome(
                                                    message: mainVariables.valueMapListProfilePage[index].title.length > 100
                                                        ? mainVariables.valueMapListProfilePage[index].title.substring(0, 100)
                                                        : mainVariables.valueMapListProfilePage[index].title,
                                                    context: context,
                                                    isByte: false),
                                              ),
                                            ) /*Text(
                                                         mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                         maxLines: 2,
                                                         style: TextStyle(
                                                             fontSize: _text*14,
                                                             color: Colors.white,
                                                             fontWeight: FontWeight.w500,
                                                             fontFamily: "Poppins",
                                                             overflow: TextOverflow.ellipsis
                                                         ),
                                                       )*/
                                            ,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.background,
                                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height / 86.6,
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
                                              heightValue: height / 17.32,
                                              widthValue: width / 8.22,
                                              myself: false,
                                              avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                              isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                              userId: mainVariables.valueMapListProfilePage[index].userId,
                                              repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                              repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                              isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                              getBillBoardListData: getBillBoardListData,
                                            ),
                                            SizedBox(
                                              width: width / 41.1,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                                id:valueMapList[index].userId,
                                                                type:'forums',
                                                                index:0
                                                            );
                                                          }));*/
                                                      /* bool response =
                                                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return UserBillBoardProfilePage(userId: mainVariables.valueMapListProfilePage[index].userId);
                                                      }));*/
                                                      if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                          mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                        mainVariables.selectedTickerId.value = mainVariables.valueMapListProfilePage[index].userId;
                                                      }
                                                      bool response =
                                                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                            ? IntermediaryBillBoardProfilePage(
                                                                userId: mainVariables.valueMapListProfilePage[index].userId)
                                                            : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                ? const BusinessProfilePage()
                                                                : UserBillBoardProfilePage(
                                                                    userId: mainVariables.valueMapListProfilePage[index].userId);
                                                      }));
                                                      if (response) {
                                                        getBillBoardListData();
                                                      }
                                                    },
                                                    child: Text(
                                                      mainVariables.valueMapListProfilePage[index].username.toString().capitalizeFirst!,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge, /*TextStyle(
                                                          fontSize: text.scale(14),
                                                          color: const Color(0XFF202020),
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: "Poppins"),*/
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        mainVariables.valueMapListProfilePage[index].createdAt,
                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                              fontWeight: FontWeight.w400,
                                                              color: const Color(0XFF737373),
                                                            ), /*TextStyle(
                                                            fontSize: text.scale(10),
                                                            color: const Color(0XFF737373),
                                                            fontWeight: FontWeight.w400,
                                                            fontFamily: "Poppins"),*/
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        " | ",
                                                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                              fontWeight: FontWeight.w400,
                                                              color: const Color(0XFF737373),
                                                            ), /*TextStyle(
                                                          fontSize: text.scale(10),
                                                          color: const Color(0XFF737373),
                                                          fontWeight: FontWeight.w400,
                                                        ),*/
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          billboardWidgetsMain.believersTabBottomSheet(
                                                            context: context,
                                                            id: mainVariables.valueMapListProfilePage[index].userId,
                                                            isBelieversList: true,
                                                          );
                                                        },
                                                        child: Text(
                                                          "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                                fontWeight: FontWeight.w400,
                                                                color: const Color(0XFF737373),
                                                              ), /*TextStyle(
                                                              fontSize: text.scale(10),
                                                              color: const Color(0XFF737373),
                                                              fontWeight: FontWeight.w400,
                                                              fontFamily: "Poppins"),*/
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            billboardWidgetsMain.likeButtonHomeListWidget(
                                              likeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                  (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                              id: mainVariables.valueMapListProfilePage[index].id,
                                              index: index,
                                              context: context,
                                              initFunction: () {},
                                              modelSetState: modelSetState,
                                              notUse: true,
                                              dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                  (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                              likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                  (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                              dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                  (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                              type: mainVariables.valueMapListProfilePage[index].type,
                                              billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                  ? "news"
                                                  : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                      ? "forums"
                                                      : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                          ? "survey"
                                                          : "billboard",
                                              /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                              image: mainVariables.valueMapListProfilePage[index].avatar,
                                              title: mainVariables.valueMapListProfilePage[index].title,
                                              description: "",
                                              fromWhere: 'homePage',
                                              responseId: '',
                                              controller: bottomSheetController,
                                              commentId: '',
                                              postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                              responseUserId: '',
                                              responseFocusList: mainVariables.responseFocusList,
                                              valueMapList: mainVariables.valueMapListProfilePage,
                                            ),
                                            SizedBox(
                                              width: width / 41.1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: height / 64),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                          child: mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      mainVariables.valueMapListProfilePage[index].companyName == ""
                                                          ? mainVariables.valueMapListProfilePage[index].category.capitalizeFirst!
                                                          : mainVariables.valueMapListProfilePage[index].companyName.capitalizeFirst!,
                                                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                            fontWeight: FontWeight.w700,
                                                            color: const Color(0xFF017FDB),
                                                          ), /*TextStyle(
                                                          fontSize: text.scale(10), color: const Color(0xFF017FDB), fontWeight: FontWeight.bold),*/
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        billboardWidgetsMain.getLikeDislikeUsersList(
                                                            context: context,
                                                            billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                            responseId: "",
                                                            commentId: "",
                                                            billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                ? "news"
                                                                : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                    ? "forums"
                                                                    : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                        ? "survey"
                                                                        : "billboard",
                                                            action: "views",
                                                            likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                            disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                            index: 0,
                                                            viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                            isViewIncluded: true);
                                                      },
                                                      child: Text(
                                                        " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                        style: TextStyle(
                                                            fontSize: text.scale(10),
                                                            color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        billboardWidgetsMain.getLikeDislikeUsersList(
                                                            context: context,
                                                            billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                            responseId: "",
                                                            commentId: "",
                                                            billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                ? "news"
                                                                : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                    ? "forums"
                                                                    : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                        ? "survey"
                                                                        : "billboard",
                                                            action: mainVariables.valueMapListProfilePage[index].type == "forums" ? "liked" : "likes",
                                                            likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                            disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                            index: 1,
                                                            viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                            isViewIncluded: true);
                                                      },
                                                      child: Text(
                                                        " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                        style: TextStyle(
                                                            fontSize: text.scale(10),
                                                            color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        billboardWidgetsMain.getLikeDislikeUsersList(
                                                            context: context,
                                                            billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                            responseId: "",
                                                            commentId: "",
                                                            billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                ? "news"
                                                                : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                    ? "forums"
                                                                    : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                        ? "survey"
                                                                        : "billboard",
                                                            action: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                ? "disliked"
                                                                : "dislikes",
                                                            likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                            disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                            index: 2,
                                                            viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                            isViewIncluded: true);
                                                      },
                                                      child: Text(
                                                        " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                        style: TextStyle(
                                                            fontSize: text.scale(10),
                                                            color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                      ),
                                                    ),
                                                    /*InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:mainVariables.valueMapListProfilePage[index].type=="news"
                                                              ?"news":mainVariables.valueMapListProfilePage[index].type=="forums"
                                                              ?"forums": mainVariables.valueMapListProfilePage[index].type=="survey"
                                                              ?"survey":"billboard",
                                                          action:mainVariables.valueMapListProfilePage[index].type=="forums"?"disliked": "dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      mainVariables.valueMapListProfilePage[index].companyName == ""
                                                          ? mainVariables.valueMapListProfilePage[index].category.capitalizeFirst!
                                                          : mainVariables.valueMapListProfilePage[index].companyName.capitalizeFirst!,
                                                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                            fontWeight: FontWeight.w700,
                                                            color: const Color(0xFF017FDB),
                                                          ), /*TextStyle(
                                                          fontSize: text.scale(10), color: const Color(0xFF017FDB), fontWeight: FontWeight.bold),*/
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        billboardWidgetsMain.getLikeDislikeUsersList(
                                                            context: context,
                                                            billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                            responseId: "",
                                                            commentId: "",
                                                            billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                ? "news"
                                                                : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                    ? "forums"
                                                                    : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                        ? "survey"
                                                                        : "billboard",
                                                            action: "views",
                                                            likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                            disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                            index: 0,
                                                            viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                            isViewIncluded: true);
                                                      },
                                                      child: Text(
                                                        " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                        style: TextStyle(
                                                            fontSize: text.scale(10),
                                                            color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        billboardWidgetsMain.getLikeDislikeUsersList(
                                                            context: context,
                                                            billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                            responseId: "",
                                                            commentId: "",
                                                            billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                                ? "news"
                                                                : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                    ? "forums"
                                                                    : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                        ? "survey"
                                                                        : "billboard",
                                                            action: mainVariables.valueMapListProfilePage[index].type == "forums" ? "liked" : "likes",
                                                            likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                            disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                            index: 1,
                                                            viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                            isViewIncluded: true);
                                                      },
                                                      child: Text(
                                                        " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                        style: TextStyle(
                                                            fontSize: text.scale(10),
                                                            color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                      ),
                                                    ),
                                                    /*InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.getLikeDislikeUsersList(
                                                          context: context,
                                                          billBoardId:mainVariables.valueMapListProfilePage[index].id,
                                                          responseId:"",
                                                          commentId:"",
                                                          billBoardType:mainVariables.valueMapListProfilePage[index].type=="news"
                                                              ?"news":mainVariables.valueMapListProfilePage[index].type=="forums"
                                                              ?"forums": mainVariables.valueMapListProfilePage[index].type=="survey"
                                                              ?"survey":"billboard",
                                                          action:mainVariables.valueMapListProfilePage[index].type=="forums"?"disliked": "dislikes",
                                                          likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                          disLikeCount:mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                          index: 2,
                                                          viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                          isViewIncluded: true
                                                      );
                                                    },
                                                    child: Text(
                                                      " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                      style: TextStyle(
                                                          fontSize: _text.scale(10),
                                                          color: Colors.black54),
                                                    ),
                                                  ),*/
                                                    InkWell(
                                                      onTap: () async {
                                                        switch (mainVariables.valueMapListProfilePage[index].type) {
                                                          case "blog":
                                                            {
                                                              mainVariables.selectedBillboardIdMain.value =
                                                                  mainVariables.valueMapListProfilePage[index].id;
                                                              Navigator.push(context,
                                                                  MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                              break;
                                                            }
                                                          case "byte":
                                                            {
                                                              mainVariables.selectedBillboardIdMain.value =
                                                                  mainVariables.valueMapListProfilePage[index].id;
                                                              Navigator.push(context,
                                                                  MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                              break;
                                                            }
                                                          case "forums":
                                                            {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                          idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                              (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                          comeFrom: "billBoardHome",
                                                                          forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                                'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                              });
                                                              var responseData = json.decode(response.body);
                                                              if (responseData["status"]) {
                                                                activeStatus = responseData["response"]["status"];

                                                                if (activeStatus == "active") {
                                                                  var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                                  var response = await http.post(url, headers: {
                                                                    'Authorization': mainUserToken
                                                                  }, body: {
                                                                    'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                              mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                                  ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return AnalyticsPage(
                                                                        surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                        activity: false,
                                                                        surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                        navBool: false,
                                                                        fromWhere: 'similar',
                                                                      );
                                                                    }))
                                                                  : activeStatus == 'active'
                                                                      ? answerStatus
                                                                          ? Navigator.push(context,
                                                                              MaterialPageRoute(builder: (BuildContext context) {
                                                                              return AnalyticsPage(
                                                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                  activity: false,
                                                                                  navBool: false,
                                                                                  fromWhere: 'similar',
                                                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                            }))
                                                                          : Navigator.push(context,
                                                                              MaterialPageRoute(builder: (BuildContext context) {
                                                                              return QuestionnairePage(
                                                                                surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                                defaultIndex: answeredQuestion,
                                                                              );
                                                                            }))
                                                                      : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return AnalyticsPage(
                                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                            activity: false,
                                                                            surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                        " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                        style: TextStyle(
                                                            fontSize: text.scale(10),
                                                            color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        SizedBox(height: height / 42.6),
                                        mainVariables.valueMapListProfilePage[index].type == 'survey' ||
                                                mainVariables.valueMapListProfilePage[index].type == 'news'
                                            ? const SizedBox()
                                            : Container(
                                                padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                            mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                          mainVariables.selectedTickerId.value = mainVariables.valueMapListProfilePage[index].userId;
                                                        }
                                                        bool response =
                                                            await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                              ? IntermediaryBillBoardProfilePage(
                                                                  userId: mainVariables.valueMapListProfilePage[index].userId)
                                                              : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                                  ? const BusinessProfilePage()
                                                                  : UserBillBoardProfilePage(
                                                                      userId: mainVariables.valueMapListProfilePage[index].userId);
                                                        }));
                                                        /*bool response =
                                                            await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return UserBillBoardProfilePage(
                                                            userId: userIdMain,
                                                          );
                                                        }));*/
                                                        if (response) {
                                                          getBillBoardListData();
                                                        }
                                                      },
                                                      child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                    ),
                                                    SizedBox(
                                                      width: width / 41.1,
                                                    ),
                                                    billboardWidgetsMain.getResponseField(
                                                      context: context,
                                                      modelSetState: modelSetState,
                                                      billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                      postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                      responseId: "",
                                                      index: index,
                                                      fromWhere: 'homePage',
                                                      callFunction: () {},
                                                      contentType: mainVariables.valueMapListProfilePage[index].type,
                                                      category: mainVariables.valueMapListProfilePage[index].category,
                                                      responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                          (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                      : //final  // NonBelievedCategory, NonFiles, nonByte
                      Container(
                          padding: const EdgeInsets.all(1.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.tertiary,
                                blurRadius: 4.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  switch (mainVariables.valueMapListProfilePage[index].type) {
                                    case "blog":
                                      {
                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                        break;
                                      }
                                    case "byte":
                                      {
                                        mainVariables.selectedBillboardIdMain.value = mainVariables.valueMapListProfilePage[index].id;
                                        //gettingPageRoute(pageName: billBoardPageName.value);
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                        break;
                                      }
                                    case "forums":
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) => ForumPostDescriptionPage(
                                                    idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                        (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                    comeFrom: "billBoardHome",
                                                    forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                          'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                        });
                                        var responseData = json.decode(response.body);
                                        if (responseData["status"]) {
                                          activeStatus = responseData["response"]["status"];

                                          if (activeStatus == "active") {
                                            var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                            var response = await http.post(url, headers: {
                                              'Authorization': mainUserToken
                                            }, body: {
                                              'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                        mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                            ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return AnalyticsPage(
                                                  surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                  activity: false,
                                                  surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                  navBool: false,
                                                  fromWhere: 'similar',
                                                );
                                              }))
                                            : activeStatus == 'active'
                                                ? answerStatus
                                                    ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return AnalyticsPage(
                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                            activity: false,
                                                            navBool: false,
                                                            fromWhere: 'similar',
                                                            surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                      }))
                                                    : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                        return QuestionnairePage(
                                                          surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                          defaultIndex: answeredQuestion,
                                                        );
                                                      }))
                                                : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return AnalyticsPage(
                                                      surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                      activity: false,
                                                      surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                            id: mainVariables.valueMapListProfilePage[index].id,
                                            type: 'news',
                                            activity: true,
                                            checkMain: false,
                                          );
                                        }));*/
                                        Get.to(const DemoView(),
                                            arguments: {"id": mainVariables.valueMapListProfilePage[index].id, "type": "news", "url": ""});
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
                                      height: height / 3.97,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                          gradient: mainVariables.valueMapListProfilePage[index].type == "blog"
                                              ? const RadialGradient(
                                                  colors: [Color.fromRGBO(23, 25, 27, 0.90), Color.fromRGBO(85, 85, 85, 0.00)],
                                                  radius: 15.0,
                                                )
                                              : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                  ? const RadialGradient(
                                                      colors: [Color.fromRGBO(0, 92, 175, 0.90), Color.fromRGBO(13, 155, 1, 0.00)],
                                                      radius: 15.0,
                                                    )
                                                  : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                      ? const RadialGradient(
                                                          colors: [Color.fromRGBO(10, 122, 1, 0.90), Color.fromRGBO(13, 155, 1, 0.00)],
                                                          radius: 15.0,
                                                        )
                                                      : const RadialGradient(
                                                          colors: [Color.fromRGBO(255, 255, 255, 1), Color.fromRGBO(255, 255, 255, 1)],
                                                          radius: 15.0,
                                                        ),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                mainVariables.valueMapListProfilePage[index].type == "news"
                                                    ? mainVariables.valueMapListProfilePage[index].newsImage
                                                    : "",
                                              ),
                                              fit: BoxFit.fill)),
                                      child: Center(
                                        child: Text(
                                          mainVariables.valueMapListProfilePage[index].type == "news"
                                              ? ""
                                              : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                  ? mainVariables.valueMapListProfilePage[index].type
                                                      .toString()
                                                      .capitalizeFirst!
                                                      .substring(0, mainVariables.valueMapListProfilePage[index].type.length - 1)
                                                  : mainVariables.valueMapListProfilePage[index].type.toString().capitalizeFirst!,
                                          style: TextStyle(fontSize: text.scale(40), fontWeight: FontWeight.w900, color: const Color(0XFFFFFFFF)),
                                        ),
                                      ),
                                    ),
                                    mainVariables.valueMapListProfilePage[index].repostCount == 0 ||
                                            mainVariables.valueMapListProfilePage[index].repostAvatar == ""
                                        ? const SizedBox()
                                        : Positioned(
                                            top: height / 15,
                                            right: 15,
                                            child: GestureDetector(
                                              onTap: () {
                                                billboardWidgetsMain.believedTabBottomSheet(
                                                    context: context,
                                                    id: mainVariables.valueMapListProfilePage[index].repostId,
                                                    type: mainVariables.valueMapListProfilePage[index].type);
                                              },
                                              child: Stack(
                                                children: [
                                                  const SizedBox(
                                                    height: 35,
                                                    width: 35,
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    bottom: 0,
                                                    child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          image: const DecorationImage(
                                                            image: AssetImage("lib/Constants/Assets/BillBoard/repost_grey.png"),
                                                          )),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      height: 15,
                                                      width: 15,
                                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                                      child: Center(
                                                          child: Text(
                                                        mainVariables.valueMapListProfilePage[index].repostCount > 9
                                                            ? "9+"
                                                            : mainVariables.valueMapListProfilePage[index].repostCount.toString(),
                                                        style: const TextStyle(color: Colors.white, fontSize: 10),
                                                      )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Container(
                                        height: height / 18,
                                        width: width / 1.06,
                                        padding: EdgeInsets.only(
                                          left: width / 27.4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black12.withOpacity(0.3),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                /*bookMarkWidget(
                                                            bookMark: List.generate(mainVariables.valueMapListProfilePage.length, (ind) => mainVariables.valueMapListProfilePage[ind].bookmarks),
                                                            context: context,
                                                            scale: 3,
                                                            color: Colors.white,
                                                            id: mainVariables.valueMapListProfilePage[index].id,
                                                            type: mainVariables.valueMapListProfilePage[index].type=="byte"||mainVariables.valueMapListProfilePage[index].type=="blog"?"billboard":mainVariables.valueMapListProfilePage[index].type,
                                                            modelSetState: modelSetState,
                                                            index: index,
                                                            initFunction: billBoardApiMain.getBillBoardListApiFunc,
                                                            notUse: false
                                                        ),*/
                                                billboardWidgetsMain.billBoardBookMarkWidget(context: context, index: index),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                billboardWidgetsMain.translationWidget(
                                                    id: mainVariables.valueMapListProfilePage[index].id,
                                                    type: mainVariables.valueMapListProfilePage[index].type == "forums"
                                                        ? "forums"
                                                        : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                            ? "survey"
                                                            : mainVariables.valueMapListProfilePage[index].type == "news"
                                                                ? "news"
                                                                : 'billboard',
                                                    index: index,
                                                    initFunction: getData,
                                                    context: context,
                                                    modelSetState: modelSetState,
                                                    notUse: false,
                                                    valueMapList: mainVariables.valueMapListProfilePage),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                userIdMain != mainVariables.valueMapListProfilePage[index].userId
                                                    ? billboardWidgetsMain.getHomeBelieveButton(
                                                        heightValue: height / 33.76,
                                                        isBelieved: List.generate(mainVariables.valueMapListProfilePage.length,
                                                            (ind) => mainVariables.valueMapListProfilePage[ind].believed),
                                                        billboardUserid: mainVariables.valueMapListProfilePage[index].userId,
                                                        billboardUserName: mainVariables.valueMapListProfilePage[index].username,
                                                        context: context,
                                                        modelSetState: modelSetState,
                                                        index: index,
                                                        background: true,
                                                      )
                                                    : const SizedBox(),

                                                ///more_vert
                                                IconButton(
                                                    onPressed: () {
                                                      billboardWidgetsMain.bottomSheet(
                                                        context1: context,
                                                        myself: userIdMain == mainVariables.valueMapListProfilePage[index].userId,
                                                        billboardId: mainVariables.valueMapListProfilePage[index].id,
                                                        billboardUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                        type: "billboard",
                                                        responseId: "",
                                                        responseUserId: "",
                                                        commentId: "",
                                                        commentUserId: "",
                                                        callFunction: getData,
                                                        contentType: mainVariables.valueMapListProfilePage[index].type,
                                                        modelSetState: modelSetState,
                                                        responseDetail: {},
                                                        category: mainVariables.valueMapListProfilePage[index].category,
                                                        valueMapList: mainVariables.valueMapListProfilePage,
                                                        index: index,
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.more_vert,
                                                      color: Colors.white,
                                                      size: 25,
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        height: height / 14,
                                        width: width,
                                        padding: EdgeInsets.only(top: height / 86.6, bottom: height / 86.6, right: width / 13.7, left: width / 41.1),
                                        decoration: BoxDecoration(
                                          color: Colors.black12.withOpacity(0.3),
                                        ),
                                        child: RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            children: conversationFunctionsMain.spanListBillBoardHome(
                                                message: mainVariables.valueMapListProfilePage[index].title.length > 100
                                                    ? mainVariables.valueMapListProfilePage[index].title.substring(0, 100)
                                                    : mainVariables.valueMapListProfilePage[index].title,
                                                context: context,
                                                isByte: false),
                                          ),
                                        )
                                        /*Text(
                                                         mainVariables.valueMapListProfilePage[index].title.toString().capitalizeFirst!,
                                                         maxLines: 2,
                                                         style: TextStyle(
                                                             fontSize: _text*14,
                                                             color: Colors.white,
                                                             fontWeight: FontWeight.w500,
                                                             fontFamily: "Poppins",
                                                             overflow: TextOverflow.ellipsis
                                                         ),
                                                       )*/
                                        ,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background, //Colors.white,
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: height / 86.6,
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
                                          heightValue: height / 17.32,
                                          widthValue: width / 8.22,
                                          myself: false,
                                          avatar: mainVariables.valueMapListProfilePage[index].avatar,
                                          isProfile: mainVariables.valueMapListProfilePage[index].profileType,
                                          userId: mainVariables.valueMapListProfilePage[index].userId,
                                          repostAvatar: mainVariables.valueMapListProfilePage[index].repostAvatar,
                                          repostUserId: mainVariables.valueMapListProfilePage[index].repostUser,
                                          isRepostProfile: mainVariables.valueMapListProfilePage[index].repostProfileType,
                                          getBillBoardListData: getBillBoardListData,
                                        ),
                                        SizedBox(
                                          width: width / 41.1,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  /*Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                                            return UserProfilePage(
                                                                id:valueMapList[index].userId,
                                                                type:'forums',
                                                                index:0
                                                            );
                                                          }));*/
                                                  /*bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return UserBillBoardProfilePage(userId: mainVariables.valueMapListProfilePage[index].userId);
                                                  }));*/
                                                  if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                      mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                    mainVariables.selectedTickerId.value = mainVariables.valueMapListProfilePage[index].userId;
                                                  }
                                                  bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                        ? IntermediaryBillBoardProfilePage(
                                                            userId: mainVariables.valueMapListProfilePage[index].userId)
                                                        : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                            ? const BusinessProfilePage()
                                                            : UserBillBoardProfilePage(userId: mainVariables.valueMapListProfilePage[index].userId);
                                                  }));
                                                  if (response) {
                                                    getBillBoardListData();
                                                  }
                                                },
                                                child: Text(
                                                  mainVariables.valueMapListProfilePage[index].username.toString().capitalizeFirst!,
                                                  style: Theme.of(context).textTheme.bodyLarge,
                                                  /*TextStyle(
                                                      fontSize: text.scale(14),
                                                      color: const Color(0XFF202020),
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: "Poppins"),*/
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    mainVariables.valueMapListProfilePage[index].createdAt,
                                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                          fontWeight: FontWeight.w400,
                                                          color: const Color(0XFF737373),
                                                        ),
                                                    /*TextStyle(
                                                        fontSize: text.scale(10),
                                                        color: const Color(0XFF737373),
                                                        fontWeight: FontWeight.w400,
                                                        fontFamily: "Poppins"),*/
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    " | ",
                                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                          fontWeight: FontWeight.w400,
                                                          color: const Color(0XFF737373),
                                                        ),
                                                    /*TextStyle(
                                                      fontSize: text.scale(10),
                                                      color: const Color(0XFF737373),
                                                      fontWeight: FontWeight.w400,
                                                    ),*/
                                                  ),
                                                  const SizedBox(
                                                    width: 3,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      billboardWidgetsMain.believersTabBottomSheet(
                                                        context: context,
                                                        id: mainVariables.valueMapListProfilePage[index].userId,
                                                        isBelieversList: true,
                                                      );
                                                    },
                                                    child: Text(
                                                      "${mainVariables.valueMapListProfilePage[index].believersCount} Believers",
                                                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                                            fontWeight: FontWeight.w400,
                                                            color: const Color(0XFF737373),
                                                          ), /*TextStyle(
                                                          fontSize: text.scale(10),
                                                          color: const Color(0XFF737373),
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: "Poppins"),*/
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        billboardWidgetsMain.likeButtonHomeListWidget(
                                          likeList: List.generate(
                                              mainVariables.valueMapListProfilePage.length, (ind) => mainVariables.valueMapListProfilePage[ind].like),
                                          id: mainVariables.valueMapListProfilePage[index].id,
                                          index: index,
                                          context: context,
                                          initFunction: () {},
                                          modelSetState: modelSetState,
                                          notUse: true,
                                          dislikeList: List.generate(mainVariables.valueMapListProfilePage.length,
                                              (ind) => mainVariables.valueMapListProfilePage[ind].dislike),
                                          likeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                              (ind) => mainVariables.valueMapListProfilePage[ind].likesCount),
                                          dislikeCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                              (ind) => mainVariables.valueMapListProfilePage[ind].disLikesCount),
                                          type: mainVariables.valueMapListProfilePage[index].type,
                                          billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                              ? "news"
                                              : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                  ? "forums"
                                                  : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                      ? "survey"
                                                      : "billboard",
                                          /*mainVariables.valueMapListProfilePage[index].type=='survey'?'survey':'billboard',*/
                                          image: mainVariables.valueMapListProfilePage[index].avatar,
                                          title: mainVariables.valueMapListProfilePage[index].title,
                                          description: "",
                                          fromWhere: 'homePage',
                                          responseId: '',
                                          controller: bottomSheetController,
                                          commentId: '',
                                          postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                          responseUserId: '',
                                          responseFocusList: mainVariables.responseFocusList,
                                          valueMapList: mainVariables.valueMapListProfilePage,
                                        ),
                                        SizedBox(
                                          width: width / 41.1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height / 64),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                      child: mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                          ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  mainVariables.valueMapListProfilePage[index].companyName == ""
                                                      ? mainVariables.valueMapListProfilePage[index].category.capitalizeFirst!
                                                      : mainVariables.valueMapListProfilePage[index].companyName.capitalizeFirst!,
                                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                        fontWeight: FontWeight.w700,
                                                        color: const Color(0xFF017FDB),
                                                      ), /*TextStyle(
                                                      fontSize: text.scale(10), color: const Color(0xFF017FDB), fontWeight: FontWeight.bold),*/
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    billboardWidgetsMain.getLikeDislikeUsersList(
                                                        context: context,
                                                        billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                        responseId: "",
                                                        commentId: "",
                                                        billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                            ? "news"
                                                            : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                ? "forums"
                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                    ? "survey"
                                                                    : "billboard",
                                                        action: "views",
                                                        likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                        disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                        index: 0,
                                                        viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                        isViewIncluded: true);
                                                  },
                                                  child: Text(
                                                    " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                    style: TextStyle(
                                                        fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary /*Colors.black54*/),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    billboardWidgetsMain.getLikeDislikeUsersList(
                                                        context: context,
                                                        billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                        responseId: "",
                                                        commentId: "",
                                                        billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                            ? "news"
                                                            : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                ? "forums"
                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                    ? "survey"
                                                                    : "billboard",
                                                        action: mainVariables.valueMapListProfilePage[index].type == "forums" ? "liked" : "likes",
                                                        likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                        disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                        index: 1,
                                                        viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                        isViewIncluded: true);
                                                  },
                                                  child: Text(
                                                    " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                    style: TextStyle(fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    billboardWidgetsMain.getLikeDislikeUsersList(
                                                        context: context,
                                                        billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                        responseId: "",
                                                        commentId: "",
                                                        billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                            ? "news"
                                                            : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                ? "forums"
                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                    ? "survey"
                                                                    : "billboard",
                                                        action:
                                                            mainVariables.valueMapListProfilePage[index].type == "forums" ? "disliked" : "dislikes",
                                                        likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                        disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                        index: 2,
                                                        viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                        isViewIncluded: true);
                                                  },
                                                  child: Text(
                                                    " ${mainVariables.valueMapListProfilePage[index].disLikesCount} DisLikes ",
                                                    style: TextStyle(fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary),
                                                  ),
                                                )
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  mainVariables.valueMapListProfilePage[index].companyName == ""
                                                      ? mainVariables.valueMapListProfilePage[index].category.capitalizeFirst!
                                                      : mainVariables.valueMapListProfilePage[index].companyName.capitalizeFirst!,
                                                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                                        fontWeight: FontWeight.w700,
                                                        color: const Color(0xFF017FDB),
                                                      ),
                                                  /*TextStyle(
                                                      fontSize: text.scale(10), color: const Color(0xFF017FDB), fontWeight: FontWeight.bold),*/
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    billboardWidgetsMain.getLikeDislikeUsersList(
                                                        context: context,
                                                        billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                        responseId: "",
                                                        commentId: "",
                                                        billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                            ? "news"
                                                            : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                ? "forums"
                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                    ? "survey"
                                                                    : "billboard",
                                                        action: "views",
                                                        likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                        disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                        index: 0,
                                                        viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                        isViewIncluded: true);
                                                  },
                                                  child: Text(
                                                    " ${mainVariables.valueMapListProfilePage[index].viewsCount} views ",
                                                    style: TextStyle(fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    billboardWidgetsMain.getLikeDislikeUsersList(
                                                        context: context,
                                                        billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                        responseId: "",
                                                        commentId: "",
                                                        billBoardType: mainVariables.valueMapListProfilePage[index].type == "news"
                                                            ? "news"
                                                            : mainVariables.valueMapListProfilePage[index].type == "forums"
                                                                ? "forums"
                                                                : mainVariables.valueMapListProfilePage[index].type == "survey"
                                                                    ? "survey"
                                                                    : "billboard",
                                                        action: mainVariables.valueMapListProfilePage[index].type == "forums" ? "liked" : "likes",
                                                        likeCount: mainVariables.valueMapListProfilePage[index].likesCount.toString(),
                                                        disLikeCount: mainVariables.valueMapListProfilePage[index].disLikesCount.toString(),
                                                        index: 1,
                                                        viewCount: mainVariables.valueMapListProfilePage[index].viewsCount.toString(),
                                                        isViewIncluded: true);
                                                  },
                                                  child: Text(
                                                    " ${mainVariables.valueMapListProfilePage[index].likesCount} likes ",
                                                    style: TextStyle(fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    switch (mainVariables.valueMapListProfilePage[index].type) {
                                                      case "blog":
                                                        {
                                                          mainVariables.selectedBillboardIdMain.value =
                                                              mainVariables.valueMapListProfilePage[index].id;
                                                          Navigator.push(context,
                                                              MaterialPageRoute(builder: (BuildContext context) => const BlogDescriptionPage()));
                                                          break;
                                                        }
                                                      case "byte":
                                                        {
                                                          mainVariables.selectedBillboardIdMain.value =
                                                              mainVariables.valueMapListProfilePage[index].id;
                                                          Navigator.push(context,
                                                              MaterialPageRoute(builder: (BuildContext context) => const BytesDescriptionPage()));
                                                          break;
                                                        }
                                                      case "forums":
                                                        {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext context) => ForumPostDescriptionPage(
                                                                      idList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                                          (ind) => mainVariables.valueMapListProfilePage[ind].id),
                                                                      comeFrom: "billBoardHome",
                                                                      forumId: mainVariables.valueMapListProfilePage[index].id)));
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
                                                            'survey_id': mainVariables.valueMapListProfilePage[index].id,
                                                          });
                                                          var responseData = json.decode(response.body);
                                                          if (responseData["status"]) {
                                                            activeStatus = responseData["response"]["status"];

                                                            if (activeStatus == "active") {
                                                              var url = Uri.parse(baseurl + versionSurvey + checkAnswer);
                                                              var response = await http.post(url, headers: {
                                                                'Authorization': mainUserToken
                                                              }, body: {
                                                                'survey_id': mainVariables.valueMapListProfilePage[index].id,
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
                                                          mainUserId == mainVariables.valueMapListProfilePage[index].userId
                                                              ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                  return AnalyticsPage(
                                                                    surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                    activity: false,
                                                                    surveyTitle: mainVariables.valueMapListProfilePage[index].title,
                                                                    navBool: false,
                                                                    fromWhere: 'similar',
                                                                  );
                                                                }))
                                                              : activeStatus == 'active'
                                                                  ? answerStatus
                                                                      ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return AnalyticsPage(
                                                                              surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                              activity: false,
                                                                              navBool: false,
                                                                              fromWhere: 'similar',
                                                                              surveyTitle: mainVariables.valueMapListProfilePage[index].title);
                                                                        }))
                                                                      : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return QuestionnairePage(
                                                                            surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                            defaultIndex: answeredQuestion,
                                                                          );
                                                                        }))
                                                                  : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                      return AnalyticsPage(
                                                                        surveyId: mainVariables.valueMapListProfilePage[index].id,
                                                                        activity: false,
                                                                        surveyTitle: mainVariables.valueMapListProfilePage[index].title,
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
                                                    " ${mainVariables.valueMapListProfilePage[index].responseCount} Responses ",
                                                    style: TextStyle(fontSize: text.scale(10), color: Theme.of(context).colorScheme.onPrimary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(height: height / 42.6),
                                    mainVariables.valueMapListProfilePage[index].type == 'survey' ||
                                            mainVariables.valueMapListProfilePage[index].type == 'news'
                                        ? const SizedBox()
                                        : Container(
                                            padding: EdgeInsets.symmetric(horizontal: width / 51.375),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    if (mainVariables.valueMapListProfilePage[index].profileType != "intermediate" ||
                                                        mainVariables.valueMapListProfilePage[index].profileType != "user") {
                                                      mainVariables.selectedTickerId.value = mainVariables.valueMapListProfilePage[index].userId;
                                                    }
                                                    bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return mainVariables.valueMapListProfilePage[index].profileType == "intermediate"
                                                          ? IntermediaryBillBoardProfilePage(
                                                              userId: mainVariables.valueMapListProfilePage[index].userId)
                                                          : mainVariables.valueMapListProfilePage[index].profileType != 'user'
                                                              ? const BusinessProfilePage()
                                                              : UserBillBoardProfilePage(userId: mainVariables.valueMapListProfilePage[index].userId);
                                                    }));
                                                    /*bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                      return UserBillBoardProfilePage(
                                                        userId: userIdMain,
                                                      );
                                                    }));*/
                                                    if (response) {
                                                      getBillBoardListData();
                                                    }
                                                  },
                                                  child: CircleAvatar(radius: 22, backgroundImage: NetworkImage(avatarMain.value)),
                                                ),
                                                SizedBox(
                                                  width: width / 41.1,
                                                ),
                                                billboardWidgetsMain.getResponseField(
                                                  context: context,
                                                  modelSetState: modelSetState,
                                                  billBoardId: mainVariables.valueMapListProfilePage[index].id,
                                                  postUserId: mainVariables.valueMapListProfilePage[index].userId,
                                                  responseId: "",
                                                  index: index,
                                                  fromWhere: 'homePage',
                                                  callFunction: () {},
                                                  contentType: mainVariables.valueMapListProfilePage[index].type,
                                                  category: mainVariables.valueMapListProfilePage[index].category,
                                                  responseCountList: List.generate(mainVariables.valueMapListProfilePage.length,
                                                      (ind) => mainVariables.valueMapListProfilePage[ind].responseCount),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
              Obx(() => mainVariables.isUserTaggingList[index]
                  ? Positioned(
                      bottom: height / 13,
                      child: UserTaggingBillBoardHomeContainer(
                        billboardListIndex: index,
                      ))
                  : const SizedBox()),
            ],
          ),
          SizedBox(
            height: height / 33.83,
          )
        ]));
  }
}
