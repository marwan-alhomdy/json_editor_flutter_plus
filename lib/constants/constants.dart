import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_editor_flutter_plus/constants/enum.dart';

const space = 18.0;

const textStyle = TextStyle(fontSize: 16);
const options = Icon(Icons.more_horiz, color: Colors.orange, size: 16);
const expandIconWidth = 10.0;
const rowHeight = 30.0;
const popupMenuHeight = 30.0;
const popupMenuItemPadding = 20.0;
const textSpacer = SizedBox(width: 5);
const newKey = "new_key_added";

const downArrow = SizedBox(
  width: expandIconWidth,
  child: Icon(
    CupertinoIcons.arrowtriangle_down_fill,
    color: Colors.indigoAccent,
    size: 14,
  ),
);

const rightArrow = SizedBox(
  width: expandIconWidth,
  child: Icon(CupertinoIcons.arrowtriangle_right_fill,
      color: Colors.cyan, size: 14),
);

const newDataValue = {
  OptionItems.string: "",
  OptionItems.bool: false,
  OptionItems.num: 0,
};
