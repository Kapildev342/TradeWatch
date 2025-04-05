import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradewatchfinal/Constants/API/Api.dart';
import 'package:tradewatchfinal/Screens/Module1/VideosPage/video_response_model.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerLandscapeScreen extends StatefulWidget {
  final String id;
  final String comeFrom;

  const YoutubePlayerLandscapeScreen({Key? key, required this.id, required this.comeFrom}) : super(key: key);

  @override
  State<YoutubePlayerLandscapeScreen> createState() => _YoutubePlayerLandscapeScreenState();
}

class _YoutubePlayerLandscapeScreenState extends State<YoutubePlayerLandscapeScreen> {
  late YoutubePlayerController _controller;
  late VideosResponseModel _videosResponse;
  bool _isPlayerReady = false;
  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  int _numInterstitialLoadAttempts = 0;
  InterstitialAd? _interstitialAd;
  int maxFailedLoadAttempts = 3;
  bool adShown = true;
  Timer? timer;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    MobileAds.instance.updateRequestConfiguration(RequestConfiguration(testDeviceIds: ["D5FADCD990EAE787E640852882FEDEE6"]));
    getAllDataMain(name: 'Video_Landscape_Screen');
    super.initState();
    getData();
  }

  getData() async {
    await getIdData(type: 'videos', id: widget.id);
  }

  getIdData({required String id, required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mainUserToken = prefs.getString('newUserToken') ?? "";
    var url = Uri.parse(baseurl + versionLocker + idGetData);
    var response = await http.post(url, body: {
      "id": id,
      "type": type
    }, headers: {
      "authorization": mainUserToken,
    });
    var responseData = json.decode(response.body);
    _videosResponse = VideosResponseModel.fromJson(responseData);
    String? finalUrl = YoutubePlayerController.convertUrlToId('${_videosResponse.response.newsUrl}?modestbranding=1');
    videoIdsMain.insert(0, finalUrl ?? "");
    Future.delayed(const Duration(seconds: 2), () {
      _controller = YoutubePlayerController(
        params: const YoutubePlayerParams(
          showControls: true,
          mute: false,
          showFullscreenButton: false,
          loop: false,
        ),
      );
      _controller.setFullScreenListener((isFullScreen) {});
      _controller.loadPlaylist(
        list: videoIdsMain,
        listType: ListType.playlist,
        startSeconds: 136,
      );
      // _controller.enterFullScreen(lock: true);
    }).then((value) => setState(() {
          _isPlayerReady = true;
        }));
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (widget.comeFrom == "search") {
      createInterstitialAd();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_interstitialAd != null) {
          if (adShown) {
            showInterstitialAd();
          } else {
            timer.cancel();
          }
        }
      });
    }
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: adVariables.interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            setState(() {});
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    adShown = false;
    _interstitialAd = null;
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (widget.comeFrom == "finalCharts") {
          /* if (!mounted) {
            return false;
          }*/
          Navigator.pop(context);
        } else if (widget.comeFrom == "main") {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const MainBottomNavigationPage(
                      caseNo1: 1, text: "stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
        } else if (widget.comeFrom == "search") {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          /*  if (!mounted) {
            return false;
          }*/
          Navigator.pop(context);
        } else {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          /*   if (!mounted) {
            return false;
          }*/
          Navigator.pop(context);
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Center(
                  child: _isPlayerReady
                      ? YoutubePlayer(
                          controller: _controller,
                          aspectRatio: 16 / 9,
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                Positioned(
                  top: width / 57.73,
                  left: height / 27.3,
                  child: GestureDetector(
                      onTap: () {
                        if (widget.comeFrom == "finalCharts") {
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        } else if (widget.comeFrom == "main") {
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => const MainBottomNavigationPage(
                                      caseNo1: 1, text: "stocks", excIndex: 1, newIndex: 0, countryIndex: 0, isHomeFirstTym: false, tType: true)));
                        } else if (widget.comeFrom == "search") {
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        } else {
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                          if (!mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                          height: height / 8.22,
                          width: width / 17.32,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black26.withOpacity(0.3)),
                          child: const Center(
                              child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )))),
                )
              ],
            )),
      ),
    );
  }
}
