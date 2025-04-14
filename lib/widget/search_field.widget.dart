import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../constants/enum.dart';

class SearchFieldWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<SearchActions> onAction;

  const SearchFieldWidget({
    super.key,
    required this.onChanged,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(width: 5),
          const Icon(CupertinoIcons.search, size: 20),
          const SizedBox(width: 5),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              autocorrect: false,
              cursorWidth: 1,
              style: textStyle,
              cursorHeight: 12,
              decoration: const InputDecoration(
                hintText: "Search keys",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                constraints: BoxConstraints(maxWidth: 100),
                border: InputBorder.none,
                fillColor: Colors.transparent,
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.all(3),
                focusedBorder: InputBorder.none,
                hoverColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
              height: 40.0,
              width: 35.0,
              child: IconButton(
                onPressed: () => onAction(SearchActions.next),
                tooltip: 'Next',
                iconSize: 15,
                constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
                icon: const Icon(CupertinoIcons.arrowtriangle_down_fill),
              )),
          SizedBox(
              height: 40.0,
              width: 35.0,
              child: IconButton(
                onPressed: () => onAction(SearchActions.prev),
                tooltip: 'Previous',
                iconSize: 15,
                constraints: const BoxConstraints(maxHeight: 30, maxWidth: 30),
                icon: const Icon(CupertinoIcons.arrowtriangle_up_fill),
              )),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
