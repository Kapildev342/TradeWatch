import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/Api.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

import 'edit_profile_page.dart';

class EditCodeVerify extends StatefulWidget {
  const EditCodeVerify({
    Key? key,
    //required this.receivedOTP,
    required this.dialCode,
    required this.phone,
    required this.first,
    required this.last,
    required this.userName1,
    required this.email,
    required this.countryCode,
    required this.referralCode,
    required this.filePath,
    required this.verifyId,
    required this.completePhone,
  }) : super(key: key);

  //final String receivedOTP;
  final String dialCode;
  final String phone;
  final String first;
  final String last;
  final String userName1;
  final String email;
  final String countryCode;
  final String referralCode;
  final String filePath;
  final String verifyId;
  final String completePhone;

  @override
  State<EditCodeVerify> createState() => _EditCodeVerifyState();
}

class _EditCodeVerifyState extends State<EditCodeVerify> {
  final TextEditingController _otpController = TextEditingController();

  bool loading = false;
  bool requestLoading = false;

  //String reqOTp="";
  //late int regeneratedOTP;
  String regId = "";
  String regToken = "";
  String regLocker = "";
  String mainUserToken = "";
  String mainUserId = "";
  File? image;
  dynamic res1;
  String verifyId = "";

  @override
  void initState() {
    getAllDataMain(name: 'Code_Verification_From_Edit_Profile');
    //reqOTp=widget.receivedOTP;
    setState(() {
      requestLoading = true;
    });
    Future.delayed(const Duration(seconds: 30), () {
      setState(() {
        requestLoading = false;
      });
    });
    verifyId = widget.verifyId;
    image = File(widget.filePath);
    super.initState();
  }

  verify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    mainUserId = prefs.getString('newUserId')!;
    bool response = await phoneNumberVerify();
    if (_otpController.text.isEmpty) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: "please enter OTP",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else if (response == false) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: "OTP not matched,please Enter valid OTP",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else {
      var uri = Uri.parse(baseurl + versions + update);
      var response = await http.post(uri, body: {
        "first_name": widget.first,
        "last_name": widget.last,
        "username": widget.userName1,
        "email": widget.email,
        "phone_code": widget.dialCode == "" ? "+91" : widget.dialCode,
        "country_code": widget.countryCode == "" ? "IN" : widget.countryCode,
        "phone_number": widget.phone,
        "referral_code": widget.referralCode,
        "user_id": mainUserId,
        "mobile_verified": "true"
      }, headers: {
        "authorization": mainUserToken,
      });
      json.decode(response.body);
      if (response.statusCode == 200) {
        // var responseData = json.decode(response.body);
        if (!mounted) {
          return;
        }
        await Flushbar(
          message: "OTP verified & profile updated successfully,",
          duration: const Duration(seconds: 2),
        ).show(context);
        if (!mounted) {
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
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

        setState(() {
          loading = false;
        });
      }
    }
  }

  verify1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken')!;
    mainUserId = prefs.getString('newUserId')!;
    bool response = await phoneNumberVerify();
    if (_otpController.text.isEmpty) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: "please enter OTP",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else if (response == false) {
      if (!mounted) {
        return;
      }
      Flushbar(
        message: "OTP not matched,please Enter valid OTP",
        duration: const Duration(seconds: 2),
      ).show(context);
      setState(() {
        loading = false;
      });
    } else {
      res1 = await functionsMain.sendForm(baseurl + versions + update, {
        'first_name': widget.first,
        'last_name': widget.last,
        'username': widget.userName1,
        'email': widget.email,
        'phone_code': widget.dialCode,
        'country_code': widget.countryCode,
        'phone_number': widget.phone,
        'referral_code': widget.referralCode,
        'user_id': mainUserId,
        "mobile_verified": "true"
      }, {
        'file': image!
      });
      if (res1.data["status"]) {
        if (!mounted) {
          return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
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

  Future<bool> phoneNumberVerify() async {
    try {
      await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: _otpController.text,
      ));
      return true;
    } catch (e) {
      return false;
    }
  }

  phoneVerify() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.completePhone,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {}
      },
      codeSent: (String verificationId, int? resendToken) async {
        verifyId = verificationId;
      },
      timeout: const Duration(seconds: 25),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    super.dispose();
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage(comeFrom: true)));
          return false;
        },
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage(comeFrom: true)));
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(vertical: height / 57.73, horizontal: width / 27.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Verification Code",
                  style: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                ),
                SizedBox(height: height / 34.64),
                const Text("Please enter verification code sent to your mobile",
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400, fontFamily: "Poppins")),
                SizedBox(height: height / 28.48),
                Text(
                  "Code is sent to ${"${widget.dialCode} ${widget.phone}"}",
                  style: TextStyle(fontSize: text.scale(16), color: const Color(0XFFA5A5A5), fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height / 35.6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "lib/Constants/Assets/SMLogos/verificationPageImage.svg",
                              height: height / 2.85,
                            ),
                          ],
                        ),
                        SizedBox(height: height / 23.73),
                      ],
                    ),
                  ),
                ),
                PinCodeTextField(
                  length: 6,
                  appContext: context,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  onChanged: (code) {
                    _otpController.text;
                  },
                  pinTheme: PinTheme(
                    inactiveColor: Colors.grey,
                    activeColor: Colors.grey,
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10.0),
                    fieldHeight: height / 20.73,
                    fieldWidth: width / 9.25,
                    activeFillColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: height / 81.2,
                ),
                loading
                    ? Center(
                        child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                      )
                    : GestureDetector(
                        onTap: () {
                          widget.filePath != "" ? verify1() : verify();
                          //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return CreatePasswordPage();}));
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color(0XFF0EA102),
                          ),
                          width: width,
                          height: height / 14.24,
                          child: const Center(
                            child: Text(
                              "Verify and Update Profile",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, fontFamily: "Poppins"),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: height / 50.75,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't receive Code?",
                      style: TextStyle(color: Color(0XFFA5A5A5), fontWeight: FontWeight.normal, fontSize: 16, fontFamily: "Poppins"),
                    ),
                    requestLoading
                        ? TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Request",
                              style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                            ))
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                requestLoading = true;
                              });
                              phoneVerify();
                            },
                            child: const Text(
                              "Request",
                              style: TextStyle(fontSize: 16, color: Color(0XFF0EA102), fontWeight: FontWeight.w600, fontFamily: "Poppins"),
                            ))
                  ],
                ),
                SizedBox(
                  height: height / 50.75,
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
