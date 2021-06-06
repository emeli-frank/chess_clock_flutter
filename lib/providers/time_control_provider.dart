import 'dart:convert';

import 'package:chess_clock/models/time_control.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeControlProvider with ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // int selectedIndex;

  Future<int> get selectedIndex async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getInt('selectedControlIndex');
  }

  Future<TimeControl> get selected async {
    final controls = await timeControls();
    return controls[await selectedIndex];
  }

  TimeControlProvider();

  Future<void> add(TimeControl control) async {
    final SharedPreferences prefs = await _prefs;

    List<String> strs = prefs.getStringList('controls');
    List<TimeControl> controls = _strToControl(strs);
    controls.add(control);
    strs = _controlsToString(controls);

    await prefs.setStringList('controls', strs);

    notifyListeners();
  }

  Future<void> update(int index, TimeControl control) async {
    final SharedPreferences prefs = await _prefs;

    List<String> strs = prefs.getStringList('controls');
    List<TimeControl> controls = _strToControl(strs);

    try {
      controls[index] = control;
    } catch (e) {
      throw e;
    }

    strs = _controlsToString(controls);

    await prefs.setStringList('controls', strs);

    notifyListeners();
  }

  delete(int index) async {
    final SharedPreferences prefs = await _prefs;

    final controls = await timeControls();
    try {
      controls.removeAt(index);
    } catch (e) {
      throw e;
    }

    final controlStrs = _controlsToString(controls);
    prefs.setStringList('controls', controlStrs);

    notifyListeners();
  }

  Future<List<TimeControl>> timeControls() async {
    final SharedPreferences prefs = await _prefs;

    final strs = prefs.getStringList('controls');
    final controls = _strToControl(strs);

    // create default control if it is empty
    if (controls.length < 1) {
      await createDefaultTimeControls();

      // call this method recursively
      return await timeControls();
    }

    return controls;
  }

  static List<TimeControl> _strToControl(List<String> jsonStrs) {
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

  static List<String> _controlsToString(List<TimeControl> controls) {
    List<String> strs = [];

    for (int i = 0; i < controls.length; i++) {
      strs.add(jsonEncode(controls[i].toJson()));
    }

    return strs;
  }

  Future<void> select(int index) async {
    final SharedPreferences prefs = await _prefs;
    
    /*final controls = await timeControls();
    if (index > controls.length - 1) {
      return;
    }*/

    // selectedIndex = index;
    prefs.setInt('selectedControlIndex', index);
    
    notifyListeners();
  }

  /// used to create default control when all controls have been deleted
  createDefaultTimeControls() async {
    await add(defaultTimeControl);
    select(0); // select the first index
  }
}

// todo:: move to somewhere else
TimeControl defaultTimeControl = TimeControl(name: 'Rapid | 10min', duration: Duration(minutes: 10));