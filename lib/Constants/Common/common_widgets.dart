import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Language/language_list_model.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Notifications/notification_categories_model.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/DoubleOne/translation_widget_single_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/ForSurvey/translation_survey_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';

class CommonWidgets {
  bool logOutLoader = false;

  Future deleteAccountBottomSheet({required BuildContext context, required String email}) {
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
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: height / 57.33, horizontal: width / 27.4),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      SizedBox(height: height / 50.75),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.clear,
                                size: 20,
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                        ],
                      ),
                      SizedBox(height: height / 50.75),
                      Center(
                        child: SvgPicture.asset(
                          "lib/Constants/Assets/SMLogos/trash-can(1).svg",
                          height: height / 5.77,
                          width: width / 4.11,
                        ),
                      ),
                      SizedBox(height: height / 27.06),
                      Center(
                          child: SizedBox(
                        width: width / 1.4,
                        child: Text(
                          "Are you sure you want to delete your account?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(18), fontFamily: "Poppins"),
                        ),
                      )),
                      SizedBox(height: height / 50.75),
                      Center(
                          child: SizedBox(
                        width: width / 1.6,
                        child: Text(
                          "By deleting, you will have 30 days to come back before all of your data is permanently removed.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(12), fontFamily: "Poppins"),
                        ),
                      )),
                      SizedBox(height: height / 50.75),
                      SizedBox(
                        width: width / 1.4,
                        height: height / 16.24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () async {
                                  logEventFunc(name: 'Account_Deleted', type: 'User');
                                  await settingsMain.deleteAccountFunc(context: context, email: email);
                                  await settingsMain.deleteAccountReset();
                                  await settingsMain.deleteAccountLogout(email: email);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: width / 12.5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Yes, Delete",
                                      style:
                                          TextStyle(fontWeight: FontWeight.w900, fontSize: text.scale(12), color: Colors.red, fontFamily: "Poppins"),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              width: width / 18.75,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: width / 12.5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "No, Cancel",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: text.scale(12),
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontFamily: "Poppins"),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(height: height / 50.75),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  contactSupportShowSheet({required BuildContext context}) {
    double height = MediaQuery.of(context).size.height;
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
                    onTap: () {
                      logEventFunc(name: 'Chat_Initiated', type: 'SettingsPage');
                      Flushbar(
                        message: "Coming Soon",
                        duration: const Duration(seconds: 2),
                      ).show(context);
                    }
                    /*() async {
                      logEventFunc(name: 'Chat_Initiated', type: 'SettingsPage');
                      if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String fbToken = prefs.getString('FBToken1')!;
                      userInsightFunc(aliasData: 'settings', typeData: 'contact_support');
                      ZohoSalesIQ.setConversationVisibility(true);
                      ZohoSalesIQ.setConversationListTitle("Zoho Chats");
                      ZohoSalesIQ.setFAQVisibility(true);
                      ZohoSalesIQ.startChat("Hello there!!");
                      Platform.isIOS ? ZohoSalesIQ.enableInAppNotification() : debugPrint('nothing');
                      Platform.isIOS ? debugPrint('nothing') : ZohoSalesIQ.disableInAppNotification();
                      Platform.isIOS ? ZohoSalesIQ.enablePushForiOS(fbToken, false, true) : debugPrint('nothing');
                      ZohoSalesIQ.setConversationVisibility(false);
                      ZohoSalesIQ.setVisitorName(userName);
                      ZohoSalesIQ.setVisitorNameVisibility(true);
                      ZohoSalesIQ.setVisitorEmail(emailNew);
                      ZohoSalesIQ.registerVisitor(userName).catchError((onError){
                      });
                      Platform.isIOS ? ZohoSalesIQ.setThemeColorForiOS("#6d85fcff") : debugPrint('nothing');
                    }*/
                    ,
                    minLeadingWidth: width / 25,
                    leading: SizedBox(
                        height: height / 43.3,
                        width: width / 20.55,
                        child: Image.asset(
                          "lib/Constants/Assets/SMLogos/message-circle (1).png",
                        )),
                    title: Text(
                      "Contact via Chat",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      settingsMain.send();
                      functionsMain.userInsightFunc(aliasData: 'settings', typeData: 'contact_support');
                      logEventFunc(name: 'Send_Mail', type: 'SettingsPage');
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    minLeadingWidth: width / 25,
                    leading: SizedBox(
                        height: height / 43.3,
                        width: width / 20.55,
                        child: Image.asset(
                          "lib/Constants/Assets/SMLogos/mail.png",
                        )),
                    title: Text(
                      "Contact via Email",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget getNotifyBadge({required BuildContext context}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Stack(
      alignment: Alignment.topRight,
      children: [
        SizedBox(
          height: height / 25.02,
          width: width / 11.74,
          child: Image.asset(
            isDarkTheme.value ? "assets/home_screen/notify_bell_dark.png" : "assets/home_screen/notify_bell.png",
            fit: BoxFit.fill,
          ),
        ),
        badgeNotifyCount.value == 0
            ? const SizedBox()
            : Container(
                height: height / 54.125,
                width: width / 25.68,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0XFFF5103A),
                ),
                child: Center(
                    child: Text(
                  badgeNotifyCount.value > 99 ? "99+" : badgeNotifyCount.value.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: badgeNotifyCount.value.toString().length == 1
                        ? text.scale(10)
                        : badgeNotifyCount.value.toString().length == 2
                            ? text.scale(8)
                            : text.scale(6),
                  ),
                )),
              )
      ],
    );
  }

  Widget getProfileImage({
    required BuildContext context,
    required bool isLogged,
  }) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return isLogged
        ? Container(
            height: height / 27.375,
            width: width / 12.84,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              "lib/Constants/Assets/SMLogos/bottomBar/Setting_color.svg",
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            ),
          )
        : Obx(() => Container(
              height: height / 27.375,
              width: width / 12.84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(avatarMain.value),
                  fit: BoxFit.fill,
                ),
              ),
            ));
  }

  notifyFilterShowSheet({
    required BuildContext context,
    required List<NotificationCategoryResponse> categoriesList,
    required List<bool> boolList,
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
        context: context,
        isDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height / 17.32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Notification Categories",
                            style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.clear))
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: categoriesList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    minLeadingWidth: width / 25,
                                    leading: Container(
                                      height: height / 28.66,
                                      width: width / 13.7,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(image: NetworkImage(categoriesList[index].image), fit: BoxFit.fill)),
                                    ),
                                    title: Text(
                                      categoriesList[index].name,
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                                    ),
                                    trailing: Switch(
                                        activeTrackColor: Colors.green,
                                        activeColor: Colors.white,
                                        value: boolList[index],
                                        onChanged: (value) {
                                          modelSetState(() {
                                            boolList[index] = value;
                                            settingsMain.notificationFunc(isSwitched: boolList[index], slug: categoriesList[index].slug);
                                          });
                                        }),
                                  ),
                                  Divider(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    thickness: 0.8,
                                  )
                                ],
                              );
                            }),
                      ),
                    ],
                  ));
            },
          );
        });
  }

  Future languagePopUp({required BuildContext context, required LanguageResponse response, required String type}) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter modelSetState) {
                  return Container(
                    height: height / 6,
                    margin: EdgeInsets.symmetric(horizontal: width / 41.1, vertical: height / 86.6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Image.asset(
                          "lib/Constants/Assets/Settings/translation_logo.png",
                          height: height / 21.65,
                          width: width / 10.275,
                          fit: BoxFit.fill,
                        )),
                        SizedBox(height: height / 108.25),
                        Center(
                            child: SizedBox(
                          width: width / 1.644,
                          child: Text(
                            "Do you want '${response.name}' to be your default translated language?",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, color: const Color(0XFF514C4C), fontSize: text.scale(12), fontFamily: "Poppins"),
                            textAlign: TextAlign.center,
                          ),
                        )),
                        const Spacer(),
                        Container(
                          height: height / 34.64,
                          padding: EdgeInsets.symmetric(horizontal: width / 16.44),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width / 16.44),
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                          color: Colors.black, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(12)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: width / 8.22),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0.0,
                                    backgroundColor: const Color(0XFF0EA102),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () async {
                                    languageMain.defaultLanguage(responseSelected: response, type: type);

                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                        //color:Color(0xff0EA102),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                        fontSize: text.scale(12)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ));
        });
  }

  logoutPopUp({required BuildContext context, required String email, required Function initFunction}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter newSetState) {
                  return Container(
                    //color: Colors.red,
                    height: height / 7,
                    margin: EdgeInsets.symmetric(vertical: height / 86.6, horizontal: width / 41.1),
                    child: logOutLoader
                        ? Center(
                            child: Text(
                              "Please wait. Logging out...",
                              style: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(14)),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Text("Logout",
                                      style: TextStyle(
                                          color: const Color(0XFF0EA102),
                                          fontWeight: FontWeight.bold,
                                          fontSize: text.scale(20),
                                          fontFamily: "Poppins"))),
                              SizedBox(height: height / 108.25),
                              Center(
                                  child: Text(
                                "Do you really want to Logout?",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: text.scale(12), fontFamily: "Poppins"),
                              )),
                              const Spacer(),
                              Container(
                                height: height / 36.08,
                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor: const Color(0XFFffffff),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        onPressed: () async {
                                          //if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                                          newSetState(() {
                                            logOutLoader = true;
                                          });
                                          await logEventFunc(
                                            name: 'Sign_out',
                                            type: 'Logged out',
                                          );
                                          await getLogout(emailNew: email);
                                          await resetLogin(authFunctions: authFunctionsMain);
                                          await resetAllValues();
                                          await initFunction();
                                          newSetState(() {
                                            logOutLoader = false;
                                          });
                                          if (!context.mounted) {
                                            return;
                                          }
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => const SettingsSkipView(
                                                        fromWhere: 'logout',
                                                      )));
                                        },
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                              //color:Color(0xff0EA102),
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Poppins",
                                              fontSize: text.scale(12)),
                                        ),
                                      ),
                                      SizedBox(width: width / 6.85),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0XFF0EA102),
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(color: Colors.green), borderRadius: BorderRadius.circular(10)),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "No",
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(12)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                  );
                },
              ));
        });
  }

  Widget translationWidget({
    required List<bool> translationList,
    required List<String> titleList,
    required String id,
    required String type,
    required int index,
    required BuildContext context,
    double? scale,
    Color? color,
    bool? enabled,
    required Function initFunction,
    required StateSetter modelSetState,
    required bool notUse,
  }) {
    return BlocBuilder<TranslationWidgetBloc, TranslationWidgetState>(
      builder: (context, state) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;

        if (state is LoadedTranslationState) {
          return GestureDetector(
              onTap: enabled == false
                  ? () {}
                  : () async {
                      if (mainSkipValue) {
                        commonFlushBar(context: context, initFunction: initFunction);
                      } else {
                        context.read<TranslationWidgetBloc>().add(InitialTranslationEvent(
                            id: id,
                            type: type,
                            translationList: state.translationList,
                            index: index,
                            context: context,
                            initFunction: notUse ? initFunction : () {},
                            titleList: titleList,
                            setState: modelSetState));
                      }
                    },
              child: Card(
                elevation: 1.0,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
                child: Container(
                  height: height / 34.64,
                  width: width / 16.44,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Image.asset(state.translationList[index]
                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                        : "lib/Constants/Assets/Settings/translation.png"),
                  ),
                ),
              ));
        } else {
          return GestureDetector(
              onTap: enabled == false
                  ? () {}
                  : () async {
                      if (mainSkipValue) {
                        commonFlushBar(context: context, initFunction: initFunction);
                      } else {
                        context.read<TranslationWidgetBloc>().add(InitialTranslationEvent(
                            id: id,
                            type: type,
                            translationList: translationList,
                            index: index,
                            context: context,
                            initFunction: notUse ? initFunction : () {},
                            titleList: titleList,
                            setState: modelSetState));
                      }
                    },
              child: Card(
                elevation: 1.0,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
                child: Container(
                  height: height / 34.64,
                  width: width / 16.44,
                  padding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Image.asset(translationList[index]
                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                        : "lib/Constants/Assets/Settings/translation.png"),
                  ),
                ),
                /*child: Image.asset(
                  translationList[index]?
                  "lib/Constants/Assets/Settings/translation_logo_filled.png":
                  "lib/Constants/Assets/Settings/translation_logo.png"),*/
              ));
        }
      },
    );
  }

  Widget translationWidgetSingle({
    required bool translation,
    required String title,
    required String id,
    required String type,
    required int index,
    required BuildContext context,
    double? scale,
    Color? color,
    bool? enabled,
    required Function initFunction,
    required StateSetter modelSetState,
    required bool notUse,
  }) {
    return BlocBuilder<TranslationWidgetSingleBloc, TranslationWidgetSingleState>(
      builder: (context, state) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        if (state is LoadedTranslationSingleState) {
          return GestureDetector(
              onTap: enabled == false
                  ? () {}
                  : () async {
                      if (mainSkipValue) {
                        commonFlushBar(context: context, initFunction: initFunction);
                      } else {
                        context.read<TranslationWidgetSingleBloc>().add(InitialTranslationSingleEvent(
                            id: id,
                            type: type,
                            translation: state.translation,
                            index: index,
                            context: context,
                            initFunction: notUse ? initFunction : () {},
                            title: title,
                            setState: modelSetState));
                      }
                    },
              child: Card(
                elevation: 1.0,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
                child: Container(
                  height: height / 34.64,
                  width: width / 16.44,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Image.asset(state.translation
                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                        : "lib/Constants/Assets/Settings/translation.png"),
                  ),
                ),
              ));
        } else {
          return GestureDetector(
              onTap: enabled == false
                  ? () {}
                  : () async {
                      if (mainSkipValue) {
                        commonFlushBar(context: context, initFunction: initFunction);
                      } else {
                        context.read<TranslationWidgetSingleBloc>().add(InitialTranslationSingleEvent(
                            id: id,
                            type: type,
                            translation: translation,
                            index: index,
                            context: context,
                            initFunction: notUse ? initFunction : () {},
                            title: title,
                            setState: modelSetState));
                      }
                    },
              child: Card(
                elevation: 1.0,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
                child: Container(
                  height: height / 34.64,
                  width: width / 16.44,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Image.asset(
                        translation ? "lib/Constants/Assets/Settings/translation_enabled.png" : "lib/Constants/Assets/Settings/translation.png"),
                  ),
                ),
              ));
        }
      },
    );
  }

  Widget translationChat({
    required List<bool> translationList,
    required List<String> titleList,
    required String id,
    required String type,
    required int index,
    required BuildContext context,
    double? scale,
    Color? color,
    required Function initFunction,
    required StateSetter modelSetState,
    required bool notUse,
  }) {
    return BlocBuilder<TranslationWidgetBloc, TranslationWidgetState>(
      builder: (context, state) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        if (state is LoadedTranslationState) {
          return GestureDetector(
              onTap: () async {
                context.read<TranslationWidgetBloc>().add(InitialTranslationEvent(
                    id: id,
                    type: type,
                    translationList: state.translationList,
                    index: index,
                    context: context,
                    initFunction: notUse ? initFunction : () {},
                    titleList: titleList,
                    setState: modelSetState));
              },
              child: Card(
                elevation: 2.0,
                shadowColor: const Color(0XFF0EA102),
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.white)),
                child: Container(
                  height: height / 34.64,
                  width: width / 16.44,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Image.asset(state.translationList[index]
                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                        : "lib/Constants/Assets/Settings/translation.png"),
                  ),
                ),
              ));
        } else {
          return GestureDetector(
              onTap: () async {
                context.read<TranslationWidgetBloc>().add(InitialTranslationEvent(
                    id: id,
                    type: type,
                    translationList: translationList,
                    index: index,
                    context: context,
                    initFunction: notUse ? initFunction : () {},
                    titleList: titleList,
                    setState: modelSetState));
              },
              child: Card(
                elevation: 2.0,
                shadowColor: const Color(0XFF0EA102),
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Colors.white)),
                child: Container(
                  height: height / 34.64,
                  width: width / 16.44,
                  padding: EdgeInsets.symmetric(horizontal: width / 82.2, vertical: height / 173.2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Image.asset(translationList[index]
                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                        : "lib/Constants/Assets/Settings/translation.png"),
                  ),
                ),
                /*child: Image.asset(
                  translationList[index]?
                  "lib/Constants/Assets/Settings/translation_logo_filled.png":
                  "lib/Constants/Assets/Settings/translation_logo.png"),*/
              ));
        }
      },
    );
  }

  Widget translationWidgetSurvey({
    required bool translation,
    required List<String> questionList,
    required List<String> answer1List,
    required List<String> answer2List,
    required List<String> answer3List,
    required List<String> answer4List,
    required List<String> answer5List,
    required String id,
    required String type,
    required int index,
    required BuildContext context,
    double? scale,
    Color? color,
    bool? enabled,
    required Function initFunction,
    required StateSetter modelSetState,
    required bool notUse,
  }) {
    return BlocBuilder<TranslationSurveyBloc, TranslationSurveyState>(
      builder: (context, state) {
        double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
        if (state is LoadedTranslationSurveyState) {
          return GestureDetector(
              onTap: enabled == false
                  ? () {}
                  : () async {
                      if (mainSkipValue) {
                        commonFlushBar(context: context, initFunction: initFunction);
                      } else {
                        context.read<TranslationSurveyBloc>().add(InitialTranslationSurveyEvent(
                            id: id,
                            type: type,
                            translation: state.translation,
                            index: index,
                            context: context,
                            initFunction: notUse ? initFunction : () {},
                            setState: modelSetState,
                            questionList: questionList,
                            answer1List: answer1List,
                            answer2List: answer2List,
                            answer3List: answer3List,
                            answer4List: answer4List,
                            answer5List: answer5List));
                      }
                    },
              child: Card(
                elevation: 1.0,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
                child: Container(
                  height: height / 34.64,
                  width: width / 16.44,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Image.asset(state.translation
                        ? "lib/Constants/Assets/Settings/translation_enabled.png"
                        : "lib/Constants/Assets/Settings/translation.png"),
                  ),
                ),
              ));
        } else {
          return GestureDetector(
              onTap: enabled == false
                  ? () {}
                  : () async {
                      if (mainSkipValue) {
                        commonFlushBar(context: context, initFunction: initFunction);
                      } else {
                        context.read<TranslationSurveyBloc>().add(InitialTranslationSurveyEvent(
                            id: id,
                            type: type,
                            translation: translation,
                            index: index,
                            context: context,
                            initFunction: notUse ? initFunction : () {},
                            setState: modelSetState,
                            questionList: questionList,
                            answer1List: answer1List,
                            answer2List: answer2List,
                            answer3List: answer3List,
                            answer4List: answer4List,
                            answer5List: answer5List));
                      }
                    },
              child: Card(
                elevation: 1.0,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.white)),
                child: Container(
                  height: height / 34.64,
                  width: width / 16.44,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Image.asset(
                        translation ? "lib/Constants/Assets/Settings/translation_enabled.png" : "lib/Constants/Assets/Settings/translation.png"),
                  ),
                ),
              ));
        }
      },
    );
  }

  Future<dynamic> translationPage({required BuildContext context, Function? initFunction}) async {
    double height = MediaQuery.of(context).size.height;
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom == 0.0 ? height / 1.732 : height / 1.08,
              child: const LanguageViewDefault(
                audio: false,
              ));
        }).whenComplete(() {
      if (initFunction != null) {
        mainSkipValue ? debugPrint("non login") : initFunction();
      }
    });
  }
}

