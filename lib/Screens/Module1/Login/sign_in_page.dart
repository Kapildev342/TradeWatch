import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/EditProfilePage/edit_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_function.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_skip_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/settings_view.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/coming_soon_page.dart';
import 'package:tradewatchfinal/Screens/Module1/my_activity_page.dart';
import 'package:tradewatchfinal/Screens/Module1/notifications_page.dart';
import 'package:tradewatchfinal/Screens/Module2/BlockList/block_list_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_post_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_add_filter.dart';

import 'code_verification_page.dart';
import 'forget_password_page.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  final String? emailNew;
  final String? navBool;
  final String? category;
  final String? id;
  final String? toWhere;
  final String? filterId;
  final bool? activity;
  final String? fromWhere;

  const SignInPage(
      {Key? key,
      this.activity,
      this.emailNew = "",
      this.navBool = "",
      this.category = "",
      this.id = "",
      this.toWhere = "",
      this.filterId = "",
      this.fromWhere})
      : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with WidgetsBindingObserver {
  FirebaseInstallations installations = FirebaseInstallations.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  late String email, pass;
  String userEmail = "";
  String regStatus = "";
  String regId = "";
  String regToken = "";
  String regLocker = "";
  bool exitApp = false;
  List<String> pathList = [];
  bool doNotShowPassword = false;
  bool loading = false;
  String twitterToken = "";
  bool regComplete = false;
  bool socialLoading = false;
  String newId = "";
  UserCredential? userMain;
  final TextEditingController _descriptionController = TextEditingController();
  List<String> feedbackList = [
    "Not sure why",
    "Didn't find value",
    "Bug issues",
    "Product didn't work",
    "Was not cool enough",
    "Found better app",
  ];
  List<String> selectedFeedbackList = [];
  bool emailEmpty = false;

  // bool emailEmptyValid=false;
  bool passwordEmpty = false;

  login({required String email1, required String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};
    if (email1 == "" || password == "") {
      if (email1 == "" && password == "") {
        emailEmpty = true;
        passwordEmpty = true;
      }
      else if (email1 == "" && password != "") {
        emailEmpty = true;
        passwordEmpty = false;
      }
      else if (email1 != "" && password == "") {
        emailEmpty = false;
        passwordEmpty = true;
        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email1);
        if (emailValid) {
          //emailEmptyValid=false;
        } else {
          //emailEmptyValid=true;
        }
      }
      else {
        emailEmpty = false;
        passwordEmpty = false;
        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email1);
        if (emailValid) {
          //emailEmptyValid=false;
        } else {
          //emailEmptyValid=true;
        }
      }
      setState(() {
        loading = false;
      });
    } else {
      emailEmpty = false;
      passwordEmpty = false;
      // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email1);
      // if(emailValid){
      //emailEmptyValid=false;
      var url = Uri.parse(baseurl + versions + newLogin);
      data = {
        "email": email1,
        "password": password,
        "device_token": functionsMain.fireBasToken,
        "device_type": Platform.isIOS ? "ios" : "android",
        "device_id": functionsMain.deviceId
      };
      var response = await http.post(url, body: data, headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      var responseData = json.decode(response.body);
      if (responseData["status"]) {
        logEventFunc(
          name: 'Login',
          type: 'normal',
        );
        regId = responseData["response"]["id"];
        setUserIDAnalyticsFunc(userId: regId, name: responseData["response"]["username"], value: responseData["response"]["email"]);
        regToken = responseData["response"]["token"];
        regLocker = responseData["response"]["locker"];
        String regAvatar = responseData["response"]["avatar"];
        mainSkipValue = false;
        //prefs.setBool("skipValue", mainSkipValue);
        kToken = regToken;
        prefs.setString('newUserId', regId);
        prefs.setString('newUserToken', regToken);
        prefs.setString('newUserLocker', regLocker);
        prefs.setString('newUserAvatar', regAvatar);
        avatarMain.value = regAvatar;
        if (!mounted) {
          return false;
        }
        conversationFunctionsMain.getSocketFunction(context: context);
        if (widget.fromWhere == "finalCharts") {
          Navigator.pop(context, true);
        } else if (widget.fromWhere == "settings") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return mainSkipValue ? const SettingsSkipView() : const SettingsView(fromWhere: "signIn");
          }));
        } else if (widget.fromWhere == "forum") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ForumPage(
                text: finalisedCategory.toLowerCase() == 'stocks'
                    ? "Stocks"
                    : finalisedCategory.toLowerCase() == 'crypto'
                        ? "Crypto"
                        : finalisedCategory.toLowerCase() == 'commodity'
                            ? "Commodity"
                            : "Forex");
          }));
        } else if (widget.fromWhere == "survey") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SurveyPage(
                text: finalisedCategory.toLowerCase() == 'stocks'
                    ? "Stocks"
                    : finalisedCategory.toLowerCase() == 'crypto'
                        ? "Crypto"
                        : finalisedCategory.toLowerCase() == 'commodity'
                            ? "Commodity"
                            : "Forex");
          }));
        } else if (widget.fromWhere == "broker") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const ComingSoonPage();
          }));
        } else if (widget.fromWhere == "notification") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
            return const NotificationsPage(
              fromWhere: 'signIn',
            );
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return /*HomePageView()*/
                widget.toWhere == "ForumPostDescriptionPage"
                    ? ForumPostDescriptionPage(
                        comeFrom: widget.navBool!,
                        forumId: widget.id!,
                        idList: const [],
                      )
                    : widget.toWhere == "FeaturePostDescriptionPage"
                        ? FeaturePostDescriptionPage(
                            navBool: 'main',
                            sortValue: widget.category!,
                            featureId: widget.id!,
                            featureDetail: const {},
                            idList: const [],
                          )
                        : widget.toWhere == "AnalyticsPage"
                            ? AnalyticsPage(
                                surveyTitle: widget.category!,
                                activity: false,
                                surveyId: widget.id!,
                                navBool: widget.activity,
                              )
                            : widget.toWhere == "StocksAddFilterPage"
                                ? StocksAddFilterPage(text: widget.category!, page: 'locker')
                                : widget.toWhere == "ForumPage"
                                    ? ForumPage(text: widget.category!)
                                    : widget.toWhere == "SurveyPage"
                                        ? SurveyPage(text: widget.category!)
                                        : /*
                widget.toWhere=="ComparePage"?
                ComparePage(text: widget.category!,fromLink: widget.activity!,):*/
                                        widget.toWhere == "FeaturePostPage"
                                            ? FeaturePostPage(
                                                fromLink: widget.activity!,
                                              )
                                            : widget.toWhere == "ForumPostPage"
                                                ? ForumPostPage(
                                                    text: widget.category!,
                                                    fromLink: widget.activity!,
                                                  )
                                                : widget.toWhere == "SurveyPostPage"
                                                    ? SurveyPostPage(
                                                        text: widget.category!,
                                                        fromLink: widget.activity!,
                                                      )
                                                    : widget.toWhere == "MyActivityPage"
                                                        ? MyActivityPage(
                                                            fromLink: widget.activity!,
                                                          )
                                                        : widget.toWhere == "BlockListPage"
                                                            ? BlockListPage(
                                                                fromLink: widget.activity!,
                                                                blockBool: true,
                                                                tabIndex: 0,
                                                              )
                                                            : widget.toWhere == "EditProfilePage"
                                                                ? EditProfilePage(comeFrom: widget.activity!)
                                                                : MainBottomNavigationPage(
                                                                    tType: true,
                                                                    text: regLocker,
                                                                    caseNo1: 0,
                                                                    newIndex: 0,
                                                                    excIndex: 1,
                                                                    countryIndex: 0,
                                                                    isHomeFirstTym: true);
          }));
        }
        _passwordController.clear();
        _emailController.clear();
      } else {
        if (responseData.containsKey("phone")) {
          await sendOtpFunc(phone: responseData["phone"], data: data, socialMediaType: '', loginType: false);
        } else {
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: responseData["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
          setState(() {
            loading = false;
          });
        }
      }
    }
  }

  sendOtpFunc(
      {required Map<String, dynamic> phone, required Map<String, dynamic> data, required bool loginType, required String socialMediaType}) async {
    String completeNumber = phone['code'] + phone['number'];
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: completeNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == "too-many-requests") {
          Flushbar(
            message: "OTP has sent too many times to this number, Please try again after",
            duration: const Duration(seconds: 2),
          ).show(context);
        }
        if (e.code == 'invalid-phone-number') {}
        setState(() {
          loading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) async {
        String verifyId = verificationId;
        bool response = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return InactiveCodeVerifyPage(
            dialCode: phone['code'],
            phone: phone['number'],
            verifyId: verifyId,
            data: data,
            loginType: loginType,
            socialMediaType: socialMediaType,
          );
        }));
        if (response) {
          setState(() {
            loading = false;
          });
        }
        _passwordController.clear();
        _emailController.clear();
      },
      timeout: const Duration(seconds: 25),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  socialMediaLogin({
    required String? email,
    required String uid,
    required String type,
    required String firstName,
    required String lastName,
    required String userName,
    required String phoneCode,
    required String? phoneNumber,
    required String referralCode,
    required String socialAvatar,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {};
    var url = Uri.parse(baseurl + versions + checkSocial);
    var response = await http.post(url, body: {"socialid": uid, "type": type, "Page": "sign_in"});
    var responseData = json.decode(response.body);
    if (!responseData["status"]) {
      var url = Uri.parse(baseurl + versions + socialLogin);
      data = {
        "email": responseData["email"] == "" ? responseData["phone_number"] : responseData["email"],
        "socialid": uid,
        "device_id": functionsMain.deviceId,
        "device_token": functionsMain.fireBasToken,
        "device_type": Platform.isIOS ? "ios" : "android",
        "type": type
      };
      var response = await http.post(
        url,
        body: data,
      );
      var responseData1 = json.decode(response.body);
      if (responseData1["status"]) {
        logEventFunc(name: 'Social_Media_Login', type: type);
        regId = responseData1["response"]["id"];
        setUserIDAnalyticsFunc(userId: regId, name: responseData1["response"]["username"], value: responseData1["response"]["email"]);
        regToken = responseData1["response"]["token"];
        regLocker = responseData1["response"]["locker"];
        String regAvatar = responseData1["response"]["avatar"];
        mainSkipValue = false;
        //prefs.setBool("skipValue", mainSkipValue);
        kToken = regToken;
        prefs.setString('newUserId', regId);
        prefs.setString('newUserToken', regToken);
        prefs.setString('newUserLocker', regLocker);
        prefs.setString('newUserAvatar', regAvatar);
        if (!mounted) {
          return false;
        }
        conversationFunctionsMain.getSocketFunction(context: context);
        avatarMain.value = regAvatar;
        if (widget.fromWhere == "finalCharts") {
          Navigator.pop(context, true);
        } else if (widget.fromWhere == "settings") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return mainSkipValue ? const SettingsSkipView() : const SettingsView(fromWhere: "signIn");
          }));
        } else if (widget.fromWhere == "forum") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return ForumPage(
                text: finalisedCategory.toLowerCase() == 'stocks'
                    ? "Stocks"
                    : finalisedCategory.toLowerCase() == 'crypto'
                        ? "Crypto"
                        : finalisedCategory.toLowerCase() == 'commodity'
                            ? "Commodity"
                            : "Forex");
          }));
        } else if (widget.fromWhere == "survey") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return SurveyPage(
                text: finalisedCategory.toLowerCase() == 'stocks'
                    ? "Stocks"
                    : finalisedCategory.toLowerCase() == 'crypto'
                        ? "Crypto"
                        : finalisedCategory.toLowerCase() == 'commodity'
                            ? "Commodity"
                            : "Forex");
          }));
        } else if (widget.fromWhere == "broker") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const ComingSoonPage();
          }));
        } else if (widget.fromWhere == "notification") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
            return const NotificationsPage(fromWhere: 'signIn');
          }));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return widget.toWhere == "ForumPostDescriptionPage"
                ? ForumPostDescriptionPage(
                    comeFrom: widget.navBool!,
                    forumId: widget.id!,
                    idList: const [],
                  )
                : widget.toWhere == "FeaturePostDescriptionPage"
                    ? FeaturePostDescriptionPage(
                        navBool: 'main',
                        sortValue: widget.category!,
                        featureId: widget.id!,
                        featureDetail: const {},
                        idList: const [],
                      )
                    : widget.toWhere == "AnalyticsPage"
                        ? AnalyticsPage(
                            surveyTitle: widget.category!,
                            activity: false,
                            surveyId: widget.id!,
                            navBool: widget.activity,
                          )
                        : widget.toWhere == "StocksAddFilterPage"
                            ? StocksAddFilterPage(
                                text: widget.category!,
                                page: 'locker',
                              )
                            : widget.toWhere == "ForumPage"
                                ? ForumPage(text: widget.category!)
                                : widget.toWhere == "SurveyPage"
                                    ? SurveyPage(text: widget.category!)
                                    : /*
          widget.toWhere=="ComparePage"?
          ComparePage(text: widget.category!,fromLink: widget.activity!,):*/
                                    widget.toWhere == "FeaturePostPage"
                                        ? FeaturePostPage(
                                            fromLink: widget.activity!,
                                          )
                                        : widget.toWhere == "ForumPostPage"
                                            ? ForumPostPage(
                                                text: widget.category!,
                                                fromLink: widget.activity!,
                                              )
                                            : widget.toWhere == "SurveyPostPage"
                                                ? SurveyPostPage(
                                                    text: widget.category!,
                                                    fromLink: widget.activity!,
                                                  )
                                                : widget.toWhere == "MyActivityPage"
                                                    ? MyActivityPage(
                                                        fromLink: widget.activity!,
                                                      )
                                                    : widget.toWhere == "BlockListPage"
                                                        ? BlockListPage(
                                                            fromLink: widget.activity!,
                                                            blockBool: true,
                                                            tabIndex: 0,
                                                          )
                                                        : widget.toWhere == "EditProfilePage"
                                                            ? EditProfilePage(comeFrom: widget.activity!)
                                                            : MainBottomNavigationPage(
                                                                tType: true,
                                                                text: regLocker,
                                                                caseNo1: 0,
                                                                newIndex: 0,
                                                                excIndex: 1,
                                                                countryIndex: 0,
                                                                isHomeFirstTym: true);
          }));
        }
        setState(() {
          loading = false;
        });
      } else {
        if (responseData1.containsKey("phone")) {
          await sendOtpFunc(phone: responseData1["phone"], data: data, socialMediaType: type, loginType: true);
        } else {
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: responseData1["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
          setState(() {
            loading = false;
            socialLoading = false;
          });
        }
      }
    } else {
      setState(() {
        socialLoading = false;
      });
      if (!mounted) {
        return false;
      }
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return SignUpPage(
          firstName: firstName,
          lastName: lastName,
          userName: userName,
          email: email,
          socialId: uid,
          type: type,
          phoneCode: phoneCode,
          phoneNumber: phoneNumber ?? "",
          devType: Platform.isIOS ? "ios" : "android",
          referralCode: "",
          socialAvatar: socialAvatar,
          noPass: true,
          navBool: widget.navBool,
          category: widget.category,
          id: widget.id,
          toWhere: widget.toWhere,
          activity: widget.activity,
        );
      }));
    }
  }

  userInsightFunc({required String typeData, required String aliasData}) async {
    var url = Uri.parse(baseurl + versions + userInsightUpdate);
    await http.post(
      url,
      body: {"alias": aliasData, "type": typeData},
    );
    //var responseData = json.decode(response.body);
  }

  @override
  void initState() {
    getAllDataMain(name: 'Sign_In_Screen');
    WidgetsBinding.instance.addObserver(this);
    doNotShowPassword = true;
    // functionsMain.fireBaseCloudMessagingListeners();
    getAlert();
    super.initState();
  }

  getAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.emailNew == "" ? debugPrint("nothing") : showAlertDialog();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }

  showAlertDialog() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: SingleChildScrollView(
            reverse: false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: Text(
                    "Reason for Leaving ?",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  )),
                  Container(
                    height: height / 81.2,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        const Color(0XFF0EA102).withOpacity(0.9),
                        const Color(0XFF0EA102).withOpacity(0.1),
                      ],
                    )),
                  )
                ],
              ),
              content: SizedBox(
                height: height / 1.9,
                child: Column(
                  children: [
                    MultiSelectChip(
                      feedbackList,
                      onSelectionChanged: (selectedList) {
                        setState(() {
                          selectedFeedbackList = selectedList;
                        });
                      },
                    ),
                    const Divider(
                      thickness: 3,
                    ),
                    SizedBox(
                      height: height / 50.75,
                    ),
                    const Center(
                        child: Text(
                      "Tell us why your Leaving ?",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    )),
                    SizedBox(
                      height: height / 50.75,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width / 25),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xffD8D8D8).withOpacity(0.5))),
                      height: height / 6,
                      child: TextFormField(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: text.scale(12),
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400),
                        controller: _descriptionController,
                        keyboardType: TextInputType.name,
                        maxLines: null,
                        decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "Enter a description...",
                            hintStyle: TextStyle(
                                color: const Color(0XFFB0B0B0), fontSize: text.scale(12), fontFamily: "Poppins", fontWeight: FontWeight.w400)),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text(
                    "Never Mind",
                    style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    if (!mounted) {
                      return;
                    }
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  child: const Text(
                    "Send feedback",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    if (!mounted) {
                      return;
                    }
                    Navigator.pop(context);
                    await feedbackFunc();
                  },
                ),
                SizedBox(
                  width: width / 37.5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  feedbackFunc() async {
    //var url = Uri.parse(baseurl + versions + updateDelete);
    var url = baseurl + versions + updateDelete;
    await dioMain.post(url, data: {'reason': selectedFeedbackList, 'description': _descriptionController.text, 'email': widget.emailNew});
    //var responseDataNew = json.decode(response.body);
    // var responseDataNew = response.data;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (scroll) {
        scroll.disallowIndicator();
        return true;
      },
      child: WillPopScope(
        onWillPop: () async {
          if (widget.fromWhere == "link") {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return const MainBottomNavigationPage(
                caseNo1: 0,
                text: '',
                excIndex: 1,
                newIndex: 0,
                countryIndex: 0,
                isHomeFirstTym: false,
                tType: true,
              );
            }));
          } else {
            if (socialLoading) {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const SignInPage();
              }));
            } else {
              if (widget.fromWhere == "finalCharts") {
                // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
              }
              /*if (!mounted) {
                return false;
              }*/
              Navigator.pop(context);
            }
          }
          return false;
        },
        child: Container(
          //color: const Color(0XFFFFFFFF),
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                toolbarHeight: socialLoading ? height / 16.24 : height / 16.24,
                leading: GestureDetector(
                    onTap: () {
                      if (widget.fromWhere == "link") {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                          return const MainBottomNavigationPage(
                            caseNo1: 0,
                            text: '',
                            excIndex: 1,
                            newIndex: 0,
                            countryIndex: 0,
                            isHomeFirstTym: false,
                            tType: true,
                          );
                        }));
                      } else {
                        if (socialLoading) {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                            return const SignInPage();
                          }));
                        } else {
                          if (widget.fromWhere == "finalCharts") {
                            //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                          }
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
              ),
              body: socialLoading
                  ? Center(
                      child: Container(
                        height: 150,
                        width: width * 0.75,
                        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Please Wait..."),
                            const SizedBox(
                              height: 15,
                            ),
                            Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height / 27.06),
                            Text(
                              "Sign In",
                              style: TextStyle(fontSize: text.scale(28), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Welcome back to",
                                    style: TextStyle(
                                        fontSize: text.scale(18),
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins")),
                                Text(" Trade Watch",
                                    style: TextStyle(
                                        fontSize: text.scale(18),
                                        color: const Color(0XFF0EA102),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins")),
                              ],
                            ),
                            SizedBox(height: height / 16.24),
                            TextFormField(
                              style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelStyle: TextStyle(
                                    color: const Color(0XFFA5A5A5), fontSize: text.scale(15), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                                labelText: 'Email or Phone Number',
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            emailEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [Text("Enter email address", style: TextStyle(fontSize: 11, color: Colors.red))],
                                    ))
                                : const SizedBox(),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                              obscureText: doNotShowPassword,
                              controller: _passwordController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelStyle: TextStyle(
                                    color: const Color(0XFFA5A5A5), fontSize: text.scale(15), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                                labelText: 'Password',
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      doNotShowPassword = !doNotShowPassword;
                                    });
                                  },
                                  child: doNotShowPassword
                                      ? const Icon(
                                          Icons.visibility_off,
                                          color: Color(0XFFA5A5A5),
                                          size: 25,
                                        )
                                      : const Icon(
                                          Icons.visibility,
                                          color: Color(0XFF0EA102),
                                          size: 25,
                                        ),
                                ),
                              ),
                            ),
                            passwordEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [Text("Enter password", style: TextStyle(fontSize: 11, color: Colors.red))],
                                    ))
                                : const SizedBox(),
                            SizedBox(
                              height: height / 32.48,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                        return const ForgetPasswordPage();
                                      }));
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          fontSize: text.scale(14),
                                          color: const Color(0XFF7EBA00),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins"),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: height / 32.48,
                            ),
                            loading
                                ? Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100))
                                : GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      login(password: _passwordController.text, email1: _emailController.text);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        color: Color(0XFF0EA102),
                                      ),
                                      width: width,
                                      height: height / 14.5,
                                      child: Center(
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: height / 32.48,
                            ),
                            Center(
                                child: Text(
                              "Or continue with",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), fontFamily: "Poppins"),
                            )),
                            SizedBox(
                              height: height / 23.2,
                            ),
                            Platform.isIOS
                                ? Center(
                                    child: SizedBox(
                                      width: width / 1.61,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              setState(() {
                                                socialLoading = true;
                                              });
                                              UserCredential? user = await authFunctionsMain.signInWithGoogle();
                                              if (user == null) {
                                                setState(() {
                                                  socialLoading = false;
                                                });
                                              }
                                              String? phone = user!.user!.phoneNumber;
                                              await socialMediaLogin(
                                                email: user.additionalUserInfo!.profile!["email"],
                                                uid: user.user!.uid,
                                                type: user.credential!.signInMethod,
                                                firstName: user.additionalUserInfo!.profile!["given_name"],
                                                lastName: user.additionalUserInfo!.profile!["family_name"],
                                                userName: "",
                                                phoneCode: "",
                                                phoneNumber: phone,
                                                referralCode: "",
                                                socialAvatar: "",
                                              );
                                            },
                                            icon: SvgPicture.asset(
                                              "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                              height: height / 18.45,
                                              width: width / 8.52,
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              /*  setState(() {
                                                socialLoading = true;
                                              });*/
                                              UserCredential? user = await authFunctionsMain.signInApples();
                                              if (user == null) {
                                                /* setState(() {
                                                  socialLoading = false;
                                                });*/
                                              }
                                              String? phone = user!.user!.phoneNumber ?? user.user!.providerData[0].phoneNumber;
                                              String? name1 = user.user!.displayName ?? user.user!.providerData[0].displayName;
                                              String? email1 = user.user!.providerData[0].email != null
                                                  ? (user.user!.providerData[0].email!.contains(".appleid.")
                                                      ? null
                                                      : user.user!.providerData[0].email)
                                                  : user.user!.email != null
                                                      ? (user.user!.email!.contains(".appleid.") ? null : user.user!.email)
                                                      : null;
                                              String? firstName1 = "";
                                              String? lastName1 = "";
                                              List parts = [];
                                              if (name1 == null || name1 == "") {
                                                if (email1 == null) {
                                                  parts.add("");
                                                  parts.add("");
                                                  firstName1 = "";
                                                  lastName1 = "";
                                                } else {
                                                  parts = email1.split("@");
                                                  parts[0].trim();
                                                  firstName1 = parts[0].trim();
                                                  lastName1 = "";
                                                }
                                              } else {
                                                parts = name1.split(" ");
                                                if (parts.isNotEmpty) {
                                                  parts[0].trim();
                                                  parts[1].trim();
                                                  firstName1 = parts[0].trim();
                                                  lastName1 = parts[1].trim();
                                                } else {
                                                  parts[0].trim();
                                                  firstName1 = parts[0].trim();
                                                  lastName1 = "";
                                                }
                                              }
                                              await socialMediaLogin(
                                                email: email1,
                                                uid: user.user!.uid,
                                                type: user.credential!.signInMethod,
                                                firstName: firstName1.toString().capitalizeFirst ?? "",
                                                lastName: lastName1.toString().capitalizeFirst ?? "",
                                                userName: "",
                                                phoneCode: "",
                                                phoneNumber: phone,
                                                referralCode: "",
                                                socialAvatar: "",
                                              );
                                            },
                                            icon: SvgPicture.asset(
                                              "lib/Constants/Assets/SMLogos/Logos/appleNew.svg",
                                              height: height / 18.45,
                                              width: width / 8.52,
                                            ),
                                          ),
                                          /*IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              setState(() {
                                                socialLoading = true;
                                              });
                                              UserCredential? user = await authFunctionsMain.signInWithFacebook();
                                              if (user == null) {
                                                setState(() {
                                                  socialLoading = false;
                                                });
                                              }
                                              String? phone = user!.user!.phoneNumber;
                                              await socialMediaLogin(
                                                email: user.additionalUserInfo!.profile!["email"],
                                                uid: user.user!.uid,
                                                type: user.credential!.signInMethod,
                                                firstName: user.additionalUserInfo!.profile!["first_name"],
                                                lastName: user.additionalUserInfo!.profile!["last_name"],
                                                userName: "",
                                                phoneCode: "",
                                                phoneNumber: phone,
                                                referralCode: "",
                                                socialAvatar: "",
                                              );
                                            },
                                            icon: SvgPicture.asset(
                                              "lib/Constants/Assets/SMLogos/Logos/facebookNew.svg",
                                              height: height / 18.45,
                                              width: width / 8.52,
                                            ),
                                          ),*/
                                          /*IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              setState(() {
                                                socialLoading = true;
                                              });

                                              UserCredential? user = await authFunctionsMain.signInWithTwitter();
                                              if (user == null) {
                                                userMain = user;
                                                setState(() {
                                                  socialLoading = false;
                                                });
                                              }
                                              else {
                                                userMain = user;
                                              }
                                              String? phone = userMain!
                                                  .user!
                                                  .providerData[0]
                                                  .phoneNumber;
                                              String? name1 = userMain!
                                                  .user!
                                                  .providerData[0]
                                                  .displayName;
                                              List parts = [];
                                              if (name1 == null ||
                                                  name1 == "") {
                                                parts.add("");
                                                parts.add("");
                                              } else {
                                                parts = name1.split(" ");
                                                if (parts.length > 0) {
                                                  parts[0].trim();
                                                  parts[1].trim();
                                                } else {
                                                  parts[0].trim();
                                                }
                                              }
                                              await socialMediaLogin(
                                                email: userMain!.user!.providerData[0].email,
                                                uid: userMain!.user!.uid,
                                                type: userMain!.credential!.signInMethod,
                                                firstName: parts[0].trim(),
                                                lastName: parts.length > 0 ? parts[1].trim() : "",
                                                userName: "",
                                                phoneCode: "",
                                                phoneNumber: phone,
                                                referralCode: "",
                                                socialAvatar: "",
                                              );
                                            },
                                            icon: SvgPicture.asset(
                                              "lib/Constants/Assets/SMLogos/Logos/twitterNew.svg",
                                              height: _height / 18.45,
                                              width: _width / 8.52,
                                            ),
                                          ),*/
                                        ],
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: SizedBox(
                                      width: width / 2.4,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async {
                                          setState(() {
                                            socialLoading = true;
                                          });
                                          UserCredential? user = await authFunctionsMain.signInWithGoogle();
                                          if (user == null) {
                                            setState(() {
                                              socialLoading = false;
                                            });
                                          }
                                          String? phone = user!.user!.phoneNumber;
                                          await socialMediaLogin(
                                            email: user.additionalUserInfo!.profile!['email'],
                                            uid: user.user!.uid,
                                            type: user.credential!.signInMethod,
                                            firstName: user.additionalUserInfo!.profile!["given_name"],
                                            lastName: user.additionalUserInfo!.profile!["family_name"],
                                            userName: "",
                                            phoneCode: "",
                                            phoneNumber: phone,
                                            referralCode: "",
                                            socialAvatar: "",
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                          height: height / 18.45,
                                          width: width / 8.52,
                                        ),
                                      ),
                                      /*Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              setState(() {
                                                socialLoading = true;
                                              });
                                              UserCredential? user = await authFunctionsMain.signInWithGoogle();
                                              if (user == null) {
                                                setState(() {
                                                  socialLoading = false;
                                                });
                                              }
                                              String? phone = user!.user!.phoneNumber;
                                              await socialMediaLogin(
                                                email: user.additionalUserInfo!.profile!['email'],
                                                uid: user.user!.uid,
                                                type: user.credential!.signInMethod,
                                                firstName: user.additionalUserInfo!.profile!["given_name"],
                                                lastName: user.additionalUserInfo!.profile!["family_name"],
                                                userName: "",
                                                phoneCode: "",
                                                phoneNumber: phone,
                                                referralCode: "",
                                                socialAvatar: "",
                                              );
                                            },
                                            icon: SvgPicture.asset(
                                              "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                              height: height / 18.45,
                                              width: width / 8.52,
                                            ),
                                          ),
                                          */
                                      /*IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              setState(() {
                                                socialLoading = true;
                                              });
                                              UserCredential? user = await authFunctionsMain.signInWithFacebook();
                                              if (user == null) {
                                                setState(() {
                                                  socialLoading = false;
                                                });
                                              }
                                              String? phone = user!.user!.phoneNumber;
                                              await socialMediaLogin(
                                                email: user.additionalUserInfo!.profile!["email"],
                                                uid: user.user!.uid,
                                                type: user.credential!.signInMethod,
                                                firstName: user.additionalUserInfo!.profile!["first_name"],
                                                lastName: user.additionalUserInfo!.profile!["last_name"],
                                                userName: "",
                                                phoneCode: "",
                                                phoneNumber: phone,
                                                referralCode: "",
                                                socialAvatar: "",
                                              );
                                            },
                                            icon: SvgPicture.asset(
                                              "lib/Constants/Assets/SMLogos/Logos/facebookNew.svg",
                                              height: height / 18.45,
                                              width: width / 8.52,
                                            ),
                                          ),*/
                                      /*
                                          */
                                      /*IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async {
                                              setState(() {
                                                socialLoading = true;
                                              });
                                              UserCredential? user = await authFunctionsMain.signInWithTwitter();
                                              if (user == null) {
                                                userMain = user;
                                                setState(() {
                                                  socialLoading = false;
                                                });
                                              }
                                              else {
                                                userMain = user;
                                              }
                                              String? phone = userMain!.user!.providerData[0].phoneNumber;
                                              String? name1 = userMain!.user!.providerData[0].displayName;
                                              List parts = [];
                                              if (name1 == null || name1 == "") {
                                                parts.add("");
                                                parts.add("");
                                              } else {
                                                parts = name1.split(" ");
                                                if (parts.length > 1) {
                                                  parts[0].trim();
                                                  parts[1].trim();
                                                } else {
                                                  parts[0].trim();
                                                }
                                              }
                                              await socialMediaLogin(
                                                email: userMain!.user!.providerData[0].email,
                                                uid: userMain!.user!.uid,
                                                type: userMain!.credential!.signInMethod,
                                                firstName: parts[0],
                                                lastName: parts.length > 1 ? parts[1].trim() : "",
                                                userName: "",
                                                phoneCode: "",
                                                phoneNumber: phone,
                                                referralCode: "",
                                                socialAvatar: "",
                                              );
                                            },
                                            icon: SvgPicture.asset(
                                              "lib/Constants/Assets/SMLogos/Logos/twitterNew.svg",
                                              height: _height / 18.45,
                                              width: _width / 8.52,
                                            ),
                                          ),*/
                                      /*
                                        ],
                                      ),*/
                                    ),
                                  ),
                            const SizedBox(
                              height: 23.88,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(16), fontFamily: "Poppins"),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                        return SignUpPage(
                                          firstName: "",
                                          lastName: "",
                                          userName: "",
                                          email: "",
                                          socialId: "",
                                          type: "",
                                          phoneCode: "",
                                          phoneNumber: "",
                                          devType: Platform.isIOS ? "ios" : "android",
                                          referralCode: "",
                                          socialAvatar: "",
                                          noPass: false,
                                          navBool: widget.navBool,
                                          category: widget.category,
                                          id: widget.id,
                                          toWhere: widget.toWhere,
                                          activity: widget.activity,
                                          fromWhere: widget.fromWhere,
                                        );
                                      }));
                                    },
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          fontSize: text.scale(16),
                                          color: const Color(0XFF0EA102),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Poppins"),
                                    ))
                              ],
                            ),
                            /* Center(
                              child: TextButton(
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    bool privacyAccept=prefs.getBool('privacyAccept')?? false;
                                    logEventFunc(name: 'Skip', type: 'General');
                                    setState(() {
                                      mainSkipValue = true;
                                    });
                                    privacyAccept?Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (BuildContext context)=>
                                            BottomNavigationPage(caseNo: 0,))): Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return PrivacyPage(fromWhere: false,);
                                        }));
                                  },
                                  child: Text("skip",
                                      style: TextStyle(
                                          color: Colors.black,
                                          decoration:
                                          TextDecoration.underline))),
                            ),*/
                            SizedBox(
                              height: height / 16.25,
                            ),
                            SizedBox(
                              height: height / 27.06,
                            ),
                            SizedBox(
                              height: height / 8.45,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "By continuing, I confirm that I have read, consent & agree to Trade watch",
                                      style: TextStyle(
                                          fontSize: text.scale(13),
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Poppins")),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        userInsightFunc(aliasData: 'sign_in', typeData: 'terms_conditions');
                                        /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return const DemoPage(
                                            url: "https://www.termsfeed.com/live/35fc0618-a094-4f73-b7bf-75c612077247",
                                            text: "Terms & Conditions",
                                            image: "",
                                            type: '',
                                            id: '',
                                            activity: false,
                                          );
                                        }));*/
                                        Get.to(const DemoView(), arguments: {
                                          "id": "",
                                          "type": "",
                                          "url": "https://www.termsfeed.com/live/35fc0618-a094-4f73-b7bf-75c612077247"
                                        });
                                      },
                                    text: " Terms & Conditions, ",
                                    style: TextStyle(
                                        fontSize: text.scale(13), color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        userInsightFunc(aliasData: 'sign_in', typeData: 'privacy_policy');
                                        /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return const DemoPage(
                                            url: "https://www.tradewatch.in/company/privacy-policy",
                                            text: "Privacy Policy",
                                            image: "",
                                            type: '',
                                            id: '',
                                            activity: false,
                                          );
                                        }));*/
                                        Get.to(const DemoView(),
                                            arguments: {"id": "", "type": "", "url": "https://www.tradewatch.in/company/privacy-policy"});
                                      },
                                    text: "Privacy Policy, ",
                                    style: TextStyle(
                                        fontSize: text.scale(13), color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        userInsightFunc(aliasData: 'sign_in', typeData: 'disclaimer');
                                        /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return const DemoPage(
                                            url: "https://www.termsfeed.com/live/99594250-2a59-4bcb-aca0-990c558438c2",
                                            text: "Cookie Policy",
                                            image: "",
                                            id: '',
                                            type: '',
                                            activity: false,
                                          );
                                        }));*/
                                        Get.to(const DemoView(), arguments: {
                                          "id": "",
                                          "type": "",
                                          "url": "https://www.termsfeed.com/live/99594250-2a59-4bcb-aca0-990c558438c2"
                                        });
                                      },
                                    text: "Cookie policy ",
                                    style: TextStyle(
                                        fontSize: text.scale(13), color: const Color(0XFF0EA102), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                                  ),
                                  TextSpan(
                                    text: "and I am of legal age.",
                                    style: TextStyle(
                                        fontSize: text.scale(13),
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins"),
                                  ),
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
