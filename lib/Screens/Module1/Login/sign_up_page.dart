import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Edited_Packages/PhoneField/intlPhone.dart';
import 'package:tradewatchfinal/Edited_Packages/Polygon/polygon.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/EditProfilePage/edit_profile_page.dart';
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

String checkPhoneNumberMain = "";

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.socialId,
    required this.type,
    required this.phoneCode,
    required this.phoneNumber,
    required this.devType,
    required this.referralCode,
    required this.socialAvatar,
    required this.noPass,
    this.navBool = "",
    this.category = "",
    this.id = "",
    this.toWhere = "",
    this.fromWhere = "",
    this.activity,
  });

  final String firstName, lastName, userName, socialId, type, phoneCode, devType, referralCode, socialAvatar;
  final String? email;
  final String? phoneNumber;
  final bool noPass;
  final String? navBool;
  final String? category;
  final String? id;
  final String? toWhere;
  final bool? activity;
  final String? fromWhere;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fnController = TextEditingController();
  final TextEditingController _lnController = TextEditingController();
  final TextEditingController _customisedAboutController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController(text: mainVariables.aboutMeListMain[2]);

  bool socialLoading = false;
  bool doNotShowPassword = false;
  bool checkMail = false;
  bool value = false;
  bool value1 = false;
  String dialCode = "";
  String countryCode = "";
  bool loading = false;
  int phoneLength = 10;
  late int newOTP;
  String twitterToken = "";
  bool google = true;
  bool faceBook = true;
  bool twitter = true;
  bool apple = true;
  bool finalNoPass = false;
  String firstName1 = "", lastName1 = "", userName1 = "", fbToken = "";
  String regId = "";
  String regToken = "";
  String regLocker = "";
  bool regComplete = false;
  String regStatus = "";
  UserCredential? userMain;
  bool emailEmpty = false;
  bool emailValidEmpty = false;
  bool emailValidExists = false;
  bool passwordEmpty = false;
  bool passwordValidEmpty = false;
  bool firstNameEmpty = false;
  bool lastNameEmpty = false;
  bool phoneNumberEmpty = false;
  bool phoneNumberValidEmpty = false;
  bool otpTimeOut = false;
  String socialId1 = "";
  String type1 = "";
  String newId = "";
  String completeNumber = "";
  String verifyId = "";

  File? image;
  File? coverImage;
  String avatar = "https://live.tradewatch.in/uploads/avatars/dood.png";
  List<bool> boolList = List.generate(10, (index) => false);
  int avatarSelectedIndex = 0;
  bool customisedAbout = false;

  Future<bool> checkEmailFunc(value) async {
    bool newValue = false;
    var url = Uri.parse(baseurl + versions + checkEmail);
    var responseNew = await http.post(url, body: {"email": value}, headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    var responseDataNew = json.decode(responseNew.body);
    setState(() {
      newValue = responseDataNew["status"];
    });
    if (!newValue) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "Email already Registered",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    }
    return responseDataNew["status"];
  }

  userInsightFunc({required String typeData, required String aliasData}) async {
    var url = Uri.parse(baseurl + versions + userInsightUpdate);
    await http.post(
      url,
      body: {"alias": aliasData, "type": typeData},
    );
  }

  noPassFunc() async {
    //   await functionsMain.fireBaseCloudMessagingListeners();
    if (widget.noPass) {
      if (widget.type == "google.com") {
        setState(() {
          google = true;
          faceBook = false;
          twitter = false;
          apple = false;
          finalNoPass = true;
        });
      } else if (widget.type == "apple.com") {
        setState(() {
          google = false;
          apple = true;
          faceBook = false;
          twitter = false;
          finalNoPass = true;
        });
      } else if (widget.type == "facebook.com") {
        setState(() {
          google = false;
          apple = false;
          faceBook = true;
          twitter = false;
          finalNoPass = true;
        });
      } else if (widget.type == "twitter.com") {
        setState(() {
          google = false;
          apple = false;
          faceBook = false;
          twitter = true;
          finalNoPass = true;
        });
      }
    }
    if (widget.email == null) {
      Flushbar(
        message: "Apple ID authenticated successfully, since you hide your data, we can’t complete registration,Please register here",
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getAllDataMain(name: 'Sign_Up_Screen');
    doNotShowPassword = true;
    widget.email == null || widget.email!.isEmpty ? _emailController.text = "" : _emailController.text = widget.email!;
    widget.firstName.isEmpty ? _fnController.text = "" : _fnController.text = widget.firstName;
    widget.lastName.isEmpty ? _lnController.text = "" : _lnController.text = widget.lastName;
    widget.phoneNumber!.isEmpty ? _phoneController.text = "" : _phoneController.text = widget.phoneNumber!;
    socialId1 = widget.socialId.isEmpty ? "" : widget.socialId;
    type1 = widget.type.isEmpty ? "" : widget.type;
    noPassFunc();
    super.initState();
  }

  signUp1(
      {required String email1,
      required String firstName,
      required String lastName,
      required String dialCode,
      required String phone,
      required String countryCode,
      required String referCode}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fbToken = prefs.getString('FBToken1')!;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email1);
    if (email1 == "") {
      emailEmpty = true;
    } else {
      emailEmpty = false;
      if (emailValid) {
        emailValidEmpty = false;
        bool newCheckMail = await checkEmailFunc(email1);
        if (!newCheckMail) {
          emailValidExists = true;
        } else {
          emailValidExists = false;
        }
      } else {
        emailValidEmpty = true;
      }
    }
    if (firstName == "") {
      firstNameEmpty = true;
    } else {
      firstNameEmpty = false;
    }
    if (lastName == "") {
      lastNameEmpty = true;
    } else {
      lastNameEmpty = false;
    }
    if (phone == "") {
      phoneNumberEmpty = true;
    } else {
      phoneNumberEmpty = false;
      if (phone.length != phoneLength) {
        phoneNumberValidEmpty = true;
      } else {
        phoneNumberValidEmpty = false;
      }
    }
    if (value != true || value1 != true) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "Please check the terms & condition checkboxes",
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    if (emailEmpty == false &&
        emailValidEmpty == false &&
        emailValidExists == false &&
        firstNameEmpty == false &&
        lastNameEmpty == false &&
        phoneNumberEmpty == false &&
        phoneNumberValidEmpty == false &&
        value == true &&
        value1 == true) {
      checkPhoneNumberMain = completeNumber;
      var url = Uri.parse(baseurl + versions + checkPhone);
      var responseNew = await http.post(url,
          body: {"phone_code": dialCode.isEmpty ? "+91" : dialCode, "phone_number": phone},
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew['status']) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: completeNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {},
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              loading = false;
            });
            if (e.code == "too-many-requests") {
              Flushbar(
                message: "OTP has sent too many times to this number, Please try again after",
                duration: const Duration(seconds: 2),
              ).show(context);
            }
            if (e.code == 'invalid-phone-number') {}
          },
          codeSent: (String verificationId, int? resendToken) async {
            verifyId = verificationId;
            setState(() {
              loading = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return CodeVerifyPage(
                //receivedOTP: newOTP.toString(),
                email: email1,
                passWord: "",
                dialCode: dialCode.isEmpty ? "+91" : dialCode,
                phone: phone,
                referCode: referCode.isEmpty ? "" : referCode,
                firstName: firstName,
                lastName: lastName,
                userName: userName1,
                socialId: socialId1,
                socialAvatar: widget.socialAvatar,
                type: type1,
                devToken: fbToken,
                devType: widget.devType,
                noPass: true,
                countryCode: '',
                verifyId: verifyId,
                completePhone: completeNumber,
                navBool: widget.navBool,
                category: widget.category,
                id: widget.id,
                toWhere: widget.toWhere,
                activity: widget.activity,
                avatar: avatar,
                aboutMe: _aboutMeController.text,
                image: image,
                coverImage: coverImage,
              );
            }));
          },
          timeout: const Duration(seconds: 25),
          codeAutoRetrievalTimeout: (String verificationId) {
            if (kDebugMode) {}
            setState(() {
              otpTimeOut = false;
            });
          },
        );
      } else {
        if (!mounted) {
          return false;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  signUp(
      {required String email1,
      required String firstName,
      required String lastName,
      required String password,
      required String dialCode,
      required String phone,
      required String countryCode,
      required String referCode}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fbToken = prefs.getString('FBToken1')!;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email1);
    bool passWordValid = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$").hasMatch(password);
    if (email1 == "") {
      emailEmpty = true;
    } else {
      emailEmpty = false;
      if (emailValid) {
        emailValidEmpty = false;
        bool newCheckMail = await checkEmailFunc(email1);
        if (!newCheckMail) {
          emailValidExists = true;
        } else {
          emailValidExists = false;
        }
      } else {
        emailValidEmpty = true;
      }
    }
    if (firstName == "") {
      firstNameEmpty = true;
    } else {
      firstNameEmpty = false;
    }
    if (lastName == "") {
      lastNameEmpty = true;
    } else {
      lastNameEmpty = false;
    }
    if (phone == "") {
      phoneNumberEmpty = true;
    } else {
      phoneNumberEmpty = false;
      if (phone.length != phoneLength) {
        phoneNumberValidEmpty = true;
      } else {
        phoneNumberValidEmpty = false;
      }
    }
    if (value != true || value1 != true) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "Please check the terms & condition checkboxes",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    }
    if (password == "") {
      passwordEmpty = true;
    } else {
      passwordEmpty = false;
      if (passWordValid) {
        passwordValidEmpty = false;
      } else {
        passwordValidEmpty = true;
      }
    }
    if (emailEmpty == false &&
        emailValidEmpty == false &&
        emailValidExists == false &&
        firstNameEmpty == false &&
        lastNameEmpty == false &&
        phoneNumberEmpty == false &&
        phoneNumberValidEmpty == false &&
        passwordEmpty == false &&
        passwordValidEmpty == false &&
        value == true &&
        value1 == true) {
      checkPhoneNumberMain = completeNumber;
      var url = Uri.parse(baseurl + versions + checkPhone);
      // var url = Uri.parse(baseurl + versions + verifyPhone);
      var responseNew = await http.post(url,
          body: {"phone_code": dialCode.isEmpty ? "+91" : dialCode, "phone_number": phone},
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew['status']) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: completeNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {},
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              loading = false;
            });
            if (e.code == "too-many-requests") {
              Flushbar(
                message: "OTP has sent too many times to this number, Please try again after",
                duration: const Duration(seconds: 2),
              ).show(context);
            }
            if (e.code == 'invalid-phone-number') {}
          },
          codeSent: (String verificationId, int? resendToken) async {
            verifyId = verificationId;
            setState(() {
              loading = false;
            });
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return CodeVerifyPage(
                //receivedOTP: newOTP.toString(),
                email: email1,
                passWord: password,
                dialCode: dialCode.isEmpty ? "+91" : dialCode,
                phone: phone,
                countryCode: countryCode.isEmpty ? "IN" : countryCode,
                referCode: referCode.isEmpty ? "" : referCode,
                firstName: firstName,
                lastName: lastName,
                userName: "",
                socialId: "",
                socialAvatar: "",
                type: widget.type,
                devToken: fbToken,
                devType: widget.devType,
                noPass: false,
                verifyId: verifyId,
                completePhone: completeNumber,
                navBool: widget.navBool,
                category: widget.category,
                id: widget.id,
                toWhere: widget.toWhere,
                activity: widget.activity,
                avatar: avatar,
                aboutMe: _aboutMeController.text,
                image: image,
                coverImage: coverImage,
              );
            }));
          },
          timeout: const Duration(seconds: 25),
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              otpTimeOut = false;
            });
          },
        );
      } else {
        if (!mounted) {
          return false;
        }
        Flushbar(
          message: responseDataNew["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        loading = false;
      });
    }
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
    fbToken = prefs.getString('FBToken1') ?? "";
    var url = Uri.parse(baseurl + versions + checkSocial);
    var response = await http
        .post(url, body: {"socialid": uid, "type": type, "Page": "sign_up"}, headers: {'Content-Type': 'application/x-www-form-urlencoded'});
    var responseData = json.decode(response.body);
    if (!responseData["status"]) {
      var url = Uri.parse(baseurl + versions + socialLogin);
      var response = await http.post(url, body: {
        "email": responseData["email"] == "" ? responseData["phone_number"] : responseData["email"],
        "socialid": uid,
        "device_token": fbToken,
        "device_type": Platform.isIOS ? "ios" : "android",
        "device_id": functionsMain.deviceId,
        "type": type
      }, headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      });
      var responseData1 = json.decode(response.body);
      if (responseData1["status"]) {
        logEventFunc(name: "Social_Media_Login", type: type);
        setState(() {
          socialLoading = false;
        });
        regId = responseData1["response"]["id"];
        setUserIDAnalyticsFunc(userId: regId, name: responseData1["response"]["username"], value: responseData1["response"]["email"]);
        regToken = responseData1["response"]["token"];
        regLocker = responseData1["response"]["locker"];
        String regAvatar = responseData1["response"]["avatar"];
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
        mainSkipValue = false;
        if (widget.fromWhere == "finalCharts") {
          Navigator.pop(context, true);
        } else if (widget.fromWhere == "settings") {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return const SettingsView();
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
            return const NotificationsPage();
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
        });
      }
      setState(() {
        loading = false;
        socialLoading = false;
      });
    } else {
      setState(() {
        _emailController.text = email ?? "";
        if (email == null) {
          Flushbar(
            message: "Apple ID authenticated successfully, since you hide your data, we can’t complete registration,Please register here",
            duration: const Duration(seconds: 3),
          ).show(context);
        }
        _fnController.text = firstName;
        _lnController.text = lastName;
        _phoneController.text = phoneNumber ?? "";
        socialId1 = uid;
        type1 = type;
        socialLoading = false;
        finalNoPass = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      //color: const Color(0XFFFFFFFF),
      color: Theme.of(context).colorScheme.background,
      child: WillPopScope(
        onWillPop: () async {
          authFunctionsMain.signOutUser();
          return true;
        },
        child: SafeArea(
            child: Scaffold(
          /* appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: _height / 16.24,
            leading: GestureDetector(
                onTap: () {
                  authFunctionsMain.signOutUser();
                  if (!mounted) {                                                    return;                                                              } Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
          ),*/
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
              : NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (scroll) {
                    scroll.disallowIndicator();
                    return true;
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: height / 4.68,
                        decoration: BoxDecoration(
                            image: coverImage != null
                                ? DecorationImage(image: FileImage(coverImage!), fit: BoxFit.fill)
                                : const DecorationImage(
                                    image: AssetImage("lib/Constants/Assets/Settings/coverImage_default.png"),
                                    //AssetImage('lib/Constants/Assets/Settings/coverImage.png'),
                                    fit: BoxFit.fill),
                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
                        foregroundDecoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height / 86.6),
                          SizedBox(
                            height: height / 28.86,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        authFunctionsMain.signOutUser();
                                        if (!mounted) {
                                          return;
                                        }
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: Color(0XFFC3C3C3),
                                      ),
                                    ),
                                    Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: text.scale(16),
                                        color: const Color(0XFFC3C3C3),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height / 11.54),
                          /*GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return FullScreenImage(
                                      imageUrl: avatar1,
                                      tag: "generate_a_unique_tag",
                                    );
                                  }));
                                },
                                child: Center(
                                  child: Container(
                                      width: _width / 3.20,
                                      height: _height / 6.24,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: image != null
                                          ? CircleAvatar(
                                              backgroundImage: FileImage(image!),
                                              radius: 100,
                                            )
                                          : avatar1 == ""
                                              ? CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      "lib/Constants/Assets/SMLogos/Settings/Profile.png"),
                                                  radius: 100,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage:
                                                      NetworkImage(avatar1),
                                                  radius: 100,
                                                )),
                                ),
                              ),*/
                          Center(
                            child: SizedBox(
                              height: height / 5.77,
                              width: width / 2.74,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DecoratedBox(
                                  decoration: ShapeDecoration(
                                      shape: PolygonBorder(
                                        borderAlign: BorderAlign.outside,
                                        polygon: RegularConvexPolygon(vertexCount: 5),
                                        radius: 15,
                                        turn: 0.15,
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 0,
                                        ),
                                      ),
                                      image: image != null
                                          ? DecorationImage(image: FileImage(image!), fit: BoxFit.fill)
                                          : avatar != ""
                                              ? DecorationImage(image: NetworkImage(avatar), fit: BoxFit.fill)
                                              : const DecorationImage(
                                                  image: AssetImage("lib/Constants/Assets/SMLogos/Settings/Profile.png"), fit: BoxFit.fill)),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                /*if (avatar1 == "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png" || avatar1 == "") {
                                      logEventFunc(
                                          name: 'Profile_Image_Added',
                                          type: 'Edit Profile');
                                    } else {
                                      logEventFunc(
                                          name: 'Profile_Image_Changed',
                                          type: 'Edit Profile');
                                    }
                                    final _image = await ImagePicker().pickImage(
                                      source: ImageSource.gallery,
                                      maxWidth: 1800,
                                      maxHeight: 1800,
                                    );
                                    */
                                showBottomSheet(context: context, forWhat: 'change');
                              },
                              child: Text(
                                'Change Photo',
                                style: TextStyle(
                                    color: const Color(0XFF0EA102), fontSize: text.scale(16), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 108.25,
                          ),
                          image != null || coverImage != null
                              ? Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      /*
                                          if (avatar1 == "https://tradewatch-s3.s3.ap-south-1.amazonaws.com/users/user.png"
                                              || avatar1 == "") {}
                                          else {
                                            logEventFunc(
                                                name: 'Profile_Image_Removed',
                                                type: 'Edit Profile');
                                            removeAvatar();
                                          }*/
                                      showBottomSheet(context: context, forWhat: 'remove');
                                    },
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.tertiary,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Poppins",
                                          fontSize: text.scale(12)),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          image != null || coverImage != null
                              ? SizedBox(
                                  height: height / 57.33,
                                )
                              : const SizedBox(),
                          Divider(
                            color: Theme.of(context).colorScheme.tertiary,
                            thickness: 0.8,
                          ),
                          /*LinearProgressIndicator(
                            value: linearValue,
                          ),
                          SizedBox(
                            height: _height/108.25,
                          ),
                          Center(
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text:usedData==totalData?
                                    "Your profile completed 100% successfully":"Complete your profile ",
                                    style: TextStyle(
                                        fontSize: _text*14,
                                        color: Color(0XFF1E1E1E),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins")),
                                usedData==totalData?TextSpan(
                                  text: "",
                                  style: TextStyle(
                                      fontSize: _text*14,
                                      color: Color(0XFF0EA102),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Poppins"),
                                ):
                                TextSpan(
                                  text: "${((linearValue * 100).round()).toString()}%",
                                  style: TextStyle(
                                      fontSize: _text*14,
                                      color: Color(0XFF0EA102),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Poppins"),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: usedData==totalData?_height/57.33:5,
                          ),
                          usedData==totalData?SizedBox():Center(
                            child: Text("Please complete your profile and add a balance of ${100-((linearValue * 100).round())}% to it",
                              style: TextStyle(
                                  fontSize: _text*12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0XFF535353)
                              ),
                            ),
                          ),
                          usedData==totalData?SizedBox():SizedBox(
                            height: _height/57.33,
                          ),*/
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                              child: ListView(
                                children: [
                                  /*Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        fontSize: _text.scale(10)28,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins"),
                                  ),
                                  Text(
                                      "Let's join millions of traders in the world",
                                      style: TextStyle(
                                          fontSize: _text.scale(10)18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Poppins")),*/
                                  Center(
                                    child: Text(
                                      "Sign up with",
                                      style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 28.48,
                                  ),
                                  Platform.isIOS
                                      ? Center(
                                          child: SizedBox(
                                            width: width / 1.61,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                AnimatedOpacity(
                                                  opacity: google ? 1.0 : 0.3,
                                                  duration: const Duration(milliseconds: 500),
                                                  child: google
                                                      ? widget.noPass
                                                          ? IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () {},
                                                              icon: SvgPicture.asset(
                                                                "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                                                height: height / 18.45,
                                                                width: width / 8.52,
                                                              ),
                                                            )
                                                          : IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () async {
                                                                setState(() {
                                                                  socialLoading = true;
                                                                  faceBook = false;
                                                                  apple = false;
                                                                  twitter = false;
                                                                  finalNoPass = true;
                                                                });
                                                                UserCredential? user = await authFunctionsMain.signInWithGoogle();
                                                                if (user == null) {
                                                                  setState(() {
                                                                    socialLoading = false;
                                                                    faceBook = true;
                                                                    twitter = true;
                                                                    apple = true;
                                                                    google = true;
                                                                    finalNoPass = false;
                                                                  });
                                                                } else {}
                                                                String? phone = user!.user!.phoneNumber;
                                                                socialMediaLogin(
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
                                                            )
                                                      : IconButton(
                                                          padding: EdgeInsets.zero,
                                                          onPressed: () async {},
                                                          icon: SvgPicture.asset(
                                                            "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                                            height: height / 18.45,
                                                            width: width / 8.52,
                                                          ),
                                                        ),
                                                ),
                                                AnimatedOpacity(
                                                  opacity: apple ? 1.0 : 0.3,
                                                  duration: const Duration(milliseconds: 500),
                                                  child: apple
                                                      ? widget.noPass
                                                          ? IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () async {},
                                                              icon: SvgPicture.asset(
                                                                "lib/Constants/Assets/SMLogos/Logos/appleNew.svg",
                                                                height: height / 18.45,
                                                                width: width / 8.52,
                                                              ),
                                                            )
                                                          : IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () async {
                                                                setState(() {
                                                                  /* socialLoading =
                                                                      true;*/
                                                                  faceBook = false;
                                                                  google = false;
                                                                  twitter = false;
                                                                  finalNoPass = true;
                                                                });
                                                                UserCredential? user = await authFunctionsMain.signInApples();
                                                                if (user == null) {
                                                                  setState(() {
                                                                    /* socialLoading =
                                                                        false;*/
                                                                    faceBook = true;
                                                                    twitter = true;
                                                                    apple = true;
                                                                    google = true;
                                                                    finalNoPass = false;
                                                                  });
                                                                } else {}
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
                                                            )
                                                      : IconButton(
                                                          padding: EdgeInsets.zero,
                                                          onPressed: () async {},
                                                          icon: SvgPicture.asset(
                                                            "lib/Constants/Assets/SMLogos/Logos/appleNew.svg",
                                                            height: height / 18.45,
                                                            width: width / 8.52,
                                                          ),
                                                        ),
                                                ),
                                                /*AnimatedOpacity(
                                                  opacity: faceBook ? 1.0 : 0.3,
                                                  duration: const Duration(milliseconds: 500),
                                                  child: faceBook
                                                      ? widget.noPass
                                                          ? IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () async {},
                                                              icon: SvgPicture.asset(
                                                                "lib/Constants/Assets/SMLogos/Logos/facebookNew.svg",
                                                                height: height / 18.45,
                                                                width: width / 8.52,
                                                              ),
                                                            )
                                                          : IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () async {
                                                                setState(() {
                                                                  socialLoading = true;
                                                                  google = false;
                                                                  apple = false;
                                                                  twitter = false;
                                                                  finalNoPass = true;
                                                                });
                                                                UserCredential? user = await authFunctionsMain.signInWithFacebook();
                                                                if (user == null) {
                                                                  setState(() {
                                                                    socialLoading = false;
                                                                    faceBook = true;
                                                                    twitter = true;
                                                                    apple = true;
                                                                    google = true;
                                                                    finalNoPass = false;
                                                                  });
                                                                } else {}
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
                                                            )
                                                      : IconButton(
                                                          padding: EdgeInsets.zero,
                                                          onPressed: () async {},
                                                          icon: SvgPicture.asset(
                                                            "lib/Constants/Assets/SMLogos/Logos/facebookNew.svg",
                                                            height: height / 18.45,
                                                            width: width / 8.52,
                                                          ),
                                                        ),
                                                ),*/
                                                /*AnimatedOpacity(
                                      opacity: twitter?1.0:0.3,
                                      duration: Duration(milliseconds: 500),
                                      child: twitter?
                                      widget.noPass?IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async {},
                                        icon: SvgPicture.asset(
                                          "lib/Constants/Assets/SMLogos/Logos/twitterNew.svg",
                                          height: _height / 18.45,
                                          width: _width / 8.52,
                                        ),
                                      ):
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async {
                                          setState(() {
                                            socialLoading=true;
                                            faceBook = false;
                                            google = false;
                                            apple = false;
                                            finalNoPass = true;
                                          });
                                          UserCredential? user =
                                          await authFunctionsMain.signInWithTwitter();
                                          if(user==null){

                                            userMain= user;
                                            setState(() {
                                              socialLoading=false;
                                              faceBook = true;
                                              twitter = true;
                                              apple = true;
                                              google=true;
                                              finalNoPass = false;
                                            });
                                          }else{
                                            userMain= user;

                                          }
                                          String? phone = userMain!.user!.providerData[0].phoneNumber;
                                          String? name1 = userMain!.user!.providerData[0].displayName;

                                          List parts=[];
                                          if(name1==null||name1==""){
                                            parts.add("");
                                            parts.add("");
                                          }else{
                                            parts=name1.split(" ");
                                            if(parts.length>0){

                                              parts[0].trim();
                                              parts[1].trim();

                                            }else{

                                              parts[0].trim();
                                            }
                                          }
                                          await socialMediaLogin(
                                            email: userMain!.user!.providerData[0].email,
                                            uid: userMain!.user!.uid,
                                            type: userMain!.credential!.signInMethod,
                                            firstName: parts[0].trim(),
                                            lastName: parts.length>0?parts[1].trim():"",
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
                                      ):
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async {},
                                        icon: SvgPicture.asset(
                                          "lib/Constants/Assets/SMLogos/Logos/twitterNew.svg",
                                          height: _height / 18.45,
                                          width: _width / 8.52,
                                        ),
                                      ),
                                    ),*/
                                              ],
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: SizedBox(
                                            width: width / 2.4,
                                            child: AnimatedOpacity(
                                              opacity: google ? 1.0 : 0.3,
                                              duration: const Duration(milliseconds: 500),
                                              child: google
                                                  ? widget.noPass
                                                  ? IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {},
                                                icon: SvgPicture.asset(
                                                  "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                                  height: height / 18.45,
                                                  width: width / 8.52,
                                                ),
                                              )
                                                  : IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async {
                                                  setState(() {
                                                    socialLoading = true;
                                                    faceBook = false;
                                                    apple = false;
                                                    twitter = false;
                                                    finalNoPass = true;
                                                  });
                                                  UserCredential? user = await authFunctionsMain.signInWithGoogle();
                                                  if (user == null) {
                                                    setState(() {
                                                      socialLoading = false;
                                                      faceBook = true;
                                                      twitter = true;
                                                      apple = true;
                                                      google = true;
                                                      finalNoPass = false;
                                                    });
                                                  } else {}
                                                  String? phone = user!.user!.phoneNumber;
                                                  socialMediaLogin(
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
                                              )
                                                  : IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async {},
                                                icon: SvgPicture.asset(
                                                  "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                                  height: height / 18.45,
                                                  width: width / 8.52,
                                                ),
                                              ),
                                            ),
                                            /*Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                AnimatedOpacity(
                                                  opacity: google ? 1.0 : 0.3,
                                                  duration: const Duration(milliseconds: 500),
                                                  child: google
                                                      ? widget.noPass
                                                          ? IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () {},
                                                              icon: SvgPicture.asset(
                                                                "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                                                height: height / 18.45,
                                                                width: width / 8.52,
                                                              ),
                                                            )
                                                          : IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () async {
                                                                setState(() {
                                                                  socialLoading = true;
                                                                  faceBook = false;
                                                                  apple = false;
                                                                  twitter = false;
                                                                  finalNoPass = true;
                                                                });
                                                                UserCredential? user = await authFunctionsMain.signInWithGoogle();
                                                                if (user == null) {
                                                                  setState(() {
                                                                    socialLoading = false;
                                                                    faceBook = true;
                                                                    twitter = true;
                                                                    apple = true;
                                                                    google = true;
                                                                    finalNoPass = false;
                                                                  });
                                                                } else {}
                                                                String? phone = user!.user!.phoneNumber;
                                                                socialMediaLogin(
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
                                                            )
                                                      : IconButton(
                                                          padding: EdgeInsets.zero,
                                                          onPressed: () async {},
                                                          icon: SvgPicture.asset(
                                                            "lib/Constants/Assets/SMLogos/Logos/googleNew.svg",
                                                            height: height / 18.45,
                                                            width: width / 8.52,
                                                          ),
                                                        ),
                                                ),
                                                */
                                            /*AnimatedOpacity(
                                                  opacity: faceBook ? 1.0 : 0.3,
                                                  duration: const Duration(milliseconds: 500),
                                                  child: faceBook
                                                      ? widget.noPass
                                                          ? IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () async {},
                                                              icon: SvgPicture.asset(
                                                                "lib/Constants/Assets/SMLogos/Logos/facebookNew.svg",
                                                                height: height / 18.45,
                                                                width: width / 8.52,
                                                              ),
                                                            )
                                                          : IconButton(
                                                              padding: EdgeInsets.zero,
                                                              onPressed: () async {
                                                                setState(() {
                                                                  socialLoading = true;
                                                                  google = false;
                                                                  apple = false;
                                                                  twitter = false;
                                                                  finalNoPass = true;
                                                                });
                                                                UserCredential? user = await authFunctionsMain.signInWithFacebook();
                                                                if (user == null) {
                                                                  setState(() {
                                                                    socialLoading = false;
                                                                    faceBook = true;
                                                                    twitter = true;
                                                                    apple = true;
                                                                    google = true;
                                                                    finalNoPass = false;
                                                                  });
                                                                } else {}
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
                                                            )
                                                      : IconButton(
                                                          padding: EdgeInsets.zero,
                                                          onPressed: () async {},
                                                          icon: SvgPicture.asset(
                                                            "lib/Constants/Assets/SMLogos/Logos/facebookNew.svg",
                                                            height: height / 18.45,
                                                            width: width / 8.52,
                                                          ),
                                                        ),
                                                ),*/
                                            /*
                                                */
                                            /* AnimatedOpacity(
                                      opacity: twitter?1.0:0.3,
                                      duration: Duration(milliseconds: 500),
                                      child: twitter?
                                      widget.noPass?IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async {},
                                        icon: SvgPicture.asset(
                                          "lib/Constants/Assets/SMLogos/Logos/twitterNew.svg",
                                          height: _height / 18.45,
                                          width: _width / 8.52,
                                        ),
                                      ):
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async {
                                          setState(() {
                                            socialLoading=true;
                                            faceBook = false;
                                            apple = false;
                                            google = false;
                                            finalNoPass = true;
                                          });
                                          UserCredential? user =
                                          await authFunctionsMain.signInWithTwitter();
                                          if(user==null){
                                            userMain= user;

                                            setState(() {
                                              socialLoading=false;
                                              faceBook = true;
                                              twitter = true;
                                              apple = true;
                                              google=true;
                                              finalNoPass = false;
                                            });
                                          }else{
                                            userMain= user;

                                          }
                                          String? phone = userMain!.user!.providerData[0].phoneNumber;
                                          String? name1 = userMain!.user!.providerData[0].displayName;

                                          List parts=[];
                                          if(name1==null||name1==""){
                                            parts.add("");
                                            parts.add("");
                                          }else{
                                            parts=name1.split(" ");
                                            if(parts.length>1){
                                              parts[0].trim();
                                              parts[1].trim();
                                            }else{
                                              parts[0].trim();
                                            }
                                          }
                                          await socialMediaLogin(
                                            email: userMain!.user!.providerData[0].email,
                                            uid: userMain!.user!.uid,
                                            type: userMain!.credential!.signInMethod,
                                            firstName: parts[0].trim(),
                                            lastName: parts.length>1?parts[1].trim():"",
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
                                      ):
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () async {},
                                        icon: SvgPicture.asset(
                                          "lib/Constants/Assets/SMLogos/Logos/twitterNew.svg",
                                          height: _height / 18.45,
                                          width: _width / 8.52,
                                        ),
                                      ),
                                    ),*/
                                            /*
                                              ],
                                            ),*/
                                          ),
                                        ),
                                  SizedBox(height: height / 18.88),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: TextFormField(
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
                                            color: const Color(0xFFA5A5A5),
                                            fontSize: text.scale(15),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins"),
                                        labelText: 'Email',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
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
                                      : emailValidEmpty
                                          ? const Padding(
                                              padding: EdgeInsets.only(left: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [Text("Enter valid email address", style: TextStyle(fontSize: 11, color: Colors.red))],
                                              ))
                                          : emailValidExists
                                              ? const Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [Text("Email already Registered", style: TextStyle(fontSize: 11, color: Colors.red))],
                                                  ))
                                              : const SizedBox(),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  finalNoPass
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 14.5,
                                          child: TextFormField(
                                            onTap: () async {
                                              checkEmailFunc(_emailController.text);
                                            },
                                            style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                            obscureText: doNotShowPassword,
                                            controller: _passwordController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.only(left: 15),
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              labelStyle: TextStyle(
                                                  color: const Color(0XFFA5A5A5),
                                                  fontSize: text.scale(15),
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Poppins"),
                                              labelText: 'Password',
                                              border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
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
                                                        color: Color(0XFFA5A5A5),
                                                        size: 25,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  finalNoPass
                                      ? const SizedBox()
                                      : passwordEmpty
                                          ? const Padding(
                                              padding: EdgeInsets.only(left: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [Text("Enter password", style: TextStyle(fontSize: 11, color: Colors.red))],
                                              ))
                                          : passwordValidEmpty
                                              ? const Padding(
                                                  padding: EdgeInsets.only(left: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [Text("Enter valid password", style: TextStyle(fontSize: 11, color: Colors.red))],
                                                  ))
                                              : const SizedBox(),
                                  finalNoPass
                                      ? const SizedBox()
                                      : const SizedBox(
                                          height: 8,
                                        ),
                                  finalNoPass
                                      ? const SizedBox()
                                      : Text(
                                          "Must be at least 8 Characters (should contain Caps, Small, Numbers, Symbol)",
                                          style: TextStyle(
                                              fontSize: text.scale(12),
                                              color: const Color(0XFF4A4A4A),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins"),
                                        ),
                                  finalNoPass
                                      ? const SizedBox()
                                      : SizedBox(
                                          height: height / 33.83,
                                        ),
                                  Text(
                                    'About me',
                                    style:
                                        TextStyle(fontFamily: "Poppins", fontSize: text.scale(13), fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  SizedBox(height: height / 108.25),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: TextFormField(
                                      onTap: () {
                                        showAboutBottomSheet(context: context);
                                      },
                                      style: TextStyle(
                                        fontSize: text.scale(15),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: _aboutMeController,
                                      readOnly: true,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 15),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        hintStyle: TextStyle(
                                            color: const Color(0XFFA5A5A5),
                                            fontSize: text.scale(16),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins"),
                                        hintText: 'about me',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.4),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'First name',
                                    style:
                                        TextStyle(fontFamily: "Poppins", fontSize: text.scale(13), fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: TextFormField(
                                      style: TextStyle(fontSize: text.scale(16), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                                      controller: _fnController,
                                      textCapitalization: TextCapitalization.words,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 15),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        hintStyle: TextStyle(
                                            color: const Color(0XFFA5A5A5),
                                            fontSize: text.scale(16),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins"),
                                        hintText: 'FirstName',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  firstNameEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [Text("Enter firstname", style: TextStyle(fontSize: 11, color: Colors.red))],
                                          ))
                                      : const SizedBox(),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Last name',
                                    style:
                                        TextStyle(fontSize: text.scale(13), fontFamily: "Poppins", fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: TextFormField(
                                      style: TextStyle(fontSize: text.scale(16), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                                      controller: _lnController,
                                      keyboardType: TextInputType.emailAddress,
                                      textCapitalization: TextCapitalization.words,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(left: 15),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        hintStyle: TextStyle(
                                            color: const Color(0XFFA5A5A5),
                                            fontSize: text.scale(16),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins"),
                                        hintText: 'LastName',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  lastNameEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [Text("Enter lastname", style: TextStyle(fontSize: 11, color: Colors.red))],
                                          ))
                                      : const SizedBox(),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Enter your mobile number, we'll send you an OTP to Verify",
                                    style: TextStyle(
                                        fontSize: text.scale(14), color: const Color(0XFF4A4A4A), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: IntlPhoneField(
                                      onTap: () {
                                        checkMail ? debugPrint("nothing") : checkEmailFunc(_emailController.text);
                                      },
                                      controller: _phoneController,
                                      showDropdownIcon: false,
                                      showCursor: true,
                                      initialCountryCode: "IN",
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      showCountryFlag: true,
                                      autovalidateMode: AutovalidateMode.disabled,
                                      dropdownTextStyle: TextStyle(
                                        fontSize: text.scale(15),
                                      ),
                                      flagsButtonPadding: const EdgeInsets.only(left: 8, right: 3),
                                      decoration: InputDecoration(
                                        counterText: "",
                                        labelText: 'Phone Number',
                                        labelStyle: TextStyle(fontSize: text.scale(15), color: const Color(0xFFA5A5A5), fontFamily: "Poppins"),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      onChanged: (phone) {
                                        completeNumber = phone.completeNumber;
                                      },
                                      onCountryChanged: (country) {
                                        setState(() {
                                          dialCode = "+${country.dialCode}";
                                          countryCode = country.code;
                                          phoneLength = country.maxLength;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  phoneNumberEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [Text("Enter phone Number", style: TextStyle(fontSize: 11, color: Colors.red))],
                                          ))
                                      : phoneNumberValidEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text("Enter valid number,phone Number Length should be $phoneLength",
                                                      style: const TextStyle(fontSize: 11, color: Colors.red))
                                                ],
                                              ))
                                          : const SizedBox(),
                                  SizedBox(
                                    height: height / 58,
                                  ),
                                  Text(
                                    "Optional",
                                    style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w500, fontFamily: "Poppins"),
                                  ),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: TextFormField(
                                      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                      controller: _referController,
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
                                        labelStyle: TextStyle(
                                            color: const Color(0XFFA5A5A5),
                                            fontSize: text.scale(15),
                                            fontWeight: FontWeight.normal,
                                            fontFamily: "Poppins"),
                                        labelText: 'Referral Code',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0xFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 23.88,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        activeColor: const Color(0XFF0EA102),
                                        value: value,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            this.value = value!;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: width / 1.4,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Center(
                                            child: RichText(
                                              textAlign: TextAlign.justify,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        "I understand Trade watch is not a financial advisor and I need to make my own research before investing.",
                                                    style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                        fontWeight: FontWeight.w400,
                                                        fontFamily: "Poppins")),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        activeColor: const Color(0XFF0EA102),
                                        value: value1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            value1 = value!;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        width: width / 1.4,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Center(
                                            child: RichText(
                                              textAlign: TextAlign.justify,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                    text: "I confirm that I have read, consent & agree to Trade watch ",
                                                    style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                        fontWeight: FontWeight.w400,
                                                        fontFamily: "Poppins")),
                                                TextSpan(
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      userInsightFunc(aliasData: 'sign_up', typeData: 'terms_conditions');
                                                      /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                        return const DemoPage(
                                                          url: "https://www.termsfeed.com/live/35fc0618-a094-4f73-b7bf-75c612077247",
                                                          text: "Terms & Conditions",
                                                          activity: false,
                                                          image: "lib/Constants/Assets/SMLogos/Logos/Logo_main.svg",
                                                          type: '',
                                                          id: '',
                                                        );
                                                      }));*/
                                                      Get.to(const DemoView(), arguments: {
                                                        "id": "",
                                                        "type": "",
                                                        "url": "https://www.termsfeed.com/live/35fc0618-a094-4f73-b7bf-75c612077247"
                                                      });
                                                    },
                                                  text: "Terms & Conditions, ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(14),
                                                      color: const Color(0XFF0EA102),
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: "Poppins"),
                                                ),
                                                TextSpan(
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      userInsightFunc(aliasData: 'sign_up', typeData: 'privacy_policy');
                                                      /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                        return const DemoPage(
                                                          url: "https://www.tradewatch.in/company/privacy-policy",
                                                          text: "Privacy Policy",
                                                          activity: false,
                                                          image: "lib/Constants/Assets/SMLogos/Logos/Logo_main.svg",
                                                          id: '',
                                                          type: '',
                                                        );
                                                      }));*/
                                                      Get.to(const DemoView(), arguments: {
                                                        "id": "",
                                                        "type": "",
                                                        "url": "https://www.tradewatch.in/company/privacy-policy"
                                                      });
                                                    },
                                                  text: "Privacy Policy ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(14),
                                                      color: const Color(0XFF0EA102),
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: "Poppins"),
                                                ),
                                                TextSpan(
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      userInsightFunc(aliasData: 'sign_up', typeData: 'disclaimer');
                                                      /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                        return const DemoPage(
                                                          url: "https://www.termsfeed.com/live/99594250-2a59-4bcb-aca0-990c558438c2",
                                                          text: "Cookie Policy",
                                                          activity: false,
                                                          image: "lib/Constants/Assets/SMLogos/Logos/Logo_main.svg",
                                                          id: '',
                                                          type: '',
                                                        );
                                                      }));*/
                                                      Get.to(const DemoView(), arguments: {
                                                        "id": "",
                                                        "type": "",
                                                        "url": "https://www.termsfeed.com/live/99594250-2a59-4bcb-aca0-990c558438c2"
                                                      });
                                                    },
                                                  text: "& Cookie policy ",
                                                  style: TextStyle(
                                                      fontSize: text.scale(14),
                                                      color: const Color(0XFF0EA102),
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: "Poppins"),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "and I am of legal age. I understand that I can change my communication preference any time in my trade watch account",
                                                  style: TextStyle(
                                                      fontSize: text.scale(14),
                                                      color: Theme.of(context).colorScheme.onPrimary,
                                                      fontWeight: FontWeight.w400,
                                                      fontFamily: "Poppins"),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: height / 33.83,
                                  ),
                                  loading
                                      ? Center(child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100))
                                      : otpTimeOut
                                          ? GestureDetector(
                                              onTap: () {
                                                if (checkPhoneNumberMain != completeNumber) {
                                                  setState(() {
                                                    loading = true;
                                                    otpTimeOut = true;
                                                  });
                                                  finalNoPass
                                                      ? signUp1(
                                                          email1: _emailController.text,
                                                          firstName: _fnController.text,
                                                          lastName: _lnController.text,
                                                          dialCode: dialCode,
                                                          phone: _phoneController.text,
                                                          countryCode: countryCode,
                                                          referCode: _referController.text,
                                                        )
                                                      : signUp(
                                                          email1: _emailController.text,
                                                          firstName: _fnController.text,
                                                          lastName: _lnController.text,
                                                          password: _passwordController.text,
                                                          dialCode: dialCode,
                                                          countryCode: countryCode,
                                                          phone: _phoneController.text,
                                                          referCode: _referController.text);
                                                } else {
                                                  Flushbar(
                                                    message: "Existing OTP not yet expired, please wait",
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                }
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  color: Color(0XFF0EA102),
                                                ),
                                                height: height / 14.5,
                                                child: const Center(
                                                  child: Text(
                                                    "Sign Up",
                                                    style: TextStyle(
                                                        color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16, fontFamily: "Poppins"),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  loading = true;
                                                  otpTimeOut = true;
                                                });
                                                finalNoPass
                                                    ? signUp1(
                                                        email1: _emailController.text,
                                                        firstName: _fnController.text,
                                                        lastName: _lnController.text,
                                                        dialCode: dialCode,
                                                        phone: _phoneController.text,
                                                        countryCode: countryCode,
                                                        referCode: _referController.text,
                                                      )
                                                    : signUp(
                                                        email1: _emailController.text,
                                                        firstName: _fnController.text,
                                                        lastName: _lnController.text,
                                                        password: _passwordController.text,
                                                        dialCode: dialCode,
                                                        countryCode: countryCode,
                                                        phone: _phoneController.text,
                                                        referCode: _referController.text);
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  color: Color(0XFF0EA102),
                                                ),
                                                height: height / 14.5,
                                                child: const Center(
                                                  child: Text(
                                                    "Sign Up",
                                                    style: TextStyle(
                                                        color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16, fontFamily: "Poppins"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                  SizedBox(
                                    height: height / 40.6,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        )),
      ),
    );
  }

  showBottomSheet({required BuildContext context, required String forWhat}) {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        if (forWhat == "change") {
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                          showChangeBottomSheet(context: context, type: "avatar");
                        } else {
                          if (image != null) {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              image = null;
                            });
                          }
                        }
                      },
                      minLeadingWidth: width / 25,
                      leading: Image.asset(
                        "lib/Constants/Assets/Settings/profileImageNew.png",
                        height: height / 43.3,
                        width: width / 20.55,
                      ),
                      title: Text(
                        "Profile Image",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: text.scale(14),
                            color: forWhat == "change"
                                ? Theme.of(context).colorScheme.onPrimary
                                : image == null
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        if (forWhat == "change") {
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                          showChangeBottomSheet(context: context, type: "cover");
                        } else {
                          if (coverImage != null) {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            setState(() {
                              coverImage = null;
                            });
                          }
                        }
                      },
                      minLeadingWidth: width / 25,
                      leading: Image.asset(
                        "lib/Constants/Assets/Settings/coverImageNew.png",
                        height: height / 43.3,
                        width: width / 20.55,
                      ),
                      title: Text(
                        "Cover Image",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: text.scale(14),
                            color: forWhat == "change"
                                ? Theme.of(context).colorScheme.onPrimary
                                : coverImage == null
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  showChangeBottomSheet({required BuildContext context, required String type}) {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        if (!mounted) {
                          return;
                        }
                        Navigator.pop(context);
                        cameraImage(type: type);
                      },
                      minLeadingWidth: width / 25,
                      leading: SvgPicture.asset(
                        "lib/Constants/Assets/Settings/camera.svg",
                        height: height / 43.3,
                        width: width / 20.55,
                      ),
                      title: Text(
                        "Camera",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        if (!mounted) {
                          return;
                        }
                        Navigator.pop(context);
                        galleryImage(type: type);
                      },
                      minLeadingWidth: width / 25,
                      leading: SvgPicture.asset(
                        "lib/Constants/Assets/Settings/gallery.svg",
                        height: height / 43.3,
                        width: width / 20.55,
                      ),
                      title: Text(
                        "Image",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                      ),
                    ),
                    type == "cover"
                        ? const SizedBox()
                        : ListTile(
                            onTap: () {
                              int index = mainVariables.avatarListMain.indexOf(avatar);
                              if (index >= 0) {
                                boolList[index] = true;
                                avatarSelectedIndex = index;
                              }
                              if (!mounted) {
                                return;
                              }
                              Navigator.pop(context);
                              avatarImage(type: type);
                            },
                            minLeadingWidth: width / 25,
                            leading: SvgPicture.asset(
                              "lib/Constants/Assets/Settings/avatar.svg",
                              height: height / 43.3,
                              width: width / 20.55,
                            ),
                            title: Text(
                              "Avatar",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                            ),
                          ),
                  ],
                )),
          );
        });
  }

  galleryImage({required String type}) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    cropImageFunc(currentImage: image!, type: type);
  }

  cameraImage({required String type}) async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    cropImageFunc(currentImage: image!, type: type);
  }

  avatarImage({required String type}) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modelSetState) {
            double width = MediaQuery.of(context).size.width;
            double height = MediaQuery.of(context).size.height;
            TextScaler text = MediaQuery.of(context).textScaler;
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              content: SizedBox(
                height: height / 2.88,
                width: width / 1.37,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height / 57.73,
                    ),
                    Center(
                      child: Text(
                        "Avatars",
                        style: TextStyle(fontSize: text.scale(20), fontWeight: FontWeight.w600, color: const Color(0XFF413C3C)),
                      ),
                    ),
                    SizedBox(
                      height: height / 57.73,
                    ),
                    Text(
                      "Male",
                      style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF8A8A8A)),
                    ),
                    SizedBox(
                      height: height / 57.73,
                    ),
                    SizedBox(
                        height: height / 21.12,
                        child: ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  modelSetState(() {
                                    if (boolList[index] == false) {
                                      boolList.clear();
                                      boolList = List.generate(10, (index) => false);
                                      boolList[index] = !boolList[index];
                                      avatar = mainVariables.avatarListMain[index];
                                      avatarSelectedIndex = index;
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(mainVariables.avatarListMain[index]),
                                    child: boolList[index]
                                        ? Center(
                                            child: Container(
                                              height: height / 21.65,
                                              width: width / 10.275,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black38,
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox()),
                              );
                            })),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Female",
                      style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF8A8A8A)),
                    ),
                    SizedBox(
                      height: height / 57.73,
                    ),
                    SizedBox(
                        height: height / 21.12,
                        child: ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  modelSetState(() {
                                    if (boolList[index + 5] == false) {
                                      boolList.clear();
                                      boolList = List.generate(10, (index) => false);
                                      boolList[index + 5] = !boolList[index + 5];
                                      avatar = mainVariables.avatarListMain[index + 5];
                                      avatarSelectedIndex = index + 5;
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(mainVariables.avatarListMain[index + 5]),
                                    child: boolList[index + 5]
                                        ? Center(
                                            child: Container(
                                              height: height / 21.65,
                                              width: width / 10.275,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black26,
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox()),
                              );
                            })),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0), side: const BorderSide(color: Colors.transparent)))),
                              onPressed: () {
                                image = null;
                                coverImage = null;
                                if (!mounted) {
                                  return;
                                }
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width / 20.55),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), color: const Color(0XFF3A3A3A)),
                                ),
                              )),
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0), side: const BorderSide(color: Colors.transparent)))),
                              onPressed: () {
                                image = null;
                                coverImage = null;
                                if (!mounted) {
                                  return;
                                }
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width / 16.44),
                                child: Text(
                                  "Done",
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: text.scale(14), color: const Color(0XFFFFFFFF)),
                                ),
                              ))
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  cropImageFunc({required XFile currentImage, required String type}) async {
    CroppedFile? croppedFile = await ImageCropper.platform.cropImage(sourcePath: currentImage.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
      AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: const Color(0XFF0EA102),
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: const Color(0XFF0EA102),
          initAspectRatio: CropAspectRatioPreset.original,
          hideBottomControls: false,
          lockAspectRatio: false),
    ]);
    if (croppedFile != null) {
      setState(() {
        if (type == "cover") {
          coverImage = File(croppedFile.path);
        } else {
          image = File(croppedFile.path);
        }
      });
    } else {}
  }

  showAboutBottomSheet({required BuildContext context}) {
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
              return SingleChildScrollView(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                    // padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    height: MediaQuery.of(context).viewInsets.bottom == 0.0 ? 300 : 500,
                    child: customisedAbout
                        ? Column(
                            children: [
                              ListTile(
                                title: Text(
                                  "Customize",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: text.scale(18),
                                    color: const Color(0XFF7F7F7F),
                                  ),
                                ),
                                /* trailing:GestureDetector(
                                onTap: (){
                                  modelSetState((){
                                    customisedAbout=false;
                                  });
                                },
                                child: Icon(Icons.clear,color:Colors.black,size: 25,))*/
                              ),
                              const Divider(color: Color(0XFFCBCBCB)),
                              Container(
                                margin: const EdgeInsets.all(15),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: text.scale(15),
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 4,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: _customisedAboutController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(15),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintStyle: TextStyle(
                                        color: const Color(0XFFA5A5A5), fontSize: text.scale(16), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                                    hintText: 'add your status here',
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.4),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        modelSetState(() {
                                          customisedAbout = false;
                                        });
                                      },
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                      )),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (_customisedAboutController.text.isEmpty) {
                                          modelSetState(() {
                                            customisedAbout = false;
                                          });
                                        } else {
                                          setState(() {
                                            _aboutMeController.text = _customisedAboutController.text;
                                          });
                                          modelSetState(() {
                                            customisedAbout = false;
                                          });
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text(
                                        "Done",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                      ))
                                ],
                              )
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                  title: Text(
                                    "About",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: text.scale(18),
                                      color: const Color(0XFF7F7F7F),
                                    ),
                                  ),
                                  trailing: GestureDetector(
                                      onTap: () {
                                        if (!mounted) {
                                          return;
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                        size: 25,
                                      ))),
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: mainVariables.aboutMeListMain.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              setState(() {
                                                _aboutMeController.text = mainVariables.aboutMeListMain[index];
                                              });
                                              modelSetState(() {});
                                            },
                                            title: Text(
                                              mainVariables.aboutMeListMain[index],
                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: const Color(0XFF232323)),
                                            ),
                                            trailing: mainVariables.aboutMeListMain[index] == _aboutMeController.text
                                                ? const Icon(
                                                    Icons.check_circle,
                                                    color: Color(0XFF0EA102),
                                                  )
                                                : const SizedBox(),
                                          ),
                                          const Divider(
                                            height: 1,
                                            thickness: 1,
                                            color: Color(0XFFCBCBCB),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              /*ListTile(
                          onTap: () {
                            setState(() {
                              _aboutMeController.text=variable.aboutMeListMain[0];
                            });
                            modelSetState((){});
                          },
                          title: Text(
                            "I am available",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: _text.scale(14),
                                color: Color(0XFF232323)),
                          ),
                          trailing: variable.aboutMeListMain[0]==_aboutMeController.text?
                          Icon(Icons.check_circle,color: Color(0XFF0EA102),)
                              :SizedBox(),
                        ),
                        Divider(height: 1,thickness: 1,color: Color(0XFFCBCBCB),),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _aboutMeController.text=variable.aboutMeListMain[1];
                            });
                            modelSetState((){});
                          },
                          title: Text(
                            "I am not a financial advisor",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: _text.scale(14),
                                color: Color(0XFF232323)),
                          ),
                          trailing: variable.aboutMeListMain[1]==_aboutMeController.text?
                          Icon(Icons.check_circle,color: Color(0XFF0EA102),)
                              :SizedBox(),
                        ),
                        Divider(height: 1,thickness: 1,color: Color(0XFFCBCBCB),),
                        ListTile(
                          onTap: () {
                            setState(() {
                              _aboutMeController.text=variable.aboutMeListMain[2];
                            });
                            modelSetState((){});
                          },
                          title: Text(
                            "Stay Connected",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: _text.scale(14),
                                color:Color(0XFF232323)),
                          ),
                          trailing: variable.aboutMeListMain[2]==_aboutMeController.text?
                          Icon(Icons.check_circle,color: Color(0XFF0EA102),)
                              :SizedBox(),
                        ),
                        Divider(height: 1,thickness: 1,color: Color(0XFFCBCBCB),),*/
                              ListTile(
                                onTap: () {
                                  modelSetState(() {
                                    customisedAbout = true;
                                  });
                                },
                                title: Text(
                                  "Customise",
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14), color: const Color(0XFF0EA102)),
                                ),
                                trailing: const Icon(Icons.add_circle, color: Color(0XFF0EA102), size: 25),
                              ),
                            ],
                          )),
              );
            },
          );
        });
  }
}
