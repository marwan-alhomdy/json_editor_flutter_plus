library json_editor_flutter_plus;

import 'dart:convert';

import 'package:flutter/material.dart';

import 'constants/enum.dart';
import 'manager/json.manager.dart';
import 'widget/header_editor.widget.dart';
import 'widget/search_field.widget.dart';
import 'widget/text_editors.widget.dart';
import 'widget/tree_editors.widget.dart';

bool _enableMoreOptions = true;
bool _enableKeyEdit = true;
bool _enableValueEdit = true;

/// Edit your JSON object with this Widget. Create, edit and format objects
/// using this user friendly widget.
class JsonEditor extends StatefulWidget {
  /// JSON can be edited in two ways, Tree editor or text editor. You can disable
  /// either of them.
  ///
  /// When UI editor is active, you can disable adding/deleting keys by using
  /// [enableMoreOptions]. Editing keys and values can also be disabled by using
  /// [enableKeyEdit] and [enableValueEdit].
  ///
  /// When text editor is active, it will simply ignore [enableMoreOptions],
  /// [enableKeyEdit] and [enableValueEdit].
  ///
  /// [duration] is the debounce time for [onChanged] function. Defaults to
  /// 500 milliseconds.
  ///
  /// [editors] is the supported list of editors. First element will be
  /// used as default editor. Defaults to `[Editors.tree, Editors.text]`.
  const JsonEditor({
    super.key,
    required this.json,
    required this.onChanged,
    this.duration = const Duration(milliseconds: 500),
    this.enableMoreOptions = true,
    this.enableKeyEdit = true,
    this.enableValueEdit = true,
    this.editors = const [Editors.tree, Editors.text],
    this.themeColor,
    this.actions = const [],
    this.enableHorizontalScroll = false,
    this.searchDuration = const Duration(milliseconds: 500),
    this.hideEditorsMenuButton = false,
    this.expandedObjects = const [],
  }) : assert(editors.length > 0, "editors list cannot be empty");

  /// JSON string to be edited.
  final String json;

  /// Callback function that will be called with the new [dynamic] data.
  final ValueChanged<dynamic> onChanged;

  /// Debounce duration for [onChanged] function.
  final Duration duration;

  /// Enables more options like adding or deleting data. Defaults to `true`.
  final bool enableMoreOptions;

  /// Enables editing of keys. Defaults to `true`.
  final bool enableKeyEdit;

  /// Enables editing of values. Defaults to `true`.
  final bool enableValueEdit;

  /// Theme color for the editor. Changes the border color and header color.
  final Color? themeColor;

  /// List of supported editors. First element will be used as default editor.
  final List<Editors> editors;

  /// A list of Widgets to display in a row at the end of header.
  final List<Widget> actions;

  /// Enables horizontal scroll for the tree view. Defaults to `false`.
  final bool enableHorizontalScroll;

  /// Debounce duration for search function.
  final Duration searchDuration;

  /// Hides the option of changing editor. Defaults to `false`.
  final bool hideEditorsMenuButton;

  /// [expandedObjects] refers to the objects that will be expanded by
  /// default. Index can be provided when the data is a List.
  ///
  /// Examples:
  /// ```dart
  /// data = {
  ///   "hobbies": ["Reading books", "Playing Cricket"],
  ///   "education": [
  ///     {"name": "Bachelor of Engineering", "marks": 75},
  ///     {"name": "Master of Engineering", "marks": 72},
  ///   ],
  /// }
  /// ```
  ///
  /// For the given data
  /// 1. To expand education pass => `["education"]`
  /// 2. To expand hobbies and education pass => `["hobbies", "education"]`
  /// 3. To expand the first element (index 0) of education list, this means
  /// we need to expand education too. In this case you need not to pass
  /// "education" separately. Just pass a list of all nested objects =>
  /// `[["education", 0]]`
  ///
  /// ```dart
  /// JsonEditor(
  ///   expandedObjects: const [
  ///     "hobbies",
  ///     ["education", 0] // expands nested object in education
  ///   ],
  ///   onChanged: (_) {},
  ///   json: jsonEncode(data),
  /// )
  /// ```
  final List expandedObjects;

