import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesPage/communities_page.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesPage/communities_post_page.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunityCreationPage/community_creation_page.dart';

class CommunitiesWidgets {
  Widget trendingCommunitiesList({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height / 7.87,
      child: Obx(() => ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: communitiesVariables.communityHomeList.value.trendingData.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return CommunitiesPage(communityId: communitiesVariables.communityHomeList.value.trendingData[index].id.value);
                  }));
                },
                child: trendingListCard(index: index, context: context, modelSetState: modelSetState));
          })),
    );
  }

  Widget trendingSeeAllCommunitiesList({
    required BuildContext context,
    required StateSetter modelSetState,
    required int skipCount,
  }) {
    double height = MediaQuery.of(context).size.height;
    RefreshController refController = RefreshController();
    return Expanded(
      child: Obx(() => SmartRefresher(
            controller: refController,
            enablePullDown: false,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = const Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = const CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = const Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = const Text("release to load more");
                } else {
                  body = const Text("No more Data");
                }
                return SizedBox(
                  height: height / 15.74,
                  child: Center(child: body),
                );
              },
            ),
            onLoading: () async {
              skipCount = skipCount + 20;
              await communitiesFunctions.getTrendingCommunitiesList(skipCount: skipCount);
              if (!context.mounted) {
                modelSetState(() {});
              }
              refController.loadComplete();
            },
            child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: communitiesVariables.communityHomeList.value.trendingData.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return CommunitiesPage(communityId: communitiesVariables.communityHomeList.value.trendingData[index].id.value);
                        }));
                      },
                      child: trendingListCard(index: index, context: context, modelSetState: modelSetState));
                }),
          )),
    );
  }

  Widget communitiesList({
    required BuildContext context,
    required StateSetter modelSetState,
    required int skipCount,
  }) {
    double height = MediaQuery.of(context).size.height;
    RefreshController refController = RefreshController();
    return Expanded(
      child: Obx(() => SmartRefresher(
            controller: refController,
            enablePullDown: false,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = const Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = const CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = const Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = const Text("release to load more");
                } else {
                  body = const Text("No more Data");
                }
                return SizedBox(
                  height: height / 15.74,
                  child: Center(child: body),
                );
              },
            ),
            onLoading: () async {
              skipCount = skipCount + 20;
              await communitiesFunctions.getCommunitiesList(skipCount: skipCount);
              if (!context.mounted) {
                modelSetState(() {});
              }
              refController.loadComplete();
            },
            child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: communitiesVariables.communityHomeList.value.communityListData.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return CommunitiesPage(
                              communityId: communitiesVariables.communityHomeList.value.communityListData[index].communityId.value);
                        }));
                      },
                      child: listCard(index: index, context: context, modelSetState: modelSetState));
                }),
          )),
    );
  }

  Widget trendingListCard({
    required BuildContext context,
    required StateSetter modelSetState,
    required int index,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => Container(
          width: communitiesVariables.isSeeAllViewEnabled.value
              ? width / 1.1
              : communitiesVariables.communityHomeList.value.trendingData.length == 1
                  ? width / 1.1
                  : width / 1.644,
          margin: communitiesVariables.isSeeAllViewEnabled.value
              ? EdgeInsets.only(top: index == 0 ? height / 433 : height / 57.73, bottom: height / 144.3, left: width / 205.5, right: width / 205.5)
              : EdgeInsets.only(left: index == 0 ? width / 205.5 : width / 27.4, top: height / 433, bottom: height / 433),
          padding: EdgeInsets.symmetric(
              horizontal: communitiesVariables.isSeeAllViewEnabled.value ? width / 27.4 : width / 41.1,
              vertical: communitiesVariables.isSeeAllViewEnabled.value ? height / 57.73 : height / 86.6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.onBackground,
            boxShadow: [
              BoxShadow(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1), blurRadius: 4.0, spreadRadius: 0.0),
            ],
          ),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: communitiesVariables.isSeeAllViewEnabled.value ? height / 12.37 : height / 15.74,
                      width: communitiesVariables.isSeeAllViewEnabled.value ? width / 5.87 : width / 7.47,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onBackground,
                        image: DecorationImage(
                            image: NetworkImage(communitiesVariables.communityHomeList.value.trendingData[index].file.isEmpty
                                ? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png"
                                : communitiesVariables.communityHomeList.value.trendingData[index].file[0].file.value),
                            fit: BoxFit.fill),
                      ),
                    ),
                    SizedBox(
                      width: width / 27.4,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: communitiesVariables.isSeeAllViewEnabled.value ? width / 3 : width / 4.6,
                                child: Text(
                                  communitiesVariables.communityHomeList.value.trendingData[index].name.value,
                                  style: TextStyle(
                                      fontSize: communitiesVariables.isSeeAllViewEnabled.value ? text.scale(14) : text.scale(10),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                communitiesVariables.communityHomeList.value.trendingData[index].code.value,
                                style: TextStyle(
                                    fontSize: communitiesVariables.isSeeAllViewEnabled.value ? text.scale(12) : text.scale(8),
                                    color: const Color(0XFFB3B3B3),
                                    fontWeight: FontWeight.w500),
                              ),
                              Obx(
                                () => communitiesVariables.communityHomeList.value.trendingData[index].isPaidSubscription.value
                                    ? AnimatedCrossFade(
                                        firstChild: InkWell(
                                            onTap: () async {
                                              // communitiesVariables.communityHomeList.value.trendingData[index].isJoined.toggle();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: communitiesVariables.isSeeAllViewEnabled.value ? width / 27.4 : width / 51.375,
                                                  vertical: height / 216.5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(communitiesVariables.isSeeAllViewEnabled.value ? 12 : 6),
                                                  color: const Color(0XFFFB1212).withOpacity(0.1)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: const Color(0XFF000000),
                                                    size: communitiesVariables.isSeeAllViewEnabled.value ? 22 : 15,
                                                  ),
                                                  SizedBox(
                                                    width: width / 68.5,
                                                  ),
                                                  Text(
                                                    "Purchased",
                                                    style: TextStyle(
                                                        fontSize: communitiesVariables.isSeeAllViewEnabled.value ? text.scale(14) : text.scale(10),
                                                        color: const Color(0XFF000000),
                                                        fontWeight: FontWeight.w700),
                                                  )
                                                ],
                                              ),
                                            )),
                                        secondChild: InkWell(
                                            onTap: () async {
                                              Map<String, dynamic> data = await communitiesFunctions.joinCommunity(
                                                  communityId: communitiesVariables.communityHomeList.value.trendingData[index].id.value);
                                              if (data["status"]) {
                                                communitiesVariables.communityHomeList.value.trendingData[index].isJoined.toggle();
                                                communitiesVariables.communityHomeList.value.trendingData[index].isJoined.refresh();
                                              } else {
                                                if (!context.mounted) {
                                                  return;
                                                }
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"])));
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: communitiesVariables.isSeeAllViewEnabled.value ? width / 27.4 : width / 51.375,
                                                  vertical: communitiesVariables.isSeeAllViewEnabled.value ? 0 : height / 216.5),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(communitiesVariables.isSeeAllViewEnabled.value ? 8 : 6),
                                                gradient: const RadialGradient(
                                                  radius: 5,
                                                  colors: [Color(0XFFEDA130), Color(0XFFFFD361)],
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: communitiesVariables.isSeeAllViewEnabled.value ? height / 216.5 : height / 433),
                                                    child: SvgPicture.asset(
                                                      "lib/Constants/Assets/NewAssets/CommunitiesScreen/subscribe_crown.svg",
                                                      height: communitiesVariables.isSeeAllViewEnabled.value ? height / 34.64 : height / 57.73,
                                                      width: communitiesVariables.isSeeAllViewEnabled.value ? width / 16.44 : width / 27.4,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 68.25,
                                                  ),
                                                  Text(
                                                    "Subscribe",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: communitiesVariables.isSeeAllViewEnabled.value ? text.scale(14) : text.scale(10),
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        crossFadeState: communitiesVariables.communityHomeList.value.trendingData[index].isJoined.value
                                            ? CrossFadeState.showFirst
                                            : CrossFadeState.showSecond,
                                        duration: const Duration(milliseconds: 500))
                                    : AnimatedCrossFade(
                                        firstChild: InkWell(
                                            onTap: () async {
                                              /*Map<String, dynamic> data = await communitiesFunctions.joinCommunity(
                                                  communityId: communitiesVariables.communityHomeList.value.trendingData[index].id.value);
                                              if (data["status"]) {
                                                communitiesVariables.communityHomeList.value.trendingData[index].isJoined.toggle();
                                                communitiesVariables.communityHomeList.value.trendingData[index].isJoined.refresh();
                                              } else {
                                                if (!context.mounted) {
                                                  return;
                                                }
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"])));
                                              }*/
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: communitiesVariables.isSeeAllViewEnabled.value ? width / 27.4 : width / 51.375,
                                                  vertical: height / 216.5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(communitiesVariables.isSeeAllViewEnabled.value ? 12 : 6),
                                                  color: const Color(0XFFFB1212).withOpacity(0.1)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: const Color(0XFF000000),
                                                    size: communitiesVariables.isSeeAllViewEnabled.value ? 22 : 15,
                                                  ),
                                                  SizedBox(
                                                    width: width / 68.25,
                                                  ),
                                                  Text(
                                                    "Joined",
                                                    style: TextStyle(
                                                        fontSize: communitiesVariables.isSeeAllViewEnabled.value ? text.scale(14) : text.scale(10),
                                                        color: const Color(0XFF000000),
                                                        fontWeight: FontWeight.w700),
                                                  )
                                                ],
                                              ),
                                            )),
                                        secondChild: InkWell(
                                            onTap: () async {
                                              Map<String, dynamic> data = await communitiesFunctions.joinCommunity(
                                                  communityId: communitiesVariables.communityHomeList.value.trendingData[index].id.value);
                                              if (data["status"]) {
                                                communitiesVariables.communityHomeList.value.trendingData[index].isJoined.toggle();
                                                communitiesVariables.communityHomeList.value.trendingData[index].isJoined.refresh();
                                              } else {
                                                if (!context.mounted) {
                                                  return;
                                                }
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"])));
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: communitiesVariables.isSeeAllViewEnabled.value ? width / 27.4 : width / 51.375,
                                                  vertical: height / 288.6),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(communitiesVariables.isSeeAllViewEnabled.value ? 8 : 6),
                                                  color: const Color(0XFF0EA102)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add_circle,
                                                    color: Colors.white,
                                                    size: communitiesVariables.isSeeAllViewEnabled.value ? 22 : 15,
                                                  ),
                                                  SizedBox(
                                                    width: width / 68.25,
                                                  ),
                                                  Text(
                                                    "Join",
                                                    style: TextStyle(
                                                        fontSize: communitiesVariables.isSeeAllViewEnabled.value ? text.scale(14) : text.scale(10),
                                                        color: const Color(0XFFFFFFFF),
                                                        fontWeight: FontWeight.w700),
                                                  )
                                                ],
                                              ),
                                            )),
                                        crossFadeState: communitiesVariables.communityHomeList.value.trendingData[index].isJoined.value
                                            ? CrossFadeState.showFirst
                                            : CrossFadeState.showSecond,
                                        duration: const Duration(milliseconds: 500)),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                  onTap: () {
                                    if (userIdMain == communitiesVariables.communityHomeList.value.trendingData[index].userId.value) {
                                      editOrDeleteBottomSheet(
                                        context: context,
                                        communityId: communitiesVariables.communityHomeList.value.trendingData[index].id.value,
                                        list: 'trending',
                                        index: index,
                                        type: "community",
                                        postId: '',
                                      );
                                    } else {
                                      blockOrReportBottomSheet(
                                        context: context,
                                        modelSetState: modelSetState,
                                        communityId: communitiesVariables.communityHomeList.value.trendingData[index].id.value,
                                        postId: "",
                                        userId: communitiesVariables.communityHomeList.value.trendingData[index].userId.value,
                                        list: 'trending',
                                        index: index,
                                        type: "community",
                                      );
                                    }
                                  },
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    size: communitiesVariables.isSeeAllViewEnabled.value ? 25 : 15,
                                  )),
                              SizedBox(
                                height: height / 57.73,
                              ),
                              Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: communitiesVariables.isSeeAllViewEnabled.value
                                          ? communitiesVariables.communityHomeList.value.trendingData[index].members.length * width / 11.74
                                          : communitiesVariables.communityHomeList.value.trendingData[index].members.length * width / 20.55,
                                      height: communitiesVariables.isSeeAllViewEnabled.value ? height / 24.74 : height / 43.3,
                                      child: Stack(
                                        alignment: Alignment.centerRight,
                                        children: List.generate(
                                            communitiesVariables.communityHomeList.value.trendingData[index].members.length,
                                            (idx) => Positioned(
                                                  left: idx * (communitiesVariables.isSeeAllViewEnabled.value ? 25 : 15),
                                                  top: 0,
                                                  child: Container(
                                                    height: communitiesVariables.isSeeAllViewEnabled.value ? height / 24.74 : height / 43.3,
                                                    width: communitiesVariables.isSeeAllViewEnabled.value ? width / 11.74 : width / 20.55,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: const Color(0XFF0EA102),
                                                        image: DecorationImage(
                                                            image: NetworkImage(communitiesVariables
                                                                .communityHomeList.value.trendingData[index].members[idx].avatar.value))),
                                                  ),
                                                )),
                                      ),
                                    ),
                                    Text(
                                      "+${communitiesVariables.communityHomeList.value.trendingData[index].members.length}",
                                      style: TextStyle(
                                          fontSize: communitiesVariables.isSeeAllViewEnabled.value ? text.scale(12) : text.scale(8),
                                          color: const Color(0XFFB3B3B3),
                                          fontWeight: FontWeight.w500),
                                    ),
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
                Text(
                  communitiesVariables.communityHomeList.value.trendingData[index].about.value,
                  style: TextStyle(
                      fontSize: communitiesVariables.isSeeAllViewEnabled.value ? text.scale(12) : text.scale(8),
                      fontWeight: FontWeight.w500,
                      color: const Color(0XFFB3B3B3)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ));
  }

  Widget listCard({
    required BuildContext context,
    required StateSetter modelSetState,
    required int index,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      height: height / 10.825,
      width: width,
      margin: EdgeInsets.only(top: height / 57.73, left: width / 205.5, right: width / 205.5),
      padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.onBackground,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: height / 13.32,
              width: width / 6.32,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.background,
                  image: DecorationImage(
                    image: NetworkImage(communitiesVariables.communityHomeList.value.communityListData[index].file.isEmpty
                        ? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png"
                        : communitiesVariables.communityHomeList.value.communityListData[index].file[0].file.value),
                    fit: BoxFit.fill,
                  )),
            ),
            SizedBox(
              width: width / 27.4,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width / 2.055,
                      child: Text(
                        communitiesVariables.communityHomeList.value.communityListData[index].name.value,
                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: height / 288.6,
                    ),
                    SizedBox(
                      width: width / 1.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          communitiesVariables.communityHomeList.value.communityListData[index].newPost.value == 0
                              ? const SizedBox()
                              : Container(
                                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 433),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0XFFFF6813), width: 0.5),
                                  ),
                                  child: Text(
                                    "${communitiesVariables.communityHomeList.value.communityListData[index].newPost} New Posts",
                                    style: TextStyle(fontSize: text.scale(8), color: const Color(0XFFFF6813), fontWeight: FontWeight.w500),
                                  ),
                                ),
                          Text(
                            communitiesVariables.communityHomeList.value.communityListData[index].lastPosted.value,
                            style: TextStyle(fontSize: text.scale(10), color: const Color(0XFF7D7D7D), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                InkWell(
                    onTap: () {
                      if (userIdMain == communitiesVariables.communityHomeList.value.communityListData[index].userId.value) {
                        editOrDeleteBottomSheet(
                          context: context,
                          communityId: communitiesVariables.communityHomeList.value.communityListData[index].communityId.value,
                          list: 'community',
                          index: index,
                          type: "community",
                          postId: '',
                        );
                      } else {
                        blockOrReportBottomSheet(
                          context: context,
                          modelSetState: modelSetState,
                          communityId: communitiesVariables.communityHomeList.value.communityListData[index].communityId.value,
                          postId: "",
                          userId: communitiesVariables.communityHomeList.value.communityListData[index].userId.value,
                          list: 'community',
                          index: index,
                          type: "community",
                        );
                      }
                    },
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 15,
                    ))
              ],
            ))
          ],
        ),
      ),
    );
  }

  communityCreationBottomSheet({
    required BuildContext context,
    required bool isEditing,
    required String communityId,
  }) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context) {
          return CommunityCreationPage(isEditing: isEditing, communityId: communityId);
        });
  }

  blockOrReportBottomSheet(
      {required BuildContext context,
      required StateSetter modelSetState,
      required String communityId,
      required String postId,
      String? responseId,
      required String userId,
      required String list,
      required String type,
      required int index}) {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  mainVariables.actionValueMain = "Block";
                  mainVariables.barController.clear();
                  blockOrReportCommunityDialog(
                      context: context,
                      modelSetState: modelSetState,
                      communityId: communityId,
                      postId: postId,
                      type: type,
                      userId: userId,
                      list: list,
                      responseId: responseId,
                      index: index);
                },
                minLeadingWidth: width / 25,
                title: Text(
                  "Block Community",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                ),
                leading: const Icon(
                  Icons.flag,
                  size: 20,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  mainVariables.actionValueMain = "Report";
                  mainVariables.barController.clear();
                  blockOrReportCommunityDialog(
                    context: context,
                    modelSetState: modelSetState,
                    communityId: communityId,
                    postId: postId,
                    type: type,
                    userId: userId,
                    list: list,
                    responseId: responseId,
                    index: index,
                  );
                },
                minLeadingWidth: width / 25,
                title: Text(
                  "Report Community",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                ),
                leading: const Icon(
                  Icons.shield,
                  size: 20,
                ),
              )
            ],
          );
        });
  }

  editOrDeleteBottomSheet({
    required BuildContext context,
    required String communityId,
    required String postId,
    String? responseId,
    required String list,
    required int index,
    required String type, //post,community
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
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  if (type == "post") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => CommunitiesPostPage(
                                  communityId: communityId,
                                  postDetails: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index],
                                )));
                  } else if (type == "response") {
                    communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].isEditing.value = true;
                  } else {
                    communitiesPageWidgets.communityCreationBottomSheet(
                      context: context,
                      isEditing: true,
                      communityId: communityId,
                    );
                  }
                },
                minLeadingWidth: width / 25,
                title: Text(
                  "Edit Community",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                ),
                leading: const Icon(
                  Icons.edit,
                  size: 20,
                ),
              ),
              ListTile(
                onTap: () async {
                  Navigator.pop(context);
                  if (type == "post") {
                    Map<String, dynamic> data = await communitiesFunctions.getCommunityPostDelete(postId: postId);
                    if (data["status"]) {
                      communitiesVariables.communitiesPageInitialData.value.communityData.postContents.removeAt(index);
                      communitiesVariables.communitiesPageInitialData.value.communityData.postContents.refresh();
                    }
                  } else if (type == "response") {
                    Map<String, dynamic> data = await communitiesFunctions.getCommunityPostResponseDelete(responseId: responseId ?? "");
                    if (data["status"]) {
                      communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList.removeAt(index);
                      communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList.refresh();
                    }
                  } else {
                    communitiesWidgets.deleteBottomSheet(context: context, list: list, index: index);
                  }
                },
                minLeadingWidth: width / 25,
                title: Text(
                  "Delete Community",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                ),
                leading: const Icon(
                  Icons.delete,
                  size: 20,
                ),
              )
            ],
          );
        });
  }

  blockOrReportCommunityDialog(
      {required BuildContext context,
      required StateSetter modelSetState,
      required String communityId,
      required String postId,
      String? responseId,
      required String type,
      required String userId,
      required String list,
      required int index}) {
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
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.clear,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 108.25,
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
                                  contentPadding: EdgeInsets.only(left: width / 27.4),
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
                                  contentPadding: EdgeInsets.only(left: width / 27.4),
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
                      if (mainVariables.whyValueMain == "Other" && mainVariables.barController.text == "") {
                        Flushbar(
                          message: "Please describe the reason in the description ",
                          duration: const Duration(seconds: 2),
                        ).show(context);
                      } else {
                        Navigator.pop(context);
                        logEventFunc(name: mainVariables.actionValueMain == "Report" ? 'Reported_Post' : 'Blocked_Post', type: 'Community');
                        if (responseId == null) {
                          if (type == "post") {
                            communitiesFunctions.getCommunityPostBlockOrReport(
                              action: mainVariables.actionValueMain,
                              why: mainVariables.whyValueMain,
                              description: mainVariables.barController.text,
                              communityId: communityId,
                              postId: postId,
                              userId: userId,
                              list: list,
                              index: index,
                            );
                          } else {
                            communitiesFunctions.getCommunityBlockOrReport(
                              action: mainVariables.actionValueMain,
                              why: mainVariables.whyValueMain,
                              description: mainVariables.barController.text,
                              communityId: communityId,
                              userId: userId,
                              list: list,
                              index: index,
                            );
                          }
                        } else {
                          communitiesFunctions.getCommunityPostResponseBlockOrReport(
                            action: mainVariables.actionValueMain,
                            why: mainVariables.whyValueMain,
                            description: mainVariables.barController.text,
                            communityId: communityId,
                            postId: postId,
                            userId: userId,
                            list: list,
                            index: index,
                            responseId: responseId,
                          );
                        }
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
}
