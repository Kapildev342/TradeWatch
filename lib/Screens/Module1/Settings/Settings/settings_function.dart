import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/Login/sign_in_page.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/news_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Notifications/notification_categories_model.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/videos_main_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/detailed_forum_image_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/user_profile_data_model.dart';

import 'profile_data_model.dart';

class SettingsFunction {
  Future<ProfileDataModel> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versions + getUser);
    var response = await http.get(url, headers: {'Authorization': mainUserToken});
    var responseData = json.decode(response.body);
    ProfileDataModel profile = ProfileDataModel.fromJson(responseData);
    return profile;
  }

  Future<UserProfileDataModel> getUserProfileData({required String userId}) async {
    var url = Uri.parse(baseurl + versions + getProfile);
    var response = await http.post(url, headers: {'Authorization': kToken}, body: {"userId": userId});
    var responseData = json.decode(response.body);
    UserProfileDataModel profile = UserProfileDataModel.fromJson(responseData);
    return profile;
  }

  Future<Uri> getLinK() async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/HomeScreen'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: 'TradeWatch', description: '', imageUrl: Uri.parse("http://live.tradewatch.in/uploads/tickers/TradeWatch_logo.png")));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  Future<void> send() async {
    final Email email = Email(
      body: "",
      subject: "",
      recipients: ['support@tradewatch.in'],
      attachmentPaths: [],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  deleteAccountLogout({required String email}) async {
    var url = Uri.parse(baseurl + versions + logout);
    final responseData = await http.post(url, body: {"email": email});
    if (responseData.statusCode == 200) {
      responseData.body;
    } else {}
  }

  deleteAccountReset() async {
    authFunctionsMain.signOutUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    prefs.clear();
  }

  deleteAccountFunc({required BuildContext context, required String email}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = baseurl + versions + deleteAccount;
    var response = await dioMain.post(
      url,
      options: Options(headers: {'Authorization': mainUserToken}),
    );
    var responseData = response.data;
    if (responseData["status"]) {
      if (!context.mounted) {
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return SignInPage(emailNew: email);
      }));
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!context.mounted) {
        return;
      }
      Flushbar(
        message: responseData["message"],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  Future notificationFunc({required bool isSwitched, required String slug}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = Uri.parse(baseurl + versions + notificationUpdate);
    var response = await http.post(uri, body: {
      'notification': isSwitched.toString(),
      "type": slug
    }, headers: {
      "authorization": mainUserToken,
    });
    jsonDecode(response.body);
  }

  Future<NotificationCategoriesModel> notificationCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var uri = Uri.parse(baseurl + versions + notificationCategory);
    var response = await http.get(uri, headers: {
      "authorization": mainUserToken,
    });
    var responseData = jsonDecode(response.body);
    NotificationCategoriesModel notifyCategories = NotificationCategoriesModel.fromJson(responseData);
    return notifyCategories;
  }

  settingsBackNavigationFunction({
    required BuildContext context,
    required bool checkMainSkipValue,
    required String fromWhere,
  }) async {
    if (checkMainSkipValue != mainSkipValue) {
      switch (fromWhere) {
        case 'main':
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainBottomNavigationPage(
                        caseNo1: 0,
                        text: finalisedCategory == "" ? "Stocks" : finalisedCategory,
                        excIndex: 1,
                        newIndex: 0,
                        countryIndex: 0,
                        isHomeFirstTym: false,
                        tType: true)));
            break;
          }
        case 'locker':
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainBottomNavigationPage(
                        caseNo1: 1,
                        text: finalisedCategory == "" ? "Stocks" : finalisedCategory,
                        excIndex: 1,
                        newIndex: 0,
                        countryIndex: 0,
                        isHomeFirstTym: false,
                        tType: true)));
            break;
          }
        case 'watchlist':
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainBottomNavigationPage(
                        caseNo1: 3,
                        text: finalisedCategory == "" ? "Stocks" : finalisedCategory,
                        excIndex: 1,
                        newIndex: 0,
                        countryIndex: 0,
                        isHomeFirstTym: false,
                        tType: true)));
            break;
          }
        case 'lockerChart':
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainBottomNavigationPage(
                        caseNo1: 4,
                        text: finalisedCategory == "" ? "Stocks" : finalisedCategory,
                        excIndex: 1,
                        newIndex: 0,
                        countryIndex: 0,
                        isHomeFirstTym: false,
                        tType: true)));
            break;
          }
        case 'newsMain':
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => NewsMainPage(
                          text: finalisedCategory == "" ? "Stocks" : finalisedCategory,
                          fromCompare: false,
                          tickerId: '',
                          tickerName: "",
                        )));
            break;
          }
        case 'videosMain':
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => VideosMainPage(
                          text: finalisedCategory == "" ? "Stocks" : finalisedCategory,
                          tickerId: '',
                          tickerName: '',
                          fromCompare: false,
                        )));
            break;
          }
        case 'forumMain':
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ForumPage(
                          text: finalisedCategory == "" ? "Stocks" : finalisedCategory,
                        )));
            break;
          }
        case 'ForumDetail':
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DetailedForumImagePage(
                          text: finalisedCategory == "" ? "Stocks" : finalisedCategory,
                          fromCompare: false,
                          topic: "Latest Topics",
                          navBool: false,
                          tickerId: '',
                          tickerName: '',
                          sendUserId: '',
                          forumDetail: const {},
                          filterId: '',
                          catIdList: const [],
                        )));
            break;
          }
        case 'forumPost':
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const ForumPostDescriptionPage(
                          idList: [],
                          comeFrom: '',
                          forumId: '',
                        )));
            break;
          }
        default:
          {
            Navigator.pop(context);
            break;
          }
      }
    } else {
      Navigator.pop(context);
    }
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectChip(this.reportList, {super.key, required this.onSelectionChanged});

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.reportList) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          backgroundColor: Colors.grey.shade500,
          selectedColor: const Color(0XFF0EA102),
          label: Text(
            item,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item) ? selectedChoices.remove(item) : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
