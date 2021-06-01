import 'dart:convert';

import 'package:chess_clock/models/time_control.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeControlProvider with ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TimeControlProvider();

  clearAll() async {
    final SharedPreferences prefs = await _prefs;

    prefs.clear();
    notifyListeners();
  }

  Future<void> add(TimeControl control) async {
    final SharedPreferences prefs = await _prefs;

    List<String> strs = prefs.getStringList('controls');
    List<TimeControl> controls = _strToControl(strs);
    controls.add(control);
    strs = _controlsToString(controls);

    prefs.setStringList('controls', strs);

    notifyListeners();
  }

  Future<List<TimeControl>> timeControls() async {
    final SharedPreferences prefs = await _prefs;

    List<String> strs = prefs.getStringList('controls');

    return _strToControl(strs);
  }

  List<TimeControl> _strToControl(List<String> jsonStrs) {
    List<TimeControl> controls = [];

    if (jsonStrs == null) {
      return [];
    }

    for (int i = 0; i < jsonStrs.length; i++) {
      String jsonStr = jsonStrs[i];
      var obj = jsonDecode(jsonStr);
      try {
        // print(obj.runtimeType);
        // TimeControl control = TimeControl.fromJson(obj);
        controls.add(TimeControl.fromJson(obj));
      } catch (e) {
        print('ERROR: $e');
      }

      // controls.add(TimeControl.fromJSON(jsonDecode(strs[i])));
    }

    return controls;
  }

  List<String> _controlsToString(List<TimeControl> controls) {
    List<String> strs = [];

    for (int i = 0; i < controls.length; i++) {
      strs.add(jsonEncode(controls[i].toJson()));
    }

    return strs;
  }
}