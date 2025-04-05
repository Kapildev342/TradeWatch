import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module8/MembersPage/focused_menu_community.dart';

class MembersPageWidgets {
  Widget memberAdminCardList({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.adminsList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].avatar.value),
            ),
            title: Text(
              communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].firstName.value,
              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].username.value,
                    style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                Text("  |  ", style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
                InkWell(
                  onTap: () {
                    billboardWidgetsMain.believersTabBottomSheet(
                      context: context,
                      id: communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].userId.value,
                      isBelieversList: true,
                    );
                  },
                  child: Text(
                      "${communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].believersCount.value} Believers",
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
                  getAdminBelieveButton(
                    heightValue: height / 34.64,
                    index: index,
                    context: context,
                  ),
                ],
              ),
            ),
          );
        }));
  }

  Widget memberSubAdminCardList({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].avatar.value),
            ),
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
                Text("  |  ", style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
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
            trailing: SizedBox(
              width: width / 3.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getSubAdminBelieveButton(
                    heightValue: height / 34.64,
                    index: index,
                    context: context,
                  ),
                  SizedBox(
                    width: width / 27.4,
                  ),
                  communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "moderator" ||
                          communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "member"
                      ? const SizedBox()
                      : FocusedMenuHolder(
                          menuWidth: width / 1.75,
                          blurSize: 0.5,
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
                                  "Make as sub-admin",
                                  style: TextStyle(fontSize: text.scale(14)),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 0,
                                    groupValue: communitiesVariables.subAdminPerson[index],
                                    onChanged: (value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.subAdminPerson[index] = value!;
                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.subAdminPerson[index] = 0;
                                modelSetState(() {});
                              },
                            ),
                            FocusedMenuItem(
                              title: SizedBox(
                                width: width / 2.34,
                                child: Text(
                                  "Make as moderator",
                                  style: TextStyle(fontSize: text.scale(14)),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 1,
                                    groupValue: communitiesVariables.subAdminPerson[index],
                                    onChanged: (value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.subAdminPerson[index] = value!;
                                      communitiesFunctions.getMemberUpdate(
                                          userId:
                                              communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].userId.value,
                                          communityId:
                                              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                          role: "moderator");
                                      communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList
                                          .add(communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index]);
                                      communitiesVariables.moderatorPerson.add(1);
                                      communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.removeAt(index);
                                      communitiesVariables.subAdminPerson.removeAt(index);

                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.subAdminPerson[index] = 1;
                                communitiesFunctions.getMemberUpdate(
                                    userId: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].userId.value,
                                    communityId:
                                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                    role: "moderator");
                                communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList
                                    .add(communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index]);
                                communitiesVariables.moderatorPerson.add(1);
                                communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.removeAt(index);
                                communitiesVariables.subAdminPerson.removeAt(index);

                                modelSetState(() {});
                              },
                            ),
                            FocusedMenuItem(
                              title: SizedBox(
                                width: width / 2.34,
                                child: Text(
                                  "Make as member",
                                  style: TextStyle(fontSize: text.scale(14)),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 2,
                                    groupValue: communitiesVariables.subAdminPerson[index],
                                    onChanged: (value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.subAdminPerson[index] = value!;
                                      communitiesFunctions.getMemberUpdate(
                                          userId:
                                              communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].userId.value,
                                          communityId:
                                              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                          role: "member");
                                      communitiesVariables.communitiesPageInitialData.value.communityData.membersList
                                          .add(communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index]);
                                      communitiesVariables.memberPerson.add(2);
                                      communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.removeAt(index);
                                      communitiesVariables.subAdminPerson.removeAt(index);

                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.subAdminPerson[index] = 2;
                                communitiesFunctions.getMemberUpdate(
                                    userId: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].userId.value,
                                    communityId:
                                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                    role: "member");
                                communitiesVariables.communitiesPageInitialData.value.communityData.membersList
                                    .add(communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index]);
                                communitiesVariables.memberPerson.add(2);
                                communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.removeAt(index);
                                communitiesVariables.subAdminPerson.removeAt(index);
                                modelSetState(() {});
                              },
                            ),
                            FocusedMenuItem(
                              title: SizedBox(
                                width: width / 2.34,
                                child: Text(
                                  "remove",
                                  style: TextStyle(fontSize: text.scale(14), color: Colors.red),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 3,
                                    groupValue: communitiesVariables.subAdminPerson[index],
                                    onChanged: (value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.subAdminPerson[index] = value!;
                                      communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.removeAt(index);
                                      communitiesVariables.subAdminPerson.removeAt(index);
                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.subAdminPerson[index] = 3;
                                communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList.removeAt(index);
                                communitiesVariables.subAdminPerson.removeAt(index);

                                modelSetState(() {});
                              },
                            ),
                          ],
                          isMe: true,
                          child: const Icon(Icons.more_vert))
                ],
              ),
            ),
          );
        }));
  }

  Widget memberModeratorCardList({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].avatar.value),
            ),
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
                Text("  |  ", style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
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
            trailing: SizedBox(
              width: width / 3.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getModeratorsBelieveButton(
                    heightValue: height / 34.64,
                    index: index,
                    context: context,
                  ),
                  SizedBox(
                    width: width / 27.4,
                  ),
                  communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "moderator" ||
                          communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "member"
                      ? const SizedBox()
                      : FocusedMenuHolder(
                          menuWidth: width / 1.75,
                          blurSize: 0.5,
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
                                  "Make as sub-admin",
                                  style: TextStyle(fontSize: text.scale(14)),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 0,
                                    groupValue: communitiesVariables.moderatorPerson[index],
                                    onChanged: (value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.moderatorPerson[index] = value!;
                                      communitiesFunctions.getMemberUpdate(
                                          userId:
                                              communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].userId.value,
                                          communityId:
                                              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                          role: "subadmin");
                                      communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList
                                          .add(communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index]);
                                      communitiesVariables.subAdminPerson.add(0);
                                      communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.removeAt(index);
                                      communitiesVariables.moderatorPerson.removeAt(index);
                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.moderatorPerson[index] = 0;
                                communitiesFunctions.getMemberUpdate(
                                    userId: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].userId.value,
                                    communityId:
                                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                    role: "subadmin");
                                communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList
                                    .add(communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index]);
                                communitiesVariables.subAdminPerson.add(0);
                                communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.removeAt(index);
                                communitiesVariables.moderatorPerson.removeAt(index);
                                modelSetState(() {});
                              },
                            ),
                            FocusedMenuItem(
                              title: SizedBox(
                                width: width / 2.34,
                                child: Text(
                                  "Make as moderator",
                                  style: TextStyle(fontSize: text.scale(14)),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 1,
                                    groupValue: communitiesVariables.moderatorPerson[index],
                                    onChanged: (value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.moderatorPerson[index] = value!;
                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.moderatorPerson[index] = 1;
                                modelSetState(() {});
                              },
                            ),
                            FocusedMenuItem(
                              title: SizedBox(
                                width: width / 2.34,
                                child: Text(
                                  "Make as member",
                                  style: TextStyle(fontSize: text.scale(14)),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 2,
                                    groupValue: communitiesVariables.moderatorPerson[index],
                                    onChanged: (value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.moderatorPerson[index] = value!;
                                      communitiesFunctions.getMemberUpdate(
                                          userId:
                                              communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].userId.value,
                                          communityId:
                                              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                          role: "member");
                                      communitiesVariables.communitiesPageInitialData.value.communityData.membersList
                                          .add(communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index]);
                                      communitiesVariables.memberPerson.add(2);
                                      communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.removeAt(index);
                                      communitiesVariables.moderatorPerson.removeAt(index);
                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.moderatorPerson[index] = 2;
                                communitiesFunctions.getMemberUpdate(
                                    userId: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].userId.value,
                                    communityId:
                                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                    role: "member");
                                communitiesVariables.communitiesPageInitialData.value.communityData.membersList
                                    .add(communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index]);
                                communitiesVariables.memberPerson.add(2);
                                communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.removeAt(index);
                                communitiesVariables.moderatorPerson.removeAt(index);
                                modelSetState(() {});
                              },
                            ),
                            FocusedMenuItem(
                              title: SizedBox(
                                width: width / 2.34,
                                child: Text(
                                  "remove",
                                  style: TextStyle(fontSize: text.scale(14), color: Colors.red),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 3,
                                    groupValue: communitiesVariables.moderatorPerson[index],
                                    onChanged: (value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.moderatorPerson[index] = value!;
                                      communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.removeAt(index);
                                      communitiesVariables.moderatorPerson.removeAt(index);
                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.moderatorPerson[index] = 3;
                                communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList.removeAt(index);
                                communitiesVariables.moderatorPerson.removeAt(index);

                                modelSetState(() {});
                              },
                            ),
                          ],
                          isMe: true,
                          child: const Icon(Icons.more_vert))
                ],
              ),
            ),
          );
        }));
  }

  Widget membersCardList({
    required BuildContext context,
    required StateSetter modelSetState,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Obx(() => ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: communitiesVariables.communitiesPageInitialData.value.communityData.membersList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].avatar.value),
            ),
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
                Text("  |  ", style: TextStyle(fontSize: text.scale(10), fontWeight: FontWeight.w500, color: const Color(0XFF808080))),
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
            trailing: SizedBox(
              width: width / 3.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getMembersBelieveButton(
                    heightValue: height / 34.64,
                    index: index,
                    context: context,
                  ),
                  SizedBox(
                    width: width / 27.4,
                  ),
                  communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "moderator" ||
                          communitiesVariables.communitiesPageInitialData.value.communityData.userAuthority.value == "member"
                      ? const SizedBox()
                      : FocusedMenuHolder(
                          menuWidth: width / 1.75,
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
                                  "Make as sub-admin",
                                  style: TextStyle(fontSize: text.scale(14)),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 0,
                                    groupValue: communitiesVariables.memberPerson[index],
                                    onChanged: (int? value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.memberPerson[index] = value!;
                                      communitiesFunctions.getMemberUpdate(
                                          userId: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].userId.value,
                                          communityId:
                                              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                          role: "subadmin");
                                      communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList
                                          .add(communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index]);
                                      communitiesVariables.subAdminPerson.add(0);
                                      communitiesVariables.communitiesPageInitialData.value.communityData.membersList.removeAt(index);
                                      communitiesVariables.memberPerson.removeAt(index);

                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.memberPerson[index] = 0;
                                communitiesFunctions.getMemberUpdate(
                                    userId: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].userId.value,
                                    communityId:
                                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                    role: "subadmin");
                                communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList
                                    .add(communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index]);
                                communitiesVariables.subAdminPerson.add(0);
                                communitiesVariables.communitiesPageInitialData.value.communityData.membersList.removeAt(index);
                                communitiesVariables.memberPerson.removeAt(index);

                                modelSetState(() {});
                              },
                            ),
                            FocusedMenuItem(
                              title: SizedBox(
                                width: width / 2.34,
                                child: Text(
                                  "Make as moderator",
                                  style: TextStyle(fontSize: text.scale(14)),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 1,
                                    groupValue: communitiesVariables.memberPerson[index],
                                    onChanged: (int? value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.memberPerson[index] = value!;
                                      communitiesFunctions.getMemberUpdate(
                                          userId: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].userId.value,
                                          communityId:
                                              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                          role: "moderator");
                                      communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList
                                          .add(communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index]);
                                      communitiesVariables.moderatorPerson.add(1);
                                      communitiesVariables.communitiesPageInitialData.value.communityData.membersList.removeAt(index);
                                      communitiesVariables.memberPerson.removeAt(index);

                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.memberPerson[index] = 1;
                                communitiesFunctions.getMemberUpdate(
                                    userId: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].userId.value,
                                    communityId:
                                        communitiesVariables.communitiesPageInitialData.value.communityData.postContents[0].communityId.value,
                                    role: "moderator");
                                communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList
                                    .add(communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index]);
                                communitiesVariables.moderatorPerson.add(1);
                                communitiesVariables.communitiesPageInitialData.value.communityData.membersList.removeAt(index);
                                communitiesVariables.memberPerson.removeAt(index);

                                modelSetState(() {});
                              },
                            ),
                            FocusedMenuItem(
                              title: SizedBox(
                                width: width / 2.34,
                                child: Text(
                                  "Make as member",
                                  style: TextStyle(fontSize: text.scale(14)),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 2,
                                    groupValue: communitiesVariables.memberPerson[index],
                                    onChanged: (int? value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.memberPerson[index] = value!;

                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.memberPerson[index] = 2;

                                modelSetState(() {});
                              },
                            ),
                            FocusedMenuItem(
                              title: SizedBox(
                                width: width / 2.34,
                                child: Text(
                                  "remove",
                                  style: TextStyle(fontSize: text.scale(14), color: Colors.red),
                                ),
                              ),
                              trailingIcon: Obx(() => Radio<int>(
                                    value: 3,
                                    groupValue: communitiesVariables.memberPerson[index],
                                    onChanged: (int? value) async {
                                      Navigator.pop(context);
                                      communitiesVariables.memberPerson[index] = value!;
                                      communitiesVariables.communitiesPageInitialData.value.communityData.membersList.removeAt(index);
                                      communitiesVariables.memberPerson.removeAt(index);

                                      modelSetState(() {});
                                    },
                                  )),
                              onPressed: () async {
                                Navigator.pop(context);
                                communitiesVariables.memberPerson[index] = 3;
                                communitiesVariables.communitiesPageInitialData.value.communityData.membersList.removeAt(index);
                                communitiesVariables.memberPerson.removeAt(index);

                                modelSetState(() {});
                              },
                            ),
                          ],
                          isMe: true,
                          child: const Icon(Icons.more_vert))
                ],
              ),
            ),
          );
        }));
  }

  Widget getAdminBelieveButton({
    required double heightValue,
    required int index,
    required BuildContext context,
    bool? background,
  }) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].userId.value,
            name: communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].username.value,
          );
          if (responseData['message'] == "Believed successfully") {
            communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].believed.value = true;
          } else if (responseData['message'] == "Unbelieved successfully") {
            communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].believed.value = false;
          } else {
            communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].believed.value = false;
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].believed.value
                    ? Colors.transparent
                    : Colors.green,
                border: Border.all(
                    color: communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].believed.value
                        ? const Color(0XFFD9D9D9)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].believed.value ? "Believed" : "Believe",
                  style: TextStyle(
                      color: communitiesVariables.communitiesPageInitialData.value.communityData.adminsList[index].believed.value
                          ? Colors.black
                          : Colors.white),
                ),
              ),
            )));
  }

  Widget getSubAdminBelieveButton({
    required double heightValue,
    required int index,
    required BuildContext context,
    bool? background,
  }) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].userId.value,
            name: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].username.value,
          );
          if (responseData['message'] == "Believed successfully") {
            communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].believed.value = true;
          } else if (responseData['message'] == "Unbelieved successfully") {
            communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].believed.value = false;
          } else {
            communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].believed.value = false;
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].believed.value
                    ? Colors.transparent
                    : Colors.green,
                border: Border.all(
                    color: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].believed.value
                        ? const Color(0XFFD9D9D9)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].believed.value ? "Believed" : "Believe",
                  style: TextStyle(
                      color: communitiesVariables.communitiesPageInitialData.value.communityData.subAdminsList[index].believed.value
                          ? Colors.black
                          : Colors.white),
                ),
              ),
            )));
  }

  Widget getModeratorsBelieveButton({
    required double heightValue,
    required int index,
    required BuildContext context,
    bool? background,
  }) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].userId.value,
            name: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].username.value,
          );
          if (responseData['message'] == "Believed successfully") {
            communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].believed.value = true;
          } else if (responseData['message'] == "Unbelieved successfully") {
            communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].believed.value = false;
          } else {
            communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].believed.value = false;
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].believed.value
                    ? Colors.transparent
                    : Colors.green,
                border: Border.all(
                    color: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].believed.value
                        ? const Color(0XFFD9D9D9)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].believed.value ? "Believed" : "Believe",
                  style: TextStyle(
                      color: communitiesVariables.communitiesPageInitialData.value.communityData.moderatorsList[index].believed.value
                          ? Colors.black
                          : Colors.white),
                ),
              ),
            )));
  }

  Widget getMembersBelieveButton({
    required double heightValue,
    required int index,
    required BuildContext context,
    bool? background,
  }) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].userId.value,
            name: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].username.value,
          );
          if (responseData['message'] == "Believed successfully") {
            communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].believed.value = true;
          } else if (responseData['message'] == "Unbelieved successfully") {
            communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].believed.value = false;
          } else {
            communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].believed.value = false;
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].believed.value
                    ? Colors.transparent
                    : Colors.green,
                border: Border.all(
                    color: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].believed.value
                        ? const Color(0XFFD9D9D9)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].believed.value ? "Believed" : "Believe",
                  style: TextStyle(
                      color: communitiesVariables.communitiesPageInitialData.value.communityData.membersList[index].believed.value
                          ? Colors.black
                          : Colors.white),
                ),
              ),
            )));
  }

  Widget getBelieveButton({
    required double heightValue,
    required int index,
    bool? postRequest,
    required BuildContext context,
    bool? background,
  }) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          if (postRequest != null) {
            Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
              id: communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].userId.value,
              name: communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].username.value,
            );
            if (responseData['message'] == "Believed successfully") {
              communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].believed.value = true;
            } else if (responseData['message'] == "Unbelieved successfully") {
              communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].believed.value = false;
            } else {
              communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].believed.value = false;
            }
          } else {
            Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
              id: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].userId.value,
              name: communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].username.value,
            );
            if (responseData['message'] == "Believed successfully") {
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].believed.value = true;
            } else if (responseData['message'] == "Unbelieved successfully") {
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].believed.value = false;
            } else {
              communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].believed.value = false;
            }
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: postRequest != null
                    ? communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].believed.value
                        ? Colors.transparent
                        : Colors.green
                    : communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].believed.value
                        ? Colors.transparent
                        : Colors.green,
                border: Border.all(
                    color: postRequest != null
                        ? communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].believed.value
                            ? const Color(0XFFD9D9D9)
                            : Colors.transparent
                        : communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].believed.value
                            ? const Color(0XFFD9D9D9)
                            : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  postRequest != null
                      ? communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].believed.value
                          ? "Believed"
                          : "Believe"
                      : communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].believed.value
                          ? "Believed"
                          : "Believe",
                  style: TextStyle(
                      color: postRequest != null
                          ? communitiesVariables.communitiesPageInitialData.value.communityData.postRequests[index].believed.value
                              ? Colors.black
                              : Colors.white
                          : communitiesVariables.communitiesPageInitialData.value.communityData.postContents[index].believed.value
                              ? isDarkTheme.value
                                  ? Colors.white
                                  : Colors.black
                              : Colors.white),
                ),
              ),
            )));
  }

  Widget getResponseBelieveButton({
    required double heightValue,
    required int index,
    required BuildContext context,
    bool? background,
  }) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () async {
          Map<String, dynamic> responseData = await billBoardApiMain.getUserBelieve(
            id: communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].userId.value,
            name: communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].username.value,
          );
          if (responseData['message'] == "Believed successfully") {
            communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].believed.value = true;
          } else if (responseData['message'] == "Unbelieved successfully") {
            communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].believed.value = false;
          } else {
            communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].believed.value = false;
          }
        },
        child: Obx(() => Container(
              height: heightValue,
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              decoration: BoxDecoration(
                color: communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].believed.value
                    ? Colors.transparent
                    : Colors.green,
                border: Border.all(
                    color: communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].believed.value
                        ? const Color(0XFFD9D9D9)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Center(
                child: Text(
                  communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].believed.value ? "Believed" : "Believe",
                  style: TextStyle(
                      color: communitiesVariables.communitiesDescriptionPageResponseList.value.responsesList[index].believed.value
                          ? Colors.black
                          : Colors.white),
                ),
              ),
            )));
  }
}
