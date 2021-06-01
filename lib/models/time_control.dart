import 'package:flutter/widgets.dart';

class TimeControl {
  final String name;
  final Duration duration;
  // final Duration increment;

  TimeControl({@required this.name, @required this.duration/*, @required this.increment*/});

  /*factory TimeControl.fromJson(Map<String, dynamic> data) {
    return TimeControl(
        name: data['name'],
        duration: data['duration'],
        // increment: data['increment']
    );
  }*/
  
  TimeControl.fromJson(Map<String, dynamic> json):
      name = json['name'],
      duration = _durationFromMap(json['duration']);

  /*fromJson(Map<String, dynamic> data) {
    print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    return TimeControl(
      name: data['name'],
      duration: data['duration'],
      // increment: data['increment']
    );
  }*/
  
  _durationToMap(Duration d) {
    var timeMap = Map<String, int>();
    int hours = d.inHours;
    int minutes = d.inMinutes - hours * 60;
    int seconds = d.inSeconds - minutes * 60;

    timeMap['hours'] = hours;
    timeMap['minutes'] = minutes;
    timeMap['seconds'] = seconds;
    
    return timeMap;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "duration": _durationToMap(this.duration),
      // 'duration': this.duration,
      // 'increment': this.increment,
    };
  }
}

Duration _durationFromMap(Map<String, dynamic> json) {
  return Duration(
    hours: json['hours'],
    minutes: json['minutes'],
    seconds: json['seconds'],
  );
}
