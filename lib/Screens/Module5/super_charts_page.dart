import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class SuperChartsPage extends StatefulWidget {
  final String url;

  const SuperChartsPage({Key? key, required this.url}) : super(key: key);

  @override
  State<SuperChartsPage> createState() => _SuperChartsPageState();
}

class _SuperChartsPageState extends State<SuperChartsPage> {
  bool loader = true;
  RxInt progressPercentage = 0.obs;
  RxString progressValue = "".obs;
  final WebViewController _controllerChartData = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..addJavaScriptChannel(
      'Toaster',
      onMessageReceived: (JavaScriptMessage message) {},
    );

  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    getAllDataMain(name: 'Super_Charts_Page');
    getDataChart1();
    super.initState();
  }

  getDataChart1() async {
    var response = await getCookies();
    PlatformWebViewCookieManagerCreationParams params1 = const PlatformWebViewCookieManagerCreationParams();
    final WebViewCookieManager webViewCookieManager = WebViewCookieManager.fromPlatformCreationParams(
      params1,
    );
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      final WebKitWebViewCookieManager webKitManager = webViewCookieManager.platform as WebKitWebViewCookieManager;
      webKitManager.setCookie(WebViewCookie(name: "sessionid", value: response["response"]["sessionid"], domain: ".tradingview.com", path: "/"));
      webKitManager
          .setCookie(WebViewCookie(name: "sessionid_sign", value: response["response"]["sessionid_sign"], domain: ".tradingview.com", path: "/"));
    } else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      final AndroidWebViewCookieManager androidManager = webViewCookieManager.platform as AndroidWebViewCookieManager;
      androidManager.setCookie(WebViewCookie(name: "sessionid", value: response["response"]["sessionid"], domain: ".tradingview.com", path: "/"));
      androidManager
          .setCookie(WebViewCookie(name: "sessionid_sign", value: response["response"]["sessionid_sign"], domain: ".tradingview.com", path: "/"));
    }
    _controllerChartData
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            progressPercentage.value = progress;
            progressValue.value = "${progressPercentage.value} %";
            if (progress == 100) {
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  loader = false;
                });
              });
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                loader = false;
              });
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
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

    return WillPopScope(
        //canPop: true,
        onWillPop: () async {
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          }
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            //backgroundColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.background,
            body: loader
                ? Container(
                    height: height,
                    width: width,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: 100, width: 100),
                        Obx(() => Text(
                              progressValue.value,
                              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w300, color: Color(0XFF0EA102)),
                            )),
                      ],
                    ),
                  )
                : Container(
                    // color: Colors.white,
                    color: Theme.of(context).colorScheme.background,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 1.77777,
                              child: WebViewWidget(
                                controller: _controllerChartData,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                height: height / 11,
                                width: width / 2,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              height: height / 9,
                              width: width / 16,
                              color: Colors.white,
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                                    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                    if (!mounted) {
                                      return;
                                    }
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back_ios),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: width / 3.5,
                                width: height / 9.25,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                height: height / 2.5,
                                width: width / 7.5,
                                color: Colors.transparent,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                height: height * 1.027,
                                width: width / 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ));
  }
}
