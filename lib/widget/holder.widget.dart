import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/enum.dart';
import 'popup_menu.widget.dart';
import 'replace_text_with_field.widget.dart';

class HolderWidget extends StatefulWidget {
  const HolderWidget({
    super.key,
    this.keyName,
    required this.data,
    required this.paddingLeft,
    required this.onChanged,
    required this.parentObject,
    required this.setState,
    required this.matchedKeys,
    required this.allParents,
    required this.expandedObjects,
    required this.enableMoreOptions,
    required this.enableKeyEdit,
    required this.enableValueEdit,
  });

  final dynamic keyName;
  final dynamic data;
  final double paddingLeft;
  final VoidCallback onChanged;
  final dynamic parentObject;
  final StateSetter setState;
  final Map<String, bool> matchedKeys;
  final List allParents;
  final Map<String, bool> expandedObjects;

  final bool enableMoreOptions;
  final bool enableKeyEdit;
  final bool enableValueEdit;

  @override
  State<HolderWidget> createState() => _HolderState();
}

class _HolderState extends State<HolderWidget> {
  late bool isExpanded =
      widget.expandedObjects[widget.allParents.toString()] == true;

  void _toggleState() {
    if (!isExpanded) {
      widget.expandedObjects[widget.allParents.toString()] = true;
    } else {
      widget.expandedObjects.remove(widget.allParents.toString());
    }
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void onSelected(OptionItems selectedItem) {
    if (selectedItem == OptionItems.delete) {
      if (widget.parentObject is Map) {
        widget.parentObject.remove(widget.keyName);
      } else {
        widget.parentObject.removeAt(widget.keyName);
      }

      widget.setState(() {});
    } else if (selectedItem == OptionItems.map) {
      if (widget.data is Map) {
        widget.data[newKey] = {};
      } else {
        widget.data.add({});
      }

      setState(() {});
    } else if (selectedItem == OptionItems.list) {
      if (widget.data is Map) {
        widget.data[newKey] = [];
      } else {
        widget.data.add([]);
      }

      setState(() {});
    } else {
      if (widget.data is Map) {
        widget.data[newKey] = newDataValue[selectedItem];
      } else {
        widget.data.add(newDataValue[selectedItem]);
      }

      setState(() {});
    }

    widget.onChanged();
  }

  void onKeyChanged(Object key) {
    final val = widget.parentObject.remove(widget.keyName);
    widget.parentObject[key] = val;

    widget.onChanged();
    widget.setState(() {});
  }

  void onValueChanged(Object value) {
    widget.parentObject[widget.keyName] = value;

    widget.onChanged();
  }

  Widget wrapWithColoredBox(Widget child, String key) {
    if (widget.matchedKeys[key] == true) {
      return ColoredBox(color: Colors.yellow, child: child);
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data is Map) {
      final mapWidget = <Widget>[];

      final List keys = widget.data.keys.toList();
      for (var key in keys) {
        mapWidget.add(HolderWidget(
          key: Key(key),
          data: widget.data[key],
          keyName: key,
          onChanged: widget.onChanged,
          parentObject: widget.data,
          paddingLeft: widget.paddingLeft + space,
          setState: setState,
          matchedKeys: widget.matchedKeys,
          allParents: [...widget.allParents, key],
          expandedObjects: widget.expandedObjects,
          enableMoreOptions: widget.enableMoreOptions,
          enableKeyEdit: widget.enableKeyEdit,
          enableValueEdit: widget.enableValueEdit,
        ));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: rowHeight,
            child: Row(
              children: [
                const SizedBox(width: expandIconWidth),
                if (widget.enableMoreOptions) OptionsWidget<Map>(onSelected),
                SizedBox(width: widget.paddingLeft),
                InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: _toggleState,
                  child: isExpanded ? downArrow : rightArrow,
                ),
                const SizedBox(width: expandIconWidth),
                if (widget.enableKeyEdit && widget.parentObject is! List) ...[
                  ReplaceTextWithField(
                    key: Key(widget.keyName.toString()),
                    initialValue: widget.keyName,
                    isKey: true,
                    onChanged: onKeyChanged,
                    setState: setState,
                    isHighlighted:
                        widget.matchedKeys["${widget.keyName}"] == true,
                  ),
                  textSpacer,
                  _BracketedText("${widget.data.length}"),
                ] else
                  InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: _toggleState,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        wrapWithColoredBox(
                          Text("${widget.keyName}", style: textStyle),
                          "${widget.keyName}",
                        ),
                        textSpacer,
                        _BracketedText("${widget.data.length}"),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (isExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: mapWidget,
            ),
        ],
      );
    } else if (widget.data is List) {
      final listWidget = <Widget>[];

      for (int i = 0; i < widget.data.length; i++) {
        listWidget.add(HolderWidget(
          key: Key(i.toString()),
          keyName: i,
          data: widget.data[i],
          onChanged: widget.onChanged,
          parentObject: widget.data,
          paddingLeft: widget.paddingLeft + space,
          setState: setState,
          matchedKeys: widget.matchedKeys,
          allParents: [...widget.allParents, i],
          expandedObjects: widget.expandedObjects,
          enableMoreOptions: widget.enableMoreOptions,
          enableKeyEdit: widget.enableKeyEdit,
          enableValueEdit: widget.enableValueEdit,
        ));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: rowHeight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: expandIconWidth),
                if (widget.enableMoreOptions) OptionsWidget<List>(onSelected),
                SizedBox(width: widget.paddingLeft),
                InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: _toggleState,
                  child: isExpanded ? downArrow : rightArrow,
                ),
                const SizedBox(width: expandIconWidth),
                if (widget.enableKeyEdit && widget.parentObject is! List) ...[
                  ReplaceTextWithField(
                    key: Key(widget.keyName.toString()),
                    initialValue: widget.keyName,
                    isKey: true,
                    onChanged: onKeyChanged,
                    setState: setState,
                    isHighlighted:
                        widget.matchedKeys["${widget.keyName}"] == true,
                  ),
                  textSpacer,
                  _BracketedText("${widget.data.length}", isList: true),
                ] else
                  InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: _toggleState,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        wrapWithColoredBox(
                          Text("${widget.keyName}", style: textStyle),
                          "${widget.keyName}",
                        ),
                        textSpacer,
                        _BracketedText("${widget.data.length}", isList: true),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (isExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: listWidget,
            ),
        ],
      );
    } else {
      return SizedBox(
        height: rowHeight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: expandIconWidth),
            if (widget.enableMoreOptions) OptionsWidget<String>(onSelected),
            SizedBox(
              width: widget.paddingLeft + (expandIconWidth * 2),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.enableKeyEdit) ...[
                  ReplaceTextWithField(
                    key: Key(widget.keyName.toString()),
                    initialValue: widget.keyName,
                    isKey: true,
                    onChanged: onKeyChanged,
                    setState: setState,
                    isHighlighted:
                        widget.matchedKeys["${widget.keyName}"] == true,
                  ),
                  Text(' :',
                      style: textStyle.copyWith(
                        color: Colors.deepOrangeAccent,
                      )),
                ] else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      wrapWithColoredBox(
                        Text("${widget.keyName}", style: textStyle),
                        "${widget.keyName}",
                      ),
                      textSpacer,
                      const Text(" :", style: textStyle),
                    ],
                  ),
                textSpacer,
                if (widget.enableValueEdit) ...[
                  ReplaceTextWithField(
                    key: UniqueKey(),
                    initialValue: widget.data,
                    onChanged: onValueChanged,
                    setState: setState,
                  ),
                  textSpacer,
                ] else ...[
                  Text(widget.data.toString(), style: textStyle),
                  textSpacer,
                ],
              ],
            ),
          ],
        ),
      );
    }
  }
}

class _BracketedText extends StatelessWidget {
  final String name;
  final bool isList;

  const _BracketedText(this.name, {Key? key, this.isList = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: isList ? '[' : '{'),
          TextSpan(
            text: name,
            style: const TextStyle(color: Colors.blueAccent),
          ),
          TextSpan(text: isList ? ']' : '}'),
        ],
        style: TextStyle(color: isList ? Colors.deepPurple : Colors.deepOrange),
      ),
    );
  }
}
