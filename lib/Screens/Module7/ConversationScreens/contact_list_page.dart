import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/contact_users_list_model.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationModels/conversation_models.dart';
import 'package:tradewatchfinal/Screens/Module7/ConversationScreens/conversation_page.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  int skipCount = 0;
  bool loader = false;
  ContactUsersListModel? contactUsers;

  // AdmobBannerSize? bannerSize;

  @override
  void initState() {
    getAllDataMain(name: 'Conversation_List_Page');
    //  bannerSize = AdmobBannerSize.LEADERBOARD;
    mainVariables.usersList.clear();
    getData();
    super.initState();
  }

  getData() async {
    debugPrint("hello");
    await conversationApiMain.getUsersList(skipCount: skipCount);
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  if (!mounted) {
                    return;
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onPrimary),
              ),
              title: Text(
                "Users",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(20)),
              ),
            ),
            body: Container(
              margin: EdgeInsets.only(top: height / 57.73),
              padding: EdgeInsets.only(top: height / 57.73, left: width / 27.4, right: width / 27.4),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                  boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3), blurRadius: 4.0, spreadRadius: 0.0)]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height / 57.73),
                  conversationWidgetsMain.getUserListSearchField(context: context, modelSetState: setState),
                  SizedBox(height: height / 57.73),
                  loader
                      ? Obx(
                          () => mainVariables.usersList.isEmpty
                              ? Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: width / 5.77,
                                          width: width / 2.74,
                                          child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: 'No users found',
                                                style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Expanded(
                                  child: SmartRefresher(
                                      controller: loadingRefreshController6,
                                      enablePullDown: false,
                                      enablePullUp: true,
                                      footer: const ClassicFooter(
                                        loadStyle: LoadStyle.ShowWhenLoading,
                                      ),
                                      onLoading: () async {
                                        skipCount = skipCount + 10;
                                        getData();
                                        loadingRefreshController6.loadComplete();
                                        setState(() {});
                                      },
                                      child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          physics: const ScrollPhysics(),
                                          itemCount: mainVariables.usersList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return InkWell(
                                              onTap: () {
                                                mainVariables.conversationUserData.value = ConversationUserData(
                                                    userId: mainVariables.usersList[index].id,
                                                    avatar: mainVariables.usersList[index].avatar,
                                                    firstName: mainVariables.usersList[index].firstName,
                                                    lastName: mainVariables.usersList[index].lastName,
                                                    userName: mainVariables.usersList[index].username,
                                                    isBelieved: mainVariables.usersList[index].believed);
                                                debugPrint(mainVariables.conversationUserData.value.firstName);
                                                debugPrint(mainVariables.conversationUserData.value.userId);
                                                Navigator.push(
                                                    context, MaterialPageRoute(builder: (BuildContext context) => const ConversationPage()));
                                              },
                                              child: Container(
                                                width: width,
                                                margin: EdgeInsets.symmetric(vertical: height / 86.6),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage: NetworkImage(mainVariables.usersList[index].avatar),
                                                        ),
                                                        SizedBox(
                                                          width: width / 27.4,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: width * 0.5,
                                                              child: Text(
                                                                "${mainVariables.usersList[index].firstName.toString().capitalizeFirst!} ${mainVariables.usersList[index].lastName.toString().capitalizeFirst!}",
                                                                style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                              ),
                                                            ),
                                                            Text(
                                                              mainVariables.usersList[index].username,
                                                              style: TextStyle(
                                                                  fontSize: text.scale(12),
                                                                  fontWeight: FontWeight.w500,
                                                                  color: const Color(0XFF737373)),
                                                            ),
                                                            IntrinsicHeight(
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "${mainVariables.usersList[index].believersCount} believers",
                                                                    style: TextStyle(
                                                                        fontSize: text.scale(12),
                                                                        fontWeight: FontWeight.w500,
                                                                        color: const Color(0XFF737373)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    conversationWidgetsMain.getContactBelieveButton(
                                                        heightValue: height / 33.76,
                                                        index: index,
                                                        billboardUserid: mainVariables.usersList[index].id,
                                                        billboardUserName: mainVariables.usersList[index].username,
                                                        context: context,
                                                        background: false,
                                                        modelSetState: setState),
                                                  ],
                                                ),
                                              ),
                                            );
                                          })),
                                ),
                        )
                      : Center(
                          child: Lottie.asset(
                            'lib/Constants/Assets/SMLogos/loading.json',
                            height: height / 8.66,
                            width: width / 4.11,
                          ),
                        ),
                ],
              ),
            )));
  }
}
