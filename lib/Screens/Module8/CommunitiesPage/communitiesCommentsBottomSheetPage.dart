import 'package:another_flushbar/flushbar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Edited_Packages/emojiPicker/emoji_picker_flutter.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';

class CommunitiesCommentsBottomSheetPage extends StatefulWidget {
  final String responseId;
  final String postId;
  final String communityId;

  const CommunitiesCommentsBottomSheetPage({super.key, required this.responseId, required this.postId, required this.communityId});

  @override
  State<CommunitiesCommentsBottomSheetPage> createState() => _CommunitiesCommentsBottomSheetPageState();
}

class _CommunitiesCommentsBottomSheetPageState extends State<CommunitiesCommentsBottomSheetPage> {
  final List<String> _choose = [
    "Recent",
    "Most Liked",
    "Most Disliked",
  ];
  String selectedValue = "Recent";
  FocusNode controllerFocus = FocusNode();
  bool loader = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await communitiesFunctions.getCommunityPostResponseComments(responseId: widget.responseId);
    setState(() {
      loader = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? SizedBox(
            height: height / 1.44,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 57.73,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20.55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Response order",
                            style: TextStyle(fontSize: text.scale(12), color: const Color(0XFFB0B0B0)),
                          ),
                          SizedBox(
                            width: width / 53.57,
                          ),
                          Icon(Icons.access_time, size: height / 37.5, color: const Color(0XFF000000).withOpacity(0.5)),
                          SizedBox(
                            width: width / 75,
                          ),
                          SizedBox(
                            width: width / 3.40,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                isDense: true,
                                items: _choose
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(fontSize: text.scale(12), fontWeight: FontWeight.w500),
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (String? value) async {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                iconStyleData: IconStyleData(
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                    iconSize: 20,
                                    iconEnabledColor: Colors.black.withOpacity(0.5),
                                    iconDisabledColor: Colors.black.withOpacity(0.5)),
                                buttonStyleData: ButtonStyleData(height: height / 17.32, width: width / 3.28, elevation: 0),
                                menuItemStyleData: MenuItemStyleData(height: height / 21.65),
                                dropdownStyleData: DropdownStyleData(
                                    maxHeight: height / 4.33,
                                    width: width / 2.055,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white),
                                    elevation: 8,
                                    offset: const Offset(-20, 0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.clear,
                            size: 25,
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 57.73,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 20.55),
                    child: Obx(
                      () => communitiesVariables.communitiesCommentsInitialData!.value.response.isEmpty
                          ? Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: height / 5.77,
                                      width: width / 2.74,
                                      child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'No response to display...',
                                            style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : communitiesWidgets.communityContentWidget(context: context, modelSetState: setState),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      color: Colors.green.withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: height / 86.6,
                        ),
                        SizedBox(
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Offstage(
                                  offstage: false,
                                  child: Container(
                                    height: height / 24.74,
                                    margin: EdgeInsets.only(top: height / 173.2),
                                    padding: EdgeInsets.symmetric(horizontal: width / 41.1),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: EmojiPicker(
                                      onEmojiSelected: (category, emoji) {
                                        communitiesVariables.communityCommentsController.value.text += emoji.emoji;
                                        communitiesVariables.communityCommentsController.value.selection = TextSelection.fromPosition(
                                            TextPosition(offset: communitiesVariables.communityCommentsController.value.text.length));
                                      },
                                      config: Config(
                                        columns: 11,
                                        emojiSizeMax: 26,
                                        verticalSpacing: 0,
                                        horizontalSpacing: 0,
                                        gridPadding: EdgeInsets.zero,
                                        initCategory: Category.SMILEYS,
                                        bgColor: Colors.grey.shade50,
                                        indicatorColor: Colors.blue,
                                        iconColor: Colors.grey,
                                        iconColorSelected: Colors.blue,
                                        backspaceColor: Colors.blue,
                                        skinToneDialogBgColor: Colors.white,
                                        skinToneIndicatorColor: Colors.grey,
                                        enableSkinTones: false,
                                        recentTabBehavior: RecentTabBehavior.NONE,
                                        recentsLimit: 28,
                                        replaceEmojiOnLimitExceed: false,
                                        noRecents: Text(
                                          'No Recents',
                                          style: TextStyle(fontSize: text.scale(20), color: Colors.black26),
                                          textAlign: TextAlign.center,
                                        ),
                                        loadingIndicator: const SizedBox.shrink(),
                                        tabIndicatorAnimDuration: kTabScrollDuration,
                                        categoryIcons: const CategoryIcons(),
                                        buttonMode: ButtonMode.MATERIAL,
                                        checkPlatformCompatibility: false,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width / 41.1),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: text.scale(14),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                            ),
                            showCursor: true,
                            cursorColor: Colors.green,
                            focusNode: controllerFocus,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: communitiesVariables.communityCommentsController.value,
                            keyboardType: TextInputType.emailAddress,
                            maxLines: null,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: height / 57.73, horizontal: width / 27.4),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                hintStyle: TextStyle(
                                    color: const Color(0XFFA5A5A5), fontSize: text.scale(12), fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                                hintText: 'add your comment here',
                                suffixIcon: SizedBox(
                                  width: width / 5.48,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      (mainVariables.pickedImageSingle == null &&
                                              mainVariables.pickedVideoSingle == null &&
                                              mainVariables.pickedFileSingle == null)
                                          ? GestureDetector(
                                              onTap: () {
                                                communitiesWidgets.showSheet(context: context, modelSetState: setState, index: 0, single: true);
                                              },
                                              child: Image.asset(
                                                "lib/Constants/Assets/ForumPage/Image 3@2x.png",
                                                scale: 2,
                                              ))
                                          : const SizedBox(),
                                      IconButton(
                                          onPressed: () async {
                                            if (communitiesVariables.communityCommentsController.value.text.isEmpty) {
                                              Flushbar(
                                                message: "Message content is empty",
                                                duration: const Duration(seconds: 2),
                                              ).show(context);
                                            } else {
                                              Map<String, dynamic> data = await communitiesFunctions.getCommunityPostCommentsAdd(
                                                  communityId: widget.communityId, postId: widget.postId, responseId: widget.responseId);
                                              if (data["status"]) {
                                                communitiesFunctions.getCommunityPostResponseComments(responseId: widget.responseId);
                                                communitiesVariables.communityCommentsController.value.clear();
                                                FocusManager.instance.primaryFocus?.unfocus();
                                              }
                                            }
                                          },
                                          icon: const Icon(Icons.send, size: 25, color: Color(0XFF0EA102))),
                                    ],
                                  ),
                                ),
                                fillColor: Colors.white,
                                filled: true),
                          ),
                        ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                        (mainVariables.pickedImageSingle == null && mainVariables.pickedVideoSingle == null && mainVariables.pickedFileSingle == null)
                            ? const SizedBox()
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: width / 18.75),
                                child: mainVariables.pickedImageSingle == null &&
                                        mainVariables.pickedVideoSingle == null &&
                                        mainVariables.docSingle == null
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          mainVariables.pickedImageSingle == null
                                              ? const SizedBox()
                                              : Row(
                                                  children: [
                                                    Text(
                                                      mainVariables.pickedImageSingle!.path.split('/').last.toString(),
                                                      style: TextStyle(color: Colors.black, fontSize: text.scale(8)),
                                                    ),
                                                    SizedBox(
                                                      width: width / 41.1,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          mainVariables.pickedImageSingle = null;
                                                          mainVariables.pickedVideoSingle = null;
                                                          mainVariables.docSingle = null;
                                                          mainVariables.pickedFileSingle = null;
                                                          mainVariables.selectedUrlTypeSingle.value = "";
                                                        });
                                                      },
                                                      child: Container(
                                                          decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              color: Colors.white,
                                                              size: 12,
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                          mainVariables.pickedVideoSingle == null
                                              ? const SizedBox()
                                              : Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      mainVariables.pickedVideoSingle!.path.split('/').last.toString(),
                                                      style: TextStyle(color: Colors.black, fontSize: text.scale(8)),
                                                    ),
                                                    SizedBox(
                                                      width: width / 41.1,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          mainVariables.pickedVideoSingle = null;
                                                          mainVariables.pickedImageSingle = null;
                                                          mainVariables.docSingle = null;
                                                          mainVariables.pickedFileSingle = null;
                                                          mainVariables.selectedUrlTypeSingle.value = "";
                                                        });
                                                      },
                                                      child: Container(
                                                          decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              color: Colors.white,
                                                              size: 12,
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                          mainVariables.docSingle == null
                                              ? const SizedBox()
                                              : Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      mainVariables.docSingle!.files[0].path!.split('/').last.toString(),
                                                      style: TextStyle(color: Colors.black, fontSize: text.scale(8)),
                                                    ),
                                                    SizedBox(
                                                      width: width / 41.1,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          mainVariables.pickedFileSingle = null;
                                                          mainVariables.docSingle = null;
                                                          mainVariables.pickedImageSingle = null;
                                                          mainVariables.pickedVideoSingle = null;
                                                          mainVariables.selectedUrlTypeSingle.value = "";
                                                        });
                                                      },
                                                      child: Container(
                                                          decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              color: Colors.white,
                                                              size: 12,
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                )
                                        ],
                                      ),
                              ),
                        SizedBox(
                          height: height / 57.73,
                        ),
                      ],
                    ))
              ],
            ),
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
          );
  }
}
