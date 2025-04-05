import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/EditProfilePage/edit_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module1/my_activity_page.dart';
import 'package:tradewatchfinal/Screens/Module2/BlockList/block_list_page.dart';
import 'package:tradewatchfinal/Screens/Module2/FeatureRequest/feature_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_description_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Forum/forum_post_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/analytics_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_page.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_post_page.dart';
import 'package:tradewatchfinal/Screens/Module3/FilterPages/stocks_add_filter.dart';

class CodeVerifyPage extends StatefulWidget {
  const CodeVerifyPage(
      {Key? key,
      // required this.receivedOTP,
      required this.email,
      required this.passWord,
      required this.dialCode,
      required this.phone,
      required this.referCode,
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.socialId,
      required this.type,
      required this.devToken,
      required this.devType,
      required this.socialAvatar,
      required this.noPass,
      required this.countryCode,
      required this.verifyId,
      required this.completePhone,
      required this.avatar,
      required this.aboutMe,
      required this.image,
      required this.coverImage,
      this.navBool = "",
      this.category = "",
      this.id = "",
      this.toWhere = "",
      this.activity})
      : super(key: key);

  //final String receivedOTP;
  final String email;
  final String passWord;
  final String dialCode;
  final String phone;
  final String referCode;
  final String firstName;
  final String lastName;
  final String userName;
  final String socialId;
  final String type;
  final String devToken;
  final String devType;
  final String countryCode;
  final String socialAvatar;
  final String verifyId;
  final String completePhone;
  final String avatar;
  final String aboutMe;
  final File? image;
  final File? coverImage;
  final bool noPass;
  final String? navBool;
  final String? category;
  final String? id;
  final String? toWhere;
  final bool? activity;

  @override
  State<CodeVerifyPage> createState() => _CodeVerifyPageState();
}

class _CodeVerifyPageState extends State<CodeVerifyPage> {
  final TextEditingController _otpController = TextEditingController();
  bool loading = false;
  bool requestLoading = true;

  //String reqOTp = "";
  late int regeneratedOTP;
  String regId = "";
  String regToken = "";
  String regLocker = "";
  String verifyId = "";

  @override
  void initState() {
    getAllDataMain(name: 'OTP_Verification_Page');
    verifyId = widget.verifyId;
    Future.delayed(const Duration(seconds: 30), () {
      setState(() {
        requestLoading = false;
      });
    });
    // reqOTp = widget.receivedOTP;
    // functionsMain.fireBaseCloudMessagingListeners();
    super.initState();
  }