  @override
  State<JsonEditor> createState() => _JsonEditorState();
}

class _JsonEditorState extends State<JsonEditor> {
  // Timer? _timer;
  // Timer? _searchTimer;
  // late dynamic _data;
  // late final _themeColor = widget.themeColor ?? Theme.of(context).primaryColor;
  // late Editors _editor = widget.editors.first;
  // bool _onError = false;
  // bool? allExpanded;
  // late final _controller = TextEditingController()
  //   ..text = _stringifyData(_data, 0, true);
  // late final _scrollController = ScrollController();
  // final _matchedKeys = <String, bool>{};
  // final _matchedKeysLocation = <List>[];
  // int? _focusedKey;
  // int? _results;
  // late final _expandedObjects = <String, bool>{
  //   ["object"].toString(): true,
  //   if (widget.expandedObjects.isNotEmpty) ...getExpandedParents(),
  // };

  // Map<String, bool> getExpandedParents() {
  //   final map = <String, bool>{};
  //   for (var key in widget.expandedObjects) {
  //     if (key is List) {
  //       final newExpandList = ["object", ...key];
  //       for (int i = newExpandList.length - 1; i > 0; i--) {
  //         map[newExpandList.toString()] = true;
  //         newExpandList.removeLast();
  //       }
  //     } else {
  //       map[["object", key].toString()] = true;
  //     }
  //   }
  //   return map;
  // }

  // void callOnChanged() {
  //   if (_timer?.isActive ?? false) _timer?.cancel();

  //   _timer = Timer(widget.duration, () {
  //     widget.onChanged(jsonDecode(jsonEncode(_data)));
  //   });
  // }

  // void parseData(String value) {
  //   if (_timer?.isActive ?? false) _timer?.cancel();

  //   _timer = Timer(widget.duration, () {
  //     try {
  //       _data = jsonDecode(value);
  //       widget.onChanged(_data);
  //       setState(() {
  //         _onError = false;
  //       });
  //     } catch (_) {
  //       setState(() {
  //         _onError = true;
  //       });
  //     }
  //   });
  // }

  // void copyData() async {
  //   await Clipboard.setData(
  //     ClipboardData(text: jsonEncode(_data)),
  //   );
  // }

  // bool updateParentObjects(List newExpandList) {
  //   bool needsRebuilding = false;
  //   for (int i = newExpandList.length - 1; i >= 0; i--) {
  //     if (_expandedObjects[newExpandList.toString()] == null) {
  //       _expandedObjects[newExpandList.toString()] = true;
  //       needsRebuilding = true;
  //     }
  //     newExpandList.removeLast();
  //   }
  //   return needsRebuilding;
  // }

  // void findMatchingKeys(data, String text, List nestedParents) {
  //   if (data is Map) {
  //     final keys = data.keys.toList();
  //     for (var key in keys) {
  //       final keyName = key.toString();
  //       if (keyName.toLowerCase().contains(text)) {
  //         _results = _results! + 1;
  //         _matchedKeys[keyName] = true;
  //         _matchedKeysLocation.add([...nestedParents, key]);
  //       }
  //       if (data[key] is Map) {
  //         findMatchingKeys(data[key], text, [...nestedParents, key]);
  //       } else if (data[key] is List) {
  //         findMatchingKeys(data[key], text, [...nestedParents, key]);
  //       }
  //     }
  //   } else if (data is List) {
  //     for (int i = 0; i < data.length; i++) {
  //       final item = data[i];
  //       if (item is Map) {
  //         findMatchingKeys(item, text, [...nestedParents, i]);
  //       } else if (item is List) {
  //         findMatchingKeys(item, text, [...nestedParents, i]);
  //       }
  //     }
  //   }
  // }

  // void onSearch(String text) {
  //   if (_searchTimer?.isActive ?? false) _searchTimer?.cancel();

