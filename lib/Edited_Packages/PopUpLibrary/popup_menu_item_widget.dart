import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'popup_menu.dart';
import 'popup_menu_item.dart';

class MenuItemWidget extends StatefulWidget {
  final MenuItemProvider item;
  final bool showLine;
  final Color lineColor;
  final Color backgroundColor;
  final Color highlightColor;
  final Widget? listTileWidget;
  final Function(MenuItemProvider item) clickCallback;

  const MenuItemWidget({
    Key? key,
    required this.item,
    this.showLine = false,
    required this.clickCallback,
    required this.lineColor,
    required this.backgroundColor,
    required this.highlightColor,
    this.listTileWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MenuItemWidgetState();
  }
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  var highlightColor = const Color(0x55000000);
  var color = const Color(0xff232323);
  bool itemWaiting = false;
  @override
  void initState() {
    color = widget.backgroundColor;
    highlightColor = widget.highlightColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          color = highlightColor;
        });
      },
      onTapUp: (details) {
        setState(() {
          color = widget.backgroundColor;
        });
      },
      onLongPressEnd: (details) {
        setState(() {
          color = widget.backgroundColor;
        });
      },
      onTap: () {
        // widget.item.clickAction();
        setState(() {
          itemWaiting = true;
        });
        widget.clickCallback(widget.item);
      },
      child: Container(
        width: PopupMenu.itemWidth,
        height: PopupMenu.itemHeight,
        decoration: BoxDecoration(
          color: color,
          border: Border(
            right: BorderSide(
              color: widget.showLine ? widget.lineColor : Colors.transparent,
            ),
          ),
        ),
        child: _createContent(),
      ),
    );
  }

  Widget _createContent() {
    if(widget.item.menuListTile!=null){
     return Center(child: Material(
         color: Colors.transparent,
         child: widget.item.menuListTile??Container(height: 15,
           width: 200,color: Colors.red,)));
    }
    else if (widget.item.menuImage != null) {
      // image and text
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 30.0,
            height: 30.0,
            child: AnimatedSwitcher(
              child: itemWaiting
                  ? CupertinoActivityIndicator(
                      color: Color.fromRGBO(
                        255 - widget.backgroundColor.red,
                        255 - widget.backgroundColor.green,
                        255 - widget.backgroundColor.blue,
                        1,
                      ),
                    )
                  : widget.item.menuImage,
              duration: const Duration(milliseconds: 100),
            ),
          ),
          SizedBox(
            height: 22.0,
            child: Material(
              color: Colors.transparent,
              child: Text(
                widget.item.menuTitle,
                style: widget.item.menuTextStyle,
              ),
            ),
          )
        ],
      );
    }
    else {
      // only text
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Text(
            widget.item.menuTitle,
            style: widget.item.menuTextStyle,
            textAlign: widget.item.menuTextAlign,
          ),
        ),
      );
    }
  }
}
