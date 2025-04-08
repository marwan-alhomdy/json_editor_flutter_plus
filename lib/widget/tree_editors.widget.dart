import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../manager/json.manager.dart';
import 'holder.widget.dart';

class TreeEditorsWidget extends StatelessWidget {
  const TreeEditorsWidget(
      {super.key,
      required this.jsonManager,
      required this.enableHorizontalScroll,
      required this.enableMoreOptions,
      required this.enableKeyEdit,
      required this.enableValueEdit});

  final JsonManager jsonManager;
  final bool enableHorizontalScroll;
  final bool enableMoreOptions;
  final bool enableKeyEdit;
  final bool enableValueEdit;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: jsonManager.scrollController,
      physics: const ClampingScrollPhysics(),
      child: wrapWithHorizontolScroll(
        HolderWidget(
          key: UniqueKey(),
          data: jsonManager.data,
          keyName: "object",
          paddingLeft: space,
          onChanged: jsonManager.callOnChanged,
          parentObject: {"object": jsonManager.data},
          setState: jsonManager.setState,
          matchedKeys: jsonManager.matchedKeys,
          allParents: const ["object"],
          expandedObjects: jsonManager.expandedObjects,
          enableMoreOptions: enableMoreOptions,
          enableKeyEdit: enableKeyEdit,
          enableValueEdit: enableValueEdit,
        ),
      ),
    );
  }

  Widget wrapWithHorizontolScroll(Widget child) {
    if (enableHorizontalScroll) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: child,
      );
    }
    return child;
  }
}