  //   _searchTimer = Timer(widget.searchDuration, () async {
  //     _matchedKeys.clear();
  //     _matchedKeysLocation.clear();
  //     _focusedKey = null;
  //     if (text.isEmpty) {
  //       setState(() {
  //         _results = null;
  //       });
  //     } else {
  //       _results = 0;
  //       findMatchingKeys(_data, text.toLowerCase(), ["object"]);
  //       setState(() {});
  //       if (_matchedKeys.isNotEmpty) {
  //         _focusedKey = 0;
  //         scrollTo(0);
  //       }
  //     }
  //   });
  // }

  // int getOffset(List toFind) {
  //   int offset = 1;
  //   bool keyFound = false;

  //   void calculateOffset(data, List parents, List toFind) {
  //     if (keyFound) return;
  //     if (data is Map) {
  //       for (var entry in data.entries) {
  //         if (keyFound) return;
  //         offset++;
  //         final newList = [...parents, entry.key];
  //         if (entry.key == toFind.last &&
  //             newList.toString() == toFind.toString()) {
  //           keyFound = true;
  //           return;
  //         }
  //         if (entry.value is Map || entry.value is List) {
  //           if (_expandedObjects[newList.toString()] == true && !keyFound) {
  //             calculateOffset(entry.value, newList, toFind);
  //           }
  //         }
  //       }
  //     } else if (data is List) {
  //       for (int i = 0; i < data.length; i++) {
  //         if (keyFound) return;
  //         offset++;
  //         if (data[i] is Map || data[i] is List) {
  //           final newList = [...parents, i];
  //           if (_expandedObjects[newList.toString()] == true && !keyFound) {
  //             calculateOffset(data[i], newList, toFind);
  //           }
  //         }
  //       }
  //     }
  //   }

  //   calculateOffset(_data, ["object"], toFind);
  //   return offset;
  // }

  // void scrollTo(int index) {
  //   final toFind = [..._matchedKeysLocation[index]];
  //   final needsRebuilding = updateParentObjects(
  //     [..._matchedKeysLocation[index]]..removeLast(),
  //   );
  //   if (needsRebuilding) setState(() {});
  //   Future.delayed(const Duration(milliseconds: 150), () {
  //     _scrollController.animateTo(
  //       (getOffset(toFind) * rowHeight) - 90,
  //       duration: const Duration(milliseconds: 200),
  //       curve: Curves.easeInOut,
  //     );
  //   });
  // }

  // void onSearchAction(SearchActions action) {
  //   if (_matchedKeys.isEmpty) return;
  //   if (action == SearchActions.next) {
  //     if (_focusedKey != null &&
  //         _matchedKeysLocation.length - 1 > _focusedKey!) {
  //       _focusedKey = _focusedKey! + 1;
  //     } else {
  //       _focusedKey = 0;
  //     }
  //   } else {
  //     if (_focusedKey != null && _focusedKey! > 0) {
  //       _focusedKey = _focusedKey! - 1;
  //     } else {
  //       _focusedKey = _matchedKeysLocation.length - 1;
  //     }
  //   }
  //   scrollTo(_focusedKey!);
  // }

  // void expandAllObjects(data, List expandedList) {
  //   if (data is Map) {
  //     for (var entry in data.entries) {
  //       if (entry.value is Map || entry.value is List) {
  //         final newList = [...expandedList, entry.key];
  //         _expandedObjects[newList.toString()] = true;
  //         expandAllObjects(entry.value, newList);
  //       }
  //     }
  //   } else if (data is List) {
  //     for (int i = 0; i < data.length; i++) {
  //       if (data[i] is Map || data[i] is List) {
  //         final newList = [...expandedList, i];
  //         _expandedObjects[newList.toString()] = true;
  //         expandAllObjects(data[i], newList);
  //       }
  //     }
  //   }
  // }

  late final JsonManager jsonManager;

