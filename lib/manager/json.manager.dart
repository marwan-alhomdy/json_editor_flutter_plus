import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';
import '../constants/enum.dart';

class JsonManager {
  JsonManager(
    BuildContext context, {
    required this.data,
    required this.editors,
    required List expandedObjects,
    required this.duration,
    required this.searchDuration,
    required this.setState,
    required this.onChangedJson,
    Color? themeColor,
  }) {
    this.themeColor = themeColor ?? Theme.of(context).primaryColor;
    editor = editors.first;
    controller.text = stringifyData(data, 0, true);
    expandedObjectsList = expandedObjects;
    this.expandedObjects = <String, bool>{
      ["object"].toString(): true,
      if (expandedObjects.isNotEmpty) ...getExpandedParents(),
    };
  }

  final Duration duration;
  final Duration searchDuration;
  final Function(VoidCallback) setState;
  final ValueChanged<dynamic> onChangedJson;

  late final Color themeColor;
  late Editors editor;

  final List<Editors> editors;
  late dynamic data;

  Timer? timer;
  Timer? searchTimer;

  bool onError = false;
  bool? allExpanded;

  int? _focusedKey;
  int? results;

  final controller = TextEditingController();
  final scrollController = ScrollController();

  final matchedKeys = <String, bool>{};
  final matchedKeysLocation = <List>[];

  late final List expandedObjectsList;
  late final Map<String, bool> expandedObjects;

  Map<String, bool> getExpandedParents() {
    final map = <String, bool>{};
    for (var key in expandedObjectsList) {
      if (key is List) {
        final newExpandList = ["object", ...key];
        for (int i = newExpandList.length - 1; i > 0; i--) {
          map[newExpandList.toString()] = true;
          newExpandList.removeLast();
        }
      } else {
        map[["object", key].toString()] = true;
      }
    }
    return map;
  }

  void callOnChanged() {
    if (timer?.isActive ?? false) timer?.cancel();

    timer = Timer(duration, () {
      onChangedJson(jsonDecode(jsonEncode(data)));
    });
  }

  void parseData(String value) {
    if (timer?.isActive ?? false) timer?.cancel();

    timer = Timer(duration, () {
      try {
        data = jsonDecode(value);
        onChangedJson(data);
        setState(() {
          onError = false;
        });
      } catch (_) {
        setState(() {
          onError = true;
        });
      }
    });
  }

  void copyData() async {
    await Clipboard.setData(
      ClipboardData(text: jsonEncode(data)),
    );
  }

  bool updateParentObjects(List newExpandList) {
    bool needsRebuilding = false;
    for (int i = newExpandList.length - 1; i >= 0; i--) {
      if (expandedObjects[newExpandList.toString()] == null) {
        expandedObjects[newExpandList.toString()] = true;
        needsRebuilding = true;
      }
      newExpandList.removeLast();
    }
    return needsRebuilding;
  }

