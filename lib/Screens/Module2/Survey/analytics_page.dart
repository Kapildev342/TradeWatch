import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:river_player/river_player.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tradewatchfinal/Constants/API/api.dart';
import 'package:tradewatchfinal/Screens/Module1/Settings/Theme/theme_page.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module2/Survey/survey_page.dart';
import 'package:tradewatchfinal/Screens/Module3/BookMarks/BookMarkWidget/SingleOne/book_mark_single_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/ForSurvey/translation_survey_bloc.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final int? y;
}

class AnalyticsPage extends StatefulWidget {
  final String surveyId;
  final String surveyTitle;
  final bool activity;
  final bool? navBool;
  final String? fromWhere;

  const AnalyticsPage({Key? key, required this.surveyId, required this.surveyTitle, required this.activity, this.navBool = false, this.fromWhere})
      : super(key: key);

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final GlobalKey previewContainer = GlobalKey();
  final GlobalKey previewContainer1 = GlobalKey();
  final GlobalKey newKey0 = GlobalKey();
  final GlobalKey newKey1 = GlobalKey();
  final GlobalKey newKey2 = GlobalKey();
  final GlobalKey newKey3 = GlobalKey();
  final GlobalKey newKey4 = GlobalKey();
  final GlobalKey newKey5 = GlobalKey();
  final GlobalKey newKey6 = GlobalKey();
  final GlobalKey newKey7 = GlobalKey();
  final GlobalKey newKey8 = GlobalKey();
  final GlobalKey newKey9 = GlobalKey();
  List<GlobalKey> keyList = <GlobalKey>[];
  List<GlobalKey> keyList1 = <GlobalKey>[];
  List<ChartData> chartData = [];
  bool val = false;
  int pageIndex = 0;
  int selectedIndex = 0;
  List<bool> tick1 = List.generate(5, (index) => false);
  List<bool> tick2 = List.generate(5, (index) => false);
  List<bool> tick3 = List.generate(5, (index) => false);
  List<bool> tick4 = List.generate(5, (index) => false);
  List<bool> tick5 = List.generate(5, (index) => false);
  String mainUserId = "";
  String mainUserToken = "";
  String category = "";
  String companyName = "";
  int totalQuestions = 0;
  int totalViews = 0;
  int totalAnswers = 0;
  String activeTime = "";
  String surveyTitle = "";
  String startTime = "";
  String endTime = "";
  List<String> urlTypeList = [];
  List<String> urlList = [];
  List<String> networkUrls = [];
  List<BetterPlayerController> betterPlayerList = [];
  List<bool> playerConditions = [];
  List<String> playerVideoId = [];
  List<String> answerTypeList = [];
  List<String> optionalTypeList = [];
  List<String> questionList = [];
  List<String> answerList1 = [];
  List<String> answerList2 = [];
  List<String> answerList3 = [];
  List<String> answerList4 = [];
  List<String> answerList5 = [];
  List<int> answerCount1 = [];
  List<int> answerViewCount = [];
  List<int> answerCount2 = [];
  List<int> answerCount3 = [];
  List<int> answerCount4 = [];
  List<int> answerCount5 = [];
  List<int> answerTotalCount = [];
  List<bool> answer1List = [];
  List<bool> answer2List = [];
  List<bool> answer3List = [];
  List<bool> answer4List = [];
  List<bool> answer5List = [];
  bool loading = false;
  bool bookMark = false;
  Map<String, dynamic> data = {};
  String surveyId = "";
  String surveyUser = "";
  int surveyStatus = 1;
  late Uri newLink;
  List<String> questionIdList = [];
  ScreenshotController screenshotController = ScreenshotController();
  List<Color> gradientColors = [
    const Color(0XFFFFFFFF),
    const Color(0XFF0EA102).withOpacity(0),
  ];
  bool showAvg = false;
  List<RenderRepaintBoundary?> boundaryList = [];
  List<ui.Image> imageList = [];
  List<ByteData?> byteDataList = [];
  List<Uint8List?> pngBytesList = [];
  List<File> imgFileList = [];
  List<dynamic> pdfImageList = [];
  List<String> surveyViewedImagesList = [];
  List<String> surveyViewedIdList = [];
  List<String> surveyViewedSourceNameList = [];
  BannerAd? _bannerAd;
  bool _bannerAdIsLoaded = false;

  @override
  void initState() {
    context.read<BookMarkSingleWidgetBloc>().add(const BookLoadingEvent());
    context.read<TranslationSurveyBloc>().add(const LoadingTranslationSurveyEvent());
    getAllDataMain(name: 'Survey_Analytics_Page');
    getAllData();
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adVariables.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('$BannerAd loaded.');
            setState(() {
              _bannerAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            debugPrint('$BannerAd failedToLoad: $error');
            ad.dispose();
          },
          onAdOpened: (Ad ad) => debugPrint('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => debugPrint('$BannerAd onAdClosed.'),
        ),
        request: const AdRequest())
      ..load();
  }

