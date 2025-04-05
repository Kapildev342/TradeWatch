import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Edited_Packages/PhoneField/intlPhone.dart';
import 'package:tradewatchfinal/Edited_Packages/Polygon/src/polygon.dart';
import 'package:tradewatchfinal/Edited_Packages/Polygon/src/polygon_border.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Settings/profile_data_model.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';

import 'edit_code_verify.dart';

class EditProfilePage extends StatefulWidget {
  final bool comeFrom;

  const EditProfilePage({Key? key, required this.comeFrom}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool googleSwitch = false;
  bool appleSwitch = false;
  bool facebookSwitch = false;
  bool twitterSwitch = false;
  bool diaLoading = false;
  String dialCode = "";
  int phoneLength = 10;
  Map<String, dynamic> response = {};
  bool usernameCustomError = false;
  dynamic res1;
  String countryCode = "";
  String countryCode1 = "";
  bool customError = false;
  bool phoneError = false;
  bool firstNameEmpty = false;
  bool lastNameEmpty = false;

  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _unController = TextEditingController();
  final TextEditingController _fnController = TextEditingController();
  final TextEditingController _lnController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _customisedAboutController = TextEditingController();
  bool doNotShowPassword = true;
  bool doNotShowPassword1 = true;
  bool doNotShowPassword2 = true;
  bool fnNameText = false;
  bool aboutMeText = true;
  bool unNameText = false;
  bool lnNameText = false;
  bool phoneNumText = false;
  bool phoneVerify = true;
  Map<String, dynamic> responseData = {};
  bool response123 = false;
  bool response12 = false;
  bool loader = false;
  bool passwordExist = false;
  String firstName = "";
  String lastName = "";
  String userName = "";
  String changeUserName = "";
  bool passWordValid = true;
  bool defaultValue = false;
  String phoneCode = "";
  String phoneNumber = "";
  String email = "";
  String phoneNo = "";
  String referralCode = "";
  String verifyId = "";
  String completeNo = "";
  bool loading = false;
  bool changes = false;
  bool checkUnValue = false;
  bool phoneVerified = false;
  bool popUpLoading = false;
  File? image;
  File? dummyImage;
  File? coverImage;
  File? dummyCoverImage;
  late int newOTP;
  String mainUserId = "";
  String mainUserToken = "";
  FocusNode aboutMeFocusNode = FocusNode();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode firstnameFocusNode = FocusNode();
  FocusNode lastnameFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  List<bool> boolList = List.generate(10, (index) => false);

  late ProfileDataModel profile;
  String avatar = "";
  String coverAvatar = "";
  int avatarSelectedIndex = 0;
  bool customisedAbout = false;
  double linearValue = 0.0;
  int totalData = 9;
  int usedData = 1;
  int usedDataCheckValue = 1;

  otpVerify({
    required String first,
    required String last,
    required String userName1,
    required String countryCode,
    required String dialCode,
    required String phone,
    required String filePath,
    required StateSetter modelSetState,
  }) async {
    if (phone.isEmpty || phone.length != phoneLength) {
      Flushbar(
        message: "phone Number Length should be $phoneLength",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else {
      String newDial = dialCode.isEmpty ? "+91" : dialCode;
      String newPhone = phone;
      completeNo = newDial + newPhone;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: completeNo,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          modelSetState(() {
            popUpLoading = false;
          });
          if (e.code == "too-many-requests") {
            Flushbar(
              message: "OTP has sent too many times to this number, Please try again after",
              duration: const Duration(seconds: 2),
            ).show(context);
          }
          if (e.code == 'invalid-phone-number') {
            if (kDebugMode) {}
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          verifyId = verificationId;
          modelSetState(() {
            popUpLoading = false;
          });
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
            return EditCodeVerify(
              dialCode: dialCode.isEmpty ? "+91" : dialCode,
              phone: phone,
              first: first,
              last: last,
              userName1: userName,
              email: email,
              countryCode: countryCode,
              referralCode: "",
              filePath: filePath,
              completePhone: completeNo,
              verifyId: verifyId,
            );
          }));
        },
        timeout: const Duration(seconds: 25),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  Future<bool> checkEmailFunc(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    bool newValue = false;
    var url = Uri.parse(baseurl + versions + checkUserName);
    var responseNew = await http
        .post(url, body: {"username": value}, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Authorization': mainUserToken});
    var responseDataNew = json.decode(responseNew.body);
    setState(() {
      newValue = responseDataNew["status"];
    });
    if (!newValue) {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "UserName already Exists",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
    return responseDataNew["status"];
  }

  socialLoginGoogle(var email, var socialId, var type, var phoneCode, var phoneNumber, var socialAvatar) async {
    var uri = Uri.parse(baseurl + versions + socialLoginLink);
    var response = await http.post(uri, body: {
      'email': email,
      'socialid': socialId,
      'type': type,
      'phone_code': phoneCode,
      'phone_number': phoneNumber,
      'social_avatar': socialAvatar,
    }, headers: {
      "authorization": mainUserToken,
    });
    var responseData = jsonDecode(response.body);
    if (responseData != null) {
      if (responseData["status"] == false) {
        setState(() {
          googleSwitch = false;
        });
        if (!mounted) {
          return;
        }
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        setState(() {
          googleSwitch = true;
        });
      }
      await getData();
      GoogleSignIn().signOut();
      FacebookAuth.instance.logOut();
    }
  }

  socialLoginFb(var email, var socialId, var type, var phoneCode, var phoneNumber, var socialAvatar) async {
    var uri = Uri.parse(baseurl + versions + socialLoginLink);
    var response = await http.post(uri, body: {
      'email': email,
      'socialid': socialId,
      'type': type,
      'phone_code': phoneCode,
      'phone_number': phoneNumber,
      'social_avatar': socialAvatar,
    }, headers: {
      "authorization": mainUserToken,
    });
    var responseData = jsonDecode(response.body);
    if (responseData != null) {
      if (responseData["status"] == false) {
        setState(() {
          facebookSwitch = false;
        });
        if (!mounted) {
          return;
        }
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        setState(() {
          facebookSwitch = true;
        });
      }
      await getData();
      FacebookAuth.instance.logOut();
    }
  }

  socialLoginTwitter(var email, var socialId, var type, var phoneCode, var phoneNumber, var socialAvatar) async {
    var uri = Uri.parse(baseurl + versions + socialLoginLink);
    var response = await http.post(uri, body: {
      'email': email,
      'socialid': socialId,
      'type': type,
      'phone_code': phoneCode,
      'phone_number': phoneNumber,
      'social_avatar': socialAvatar,
    }, headers: {
      "authorization": mainUserToken,
    });
    var responseData = jsonDecode(response.body);
    if (responseData != null) {
      if (responseData["status"] == false) {
        setState(() {
          twitterSwitch = false;
        });
        if (!mounted) {
          return;
        }
        Flushbar(
          message: responseData['message'],
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        setState(() {
          twitterSwitch = true;
        });
      }
      await getData();
    }
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mainSkipValue == false) {
      usedData = 1;
      profile = await settingsMain.getData();
      avatar = profile.response.avatar;
      passwordExist = profile.response.verifyPassword;
      phoneVerified = profile.response.mobileVerified;
      referralCode = profile.response.referralCode;
      coverAvatar = profile.response.coverImage;
      _aboutMeController.text = _customisedAboutController.text = profile.response.about;
      _unController.text = userName = profile.response.username;
      _fnController.text = profile.response.firstName;
      _lnController.text = profile.response.lastName;
      _emailController.text = profile.response.email;
      _phoneController.text = phoneNo = profile.response.phoneNumber;
      phoneCode = profile.response.phoneCode;
      countryCode1 = profile.response.countryCode;
      googleSwitch = profile.response.socialLogins.google;
      appleSwitch = profile.response.socialLogins.apple;
      facebookSwitch = profile.response.socialLogins.facebook;
      twitterSwitch = profile.response.socialLogins.twitter;
      prefs.setString('newUserAvatar', avatar);
      avatarMain.value = avatar;
      profile.response.coverChanged ? usedData++ : debugPrint("nothing");
      profile.response.avatarChanged ? usedData++ : debugPrint("nothing");
      _aboutMeController.text.isNotEmpty ? usedData++ : debugPrint("nothing");
      _unController.text.isNotEmpty ? usedData++ : debugPrint("nothing");
      _fnController.text.isNotEmpty ? usedData++ : debugPrint("nothing");
      _lnController.text.isNotEmpty ? usedData++ : debugPrint("nothing");
      phoneError == false ? usedData++ : debugPrint("nothing");
      passwordExist ? usedData++ : debugPrint("nothing");
      linearValue = usedData / totalData;
    }
    setState(() {
      loader = true;
    });
  }

  updateProfile({
    required String first,
    required String last,
    required String phoneCode,
    required String countryCode,
    required String userName1,
    required String phone,
  }) async {
    TextScaler text = MediaQuery.of(context).textScaler;
    if (first == "" || last == "" || userName1 == "" || phone == "") {
      setState(() {
        loading = false;
      });
      Flushbar(
        message: "Please fill all fields",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else if (userName != userName1) {
      response123 = await checkEmailFunc(changeUserName);
      if (!response123) {
        setState(() {
          loading = false;
        });
        if (!mounted) {
          return;
        }
        Flushbar(
          message: "UserName already Exists, please provide unique username",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (phoneVerified == false || phoneVerify == false) {
          /*  setState(() {
            loading = false;
          });*/
          var url = Uri.parse(baseurl + versions + checkPhone);
          var responseNew = await http.post(url,
              body: {"phone_code": dialCode.isEmpty ? "+91" : dialCode, "phone_number": phone},
              headers: {'Content-Type': 'application/x-www-form-urlencoded'});
          var responseDataNew = json.decode(responseNew.body);
          if (responseDataNew['status']) {
            if (!mounted) {
              return;
            }
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter modelSetState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                        child: Container(
                          height: 240,
                          margin: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Text("OTP Verify",
                                      style: TextStyle(
                                          color: const Color(0XFF0EA102),
                                          fontWeight: FontWeight.bold,
                                          fontSize: text.scale(20),
                                          fontFamily: "Poppins"))),
                              const Divider(),
                              Container(
                                  padding: const EdgeInsets.all(15),
                                  child:
                                      const Text("You have recently added/changed your mobile Number. Press Continue to verify your Phone Number")),
                              const Spacer(),
                              popUpLoading
                                  ? Center(
                                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              if (!mounted) {
                                                return;
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(15)),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                            onPressed: () async {
                                              modelSetState(() {
                                                popUpLoading = true;
                                              });
                                              otpVerify(
                                                  first: first,
                                                  last: last,
                                                  userName1: userName1,
                                                  countryCode: countryCode == "" ? "IN" : countryCode,
                                                  dialCode: phoneCode,
                                                  phone: phone,
                                                  filePath: "",
                                                  modelSetState: modelSetState);
                                            },
                                            child: Text(
                                              "Continue",
                                              style: TextStyle(
                                                  color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(15)),
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
                    },
                  );
                });
            setState(() {
              loading = false;
            });
          } else {
            if (!mounted) {
              return;
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
          var uri = Uri.parse(baseurl + versions + update);
          var response = await http.post(uri, body: {
            "first_name": first,
            "last_name": last,
            "username": userName1,
            "email": email,
            "phone_code": phoneCode == "" ? "+91" : phoneCode,
            "country_code": countryCode == "" ? "IN" : countryCode,
            "phone_number": phoneNo,
            "referral_code": referralCode,
            "user_id": mainUserId,
            "mobile_verified": "true",
            "about": _aboutMeController.text,
            "default_avatar": profile.response.defaultAvatarsList[avatarSelectedIndex]
          }, headers: {
            "authorization": mainUserToken,
          });
          if (response.statusCode == 200) {
            getData();
            /*widget.comeFrom
                ? Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                    return SettingsView();
                  }))
                : Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                    return MainBottomNavigationPage(
                      tType: true,
                      text: "",
                      caseNo1: 0,
                      newIndex: 0,
                      excIndex: 0,
                      countryIndex: 0,
                      isHomeFirstTym: false,
                    );
                  }));*/
            if (!mounted) {
              return;
            }
            Flushbar(
              message: "Profile successfully updated",
              duration: const Duration(seconds: 2),
            ).show(context);
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              loading = false;
            });
          }
        }
      }
    } else if (phoneVerified == false || phoneVerify == false) {
      var url = Uri.parse(baseurl + versions + checkPhone);
      var responseNew = await http.post(url,
          body: {"phone_code": dialCode.isEmpty ? "+91" : dialCode, "phone_number": phone},
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew['status']) {
        if (!mounted) {
          return;
        }
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter modelSetState) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                    child: Container(
                      height: 240,
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text("OTP Verify",
                                  style: TextStyle(
                                      color: const Color(0XFF0EA102), fontWeight: FontWeight.bold, fontSize: text.scale(20), fontFamily: "Poppins"))),
                          const Divider(),
                          Container(
                              padding: const EdgeInsets.all(15),
                              child: const Text("You have recently added/changed your mobile Number. Press Continue to verify your Phone Number")),
                          const Spacer(),
                          popUpLoading
                              ? Center(
                                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(15)),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () async {
                                          modelSetState(() {
                                            popUpLoading = true;
                                          });
                                          otpVerify(
                                              first: first,
                                              last: last,
                                              userName1: userName1,
                                              countryCode: countryCode == "" ? "IN" : countryCode,
                                              dialCode: phoneCode,
                                              phone: phone,
                                              modelSetState: modelSetState,
                                              filePath: "");
                                        },
                                        child: Text(
                                          "Continue",
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(15)),
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
                },
              );
            });
        setState(() {
          loading = false;
        });
      } else {
        if (!mounted) {
          return;
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
      var uri = Uri.parse(baseurl + versions + update);
      var response = await http.post(uri, body: {
        "first_name": first,
        "last_name": last,
        "username": userName1,
        "email": email,
        "phone_code": phoneCode == "" ? "+91" : phoneCode,
        "country_code": countryCode == "" ? "IN" : countryCode,
        "phone_number": phoneNo,
        "referral_code": referralCode,
        "user_id": mainUserId,
        "mobile_verified": "true",
        "about": _aboutMeController.text,
        "default_avatar": profile.response.defaultAvatarsList[avatarSelectedIndex]
      }, headers: {
        "authorization": mainUserToken,
      });
      if (response.statusCode == 200) {
        /*widget.comeFrom
            ? Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) {
                return SettingsView();
              }))
            : Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
                return MainBottomNavigationPage(
                  tType: true,
                  text: "",
                  caseNo1: 3,
                  newIndex: 0,
                  excIndex: 0,
                  countryIndex: 0,
                  isHomeFirstTym: false,
                );
              }));*/
        getData();
        if (!mounted) {
          return;
        }
        Flushbar(
          message: "Profile successfully updated",
          duration: const Duration(seconds: 2),
        ).show(context);
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }
  }

  updateProfile1(
      {required String first,
      required String last,
      required String phoneCode,
      required String countryCode,
      required String userName1,
      required String phone,
      required String filePath}) async {
    TextScaler text = MediaQuery.of(context).textScaler;
    if (first == "" || last == "" || userName1 == "" || phone == "") {
      setState(() {
        loading = false;
      });
      Flushbar(
        message: "Please fill all fields",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else if (userName != userName1) {
      response123 = await checkEmailFunc(changeUserName);
      if (!response123) {
        setState(() {
          loading = false;
        });
        if (!mounted) {
          return;
        }
        Flushbar(
          message: "UserName already Exists, please provide unique username",
          duration: const Duration(seconds: 2),
        ).show(context);
      } else {
        if (phoneVerified == false || phoneVerify == false) {
          var url = Uri.parse(baseurl + versions + checkPhone);
          var responseNew = await http.post(url,
              body: {"phone_code": dialCode.isEmpty ? "+91" : dialCode, "phone_number": phone},
              headers: {'Content-Type': 'application/x-www-form-urlencoded'});
          var responseDataNew = json.decode(responseNew.body);
          if (responseDataNew['status']) {
            if (!mounted) {
              return;
            }
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter modelSetState) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                        child: Container(
                          height: 240,
                          margin: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Text("OTP Verify",
                                      style: TextStyle(
                                          color: const Color(0XFF0EA102),
                                          fontWeight: FontWeight.bold,
                                          fontSize: text.scale(20),
                                          fontFamily: "Poppins"))),
                              const Divider(),
                              Container(
                                  padding: const EdgeInsets.all(15),
                                  child:
                                      const Text("You have recently added/changed your mobile Number. Press Continue to verify your Phone Number")),
                              const Spacer(),
                              popUpLoading
                                  ? Center(
                                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              if (!mounted) {
                                                return;
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(15)),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                            onPressed: () async {
                                              modelSetState(() {
                                                popUpLoading = true;
                                              });
                                              otpVerify(
                                                  first: first,
                                                  last: last,
                                                  userName1: userName1,
                                                  countryCode: countryCode == "" ? "IN" : countryCode,
                                                  dialCode: phoneCode,
                                                  phone: phone,
                                                  filePath: "",
                                                  modelSetState: modelSetState);
                                            },
                                            child: Text(
                                              "Continue",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Poppins",
                                                fontSize: text.scale(15),
                                              ),
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
                    },
                  );
                });
            setState(() {
              loading = false;
            });
          } else {
            if (!mounted) {
              return;
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
          Map<String, File> data = {};
          if (image != null || coverImage != null) {
            if (image == null) {
              data = {'cover': coverImage!};
            } else if (coverImage == null) {
              data = {'file': image!};
            } else {
              data = {'file': image!, 'cover': coverImage!};
            }
          }
          res1 = await functionsMain.sendForm(
              baseurl + versions + update,
              {
                'first_name': first,
                'last_name': last,
                'username': userName1,
                'email': email,
                'phone_code': phoneCode,
                'country_code': countryCode,
                'phone_number': phoneNo,
                'referral_code': referralCode,
                'user_id': mainUserId,
                "mobile_verified": "true",
                "about": _aboutMeController.text,
                "default_avatar": image == null ? profile.response.defaultAvatarsList[avatarSelectedIndex] : ""
              },
              data);
          if (res1.data["status"]) {
            getData();
            /* widget.comeFrom
                ? Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                    return SettingsView();
                  }))
                : Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                    return MainBottomNavigationPage(
                      tType: true,
                      text: "",
                      caseNo1: 0,
                      newIndex: 0,
                      excIndex: 0,
                      countryIndex: 0,
                      isHomeFirstTym: false,
                    );
                  }));*/
            if (!mounted) {
              return;
            }
            Flushbar(
              message: res1.data["message"],
              duration: const Duration(seconds: 2),
            ).show(context);
            setState(() {
              loading = false;
            });
          } else {
            if (!mounted) {
              return;
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
    } else if (phoneVerified == false || phoneVerify == false) {
      var url = Uri.parse(baseurl + versions + checkPhone);
      var responseNew = await http.post(url,
          body: {"phone_code": dialCode.isEmpty ? "+91" : dialCode, "phone_number": phone},
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      var responseDataNew = json.decode(responseNew.body);
      if (responseDataNew['status']) {
        if (!mounted) {
          return;
        }
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter modelSetState) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                    child: Container(
                      height: 240,
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text("OTP Verify",
                                  style: TextStyle(
                                      color: const Color(0XFF0EA102), fontWeight: FontWeight.bold, fontSize: text.scale(20), fontFamily: "Poppins"))),
                          const Divider(),
                          Container(
                              padding: const EdgeInsets.all(15),
                              child: const Text("You have recently added/changed your mobile Number. Press Continue to verify your Phone Number")),
                          const Spacer(),
                          popUpLoading
                              ? Center(
                                  child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(15)),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () async {
                                          modelSetState(() {
                                            popUpLoading = true;
                                          });
                                          otpVerify(
                                              first: first,
                                              last: last,
                                              userName1: userName1,
                                              countryCode: countryCode == "" ? "IN" : countryCode,
                                              dialCode: phoneCode,
                                              phone: phone,
                                              filePath: "",
                                              modelSetState: modelSetState);
                                        },
                                        child: Text(
                                          "Continue",
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.w600, fontFamily: "Poppins", fontSize: text.scale(15)),
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
                },
              );
            });
        setState(() {
          loading = false;
        });
      } else {
        if (!mounted) {
          return;
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
      Map<String, File> data = {};
      if (image != null || coverImage != null) {
        if (image == null) {
          data = {'cover': coverImage!};
        } else if (coverImage == null) {
          data = {'file': image!};
        } else {
          data = {'file': image!, 'cover': coverImage!};
        }
      }
      res1 = await functionsMain.sendForm(
          baseurl + versions + update,
          {
            'first_name': first,
            'last_name': last,
            'username': userName1,
            'email': email,
            'phone_code': phoneCode,
            'country_code': countryCode,
            'phone_number': phoneNo,
            'referral_code': referralCode,
            'user_id': mainUserId,
            "mobile_verified": "true",
            "about": _aboutMeController.text,
            "default_avatar": image == null ? profile.response.defaultAvatarsList[avatarSelectedIndex] : ""
          },
          data);
      if (res1.data["status"]) {
        getData();
        /*widget.comeFrom
            ? Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) {
                return SettingsView();
              }))
            : Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
                return MainBottomNavigationPage(
                  tType: true,
                  text: "",
                  caseNo1: 0,
                  newIndex: 0,
                  excIndex: 0,
                  countryIndex: 0,
                  isHomeFirstTym: false,
                );
              }));*/
        if (!mounted) {
          return;
        }
        Flushbar(
          message: res1.data["message"],
          duration: const Duration(seconds: 2),
        ).show(context);
        setState(() {
          loading = false;
        });
      } else {
        if (!mounted) {
          return;
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

  removeAvatar({required String type}) async {
    var uri = Uri.parse(baseurl + versions + removeAvatarPic);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "type": type
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
      type == 'cover' ? coverImage = null : image = null;
      setState(() {
        usedData--;
        linearValue = usedData / totalData;
      });
      if (!mounted) {
        return;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
      await getData();
    }
  }

  userInsightFunc({required String typeData, required String aliasData}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString("newUserToken") ?? "";
    var url = Uri.parse(baseurl + versions + userInsightUpdate);
    var response = await http.post(url,
        body: {"alias": aliasData, "type": typeData}, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'Authorization': mainUserToken});
    responseData = json.decode(response.body);
  }

  @override
  void initState() {
    getAllDataMain(name: 'Edit_Profile_Screen');
    userInsightFunc(aliasData: 'settings', typeData: 'profile_details');
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        widget.comeFrom
            ? Navigator.pop(context, true)
            : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return const MainBottomNavigationPage(
                  tType: true,
                  text: "",
                  caseNo1: 0,
                  newIndex: 0,
                  excIndex: 0,
                  countryIndex: 0,
                  isHomeFirstTym: false,
                );
              }));
        return false;
      },
      child: Container(
        //color: const Color(0XFFFFFFFF),
        color: Theme.of(context).colorScheme.background,
        child: SafeArea(
          child: Scaffold(
            // backgroundColor: const Color(0XFFFFFFFF),
            backgroundColor: Theme.of(context).colorScheme.background,
            /* appBar: AppBar(
              elevation: 0,
              leadingWidth: 45,
              backgroundColor: Color(0XFFFFFFFF),
              title: Text(
                widget.comeFrom ? 'Edit profile' : 'Complete your Profile',
                style: TextStyle(
                    fontSize: _text * 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Poppins"),
              ),
              leading: GestureDetector(
                  onTap: () {
                    widget.comeFrom
                        ? Navigator.pop(context)
                        : Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                            return MainBottomNavigationPage(
                              tType: true,
                              text: "",
                              caseNo1: 0,
                              newIndex: 0,
                              excIndex: 0,
                              countryIndex: 0,
                              isHomeFirstTym: false,
                            );
                          }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  )),
            ),*/
            body: loader
                ? Stack(
                    children: [
                      Container(
                        height: height / 4.68,
                        decoration: BoxDecoration(
                            image: coverImage != null
                                ? DecorationImage(image: FileImage(coverImage!), fit: BoxFit.fill)
                                : DecorationImage(
                                    image: NetworkImage(coverAvatar), //AssetImage('lib/Constants/Assets/Settings/coverImage.png'),
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
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                        child: Column(
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
                                          /* _settings.settingsBackNavigationFunction(
                                      context: context,
                                      checkMainSkipValue: checkMainSkipValue,
                                      fromWhere: widget.fromWhere??"");*/
                                          widget.comeFrom
                                              ? Navigator.pop(context, true)
                                              : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return const MainBottomNavigationPage(
                                                    tType: true,
                                                    text: "",
                                                    caseNo1: 0,
                                                    newIndex: 0,
                                                    excIndex: 0,
                                                    countryIndex: 0,
                                                    isHomeFirstTym: false,
                                                  );
                                                }));
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          color: Color(0XFFC3C3C3),
                                        ),
                                      ),
                                      Text(
                                        "Edit Profile",
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
                              child: GestureDetector(
                                onTap: mainSkipValue
                                    ? () {
                                        commonFlushBar(context: context, initFunction: getData);
                                      }
                                    : () {
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                          return FullScreenImage(
                                            imageUrl: avatar,
                                            tag: "generate_a_unique_tag",
                                          );
                                        }));
                                      },
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
                                              : avatar == ""
                                                  ? const DecorationImage(
                                                      image: AssetImage("lib/Constants/Assets/SMLogos/Settings/Profile.png"), fit: BoxFit.fill)
                                                  : DecorationImage(image: NetworkImage(avatar), fit: BoxFit.fill)),
                                    ),
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
                                  showBottomSheet(
                                      context: context,
                                      avatarEnabled: profile.response.avatarChanged,
                                      coverEnabled: profile.response.coverChanged,
                                      forWhat: 'change');
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
                            profile.response.coverChanged || profile.response.avatarChanged
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
                                        showBottomSheet(
                                            context: context,
                                            avatarEnabled: profile.response.avatarChanged,
                                            coverEnabled: profile.response.coverChanged,
                                            forWhat: 'remove');
                                      },
                                      child: Text(
                                        'Remove',
                                        style: TextStyle(
                                            color: Colors.grey.shade300,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Poppins",
                                            fontSize: text.scale(12)),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            profile.response.coverChanged || profile.response.avatarChanged
                                ? SizedBox(
                                    height: height / 57.33,
                                  )
                                : const SizedBox(),
                            LinearProgressIndicator(
                              value: linearValue,
                            ),
                            SizedBox(
                              height: height / 108.25,
                            ),
                            Center(
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: usedData == totalData ? "Your profile completed 100% successfully" : "Complete your profile ",
                                      style: TextStyle(
                                          fontSize: text.scale(14),
                                          color: const Color(0XFF1E1E1E),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins")),
                                  usedData == totalData
                                      ? TextSpan(
                                          text: "",
                                          style: TextStyle(
                                              fontSize: text.scale(14),
                                              color: const Color(0XFF0EA102),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Poppins"),
                                        )
                                      : TextSpan(
                                          text: "${((linearValue * 100).round()).toString()}%",
                                          style: TextStyle(
                                              fontSize: text.scale(14),
                                              color: const Color(0XFF0EA102),
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Poppins"),
                                        ),
                                ]),
                              ),
                            ),
                            SizedBox(
                              height: usedData == totalData ? height / 57.33 : 5,
                            ),
                            usedData == totalData
                                ? const SizedBox()
                                : Center(
                                    child: Text(
                                      "Please complete your profile and add a balance of ${100 - ((linearValue * 100).round())}% to it",
                                      style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500, color: const Color(0XFF535353)),
                                    ),
                                  ),
                            usedData == totalData
                                ? const SizedBox()
                                : SizedBox(
                                    height: height / 57.33,
                                  ),
                            Expanded(
                              child: ListView(
                                children: [
                                  Text(
                                    'About me',
                                    style:
                                        TextStyle(fontSize: text.scale(13), fontFamily: "Poppins", fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  SizedBox(height: height / 108.25),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: TextFormField(
                                      focusNode: aboutMeFocusNode,
                                      onTap: () {
                                        usedDataCheckValue = usedData;
                                        showAboutBottomSheet(context: context);
                                      },
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          if (usedDataCheckValue == usedData) {
                                            setState(() {
                                              usedData--;
                                              linearValue = usedData / totalData;
                                            });
                                          }
                                        } else {
                                          if (usedDataCheckValue != usedData) {
                                            setState(() {
                                              usedData++;
                                              linearValue = usedData / totalData;
                                            });
                                          }
                                        }
                                      },
                                      style: TextStyle(
                                        fontSize: text.scale(15),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      readOnly: aboutMeText,
                                      controller: _aboutMeController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        suffixIcon: Container(
                                            height: height / 40.6,
                                            width: width / 18.75,
                                            padding: const EdgeInsets.all(13),
                                            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/edit.svg")),
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
                                  SizedBox(height: height / 72.16),
                                  Text(
                                    'User name',
                                    style:
                                        TextStyle(fontSize: text.scale(13), fontFamily: "Poppins", fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  SizedBox(height: height / 108.25),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: TextFormField(
                                      focusNode: usernameFocusNode,
                                      onTap: () {
                                        usedDataCheckValue = usedData;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          defaultValue = true;
                                        });
                                        if (value.isEmpty) {
                                          if (usedDataCheckValue == usedData) {
                                            setState(() {
                                              usedData--;
                                              linearValue = usedData / totalData;
                                            });
                                          }
                                        } else {
                                          if (usedDataCheckValue != usedData) {
                                            setState(() {
                                              usedData++;
                                              linearValue = usedData / totalData;
                                            });
                                          }
                                        }
                                        if (value == userName) {
                                        } else if (value.isEmpty) {
                                        } else {
                                          changeUserName = value;
                                          checkEmailFunc(changeUserName);
                                        }
                                        if (value.length < 3) {
                                          setState(() {
                                            usernameCustomError = true;
                                          });
                                        } else {
                                          usernameCustomError = false;
                                        }
                                        setState(() {
                                          passWordValid = RegExp(r"([a-z])").hasMatch(value);
                                          customError = value.contains(RegExp(r'[^a-z0-9_@-]'));
                                        });
                                      },
                                      style: TextStyle(
                                        fontSize: text.scale(15),
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      readOnly: unNameText,
                                      controller: _unController,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(16),
                                        // FilteringTextInputFormatter.deny(RegExp(r'[A-Z]')),
                                      ],
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          padding: const EdgeInsets.all(0.0),
                                          onPressed: () {
                                            setState(() {
                                              //unNameText = !unNameText;
                                              FocusScope.of(context).requestFocus(usernameFocusNode);
                                            });
                                          },
                                          icon: SizedBox(
                                              height: height / 40.6,
                                              width: width / 18.75,
                                              child: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/edit.svg")),
                                        ),
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
                                        hintText: 'UserName',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.4),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Must be in 3-16 Characters (accepts only small alphabets, numbers, special characters (only _@-)) ',
                                    style:
                                        TextStyle(fontSize: text.scale(10), fontFamily: "Poppins", fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  defaultValue
                                      ? customError
                                          ? Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "allows only lowercase and _@-",
                                                    style: TextStyle(fontSize: text.scale(11), color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : usernameCustomError
                                              ? Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      _unController.text.length < 3
                                                          ? Text("Minimum of 3 characters",
                                                              style: TextStyle(fontSize: text.scale(11), color: Colors.red))
                                                          : const SizedBox(),
                                                    ],
                                                  ))
                                              : const SizedBox()
                                      : const SizedBox(),
                                  defaultValue
                                      ? _unController.text.length >= 3
                                          ? passWordValid
                                              ? const SizedBox()
                                              : Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text("atleast contains one alphabet",
                                                          style: TextStyle(fontSize: text.scale(11), color: Colors.red)),
                                                    ],
                                                  ),
                                                )
                                          : const SizedBox()
                                      : const SizedBox(),
                                  SizedBox(height: height / 72.16),
                                  Text(
                                    'First name',
                                    style:
                                        TextStyle(fontFamily: "Poppins", fontSize: text.scale(13), fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: TextFormField(
                                      focusNode: firstnameFocusNode,
                                      style: TextStyle(fontSize: text.scale(16), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                                      onTap: () {
                                        usedDataCheckValue = usedData;
                                      },
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          if (usedDataCheckValue == usedData) {
                                            setState(() {
                                              usedData--;
                                              linearValue = usedData / totalData;
                                            });
                                          }
                                        } else {
                                          if (usedDataCheckValue != usedData) {
                                            setState(() {
                                              usedData++;
                                              linearValue = usedData / totalData;
                                            });
                                          }
                                        }
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            firstNameEmpty = false;
                                          });
                                        } else {
                                          setState(() {
                                            firstNameEmpty = true;
                                          });
                                        }
                                      },
                                      readOnly: fnNameText,
                                      controller: _fnController,
                                      textCapitalization: TextCapitalization.words,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          padding: const EdgeInsets.all(0.0),
                                          onPressed: () {
                                            setState(() {
                                              FocusScope.of(context).requestFocus(firstnameFocusNode);
                                            });
                                          },
                                          icon: SizedBox(
                                            height: height / 40.6,
                                            width: width / 18.75,
                                            child: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/edit.svg"),
                                          ),
                                        ),
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
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [Text("Please enter firstname", style: TextStyle(fontSize: text.scale(11), color: Colors.red))],
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
                                      focusNode: lastnameFocusNode,
                                      readOnly: lnNameText,
                                      style: TextStyle(fontSize: text.scale(16), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          if (usedDataCheckValue == usedData) {
                                            setState(() {
                                              usedData--;
                                              linearValue = usedData / totalData;
                                            });
                                          }
                                        } else {
                                          if (usedDataCheckValue != usedData) {
                                            setState(() {
                                              usedData++;
                                              linearValue = usedData / totalData;
                                            });
                                          }
                                        }
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            lastNameEmpty = false;
                                          });
                                        } else {
                                          setState(() {
                                            lastNameEmpty = true;
                                          });
                                        }
                                      },
                                      onTap: () {
                                        usedDataCheckValue = usedData;
                                      },
                                      controller: _lnController,
                                      keyboardType: TextInputType.emailAddress,
                                      textCapitalization: TextCapitalization.words,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          padding: const EdgeInsets.all(0.0),
                                          onPressed: () {
                                            setState(() {
                                              //lnNameText = !lnNameText;
                                              FocusScope.of(context).requestFocus(lastnameFocusNode);
                                            });
                                          },
                                          icon: SizedBox(
                                              height: height / 40.6,
                                              width: width / 18.75,
                                              child: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/edit.svg")),
                                        ),
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
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [Text("Please enter lastname", style: TextStyle(fontSize: text.scale(11), color: Colors.red))],
                                          ))
                                      : const SizedBox(),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Email',
                                    style:
                                        TextStyle(fontSize: text.scale(13), fontFamily: "Poppins", fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: TextFormField(
                                      readOnly: true,
                                      style: TextStyle(fontSize: text.scale(16), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                                      controller: _emailController,
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
                                        hintText: 'Email',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // passwordExist
                                  //     ?
                                  Text(
                                    'Password',
                                    style:
                                        TextStyle(fontFamily: "Poppins", fontSize: text.scale(13), fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  // : SizedBox(),
                                  // passwordExist
                                  //     ?
                                  const SizedBox(height: 8),
                                  //: SizedBox(),
                                  /* passwordExist
                                      ? */
                                  SizedBox(
                                    height: height / 14.5,
                                    child: TextFormField(
                                      readOnly: true,
                                      style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins", fontWeight: FontWeight.w400),
                                      controller: _pwController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          padding: const EdgeInsets.all(0.0),
                                          onPressed: () {
                                            passwordExist
                                                ? showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return StatefulBuilder(
                                                        builder: (context, setState) {
                                                          return Dialog(
                                                            shape:
                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                            child: Container(
                                                              height: height / 2.5,
                                                              margin: const EdgeInsets.all(15),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Center(
                                                                      child: Text("Change Password",
                                                                          style: TextStyle(
                                                                              color: const Color(0XFF0EA102),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: text.scale(20),
                                                                              fontFamily: "Poppins"))),
                                                                  const SizedBox(height: 20),
                                                                  TextFormField(
                                                                    style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                                                    obscureText: doNotShowPassword2,
                                                                    controller: _oldPasswordController,
                                                                    keyboardType: TextInputType.text,
                                                                    decoration: InputDecoration(
                                                                      contentPadding: const EdgeInsets.all(20),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      labelStyle: TextStyle(
                                                                          color: const Color(0XFFA5A5A5),
                                                                          fontSize: text.scale(14),
                                                                          fontWeight: FontWeight.normal,
                                                                          fontFamily: "Poppins"),
                                                                      labelText: 'Old Password',
                                                                      border: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      suffixIcon: GestureDetector(
                                                                        onTap: () {
                                                                          setState(() {
                                                                            doNotShowPassword2 = !doNotShowPassword2;
                                                                          });
                                                                        },
                                                                        child: doNotShowPassword2
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
                                                                  const SizedBox(height: 10),
                                                                  TextFormField(
                                                                    style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                                                    obscureText: doNotShowPassword,
                                                                    controller: _passwordController,
                                                                    keyboardType: TextInputType.text,
                                                                    decoration: InputDecoration(
                                                                      contentPadding: const EdgeInsets.all(20),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      labelStyle: TextStyle(
                                                                          color: const Color(0XFFA5A5A5),
                                                                          fontSize: text.scale(14),
                                                                          fontWeight: FontWeight.normal,
                                                                          fontFamily: "Poppins"),
                                                                      labelText: 'Password',
                                                                      border: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
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
                                                                  const SizedBox(height: 10),
                                                                  TextFormField(
                                                                    style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                                                    obscureText: doNotShowPassword1,
                                                                    controller: _newPasswordController,
                                                                    keyboardType: TextInputType.text,
                                                                    decoration: InputDecoration(
                                                                      contentPadding: const EdgeInsets.all(20),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      labelStyle: TextStyle(
                                                                          color: const Color(0XFFA5A5A5),
                                                                          fontSize: text.scale(14),
                                                                          fontWeight: FontWeight.normal,
                                                                          fontFamily: "Poppins"),
                                                                      labelText: 'Confirm Password',
                                                                      border: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      suffixIcon: GestureDetector(
                                                                        onTap: () {
                                                                          setState(() {
                                                                            doNotShowPassword1 = !doNotShowPassword1;
                                                                          });
                                                                        },
                                                                        child: doNotShowPassword1
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
                                                                  const SizedBox(height: 20),
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            if (!mounted) {
                                                                              return;
                                                                            }
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Text(
                                                                            "Cancel",
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "Poppins",
                                                                                fontSize: text.scale(15)),
                                                                          ),
                                                                        ),
                                                                        diaLoading
                                                                            ? Center(
                                                                                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                                                    height: 100, width: 100))
                                                                            : ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(18.0),
                                                                                  ),
                                                                                  backgroundColor: Colors.green,
                                                                                ),
                                                                                onPressed: () async {
                                                                                  setState(() {
                                                                                    diaLoading = true;
                                                                                  });
                                                                                  bool passWordValid = RegExp(
                                                                                          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
                                                                                      .hasMatch(_passwordController.text);
                                                                                  if (_passwordController.text == "" ||
                                                                                      _newPasswordController.text == "" ||
                                                                                      _oldPasswordController.text == "") {
                                                                                    Flushbar(
                                                                                      message: "Please Fill all the Fields",
                                                                                      duration: const Duration(seconds: 2),
                                                                                    ).show(context);
                                                                                    setState(() {
                                                                                      diaLoading = false;
                                                                                    });
                                                                                  } else if (!passWordValid) {
                                                                                    Flushbar(
                                                                                      message:
                                                                                          "Password should contain Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character",
                                                                                      duration: const Duration(seconds: 2),
                                                                                    ).show(context);
                                                                                    setState(() {
                                                                                      diaLoading = false;
                                                                                    });
                                                                                  } else if (_passwordController.text !=
                                                                                      _newPasswordController.text) {
                                                                                    Flushbar(
                                                                                      message: "Both password are Not Matched",
                                                                                      duration: const Duration(seconds: 2),
                                                                                    ).show(context);
                                                                                    setState(() {
                                                                                      diaLoading = false;
                                                                                    });
                                                                                  } else {
                                                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                    mainUserId = prefs.getString('newUserId')!;
                                                                                    mainUserToken = prefs.getString('newUserToken')!;
                                                                                    var url = Uri.parse(baseurl + versions + changePassWord);
                                                                                    var response = await http.post(url, headers: {
                                                                                      'Content-Type': 'application/x-www-form-urlencoded',
                                                                                      'Authorization': mainUserToken
                                                                                    }, body: {
                                                                                      'oldpassword': _oldPasswordController.text,
                                                                                      'newpassword': _passwordController.text,
                                                                                      'confirmpassword': _newPasswordController.text
                                                                                    });
                                                                                    responseData = json.decode(response.body);
                                                                                    if (responseData["status"]) {
                                                                                      setState(() {
                                                                                        diaLoading = false;
                                                                                      });
                                                                                      if (!mounted) {
                                                                                        return;
                                                                                      }
                                                                                      Navigator.pop(context);
                                                                                      Flushbar(
                                                                                        message: responseData["message"],
                                                                                        duration: const Duration(seconds: 2),
                                                                                      ).show(context);
                                                                                    } else {
                                                                                      if (!mounted) {
                                                                                        return;
                                                                                      }
                                                                                      Flushbar(
                                                                                        message: responseData["message"],
                                                                                        duration: const Duration(seconds: 2),
                                                                                      ).show(context);
                                                                                      setState(() {
                                                                                        diaLoading = false;
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child: Text(
                                                                                  "Submit",
                                                                                  style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontFamily: "Poppins",
                                                                                      fontSize: text.scale(15)),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 20),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    })
                                                : showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return StatefulBuilder(
                                                        builder: (context, setState) {
                                                          return Dialog(
                                                            shape:
                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                            child: Container(
                                                              height: height / 3,
                                                              margin: const EdgeInsets.all(15),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Center(
                                                                      child: Text("Create Password",
                                                                          style: TextStyle(
                                                                              color: const Color(0XFF0EA102),
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: text.scale(20),
                                                                              fontFamily: "Poppins"))),
                                                                  const SizedBox(height: 20),
                                                                  TextFormField(
                                                                    style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                                                    obscureText: doNotShowPassword,
                                                                    controller: _passwordController,
                                                                    keyboardType: TextInputType.text,
                                                                    decoration: InputDecoration(
                                                                      contentPadding: const EdgeInsets.all(20),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      labelStyle: TextStyle(
                                                                          color: const Color(0XFFA5A5A5),
                                                                          fontSize: text.scale(14),
                                                                          fontWeight: FontWeight.normal,
                                                                          fontFamily: "Poppins"),
                                                                      labelText: 'Password',
                                                                      border: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
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
                                                                  const SizedBox(height: 10),
                                                                  TextFormField(
                                                                    style: TextStyle(fontSize: text.scale(15), fontFamily: "Poppins"),
                                                                    obscureText: doNotShowPassword1,
                                                                    controller: _newPasswordController,
                                                                    keyboardType: TextInputType.text,
                                                                    decoration: InputDecoration(
                                                                      contentPadding: const EdgeInsets.all(20),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      labelStyle: TextStyle(
                                                                          color: const Color(0XFFA5A5A5),
                                                                          fontSize: text.scale(14),
                                                                          fontWeight: FontWeight.normal,
                                                                          fontFamily: "Poppins"),
                                                                      labelText: 'Confirm Password',
                                                                      border: OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Color(0xffEFEFEF), width: 2),
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                      suffixIcon: GestureDetector(
                                                                        onTap: () {
                                                                          setState(() {
                                                                            doNotShowPassword1 = !doNotShowPassword1;
                                                                          });
                                                                        },
                                                                        child: doNotShowPassword1
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
                                                                  const SizedBox(height: 20),
                                                                  Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            if (!mounted) {
                                                                              return;
                                                                            }
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Text(
                                                                            "Cancel",
                                                                            style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "Poppins",
                                                                                fontSize: text.scale(15)),
                                                                          ),
                                                                        ),
                                                                        diaLoading
                                                                            ? Center(
                                                                                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json',
                                                                                    height: 100, width: 100))
                                                                            : ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(18.0),
                                                                                  ),
                                                                                  backgroundColor: Colors.green,
                                                                                ),
                                                                                onPressed: () async {
                                                                                  setState(() {
                                                                                    diaLoading = true;
                                                                                  });
                                                                                  bool passWordValid = RegExp(
                                                                                          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
                                                                                      .hasMatch(_passwordController.text);
                                                                                  if (_passwordController.text == "" ||
                                                                                      _newPasswordController.text == "") {
                                                                                    Flushbar(
                                                                                      message: "Please Fill all the Fields",
                                                                                      duration: const Duration(seconds: 2),
                                                                                    ).show(context);
                                                                                    setState(() {
                                                                                      diaLoading = false;
                                                                                    });
                                                                                  } else if (!passWordValid) {
                                                                                    Flushbar(
                                                                                      message:
                                                                                          "Password should contain Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character",
                                                                                      duration: const Duration(seconds: 2),
                                                                                    ).show(context);
                                                                                    setState(() {
                                                                                      diaLoading = false;
                                                                                    });
                                                                                  } else if (_passwordController.text !=
                                                                                      _newPasswordController.text) {
                                                                                    Flushbar(
                                                                                      message: "Both password are Not Matched",
                                                                                      duration: const Duration(seconds: 2),
                                                                                    ).show(context);
                                                                                    setState(() {
                                                                                      diaLoading = false;
                                                                                    });
                                                                                  } else {
                                                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                    mainUserId = prefs.getString('newUserId')!;
                                                                                    mainUserToken = prefs.getString('newUserToken')!;
                                                                                    var url = Uri.parse(baseurl + versions + createPassWord);
                                                                                    var response = await http.post(url, headers: {
                                                                                      'Content-Type': 'application/x-www-form-urlencoded',
                                                                                      'Authorization': mainUserToken
                                                                                    }, body: {
                                                                                      'new_password': _passwordController.text,
                                                                                      'confirm_password': _newPasswordController.text
                                                                                    });
                                                                                    responseData = json.decode(response.body);
                                                                                    if (responseData["status"]) {
                                                                                      setState(() {
                                                                                        diaLoading = false;
                                                                                      });
                                                                                      if (!mounted) {
                                                                                        return;
                                                                                      }
                                                                                      Navigator.pop(context);
                                                                                      Flushbar(
                                                                                        message: responseData["message"],
                                                                                        duration: const Duration(seconds: 2),
                                                                                      ).show(context);
                                                                                    } else {
                                                                                      if (!mounted) {
                                                                                        return;
                                                                                      }
                                                                                      Flushbar(
                                                                                        message: responseData["message"],
                                                                                        duration: const Duration(seconds: 2),
                                                                                      ).show(context);
                                                                                      setState(() {
                                                                                        diaLoading = false;
                                                                                      });
                                                                                    }
                                                                                  }
                                                                                },
                                                                                child: Text(
                                                                                  "Submit",
                                                                                  style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontFamily: "Poppins",
                                                                                      fontSize: text.scale(15)),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 20),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    });
                                          },
                                          icon: SizedBox(
                                              height: height / 40.6,
                                              width: width / 18.75,
                                              child: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/edit.svg")),
                                        ),
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
                                            fontSize: text.scale(14),
                                            fontWeight: FontWeight.normal,
                                            fontFamily: "Poppins"),
                                        hintText: '* * * * * * * *',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //: SizedBox(),
                                  // passwordExist
                                  //     ?
                                  const SizedBox(height: 12),
                                  // : SizedBox(),
                                  Text(
                                    'Phone number',
                                    style:
                                        TextStyle(fontSize: text.scale(13), fontFamily: "Poppins", fontWeight: FontWeight.w700, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: height / 14.5,
                                    child: IntlPhoneField(
                                      focusNode: phoneNumberFocusNode,
                                      readOnly: phoneNumText,
                                      controller: _phoneController,
                                      showDropdownIcon: false,
                                      showCursor: true,
                                      initialCountryCode: countryCode1,
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                      showCountryFlag: true,
                                      autovalidateMode: AutovalidateMode.disabled,
                                      dropdownTextStyle: TextStyle(fontSize: text.scale(16)),
                                      flagsButtonPadding: const EdgeInsets.only(left: 8, right: 3),
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          padding: const EdgeInsets.all(0.0),
                                          onPressed: () {
                                            setState(() {
                                              // phoneNumText = !phoneNumText;
                                              FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                                            });
                                          },
                                          icon: SizedBox(
                                              height: height / 40.6,
                                              width: width / 18.75,
                                              child: SvgPicture.asset("lib/Constants/Assets/SMLogos/Settings/edit.svg")),
                                        ),
                                        counterText: "",
                                        labelStyle: const TextStyle(color: Color(0XFFA5A5A5), fontFamily: "Poppins", fontWeight: FontWeight.w600),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Color(0XFFA5A5A5), width: 1.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      onTap: () {
                                        usedDataCheckValue = usedData;
                                      },
                                      onChanged: (phone) {
                                        if (phone.number.isEmpty) {
                                          if (usedDataCheckValue == usedData) {
                                            setState(() {
                                              usedData--;
                                              linearValue = usedData / totalData;
                                            });
                                          }
                                        } else {
                                          if (usedDataCheckValue != usedData) {
                                            setState(() {
                                              usedData++;
                                              linearValue = usedData / totalData;
                                            });
                                          }
                                        }
                                        if (phone.number.isEmpty || phone.number.length != phoneLength) {
                                          setState(() {
                                            phoneError = true;
                                          });
                                        } else {
                                          if (phone.number != phoneNo) {
                                            setState(() {
                                              phoneError = false;
                                              phoneVerify = false;
                                            });
                                          } else {
                                            setState(() {
                                              phoneError = false;
                                              phoneVerify = true;
                                            });
                                          }
                                        }
                                      },
                                      onCountryChanged: (country) {
                                        setState(() {
                                          _phoneController.clear();
                                          phoneError = true;
                                          dialCode = "+${country.dialCode}";
                                          countryCode = country.code;
                                          phoneLength = country.maxLength;
                                        });
                                      },
                                    ),
                                  ),
                                  phoneError
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text("Please enter valid phone number", style: TextStyle(fontSize: text.scale(11), color: Colors.red))
                                            ],
                                          ))
                                      : const SizedBox(),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Link to Social media',
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(18), fontFamily: "Poppins"),
                                  ),
                                  SizedBox(
                                    height: height / 33.83,
                                  ),
                                  SizedBox(
                                    height: height / 20.3,
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 15.0),
                                              child: SvgPicture.asset(
                                                "lib/Constants/Assets/SMLogos/Logos/google_new.svg",
                                                height: height / 33.83,
                                                width: width / 15.625,
                                              ),
                                            ),
                                            Text(
                                              'Google',
                                              style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: text.scale(14)),
                                            ),
                                          ],
                                        ),
                                        Switch(
                                            activeColor: Colors.white,
                                            activeTrackColor: Colors.green,
                                            splashRadius: 0.0,
                                            value: googleSwitch,
                                            onChanged: (value) async {
                                              if (googleSwitch == false) {
                                                UserCredential? user = await authFunctionsMain.signInWithGoogle();
                                                var userEmail = user!.user!.email != null ? user.user!.email : '';
                                                var userSocialId = user.user!.uid;
                                                var type = user.additionalUserInfo!.providerId;
                                                var phoneCodes = '';
                                                var phoneNumbers = user.user!.phoneNumber ?? "";
                                                var socialPic = user.user!.photoURL ?? '';

                                                socialLoginGoogle(userEmail, userSocialId, type, phoneCodes, phoneNumbers, socialPic);
                                              } else {
                                                Flushbar(
                                                  message: "Already Registered",
                                                  duration: const Duration(seconds: 2),
                                                ).show(context);
                                                setState(() {
                                                  googleSwitch = true;
                                                });
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height / 67.66,
                                  ),
                                  if (Platform.isIOS)
                                    SizedBox(
                                      height: height / 20.3,
                                      width: width,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 15.0),
                                                child: SvgPicture.asset(
                                                  "lib/Constants/Assets/SMLogos/Logos/apple.svg",
                                                  height: height / 33.83,
                                                  width: width / 15.625,
                                                ),
                                              ),
                                              Text(
                                                'Apple',
                                                style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: text.scale(14)),
                                              ),
                                            ],
                                          ),
                                          Switch(
                                              activeColor: Colors.white,
                                              activeTrackColor: Colors.green,
                                              value: appleSwitch,
                                              onChanged: (value) async {
                                                if (appleSwitch == false) {
                                                  UserCredential? user = await authFunctionsMain.signInApples();
                                                  var userEmail = user!.user!.providerData[0].email != null
                                                      ? (user.user!.providerData[0].email!.contains(".appleid.")
                                                          ? null
                                                          : user.user!.providerData[0].email)
                                                      : user.user!.email != null
                                                          ? (user.user!.email!.contains(".appleid.") ? null : user.user!.email)
                                                          : null;
                                                  var userSocialId = user.user!.uid;
                                                  var type = user.additionalUserInfo!.providerId;
                                                  var phoneCodes = '';
                                                  var phoneNumbers = user.user!.phoneNumber ?? user.user!.providerData[0].phoneNumber;
                                                  var socialPic = user.user!.photoURL ?? user.user!.providerData[0].photoURL;

                                                  socialLoginFb(userEmail, userSocialId, type, phoneCodes, phoneNumbers, socialPic);
                                                } else {
                                                  Flushbar(
                                                    message: "Already Registered",
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                  setState(() {
                                                    appleSwitch = true;
                                                  });
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  if (Platform.isIOS)
                                    const SizedBox(
                                      height: 12,
                                    ),
                                  SizedBox(
                                    height: height / 20.3,
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 15.0),
                                              child: SvgPicture.asset(
                                                "lib/Constants/Assets/SMLogos/Logos/facebook.svg",
                                                height: height / 33.83,
                                                width: width / 15.625,
                                              ),
                                            ),
                                            Text(
                                              'Facebook',
                                              style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w700, fontSize: text.scale(14)),
                                            ),
                                          ],
                                        ),
                                        Switch(
                                            activeColor: Colors.white,
                                            activeTrackColor: Colors.green,
                                            value: facebookSwitch,
                                            onChanged: (value) async {
                                              if (facebookSwitch == false) {
                                                UserCredential? user = await authFunctionsMain.signInWithFacebook();
                                                var userEmail = user!.user!.email != null ? user.user!.email : '';
                                                var userSocialId = user.user!.uid;
                                                var type = user.additionalUserInfo!.providerId;
                                                var phoneCodes = '';
                                                var phoneNumbers = user.user!.phoneNumber ?? "";
                                                var socialPic = user.user!.photoURL ?? '';

                                                socialLoginFb(userEmail, userSocialId, type, phoneCodes, phoneNumbers, socialPic);
                                              } else {
                                                Flushbar(
                                                  message: "Already Registered",
                                                  duration: const Duration(seconds: 2),
                                                ).show(context);
                                                setState(() {
                                                  facebookSwitch = true;
                                                });
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  /*SizedBox(
                              height: _height / 20.3,
                              width: _width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15.0),
                                        child: SvgPicture.asset(
                                          "lib/Constants/Assets/SMLogos/Logos/twitter.svg",
                                          height: _height / 33.83,
                                          width: _width / 15.625,
                                        ),
                                      ),
                                      Text(
                                        'Twitter',
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w700,
                                            fontSize: _text * 14),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                      activeColor: Colors.white,
                                      activeTrackColor: Colors.green,
                                      value: twitterSwitch,
                                      onChanged: (value) async {
                                        if (twitterSwitch == false) {
                                          UserCredential? user =
                                              await authFunctionsMain
                                                  .signInWithTwitter();
                                          var useremail = user!.user!.email != null
                                              ? user.user!.email
                                              : '';
                                          var usersocialId = user.user!.uid;
                                          var type =
                                              user.additionalUserInfo!.providerId;
                                          var phonecodes = '';
                                          var phoneNumbers =
                                              user.user!.phoneNumber != null
                                                  ? user.user!.phoneNumber
                                                  : "";
                                          var socialPic =
                                              user.user!.photoURL != null
                                                  ? user.user!.photoURL
                                                  : '';

                                          socialLoginTwitter(
                                              useremail,
                                              usersocialId,
                                              type,
                                              phonecodes,
                                              phoneNumbers,
                                              socialPic);
                                        } else {
                                          Flushbar(
                                            message: "Already Registered",
                                            duration: Duration(seconds: 2),
                                          )..show(context);
                                          setState(() {
                                            twitterSwitch = true;
                                          });
                                        }
                                      }),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: _height / 31.23,
                            ),*/
                                  loading
                                      ? Center(
                                          child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                                        )
                                      : customError
                                          ? GestureDetector(
                                              onTap: () {
                                                Flushbar(
                                                  message: "Please check all fields",
                                                  duration: const Duration(seconds: 2),
                                                ).show(context);
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
                                                    "Save",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: text.scale(16),
                                                        fontFamily: "Poppins"),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : usernameCustomError
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Flushbar(
                                                      message: "Please check all fields",
                                                      duration: const Duration(seconds: 2),
                                                    ).show(context);
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
                                                        "Save",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: text.scale(16),
                                                            fontFamily: "Poppins"),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : passWordValid == false
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        Flushbar(
                                                          message: "Please check all fields",
                                                          duration: const Duration(seconds: 2),
                                                        ).show(context);
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
                                                            "Save",
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: text.scale(16),
                                                                fontFamily: "Poppins"),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : phoneError
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            Flushbar(
                                                              message: "Please check all fields",
                                                              duration: const Duration(seconds: 2),
                                                            ).show(context);
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
                                                                "Save",
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: text.scale(16),
                                                                    fontFamily: "Poppins"),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : firstNameEmpty == true
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Flushbar(
                                                                  message: "Please check all fields",
                                                                  duration: const Duration(seconds: 2),
                                                                ).show(context);
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
                                                                    "Save",
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.w700,
                                                                        fontSize: text.scale(16),
                                                                        fontFamily: "Poppins"),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : lastNameEmpty == true
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    Flushbar(
                                                                      message: "Please check all fields",
                                                                      duration: const Duration(seconds: 2),
                                                                    ).show(context);
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
                                                                        "Save",
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: text.scale(16),
                                                                            fontFamily: "Poppins"),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: () async {
                                                                    setState(() {
                                                                      loading = true;
                                                                      popUpLoading = false;
                                                                    });
                                                                    if (image == null && coverImage == null) {
                                                                      updateProfile(
                                                                          first: _fnController.text,
                                                                          last: _lnController.text,
                                                                          userName1: _unController.text,
                                                                          phoneCode: dialCode == "" ? phoneCode : dialCode,
                                                                          countryCode: countryCode == "" ? countryCode1 : countryCode,
                                                                          phone: _phoneController.text);
                                                                    } else {
                                                                      updateProfile1(
                                                                          first: _fnController.text,
                                                                          last: _lnController.text,
                                                                          userName1: _unController.text,
                                                                          phoneCode: dialCode == "" ? phoneCode : dialCode,
                                                                          countryCode: countryCode == "" ? countryCode1 : countryCode,
                                                                          phone: _phoneController.text,
                                                                          filePath: image == null ? "" : image!.path);
                                                                    }
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
                                                                        "Save",
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: text.scale(16),
                                                                            fontFamily: "Poppins"),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                  SizedBox(
                                    height: height / 50.75,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                  ),
          ),
        ),
      ),
    );
  }

  showBottomSheet({required BuildContext context, required bool avatarEnabled, required bool coverEnabled, required String forWhat}) {
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
                          if (avatarEnabled) {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            logEventFunc(name: 'Profile_Image_Removed', type: 'Edit Profile');
                            removeAvatar(type: "avatar");
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
                                : avatarEnabled
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Colors.grey),
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
                          if (coverEnabled) {
                            if (!mounted) {
                              return;
                            }
                            Navigator.pop(context);
                            logEventFunc(name: 'Cover_Image_Removed', type: 'Edit Profile');
                            removeAvatar(type: "cover");
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
                                : coverEnabled
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Colors.grey),
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
                              int index = profile.response.defaultAvatarsList.indexOf(avatar);
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
                                      avatar = profile.response.defaultAvatarsList[index];
                                      avatarSelectedIndex = index;
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(profile.response.defaultAvatarsList[index]),
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
                                      avatar = profile.response.defaultAvatarsList[index + 5];
                                      avatarSelectedIndex = index + 5;
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(profile.response.defaultAvatarsList[index + 5]),
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
          if (profile.response.coverChanged || coverImage != null) {
            setState(() {
              usedData--;
              linearValue = usedData / totalData;
            });
          }
          coverImage = File(croppedFile.path);
          setState(() {
            usedData++;
            linearValue = usedData / totalData;
          });
        } else {
          if (profile.response.avatarChanged || image != null) {
            setState(() {
              usedData--;
              linearValue = usedData / totalData;
            });
          }
          image = File(croppedFile.path);
          setState(() {
            usedData++;
            linearValue = usedData / totalData;
          });
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
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter modelSetState) {
              return SingleChildScrollView(
                child: customisedAbout
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
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
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              style: TextStyle(
                                fontSize: text.scale(15),
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 18,
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
                            const SizedBox(
                              height: 15,
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
                        ),
                      )
                    : SizedBox(
                        height: 300,
                        child: Column(
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
                              fontSize: _text * 14,
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
                              fontSize: _text * 14,
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
                              fontSize: _text * 14,
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
                        ),
                      ),
              );
            },
          );
        });
  }
}