  @override
  void initState() {
    super.initState();

    _enableMoreOptions = widget.enableMoreOptions;
    _enableKeyEdit = widget.enableKeyEdit;
    _enableValueEdit = widget.enableValueEdit;

    jsonManager = JsonManager(
      context,
      themeColor: widget.themeColor,
      data: jsonDecode(widget.json),
      editors: widget.editors,
      duration: widget.duration,
      searchDuration: widget.searchDuration,
      onChangedJson: widget.onChanged,
      setState: setState,
      expandedObjects: widget.expandedObjects,
    );
  }

  @override
  void dispose() {
    jsonManager.timer?.cancel();
    jsonManager.searchTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          width: jsonManager.onError ? 2 : 1,
          color: jsonManager.onError ? Colors.red : jsonManager.themeColor,
        ),
      ),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderEditorWidget(
                actions: widget.actions,
                jsonManager: jsonManager,
                hideEditorsMenuButton: widget.hideEditorsMenuButton,
                searchWidget: SearchFieldWidget(
                    onChanged: jsonManager.onSearch,
                    onAction: jsonManager.onSearchAction),
                onChangedEditor: (value) {
                  if (value == Editors.text) {
                    jsonManager.controller.text =
                        jsonManager.stringifyData(jsonManager.data, 0, true);
                  }
                  setState(() {
                    jsonManager.editor = value;
                  });
                },
                onExpandAll: () {
                  jsonManager.expandedObjects[["object"].toString()] = true;
                  jsonManager.expandAllObjects(jsonManager.data, ["object"]);
                  setState(() {});
                },
                onCollapseAll: () {
                  jsonManager.expandedObjects.clear();
                  setState(() {});
                },
                onFormat: () {
                  jsonManager.controller.text =
                      jsonManager.stringifyData(jsonManager.data, 0, true);
                }),
            if (jsonManager.editor == Editors.tree)
              Expanded(
                child: TreeEditorsWidget(
                  jsonManager: jsonManager,
                  enableHorizontalScroll: widget.enableHorizontalScroll,
                  enableMoreOptions: _enableMoreOptions,
                  enableKeyEdit: _enableKeyEdit,
                  enableValueEdit: _enableValueEdit,
                ),
              ),
            if (jsonManager.editor == Editors.text)
              Expanded(
                  child: TextEditorsWidget(
                controller: jsonManager.controller,
                onChanged: jsonManager.parseData,
              )),
          ],
        ),
      ),
    );
  }
}

// List<String> _getSpace(int count) {
//   if (count == 0) return ['', '  '];

//   String space = '';
//   for (int i = 0; i < count; i++) {
//     space += '  ';
//   }
//   return [space, '$space  '];
// }

// String _stringifyData(data, int spacing, [bool isLast = false]) {
//   String str = '';
//   final spaceList = _getSpace(spacing);
//   final objectSpace = spaceList[0];
//   final dataSpace = spaceList[1];

//   if (data is Map) {
//     str += '$objectSpace{';
//     str += '\n';
//     final keys = data.keys.toList();
//     for (int i = 0; i < keys.length; i++) {
//       str +=
//           '$dataSpace"${keys[i]}": ${_stringifyData(data[keys[i]], spacing + 1, i == keys.length - 1)}';
//       str += '\n';
//     }
//     str += '$objectSpace}';
//     if (!isLast) str += ',';
//   } else if (data is List) {
//     str += '$objectSpace[';
//     str += '\n';
//     for (int i = 0; i < data.length; i++) {
//       final item = data[i];
//       if (item is Map || item is List) {
//         str += _stringifyData(item, spacing + 1, i == data.length - 1);
//       } else {
//         str +=
//             '$dataSpace${_stringifyData(item, spacing + 1, i == data.length - 1)}';
//       }
//       str += '\n';
//     }
//     str += '$objectSpace]';
//     if (!isLast) str += ',';
//   } else {
//     if (data is String) {
//       str = '"$data"';
//     } else {
//       str = '$data';
//     }
//     if (!isLast) str += ',';
//   }

//   return str;
// }