  verify1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool response = await phoneNumberVerify();
    if (_otpController.text.isEmpty) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "please enter OTP",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else if (response == false) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "OTP not matched,please Enter valid OTP",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (widget.image == null && widget.coverImage == null) {
        Map<String, dynamic> data1 = {};
        var url = baseurl + versions + socialRegister;
        data1 = {
          "email": widget.email,
          "password": widget.passWord,
          "phone_code": widget.dialCode,
          "phone_number": widget.phone,
          "referral_code": widget.referCode,
          "first_name": widget.firstName,
          "last_name": widget.lastName,
          "username": widget.userName,
          "socialid": widget.socialId,
          "type": widget.type,
          "device_token": widget.devToken,
          "device_type": widget.devType,
          "device_id": functionsMain.deviceId,
          "mobile_verified": true,
          "social_avatar": widget.socialAvatar,
          "about": widget.aboutMe,
          "default_avatar": widget.avatar
        };
        var response = await dioMain.post(url, data: data1, options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}));
        var responseData = response.data;
        if (responseData["status"]) {
          logEventFunc(name: 'Social_Media_Register', type: widget.type);
          setState(() {
            loading = false;
            regId = responseData["response"]["id"];
            setUserIDAnalyticsFunc(userId: regId, name: responseData["response"]["username"], value: responseData["response"]["email"]);
            regToken = responseData["response"]["token"];
            regLocker = responseData["response"]["locker"];
            String regAvatar = responseData["response"]["avatar"];
            mainSkipValue = false;
            // prefs.setBool("skipValue", mainSkipValue);
            kToken = regToken;
            prefs.setString('newUserId', regId);
            prefs.setString('newUserToken', regToken);
            prefs.setString('newUserLocker', regLocker);
            prefs.setString('newUserAvatar', regAvatar);
            conversationFunctionsMain.getSocketFunction(context: context);
            avatarMain.value = regAvatar;
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
                                      widget.toWhere == "ForumPostPage"
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
                                                          : const MainBottomNavigationPage(
                                                              caseNo1: 0,
                                                              text: "",
                                                              excIndex: 1,
                                                              newIndex: 0,
                                                              countryIndex: 0,
                                                              tType: true,
                                                              isHomeFirstTym: true,
                                                            );
            }));
          });
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
        setState(() {
          loading = false;
        });
      } else {
        Map<String, File> data = {};
        if (widget.image != null || widget.coverImage != null) {
          if (widget.image == null) {
            data = {'cover': widget.coverImage!};
          } else if (widget.coverImage == null) {
            data = {'file': widget.image!};
          } else {
            data = {'file': widget.image!, 'cover': widget.coverImage!};
          }
        }
        var res1 = await functionsMain.sendForm(
            baseurl + versions + socialRegister,
            {
              "email": widget.email,
              "password": widget.passWord,
              "phone_code": widget.dialCode,
              "phone_number": widget.phone,
              "referral_code": widget.referCode,
              "first_name": widget.firstName,
              "last_name": widget.lastName,
              "username": widget.userName,
              "socialid": widget.socialId,
              "type": widget.type,
              "device_token": widget.devToken,
              "device_type": widget.devType,
              "device_id": functionsMain.deviceId,
              "mobile_verified": true,
              "social_avatar": widget.socialAvatar,
              "about": widget.aboutMe,
              "default_avatar": widget.image != null ? "" : widget.avatar
            },
            data);
        if (res1.data["status"]) {
          logEventFunc(name: 'Social_Media_Register', type: widget.type);
          setState(() {
            loading = false;
            regId = res1.data["response"]["id"];
            setUserIDAnalyticsFunc(userId: regId, name: res1.data["response"]["username"], value: res1.data["response"]["email"]);
            regToken = res1.data["response"]["token"];
            regLocker = res1.data["response"]["locker"];
            String regAvatar = res1.data["response"]["avatar"];
            mainSkipValue = false;
            // prefs.setBool("skipValue", mainSkipValue);
            kToken = regToken;
            prefs.setString('newUserId', regId);
            prefs.setString('newUserToken', regToken);
            prefs.setString('newUserLocker', regLocker);
            prefs.setString('newUserAvatar', regAvatar);
            conversationFunctionsMain.getSocketFunction(context: context);
            avatarMain.value = regAvatar;
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
                                      widget.toWhere == "ForumPostPage"
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
                                                          : const MainBottomNavigationPage(
                                                              caseNo1: 0,
                                                              text: "",
                                                              excIndex: 1,
                                                              newIndex: 0,
                                                              countryIndex: 0,
                                                              tType: true,
                                                              isHomeFirstTym: true,
                                                            );
            }));
          });
        } else {
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: res1.data["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
          setState(() {
            loading = false;
          });
        }
      }
    }
  }

  verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool response = await phoneNumberVerify();
    if (_otpController.text.isEmpty) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "please enter OTP",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else if (response == false) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "OTP not matched,please Enter valid OTP",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (widget.image == null && widget.coverImage == null) {
        var url = baseurl + versions + register;
        var response = await dioMain.post(url,
            data: {
              "email": widget.email,
              "password": widget.passWord,
              "phone_code": widget.dialCode,
              "phone_number": widget.phone,
              "first_name": widget.firstName,
              "last_name": widget.lastName,
              "device_token": widget.devToken,
              "device_type": Platform.isIOS ? "ios" : "android",
              "device_id": functionsMain.deviceId,
              "referral_code": widget.referCode,
              "mobile_verified": true,
              'country_code': widget.countryCode,
              "about": widget.aboutMe,
              "default_avatar": widget.image == null ? "" : widget.avatar
            },
            options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}));
        var responseData = response.data;
        if (responseData["status"]) {
          logEventFunc(name: "Register", type: 'normal register');
          setState(() {
            loading = false;
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
            conversationFunctionsMain.getSocketFunction(context: context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
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
                              activity: true,
                              surveyId: widget.id!,
                            )
                          : const MainBottomNavigationPage(
                              tType: true,
                              countryIndex: 0,
                              excIndex: 1,
                              newIndex: 0,
                              text: '',
                              caseNo1: 0,
                              isHomeFirstTym: true,
                            );
            }));
          });
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
        setState(() {
          loading = false;
        });
      } else {
        Map<String, File> data = {};
        if (widget.image != null || widget.coverImage != null) {
          if (widget.image == null) {
            data = {'cover': widget.coverImage!};
          } else if (widget.coverImage == null) {
            data = {'file': widget.image!};
          } else {
            data = {'file': widget.image!, 'cover': widget.coverImage!};
          }
        }
        var res1 = await functionsMain.sendForm(
            baseurl + versions + register,
            {
              "email": widget.email,
              "password": widget.passWord,
              "phone_code": widget.dialCode,
              "phone_number": widget.phone,
              "first_name": widget.firstName,
              "last_name": widget.lastName,
              "device_token": widget.devToken,
              "device_type": Platform.isIOS ? "ios" : "android",
              "device_id": functionsMain.deviceId,
              "referral_code": widget.referCode,
              "mobile_verified": true,
              'country_code': widget.countryCode,
              "about": widget.aboutMe,
              "default_avatar": widget.image == null ? widget.avatar : ""
            },
            data);
        if (res1.data["status"]) {
          logEventFunc(name: "Register", type: 'normal register');
          setState(() {
            loading = false;
            regId = res1.data["response"]["id"];
            setUserIDAnalyticsFunc(userId: regId, name: res1.data["response"]["username"], value: res1.data["response"]["email"]);
            regToken = res1.data["response"]["token"];
            regLocker = res1.data["response"]["locker"];
            String regAvatar = res1.data["response"]["avatar"];
            mainSkipValue = false;
            //prefs.setBool("skipValue", mainSkipValue);
            kToken = regToken;
            prefs.setString('newUserId', regId);
            prefs.setString('newUserToken', regToken);
            prefs.setString('newUserLocker', regLocker);
            prefs.setString('newUserAvatar', regAvatar);
            conversationFunctionsMain.getSocketFunction(context: context);
            avatarMain.value = regAvatar;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
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
                              activity: true,
                              surveyId: widget.id!,
                            )
                          : const MainBottomNavigationPage(
                              tType: true,
                              countryIndex: 0,
                              excIndex: 1,
                              newIndex: 0,
                              text: '',
                              caseNo1: 0,
                              isHomeFirstTym: true,
                            );
            }));
          });
        } else {
          if (!mounted) {
            return false;
          }
          Flushbar(
            message: res1.data["message"],
            duration: const Duration(seconds: 2),
          ).show(context);
          setState(() {
            loading = false;
          });
        }
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<bool> phoneNumberVerify() async {
    try {
      await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: _otpController.text,
      ));
      return true;
    } catch (e) {
      if (kDebugMode) {}
      return false;
    }
  }

  phoneVerify() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.completePhone,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          requestLoading = false;
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
        Future.delayed(const Duration(seconds: 25), () {
          setState(() {
            requestLoading = false;
          });
        });
      },
      timeout: const Duration(seconds: 25),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return Container(
      // color: const Color(0XFFFFFFFF),
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: width / 18.75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height / 50.75),
                GestureDetector(
                    onTap: () {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
                const SizedBox(height: 4),
                Text(
                  "Verification Code",
                  style: TextStyle(fontSize: text.scale(28), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                ),
                SizedBox(height: height / 67.66),
                Text("Please enter verification code sent to your mobile",
                    style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w400, fontFamily: "Poppins")),
                SizedBox(height: height / 67.66),
                Text(
                  "Code is sent to ${"${widget.dialCode} ${widget.phone}"}",
                  style: TextStyle(fontSize: text.scale(16), color: const Color(0XFFA5A5A5), fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                ),
                SizedBox(height: height / 25.375),
                Center(
                  child: SizedBox(
                    height: height / 3.77,
                    width: width / 1.38,
                    child: SvgPicture.asset(
                      "lib/Constants/Assets/SMLogos/verificationPageImage.svg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: height / 19.8),
                SizedBox(
                  height: height / 12.49,
                  child: PinCodeTextField(
                    length: 6,
                    appContext: context,
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    onChanged: (code) {
                      _otpController.text;
                    },
                    pinTheme: PinTheme(
                        inactiveColor: const Color(0XFFA5A5A5),
                        activeColor: const Color(0XFFA5A5A5),
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10.0),
                        fieldHeight: height / 20.3,
                        fieldWidth: width / 9.375,
                        activeFillColor: Theme.of(context).colorScheme.background,
                        borderWidth: 1.5),
                  ),
                ),
                SizedBox(height: height / 32.48),
                loading
                    ? Center(
                        child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                      )
                    : GestureDetector(
                        onTap: () async {
                          widget.noPass ? verify1() : verify();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color(0XFF0EA102),
                          ),
                          height: height / 14.5,
                          child: Center(
                            child: Text(
                              "Verify and Create Account",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive Code?",
                      style: TextStyle(color: const Color(0XFFA5A5A5), fontWeight: FontWeight.w400, fontSize: text.scale(18), fontFamily: "Poppins"),
                    ),
                    requestLoading
                        ? TextButton(
                            onPressed: () {},
                            child: Text(
                              "Request",
                              style: TextStyle(
                                  fontSize: text.scale(18), color: const Color(0XFFA5A5A5), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                            ))
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                requestLoading = true;
                              });
                              phoneVerify();
                            },
                            child: Text(
                              "Request",
                              style: TextStyle(
                                  fontSize: text.scale(18), color: const Color(0XFF0EA102), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                            ))
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class InactiveCodeVerifyPage extends StatefulWidget {
  final String dialCode;
  final String phone;
  final String verifyId;
  final Map<String, dynamic> data;
  final bool loginType;
  final String socialMediaType;

  const InactiveCodeVerifyPage(
      {Key? key,
      required this.dialCode,
      required this.phone,
      required this.verifyId,
      required this.data,
      required this.loginType,
      required this.socialMediaType})
      : super(key: key);

  @override
  State<InactiveCodeVerifyPage> createState() => _InactiveCodeVerifyPageState();
}

class _InactiveCodeVerifyPageState extends State<InactiveCodeVerifyPage> {
  final TextEditingController _otpController = TextEditingController();
  bool loading = false;
  bool requestLoading = true;
  String verifyId = "";
  String regId = "";
  String regToken = "";
  String regLocker = "";

  @override
  void initState() {
    getAllDataMain(name: 'OTP_Verification_Page');
    verifyId = widget.verifyId;
    Future.delayed(const Duration(seconds: 30), () {
      setState(() {
        requestLoading = false;
      });
    });
    //functionsMain.fireBaseCloudMessagingListeners();
    super.initState();
  }

  Future<bool> phoneNumberVerify() async {
    try {
      await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: _otpController.text,
      ));
      return true;
    } catch (e) {
      if (kDebugMode) {}
      return false;
    }
  }

  phoneVerify() async {
    String completeNumber = widget.dialCode + widget.phone;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: completeNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          requestLoading = false;
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
        Future.delayed(const Duration(seconds: 25), () {
          setState(() {
            requestLoading = false;
          });
        });
      },
      timeout: const Duration(seconds: 25),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool response = await phoneNumberVerify();
    if (response == false) {
    } else {
      var url = Uri.parse(baseurl + versions + newLogin);
      Map<String, dynamic> data = {};
      data = widget.data;
      data["mobile_verified"] = "true";
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
        if (!mounted) {
          return false;
        }
        conversationFunctionsMain.getSocketFunction(context: context);
        avatarMain.value = regAvatar;
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return MainBottomNavigationPage(tType: true, text: regLocker, caseNo1: 0, newIndex: 0, excIndex: 1, countryIndex: 0, isHomeFirstTym: true);
        }));
      } else {
        if (responseData.containsKey("phone")) {
          //await sendOtpFunc(phone: responseData["phone"],data: data);
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

/*  sendOtpFunc({required Map<String,dynamic> phone, required Map<String,dynamic> data}) async{

    String completeNumber=phone['code'] + phone['number'];

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+919500920819",//completeNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          loading = false;
        });
        if(e.code == "too-many-requests"){
          Flushbar(
            message: "OTP has sent too many times to this number, Please try again after",
            duration: Duration(seconds: 2),
          )..show(context);
        }
        if (e.code == 'invalid-phone-number') {
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        String verifyId=verificationId;
        setState(() {
          loading = false;
        });
      },
      timeout: const Duration(seconds: 25),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }*/

  socialLoginVerify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool response = await phoneNumberVerify();
    if (response == false) {
    } else {
      var url = Uri.parse(baseurl + versions + socialLogin);
      Map<String, dynamic> data = {};
      data = widget.data;
      data["mobile_verified"] = "true";
      var response = await http.post(
        url,
        body: data,
      );
      var responseData1 = json.decode(response.body);
      if (responseData1["status"]) {
        logEventFunc(name: 'Social_Media_Login', type: widget.socialMediaType);
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
        avatarMain.value = regAvatar;
        if (!mounted) {
          return false;
        }
        conversationFunctionsMain.getSocketFunction(context: context);
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return MainBottomNavigationPage(tType: true, text: regLocker, caseNo1: 0, newIndex: 0, excIndex: 1, countryIndex: 0, isHomeFirstTym: true);
        }));
        setState(() {
          loading = false;
        });
      } else {
        if (responseData1.containsKey("phone")) {
          //  await sendOtpFunc(phone: responseData1["phone"],data: data);
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
      }
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
          Navigator.pop(context, true);
          return false;
        },
        child: SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width / 18.75),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height / 50.75),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    "Verification Code",
                    style: TextStyle(fontSize: text.scale(28), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                  ),
                  SizedBox(height: height / 67.66),
                  Text("Please enter verification code sent to your mobile",
                      style: TextStyle(fontSize: text.scale(18), fontWeight: FontWeight.w400, fontFamily: "Poppins")),
                  SizedBox(height: height / 67.66),
                  Text(
                    "Code is sent to ${"${widget.dialCode} ${widget.phone}"}",
                    style: TextStyle(fontSize: text.scale(16), color: const Color(0XFFA5A5A5), fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                  ),
                  SizedBox(height: height / 25.375),
                  Center(
                    child: SizedBox(
                      height: height / 3.77,
                      width: width / 1.38,
                      child: SvgPicture.asset(
                        "lib/Constants/Assets/SMLogos/verificationPageImage.svg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: height / 19.8),
                  SizedBox(
                    height: height / 12.49,
                    child: PinCodeTextField(
                      length: 6,
                      appContext: context,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                          inactiveColor: const Color(0XFFA5A5A5),
                          activeColor: const Color(0XFFA5A5A5),
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10.0),
                          fieldHeight: height / 20.3,
                          fieldWidth: width / 9.375,
                          activeFillColor: Theme.of(context).colorScheme.background,
                          borderWidth: 1.5),
                      onChanged: (String value) {},
                    ),
                  ),
                  SizedBox(height: height / 32.48),
                  loading
                      ? Center(
                          child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                        )
                      : GestureDetector(
                          onTap: () async {
                            widget.loginType ? socialLoginVerify() : login();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Color(0XFF0EA102),
                            ),
                            height: height / 14.5,
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: text.scale(16), fontFamily: "Poppins"),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive Code?",
                        style:
                            TextStyle(color: const Color(0XFFA5A5A5), fontWeight: FontWeight.w400, fontSize: text.scale(18), fontFamily: "Poppins"),
                      ),
                      requestLoading
                          ? TextButton(
                              onPressed: () {},
                              child: Text(
                                "Request",
                                style: TextStyle(
                                    fontSize: text.scale(18), color: const Color(0XFFA5A5A5), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                              ))
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  requestLoading = true;
                                });
                                phoneVerify();
                              },
                              child: Text(
                                "Request",
                                style: TextStyle(
                                    fontSize: text.scale(18), color: const Color(0XFF0EA102), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                              ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
