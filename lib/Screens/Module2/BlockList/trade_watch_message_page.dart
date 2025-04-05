import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';

class TradeWatchMessagePage extends StatefulWidget {
  const TradeWatchMessagePage({Key? key}) : super(key: key);

  @override
  State<TradeWatchMessagePage> createState() => _TradeWatchMessagePageState();
}

class _TradeWatchMessagePageState extends State<TradeWatchMessagePage> {
  getNotifyCountAndImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await functionsMain.getNotifyCount();
    avatarMain.value = prefs.getString('newUserAvatar') ?? "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png";
  }

  @override
  void initState() {
    getAllDataMain(name: 'Trade_Watch_Message_Page');
    getNotifyCountAndImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      //color: const Color(0XFFFFFFFF),
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Scaffold(
          //  backgroundColor: const Color(0XFFFFFFFF),
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            toolbarHeight: 80,
            leadingWidth: 35,
            elevation: 0.0,
            //backgroundColor: const Color(0XFFFFFFFF),
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: GestureDetector(
                onTap: () {
                  if (!mounted) {
                    return;
                  }
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 25,
                  ),
                )),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Messages from TradeWatch",
                  style: TextStyle(fontSize: text.scale(15), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: const Center(
              child: Text(
            "No message to display.",
            style: TextStyle(color: Color(0XFF0EA102), fontSize: 15),
          )),
        ),
      ),
    );
  }
}
