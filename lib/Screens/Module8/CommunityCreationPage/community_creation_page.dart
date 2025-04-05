import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/categories_list_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesModel/post_limitation_model.dart';
import 'package:tradewatchfinal/Screens/Module8/CommunitiesPage/communities_page.dart';

class CommunityCreationPage extends StatefulWidget {
  final bool isEditing;
  final String communityId;

  const CommunityCreationPage({super.key, required this.isEditing, required this.communityId});

  @override
  State<CommunityCreationPage> createState() => _CommunityCreationPageState();
}

class _CommunityCreationPageState extends State<CommunityCreationPage> {
  bool loader = false;
  bool isEditing = false;

  @override
  void initState() {
    isEditing = widget.isEditing;
    getData();
    super.initState();
  }

  getData() async {
    if (isEditing) {
      isEditing = true;
      await communitiesFunctions.getCommunityDetails(communityId: widget.communityId);
      communitiesVariables.communityController.value.clear();
      communitiesVariables.aboutController.value.clear();
      communitiesVariables.rulesController.value.clear();
      communitiesVariables.selectedPostLimitResponseOptionValue.clear();
      communitiesVariables.selectedSubscriptionPeriodValue.clear();
      communitiesVariables.selectedTrailAvailableValue.clear();
      communitiesVariables.selectedTrailFreeValue.clear();
      communitiesVariables.paymentController.clear();
      communitiesVariables.discountController.clear();
      communitiesVariables.periodDataSlugList.clear();
      communitiesVariables.isDiscountAvailable.clear();
      communitiesVariables.selectedImageForCommunity = null;
      communitiesVariables.createButtonLoader.value = false;
      communitiesVariables.communityController.value.text = communitiesVariables.communitiesDetail!.value.response.name;
      communitiesVariables.aboutController.value.text = communitiesVariables.communitiesDetail!.value.response.about;
      communitiesVariables.rulesController.value.text = communitiesVariables.communitiesDetail!.value.response.rules;
      for (int i = 0; i < communitiesVariables.categoriesList.value.response.length; i++) {
        if (communitiesVariables.categoriesList.value.response[i].id.value == communitiesVariables.communitiesDetail!.value.response.categoryId) {
          communitiesVariables.selectedCategoryForCommunity = (communitiesVariables.categoriesList.value.response[i]).obs;
        }
      }
      communitiesVariables.categoriesController.value.text = communitiesVariables.selectedCategoryForCommunity.value.name.value;
      for (int i = 0; i < communitiesVariables.postLimitationData.value.response.length; i++) {
        if (communitiesVariables.postLimitationData.value.response[i].slug.value == communitiesVariables.communitiesDetail!.value.response.postType) {
          communitiesVariables.selectedPostLimitValue = (communitiesVariables.postLimitationData.value.response[i]).obs;
        }
      }
      communitiesVariables.selectedSubscriptionType = (communitiesVariables.communitiesDetail!.value.response.subscription).obs;
      if (communitiesVariables.communitiesDetail!.value.response.postType == "flexible") {
        for (int i = 0; i < communitiesVariables.communitiesDetail!.value.response.postAccess.length; i++) {
          for (int j = 0; j < communitiesVariables.selectedPostLimitValue.value.options.length; j++) {
            if (communitiesVariables.selectedPostLimitValue.value.options[j].slug.value ==
                communitiesVariables.communitiesDetail!.value.response.postAccess[i]) {
              communitiesVariables.selectedPostLimitResponseOptionValue.add(communitiesVariables.selectedPostLimitValue.value.options[j].slug.value);
            }
          }
        }
      } else {
        communitiesVariables.selectedPostLimitResponseOptionValue.add(communitiesVariables.selectedPostLimitValue.value.options[0].slug.value);
      }
      for (int i = 0; i < communitiesVariables.communitiesDetail!.value.response.subscriptionType.length; i++) {
        for (int j = 0; j < communitiesVariables.subscriptionPeriodData.value.response.length; j++) {
          if (communitiesVariables.subscriptionPeriodData.value.response[j].slug.value ==
              communitiesVariables.communitiesDetail!.value.response.subscriptionType[i].type) {
            communitiesVariables.selectedSubscriptionPeriodValue.add(communitiesVariables.subscriptionPeriodData.value.response[j]);
          }
        }
      }
      for (int i = 0; i < communitiesVariables.communitiesDetail!.value.response.subscriptionType.length; i++) {
        if (communitiesVariables.communitiesDetail!.value.response.subscriptionType[i].trailPeriod == 0) {
          communitiesVariables.selectedTrailAvailableValue.add(PostLimitationResponse.fromJson({"name": "No", "slug": "no"}));
        } else {
          communitiesVariables.selectedTrailAvailableValue.add(PostLimitationResponse.fromJson({"name": "Yes", "slug": "yes"}));
        }
      }
      for (int i = 0; i < communitiesVariables.communitiesDetail!.value.response.subscriptionType.length; i++) {
        if (communitiesVariables.communitiesDetail!.value.response.subscriptionType[i].trailPeriod == 0) {
          communitiesVariables.selectedTrailFreeValue.add(
            PostLimitationResponse.fromJson({"name": "0 days", "slug": "0"}),
          );
        } else {
          for (int j = 0; j < communitiesVariables.trailFreeData.value.response.length; j++) {
            if (communitiesVariables.trailFreeData.value.response[j].slug.value ==
                communitiesVariables.communitiesDetail!.value.response.subscriptionType[i].trailPeriod.toString()) {
              communitiesVariables.selectedTrailFreeValue.add(communitiesVariables.trailFreeData.value.response[j]);
            }
          }
        }
      }
      for (int i = 0; i < communitiesVariables.communitiesDetail!.value.response.subscriptionType.length; i++) {
        communitiesVariables.paymentController.add(TextEditingController());
        communitiesVariables.discountController.add(TextEditingController());
        communitiesVariables.isDiscountAvailable.add(communitiesVariables.communitiesDetail!.value.response.subscriptionType[i].discountPer != 0);
        communitiesVariables.paymentController[i].text = communitiesVariables.communitiesDetail!.value.response.subscriptionType[i].amount.toString();
        communitiesVariables.discountController[i].text =
            communitiesVariables.communitiesDetail!.value.response.subscriptionType[i].discountPer.toString();
      }
      for (int i = 0; i < communitiesVariables.selectedSubscriptionPeriodValue.length; i++) {
        communitiesVariables.periodDataSlugList.add(communitiesVariables.selectedSubscriptionPeriodValue[i].slug.value);
      }
      if (communitiesVariables.communitiesDetail!.value.response.subscription == "Paid") {
        communitiesVariables.isDisclaimerChecked.value = true;
      }
      communitiesFunctions.getEditData();
      setState(() {
        loader = true;
      });
    } else {
      communitiesVariables.communityController.value.clear();
      communitiesVariables.aboutController.value.clear();
      communitiesVariables.rulesController.value.clear();
      communitiesVariables.selectedPostLimitResponseOptionValue.clear();
      communitiesVariables.selectedSubscriptionPeriodValue.clear();
      communitiesVariables.selectedTrailAvailableValue.clear();
      communitiesVariables.selectedTrailFreeValue.clear();
      communitiesVariables.paymentController.clear();
      communitiesVariables.discountController.clear();
      communitiesVariables.periodDataSlugList.clear();
      communitiesVariables.selectedImageForCommunity = null;
      communitiesVariables.createButtonLoader.value = false;
      communitiesVariables.selectedCategoryForCommunity = (CategoriesListModelResponse.fromJson({
        "name": "Stocks",
        "id": "625feb5da30e9baa64758043",
        "slug": "stocks",
        "image_url": "lib/Constants/Assets/SMLogos/LockerScreen/Chart.svg"
      })).obs;
      communitiesVariables.categoriesController.value.text = communitiesVariables.selectedCategoryForCommunity.value.name.value;
      communitiesVariables.selectedPostLimitValue = PostLimitationResponse.fromJson({
        "name": "Open",
        "slug": "open",
        "options": [
          {"name": "Any one can post community", "slug": "anyone"}
        ]
      }).obs;
      communitiesVariables.selectedSubscriptionType = "Free".obs;
      communitiesVariables.selectedPostLimitResponseOptionValue.add(communitiesVariables.selectedPostLimitValue.value.options[0].slug.value);
      communitiesVariables.selectedSubscriptionPeriodValue.add(PostLimitationResponse.fromJson({"name": "Monthly", "slug": "month"}));
      communitiesVariables.selectedTrailAvailableValue.add(PostLimitationResponse.fromJson({"name": "Yes", "slug": "yes"}));
      communitiesVariables.selectedTrailFreeValue.add(PostLimitationResponse.fromJson({"name": "7 days", "slug": "7"}));
      communitiesVariables.paymentController.add(TextEditingController());
      communitiesVariables.discountController.add(TextEditingController());
      communitiesVariables.paymentController[0].text = "1499";
      communitiesVariables.isDiscountAvailable.add(false);
      communitiesVariables.discountController[0].text = "15";
      for (int i = 0; i < communitiesVariables.selectedSubscriptionPeriodValue.length; i++) {
        communitiesVariables.periodDataSlugList.add(communitiesVariables.selectedSubscriptionPeriodValue[i].slug.value);
      }
      communitiesFunctions.getData();
      setState(() {
        loader = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            height: height / 1.23,
            width: width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                color: Theme.of(context).colorScheme.tertiary),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 27.4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height / 57.73),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isEditing ? "Edit Community" : "Create Community",
                        style: TextStyle(fontSize: text.scale(16), color: const Color(0XFF0EA102), fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Color(0XFF0EA102),
                          ))
                    ],
                  ),
                  SizedBox(height: height / 28.86),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Container(
                            height: height / 10.06,
                            padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                            child: InkWell(
                              onTap: () {
                                communityCreationWidgets.showChangeBottomSheet(context: context, modelSetState: setState);
                              },
                              child: communitiesVariables.selectedImageForCommunity == null
                                  ? isEditing
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                              Container(
                                                height: height / 10.06,
                                                width: width / 4.83,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: const Color(0XFF202020).withOpacity(0.6),
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                                child: Image.network(
                                                  communitiesVariables.communitiesDetail!.value.response.file[0].file.value,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              SizedBox(width: width / 41.1),
                                              IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("Change",
                                                        style: TextStyle(
                                                            fontSize: text.scale(12), color: const Color(0XFF828282), fontWeight: FontWeight.w400)),
                                                    const VerticalDivider(
                                                      thickness: 1.5,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          communitiesVariables.selectedImageForCommunity = null;
                                                        });
                                                      },
                                                      child: Text("Remove",
                                                          style: TextStyle(
                                                              fontSize: text.scale(12), color: const Color(0XFF828282), fontWeight: FontWeight.w400)),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ])
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                              Container(
                                                  height: height / 10.06,
                                                  width: width / 4.83,
                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0XFF202020).withOpacity(0.6)),
                                                  child: const Center(child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 30))),
                                              SizedBox(width: width / 41.1),
                                              Text("Add Photo".obs.value,
                                                  style: TextStyle(
                                                      fontSize: text.scale(14), color: const Color(0XFF828282), fontWeight: FontWeight.w400))
                                            ])
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                          Container(
                                            height: height / 10.06,
                                            width: width / 4.83,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0XFF202020).withOpacity(0.6),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.file(
                                              communitiesVariables.selectedImageForCommunity ?? File(""),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(width: width / 41.1),
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Change",
                                                    style: TextStyle(
                                                        fontSize: text.scale(12), color: const Color(0XFF828282), fontWeight: FontWeight.w400)),
                                                const VerticalDivider(
                                                  thickness: 1.5,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      communitiesVariables.selectedImageForCommunity = null;
                                                    });
                                                  },
                                                  child: Text("Remove",
                                                      style: TextStyle(
                                                          fontSize: text.scale(12), color: const Color(0XFF828282), fontWeight: FontWeight.w400)),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                            )),
                        SizedBox(height: height / 86.6),
                        communityCreationWidgets.textFieldFunction(
                          context: context,
                          topic: "Community Name",
                          controller: communitiesVariables.communityController.value,
                        ),
                        communityCreationWidgets.textFieldFunction(
                          context: context,
                          topic: "About",
                          controller: communitiesVariables.aboutController.value,
                        ),
                        communityCreationWidgets.textFieldFunction(
                          context: context,
                          topic: "Rules",
                          controller: communitiesVariables.rulesController.value,
                        ),
                        communityCreationWidgets.categoriesTextFieldFunction(
                          context: context,
                          topic: "Content Categories",
                          controller: communitiesVariables.categoriesController.value,
                          isEditing: isEditing,
                        ),
                        Obx(
                          () => communitiesVariables.selectedCategoryForCommunity.value.slug.value == "stocks"
                              ? communityCreationWidgets.categoriesTextFieldFunction(
                                  context: context,
                                  topic: "Exchange",
                                  controller: communitiesVariables.exchangeController.value,
                                  isEditing: isEditing)
                              : const SizedBox(),
                        ),
                        Obx(
                          () => communitiesVariables.selectedCategoryForCommunity.value.slug.value == "stocks"
                              ? communitiesVariables.selectedExchangeForCommunity.value.id.value == ""
                                  ? const SizedBox()
                                  : communityCreationWidgets.categoriesTextFieldFunction(
                                      context: context,
                                      topic: "Industry",
                                      controller: communitiesVariables.industriesController.value,
                                      isEditing: isEditing)
                              : const SizedBox(),
                        ),
                        Obx(
                          () => communitiesVariables.selectedCategoryForCommunity.value.slug.value == "crypto"
                              ? communityCreationWidgets.categoriesTextFieldFunction(
                                  context: context, topic: "Type", controller: communitiesVariables.cryptoTypeController.value, isEditing: isEditing)
                              : const SizedBox(),
                        ),
                        Obx(
                          () => communitiesVariables.selectedCategoryForCommunity.value.slug.value == "commodity"
                              ? communityCreationWidgets.categoriesTextFieldFunction(
                                  context: context, topic: "Country", controller: communitiesVariables.countryController.value, isEditing: isEditing)
                              : const SizedBox(),
                        ),
                        Obx(
                          () => communitiesVariables.selectedCategoryForCommunity.value.slug.value == "general" ||
                                  communitiesVariables.selectedExchangeForCommunity.value.id.value == "" ||
                                  communitiesVariables.selectedCryptoTypeForCommunity.value.id.value == "" ||
                                  communitiesVariables.selectedCountryForCommunity.value.id.value == ""
                              ? const SizedBox()
                              : communityCreationWidgets.categoriesTextFieldFunction(
                                  context: context, topic: "Company", controller: communitiesVariables.tickerController.value, isEditing: isEditing),
                        ),
                        SizedBox(height: height / 57.73),
                        Text(
                          "Post Limitation",
                          style: TextStyle(
                            fontSize: text.scale(14),
                            color: const Color(0XFF666565),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: height / 86.6,
                        ),
                        communityCreationWidgets.postLimitationFunction(context: context, modelSetState: setState),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Text(
                          "Subscription",
                          style: TextStyle(
                            fontSize: text.scale(14),
                            color: const Color(0XFF666565),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: height / 86.6,
                        ),
                        communityCreationWidgets.subscriptionFunction(context: context),
                        Obx(
                          () => communitiesVariables.selectedSubscriptionType.value == "Free"
                              ? const SizedBox()
                              : communityCreationWidgets.paidSubscriptionFunc(
                                  context: context,
                                  modelSetState: setState,
                                ),
                        ),
                        Obx(
                          () => communitiesVariables.selectedSubscriptionType.value == "Free"
                              ? const SizedBox()
                              : communityCreationWidgets.disclaimerFunc(
                                  context: context,
                                ),
                        ),
                        Obx(() => communitiesVariables.createButtonLoader.value
                            ? Center(
                                child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 17.32, width: width / 8.22),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: communitiesVariables.selectedSubscriptionType.value == "Paid"
                                        ? communitiesVariables.isDisclaimerChecked.value
                                            ? const Color(0XFF0EA102)
                                            : Colors.grey
                                        : const Color(0XFF0EA102)),
                                onPressed: communitiesVariables.selectedSubscriptionType.value == "Paid"
                                    ? communitiesVariables.isDisclaimerChecked.value
                                        ? () async {
                                            communitiesVariables.createButtonLoader.value = true;
                                            Map<String, dynamic> data =
                                                await communitiesFunctions.getCommunitiesCreate(communityId: isEditing ? widget.communityId : '');
                                            if (data["status"]) {
                                              if (!mounted) {
                                                return;
                                              }
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) => const CommunitiesPage(
                                                            communityId: "",
                                                          )));
                                              communitiesFunctions.getCommunitiesList(skipCount: 0);
                                              communitiesFunctions.getTrendingCommunitiesList(skipCount: 0);
                                              communitiesVariables.createButtonLoader.value = false;
                                            } else {
                                              communitiesVariables.createButtonLoader.value = false;
                                            }
                                          }
                                        : () {}
                                    : () async {
                                        communitiesVariables.createButtonLoader.value = true;
                                        Map<String, dynamic> data = await communitiesFunctions.getCommunitiesCreate(
                                          communityId: isEditing ? widget.communityId : '',
                                        );
                                        if (data["status"]) {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => const CommunitiesPage(
                                                        communityId: '',
                                                      )));
                                          communitiesFunctions.getCommunitiesList(skipCount: 0);
                                          communitiesFunctions.getTrendingCommunitiesList(skipCount: 0);
                                          communitiesVariables.communityHomeList.refresh();
                                          communitiesVariables.createButtonLoader.value = false;
                                        } else {
                                          communitiesVariables.createButtonLoader.value = false;
                                        }
                                      },
                                child: const Text(
                                  "Create",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
          );
  }
}
