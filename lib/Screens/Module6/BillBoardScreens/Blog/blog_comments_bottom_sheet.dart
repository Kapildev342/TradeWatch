import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tradewatchfinal/Edited_Packages/chewieLibrary/src/chewie_player.dart';
import 'package:tradewatchfinal/Screens/Module1/NewsPage/Demo/demo_view.dart';
import 'package:tradewatchfinal/Screens/Module1/bottom_navigation.dart';
import 'package:tradewatchfinal/Screens/Module3/Translation/SingleOne/translation_widget_bloc.dart';
import 'package:tradewatchfinal/Screens/Module4/full_screen_image_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardCommonFunctions/bill_board_widgets.dart';
import 'package:tradewatchfinal/Screens/Module6/BillBoardScreens/UserProfile/user_bill_board_profile_page.dart';
import 'package:tradewatchfinal/Screens/Module6/BillboardModels/bill_board_comments_model.dart';
import 'package:tradewatchfinal/Screens/Module6/WidgetsBloc/CommentLikeButton/comment_like_button_bloc.dart';
import 'package:video_player/video_player.dart';

class BlogCommentsBottomSheetPage extends StatefulWidget {
  final String responseId;
  final String billBoardPostUser;
  final String responsePostUser;
  final String category;

  const BlogCommentsBottomSheetPage({
    Key? key,
    required this.responseId,
    required this.billBoardPostUser,
    required this.responsePostUser,
    required this.category,
  }) : super(key: key);

  @override
  State<BlogCommentsBottomSheetPage> createState() => _BlogCommentsBottomSheetPageState();
}

class _BlogCommentsBottomSheetPageState extends State<BlogCommentsBottomSheetPage> {
  final List<String> _choose = [
    "Recent",
    "Most Liked",
    "Most Disliked",
  ];
  String selectedValue = "Recent";
  bool emptyBoolResponses = false;
  late BillBoardCommentsModel billboardComments;
  TextEditingController bottomSheetController = TextEditingController();
  bool loader = false;
  List<int> likeCountList = [];
  List<int> dislikeCountList = [];
  List<bool> likeList = [];
  List<bool> dislikeList = [];
  RxList<bool> isBelieved = RxList<bool>([]);
  List<String> titlesList = [];
  List<bool> translationList = [];
  List<ChewieController> commentsCvControllerList = [];

  @override
  void initState() {
    getData();
    getAllDataMain(name: 'BillBoard_Comments_Section');
    super.initState();
  }

