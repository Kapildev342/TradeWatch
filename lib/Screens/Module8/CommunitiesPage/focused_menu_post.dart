library focused_menu;

import 'dart:ui';

import 'package:flutter/material.dart';

class FocusedMenuHolder extends StatefulWidget {
  final Widget child;
  final double? menuItemExtent;
  final double? menuWidth;
  final List<FocusedMenuItem> menuItems;
  final bool? animateMenuItems;
  final BoxDecoration? menuBoxDecoration;
  final Function onPressed;
  final Duration? duration;
  final double? blurSize;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;
  final bool isMe;

  /// Open with tap instead of long press.
  final bool openWithTap;

  const FocusedMenuHolder(
      {Key? key,
      required this.child,
      required this.onPressed,
      required this.menuItems,
      this.duration,
      required this.isMe,
      this.menuBoxDecoration,
      this.menuItemExtent,
      this.animateMenuItems,
      this.blurSize,
      this.blurBackgroundColor,
      this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      this.openWithTap = false})
      : super(key: key);

  @override
  State<FocusedMenuHolder> createState() => _FocusedMenuHolderState();
}

class _FocusedMenuHolderState extends State<FocusedMenuHolder> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = const Offset(0, 0);
  Size? childSize;

  getOffset() {
    RenderBox renderBox = containerKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: containerKey,
        onTap: () async {
          widget.onPressed();
          if (widget.openWithTap) {
            await openMenu(context);
          }
        },
        onLongPress: () async {
          await widget.onPressed();
          if (!widget.openWithTap) {
            if (!mounted) {
              return;
            }
            await openMenu(context);
          }
        },
        child: widget.child);
  }

  Future openMenu(BuildContext context) async {
    getOffset();
    await Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: widget.duration ?? const Duration(milliseconds: 100),
            pageBuilder: (context, animation, secondaryAnimation) {
              animation = Tween(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(
                  opacity: animation,
                  child: FocusedMenuDetails(
                    isMean: widget.isMe,
                    itemExtent: widget.menuItemExtent,
                    menuBoxDecoration: widget.menuBoxDecoration,
                    childOffset: childOffset,
                    childSize: childSize,
                    menuItems: widget.menuItems,
                    blurSize: widget.blurSize,
                    menuWidth: widget.menuWidth,
                    blurBackgroundColor: widget.blurBackgroundColor,
                    animateMenu: widget.animateMenuItems ?? true,
                    bottomOffsetHeight: widget.bottomOffsetHeight ?? 0,
                    menuOffset: widget.menuOffset ?? 0,
                    child: widget.child,
                  ));
            },
            fullscreenDialog: true,
            opaque: false));
  }
}

class FocusedMenuDetails extends StatelessWidget {
  final List<FocusedMenuItem> menuItems;
  final BoxDecoration? menuBoxDecoration;
  final Offset childOffset;
  final double? itemExtent;
  final Size? childSize;
  final Widget child;
  final bool animateMenu;
  final bool isMean;
  final double? blurSize;
  final double? menuWidth;
  final Color? blurBackgroundColor;
  final double? bottomOffsetHeight;
  final double? menuOffset;

  const FocusedMenuDetails(
      {Key? key,
      required this.menuItems,
      required this.child,
      required this.childOffset,
      required this.childSize,
      required this.menuBoxDecoration,
      required this.itemExtent,
      required this.animateMenu,
      required this.blurSize,
      required this.blurBackgroundColor,
      required this.menuWidth,
      this.bottomOffsetHeight,
      this.menuOffset,
      required this.isMean})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final maxMenuHeight = size.height * 0.45;
    final listHeight = menuItems.length * (itemExtent ?? 50.0);
    final maxMenuWidth = menuWidth ?? (size.width * 0.70);
    final menuHeight = listHeight < maxMenuHeight ? listHeight : maxMenuHeight;
    const leftOffset = 5.0 /*(childOffset.dx+maxMenuWidth ) < size.width ? childOffset.dx: (childOffset.dx-maxMenuWidth+childSize!.width)*/;
    /*final topOffset =142.0*/ /* (childOffset.dy + menuHeight + childSize!.height) < size.height - bottomOffsetHeight! ? childOffset.dy + childSize!.height + menuOffset! : childOffset.dy - menuHeight - menuOffset!*/ /*;*/
    final topOffset = isMean
        ? (childOffset.dy + menuHeight + childSize!.height) <= (size.height - bottomOffsetHeight!)
            ? childOffset.dy + childSize!.height
            : childOffset.dy - menuHeight - (1.5 * menuOffset!)
        : (childOffset.dy + menuHeight + childSize!.height) <= (size.height - bottomOffsetHeight!)
            ? childOffset.dy + childSize!.height
            : childOffset.dy - menuHeight - menuOffset! - (menuOffset! / 2);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blurSize ?? 5, sigmaY: blurSize ?? 5),
                child: Container(
                  color: (blurBackgroundColor ?? Colors.white).withOpacity(0.3),
                ),
              )),
          Positioned(
              top: topOffset,
              left: isMean ? MediaQuery.of(context).size.width * 0.27 : leftOffset,
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 100),
                builder: (BuildContext context, dynamic value, Widget? child) {
                  return Transform.scale(
                    scale: value,
                    alignment: Alignment.center,
                    child: child,
                  );
                },
                tween: Tween(begin: 0.0, end: 1.0),
                child: Container(
                  margin: const EdgeInsets.all(15),
                  width: maxMenuWidth,
                  height: menuHeight,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      FocusedMenuItem item = menuItems[index];
                      Widget listItem = GestureDetector(
                          onTap: () {
                            //Navigator.pop(context);
                            item.onPressed();
                          },
                          child: Column(
                            children: [
                              Container(
                                  alignment: Alignment.center,
                                  height: itemExtent ?? 50.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        if (item.leadingIcon != null) ...[item.leadingIcon!],
                                        item.title,
                                        if (item.trailingIcon != null) ...[item.trailingIcon!]
                                      ],
                                    ),
                                  )),
                              Divider(
                                color: Theme.of(context).colorScheme.onBackground,
                                height: 1,
                                thickness: 1,
                              )
                            ],
                          ));
                      if (animateMenu) {
                        return listItem;
                      } else {
                        return listItem;
                      }
                    },
                  ),
                ),
              )),
          Positioned(
              top: childOffset.dy,
              left: childOffset.dx,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: AbsorbPointer(absorbing: true, child: SizedBox(width: childSize!.width, height: childSize!.height, child: child)),
              )),
        ],
      ),
    );
  }
}

class FocusedMenuItem {
  Color? backgroundColor;
  Widget title;
  Widget? trailingIcon;
  Widget? leadingIcon;
  Function onPressed;

  FocusedMenuItem({this.backgroundColor, required this.title, this.trailingIcon, this.leadingIcon, required this.onPressed});
}