class LanguageViewDefault extends StatefulWidget {
  final bool audio;

  const LanguageViewDefault({Key? key, required this.audio}) : super(key: key);

  @override
  State<LanguageViewDefault> createState() => _LanguageViewDefaultState();
}

class _LanguageViewDefaultState extends State<LanguageViewDefault> {
  final TextEditingController _searchController = TextEditingController();
  late LanguageListModel language;
  bool loader = false;
  int selectedIndex = 0;
  List<LanguageResponse> popularLanguageList = [];
  List<LanguageResponse> searchPopularLanguageList = [];
  List<LanguageResponse> allLanguageList = [];
  List<LanguageResponse> searchAllLanguageList = [];
  late LanguageResponse selectedResponse;
  String selectedLanguage = "";

  @override
  void initState() {
    getAllDataMain(name: 'Settings_Page');
    pageVisitFunc(pageName: 'settings');
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      loader = false;
    });
    language = await languageMain.getData(type: widget.audio ? 'audio' : 'text');
    for (int i = 0; i < language.limit; i++) {
      popularLanguageList.add(language.response[i]);
      searchPopularLanguageList.add(language.response[i]);
    }
    for (int j = language.limit; j < language.response.length; j++) {
      allLanguageList.add(language.response[j]);
      searchAllLanguageList.add(language.response[j]);
    }
    String defaultLanguage = language.defaultLanguage == ""
        ? widget.audio
            ? 'en-IN'
            : 'en'
        : language.defaultLanguage;
    selectedResponse = language.response.firstWhere((e) => e.code == defaultLanguage);
    selectedLanguage = selectedResponse.name;
    setState(() {
      loader = true;
    });
  }

  void filterSearchResults({required String query}) {
    if (query.isEmpty) {
      setState(() {
        searchPopularLanguageList = popularLanguageList.toList();
        searchAllLanguageList = allLanguageList.toList();
      });
    } else {
      setState(() {
        searchPopularLanguageList = popularLanguageList.where((item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
        searchAllLanguageList = allLanguageList.where((item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: width / 27.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 54.125,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.audio ? 'Audio Translation' : 'Language Translation',
                      style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                    ),
                    IconButton(
                        onPressed: () {
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
                SizedBox(
                  height: height / 54.125,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Default Translated",
                      style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          selectedLanguage,
                          style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                        ),
                        SizedBox(width: width / 41.1),
                        const Icon(Icons.keyboard_arrow_down_outlined)
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height / 28.86,
                ),
                TextFormField(
                  onChanged: (value) {
                    filterSearchResults(query: value);
                  },
                  cursorColor: Colors.green,
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: _searchController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.tertiary,
                    filled: true,
                    contentPadding: EdgeInsets.only(left: width / 27.4),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
                      child: SvgPicture.asset("lib/Constants/Assets/SMLogos/HomeScreen/Icon Search.svg"),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchController.clear();
                                filterSearchResults(query: "");
                              });
                            },
                            child: const Icon(Icons.cancel, size: 22),
                          )
                        : const SizedBox(),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: const Color(0XFFA5A5A5)),
                    hintText: 'Search here',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffD8D8D8), width: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(
                  height: height / 28.86,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: searchPopularLanguageList.isEmpty && searchAllLanguageList.isEmpty
                        ? SizedBox(
                            height: height / 1.5,
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: height / 5.773,
                                      width: width / 2.74,
                                      child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Unfortunately, there is nothing to display!',
                                            style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              searchPopularLanguageList.isEmpty
                                  ? const SizedBox()
                                  : Text(
                                      'Popular Languages',
                                      style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                                    ),
                              searchPopularLanguageList.isEmpty
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: height / 54.125,
                                    ),
                              searchPopularLanguageList.isEmpty
                                  ? const SizedBox()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: searchPopularLanguageList.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (BuildContext context, int index) {
                                        return RadioListTile(
                                            title: Text(searchPopularLanguageList[index].name),
                                            controlAffinity: ListTileControlAffinity.trailing,
                                            value: searchPopularLanguageList[index],
                                            groupValue: selectedResponse,
                                            selected: selectedResponse == searchPopularLanguageList[index],
                                            onChanged: (value) {
                                              selectedResponse = searchPopularLanguageList[index];
                                              widgetsMain
                                                  .languagePopUp(context: context, response: selectedResponse, type: widget.audio ? 'audio' : 'text')
                                                  .then((value) {
                                                setState(() {
                                                  selectedLanguage = searchPopularLanguageList[index].name;
                                                });
                                              });
                                            });
                                      }),
                              searchPopularLanguageList.isEmpty
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: height / 28.86,
                                    ),
                              searchAllLanguageList.isEmpty
                                  ? const SizedBox()
                                  : Text(
                                      'All Languages',
                                      style: TextStyle(fontSize: text.scale(16), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                                    ),
                              searchAllLanguageList.isEmpty
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: height / 54.125,
                                    ),
                              searchAllLanguageList.isEmpty
                                  ? const SizedBox()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: searchAllLanguageList.length,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (BuildContext context, int index) {
                                        return RadioListTile(
                                            title: Text(searchAllLanguageList[index].name),
                                            controlAffinity: ListTileControlAffinity.trailing,
                                            value: searchAllLanguageList[index],
                                            groupValue: selectedResponse,
                                            selected: selectedResponse == searchAllLanguageList[index],
                                            onChanged: (value) {
                                              selectedResponse = searchAllLanguageList[index];
                                              widgetsMain
                                                  .languagePopUp(context: context, response: selectedResponse, type: widget.audio ? 'audio' : 'text')
                                                  .then((value) {
                                                setState(() {
                                                  selectedLanguage = searchAllLanguageList[index].name;
                                                });
                                              });
                                            });
                                      }),
                              searchAllLanguageList.isEmpty
                                  ? const SizedBox()
                                  : SizedBox(
                                      height: height / 54.125,
                                    ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: Lottie.asset(
              'lib/Constants/Assets/SMLogos/loading.json',
              height: height / 8.66,
              width: width / 4.11,
            ),
          );
  }
}