  getData() async {
    context.read<CommentLikeButtonBloc>().add(const CommentLikeButtonListLoadingEvent());
    context.read<TranslationWidgetBloc>().add(const LoadingTranslationEvent());
    billboardComments = await billBoardApiMain.getBillBoardCommentsData(
      context: context,
      id: mainVariables.selectedBillboardIdMain.value,
      responseId: widget.responseId,
    );
    if (billboardComments.response.isNotEmpty) {
      emptyBoolResponses = false;
      isBelieved.clear();
      likeCountList.clear();
      dislikeCountList.clear();
      likeList.clear();
      dislikeList.clear();
      titlesList.clear();
      translationList.clear();
      for (int i = 0; i < billboardComments.response.length; i++) {
        isBelieved.add(billboardComments.response[i].believed);
        likeCountList.add(billboardComments.response[i].likesCount);
        dislikeCountList.add(billboardComments.response[i].disLikesCount);
        likeList.add(billboardComments.response[i].likes);
        dislikeList.add(billboardComments.response[i].dislikes);
        titlesList.add(billboardComments.response[i].message);
        translationList.add(billboardComments.response[i].translation);
        if (billboardComments.response[i].files.isNotEmpty) {
          commentsCvControllerList.add(await functionsMain.getVideoPlayer(
            url: billboardComments.response[i].files.first,
          ));
        } else {
          commentsCvControllerList.add(ChewieController(videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(""))));
        }
      }
    } else {
      emptyBoolResponses = true;
    }
    setState(() {
      loader = true;
    });
  }

  @override
  void dispose() {
    for (int i = 0; i < commentsCvControllerList.length; i++) {
      commentsCvControllerList[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextScaler text = MediaQuery.of(context).textScaler;
    return loader
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: width / 27.4, vertical: height / 57.73),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height / 57.73,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Comments",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: text.scale(16)),
                    ),
                    GestureDetector(
                        onTap: () async {
                          await billboardWidgetsMain.commentsFilterBottomSheet(context: context).then((value) {});
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: width / 34.25),
                          child: Image.asset(
                            "lib/Constants/Assets/BillBoard/Filter.png",
                            height: height / 57.73,
                            width: width / 27.4,
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: height / 57.73,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Response order",
                      style: TextStyle(fontSize: text.scale(12)),
                    ),
                    SizedBox(
                      width: width / 53.57,
                    ),
                    Icon(Icons.access_time, size: height / 37.5),
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
                              mainVariables.selectedCommentsSortTypeMain.value = selectedValue == "Recent"
                                  ? ""
                                  : selectedValue == "Most Liked"
                                      ? ""
                                      : selectedValue == "Most Disliked"
                                          ? ""
                                          : selectedValue == "Most Commented"
                                              ? ""
                                              : "";
                            });
                            // getResponses(forumId: _forumsResponse.response.id, type: selectedValue);
                          },
                          iconStyleData: IconStyleData(
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                              ),
                              iconSize: 20,
                              iconEnabledColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                              iconDisabledColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5)),
                          buttonStyleData: ButtonStyleData(height: height / 17.32, width: width / 3.28, elevation: 0),
                          menuItemStyleData: MenuItemStyleData(height: height / 21.65),
                          dropdownStyleData: DropdownStyleData(
                              maxHeight: height / 4.33,
                              width: width / 2.055,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Theme.of(context).colorScheme.background),
                              elevation: 8,
                              offset: const Offset(-20, 0)),
                          /*icon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          iconSize: 20,
                          iconEnabledColor: Colors.black.withOpacity(0.5),
                          iconDisabledColor: Colors.black.withOpacity(0.5),
                          buttonHeight: _height/17.32,
                          buttonWidth: _width/3.28,
                          buttonElevation: 0,
                          itemHeight: _height/21.65,
                          dropdownMaxHeight: _height/4.33,
                          dropdownWidth: _width/2.055,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          dropdownElevation: 8,
                          scrollbarRadius: const Radius.circular(40),
                          scrollbarThickness: 6,
                          scrollbarAlwaysShow: true,
                          offset: const Offset(-20, 0),*/
                        ),
                      ),
                    ),
                  ],
                ),
                emptyBoolResponses
                    ? const SizedBox()
                    : SizedBox(
                        height: height / 86.6,
                        width: width,
                      ),
                Expanded(
                  child: emptyBoolResponses
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(height: height / 57.73),
                              SizedBox(
                                  height: height / 5.77, width: width / 2.74, child: SvgPicture.asset("lib/Constants/Assets/SMLogos/no respone.svg")),
                              SizedBox(height: height / 86.6),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'No response to display...',
                                        style: TextStyle(fontFamily: "Poppins", color: const Color(0XFF0EA102), fontSize: text.scale(12))),
                                  ],
                                ),
                              ),
                              SizedBox(height: height / 57.73),
                            ],
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 4.0, spreadRadius: 0.0),
                            ],
                          ),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const ScrollPhysics(),
                            itemCount: billboardComments.response.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(top: index == 0.0 ? 15 : 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: width / 41.1),
                                      color: Theme.of(context).colorScheme.background,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          billboardWidgetsMain.getProfile(
                                            context: context,
                                            heightValue: height / 20.13,
                                            widthValue: width / 9.55,
                                            myself: false,
                                            avatar: billboardComments.response[index].users.avatar,
                                            userId: billboardComments.response[index].users.userId,
                                            isProfile: billboardComments.response[index].users.profileType,
                                          ),
                                          SizedBox(
                                            width: width / 41.1,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width / 1.35,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                              return UserBillBoardProfilePage(userId: billboardComments.response[index].users.userId)
                                                                  /*UserProfilePage(
                                                                      id:billboardComments
                                                                          .response[
                                                                      index]
                                                                          .users
                                                                          .userId,type:'forums',index:0)*/
                                                                  ;
                                                            }));
                                                          },
                                                          child: Text(
                                                            billboardComments.response[index].users.username,
                                                            style: TextStyle(
                                                                fontSize: text.scale(14), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: height / 173.2,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              billboardComments.response[index].createdAt,
                                                              style: TextStyle(
                                                                  fontSize: text.scale(10),
                                                                  color: const Color(0XFF737373),
                                                                  fontWeight: FontWeight.w400,
                                                                  fontFamily: "Poppins"),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        userIdMain != billboardComments.response[index].users.userId
                                                            ? billboardWidgetsMain.getBelieveButton(
                                                                heightValue: height / 33.76,
                                                                isBelieved: isBelieved,
                                                                billboardUserid: billboardComments.response[index].users.userId,
                                                                billboardUserName: billboardComments.response[index].users.username,
                                                                context: context,
                                                                modelSetState: setState,
                                                                index: index,
                                                                background: true,
                                                                believersCount: RxList.generate(billboardComments.response.length,
                                                                    (index) => billboardComments.response[index].users.believersCount),
                                                                isSearchData: false,
                                                              )
                                                            : const SizedBox(),
                                                        SizedBox(
                                                          width: width / 41.1,
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
                                                              billboardWidgetsMain.bottomSheet(
                                                                  context1: context,
                                                                  myself: userIdMain == billboardComments.response[index].users.userId,
                                                                  billboardId: mainVariables.selectedBillboardIdMain.value,
                                                                  billboardUserId: widget.billBoardPostUser,
                                                                  type: "comment",
                                                                  responseId: widget.responseId,
                                                                  responseUserId: widget.responsePostUser,
                                                                  commentId: billboardComments.response[index].id,
                                                                  commentUserId: billboardComments.response[index].users.userId,
                                                                  callFunction: getData,
                                                                  contentType: 'blog_comments',
                                                                  modelSetState: setState,
                                                                  responseDetail: billboardComments.response[index],
                                                                  category: widget.category,
                                                                  index: index);
                                                            },
                                                            child: Icon(
                                                              Icons.more_horiz,
                                                              color: Theme.of(context).colorScheme.onPrimary,
                                                              size: 25,
                                                            ))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: height / 50.75,
                                              ),
                                              SizedBox(
                                                  width: width / 1.7,
                                                  child: RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        children: spanList(
                                                            message: billboardComments.response[index].message.length > 200
                                                                ? billboardComments.response[index].message.substring(0, 200)
                                                                : billboardComments.response[index].message,
                                                            context: context)),
                                                  )),
                                              billboardComments.response[index].message.length > 200
                                                  ? SizedBox(
                                                      width: width / 1.4,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                showModalBottomSheet(
                                                                    shape: const RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.vertical(
                                                                        top: Radius.circular(30),
                                                                      ),
                                                                    ),
                                                                    context: context,
                                                                    isScrollControlled: true,
                                                                    isDismissible: false,
                                                                    enableDrag: false,
                                                                    builder: (BuildContext context) {
                                                                      return StatefulBuilder(
                                                                        builder: (BuildContext context, StateSetter modelSetState) {
                                                                          return SingleChildScrollView(
                                                                            child: Container(
                                                                              margin: EdgeInsets.symmetric(
                                                                                  horizontal: width / 27.4, vertical: height / 57.73),
                                                                              padding:
                                                                                  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    height: height / 54.13,
                                                                                  ),
                                                                                  Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          "Description",
                                                                                          style: TextStyle(
                                                                                              fontSize: text.scale(14), fontWeight: FontWeight.w600),
                                                                                        ),
                                                                                        IconButton(
                                                                                            onPressed: () {
                                                                                              if (!mounted) {
                                                                                                return;
                                                                                              }
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            icon: const Icon(
                                                                                              Icons.highlight_remove,
                                                                                              size: 25,
                                                                                            )),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: height / 54.13,
                                                                                  ),
                                                                                  Container(
                                                                                      padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                                                      width: width,
                                                                                      child: RichText(
                                                                                        textAlign: TextAlign.left,
                                                                                        text: TextSpan(
                                                                                            children: spanList(
                                                                                                message: billboardComments.response[index].message,
                                                                                                context: context)),
                                                                                      )),
                                                                                  SizedBox(
                                                                                    height: height / 50.75,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    });
                                                              },
                                                              child: Text(
                                                                "read more..",
                                                                style: TextStyle(
                                                                    color: const Color(0XFF0EA102),
                                                                    fontSize: text.scale(10),
                                                                    fontFamily: "Poppins",
                                                                    fontWeight: FontWeight.w400),
                                                              ))
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              SizedBox(
                                                height: height / 50.75,
                                              ),
                                              billboardComments.response[index].fileType == ""
                                                  ? const SizedBox()
                                                  : Row(
                                                      mainAxisAlignment: billboardComments.response[index].fileType == "doc"
                                                          ? MainAxisAlignment.start
                                                          : MainAxisAlignment.center,
                                                      children: [
                                                        billboardComments.response[index].fileType == ""
                                                            ? const SizedBox()
                                                            : billboardComments.response[index].fileType == "image"
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                        return FullScreenImage(
                                                                            imageUrl: billboardComments.response[index].files[0],
                                                                            tag: "generate_a_unique_tag");
                                                                      }));
                                                                    },
                                                                    child: Container(
                                                                        padding: const EdgeInsets.only(top: 8, right: 5),
                                                                        height: height / 6.76,
                                                                        width: width / 3.12,
                                                                        child: Image.network(
                                                                          billboardComments.response[index].files.first,
                                                                          fit: BoxFit.fill,
                                                                        )),
                                                                  )
                                                                : billboardComments.response[index].fileType == "video"
                                                                    ? billboardWidgetsMain.getVideoPlayer(
                                                                        cvController: commentsCvControllerList[index],
                                                                        heightValue: height / 5.4,
                                                                        widthValue: width / 1.45,
                                                                      )
                                                                    : billboardComments.response[index].fileType == "doc"
                                                                        ? Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: height / 86.6,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute<dynamic>(
                                                                                      builder: (_) => PDFViewerFromUrl(
                                                                                        url: billboardComments.response[index].files.first,
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    Container(
                                                                                      padding: EdgeInsets.symmetric(
                                                                                          horizontal: width / 41.1, vertical: height / 86.6),
                                                                                      decoration: BoxDecoration(
                                                                                          border: Border.all(
                                                                                              color: const Color(0xffD8D8D8).withOpacity(0.5))),
                                                                                      child: Text(
                                                                                        billboardComments.response[index].files.first
                                                                                            .split('/')
                                                                                            .last
                                                                                            .toString(),
                                                                                        style: TextStyle(
                                                                                            color: Theme.of(context).colorScheme.onPrimary,
                                                                                            fontSize: text.scale(13)),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(width: 5),
                                                                                    const Icon(
                                                                                      Icons.file_copy_outlined,
                                                                                      color: Colors.red,
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: height / 86.6,
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : const SizedBox(),
                                                      ],
                                                    ),
                                              /*Container(
                                        width: _width / 1.7,
                                        child: RichText(
                                          textAlign:
                                          TextAlign.left,
                                          text: TextSpan(
                                              children: spanList(
                                                  message:
                                                  billboardComments
                                                      .response[
                                                  index]
                                                      .message,
                                                  context: context)),
                                        ),
                                      ),*/
                                              SizedBox(
                                                height: height / 50.75,
                                              ),
                                              SizedBox(
                                                width: width / 1.4,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    billboardWidgetsMain.commentLikeButtonListWidget(
                                                      likeList: likeList,
                                                      id: mainVariables.selectedBillboardIdMain.value,
                                                      index: index,
                                                      context: context,
                                                      initFunction: getData,
                                                      modelSetState: setState,
                                                      notUse: true,
                                                      dislikeList: dislikeList,
                                                      likeCountList: likeCountList,
                                                      dislikeCountList: dislikeCountList,
                                                      type: 'comments',
                                                      image: "",
                                                      title: "",
                                                      description: "",
                                                      fromWhere: 'comments',
                                                      responseId: widget.responseId,
                                                      controller: bottomSheetController,
                                                      commentId: billboardComments.response[index].id,
                                                      postUserId: widget.billBoardPostUser,
                                                      responseUserId: widget.responsePostUser,
                                                      billBoardType: 'billboard',
                                                      repostUserName: billboardComments.response[index].users.username,
                                                      profileType: billboardComments.response[index].users.profileType,
                                                      tickerId: billboardComments.response[index].users.tickerId,
                                                      category: '',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    index == billboardComments.response.length - 1 ? const SizedBox() : const Divider(),
                                  ],
                                ),
                              );
                            },
                          )
                          /*Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              */ /*Container(
                                height: height / 57.73,
                                width: width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                ),
                              ),*/ /*
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const ScrollPhysics(),
                                itemCount: billboardComments.response.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: width / 41.1),
                                        color: Theme.of(context).colorScheme.background,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            billboardWidgetsMain.getProfile(
                                              context: context,
                                              heightValue: height / 20.13,
                                              widthValue: width / 9.55,
                                              myself: false,
                                              avatar: billboardComments.response[index].users.avatar,
                                              userId: billboardComments.response[index].users.userId,
                                              isProfile: billboardComments.response[index].users.profileType,
                                            ),
                                            SizedBox(
                                              width: width / 41.1,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: width / 1.35,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                return UserBillBoardProfilePage(
                                                                        userId: billboardComments.response[index].users.userId)
                                                                    */ /*UserProfilePage(
                                                                    id:billboardComments
                                                                        .response[
                                                                    index]
                                                                        .users
                                                                        .userId,type:'forums',index:0)*/ /*
                                                                    ;
                                                              }));
                                                            },
                                                            child: Text(
                                                              billboardComments.response[index].users.username,
                                                              style: TextStyle(
                                                                  fontSize: text.scale(14), fontWeight: FontWeight.w700, fontFamily: "Poppins"),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: height / 173.2,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                billboardComments.response[index].createdAt,
                                                                style: TextStyle(
                                                                    fontSize: text.scale(10),
                                                                    color: const Color(0XFF737373),
                                                                    fontWeight: FontWeight.w400,
                                                                    fontFamily: "Poppins"),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          userIdMain != billboardComments.response[index].users.userId
                                                              ? billboardWidgetsMain.getBelieveButton(
                                                                  heightValue: height / 33.76,
                                                                  isBelieved: isBelieved,
                                                                  billboardUserid: billboardComments.response[index].users.userId,
                                                                  billboardUserName: billboardComments.response[index].users.username,
                                                                  context: context,
                                                                  modelSetState: setState,
                                                                  index: index,
                                                                  background: true,
                                                                  believersCount: RxList.generate(billboardComments.response.length,
                                                                      (index) => billboardComments.response[index].users.believersCount),
                                                                  isSearchData: false,
                                                                )
                                                              : const SizedBox(),
                                                          SizedBox(
                                                            width: width / 41.1,
                                                          ),
                                                          GestureDetector(
                                                              onTap: () {
                                                                billboardWidgetsMain.bottomSheet(
                                                                    context1: context,
                                                                    myself: userIdMain == billboardComments.response[index].users.userId,
                                                                    billboardId: mainVariables.selectedBillboardIdMain.value,
                                                                    billboardUserId: widget.billBoardPostUser,
                                                                    type: "comment",
                                                                    responseId: widget.responseId,
                                                                    responseUserId: widget.responsePostUser,
                                                                    commentId: billboardComments.response[index].id,
                                                                    commentUserId: billboardComments.response[index].users.userId,
                                                                    callFunction: getData,
                                                                    contentType: 'blog_comments',
                                                                    modelSetState: setState,
                                                                    responseDetail: billboardComments.response[index],
                                                                    category: widget.category,
                                                                    index: index);
                                                              },
                                                              child: Icon(
                                                                Icons.more_horiz,
                                                                color: Theme.of(context).colorScheme.onPrimary,
                                                                size: 25,
                                                              ))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 50.75,
                                                ),
                                                SizedBox(
                                                    width: width / 1.7,
                                                    child: RichText(
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                          children: spanList(
                                                              message: billboardComments.response[index].message.length > 200
                                                                  ? billboardComments.response[index].message.substring(0, 200)
                                                                  : billboardComments.response[index].message,
                                                              context: context)),
                                                    )),
                                                billboardComments.response[index].message.length > 200
                                                    ? SizedBox(
                                                        width: width / 1.4,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            GestureDetector(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      shape: const RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.vertical(
                                                                          top: Radius.circular(30),
                                                                        ),
                                                                      ),
                                                                      context: context,
                                                                      isScrollControlled: true,
                                                                      isDismissible: false,
                                                                      enableDrag: false,
                                                                      builder: (BuildContext context) {
                                                                        return StatefulBuilder(
                                                                          builder: (BuildContext context, StateSetter modelSetState) {
                                                                            return SingleChildScrollView(
                                                                              child: Container(
                                                                                margin: EdgeInsets.symmetric(
                                                                                    horizontal: width / 27.4, vertical: height / 57.73),
                                                                                padding:
                                                                                    EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      height: height / 54.13,
                                                                                    ),
                                                                                    Container(
                                                                                      padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text(
                                                                                            "Description",
                                                                                            style: TextStyle(
                                                                                                fontSize: text.scale(14),
                                                                                                fontWeight: FontWeight.w600),
                                                                                          ),
                                                                                          IconButton(
                                                                                              onPressed: () {
                                                                                                if (!mounted) {
                                                                                                  return;
                                                                                                }
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              icon: const Icon(
                                                                                                Icons.highlight_remove,
                                                                                                size: 25,
                                                                                              )),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: height / 54.13,
                                                                                    ),
                                                                                    Container(
                                                                                        padding: EdgeInsets.symmetric(horizontal: width / 27.4),
                                                                                        width: width,
                                                                                        child: RichText(
                                                                                          textAlign: TextAlign.left,
                                                                                          text: TextSpan(
                                                                                              children: spanList(
                                                                                                  message: billboardComments.response[index].message,
                                                                                                  context: context)),
                                                                                        )),
                                                                                    SizedBox(
                                                                                      height: height / 50.75,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      });
                                                                },
                                                                child: Text(
                                                                  "read more..",
                                                                  style: TextStyle(
                                                                      color: const Color(0XFF0EA102),
                                                                      fontSize: text.scale(10),
                                                                      fontFamily: "Poppins",
                                                                      fontWeight: FontWeight.w400),
                                                                ))
                                                          ],
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                                SizedBox(
                                                  height: height / 50.75,
                                                ),
                                                billboardComments.response[index].fileType == ""
                                                    ? const SizedBox()
                                                    : Row(
                                                        mainAxisAlignment: billboardComments.response[index].fileType == "doc"
                                                            ? MainAxisAlignment.start
                                                            : MainAxisAlignment.center,
                                                        children: [
                                                          billboardComments.response[index].fileType == ""
                                                              ? const SizedBox()
                                                              : billboardComments.response[index].fileType == "image"
                                                                  ? GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                                          return FullScreenImage(
                                                                              imageUrl: billboardComments.response[index].files[0],
                                                                              tag: "generate_a_unique_tag");
                                                                        }));
                                                                      },
                                                                      child: Container(
                                                                          padding: const EdgeInsets.only(top: 8, right: 5),
                                                                          height: height / 6.76,
                                                                          width: width / 3.12,
                                                                          child: Image.network(
                                                                            billboardComments.response[index].files.first,
                                                                            fit: BoxFit.fill,
                                                                          )),
                                                                    )
                                                                  : billboardComments.response[index].fileType == "video"
                                                                      ? billboardWidgetsMain.getVideoPlayer(
                                                                          cvController: commentsCvControllerList[index],
                                                                          heightValue: height / 5.4,
                                                                          widthValue: width / 1.45,
                                                                        )
                                                                      : billboardComments.response[index].fileType == "doc"
                                                                          ? Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: height / 86.6,
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute<dynamic>(
                                                                                        builder: (_) => PDFViewerFromUrl(
                                                                                          url: billboardComments.response[index].files.first,
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.symmetric(
                                                                                            horizontal: width / 41.1, vertical: height / 86.6),
                                                                                        decoration: BoxDecoration(
                                                                                            border: Border.all(
                                                                                                color: const Color(0xffD8D8D8).withOpacity(0.5))),
                                                                                        child: Text(
                                                                                          billboardComments.response[index].files.first
                                                                                              .split('/')
                                                                                              .last
                                                                                              .toString(),
                                                                                          style: TextStyle(
                                                                                              color: Theme.of(context).colorScheme.onPrimary,
                                                                                              fontSize: text.scale(13)),
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(width: 5),
                                                                                      const Icon(
                                                                                        Icons.file_copy_outlined,
                                                                                        color: Colors.red,
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: height / 86.6,
                                                                                ),
                                                                              ],
                                                                            )
                                                                          : const SizedBox(),
                                                        ],
                                                      ),
                                                */ /*Container(
                                      width: _width / 1.7,
                                      child: RichText(
                                        textAlign:
                                        TextAlign.left,
                                        text: TextSpan(
                                            children: spanList(
                                                message:
                                                billboardComments
                                                    .response[
                                                index]
                                                    .message,
                                                context: context)),
                                      ),
                                    ),*/ /*
                                                SizedBox(
                                                  height: height / 50.75,
                                                ),
                                                SizedBox(
                                                  width: width / 1.4,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      billboardWidgetsMain.commentLikeButtonListWidget(
                                                        likeList: likeList,
                                                        id: mainVariables.selectedBillboardIdMain.value,
                                                        index: index,
                                                        context: context,
                                                        initFunction: getData,
                                                        modelSetState: setState,
                                                        notUse: true,
                                                        dislikeList: dislikeList,
                                                        likeCountList: likeCountList,
                                                        dislikeCountList: dislikeCountList,
                                                        type: 'comments',
                                                        image: "",
                                                        title: "",
                                                        description: "",
                                                        fromWhere: 'comments',
                                                        responseId: widget.responseId,
                                                        controller: bottomSheetController,
                                                        commentId: billboardComments.response[index].id,
                                                        postUserId: widget.billBoardPostUser,
                                                        responseUserId: widget.responsePostUser,
                                                        billBoardType: 'billboard',
                                                        repostUserName: billboardComments.response[index].users.username,
                                                        profileType: billboardComments.response[index].users.profileType,
                                                        tickerId: billboardComments.response[index].users.tickerId,
                                                        category: '',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      index == billboardComments.response.length - 1 ? const SizedBox() : const Divider(),
                                    ],
                                  );
                                },
                              ),
                              */ /* Container(
                                height: height / 34.64,
                                width: width,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    )),
                              ),*/ /*
                            ],
                          )*/
                          ,
                        ),
                ),
              ],
            ),
          )
        : Center(
            child: Lottie.asset('lib/Constants/Assets/SMLogos/loading.json', height: height / 8.66, width: width / 4.11),
          );
  }

  List<TextSpan> spanList({required String message, required BuildContext context}) {
    TextScaler text = MediaQuery.of(context).textScaler;
    List<TextSpan> textSpan = [];
    List<String> newSplit = message.split(' ');
    for (int i = 0; i < newSplit.length; i++) {
      if (newSplit[i].contains("+")) {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(color: const Color(0XFF0EA102), fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w400),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                //   getValuesData(value: newSplit[i].substring(1));
              }));
      } else if ((RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?"))
          .hasMatch(newSplit[i])) {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(
                color: Colors.blue,
                fontSize: text.scale(14),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DemoPage(url: newSplit[i], text: "", image: "", id: "", type: "", activity: false)));*/
                //getValuesData(value: newSplit[i].substring(1));
                Get.to(const DemoView(), arguments: {"id": "", "type": "", "url": newSplit[i]});
              }));
      } else {
        textSpan.add(TextSpan(
            text: "${newSplit[i]} ",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary, fontSize: text.scale(14), fontFamily: "Poppins", fontWeight: FontWeight.w400)));
      }
    }
    return textSpan;
  }
}