  void findMatchingKeys(data, String text, List nestedParents) {
    if (data is Map) {
      final keys = data.keys.toList();
      for (var key in keys) {
        final keyName = key.toString();
        if (keyName.toLowerCase().contains(text)) {
          results = results! + 1;
          matchedKeys[keyName] = true;
          matchedKeysLocation.add([...nestedParents, key]);
        }
        if (data[key] is Map) {
          findMatchingKeys(data[key], text, [...nestedParents, key]);
        } else if (data[key] is List) {
          findMatchingKeys(data[key], text, [...nestedParents, key]);
        }
      }
    } else if (data is List) {
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        if (item is Map) {
          findMatchingKeys(item, text, [...nestedParents, i]);
        } else if (item is List) {
          findMatchingKeys(item, text, [...nestedParents, i]);
        }
      }
    }
  }

  void onSearch(String text) {
    if (searchTimer?.isActive ?? false) searchTimer?.cancel();

    searchTimer = Timer(searchDuration, () async {
      matchedKeys.clear();
      matchedKeysLocation.clear();
      _focusedKey = null;
      if (text.isEmpty) {
        setState(() {
          results = null;
        });
      } else {
        results = 0;
        findMatchingKeys(data, text.toLowerCase(), ["object"]);
        setState(() {});
        if (matchedKeys.isNotEmpty) {
          _focusedKey = 0;
          scrollTo(0);
        }
      }
    });
  }

  int getOffset(List toFind) {
    int offset = 1;
    bool keyFound = false;

    void calculateOffset(data, List parents, List toFind) {
      if (keyFound) return;
      if (data is Map) {
        for (var entry in data.entries) {
          if (keyFound) return;
          offset++;
          final newList = [...parents, entry.key];
          if (entry.key == toFind.last &&
              newList.toString() == toFind.toString()) {
            keyFound = true;
            return;
          }
          if (entry.value is Map || entry.value is List) {
            if (expandedObjects[newList.toString()] == true && !keyFound) {
              calculateOffset(entry.value, newList, toFind);
            }
          }
        }
      } else if (data is List) {
        for (int i = 0; i < data.length; i++) {
          if (keyFound) return;
          offset++;
          if (data[i] is Map || data[i] is List) {
            final newList = [...parents, i];
            if (expandedObjects[newList.toString()] == true && !keyFound) {
              calculateOffset(data[i], newList, toFind);
            }
          }
        }
      }
    }

    calculateOffset(data, ["object"], toFind);
    return offset;
  }

  void scrollTo(int index) {
    final toFind = [...matchedKeysLocation[index]];
    final needsRebuilding = updateParentObjects(
      [...matchedKeysLocation[index]]..removeLast(),
    );
    if (needsRebuilding) setState(() {});
    Future.delayed(const Duration(milliseconds: 150), () {
      scrollController.animateTo(
        (getOffset(toFind) * rowHeight) - 90,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  void onSearchAction(SearchActions action) {
    if (matchedKeys.isEmpty) return;
    if (action == SearchActions.next) {
      if (_focusedKey != null &&
          matchedKeysLocation.length - 1 > _focusedKey!) {
        _focusedKey = _focusedKey! + 1;
      } else {
        _focusedKey = 0;
      }
    } else {
      if (_focusedKey != null && _focusedKey! > 0) {
        _focusedKey = _focusedKey! - 1;
      } else {
        _focusedKey = matchedKeysLocation.length - 1;
      }
    }
    scrollTo(_focusedKey!);
  }

  void expandAllObjects(data, List expandedList) {
    if (data is Map) {
      for (var entry in data.entries) {
        if (entry.value is Map || entry.value is List) {
          final newList = [...expandedList, entry.key];
          expandedObjects[newList.toString()] = true;
          expandAllObjects(entry.value, newList);
        }
      }
    } else if (data is List) {
      for (int i = 0; i < data.length; i++) {
        if (data[i] is Map || data[i] is List) {
          final newList = [...expandedList, i];
          expandedObjects[newList.toString()] = true;
          expandAllObjects(data[i], newList);
        }
      }
    }
  }

  List<String> _getSpace(int count) {
    if (count == 0) return ['', '  '];

    String space = '';
    for (int i = 0; i < count; i++) {
      space += '  ';
    }
    return [space, '$space  '];
  }

  String stringifyData(data, int spacing, [bool isLast = false]) {
    String str = '';
    final spaceList = _getSpace(spacing);
    final objectSpace = spaceList[0];
    final dataSpace = spaceList[1];

    if (data is Map) {
      str += '$objectSpace{';
      str += '\n';
      final keys = data.keys.toList();
      for (int i = 0; i < keys.length; i++) {
        str +=
            '$dataSpace"${keys[i]}": ${stringifyData(data[keys[i]], spacing + 1, i == keys.length - 1)}';
        str += '\n';
      }
      str += '$objectSpace}';
      if (!isLast) str += ',';
    } else if (data is List) {
      str += '$objectSpace[';
      str += '\n';
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        if (item is Map || item is List) {
          str += stringifyData(item, spacing + 1, i == data.length - 1);
        } else {
          str +=
              '$dataSpace${stringifyData(item, spacing + 1, i == data.length - 1)}';
        }
        str += '\n';
      }
      str += '$objectSpace]';
      if (!isLast) str += ',';
    } else {
      if (data is String) {
        str = '"$data"';
      } else {
        str = '$data';
      }
      if (!isLast) str += ',';
    }

    return str;
  }
}
