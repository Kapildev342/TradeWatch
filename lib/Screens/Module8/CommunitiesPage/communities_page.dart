import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/communities_page_initial_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesPage/view_analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module8/MembersPage/members_page.dart';
import 'package:tradewatchfinal/Screens/Module8/Payment/plan_choosing_page.dart';

import 'communities_post_page.dart';

class CommunitiesPage extends StatefulWidget {
  final String communityId;

  const CommunitiesPage({super.key, required this.communityId});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  bool loader = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    communitiesVariables.communitiesPageInitialData.value = CommunitiesPageInitialModel.fromJson({});
    communitiesVariables.communitiesPostSortValue.value = 0;
    communitiesVariables.communitiesPostList = null;
    await communitiesFunctions.getCommunityPostList(communityId: widget.communityId, skipCount: 0, sortType: 'Recent');
    communitiesVariables.communitiesDetail = null;
    await communitiesFunctions.getCommunityDetails(communityId: widget.communityId);
    communitiesVariables.communitiesMembersList = null;
    await communitiesFunctions.getCommunityMemberList(communityId: widget.communityId, skipCount: 0, limit: 3);
    communitiesVariables.communitiesPostRequestList = null;
    if (communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "member" ||
        communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "") {
      debugPrint("role is not a admin or subadmin");
    } else {
      await communitiesFunctions.getCommunityPostRequestList(communityId: widget.communityId, skipCount: 0, limit: 3);
    }
    await setData();
    setState(() {
      loader = true;
    });
  }

  setData() async {
    communitiesVariables.communitiesPageInitialData.value.communityData.image.value =
        communitiesVariables.communitiesDetail!.value.response.file.isEmpty
            ? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png"
            : communitiesVariables.communitiesDetail!.value.response.file[0].file.value;
    communitiesVariables.communitiesPageInitialData.value.communityData.isDetailShown.value = false;
    communitiesVariables.communitiesPageInitialData.value.communityData.name.value = communitiesVariables.communitiesDetail!.value.response.name;
    communitiesVariables.communitiesPageInitialData.value.communityData.code.value = communitiesVariables.communitiesDetail!.value.response.code;
    communitiesVariables.communitiesPageInitialData.value.communityData.membersList.value =
        communitiesVariables.communitiesMembersList!.value.response;
    communitiesVariables.communitiesPageInitialData.value.communityData.isPaidSubscription.value =
        communitiesVariables.communitiesDetail!.value.response.subscription == "Paid";
    communitiesVariables.communitiesPageInitialData.value.communityData.about.value = communitiesVariables.communitiesDetail!.value.response.about;
    communitiesVariables.communitiesPageInitialData.value.communityData.roles.value = [];
    communitiesVariables.communitiesPageInitialData.value.communityData.roles.value = communitiesVariables.communitiesDetail!.value.response.admins;
    for (int i = 0; i < communitiesVariables.communitiesPageInitialData.value.communityData.roles.length; i++) {
      if (communitiesVariables.communitiesPageInitialData.value.communityData.roles[i].role.value == "admin") {
        communitiesVariables.communitiesPageInitialData.value.communityData.adminsList
            .add(communitiesVariables.communitiesPageInitialData.value.communityData.roles[i]);
      } else if (communitiesVariables.communitiesPageInitialData.value.communityData.roles[i].role.value == "subadmin") {
        communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList
            .add(communitiesVariables.communitiesPageInitialData.value.communityData.roles[i]);
      } else if (communitiesVariables.communitiesPageInitialData.value.communityData.roles[i].role.value == "moderator") {
        communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList
            .add(communitiesVariables.communitiesPageInitialData.value.communityData.roles[i]);
      } else {}
    }
    /*for (int i = 0; i < communitiesVariables.communitiesDetail!.value.response.admins.length; i++) {
      communitiesVariables.communitiesPageInitialData.value.communityData.roles.add(communitiesVariables.communitiesDetail!.value.response.admins[i]);
    }
    for (int i = 0; i < communitiesVariables.communitiesDetail!.value.response.subAdmins.length; i++) {
      communitiesVariables.communitiesPageInitialData.value.communityData.roles
          .add(communitiesVariables.communitiesDetail!.value.response.subAdmins[i]);
    }
    for (int i = 0; i < communitiesVariables.communitiesDetail!.value.response.moderators.length; i++) {
      communitiesVariables.communitiesPageInitialData.value.communityData.roles
          .add(communitiesVariables.communitiesDetail!.value.response.moderators[i]);
    }*/
    communitiesVariables.communitiesPageInitialData.value.communityData.totalMembers.value = [];
    communitiesVariables.communitiesPageInitialData.value.communityData.totalMembers
        .addAll(communitiesVariables.communitiesPageInitialData.value.communityData.roles);
    communitiesVariables.communitiesPageInitialData.value.communityData.totalMembers
        .addAll(communitiesVariables.communitiesPageInitialData.value.communityData.membersList);
    communitiesVariables.communitiesPageInitialData.value.communityData.creationDate.value =
        communitiesVariables.communitiesDetail!.value.response.createdAt;
    communitiesVariables.communitiesPageInitialData.value.communityData.averagePost.value =
        communitiesVariables.communitiesDetail!.value.response.avgPost.toString();
    communitiesVariables.communitiesPageInitialData.value.communityData.category.value =
        communitiesVariables.communitiesDetail!.value.response.category;
    communitiesVariables.communitiesPageInitialData.value.communityData.rules.value = communitiesVariables.communitiesDetail!.value.response.rules;
    communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.value =
        communitiesVariables.communitiesPostRequestList == null ? [] : communitiesVariables.communitiesPostRequestList!.value.response;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value) {
          communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          //backgroundColor: const Color(0XFFFFFFFF),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: loader
              ? Obx(
                  () => Stack(
                    children: [
                      communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value
                          ? const SizedBox()
                          : Container(
                              height: height / 4.02,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('lib/Constants/Assets/NewAssets/CommunitiesScreen/profile_background.png'),
                                      fit: BoxFit.fill)),
                            ),
                      Column(
                        children: [
                          communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value
                              ? Container(
                                  width: width,
                                  height: height / 14.43,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                    image: AssetImage("lib/Constants/Assets/Settings/coverImage_default.png"),
                                    fit: BoxFit.fill,
                                  )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            if (communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value) {
                                              communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value = false;
                                              FocusManager.instance.primaryFocus?.unfocus();
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          )),
                                      Container(
                                        height: height / 17.32,
                                        width: width / 8.22,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(communitiesVariables.communitiesPageInitialData.value.communityData.image.value),
                                                fit: BoxFit.fill)),
                                      ),
                                      SizedBox(
                                        width: width / 27.4,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              communitiesVariables.communitiesPageInitialData.value.communityData.name.value,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: text.scale(14),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: height / 173.2,
                                            ),
                                            Text(
                                              communitiesVariables.communitiesPageInitialData.value.communityData.code.value,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: text.scale(12),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: width / 82.2,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: communitiesVariables.communitiesPageInitialData.value.communityData.totalMembers.length >= 3
                                                ? width / 41.1
                                                : width /
                                                    8.22 /
                                                    communitiesVariables.communitiesPageInitialData.value.communityData.totalMembers.length),
                                        child: communitiesWidgets.membersLabelOrJoinButton(
                                          context: context,
                                          type: communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          communitiesWidgets.bottomSheet(context: context, modelSetState: setState, communityId: widget.communityId);
                                        },
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            )),
                                        IconButton(
                                          onPressed: () {
                                            communitiesWidgets.bottomSheet(
                                                context: context, modelSetState: setState, communityId: widget.communityId);
                                          },
                                          icon: const Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                    Center(
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            NetworkImage(communitiesVariables.communitiesPageInitialData.value.communityData.image.value),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height / 173.2,
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: width / 6.85),
                                      padding: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Theme.of(context).colorScheme.onBackground,
                                          border: Border.all(color: Colors.black26.withOpacity(0.1))),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Obx(
                                                () => InkWell(
                                                  onTap: () {
                                                    communitiesVariables.communitiesPageInitialData.value.communityData.isDetailShown.toggle();
                                                  },
                                                  child: Transform.flip(
                                                    flipY: communitiesVariables.communitiesPageInitialData.value.communityData.isDetailShown.value,
                                                    child: Icon(
                                                      Icons.arrow_drop_down_circle_outlined,
                                                      size: 25,
                                                      color: communitiesVariables.communitiesPageInitialData.value.communityData.isDetailShown.value
                                                          ? const Color(0XFF0EA102)
                                                          : Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            communitiesVariables.communitiesPageInitialData.value.communityData.name.value,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            communitiesVariables.communitiesPageInitialData.value.communityData.code.value,
                                            style: TextStyle(
                                              fontSize: text.scale(10),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height / 108.25,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext context) => MembersPage(communityId: widget.communityId)));
                                                },
                                                child: Obx(
                                                  () => Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            communitiesVariables.communitiesPageInitialData.value.communityData.totalMembers.length >=
                                                                    3
                                                                ? width / 8.22
                                                                : communitiesVariables
                                                                        .communitiesPageInitialData.value.communityData.totalMembers.length *
                                                                    width /
                                                                    16.44,
                                                        height: height / 43.3,
                                                        child: Stack(
                                                          alignment: Alignment.centerRight,
                                                          children: List.generate(
                                                              communitiesVariables
                                                                          .communitiesPageInitialData.value.communityData.totalMembers.length >=
                                                                      3
                                                                  ? 3
                                                                  : communitiesVariables
                                                                      .communitiesPageInitialData.value.communityData.totalMembers.length,
                                                              (idx) => Positioned(
                                                                    left: idx * (15),
                                                                    top: 0,
                                                                    child: Container(
                                                                      height: height / 43.3,
                                                                      width: width / 20.55,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: const Color(0XFF0EA102),
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(communitiesVariables.communitiesPageInitialData
                                                                                  .value.communityData.totalMembers[idx].avatar.value))),
                                                                    ),
                                                                  )),
                                                        ),
                                                      ),
                                                      Text(
                                                        "+${communitiesVariables.communitiesPageInitialData.value.communityData.totalMembers.length}",
                                                        style: TextStyle(
                                                            fontSize: text.scale(8), color: const Color(0XFFB3B3B3), fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              communitiesWidgets.membersLabelOrJoinButton(
                                                context: context,
                                                type: communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  logEventFunc(name: "Share", type: "Community");
                                                  Uri newLink = await communitiesFunctions.getCommunityLinK(
                                                    id: widget.communityId,
                                                    type: "communitiesPage",
                                                    title: communitiesVariables.communitiesPageInitialData.value.communityData.name.value,
                                                    imageUrl: communitiesVariables.communitiesPageInitialData.value.communityData.image.value,
                                                    description: communitiesVariables.communitiesPageInitialData.value.communityData.about.value,
                                                  );
                                                  await Share.share(
                                                    "Look what I was able to find on Tradewatch: ${communitiesVariables.communitiesPageInitialData.value.communityData.name.value} ${newLink.toString()}",
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(left: width / 10.275, right: width / 27.4),
                                                  child: SvgPicture.asset(
                                                    "lib/Constants/Assets/NewAssets/CommunitiesScreen/invite.svg",
                                                    height: height / 34.64,
                                                    width: width / 16.44,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height / 108.25,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                          SizedBox(
                            height: height / 57.73,
                          ),
                          Expanded(
                            child: Container(
                              width: width,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26.withOpacity(0.1), offset: const Offset(0.0, 0.0), blurRadius: 1.0, spreadRadius: 1.0)
                                  ]),
                              clipBehavior: Clip.none,
                              child: Obx(
                                () => communitiesVariables.communitiesPageInitialData.value.communityData.isDetailShown.value
                                    ? communitiesWidgets.detailsPage(context: context, modelSetState: setState, communityId: widget.communityId)
                                    : communitiesWidgets.contentPage(context: context, modelSetState: setState, communityId: widget.communityId),
                              ),
                            ),
                          ),
                          Container(
                            width: width,
                            color: Theme.of(context).colorScheme.onBackground,
                            child: Center(
                              child: SizedBox(
                                width: width / 2.5,
                                child: communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "admin"
                                    ? communitiesVariables.communitiesPageInitialData.value.communityData.isDetailShown.value
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFF3A98B9)),
                                            onPressed: () {
                                              Navigator.push(
                                                  context, MaterialPageRoute(builder: (BuildContext context) => const ViewAnalyticsPage()));
                                            },
                                            child: const Text(
                                              "View Analytics",
                                              style: TextStyle(color: Colors.white),
                                            ))
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFF4942E4)),
                                            onPressed: () async {
                                              logEventFunc(name: "Share", type: "Community");
                                              var newLink = await communitiesFunctions.getCommunityLinK(
                                                id: widget.communityId,
                                                type: "community",
                                                title: communitiesVariables.communitiesPageInitialData.value.communityData.name.value,
                                                imageUrl: communitiesVariables.communitiesPageInitialData.value.communityData.image.value,
                                                description: communitiesVariables.communitiesPageInitialData.value.communityData.about.value,
                                              );
                                              await Share.share(
                                                "Look what I was able to find on Tradewatch: ${communitiesVariables.communitiesPageInitialData.value.communityData.name.value} ${newLink.toString()}",
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "lib/Constants/Assets/NewAssets/CommunitiesScreen/invite_white.svg",
                                                  height: height / 57.73,
                                                  width: width / 27.4,
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox(
                                                  width: width / 51.375,
                                                ),
                                                const Text(
                                                  "Invite friends",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          )
                                    : communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "subadmin" ||
                                            communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "moderator"
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFF4942E4)),
                                            onPressed: () async {
                                              logEventFunc(name: "Share", type: "Community");
                                              var newLink = await communitiesFunctions.getCommunityLinK(
                                                id: widget.communityId,
                                                type: "community",
                                                title: communitiesVariables.communitiesPageInitialData.value.communityData.name.value,
                                                imageUrl: communitiesVariables.communitiesPageInitialData.value.communityData.image.value,
                                                description: communitiesVariables.communitiesPageInitialData.value.communityData.about.value,
                                              );
                                              await Share.share(
                                                "Look what I was able to find on Tradewatch: ${communitiesVariables.communitiesPageInitialData.value.communityData.name.value} ${newLink.toString()}",
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "lib/Constants/Assets/NewAssets/CommunitiesScreen/invite_white.svg",
                                                  height: height / 57.73,
                                                  width: width / 27.4,
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox(
                                                  width: width / 51.375,
                                                ),
                                                const Text(
                                                  "Invite friends",
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ],
                                            ))
                                        : communitiesVariables.communitiesPageInitialData.value.communityData.isJoined.value
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFF4942E4)),
                                                onPressed: () async {
                                                  logEventFunc(name: "Share", type: "Community");
                                                  var newLink = await communitiesFunctions.getCommunityLinK(
                                                    id: widget.communityId,
                                                    type: "community",
                                                    title: communitiesVariables.communitiesPageInitialData.value.communityData.name.value,
                                                    imageUrl: communitiesVariables.communitiesPageInitialData.value.communityData.image.value,
                                                    description: communitiesVariables.communitiesPageInitialData.value.communityData.about.value,
                                                  );
                                                  await Share.share(
                                                    "Look what I was able to find on Tradewatch: ${communitiesVariables.communitiesPageInitialData.value.communityData.name.value} ${newLink.toString()}",
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "lib/Constants/Assets/NewAssets/CommunitiesScreen/invite_white.svg",
                                                      height: height / 57.73,
                                                      width: width / 27.4,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    SizedBox(
                                                      width: width / 51.375,
                                                    ),
                                                    const Text(
                                                      "Invite friends",
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ],
                                                ))
                                            : GestureDetector(
                                                onTap: () {
                                                  communitiesVariables.communitiesPageInitialData.value.communityData.isPaidSubscription.value
                                                      ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                          return const PlanChoosingPage();
                                                        }))
                                                      : communitiesFunctions.joinCommunity(communityId: widget.communityId);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                                                  padding: EdgeInsets.symmetric(vertical: height / 173.2),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6),
                                                      gradient: RadialGradient(
                                                          radius: 3,
                                                          colors: communitiesVariables
                                                                  .communitiesPageInitialData.value.communityData.isPaidSubscription.value
                                                              ? [const Color(0XFFEDA130), const Color(0XFFFFD361)]
                                                              : [const Color(0XFF0EA102), const Color(0XFF0EA102)])),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      communitiesVariables.communitiesPageInitialData.value.communityData.isPaidSubscription.value
                                                          ? Padding(
                                                              padding: EdgeInsets.only(bottom: height / 108.25),
                                                              child: SvgPicture.asset(
                                                                "lib/Constants/Assets/NewAssets/CommunitiesScreen/subscribe_crown.svg",
                                                                height: height / 34.64,
                                                                width: width / 16.44,
                                                                fit: BoxFit.fill,
                                                              ),
                                                            )
                                                          : const Icon(
                                                              Icons.add_circle,
                                                              color: Colors.white,
                                                              size: 15,
                                                            ),
                                                      SizedBox(
                                                        width: width / 51.375,
                                                      ),
                                                      Text(
                                                        communitiesVariables.communitiesPageInitialData.value.communityData.isPaidSubscription.value
                                                            ? "Subscribe"
                                                            : "Join now",
                                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
                ),
          floatingActionButton: communitiesVariables.communitiesPageInitialData.value.communityData.isJoined.value
              ? Padding(
                  padding: EdgeInsets.only(bottom: height / 21.65),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return CommunitiesPostPage(
                          communityId: widget.communityId,
                        );
                      }));
                    },
                    child: SvgPicture.asset("lib/Constants/Assets/NewAssets/CommunitiesScreen/edit_pencil.svg"),
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
