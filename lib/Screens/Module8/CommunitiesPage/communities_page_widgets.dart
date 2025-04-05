import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationFunctions/conversation_widgets.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesPage/focused_menu_post.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunityDescription/community_description_page.dart';
import 'package:tradewatchfinal/Screens/Module8/MembersPage/members_page.dart';

import 'communitiesCommentsBottomSheetPage.dart';

class CommunitiesPageWidgets {
  bottomSheet({
    required BuildContext context,
    required StateSetter modelSetState,
    required String communityId,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return MembersPage(communityId: communityId);
                      }));
                    },
                    minLeadingWidth: width / 25,
                    leading: SvgPicture.asset(
                      "lib/Constants/Assets/NewAssets/CommunitiesScreen/members.svg",
                      height: height / 43.3,
                      width: width / 20.55,
                      fit: BoxFit.fill,
                    ),
                    title: Text(
                      "Members",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      logEventFunc(name: "Share", type: "Community");
                      Uri newLink = await communitiesFunctions.getCommunityLinK(
                        id: communityId,
                        type: "communitiesPage",
                        title: communitiesVariables.communitiesPageInitialData.value.communityData.name.value,
                        imageUrl: communitiesVariables.communitiesPageInitialData.value.communityData.image.value,
                        description: communitiesVariables.communitiesPageInitialData.value.communityData.about.value,
                      );
                      await Share.share(
                        "Look what I was able to find on Tradewatch: ${communitiesVariables.communitiesPageInitialData.value.communityData.name.value} ${newLink.toString()}",
                      );
                    },
                    minLeadingWidth: width / 25,
                    leading: SvgPicture.asset(
                      "lib/Constants/Assets/NewAssets/CommunitiesScreen/invite_friends.svg",
                      height: height / 43.3,
                      width: width / 20.55,
                      fit: BoxFit.fill,
                    ),
                    title: Text(
                      "Invite friends",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Feature will released later")));
                    },
                    minLeadingWidth: width / 25,
                    leading: SvgPicture.asset(
                      "lib/Constants/Assets/NewAssets/CommunitiesScreen/clear_chat.svg",
                      height: height / 43.3,
                      width: width / 20.55,
                      fit: BoxFit.fill,
                    ),
                    title: Text(
                      "ClearChat",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  /*ListTile(
                    onTap: () async {
                    },
                    minLeadingWidth: width / 25,
                    leading: SvgPicture.asset(
                      "lib/Constants/Assets/NewAssets/CommunitiesScreen/report_shield.svg",
                      height: height / 43.3,
                      width: width / 20.55,
                      fit: BoxFit.fill,
                    ),
                    title: Text(
                      "Report community",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () {

                    },
                    minLeadingWidth: width / 25,
                    leading: SvgPicture.asset(
                      "lib/Constants/Assets/NewAssets/CommunitiesScreen/block_flag.svg",
                      height: height / 43.3,
                      width: width / 20.55,
                      fit: BoxFit.fill,
                    ),
                    title: Text(
                      "Block community",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),*/
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      //communitiesVariables.isAdminChanged.value = false;
                      communitiesVariables.checkValue.value = false;
                      communitiesVariables.makeAdminPerson.value = "";
                      exitBottomSheet(context: context, modelSetState: modelSetState, communityId: communityId);
                    },
                    minLeadingWidth: width / 25,
                    leading: SvgPicture.asset(
                      "lib/Constants/Assets/NewAssets/CommunitiesScreen/exit_image.svg",
                      height: height / 43.3,
                      width: width / 20.55,
                      fit: BoxFit.fill,
                    ),
                    title: Text(
                      "Exit Community",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  deleteBottomSheet({
    required BuildContext context,
    required String list,
    required int index,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("lib/Constants/Assets/NewAssets/CommunitiesScreen/delete_image.svg"),
                        SizedBox(
                          width: width / 27.4,
                        ),
                        Text(
                          "Delete Community ",
                          style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0XFF3C3C3C), fontSize: text.scale(18)),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          communitiesVariables.deleteCheckValue.value = false;
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
                SizedBox(height: height / 28.86),
                Center(
                  child: SvgPicture.asset("lib/Constants/Assets/NewAssets/CommunitiesScreen/delete_man_image.svg"),
                ),
                SizedBox(height: height / 28.86),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                  child: Obx(() => CheckboxListTile(
                        value: communitiesVariables.deleteCheckValue.value,
                        activeColor: const Color(0XFF0EA102),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          communitiesVariables.deleteCheckValue.toggle();
                        },
                        checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        title: Text(
                          "If you delete the content, it will be removed from the conversation.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0XFF202020),
                            fontSize: text.scale(10),
                          ),
                        ),
                      )),
                ),
                SizedBox(height: height / 57.73),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            communitiesVariables.deleteCheckValue.value = false;
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
                          )),
                      Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: communitiesVariables.deleteCheckValue.value ? const Color(0XFF0EA102) : Colors.grey.shade300,
                          ),
                          onPressed: communitiesVariables.deleteCheckValue.value
                              ? () {
                                  Navigator.pop(context);
                                  if (list == "trending") {
                                    communitiesVariables.communityHomeList.value.trendingData.removeAt(index);
                                    communitiesVariables.communityHomeList.value.trendingData.refresh();
                                  } else if (list == "community") {
                                    communitiesVariables.communityHomeList.value.communityListData.removeAt(index);
                                    communitiesVariables.communityHomeList.value.communityListData.refresh();
                                  } else if (list == "main") {
                                  } else {}
                                }
                              : () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 20.55),
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: communitiesVariables.deleteCheckValue.value ? Colors.white : Colors.black,
                              ),
                            ),
                          )))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  exitBottomSheet({
    required BuildContext context,
    required StateSetter modelSetState,
    required String communityId,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Exit Community ",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(18)),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          // communitiesVariables.isAdminChanged.value = false;
                          communitiesVariables.checkValue.value = false;
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
                SizedBox(height: height / 28.86),
                Center(
                  child: SvgPicture.asset("lib/Constants/Assets/NewAssets/CommunitiesScreen/running_out.svg"),
                ),
                SizedBox(height: height / 28.86),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                  child: Obx(() => CheckboxListTile(
                        value: communitiesVariables.checkValue.value,
                        activeColor: const Color(0XFF0EA102),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          communitiesVariables.checkValue.toggle();
                          modelSetState(() {});
                        },
                        checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        title: Text(
                          /*communitiesVariables.isAdminChanged.value
                              ? "Are you sure want to exit the community?"
                              : */
                          communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "admin"
                              ? "If you would like to exit the community, assign your Admin credentials to another user."
                              : "Are you sure want to exit the community?",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: text.scale(10),
                          ),
                        ),
                      )),
                ),
                SizedBox(height: height / 57.73),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            // communitiesVariables.isAdminChanged.value = false;
                            communitiesVariables.checkValue.value = false;
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          )),
                      Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: communitiesVariables.checkValue.value ? const Color(0XFF0EA102) : Colors.grey.shade300,
                          ),
                          onPressed: communitiesVariables.checkValue.value
                              ? () async {
                                  if (communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "admin") {
                                    /*communitiesVariables.isAdminChanged.value
                                        ? Navigator.pop(context)
                                        : */
                                    membersBottomSheet(context: context, modelSetState: modelSetState, communityId: communityId);
                                  } else {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    await communitiesFunctions.getMemberExit(communityId: communityId);
                                  }
                                }
                              : () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 20.55),
                            child: Text(
                              communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "admin"
                                  ? /*communitiesVariables.isAdminChanged.value
                                      ? "Exit"
                                      :*/
                                  "View members"
                                  : "Exit",
                              style: TextStyle(
                                color: communitiesVariables.checkValue.value ? Colors.white : Colors.black,
                              ),
                            ),
                          )))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  membersBottomSheet({
    required BuildContext context,
    required StateSetter modelSetState,
    required String communityId,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: height / 1.237,
            padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Members ",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(18)),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          // communitiesVariables.isAdminChanged.value = false;
                          communitiesVariables.checkValue.value = false;
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
                SizedBox(height: height / 57.73),
                Column(
                  children: [
                    ListView.builder(
                        itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.length,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Obx(() => RadioListTile<String>(
                                value: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].userId.value,
                                groupValue: communitiesVariables.makeAdminPerson.value,
                                onChanged: (value) {
                                  communitiesVariables.makeAdminPerson.value = value!;
                                  modelSetState(() {});
                                },
                                title: Text(
                                  communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].firstName.value,
                                  style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].username.value,
                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                                    Text("  |  ",
                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                                    InkWell(
                                      onTap: () {
                                        billboardWidgetsMain.believersTabBottomSheet(
                                          context: context,
                                          id: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].userId.value,
                                          isBelieversList: true,
                                        );
                                      },
                                      child: Text(
                                          "${communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].believersCount.value} Believers",
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                                    ),
                                  ],
                                ),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.trailing,
                                secondary: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].avatar.value),
                                ),
                              ));
                        }),
                    ListView.builder(
                        itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.length,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Obx(() => RadioListTile<String>(
                                value: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].userId.value,
                                groupValue: communitiesVariables.makeAdminPerson.value,
                                onChanged: (value) {
                                  communitiesVariables.makeAdminPerson.value = value!;
                                  modelSetState(() {});
                                },
                                title: Text(
                                  communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].firstName.value,
                                  style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].username.value,
                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                                    Text("  |  ",
                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                                    InkWell(
                                      onTap: () {
                                        billboardWidgetsMain.believersTabBottomSheet(
                                          context: context,
                                          id: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].userId.value,
                                          isBelieversList: true,
                                        );
                                      },
                                      child: Text(
                                          "${communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].believersCount.value} Believers",
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                                    ),
                                  ],
                                ),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.trailing,
                                secondary: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].avatar.value),
                                ),
                              ));
                        }),
                    ListView.builder(
                        itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.membersList.length,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Obx(() => RadioListTile(
                                value: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].userId.value,
                                groupValue: communitiesVariables.makeAdminPerson.value,
                                onChanged: (value) {
                                  communitiesVariables.makeAdminPerson.value = value!;
                                  modelSetState(() {});
                                },
                                title: Text(
                                  communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].firstName.value,
                                  style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].username.value,
                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                                    Text("  |  ",
                                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                                    InkWell(
                                      onTap: () {
                                        billboardWidgetsMain.believersTabBottomSheet(
                                          context: context,
                                          id: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].userId.value,
                                          isBelieversList: true,
                                        );
                                      },
                                      child: Text(
                                          "${communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].believersCount.value} Believers",
                                          style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                                    ),
                                  ],
                                ),
                                contentPadding: EdgeInsets.zero,
                                controlAffinity: ListTileControlAffinity.trailing,
                                secondary: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].avatar.value),
                                ),
                              ));
                        }),
                  ],
                ),
                SizedBox(height: height / 57.73),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 11.74),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            //communitiesVariables.isAdminChanged.value = false;
                            communitiesVariables.checkValue.value = false;
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            //communitiesVariables.isAdminChanged.toggle();
                            communitiesVariables.checkValue.value = false;
                            Navigator.pop(context);
                            await communitiesFunctions.getMemberUpdate(
                                userId: communitiesVariables.makeAdminPerson.value, communityId: communityId, role: "admin");
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: width / 20.55),
                            child: Text(
                              "Make as admin",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  postRequestBottomSheet({
    required BuildContext context,
    required String communityId,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height / 57.73,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Post Requests ",
                          style: TextStyle(fontWeight: FontWeight.w600, color: const Color(0XFF3C3C3C), fontSize: text.scale(18)),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          //  communitiesVariables.isAdminChanged.value = false;
                          communitiesVariables.checkValue.value = false;
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
              ),
              SizedBox(
                height: height / 57.73,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                child: getSearchField(context: context, communityId: communityId),
              ),
              SizedBox(
                height: height / 57.73,
              ),
              Obx(
                () => communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.isEmpty
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                                height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'No response to display...',
                                      style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: width,
                              child: ListTile(
                                leading: Container(
                                  height: height / 17.32,
                                  width: width / 8.22,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(communitiesVariables
                                              .communitiesPageInitialData.value.communityData.postRequests[index].files[0].file.value),
                                          fit: BoxFit.fill)),
                                ),
                                title: Text(
                                  communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].username.value,
                                  style: TextStyle(
                                    fontSize: text.scale(14),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].title.value.length > 65
                                      ? communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].title.value
                                          .substring(0, 65)
                                      : communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].title.value,
                                  style: TextStyle(
                                    fontSize: text.scale(10),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: SizedBox(
                                  height: height / 24.74,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFFF4C75F)),
                                    onPressed: () {
                                      postRequestDialog(context: context, index: index);
                                    },
                                    child: const Text("View"),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        });
  }

  Widget getSearchField({
    required BuildContext context,
    required String communityId,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => SizedBox(
          height: height / 21.65,
          child: TextFormField(
            controller: communitiesVariables.postRequestSearchController.value,
            onChanged: (value) async {
              await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Recent');
            },
            onTap: () {
              communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value = true;
            },
            onFieldSubmitted: (value) {
              communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value = false;
            },
            cursorColor: Colors.green,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.background,
                suffixIcon: communitiesVariables.postRequestSearchController.value.text.isEmpty
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () async {
                          communitiesVariables.postRequestSearchController.value.text = "";
                          await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Recent');
                          communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value = false;
                        },
                        child: Icon(Icons.cancel, size: 22, color: Theme.of(context).colorScheme.onPrimary),
                      ),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
                  child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                ),
                contentPadding: EdgeInsets.zero,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintStyle: TextStyle(color: const Color(0XFFA5A5A5), fontSize: text.scale(14), fontWeight: FontWeight.normal, fontFamily: "Poppins"),
                filled: true,
                hintText: 'Search here',
                errorStyle: TextStyle(fontSize: text.scale(10))),
          ),
        ));
  }

  Widget membersLabelOrJoinButton({
    required BuildContext context,
    required String type,
  }) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    switch (type) {
      case "admin":
        {
          return SizedBox(
              height: height / 34.64,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFF4942E4)),
                onPressed: () {},
                child: Text(
                  "Admin",
                  style: TextStyle(
                    fontSize: text.scale(12),
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ));
        }
      case "sub_admin":
        {
          return SizedBox(
              height: height / 34.64,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFF4942E4).withOpacity(0.7)),
                onPressed: () {},
                child: Text(
                  "Sub Admin",
                  style: TextStyle(
                    fontSize: text.scale(12),
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ));
        }
      case "moderator":
        {
          return SizedBox(
              height: height / 34.64,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFF8EC2FF)),
                onPressed: () {},
                child: Text(
                  "Moderator",
                  style: TextStyle(
                    fontSize: text.scale(12),
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ));
        }
      case "member":
        {
          return AnimatedCrossFade(
              firstChild: SizedBox(
                  height: height / 34.64,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0XFF0EA102)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        // communitiesVariables.communitiesPageInitialData.value.communityData.isJoined.toggle();
                      },
                      child: Text(
                        "Member",
                        style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0XFF0EA102)),
                      ))),
              secondChild: InkWell(
                  onTap: () async {
                    // communitiesVariables.communitiesPageInitialData.value.communityData.isJoined.toggle();
                  },
                  child: communitiesVariables.communitiesPageInitialData.value.communityData.isPaidSubscription.value
                      ? Container(
                          width: width / 5.13,
                          height: height / 34.64,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: const RadialGradient(radius: 3, colors: [Color(0XFFEDA130), Color(0XFFFFD361)])),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("lib/Constants/Assets/NewAssets/CommunitiesScreen/subscribe_crown.svg"),
                              SizedBox(
                                width: width / 68.5,
                              ),
                              Text(
                                "SubScribe",
                                style: TextStyle(fontSize: text.scale(10), color: const Color(0XFFFFFFFF), fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        )
                      : Container(
                          width: width / 5.13,
                          height: height / 34.64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0XFF0EA102),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(
                                width: width / 68.5,
                              ),
                              Text(
                                "Join now",
                                style: TextStyle(fontSize: text.scale(10), color: const Color(0XFFFFFFFF), fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        )),
              crossFadeState: communitiesVariables.communitiesPageInitialData.value.communityData.isJoined.value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 500));
        }
      default:
        {
          return AnimatedCrossFade(
              firstChild: SizedBox(
                  height: height / 34.64,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0XFF0EA102)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        communitiesVariables.communitiesPageInitialData.value.communityData.isJoined.toggle();
                      },
                      child: Text(
                        "Member",
                        style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: const Color(0XFF0EA102)),
                      ))),
              secondChild: InkWell(
                  onTap: () {
                    communitiesVariables.communitiesPageInitialData.value.communityData.isJoined.toggle();
                  },
                  child: communitiesVariables.communitiesPageInitialData.value.communityData.isPaidSubscription.value
                      ? Container(
                          width: width / 5.13,
                          height: height / 34.64,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: const RadialGradient(radius: 3, colors: [Color(0XFFEDA130), Color(0XFFFFD361)])),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("lib/Constants/Assets/NewAssets/CommunitiesScreen/subscribe_crown.svg"),
                              SizedBox(
                                width: width / 68.5,
                              ),
                              Text(
                                "SubScribe",
                                style: TextStyle(fontSize: text.scale(10), color: const Color(0XFFFFFFFF), fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        )
                      : Container(
                          width: width / 5.13,
                          height: height / 34.64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0XFF0EA102),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(
                                width: width / 68.5,
                              ),
                              Text(
                                "Join now",
                                style: TextStyle(fontSize: text.scale(10), color: const Color(0XFFFFFFFF), fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        )),
              crossFadeState: communitiesVariables.communitiesPageInitialData.value.communityData.isJoined.value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 500));
        }
    }
  }

  Widget contentPage({
    required BuildContext context,
    required String communityId,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return ListView(
      children: [
        SizedBox(height: height / 57.73),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 34.25),
          child: Row(
            children: [
              Expanded(child: getSearchField(context: context, communityId: communityId)),
              FocusedMenuHolder(
                menuWidth: width / 1.5,
                blurSize: 5,
                menuItemExtent: height / 21.65,
                duration: const Duration(milliseconds: 100),
                animateMenuItems: true,
                blurBackgroundColor: Colors.transparent,
                bottomOffsetHeight: height / 4.33,
                openWithTap: true,
                menuOffset: height / 43.3,
                onPressed: () {
                  return true;
                },
                menuItems: <FocusedMenuItem>[
                  FocusedMenuItem(
                    title: SizedBox(
                      width: width / 2.34,
                      child: Text(
                        "Recent",
                        style: TextStyle(fontSize: text.scale(14)),
                      ),
                    ),
                    trailingIcon: Obx(() => Radio<int>(
                          onChanged: (value) async {
                            communitiesVariables.communitiesPostSortValue.value = 0;
                            communitiesVariables.communitiesPostSortValue.refresh();
                            await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Recent');
                          },
                          value: 0,
                          groupValue: communitiesVariables.communitiesPostSortValue.value,
                        )),
                    onPressed: () async {
                      communitiesVariables.communitiesPostSortValue.value = 0;
                      communitiesVariables.communitiesPostSortValue.refresh();
                      await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Recent');
                    },
                  ),
                  FocusedMenuItem(
                    title: SizedBox(
                      width: width / 2.34,
                      child: Text(
                        "Most Liked",
                        style: TextStyle(fontSize: text.scale(14)),
                      ),
                    ),
                    trailingIcon: Obx(() => Radio<int>(
                          onChanged: (value) async {
                            communitiesVariables.communitiesPostSortValue.value = 1;
                            communitiesVariables.communitiesPostSortValue.refresh();
                            await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Liked');
                          },
                          value: 1,
                          groupValue: communitiesVariables.communitiesPostSortValue.value,
                        )),
                    onPressed: () async {
                      communitiesVariables.communitiesPostSortValue.value = 1;
                      communitiesVariables.communitiesPostSortValue.refresh();
                      await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Liked');
                    },
                  ),
                  FocusedMenuItem(
                    title: SizedBox(
                      width: width / 2.34,
                      child: Text(
                        "Most Disliked",
                        style: TextStyle(fontSize: text.scale(14)),
                      ),
                    ),
                    trailingIcon: Obx(() => Radio<int>(
                          onChanged: (value) async {
                            communitiesVariables.communitiesPostSortValue.value = 2;
                            communitiesVariables.communitiesPostSortValue.refresh();
                            await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Disliked');
                          },
                          value: 2,
                          groupValue: communitiesVariables.communitiesPostSortValue.value,
                        )),
                    onPressed: () async {
                      communitiesVariables.communitiesPostSortValue.value = 2;
                      communitiesVariables.communitiesPostSortValue.refresh();
                      await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Disliked');
                    },
                  ),
                  FocusedMenuItem(
                      title: SizedBox(
                        width: width / 2.34,
                        child: Text(
                          "Most Responsed",
                          style: TextStyle(fontSize: text.scale(14)),
                        ),
                      ),
                      trailingIcon: Obx(() => Radio<int>(
                            onChanged: (value) async {
                              communitiesVariables.communitiesPostSortValue.value = 3;
                              communitiesVariables.communitiesPostSortValue.refresh();
                              await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Responsed');
                            },
                            value: 3,
                            groupValue: communitiesVariables.communitiesPostSortValue.value,
                          )),
                      onPressed: () async {
                        communitiesVariables.communitiesPostSortValue.value = 3;
                        communitiesVariables.communitiesPostSortValue.refresh();
                        await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Responsed');
                      }),
                  FocusedMenuItem(
                      title: SizedBox(
                        width: width / 2.34,
                        child: Text(
                          "Most Shared",
                          style: TextStyle(fontSize: text.scale(14)),
                        ),
                      ),
                      trailingIcon: Obx(() => Radio<int>(
                            onChanged: (value) async {
                              communitiesVariables.communitiesPostSortValue.value = 4;
                              communitiesVariables.communitiesPostSortValue.refresh();
                              await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Shared');
                            },
                            value: 4,
                            groupValue: communitiesVariables.communitiesPostSortValue.value,
                          )),
                      onPressed: () async {
                        communitiesVariables.communitiesPostSortValue.value = 4;
                        communitiesVariables.communitiesPostSortValue.refresh();
                        await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Shared');
                      }),
                ],
                isMe: true,
                child: SizedBox(
                  width: width / 5.48,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "lib/Constants/Assets/SMLogos/Frame 162.svg",
                        height: height / 54.13,
                        width: width / 18.25,
                        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: width / 137,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sort",
                            style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          SizedBox(width: width / 205.5),
                          Container(
                            height: height / 173.2,
                            width: width / 82.2,
                            decoration: const BoxDecoration(
                              color: Color(0XFF0EA102),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height / 57.73),
        communitiesVariables.communitiesPageInitialData.value.communityData.postContents.isEmpty
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: height / 5.77,
                      width: width / 2.74,
                      child: SvgPicture.asset(
                        "lib/Constants/Assets/SMLogos/no respone.svg",
                      ),
                    ),
                    SizedBox(
                      height: height / 86.6,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'No response to display...',
                              style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : postContentList(context: context, modelSetState: modelSetState, communityId: communityId),
      ],
    );
  }

  Widget detailsPage({
    required BuildContext context,
    required StateSetter modelSetState,
    required String communityId,
  }) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return ListView(
      children: [
        SizedBox(height: height / 57.73),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20.55),
          child: Text(
            "About",
            style: TextStyle(
              fontSize: text.scale(14),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: height / 86.6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20.55),
          child: Text(
            communitiesVariables.communitiesPageInitialData.value.communityData.about.value,
            style: TextStyle(
              fontSize: text.scale(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: height / 86.6),
        const Divider(
          thickness: 1.5,
        ),
        SizedBox(height: height / 86.6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20.55),
          child: Text(
            "Roles",
            style: TextStyle(
              fontSize: text.scale(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: height / 86.6),
        rolesWidget(context: context),
        SizedBox(height: height / 86.6),
        const Divider(
          thickness: 1.5,
        ),
        SizedBox(height: height / 86.6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20.55),
          child: Text(
            "Creation Date",
            style: TextStyle(
              fontSize: text.scale(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: height / 86.6),
        Row(
          children: [
            Container(
                width: width / 4.11,
                margin: EdgeInsets.symmetric(horizontal: width / 20.55),
                padding: EdgeInsets.symmetric(vertical: height / 144.3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
                child: Center(
                  child: Text(
                    communitiesVariables.communitiesPageInitialData.value.communityData.creationDate.value,
                    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                )),
          ],
        ),
        SizedBox(height: height / 57.73),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20.55),
          child: Text(
            "Average Number of Post / day",
            style: TextStyle(
              fontSize: text.scale(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: height / 86.6),
        Row(
          children: [
            Container(
                width: width / 5.13,
                margin: EdgeInsets.symmetric(horizontal: width / 20.55),
                padding: EdgeInsets.symmetric(vertical: height / 144.3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0XFF3E3E3E),
                ),
                child: Center(
                  child: Text(
                    "${communitiesVariables.communitiesPageInitialData.value.communityData.averagePost.value} Posts",
                    style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                )),
          ],
        ),
        SizedBox(height: height / 57.73),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20.55),
          child: Text(
            "Content Labels",
            style: TextStyle(
              fontSize: text.scale(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: height / 86.6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 27.4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 173.2),
                  decoration: BoxDecoration(color: const Color(0XFF0EA102), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    communitiesVariables.communitiesPageInitialData.value.communityData.category.value.capitalizeFirst!,
                    style: TextStyle(fontSize: text.scale(13), color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: width / 41.1,
              ),
              InkWell(
                  onTap: () {},
                  child: Text(
                    "more details +",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: text.scale(10),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic),
                  ))
            ],
          ),
        ),
        SizedBox(height: height / 86.6),
        const Divider(
          thickness: 1.5,
        ),
        SizedBox(height: height / 86.6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20.55),
          child: Text(
            "Rules",
            style: TextStyle(
              fontSize: text.scale(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: height / 86.6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20.55),
          child: Text(
            communitiesVariables.communitiesPageInitialData.value.communityData.rules.value,
            style: TextStyle(
              fontSize: text.scale(14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: height / 86.6),
        const Divider(
          thickness: 1.5,
        ),
        SizedBox(height: height / 86.6),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20.55),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Members",
                style: TextStyle(
                  fontSize: text.scale(16),
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return MembersPage(
                      communityId: communityId,
                    );
                  }));
                },
                child: Text(
                  "See all",
                  style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600, color: const Color(0XFFB3B3B3)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height / 86.6),
        communitiesVariables.communitiesPageInitialData.value.communityData.membersList.isEmpty
            ? Center(
                child: Column(
                  children: [
                    SizedBox(height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                    SizedBox(
                      height: height / 86.6,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'No response to display...',
                              style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 20.55),
                child: membersWidgets.membersCardList(context: context, modelSetState: modelSetState),
              ),
        SizedBox(height: height / 86.6),
        const Divider(
          thickness: 1.5,
        ),
        communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value != "member" &&
                communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.isNotEmpty
            ? SizedBox(height: height / 86.6)
            : const SizedBox(),
        communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value != "member" &&
                communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 20.55),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Post Request",
                      style: TextStyle(
                        fontSize: text.scale(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await communitiesFunctions.getCommunityPostRequestList(communityId: communityId, skipCount: 0, limit: 10);
                        if (context.mounted) {
                          postRequestBottomSheet(context: context, communityId: communityId);
                        }
                      },
                      child: Text(
                        "See all",
                        style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w600, color: const Color(0XFFB3B3B3)),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value != "member" &&
                communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.isNotEmpty
            ? SizedBox(height: height / 86.6)
            : const SizedBox(),
        communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value != "member" &&
                communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.isNotEmpty
            ? postRequestWidget(context: context)
            : const SizedBox(),
        communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value != "member" &&
                communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.isNotEmpty
            ? SizedBox(height: height / 86.6)
            : const SizedBox(),
      ],
    );
  }

  Widget rolesWidget({required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.roles.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width / 20.55, vertical: height / 86.6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height / 17.32,
                width: width / 8.22,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                          communitiesVariables.communitiesPageInitialData.value.communityData.roles[index].avatar.value,
                        ),
                        fit: BoxFit.fill)),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 41.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            communitiesVariables.communitiesPageInitialData.value.communityData.roles[index].firstName.value,
                            style: TextStyle(
                              fontSize: text.scale(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          membersLabelOrJoinButton(
                              context: context, type: communitiesVariables.communitiesPageInitialData.value.communityData.roles[index].role.value),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width / 41.1),
                      child: Text(
                        communitiesVariables.communitiesPageInitialData.value.communityData.roles[index].about.value,
                        style: TextStyle(
                          fontSize: text.scale(10),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget postRequestWidget({required BuildContext context}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.length > 3
          ? 3
          : communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.length,
      itemBuilder: (BuildContext context, int index) {
        return Obx(() => SizedBox(
              width: width,
              child: ListTile(
                leading: Container(
                  height: height / 17.32,
                  width: width / 8.22,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].files.isEmpty
                              ? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png"
                              : communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].files[0].file.value),
                          fit: BoxFit.fill)),
                ),
                title: Text(
                  communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].username.value,
                  style: TextStyle(
                    fontSize: text.scale(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].title.value.length > 65
                      ? communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].title.value.substring(0, 65)
                      : communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].title.value,
                  style: TextStyle(
                    fontSize: text.scale(10),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: SizedBox(
                  height: height / 24.74,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFFF4C75F)),
                    onPressed: () {
                      postRequestDialog(context: context, index: index);
                    },
                    child: const Text("View"),
                  ),
                ),
              ),
            ));
      },
    );
  }

  postRequestDialog({required BuildContext context, required int index}) async {
    TextScaler text = MediaQuery.of(context).textScaler;
    return showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black45,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modelSetState) {
            double width = MediaQuery.of(context).size.width;
            double height = MediaQuery.of(context).size.height;
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: width,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, borderRadius: BorderRadius.circular(12), boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                  ),
                ]),
                padding: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.highlight_off_rounded,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ))
                      ],
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            NetworkImage(communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].avatar.value),
                      ),
                      title: Text(
                        communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].firstName.value,
                        style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].username.value,
                              style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                          Text(
                              "${communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].believersCount.value} Believers",
                              style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                        ],
                      ),
                      trailing: SizedBox(
                        width: width / 4.5,
                        child: membersWidgets.getBelieveButton(
                          heightValue: height / 34.64,
                          index: 0,
                          postRequest: true,
                          context: context,
                        ),
                      ),
                    ),
                    const Divider(),
                    Text(communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].title.value),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0XFF0EA102))),
                            onPressed: () async {
                              await communitiesFunctions.acceptOrDeclinePostRequest(
                                communityId:
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].communityId.value,
                                postId: communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].id.value,
                                isAccepted: true,
                              );
                              communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.removeAt(index);
                              communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.refresh();
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "lib/Constants/Assets/NewAssets/CommunitiesScreen/approve_image.svg",
                                  height: height / 48.11,
                                  width: width / 22.83,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  width: width / 41.1,
                                ),
                                Text(
                                  "Approve",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: const Color(0XFF0EA102)),
                                ),
                              ],
                            )),
                        SizedBox(
                          width: width / 27.4,
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                            onPressed: () async {
                              await communitiesFunctions.acceptOrDeclinePostRequest(
                                communityId:
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].communityId.value,
                                postId: communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].id.value,
                                isAccepted: false,
                              );
                              communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.removeAt(index);
                              communitiesVariables.communitiesPageInitialData.value.communityData.postRequests.refresh();
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "lib/Constants/Assets/NewAssets/CommunitiesScreen/decline_image.svg",
                                  height: height / 48.11,
                                  width: width / 22.83,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  width: width / 41.1,
                                ),
                                Text(
                                  "Decline",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: Colors.red),
                                ),
                              ],
                            )),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget postContentList({
    required BuildContext context,
    required String communityId,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => ListView.builder(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.postContents.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: width / 34.25),
            margin: EdgeInsets.symmetric(horizontal: width / width, vertical: height / 86.6),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
              width: width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1), blurRadius: 4.0, spreadRadius: 0.0),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () async {
                      bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return UserBillBoardProfilePage(
                            userId: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].userId.value);
                      }));
                      if (response) {
                        communitiesVariables.communitiesPostList = null;
                        await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Recent');
                      }
                    },
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].avatar.value),
                    ),
                    title: Text(
                      communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].firstName.value,
                      style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].username.value,
                            style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                        Text(" | ", style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                        InkWell(
                          onTap: () {
                            billboardWidgetsMain.believersTabBottomSheet(
                              context: context,
                              id: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].userId.value,
                              isBelieversList: true,
                            );
                          },
                          child: Text(
                              "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].believersCount.value} Believers",
                              style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: width / 3.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          userIdMain == communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].userId.value
                              ? const SizedBox()
                              : membersWidgets.getBelieveButton(
                                  heightValue: height / 34.64,
                                  index: index,
                                  context: context,
                                ),
                          SizedBox(
                            width: width / 41.1,
                          ),
                          InkWell(
                              onTap: () {
                                if (userIdMain ==
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].userId.value) {
                                  communitiesPageWidgets.editOrDeleteBottomSheet(
                                    context: context,
                                    communityId:
                                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].communityId.value,
                                    list: '',
                                    index: index,
                                    type: "post",
                                    postId: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].id.value,
                                  );
                                } else {
                                  communitiesPageWidgets.blockOrReportBottomSheet(
                                    context: context,
                                    modelSetState: modelSetState,
                                    communityId:
                                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].communityId.value,
                                    userId: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].userId.value,
                                    list: '',
                                    index: index,
                                    type: "post",
                                    postId: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].id.value,
                                  );
                                }
                              },
                              child: const Icon(Icons.more_vert)),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.background,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => CommunityDescriptionPage(
                                    index: index,
                                  )));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].title.value),
                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].files.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: height / 86.6,
                              ),
                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].files.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: height / 3.464,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].files.length,
                                    itemBuilder: (BuildContext context, int idx) {
                                      return Container(
                                        width:
                                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].files.length == 1
                                                ? width / 1.2
                                                : width / 1.64,
                                        margin:
                                            EdgeInsets.symmetric(vertical: height / 108.25, horizontal: index == 0 ? width / 205.5 : width / 51.375),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: [
                                          BoxShadow(
                                            blurRadius: 1,
                                            spreadRadius: 1,
                                            color: Colors.grey.shade300,
                                          )
                                        ]),
                                        clipBehavior: Clip.hardEdge,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          child: communitiesVariables
                                                      .communitiesPageInitialData.value.communityData.postContents[index].files[idx].fileType.value ==
                                                  "image"
                                              ? Image.network(
                                                  communitiesVariables
                                                      .communitiesPageInitialData.value.communityData.postContents[index].files[idx].file.value,
                                                  fit: BoxFit.fill, errorBuilder: (context, __, error) {
                                                  return Image.asset("lib/Constants/Assets/Settings/coverImage_default.png");
                                                })
                                              : communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].files[idx]
                                                          .fileType.value ==
                                                      "video"
                                                  ? Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                          "lib/Constants/Assets/Settings/coverImage_default.png",
                                                          fit: BoxFit.fill,
                                                          height: height / 3.464,
                                                        ),
                                                        Container(
                                                            height: height / 17.32,
                                                            width: width / 8.22,
                                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black26.withOpacity(0.7)),
                                                            child: const Icon(
                                                              Icons.play_arrow_sharp,
                                                              color: Colors.white,
                                                              size: 40,
                                                            ))
                                                      ],
                                                    )
                                                  : communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].files[idx]
                                                              .fileType.value ==
                                                          "document"
                                                      ? Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            Image.asset(
                                                              "lib/Constants/Assets/Settings/coverImage.png",
                                                              fit: BoxFit.fill,
                                                              height: height / 3.464,
                                                            ),
                                                            Container(
                                                              height: height / 17.32,
                                                              width: width / 8.22,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.black26.withOpacity(0.3),
                                                              ),
                                                              child: Center(
                                                                child: Image.asset(
                                                                  "lib/Constants/Assets/BillBoard/document.png",
                                                                  color: Colors.white,
                                                                  height: height / 34.64,
                                                                  width: width / 16.44,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                        ),
                                      );
                                    }),
                              ),
                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].files.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: height / 86.6,
                              ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.background,
                    thickness: 1,
                  ),
                  SizedBox(height: height / 57.73),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                bool response = await communitiesFunctions.communityLikeFunction(
                                  postId: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].id.value,
                                  communityId:
                                      communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].communityId.value,
                                  type: 'likes',
                                );
                                if (response) {
                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].isLiked.toggle();
                                  if (communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].isDisliked.value) {
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].isDisliked.toggle();
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].dislikesCount.value--;
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].likesCount.value++;
                                  } else {
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].isLiked.value
                                        ? communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].likesCount.value++
                                        : communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].likesCount.value--;
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(content: Text("Something went wrong, please try again later")));
                                  }
                                }
                              },
                              child: Obx(() => communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].isLiked.value
                                  ? SvgPicture.asset(
                                      isDarkTheme.value
                                          ? "assets/home_screen/like_filled_dark.svg"
                                          : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                      height: height / 43.3,
                                      width: width / 20.55)
                                  : SvgPicture.asset(
                                      isDarkTheme.value
                                          ? "assets/home_screen/like_dark.svg"
                                          : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                      height: height / 43.3,
                                      width: width / 20.55,
                                    )),
                            ),
                            Obx(() => Text(
                                  "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].likesCount.value}",
                                  style: TextStyle(fontSize: text.scale(8), color: const Color(0XFFA7A7A7), fontWeight: FontWeight.w600),
                                )),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () async {
                                  logEventFunc(name: "Share", type: "Forum");
                                  Uri newLink = await communitiesFunctions.getCommunityLinK(
                                    id: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].id.value,
                                    type: "CommunityDescriptionPage",
                                    title: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].title.value,
                                    imageUrl: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].files.isEmpty
                                        ? ""
                                        : communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].files[0].file.value,
                                    description: "",
                                  );
                                  ShareResult result = await Share.share(
                                    "Look what I was able to find on Tradewatch: ${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].title.value} ${newLink.toString()}",
                                  );
                                  if (result.status == ShareResultStatus.success) {
                                    await communitiesFunctions.shareFunction(
                                        id: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].id.value);
                                  }
                                },
                                child: SvgPicture.asset(
                                  isDarkTheme.value ? "assets/home_screen/share_dark.svg" : "lib/Constants/Assets/SMLogos/HomeScreen/share.svg",
                                )),
                            Text(
                              "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].shareCount.value}",
                              style: TextStyle(fontSize: text.scale(8), color: const Color(0XFFA7A7A7), fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                bool response = await communitiesFunctions.communityLikeFunction(
                                  postId: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].id.value,
                                  communityId:
                                      communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].communityId.value,
                                  type: 'dislikes',
                                );
                                if (response) {
                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].isDisliked.toggle();
                                  if (communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].isLiked.value) {
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].isLiked.toggle();
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].likesCount.value--;
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].dislikesCount.value++;
                                  } else {
                                    communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].isDisliked.value
                                        ? communitiesVariables
                                            .communitiesPageInitialData.value.communityData.postContents[index].dislikesCount.value++
                                        : communitiesVariables
                                            .communitiesPageInitialData.value.communityData.postContents[index].dislikesCount.value--;
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(content: Text("Something went wrong, please try again later")));
                                  }
                                }
                              },
                              child: Obx(
                                () => communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].isDisliked.value
                                    ? SvgPicture.asset(
                                        isDarkTheme.value
                                            ? "assets/home_screen/dislike_filled_dark.svg"
                                            : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                        height: height / 43.3,
                                        width: width / 20.55)
                                    : SvgPicture.asset(
                                        isDarkTheme.value
                                            ? "assets/home_screen/dislike_dark.svg"
                                            : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                        height: height / 43.3,
                                        width: width / 20.55,
                                      ),
                              ),
                            ),
                            Obx(() => Text(
                                  "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].dislikesCount.value}",
                                  style: TextStyle(fontSize: text.scale(8), color: const Color(0XFFA7A7A7), fontWeight: FontWeight.w600),
                                )),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CommunityDescriptionPage(index: index)));
                              },
                              child: SvgPicture.asset(
                                "lib/Constants/Assets/SMLogos/messageCircle.svg",
                                colorFilter: ColorFilter.mode(isDarkTheme.value ? const Color(0XFFD6D6D6) : const Color(0XFF0EA102), BlendMode.srcIn),
                                height: height / 43.3,
                                width: width / 20.55,
                              ),
                            ),
                            Text(
                              "${communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].responseCount.value}",
                              style: TextStyle(fontSize: text.scale(8), color: const Color(0XFFA7A7A7), fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 86.6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                            return UserBillBoardProfilePage(
                              userId: userIdMain,
                            );
                          }));
                          if (response) {
                            communitiesVariables.communitiesPostList = null;
                            await communitiesFunctions.getCommunityPostList(communityId: communityId, skipCount: 0, sortType: 'Recent');
                          }
                        },
                        child: CircleAvatar(radius: 18, backgroundImage: NetworkImage(avatarMain.value)),
                      ),
                      SizedBox(
                        width: width / 41.1,
                      ),
                      Expanded(
                        child: getResponseField(
                          context: context,
                          modelSetState: modelSetState,
                          index: index,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 86.6,
                  ),
                ],
              ),
            ),
          );
        }));
  }

  Widget getResponseField({
    required BuildContext context,
    required int index,
    required StateSetter modelSetState,
  }) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: height / 24.74,
          child: TextFormField(
            onChanged: (value) {},
            onTap: () {
              communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value = true;
            },
            onFieldSubmitted: (value) {
              communitiesVariables.communitiesPageInitialData.value.communityData.isSearchEnabled.value = false;
            },
            controller: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].responseController.value,
            cursorColor: Colors.green,
            //focusNode: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].responseFocus.value,
            style: TextStyle(fontSize: text.scale(14), fontFamily: "Poppins"),
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            minLines: 1,
            decoration: InputDecoration(
                suffixIcon: SizedBox(
                  width: width / 3.425,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value.path == "" &&
                              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value.path == "" &&
                              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value.path == "")
                          ? GestureDetector(
                              onTap: () {
                                showSheet(context: context, modelSetState: modelSetState, index: index, single: false);
                              },
                              child: Image.asset(
                                "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                                height: height / 34.64,
                                width: width / 16.44,
                              ))
                          : const SizedBox(),
                      getResponseSubmitButton(context: context, index: index)
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                filled: true,
                fillColor: Theme.of(context).colorScheme.onBackground,
                hintText: 'Add a response'),
          ),
        ),
        Obx(
          () => (communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value.path == "" &&
                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value.path == "" &&
                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value.path == "")
              ? const SizedBox()
              : SizedBox(
                  height: height / 108.25,
                ),
        ),
        Obx(
          () => (communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value.path == "" &&
                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value.path == "" &&
                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value.path == "")
              ? const SizedBox()
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                  child: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value.path == "" &&
                          communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value.path == "" &&
                          communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value.files.isEmpty
                      ? const SizedBox()
                      : Row(
                          children: [
                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value.path == ""
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      Text(
                                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value.path
                                            .split('/')
                                            .last
                                            .toString(),
                                        style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                      ),
                                      SizedBox(
                                        width: width / 41.1,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          modelSetState(() {
                                            communitiesVariables
                                                .communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value = File("");
                                            communitiesVariables
                                                .communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value = File("");
                                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value =
                                                const FilePickerResult([]);
                                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value =
                                                File("");
                                          });
                                        },
                                        child: Container(
                                            decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                            child: const Center(
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value.path == ""
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value.path
                                            .split('/')
                                            .last
                                            .toString(),
                                        style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                      ),
                                      SizedBox(
                                        width: width / 41.1,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          modelSetState(() {
                                            communitiesVariables
                                                .communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value = File("");
                                            communitiesVariables
                                                .communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value = File("");
                                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value =
                                                const FilePickerResult([]);
                                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value =
                                                File("");
                                          });
                                        },
                                        child: Container(
                                            decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                            child: const Center(
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value.files.isEmpty
                                ? const SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        communitiesVariables
                                            .communitiesPageInitialData.value.communityData.postContents[index].doc.value.files[index].path!
                                            .split('/')
                                            .last
                                            .toString(),
                                        style: TextStyle(color: Colors.black, fontSize: text.scale(10)),
                                      ),
                                      SizedBox(
                                        width: width / 41.1,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          modelSetState(() {
                                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value =
                                                File("");
                                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value =
                                                const FilePickerResult([]);
                                            communitiesVariables
                                                .communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value = File("");
                                            communitiesVariables
                                                .communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value = File("");
                                          });
                                        },
                                        child: Container(
                                            decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                            child: const Center(
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                            )),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                ),
        ),
      ],
    );
  }

  Widget getDescriptionResponseField({
    required BuildContext context,
    required int index,
    required StateSetter modelSetState,
  }) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          width: width / 1.35,
          child: TextFormField(
            controller: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].responseController.value,
            onChanged: (value) {
              if (value.isNotEmpty) {
                modelSetState(() {
                  String newResponseValue = value.trim();
                  if (newResponseValue.isNotEmpty) {
                    String messageText = newResponseValue;
                    if (messageText.startsWith("+")) {
                      if (messageText.substring(messageText.length - 1) == '+') {
                        modelSetState(() {
                          mainVariables.isUserTagged.value = true;
                        });
                      } else {
                        if (mainVariables.isUserTagged.value) {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                          modelSetState(() {});
                        } else {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                        }
                      }
                    } else {
                      if (messageText.contains(" +")) {
                        if (messageText.substring(messageText.length - 1) == '+') {
                          modelSetState(() {
                            mainVariables.isUserTagged.value = true;
                          });
                        } else {
                          if (mainVariables.isUserTagged.value) {
                            conversationFunctionsMain.conversationSearchData(
                              newResponseValue: newResponseValue,
                              newSetState: modelSetState,
                            );
                            modelSetState(() {});
                          } else {
                            conversationFunctionsMain.conversationSearchData(newResponseValue: newResponseValue, newSetState: modelSetState);
                          }
                        }
                      } else {
                        modelSetState(() {
                          mainVariables.isUserTagged.value = false;
                        });
                      }
                    }
                  }
                });
              } else if (value.isEmpty) {
                modelSetState(() {
                  mainVariables.isUserTagged.value = false;
                });
              } else {
                modelSetState(() {});
              }
            },
            cursorColor: Colors.green,
            showCursor: true,
            style: TextStyle(fontSize: text.scale(14), fontFamily: "Poppins"),
            keyboardType: TextInputType.emailAddress,
            maxLines: 5,
            minLines: 4,
            decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.onBackground,
                contentPadding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                filled: true,
                hintText: 'Add a response'),
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
        SizedBox(
          width: width / 1.35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => (communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value.path == "" &&
                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value.path == "" &&
                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value.path == "")
                    ? GestureDetector(
                        onTap: () {
                          showSheet(context: context, modelSetState: modelSetState, index: index, single: true);
                        },
                        child: Image.asset(
                          "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                          height: height / 34.64,
                          width: width / 16.44,
                        ))
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                        child: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value.path == "" &&
                                communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value.path ==
                                    "" &&
                                communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value.files.isEmpty
                            ? const SizedBox()
                            : Row(
                                children: [
                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value.path == ""
                                      ? const SizedBox()
                                      : Row(
                                          children: [
                                            SizedBox(
                                              width: width / 3.5,
                                              child: Text(
                                                communitiesVariables
                                                    .communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value.path
                                                    .split('/')
                                                    .last
                                                    .toString(),
                                                style: TextStyle(fontSize: text.scale(10), overflow: TextOverflow.ellipsis),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 41.1,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                modelSetState(() {
                                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage
                                                      .value = File("");
                                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo
                                                      .value = File("");
                                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value =
                                                      const FilePickerResult([]);
                                                  communitiesVariables
                                                      .communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value = File("");
                                                });
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary, shape: BoxShape.circle),
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
                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value.path == ""
                                      ? const SizedBox()
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: width / 3.5,
                                              child: Text(
                                                communitiesVariables
                                                    .communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value.path
                                                    .split('/')
                                                    .last
                                                    .toString(),
                                                style: TextStyle(fontSize: text.scale(10), overflow: TextOverflow.ellipsis),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 41.1,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                modelSetState(() {
                                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo
                                                      .value = File("");
                                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage
                                                      .value = File("");
                                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value =
                                                      const FilePickerResult([]);
                                                  communitiesVariables
                                                      .communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value = File("");
                                                });
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary, shape: BoxShape.circle),
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
                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value.files.isEmpty
                                      ? const SizedBox()
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: width / 3.5,
                                              child: Text(
                                                communitiesVariables
                                                    .communitiesPageInitialData.value.communityData.postContents[index].doc.value.files[index].path!
                                                    .split('/')
                                                    .last
                                                    .toString(),
                                                style: TextStyle(fontSize: text.scale(10), overflow: TextOverflow.ellipsis),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 41.1,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                modelSetState(() {
                                                  communitiesVariables
                                                      .communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value = File("");
                                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value =
                                                      const FilePickerResult([]);
                                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage
                                                      .value = File("");
                                                  communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo
                                                      .value = File("");
                                                });
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary, shape: BoxShape.circle),
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
              ),
              getResponseSubmitButton(context: context, index: index)
            ],
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
      ],
    );
  }

  Widget getResponseEditingField({
    required BuildContext context,
    required int index,
    required StateSetter modelSetState,
  }) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Obx(() => mainVariables.isUserResponseTagged.value
            ? Positioned(
                bottom: height / 5.5,
                child: const UserTaggingBillBoardSingleContainer(
                  billboardListIndex: 0,
                ))
            : const SizedBox()),
        SizedBox(
          width: width / 1.4,
          child: TextFormField(
            controller: communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].responseController.value,
            onChanged: (value) {
              if (value.isNotEmpty) {
                modelSetState(() {
                  String newResponseValue = value.trim();
                  if (newResponseValue.isNotEmpty) {
                    String messageText = newResponseValue;
                    if (messageText.startsWith("+")) {
                      if (messageText.substring(messageText.length - 1) == '+') {
                        modelSetState(() {
                          mainVariables.isUserResponseTagged.value = true;
                        });
                      } else {
                        if (mainVariables.isUserResponseTagged.value) {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                          modelSetState(() {});
                        } else {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                        }
                      }
                    } else {
                      if (messageText.contains(" +")) {
                        if (messageText.substring(messageText.length - 1) == '+') {
                          modelSetState(() {
                            mainVariables.isUserResponseTagged.value = true;
                          });
                        } else {
                          if (mainVariables.isUserResponseTagged.value) {
                            conversationFunctionsMain.conversationSearchData(
                              newResponseValue: newResponseValue,
                              newSetState: modelSetState,
                            );
                            modelSetState(() {});
                          } else {
                            conversationFunctionsMain.conversationSearchData(newResponseValue: newResponseValue, newSetState: modelSetState);
                          }
                        }
                      } else {
                        modelSetState(() {
                          mainVariables.isUserResponseTagged.value = false;
                        });
                      }
                    }
                  }
                });
              } else if (value.isEmpty) {
                modelSetState(() {
                  mainVariables.isUserResponseTagged.value = false;
                });
              } else {
                modelSetState(() {});
              }
            },
            cursorColor: Colors.green,
            showCursor: true,
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.emailAddress,
            maxLines: 5,
            minLines: 4,
            decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.tertiary,
                contentPadding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                filled: true,
                hintText: 'Add a response'),
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
        SizedBox(
          width: width / 1.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              getResponseSubmitButton(
                  context: context,
                  index: index,
                  responseId: communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].id.value)
            ],
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
      ],
    );
  }

  Widget getCommentsEditingField({
    required BuildContext context,
    required int index,
    required StateSetter modelSetState,
  }) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Obx(() => mainVariables.isUserResponseTagged.value
            ? Positioned(
                bottom: height / 5.5,
                child: const UserTaggingBillBoardSingleContainer(
                  billboardListIndex: 0,
                ))
            : const SizedBox()),
        SizedBox(
          width: width / 1.5,
          child: TextFormField(
            controller: communitiesVariables.communitiesCommentsInitialData!.value.response[index].commentsController.value,
            onChanged: (value) {
              if (value.isNotEmpty) {
                modelSetState(() {
                  String newResponseValue = value.trim();
                  if (newResponseValue.isNotEmpty) {
                    String messageText = newResponseValue;
                    if (messageText.startsWith("+")) {
                      if (messageText.substring(messageText.length - 1) == '+') {
                        modelSetState(() {
                          mainVariables.isUserResponseTagged.value = true;
                        });
                      } else {
                        if (mainVariables.isUserResponseTagged.value) {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                          modelSetState(() {});
                        } else {
                          conversationFunctionsMain.conversationSearchData(
                            newResponseValue: newResponseValue,
                            newSetState: modelSetState,
                          );
                        }
                      }
                    } else {
                      if (messageText.contains(" +")) {
                        if (messageText.substring(messageText.length - 1) == '+') {
                          modelSetState(() {
                            mainVariables.isUserResponseTagged.value = true;
                          });
                        } else {
                          if (mainVariables.isUserResponseTagged.value) {
                            conversationFunctionsMain.conversationSearchData(
                              newResponseValue: newResponseValue,
                              newSetState: modelSetState,
                            );
                            modelSetState(() {});
                          } else {
                            conversationFunctionsMain.conversationSearchData(newResponseValue: newResponseValue, newSetState: modelSetState);
                          }
                        }
                      } else {
                        modelSetState(() {
                          mainVariables.isUserResponseTagged.value = false;
                        });
                      }
                    }
                  }
                });
              } else if (value.isEmpty) {
                modelSetState(() {
                  mainVariables.isUserResponseTagged.value = false;
                });
              } else {
                modelSetState(() {});
              }
            },
            cursorColor: Colors.green,
            showCursor: true,
            style: TextStyle(fontSize: text.scale(14), fontFamily: "Poppins"),
            keyboardType: TextInputType.emailAddress,
            maxLines: 5,
            minLines: 4,
            decoration: InputDecoration(
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(10), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                filled: true,
                hintText: 'Add a response'),
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
        SizedBox(
          width: width / 1.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              getCommentSubmitButton(
                context: context,
                index: index,
                responseId: communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].id.value,
              )
            ],
          ),
        ),
        SizedBox(
          height: height / 108.25,
        ),
      ],
    );
  }

  Widget getResponseSubmitButton({required BuildContext context, required int index, String? responseId}) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> data = await communitiesFunctions.getCommunityCommentAdd(data: {
            "community_id": communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].communityId.value,
            "post_id": communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].id.value,
            "message": responseId == null
                ? communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].responseController.value.text
                : communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].responseController.value.text,
            "files": communitiesVariables.addedFilesList,
            "response_id": responseId ?? ""
          });
          if (data["status"]) {
            if (responseId == "") {
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].responseController.value.clear();
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value = File("");
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value = File("");
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value = File("");
              await communitiesFunctions.getCommunityPostResponsesList(
                postId: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].id.value,
                skipCount: 0,
              );
              communitiesVariables.addedFilesList.clear();
            } else {
              communitiesFunctions.getCommunityPostResponsesList(
                postId: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].id.value,
                skipCount: 0,
              );
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value = File("");
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value = File("");
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value = File("");
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].responseController.value.clear();
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"])));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"])));
          }
        },
        child: Container(
          height: height / 34.64,
          padding: EdgeInsets.symmetric(horizontal: width / 86.6),
          margin: EdgeInsets.symmetric(horizontal: width / 86.6),
          decoration: BoxDecoration(
            color: const Color(0XFF0EA102),
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Text(
              "Respond",
              style: TextStyle(
                color: Colors.white,
                fontSize: text.scale(10),
              ),
            ),
          ),
        ));
  }

  Widget getCommentSubmitButton({required BuildContext context, required int index, String? responseId, String? commentId}) {
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> data = await communitiesFunctions.getCommunityCommentAdd(data: {
            "community_id": communitiesVariables.communitiesCommentsInitialData!.value.response[index].communityId.value,
            "post_id": communitiesVariables.communitiesCommentsInitialData!.value.response[index].postId.value,
            "message": communitiesVariables.communitiesCommentsInitialData!.value.response[index].commentsController.value.text,
            "files": communitiesVariables.addedFilesList,
            "response_id": communitiesVariables.communitiesCommentsInitialData!.value.response[index].responseId.value,
            "comment_id": communitiesVariables.communitiesCommentsInitialData!.value.response[index].id.value
          });
          if (data["status"]) {
            communitiesFunctions.getCommunityPostResponseComments(
                responseId: communitiesVariables.communitiesCommentsInitialData!.value.response[index].responseId.value);
            communitiesVariables.communitiesCommentsInitialData!.value.response[index].isEditing.value = false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"])));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["message"])));
          }
        },
        child: Container(
          height: height / 34.64,
          padding: EdgeInsets.symmetric(horizontal: width / 86.6),
          margin: EdgeInsets.symmetric(horizontal: width / 86.6),
          decoration: BoxDecoration(
            color: const Color(0XFF0EA102),
            borderRadius: BorderRadius.circular(5),
          ),
          clipBehavior: Clip.hardEdge,
          child: Center(
            child: Text(
              "Respond",
              style: TextStyle(
                color: Colors.white,
                fontSize: text.scale(10),
              ),
            ),
          ),
        ));
  }

  showSheet({
    required BuildContext context,
    required StateSetter modelSetState,
    required int index,
    required bool single,
  }) {
    ImagePicker picker = ImagePicker();
    TextScaler text = MediaQuery.of(context).textScaler;
    double width = MediaQuery.of(context).size.width;
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
                        modelSetState(() {
                          communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value =
                              File(image.path);
                          communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].urlType.value = "image";
                          communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value = File("");
                        });
                      }
                      if (!context.mounted) {
                        return;
                      }
                      String imagePath = await billBoardApiMain.fileUploadBillBoard(
                          file: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value,
                          context: context);
                      Map<String, dynamic> data = {
                        "file": imagePath,
                        "file_type": communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].urlType.value
                      };
                      communitiesVariables.addedFilesList.add(data);
                      Navigator.of(context).pop();
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.image_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Image",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
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
                        modelSetState(() {
                          communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value =
                              File(video.path);
                          communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedImage.value = File("");
                          communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].urlType.value = "video";
                        });
                      }
                      if (!context.mounted) {
                        return;
                      }
                      String imagePath = await billBoardApiMain.fileUploadBillBoard(
                          file: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedVideo.value,
                          context: context);
                      Map<String, dynamic> data = {
                        "file": imagePath,
                        "file_type": communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].urlType.value
                      };
                      communitiesVariables.addedFilesList.add(data);
                      Navigator.of(context).pop();
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.video_library_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Video",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value =
                          (await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['pdf', 'docx'],
                              )) ??
                              const FilePickerResult([]);
                      if (communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value.files.isNotEmpty) {
                        modelSetState(() {
                          for (int i = 0;
                              i < communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value.paths.length;
                              i++) {
                            communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].docFiles.add(
                                File(communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].doc.value.paths[i]!));
                          }
                          communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value =
                              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].docFiles[index];
                          communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].urlType.value = "document";
                        });
                      }
                      if (!context.mounted) {
                        return;
                      }
                      String imagePath = await billBoardApiMain.fileUploadBillBoard(
                          file: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].pickedFile.value,
                          context: context);
                      Map<String, dynamic> data = {
                        "file": imagePath,
                        "file_type": communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].urlType.value
                      };
                      communitiesVariables.addedFilesList.add(data);
                      Navigator.of(context).pop();
                    },
                    minLeadingWidth: width / 25,
                    leading: const Icon(
                      Icons.attach_file_outlined,
                      size: 20,
                    ),
                    title: Text(
                      "Document",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future commentsBottomSheet({
    required BuildContext context,
    required String responseId,
    required String postId,
    required String communityId,
  }) async {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return CommunitiesCommentsBottomSheetPage(
            responseId: responseId,
            postId: postId,
            communityId: communityId,
          );
        });
  }

  communitiesCommentsBottomSheet({
    required BuildContext context,
    required bool myself,
    required int index,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
              child: myself
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () async {
                            communitiesVariables.communitiesCommentsInitialData!.value.response[index].isEditing.value = true;
                            communitiesVariables.communitiesCommentsInitialData!.value.response[index].commentsController.value.text =
                                communitiesVariables.communitiesCommentsInitialData!.value.response[index].message.value;
                            Navigator.pop(context);
                          },
                          minLeadingWidth: width / 25,
                          leading: const Icon(
                            Icons.edit,
                            size: 20,
                          ),
                          title: Text(
                            "Edit comment",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                    child: Container(
                                      height: height / 6,
                                      margin: EdgeInsets.symmetric(vertical: height / 54.13, horizontal: width / 25),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                              child: Text("Delete comment",
                                                  style: TextStyle(
                                                      color: const Color(0XFF0EA102),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: text.scale(18),
                                                      fontFamily: "Poppins"))),
                                          const Divider(),
                                          const Center(child: Text("Are you sure to delete this comment")),
                                          const Spacer(),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width / 25),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                        fontSize: text.scale(12)),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(18.0),
                                                    ),
                                                    backgroundColor: const Color(0XFF0EA102),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await communitiesFunctions.getCommunityCommentsDelete(
                                                      responseId:
                                                          communitiesVariables.communitiesCommentsInitialData!.value.response[index].responseId.value,
                                                      commentId: communitiesVariables.communitiesCommentsInitialData!.value.response[index].id.value,
                                                    );
                                                    communitiesVariables.communitiesCommentsInitialData!.value.response.removeAt(index);
                                                  },
                                                  child: Text(
                                                    "Continue",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                        fontSize: text.scale(12)),
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
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            communitiesCommentsShowAlertDialog(
                              context: context,
                              actionType: 'Report',
                              modelSetState: modelSetState,
                            );
                          },
                          minLeadingWidth: width / 25,
                          leading: const Icon(
                            Icons.shield,
                            size: 20,
                          ),
                          title: Text(
                            "Report Post",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                          ),
                        ),
                        const Divider(
                          thickness: 0.0,
                          height: 0.0,
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            communitiesCommentsShowAlertDialog(
                              context: context,
                              actionType: 'Block',
                              modelSetState: modelSetState,
                            );
                          },
                          minLeadingWidth: width / 25,
                          leading: const Icon(
                            Icons.flag,
                            size: 20,
                          ),
                          title: Text(
                            "Block Post",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12)),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        });
  }

  void communitiesCommentsShowAlertDialog({
    required BuildContext context,
    required StateSetter modelSetState,
    required String actionType,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        List<String> actionList = ["Report", "Block"];
        List<String> whyList = ["Scam", "Abusive Content", "Spam", "Other"];
        String actionValue = actionType;
        String whyValue = "Scam";
        TextEditingController controller = TextEditingController();
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
                        icon: const Icon(Icons.clear, size: 24),
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
                                  modelSetState(() {
                                    actionValue = value!;
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
                                  modelSetState(() {
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
                    controller: controller,
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
                      logEventFunc(name: actionValue == "Report" ? 'Reported_Post' : 'Blocked_Post', type: "communities");
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
                conversationApiMain.getValuesData(value: newSplit[i].substring(1), context: context);
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
                Get.to(const DemoView(), arguments: {"id": "", "type": '', "url": newSplit[i]});
              }));
      } else {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(color: Colors.black, fontSize: text.scale(10), fontFamily: "Poppins", fontWeight: FontWeight.w400)));
      }
    }
    return textSpan;
  }

  List<TextSpan> commentsSpanList({required String message, required BuildContext context}) {
    TextScaler text = MediaQuery.of(context).textScaler;
    List<TextSpan> textSpan = [];
    List<String> newSplit = message.split(' ');
    for (int i = 0; i < newSplit.length; i++) {
      if (newSplit[i].contains("+")) {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w400),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                conversationApiMain.getValuesData(value: newSplit[i].substring(1), context: context);
              }));
      } else if ((RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?"))
          .hasMatch(newSplit[i])) {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(
                color: Colors.blue,
                fontSize: text.scale(14),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DemoPage(url: newSplit[i], text: "", image: "", id: "", type: "", activity: false)));*/
                Get.to(const DemoView(), arguments: {"id": "", "type": '', "url": newSplit[i]});
              }));
      } else {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(color: Colors.black, fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w400)));
      }
    }
    return textSpan;
  }

  Widget communityContentWidget({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: communitiesVariables.communitiesCommentsInitialData!.value.response.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height / 17.32,
                      width: width / 8.22,
                      child: Center(
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(communitiesVariables.communitiesCommentsInitialData!.value.response[index].avatar.value),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width / 41.1,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(communitiesVariables.communitiesCommentsInitialData!.value.response[index].firstName.value,
                                      style: TextStyle(
                                        color: const Color(0XFF1D1D1D),
                                        fontSize: text.scale(14),
                                        fontWeight: FontWeight.w600,
                                      )),
                                  Text(communitiesVariables.communitiesCommentsInitialData!.value.response[index].postedTime.value,
                                      style: TextStyle(
                                        color: const Color(0XFF737373),
                                        fontSize: text.scale(8),
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  communitiesVariables.communitiesCommentsInitialData!.value.response[index].userId.value == userIdMain
                                      ? const SizedBox()
                                      : membersWidgets.getBelieveButton(
                                          heightValue: height / 34.64,
                                          index: 0,
                                          context: context,
                                        ),
                                  communitiesVariables.communitiesCommentsInitialData!.value.response[index].userId.value != userIdMain
                                      ? const SizedBox()
                                      : IconButton(
                                          onPressed: () {
                                            communitiesWidgets.communitiesCommentsBottomSheet(
                                                context: context,
                                                myself: communitiesVariables.communitiesCommentsInitialData!.value.response[index].userId.value ==
                                                    userIdMain,
                                                modelSetState: modelSetState,
                                                index: index);
                                          },
                                          icon: const Icon(Icons.more_vert),
                                        ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 86.6,
                          ),
                          Obx(
                            () => communitiesVariables.communitiesCommentsInitialData!.value.response[index].isEditing.value
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      communitiesWidgets.getCommentsEditingField(
                                        context: context,
                                        modelSetState: modelSetState,
                                        index: index,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          communitiesVariables.communitiesCommentsInitialData!.value.response[index].isEditing.value = false;
                                        },
                                        child: const Icon(
                                          Icons.highlight_off_sharp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(communitiesVariables.communitiesCommentsInitialData!.value.response[index].message.value),
                                      communitiesVariables.communitiesCommentsInitialData!.value.response[index].files.isEmpty
                                          ? const SizedBox()
                                          : SizedBox(
                                              height: height / 86.6,
                                            ),
                                      communitiesVariables.communitiesCommentsInitialData!.value.response[index].files.isEmpty
                                          ? const SizedBox()
                                          : SizedBox(
                                              height: height / 3.464,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  physics: const BouncingScrollPhysics(),
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: communitiesVariables.communitiesCommentsInitialData!.value.response[index].files.length,
                                                  itemBuilder: (BuildContext context, int idx) {
                                                    return Container(
                                                      width:
                                                          communitiesVariables.communitiesCommentsInitialData!.value.response[index].files.length == 1
                                                              ? width / 1.2
                                                              : width / 1.644,
                                                      margin: EdgeInsets.symmetric(
                                                          vertical: height / 108.25, horizontal: index == 0 ? width / 205.5 : width / 51.375),
                                                      decoration:
                                                          BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white, boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 1,
                                                          spreadRadius: 1,
                                                          color: Colors.grey.shade300,
                                                        )
                                                      ]),
                                                      clipBehavior: Clip.hardEdge,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          color: Colors.white,
                                                        ),
                                                        child: communitiesVariables.communitiesCommentsInitialData!.value.response[index].files[idx]
                                                                    .fileType.value ==
                                                                "image"
                                                            ? Image.network(
                                                                communitiesVariables
                                                                    .communitiesCommentsInitialData!.value.response[index].files[idx].file.value,
                                                                fit: BoxFit.fill, errorBuilder: (context, __, error) {
                                                                return Image.asset("lib/Constants/Assets/Settings/coverImage_default.png");
                                                              })
                                                            : communitiesVariables.communitiesCommentsInitialData!.value.response[index].files[idx]
                                                                        .fileType.value ==
                                                                    "video"
                                                                ? Stack(
                                                                    alignment: Alignment.center,
                                                                    children: [
                                                                      Image.asset(
                                                                        "lib/Constants/Assets/Settings/coverImage_default.png",
                                                                        fit: BoxFit.fill,
                                                                        height: height / 3.464,
                                                                      ),
                                                                      Container(
                                                                          height: height / 17.32,
                                                                          width: width / 8.22,
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle, color: Colors.black26.withOpacity(0.7)),
                                                                          child: const Icon(
                                                                            Icons.play_arrow_sharp,
                                                                            color: Colors.white,
                                                                            size: 40,
                                                                          ))
                                                                    ],
                                                                  )
                                                                : communitiesVariables.communitiesCommentsInitialData!.value.response[index]
                                                                            .files[idx].fileType.value ==
                                                                        "document"
                                                                    ? Stack(
                                                                        alignment: Alignment.center,
                                                                        children: [
                                                                          Image.asset(
                                                                            "lib/Constants/Assets/Settings/coverImage.png",
                                                                            fit: BoxFit.fill,
                                                                            height: height / 3.464,
                                                                          ),
                                                                          Container(
                                                                            height: height / 17.32,
                                                                            width: width / 8.22,
                                                                            decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: Colors.black26.withOpacity(0.3),
                                                                            ),
                                                                            child: Center(
                                                                              child: Image.asset(
                                                                                "lib/Constants/Assets/BillBoard/document.png",
                                                                                color: Colors.white,
                                                                                height: height / 34.64,
                                                                                width: width / 16.44,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    : const SizedBox(),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                      communitiesVariables.communitiesCommentsInitialData!.value.response[index].files.isEmpty
                                          ? const SizedBox()
                                          : SizedBox(
                                              height: height / 86.6,
                                            ),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: height / 86.6,
                          ),
                          SizedBox(
                            width: width / 4.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        bool response = await communitiesFunctions.communityCommentsLikeFunction(
                                          postId: communitiesVariables.communitiesCommentsInitialData!.value.response[index].postId.value,
                                          responseId: communitiesVariables.communitiesCommentsInitialData!.value.response[index].responseId.value,
                                          communityId: communitiesVariables.communitiesCommentsInitialData!.value.response[index].communityId.value,
                                          type: 'likes',
                                          commentId: communitiesVariables.communitiesCommentsInitialData!.value.response[index].id.value,
                                        );
                                        if (response) {
                                          communitiesVariables.communitiesCommentsInitialData!.value.response[index].likes.toggle();
                                          if (communitiesVariables.communitiesCommentsInitialData!.value.response[index].dislikes.value) {
                                            communitiesVariables.communitiesCommentsInitialData!.value.response[index].dislikes.toggle();
                                            communitiesVariables.communitiesCommentsInitialData!.value.response[index].dislikesCount.value--;
                                            communitiesVariables.communitiesCommentsInitialData!.value.response[index].likesCount.value++;
                                          } else {
                                            communitiesVariables.communitiesCommentsInitialData!.value.response[index].likes.value
                                                ? communitiesVariables.communitiesCommentsInitialData!.value.response[index].likesCount.value++
                                                : communitiesVariables.communitiesCommentsInitialData!.value.response[index].likesCount.value--;
                                          }
                                        } else {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(content: Text("Something went wrong, please try again later")));
                                          }
                                        }
                                      },
                                      child: Obx(() => communitiesVariables.communitiesCommentsInitialData!.value.response[index].likes.value
                                          ? SvgPicture.asset(
                                              isDarkTheme.value
                                                  ? "assets/home_screen/like_filled_dark.svg"
                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_colored.svg",
                                              height: height / 43.3,
                                              width: width / 20.55)
                                          : SvgPicture.asset(
                                              isDarkTheme.value
                                                  ? "assets/home_screen/like_dark.svg"
                                                  : "lib/Constants/Assets/SMLogos/HomeScreen/Stroke_grey.svg",
                                              height: height / 43.3,
                                              width: width / 20.55,
                                            )),
                                    ),
                                    Obx(() => Text(
                                          "${communitiesVariables.communitiesCommentsInitialData!.value.response[index].likesCount.value}",
                                          style: TextStyle(fontSize: text.scale(8), color: const Color(0XFFA7A7A7), fontWeight: FontWeight.w600),
                                        )),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        bool response = await communitiesFunctions.communityCommentsLikeFunction(
                                          postId: communitiesVariables.communitiesCommentsInitialData!.value.response[index].postId.value,
                                          communityId: communitiesVariables.communitiesCommentsInitialData!.value.response[index].communityId.value,
                                          type: 'dislikes',
                                          responseId: communitiesVariables.communitiesCommentsInitialData!.value.response[index].responseId.value,
                                          commentId: communitiesVariables.communitiesCommentsInitialData!.value.response[index].id.value,
                                        );
                                        if (response) {
                                          communitiesVariables.communitiesCommentsInitialData!.value.response[index].dislikes.toggle();
                                          if (communitiesVariables.communitiesCommentsInitialData!.value.response[index].likes.value) {
                                            communitiesVariables.communitiesCommentsInitialData!.value.response[index].likes.toggle();
                                            communitiesVariables.communitiesCommentsInitialData!.value.response[index].likesCount.value--;
                                            communitiesVariables.communitiesCommentsInitialData!.value.response[index].dislikesCount.value++;
                                          } else {
                                            communitiesVariables.communitiesCommentsInitialData!.value.response[index].dislikes.value
                                                ? communitiesVariables.communitiesCommentsInitialData!.value.response[index].dislikesCount.value++
                                                : communitiesVariables.communitiesCommentsInitialData!.value.response[index].dislikesCount.value--;
                                          }
                                        } else {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(content: Text("Something went wrong, please try again later")));
                                          }
                                        }
                                      },
                                      child: Obx(
                                        () => communitiesVariables.communitiesCommentsInitialData!.value.response[index].dislikes.value
                                            ? SvgPicture.asset(
                                                isDarkTheme.value
                                                    ? "assets/home_screen/dislike_filled_dark.svg"
                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke_filled.svg",
                                                height: height / 43.3,
                                                width: width / 20.55)
                                            : SvgPicture.asset(
                                                isDarkTheme.value
                                                    ? "assets/home_screen/dislike_dark.svg"
                                                    : "lib/Constants/Assets/SMLogos/HomeScreen/broken_stroke.svg",
                                                height: height / 43.3,
                                                width: width / 20.55,
                                              ),
                                      ),
                                    ),
                                    Obx(() => Text(
                                          "${communitiesVariables.communitiesCommentsInitialData!.value.response[index].dislikesCount.value}",
                                          style: TextStyle(fontSize: text.scale(8), color: const Color(0XFFA7A7A7), fontWeight: FontWeight.w600),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider()
            ],
          );
        });
  }
}