  @override
  void dispose() {
    _bannerAd!.dispose();
    context.read<BookMarkSingleWidgetBloc>().add(const BookLoadingEvent());
    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  shareCountFunc({required String id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + shareCount);
    await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'survey_id': id,
    });
  }

  Future<bool> shareFunction({required String id, required String type}) async {
    var uri = Uri.parse(baseurl + versionLocker + share);
    var response = await http.post(uri, headers: {
      "authorization": mainUserToken,
    }, body: {
      "id": id,
      "type": type
    });
    var responseData = jsonDecode(response.body);
    if (responseData['status'] == true) {
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: responseData['message'],
        duration: const Duration(seconds: 2),
      ).show(context);
    }
    return responseData['status'];
  }

  Future<Uri> getLinK(
      {required String id, required String type, required String imageUrl, required String title, required String description}) async {
    final dynamicLinkParams = DynamicLinkParameters(
        uriPrefix: domainLink,
        link: Uri.parse('$domainLink/AnalyticsPage/$id/$type/$title'),
        androidParameters: const AndroidParameters(packageName: "com.tradewatch.tradewatch"),
        iosParameters: const IOSParameters(bundleId: "com.tradewatch.tradewatch", appStoreId: "1625656597"),
        socialMetaTagParameters: SocialMetaTagParameters(title: title, description: '', imageUrl: Uri.parse(imageUrl)));
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams, shortLinkType: ShortDynamicLinkType.short);
    return dynamicLink.shortUrl;
  }

  getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + surveyDetails);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'survey_id': widget.surveyId,
    });
    var responseData = json.decode(response.body);
    if (responseData["status"]) {
      watchVariables.postCountTotalMain.value = responseData["post_view_counts"];
      if (watchVariables.postCountTotalMain.value % 5 == 0) {
        debugPrint(" ad Started");
        functionsMain.createInterstitialAd(modelSetState: setState);
      }
      keyList.add(newKey0);
      keyList.add(newKey1);
      keyList.add(newKey2);
      keyList.add(newKey3);
      keyList.add(newKey4);
      keyList.add(newKey5);
      keyList.add(newKey6);
      keyList.add(newKey7);
      keyList.add(newKey8);
      keyList.add(newKey9);
      if (responseData["response"].length == 0) {
      } else {
        answerTypeList.clear();
        optionalTypeList.clear();
        questionIdList.clear();
        questionList.clear();
        answerCount1.clear();
        answerCount2.clear();
        answerCount3.clear();
        answerCount4.clear();
        answerCount5.clear();
        answerTotalCount.clear();
        answer1List.clear();
        answer2List.clear();
        answer3List.clear();
        answer4List.clear();
        answer5List.clear();
        keyList1.clear();
        answerViewCount.clear();
        totalQuestions = responseData["response"]["questions"].length;
        totalViews = responseData["response"]["views_count"];
        surveyTitle = responseData["response"]["title"];
        bookMark = responseData["response"]["bookmark"] ?? false;
        totalAnswers = responseData["response"]["answers_count"];
        surveyId = responseData["response"]["_id"];
        surveyUser = responseData["response"]["user_id"];
        category = responseData["response"]["category"];
        activeTime = responseData["response"]["active_until"];
        startTime = responseData["response"]["start_date"];
        endTime = responseData["response"]["end_date"];
        companyName = responseData["response"]["company_name"];
        surveyStatus = responseData["response"]["status"];
        for (int i = 0; i < responseData["response"]["questions"].length; i++) {
          keyList1.add(keyList[i]);
          answerTypeList.add(responseData["response"]["questions"][i]["answer_type"]);
          optionalTypeList.add(responseData["response"]["questions"][i]["optional_type"]);
          questionIdList.add(responseData["response"]["questions"][i]["_id"]);
          questionList.add(responseData["response"]["questions"][i]["title"]);
          answerViewCount.add(responseData["response"]["questions"][i]["views_count"]);
          answerCount1.add(responseData["response"]["questions"][i]["answer1_count"]);
          answerCount2.add(responseData["response"]["questions"][i]["answer2_count"]);
          answerCount3.add(responseData["response"]["questions"][i]["answer3_count"]);
          answerCount4.add(responseData["response"]["questions"][i]["answer4_count"]);
          answerCount5.add(responseData["response"]["questions"][i]["answer5_count"]);
          answerTotalCount.add((responseData["response"]["questions"][i]["answer1_count"]) +
              (responseData["response"]["questions"][i]["answer2_count"]) +
              (responseData["response"]["questions"][i]["answer3_count"]) +
              (responseData["response"]["questions"][i]["answer4_count"]) +
              (responseData["response"]["questions"][i]["answer5_count"]));
          if (responseData["response"]["questions"][i].containsKey("url_type")) {
            urlTypeList.add(responseData["response"]["questions"][i]["url_type"]);
            urlList.add(responseData["response"]["questions"][i]["url"]);
            if (responseData["response"]["questions"][i]["url_type"] == 'video') {
              networkUrls.add(responseData["response"]["questions"][i]["url"]);
              playerConditions.add(false);
              playerVideoId.add(responseData["response"]["questions"][i]["_id"]);
            } else {
              networkUrls.add("a");
              playerConditions.add(false);
              playerVideoId.add(responseData["response"]["questions"][i]["_id"]);
            }
          } else {
            urlTypeList.add("");
            urlList.add("");
          }
          if (responseData["response"]["questions"][i].containsKey('answer1')) {
            answer1List.add(true);
            answerList1.add(responseData["response"]["questions"][i]["answer1"]);
          } else {
            answer1List.add(false);
            answerList1.add("");
          }
          if (responseData["response"]["questions"][i].containsKey('answer2')) {
            answer2List.add(true);
            answerList2.add(responseData["response"]["questions"][i]["answer2"]);
          } else {
            answer2List.add(false);
            answerList2.add("");
          }
          if (responseData["response"]["questions"][i].containsKey('answer3')) {
            answer3List.add(true);
            answerList3.add(responseData["response"]["questions"][i]["answer3"]);
          } else {
            answer3List.add(false);
            answerList3.add("");
          }
          if (responseData["response"]["questions"][i].containsKey('answer4')) {
            answer4List.add(true);
            answerList4.add(responseData["response"]["questions"][i]["answer4"]);
          } else {
            answer4List.add(false);
            answerList4.add("");
          }
          if (responseData["response"]["questions"][i].containsKey('answer5')) {
            answer5List.add(true);
            answerList5.add(responseData["response"]["questions"][i]["answer5"]);
          } else {
            answer5List.add(false);
            answerList5.add("");
          }
        }
        await getChartData();
        for (var element in networkUrls) {
          betterPlayerList.add(
            BetterPlayer.network(
              element,
              betterPlayerConfiguration: const BetterPlayerConfiguration(
                aspectRatio: 16 / 9,
                fit: BoxFit.contain,
                autoDispose: false,
                controlsConfiguration: BetterPlayerControlsConfiguration(
                  enablePip: false,
                  enableOverflowMenu: false,
                  enablePlayPause: false,
                  enableAudioTracks: false,
                  enableMute: false,
                  enableSkips: false,
                  enableProgressText: false,
                ),
              ),
            ).controller,
          );
        }
        setState(() {
          loading = true;
        });
      }
    }
  }

  getChartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + analytics);
    var nowTime = DateTime.now();
    var newTime = nowTime.subtract(const Duration(minutes: 270));
    var dateFormatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm'Z'").format(newTime);
    var response = await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'survey_id': widget.surveyId,
      'active_until': activeTime,
      'start_date': startTime,
      'end_date': surveyStatus == 1 ? dateFormatted : endTime,
    });
    var responseData1 = json.decode(response.body);
    if (responseData1["status"]) {
      if (responseData1["response"].length == 0) {
        chartData.add(ChartData("0", 0));
      } else {
        chartData.clear();
        for (int i = 0; i < responseData1["response"].length; i++) {
          chartData.add(
            ChartData(
              activeTime == "1 day"
                  ? "${responseData1["response"][i]["hours"].toString()}.00"
                  : activeTime == "1 Week"
                      ? responseData1["response"][i]["day"].toString().substring(0, 10)
                      : activeTime == "1 Month"
                          ? responseData1["response"][i]["day"].toString().substring(0, 10)
                          : activeTime == "6 Months"
                              ? responseData1["response"][i]["month"].toString().substring(5, 7) == "01"
                                  ? "Jan"
                                  : responseData1["response"][i]["month"].toString().substring(5, 7) == "02"
                                      ? "Feb"
                                      : responseData1["response"][i]["month"].toString().substring(5, 7) == "03"
                                          ? "Mar"
                                          : responseData1["response"][i]["month"].toString().substring(5, 7) == "04"
                                              ? "Apr"
                                              : responseData1["response"][i]["month"].toString().substring(5, 7) == "05"
                                                  ? "May"
                                                  : responseData1["response"][i]["month"].toString().substring(5, 7) == "06"
                                                      ? "Jun"
                                                      : responseData1["response"][i]["month"].toString().substring(5, 7) == "07"
                                                          ? "Jul"
                                                          : responseData1["response"][i]["month"].toString().substring(5, 7) == "08"
                                                              ? "Aug"
                                                              : responseData1["response"][i]["month"].toString().substring(5, 7) == "09"
                                                                  ? "Sep"
                                                                  : responseData1["response"][i]["month"].toString().substring(5, 7) == "10"
                                                                      ? "Oct"
                                                                      : responseData1["response"][i]["month"].toString().substring(5, 7) == "11"
                                                                          ? "Nov"
                                                                          : responseData1["response"][i]["month"].toString().substring(5, 7) == "12"
                                                                              ? "Dec"
                                                                              : "Jan"
                              : "1",
              responseData1["response"][i]["count"],
            ),
          );
        }
      }
    }
  }

  @pragma('vm:entry-point')
  //static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  downloadFile({required String id}) async {
    Directory? documents = await getApplicationDocumentsDirectory();
    String tempPath = documents.path;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserId = prefs.getString('newUserId') ?? "";
    mainUserToken = prefs.getString('newUserToken') ?? "";
    Response response = await dioMain.post(
      baseurl + versionSurvey + excelDownload,
      data: {
        "survey_id": id,
      },
      options: Options(
        headers: {"authorization": mainUserToken},
      ),
    );
    if (response.data["status"]) {
      await FlutterDownloader.enqueue(
        url: response.data["response"],
        savedDir: Platform.isIOS ? tempPath : "/storage/emulated/0/Download/",
        fileName: "${surveyTitle}_Tradewatch_${DateTime.now().toString().substring(0, 10)}.csv",
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "Check the download progress in notifications",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "File Not Available",
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  createPDF() async {
    final directory1 = (await getTemporaryDirectory()).path;
    boundaryList.clear();
    imageList.clear();
    byteDataList.clear();
    pngBytesList.clear();
    imgFileList.clear();
    pdfImageList.clear();
    for (int i = 0; i < totalQuestions; i++) {
      if (!mounted) {
        return false;
      }
      boundaryList.add(keyList1[i].currentContext!.findRenderObject() as RenderRepaintBoundary?);
      imageList.add(await boundaryList[i]!.toImage());
      byteDataList.add(await imageList[i].toByteData(format: ui.ImageByteFormat.png));
      pngBytesList.add(byteDataList[i]!.buffer.asUint8List());
      imgFileList.add(File('$directory1/screenshot$i.png'));
      imgFileList[i].writeAsBytesSync(pngBytesList[i]!, mode: FileMode.write, flush: true);
      pdfImageList.add(pw.MemoryImage(File(imgFileList[i].path).readAsBytesSync()));
    }
    if (!mounted) {
      return false;
    }
    RenderRepaintBoundary? boundary = previewContainer.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    RenderRepaintBoundary? boundary1 = previewContainer1.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    ui.Image image = await boundary!.toImage();
    ui.Image image1 = await boundary1!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    ByteData? byteData1 = await image1.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    Uint8List pngBytes1 = byteData1!.buffer.asUint8List();
    File imgFile = File('$directory1/screenshot.png');
    File imgFile1 = File('$directory1/screenshot1.png');
    imgFile.writeAsBytesSync(pngBytes, mode: FileMode.write, flush: true);
    imgFile1.writeAsBytesSync(pngBytes1, mode: FileMode.write, flush: true);
    final pdfImage = pw.MemoryImage(File(imgFile.path).readAsBytesSync());
    final pdfImage1 = pw.MemoryImage(File(imgFile1.path).readAsBytesSync());
    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
      verbose: true,
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: <pw.Widget>[
                pw.Image(pdfImage, fit: pw.BoxFit.contain),
                pw.SizedBox(height: 15),
                pw.Image(pdfImage1, fit: pw.BoxFit.contain),
                pw.SizedBox(height: 15),
                0 < totalQuestions ? pw.Image(pdfImageList[0], fit: pw.BoxFit.contain) : pw.SizedBox(),
                pw.SizedBox(height: 15),
                1 < totalQuestions ? pw.Image(pdfImageList[1], fit: pw.BoxFit.contain) : pw.SizedBox(),
                pw.SizedBox(height: 15),
                2 < totalQuestions ? pw.Image(pdfImageList[2], fit: pw.BoxFit.contain) : pw.SizedBox(),
                pw.SizedBox(height: 15),
                3 < totalQuestions ? pw.Image(pdfImageList[3], fit: pw.BoxFit.contain) : pw.SizedBox(),
                pw.SizedBox(height: 15),
                4 < totalQuestions ? pw.Image(pdfImageList[4], fit: pw.BoxFit.contain) : pw.SizedBox(),
                pw.SizedBox(height: 15),
                5 < totalQuestions ? pw.Image(pdfImageList[5], fit: pw.BoxFit.contain) : pw.SizedBox(),
                pw.SizedBox(height: 15),
                6 < totalQuestions ? pw.Image(pdfImageList[6], fit: pw.BoxFit.contain) : pw.SizedBox(),
                pw.SizedBox(height: 15),
                7 < totalQuestions ? pw.Image(pdfImageList[7], fit: pw.BoxFit.contain) : pw.SizedBox(),
                pw.SizedBox(height: 15),
                8 < totalQuestions ? pw.Image(pdfImageList[8], fit: pw.BoxFit.contain) : pw.SizedBox(),
                pw.SizedBox(height: 15),
                9 < totalQuestions ? pw.Image(pdfImageList[9], fit: pw.BoxFit.contain) : pw.SizedBox(),
              ],
            ),
          ];
        },
      ),
    );
    if (Platform.isIOS) {
      Directory? documents = await getApplicationDocumentsDirectory();
      String tempPath = documents.path;
      var filePath = '$tempPath/${surveyTitle}_Tradewatch_${DateTime.now().toString().substring(0, 10)}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "Survey PDF is now available within the download manager",
        duration: const Duration(seconds: 2),
      ).show(context);
    } else {
      final file = File("/storage/emulated/0/Download/${surveyTitle}_Tradewatch_${DateTime.now().toString().substring(0, 10)}.pdf");
      await file.writeAsBytes(await pdf.save());
      if (!mounted) {
        return false;
      }
      Flushbar(
        message: "Survey PDF is now available within the download manager",
        duration: const Duration(seconds: 2),
      ).show(context);
    }
  }

  Future _getStoragePermission({required bool type}) async {
    PermissionStatus storagePermission = await Permission.storage.request();
    if (storagePermission == PermissionStatus.denied) {
      await Permission.storage.request();
    } else {
      type ? await createPDF() : await downloadFile(id: widget.surveyId);
    }
  }

  getActivityApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionSurvey + downLoadActivity);
    await http.post(url, headers: {
      'Authorization': mainUserToken
    }, body: {
      'survey_id': widget.surveyId,
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return WillPopScope(
      onWillPop: () async {
        if (widget.activity) {
          /* if (!mounted) {
            return false;
          }*/
          Navigator.pop(context);
        } else {
          if (widget.navBool == true) {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return const MainBottomNavigationPage(
                tType: true,
                caseNo1: 0,
                text: "",
                excIndex: 1,
                newIndex: 0,
                countryIndex: 0,
                isHomeFirstTym: false,
              );
            }));
          } else {
            if (widget.fromWhere == "finalCharts") {
              // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
              SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
              /*if (!mounted) {
                return false;
              }*/
              Navigator.pop(context);
            } else if (widget.fromWhere == 'similar') {
              Navigator.pop(context, true);
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return SurveyPage(
                  text: category == 'stocks'
                      ? "Stocks"
                      : category == 'crypto'
                          ? "Crypto"
                          : category == 'commodity'
                              ? "Commodity"
                              : category == 'forex'
                                  ? "Forex"
                                  : "",
                );
              }));
            }
          }
        }
        return false;
      },
      child: Container(
        color: Theme.of(context).colorScheme.background /*const Color(0XFFFFFFFF)*/,
        child: SafeArea(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overflow) {
              overflow.disallowIndicator();
              return true;
            },
            child: Scaffold(
              body: loading
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: height,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                RepaintBoundary(
                                  key: previewContainer,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: height / 2.75,
                                        decoration: isDarkTheme.value
                                            ? BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                                color: Theme.of(context).colorScheme.tertiary)
                                            : BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                                gradient: LinearGradient(
                                                  colors: [const Color(0XFF0EA102).withOpacity(0.46), const Color(0XFF0EA102).withOpacity(0.76)],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                ),
                                              ),
                                      ),
                                      // SizedBox(height: _height/11.94,),
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: height / 40.6, horizontal: width / 18.75),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: height / 50.75,
                                              ),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        if (widget.activity) {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                        } else {
                                                          if (widget.navBool == true) {
                                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                              return const MainBottomNavigationPage(
                                                                tType: true,
                                                                caseNo1: 0,
                                                                text: "",
                                                                excIndex: 1,
                                                                newIndex: 0,
                                                                countryIndex: 0,
                                                                isHomeFirstTym: false,
                                                              );
                                                            }));
                                                          } else {
                                                            if (widget.fromWhere == "finalCharts") {
                                                              //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                                                              SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Navigator.pop(context);
                                                            } else if (widget.fromWhere == 'similar') {
                                                              Navigator.pop(context, true);
                                                            } else {
                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return SurveyPage(
                                                                  text: category == 'stocks'
                                                                      ? "Stocks"
                                                                      : category == 'crypto'
                                                                          ? "Crypto"
                                                                          : category == 'commodity'
                                                                              ? "Commodity"
                                                                              : category == 'forex'
                                                                                  ? "Forex"
                                                                                  : "",
                                                                );
                                                              }));
                                                            }
                                                          }
                                                        }
                                                        /*widget.activity?
                                                        Navigator.pop(context):
                                                        widget.navBool==true? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                                                          return MainBottomNavigationPage(tType: true,caseNo1: 0, text: "", excIndex: 1, newIndex:0, countryIndex: 0,isHomeFirstTym:false,);
                                                        })):
                                                        Navigator.push(
                                                            context, MaterialPageRoute(
                                                            builder: (BuildContext context) {
                                                              return SurveyPage(
                                                              text: category=='stocks'?"Stocks":
                                                              category=='crypto'?"Crypto":
                                                              category=='commodity'?"Commodity":
                                                              category=='forex'?"Forex":"",
                                                              );
                                                        }));*/
                                                      },
                                                      child: Icon(
                                                        Icons.arrow_back,
                                                        color: isDarkTheme.value
                                                            ? Theme.of(context).colorScheme.onPrimary
                                                            : Theme.of(context).colorScheme.background, /*Color(0XFFFFFFFF)*/
                                                      )),
                                                  Text(
                                                    "Survey Analytics",
                                                    style: TextStyle(
                                                      fontSize: text.scale(20),
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: "Poppins",
                                                      color: isDarkTheme.value
                                                          ? Theme.of(context).colorScheme.onPrimary
                                                          : Theme.of(context).colorScheme.background, /*const Color(0XFFFFFFFF)*/
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: height / 33.83),
                                              Container(
                                                height: height / 3.09,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: Theme.of(context).colorScheme.background /* const Color(0XFFFFFFFF)*/,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Theme.of(context).colorScheme.tertiary,
                                                        blurRadius: 4,
                                                        spreadRadius: 0,
                                                      )
                                                    ]),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: height / 50.75,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 15.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "Active status:  ",
                                                                style: TextStyle(
                                                                    color: const Color(0xffB0B0B0),
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: text.scale(12)),
                                                              ),
                                                              Text(
                                                                surveyStatus == 1
                                                                    ? "Active"
                                                                    : surveyStatus == 2
                                                                        ? "Expired"
                                                                        : "",
                                                                style: TextStyle(
                                                                  color: surveyStatus == 1
                                                                      ? const Color(0XFF0EA102)
                                                                      : surveyStatus == 2
                                                                          ? Colors.red
                                                                          : Colors.transparent,
                                                                  fontSize: text.scale(12),
                                                                  fontWeight: FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                ),
                                                              )
                                                              /*GradientText(
                                                                surveyStatus==1?"Active":surveyStatus==2?"Expired":"",
                                                                style: TextStyle(
                                                                  // color: surveyStatus==1?Color(0XFF0EA102):surveyStatus==2?Colors.red:Colors.green,
                                                                  fontSize: _text.scale(100)12,
                                                                  fontWeight:
                                                                  FontWeight.w600,
                                                                  fontFamily: "Poppins",
                                                                ),
                                                                colors: [
                                                                  const Color(0XFF661A72)
                                                                      .withOpacity(1),
                                                                  const Color(0XFFA607EE)
                                                                      .withOpacity(1),
                                                                  const Color(0XFFAF04FF)
                                                                      .withOpacity(0.43)
                                                                ],
                                                                gradientType:
                                                                GradientType.linear,
                                                                radius: 20,
                                                                gradientDirection:
                                                                GradientDirection.ttb,
                                                              ),*/
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            widgetsMain.translationWidgetSurvey(
                                                                translation: false,
                                                                id: widget.surveyId,
                                                                type: 'survey',
                                                                index: 0,
                                                                initFunction: getAllData,
                                                                context: context,
                                                                modelSetState: setState,
                                                                notUse: false,
                                                                questionList: questionList,
                                                                answer1List: answerList1,
                                                                answer2List: answerList2,
                                                                answer3List: answerList3,
                                                                answer4List: answerList4,
                                                                answer5List: answerList5),
                                                            SizedBox(
                                                              width: width / 31.25,
                                                            ),
                                                            bookMarkWidgetSingle(
                                                                bookMark: [bookMark],
                                                                context: context,
                                                                scale: 3.2,
                                                                id: widget.surveyId,
                                                                type: 'survey',
                                                                modelSetState: setState,
                                                                index: 0),
                                                            SizedBox(
                                                              width: width / 31.25,
                                                            ),
                                                            surveyUser == mainUserId
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      showSheet();
                                                                    },
                                                                    child: Image.asset(
                                                                      "lib/Constants/Assets/SMLogos/arrow-down-circle.png",
                                                                      height: 20,
                                                                      width: 20,
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                            surveyUser == mainUserId
                                                                ? SizedBox(
                                                                    width: width / 31.25,
                                                                  )
                                                                : const SizedBox(),
                                                            GestureDetector(
                                                                onTap: () async {
                                                                  newLink = await getLinK(
                                                                      id: widget.surveyId,
                                                                      type: "survey",
                                                                      description: '',
                                                                      imageUrl: "" /*forumImagesList[index]*/,
                                                                      title: surveyTitle);
                                                                  ShareResult result = await Share.share(
                                                                    "Look what I was able to find on Tradewatch: $surveyTitle ${newLink.toString()}",
                                                                  );
                                                                  if (result.status == ShareResultStatus.success) {
                                                                    await shareFunction(id: widget.surveyId, type: "survey");
                                                                  }
                                                                  shareCountFunc(
                                                                    id: widget.surveyId,
                                                                  );
                                                                },
                                                                child: Image.asset(
                                                                  "lib/Constants/Assets/SMLogos/share-2.png",
                                                                  height: 20,
                                                                  width: 20,
                                                                )),
                                                            SizedBox(
                                                              width: width / 16.30,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    // SizedBox(
                                                    //          height: _height / 135.33,
                                                    //        ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 15.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Active Time:",
                                                            style: TextStyle(
                                                                fontSize: text.scale(8),
                                                                fontWeight: FontWeight.w700,
                                                                fontFamily: "Poppins",
                                                                color: const Color(0XFFA5A5A5)),
                                                          ),
                                                          SizedBox(width: width / 93.75),
                                                          /*GestureDetector(
                                                                onTap: (){},
                                                                child:Image.asset("lib/Constants/Assets/SMLogos/bitcoin-btc-logo.png",
                                                                  height:12 ,width: 12,)
                                                            ),*/
                                                          Text(
                                                            activeTime,
                                                            style: TextStyle(
                                                              color: const Color(0XFF0EA102),
                                                              fontSize: text.scale(8),
                                                              fontWeight: FontWeight.w600,
                                                              fontFamily: "Poppins",
                                                            ),
                                                          )
                                                          /*GradientText(
                                                            activeTime,
                                                            style: TextStyle(
                                                              fontSize: _text.scale(100)8,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontFamily: "Poppins",
                                                            ),
                                                            colors: [
                                                              const Color(0XFF661A72)
                                                                  .withOpacity(1),
                                                              const Color(0XFFA607EE)
                                                                  .withOpacity(1),
                                                              const Color(0XFFAF04FF)
                                                                  .withOpacity(0.43)
                                                            ],
                                                            gradientType:
                                                            GradientType.linear,
                                                            radius: 20,
                                                            gradientDirection:
                                                            GradientDirection.ttb,
                                                          ),*/
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height / 50.75,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Total Response",
                                                          style: TextStyle(
                                                              fontSize: text.scale(18),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Poppins",
                                                              color: const Color(0XFFA5A5A5)),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: height / 350.66,
                                                    ),
                                                    Text(
                                                      totalAnswers.toString(),
                                                      style: TextStyle(
                                                          fontSize: text.scale(40),
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: "Poppins",
                                                          color: const Color(0XFF0EA102).withOpacity(0.9)),
                                                    ),
                                                    SizedBox(
                                                      height: height / 94.13,
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.symmetric(horizontal: width / 7.5),
                                                        child: const Divider(thickness: 0, height: 1)),
                                                    SizedBox(
                                                      height: height / 33.83,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            GradientText(
                                                              totalQuestions.toString(),
                                                              style: TextStyle(
                                                                fontSize: text.scale(18),
                                                                fontWeight: FontWeight.w700,
                                                                fontFamily: "Poppins",
                                                              ),
                                                              colors: [
                                                                const Color(0XFF47B95C).withOpacity(1),
                                                                const Color(0XFF3DA0A7).withOpacity(1)
                                                              ],
                                                              gradientType: GradientType.linear,
                                                              radius: 20,
                                                              gradientDirection: GradientDirection.ttb,
                                                            ),
                                                            Text(
                                                              "Questions",
                                                              style: TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontFamily: "Poppins",
                                                                  color: const Color(0XFFA5A5A5)),
                                                            )
                                                          ],
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            setState(() {
                                                              viewCountMain = totalViews;
                                                              kUserSearchController.clear();
                                                              onTapType = "Views";
                                                              onTapId = widget.surveyId;
                                                              onLike = false;
                                                              onDislike = false;
                                                              onViews = true;
                                                              idKeyMain = "survey_id";
                                                              apiMain = baseurl + versionSurvey + viewsCount;
                                                              onTapIdMain = widget.surveyId;
                                                              onTapTypeMain = "Views";
                                                              haveViewsMain = totalViews > 0 ? true : false;
                                                              viewCountMain = totalViews;
                                                              kToken = mainUserToken;
                                                            });
                                                            //bool data= await viewsCountFunc(context: context, mainToken: mainUserToken, api: baseurl + versionSurvey + viewsCount, idKey: 'survey_id', setState: setState);
                                                            bool data = await likeCountFunc(context: context, newSetState: setState);
                                                            if (data) {
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              customShowSheet1(context: context);
                                                              setState(() {
                                                                loaderMain = true;
                                                              });
                                                            } else {
                                                              if (!mounted) {
                                                                return;
                                                              }
                                                              Flushbar(
                                                                message: "Still no one has viewed this post",
                                                                duration: const Duration(seconds: 2),
                                                              ).show(context);
                                                            }
                                                          },
                                                          child: Column(
                                                            children: [
                                                              GradientText(
                                                                totalViews.toString(),
                                                                style: TextStyle(
                                                                  fontSize: text.scale(18),
                                                                  fontWeight: FontWeight.w700,
                                                                  fontFamily: "Poppins",
                                                                ),
                                                                colors: [
                                                                  const Color(0XFF47B95C).withOpacity(1),
                                                                  const Color(0XFF3DA0A7).withOpacity(1)
                                                                ],
                                                                gradientType: GradientType.linear,
                                                                radius: 20,
                                                                gradientDirection: GradientDirection.ttb,
                                                              ),
                                                              Text(
                                                                "Total Views",
                                                                style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    fontWeight: FontWeight.w700,
                                                                    fontFamily: "Poppins",
                                                                    color: const Color(0XFFA5A5A5)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Category:",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(8),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontFamily: "Poppins",
                                                                      color: const Color(0XFFA5A5A5)),
                                                                ),
                                                                SizedBox(width: width / 93.75),
                                                                Text(
                                                                  category == "stocks"
                                                                      ? "Stocks"
                                                                      : category == "crypto"
                                                                          ? "Crypto"
                                                                          : category == "commodity"
                                                                              ? "Commodity"
                                                                              : category == "forex"
                                                                                  ? "Forex"
                                                                                  : "",
                                                                  style: TextStyle(
                                                                    fontSize: text.scale(8),
                                                                    color: const Color(0XFF0EA102),
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                  ),
                                                                )
                                                                /*GradientText(
                                                                  category,
                                                                  style: TextStyle(
                                                                    fontSize: _text.scale(100)8,
                                                                    fontWeight:
                                                                        FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                  ),
                                                                  colors: [
                                                                    const Color(0XFF661A72)
                                                                        .withOpacity(1),
                                                                    const Color(0XFFA607EE)
                                                                        .withOpacity(1),
                                                                    const Color(0XFFAF04FF)
                                                                        .withOpacity(0.43)
                                                                  ],
                                                                  gradientType:
                                                                      GradientType.linear,
                                                                  radius: 20,
                                                                  gradientDirection:
                                                                      GradientDirection.ttb,
                                                                ),*/
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height / 135.33,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Sub Category:",
                                                                  style: TextStyle(
                                                                      fontSize: text.scale(8),
                                                                      fontWeight: FontWeight.w700,
                                                                      fontFamily: "Poppins",
                                                                      color: const Color(0XFFA5A5A5)),
                                                                ),
                                                                SizedBox(width: width / 93.75),
                                                                Text(
                                                                  companyName,
                                                                  style: TextStyle(
                                                                    color: const Color(0XFF0EA102),
                                                                    fontSize: text.scale(8),
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: "Poppins",
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            /* SizedBox(
                                                              height: _height / 135.33,
                                                            ),*/
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      )
                                    ],
                                  ),
                                ),
                                RepaintBoundary(
                                  key: previewContainer1,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: height / 33.83,
                                      ),
                                      Container(
                                        height: height / 4.06,
                                        margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                        decoration: isDarkTheme.value
                                            ? BoxDecoration(borderRadius: BorderRadius.circular(20), color: Theme.of(context).colorScheme.tertiary)
                                            : BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                gradient: LinearGradient(
                                                  colors: [const Color(0XFF0EA102).withOpacity(0.46), const Color(0XFF0EA102).withOpacity(0.76)],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ),
                                              ),
                                        child: totalAnswers == 0
                                            ? Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: 'No response to display...',
                                                          style: TextStyle(
                                                              color: isDarkTheme.value
                                                                  ? Theme.of(context).colorScheme.onPrimary
                                                                  : Theme.of(context).colorScheme.background,
                                                              fontWeight: FontWeight.w600,
                                                              fontFamily: "Poppins",
                                                              fontSize: 14)),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Stack(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 8.0),
                                                          child: Text(
                                                            "Total Response Trend",
                                                            style: TextStyle(
                                                                color: isDarkTheme.value
                                                                    ? Theme.of(context).colorScheme.onPrimary
                                                                    : Theme.of(context).colorScheme.background,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w700),
                                                          ),
                                                        ),
                                                        Text(
                                                          totalAnswers.toString(),
                                                          style: TextStyle(
                                                              color: isDarkTheme.value
                                                                  ? Theme.of(context).colorScheme.onPrimary
                                                                  : Theme.of(context).colorScheme.background,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SfCartesianChart(
                                                    plotAreaBackgroundColor: Colors.transparent,
                                                    enableAxisAnimation: true,
                                                    primaryXAxis: CategoryAxis(
                                                      majorGridLines: const MajorGridLines(width: 0),
                                                      isVisible: false,
                                                      placeLabelsNearAxisLine: false,
                                                    ),
                                                    primaryYAxis: NumericAxis(
                                                      majorGridLines: const MajorGridLines(width: 0),
                                                      isVisible: false,
                                                      placeLabelsNearAxisLine: false,
                                                    ),
                                                    plotAreaBorderColor: Colors.transparent,
                                                    trackballBehavior: TrackballBehavior(
                                                      tooltipAlignment: ChartAlignment.center,
                                                      lineColor: Colors.white,
                                                      lineWidth: 3,
                                                      tooltipSettings: InteractiveTooltip(
                                                          borderColor: Colors.white,
                                                          color: Colors.white,
                                                          canShowMarker: false,
                                                          enable: true,
                                                          format: activeTime == "1 day"
                                                              ? "Time:point.x , Count:point.y"
                                                              : activeTime == "1 Week"
                                                                  ? "Date:point.x , Count:point.y"
                                                                  : activeTime == "1 Month"
                                                                      ? "Date:point.x , Count:point.y"
                                                                      : activeTime == "6 Months"
                                                                          ? "Month:point.x , Count:point.y"
                                                                          : "",
                                                          textStyle: const TextStyle(color: Colors.black)),
                                                      activationMode: ActivationMode.singleTap,
                                                      enable: true,
                                                      tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
                                                    ),
                                                    /*tooltipBehavior: TooltipBehavior(enable: true,color: Colors.white, header:"Responses",format:activeTime == "1 day" ? "Time:point.x , Count:point.y"
                                                  : activeTime == "1 Week"
                                                  ? "Date:point.x , Count:point.y"
                                                  : activeTime == "1 Month"
                                                  ? "Date:point.x , Count:point.y"
                                                  : activeTime == "6 Months" ? "Month:point.x , Count:point.y":"",canShowMarker: false, textStyle: TextStyle(color: Colors.black)),*/
                                                    series: <ChartSeries>[
                                                      // Renders spline chart
                                                      AreaSeries<ChartData, String>(
                                                        color: Colors.green,
                                                        gradient: const LinearGradient(
                                                          colors: [
                                                            Colors.white,
                                                            Colors.green,
                                                          ],
                                                          end: Alignment.bottomCenter,
                                                          begin: Alignment.topCenter,
                                                        ),
                                                        borderColor: isDarkTheme.value ? Theme.of(context).colorScheme.background : Colors.white,
                                                        borderWidth: 2,
                                                        dataSource: chartData,
                                                        xValueMapper: (ChartData data, _) => data.x,
                                                        yValueMapper: (ChartData data, _) => data.y,
                                                        // dataLabelSettings: DataLabelSettings(isVisible:false)
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height / 33.83),
                                ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: totalQuestions,
                                    itemBuilder: (BuildContext context, int index) {
                                      return RepaintBoundary(
                                        key: keyList1[index],
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: height / 33.83, right: width / 18.75, left: width / 18.75),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.tertiary /*const Color(0XFFFFFFFF)*/,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context).colorScheme.background.withOpacity(0.3), blurRadius: 4, spreadRadius: 0),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: height / 33.83,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width / 17.85,
                                                  ),
                                                  Text(
                                                    "Question ${index + 1}/$totalQuestions",
                                                    style: TextStyle(
                                                        fontSize: text.scale(14),
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: "Poppins",
                                                        color: Theme.of(context).colorScheme.onPrimary),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: height / 45.11),
                                              GestureDetector(
                                                onTap: () {
                                                  Flushbar(
                                                    message: "Analytics not visible due to privacy",
                                                    duration: const Duration(seconds: 2),
                                                  ).show(context);
                                                },
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          answerTotalCount[index].toString(),
                                                          style: TextStyle(
                                                              fontSize: text.scale(24),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Poppins",
                                                              color: const Color(0XFF0EA102).withOpacity(0.6)),
                                                        ),
                                                        Text(
                                                          "Response",
                                                          style: TextStyle(
                                                              fontSize: text.scale(12),
                                                              fontWeight: FontWeight.w600,
                                                              fontFamily: "Poppins",
                                                              color: const Color(0XFFA5A5A5)),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          answerViewCount[index].toString(),
                                                          style: TextStyle(
                                                              fontSize: text.scale(24),
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: "Poppins",
                                                              color: const Color(0XFF0EA102).withOpacity(0.6)),
                                                        ),
                                                        Text(
                                                          "Views",
                                                          style: TextStyle(
                                                              fontSize: text.scale(12),
                                                              fontWeight: FontWeight.w600,
                                                              fontFamily: "Poppins",
                                                              color: const Color(0XFFA5A5A5)),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: height / 20.3,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: width / 18.75, right: width / 18.75),
                                                child: Text(
                                                  questionList[index],
                                                  style: TextStyle(
                                                      fontSize: text.scale(16),
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "Poppins",
                                                      color: Theme.of(context).colorScheme.onPrimary),
                                                ),
                                              ),
                                              SizedBox(
                                                height: height / 101.5,
                                              ),
                                              Column(
                                                children: [
                                                  answer1List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                  answer1List[index]
                                                      ? Stack(alignment: Alignment.centerLeft, children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(left: width / 28.84, right: width / 28.84),
                                                            child: Container(
                                                              height: height / 18.04,
                                                              width: width / 1.25,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Theme.of(context).colorScheme.background /*const Color(0XFFFFFFFF)*/,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: const Color(0XFFB0B0B0).withOpacity(0.2),
                                                                        blurRadius: 4,
                                                                        spreadRadius: 0)
                                                                  ]),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: LinearProgressIndicator(
                                                                  value:
                                                                      answerCount1[index] == 0 ? 0.0 : answerCount1[index] / answerTotalCount[index],
                                                                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0XFF0EA102).withOpacity(0.7)),
                                                                  backgroundColor: Theme.of(context).colorScheme.background,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: width / 11, top: 10, bottom: 10),
                                                            child: SizedBox(
                                                              width: width / 1.4,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width / 1.65,
                                                                    child: Text(
                                                                      answerList1[index],
                                                                      style: TextStyle(
                                                                          color: Theme.of(context).colorScheme.onPrimary /*const Color(0XFF000000)*/,
                                                                          fontSize: text.scale(14),
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: "Poppins"),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    answerCount1[index] == 0
                                                                        ? "0%"
                                                                        : "${((answerCount1[index] / answerTotalCount[index]) * 100).round()}%",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context).colorScheme.onPrimary /*const Color(0XFF000000)*/,
                                                                        fontSize: text.scale(14),
                                                                        fontWeight: FontWeight.w700,
                                                                        fontFamily: "poppins"),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ])
                                                      : const SizedBox(),
                                                  answer1List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                  answer2List[index]
                                                      ? Stack(alignment: Alignment.centerLeft, children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(left: width / 28.84, right: width / 28.84),
                                                            child: Container(
                                                              height: height / 18.04,
                                                              width: width / 1.25,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Theme.of(context).colorScheme.background,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: const Color(0XFFB0B0B0).withOpacity(0.2),
                                                                        blurRadius: 4,
                                                                        spreadRadius: 0)
                                                                  ]),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: LinearProgressIndicator(
                                                                  value:
                                                                      answerCount2[index] == 0 ? 0.0 : answerCount2[index] / answerTotalCount[index],
                                                                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0XFF0EA102).withOpacity(0.7)),
                                                                  backgroundColor: Theme.of(context).colorScheme.background,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: width / 11, top: 10, bottom: 10),
                                                            child: SizedBox(
                                                              width: width / 1.4,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width / 1.65,
                                                                    child: Text(
                                                                      answerList2[index],
                                                                      style: TextStyle(
                                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                                          fontSize: text.scale(14),
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: "Poppins"),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    answerCount2[index] == 0
                                                                        ? "0%"
                                                                        : "${((answerCount2[index] / answerTotalCount[index]) * 100).round()}%",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                                        fontSize: text.scale(14),
                                                                        fontWeight: FontWeight.w700,
                                                                        fontFamily: "poppins"),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ])
                                                      : const SizedBox(),
                                                  answer2List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                  answer3List[index]
                                                      ? Stack(alignment: Alignment.centerLeft, children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(left: width / 28.84, right: width / 28.84),
                                                            child: Container(
                                                              height: height / 18.04,
                                                              width: width / 1.25,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Theme.of(context).colorScheme.background,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: const Color(0XFFB0B0B0).withOpacity(0.2),
                                                                        blurRadius: 4,
                                                                        spreadRadius: 0)
                                                                  ]),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: LinearProgressIndicator(
                                                                  value:
                                                                      answerCount3[index] == 0 ? 0.0 : answerCount3[index] / answerTotalCount[index],
                                                                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0XFF0EA102).withOpacity(0.7)),
                                                                  backgroundColor: Theme.of(context).colorScheme.background,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: width / 11, top: 10, bottom: 10),
                                                            child: SizedBox(
                                                              width: width / 1.4,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width / 1.6,
                                                                    child: Text(
                                                                      answerList3[index],
                                                                      style: TextStyle(
                                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                                          fontSize: text.scale(14),
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: "Poppins"),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    answerCount3[index] == 0
                                                                        ? "0%"
                                                                        : "${((answerCount3[index] / answerTotalCount[index]) * 100).round()}%",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                                        fontSize: text.scale(14),
                                                                        fontWeight: FontWeight.w700,
                                                                        fontFamily: "poppins"),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ])
                                                      : const SizedBox(),
                                                  answer3List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                  answer4List[index]
                                                      ? Stack(alignment: Alignment.centerLeft, children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(left: width / 28.84, right: width / 28.84),
                                                            child: Container(
                                                              height: height / 18.04,
                                                              width: width / 1.25,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Theme.of(context).colorScheme.background,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: const Color(0XFFB0B0B0).withOpacity(0.2),
                                                                        blurRadius: 4,
                                                                        spreadRadius: 0)
                                                                  ]),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: LinearProgressIndicator(
                                                                  value:
                                                                      answerCount4[index] == 0 ? 0.0 : answerCount4[index] / answerTotalCount[index],
                                                                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0XFF0EA102).withOpacity(0.7)),
                                                                  backgroundColor: Theme.of(context).colorScheme.background,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: width / 11, top: 10, bottom: 10),
                                                            child: SizedBox(
                                                              width: width / 1.4,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width / 1.6,
                                                                    child: Text(
                                                                      answerList4[index],
                                                                      style: TextStyle(
                                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                                          fontSize: text.scale(14),
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: "Poppins"),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    answerCount4[index] == 0
                                                                        ? "0%"
                                                                        : "${((answerCount4[index] / answerTotalCount[index]) * 100).round()}%",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                                        fontSize: text.scale(14),
                                                                        fontWeight: FontWeight.w700,
                                                                        fontFamily: "poppins"),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ])
                                                      : const SizedBox(),
                                                  answer4List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                  answer5List[index]
                                                      ? Stack(alignment: Alignment.centerLeft, children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(left: width / 28.84, right: width / 28.84),
                                                            child: Container(
                                                              height: height / 18.04,
                                                              width: width / 1.25,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Theme.of(context).colorScheme.background,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: const Color(0XFFB0B0B0).withOpacity(0.2),
                                                                        blurRadius: 4,
                                                                        spreadRadius: 0)
                                                                  ]),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(10),
                                                                child: LinearProgressIndicator(
                                                                  value:
                                                                      answerCount5[index] == 0 ? 0.0 : answerCount5[index] / answerTotalCount[index],
                                                                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0XFF0EA102).withOpacity(0.7)),
                                                                  backgroundColor: Theme.of(context).colorScheme.background,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(left: width / 11, top: 10, bottom: 10),
                                                            child: SizedBox(
                                                              width: width / 1.4,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width / 1.6,
                                                                    child: Text(
                                                                      answerList5[index],
                                                                      style: TextStyle(
                                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                                          fontSize: text.scale(14),
                                                                          fontWeight: FontWeight.w700,
                                                                          fontFamily: "Poppins"),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    answerCount5[index] == 0
                                                                        ? "0%"
                                                                        : "${((answerCount5[index] / answerTotalCount[index]) * 100).round()}%",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context).colorScheme.onPrimary,
                                                                        fontSize: text.scale(14),
                                                                        fontWeight: FontWeight.w700,
                                                                        fontFamily: "poppins"),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ])
                                                      : const SizedBox(),
                                                  answer5List[index]
                                                      ? SizedBox(
                                                          height: height / 40.6,
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height / 33.83,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                        _bannerAdIsLoaded && _bannerAd != null
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                child: SizedBox(
                                  width: _bannerAd!.size.width.toDouble(),
                                  height: _bannerAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAd!),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    )
                  : Center(
                      child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  showSheet() {
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
                    onTap: () async {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      _getStoragePermission(type: true);
                      getActivityApi();
                    },
                    minLeadingWidth: width / 25,
                    leading: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "lib/Constants/Assets/SMLogos/pdf.png",
                        )),
                    title: Text(
                      "PDF",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                  const Divider(
                    thickness: 0.0,
                    height: 0.0,
                  ),
                  ListTile(
                    onTap: () async {
                      if (!mounted) {
                        return;
                      }
                      Navigator.pop(context);
                      _getStoragePermission(type: false);
                      getActivityApi();
                    },
                    minLeadingWidth: width / 25,
                    leading: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "lib/Constants/Assets/SMLogos/csv.png",
                        )),
                    title: Text(
                      "CSV",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  viewedShowSheet() {
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
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: surveyViewedIdList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            await checkUser(
                                uId: surveyViewedIdList[index], uType: 'forums', mainUserToken: mainUserToken, context: context, index: 0);
                          },
                          minLeadingWidth: width / 25,
                          leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: NetworkImage(surveyViewedImagesList[index]), fit: BoxFit.fill))),
                          title: Text(
                            surveyViewedSourceNameList[index].toString().capitalizeFirst!,
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: text.scale(14)),
                          ),
                          trailing: Container(
                              margin: EdgeInsets.only(right: width / 25),
                              height: height / 40.6,
                              width: width / 18.75,
                              child: const Icon(Icons.remove_red_eye_outlined)),
                        ),
                        const Divider(
                          thickness: 0.0,
                          height: 0.0,
                        ),
                      ],
                    );
                  }),
            ),
          );
        });
  }
}
