import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage> {
  bool loader = false;

  @override
  void initState() {
    communitiesVariables.isSeeAllViewEnabled.value = false;
    getData();
    super.initState();
  }

  getData() async {
    communitiesFunctions.getCommunitiesList(skipCount: 0);
    communitiesFunctions.getTrendingCommunitiesList(skipCount: 0);
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: Column(
              children: [
                SizedBox(height: height / 57.73),
                Obx(
                  () => communitiesVariables.communityHomeList.value.trendingData.isEmpty
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Trending community",
                              style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                child: Divider(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  thickness: 0.8,
                                ),
                              ),
                            ),
                            communitiesVariables.communityHomeList.value.trendingData.isEmpty
                                ? const SizedBox()
                                : GestureDetector(
                                    onTap: () {
                                      communitiesVariables.isSeeAllViewEnabled.toggle();
                                    },
                                    child: Obx(
                                      () => communitiesVariables.isSeeAllViewEnabled.value
                                          ? Image.asset(
                                              "lib/Constants/Assets/ForumPage/x.png",
                                              scale: 3,
                                            )
                                          : Text(
                                              "See all",
                                              style: TextStyle(fontSize: text.scale(10), color: const Color(0XFF0EA102), fontWeight: FontWeight.w500),
                                            ),
                                    ),
                                  ),
                          ],
                        ),
                ),
                Obx(
                  () => communitiesVariables.communityHomeList.value.trendingData.isEmpty ? const SizedBox() : SizedBox(height: height / 57.73),
                ),
                Obx(
                  () => communitiesVariables.communityHomeList.value.trendingData.isEmpty
                      ? const SizedBox()
                      : communitiesVariables.isSeeAllViewEnabled.value
                          ? communitiesPageWidgets.trendingSeeAllCommunitiesList(context: context, modelSetState: setState, skipCount: 0)
                          : communitiesPageWidgets.trendingCommunitiesList(context: context, modelSetState: setState),
                ),
                Obx(
                  () => communitiesVariables.communityHomeList.value.trendingData.isEmpty
                      ? const SizedBox()
                      : communitiesVariables.isSeeAllViewEnabled.value
                          ? const SizedBox()
                          : SizedBox(
                              height: height / 57.73,
                            ),
                ),
                Obx(
                  () => communitiesVariables.isSeeAllViewEnabled.value
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("List of community", style: TextStyle(fontSize: text.scale(14), fontWeight: FontWeight.w600)),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                child: Divider(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  thickness: 0.8,
                                ),
                              ),
                            )
                          ],
                        ),
                ),
                Obx(
                  () => communitiesVariables.isSeeAllViewEnabled.value ? const SizedBox() : SizedBox(height: height / 57.73),
                ),
                Obx(
                  () => communitiesVariables.isSeeAllViewEnabled.value
                      ? const SizedBox()
                      : communitiesPageWidgets.communitiesList(context: context, modelSetState: setState, skipCount: 0),
                ),
              ],
            ),
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
          );
  }
}
