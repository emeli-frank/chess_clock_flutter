import 'dart:async';

import 'package:chess_clock/models/time_control.dart';
import 'package:flutter/material.dart';

class ClockProvider with ChangeNotifier {
  DateTime timeOut = DateTime(0, 0, 0, 0, 5, 0, 0, 0);
  var playerOneTime = 5;
  var playerTwoTime = 5;
  var currentPlayerIndex = 0;
  bool paused = true;

  List<Player> players = [];
  List<TimeControl> timeControls = [];

  ClockProvider() {
    players.add(Player(timeLeft: Duration(seconds: 1 * 60)));
    players.add(Player(timeLeft: Duration(seconds: 1 * 60)));
  }

  setPlayersTime(List<Duration> time) {
    players[0].timeLeft = time[0];
    players[1].timeLeft = time[1];
  }

  Stream<String> clock1() async* {
    const index = 0;
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      if (currentPlayerIndex != index || paused == true) {
        continue;
      }
      players[index].removeASecond();
      if (players[index].timeLeft.inMilliseconds % 1000 == 0) {
        yield players[index].getTimeLeft();
        if (players[index].timeLeft == Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0)) {
          break;
        }
      }
    }
  }

  Stream<String> clock2() async* {
    const index = 1;
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      if (currentPlayerIndex != index || paused == true) {
        continue;
      }
      players[index].removeASecond();
      if (players[index].timeLeft.inMilliseconds % 1000 == 0) {
        yield players[index].getTimeLeft();
        if (players[index].timeLeft == Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0)) {
          break;
        }
      }
    }
  }

  startTheOtherPlayerTime(index) {
    paused = false;
    currentPlayerIndex = (index + 1) % 2;
    notifyListeners();
  }

  pause() {
    paused = true;
  }
}

class Player {
  Duration timeLeft;
  bool timeCounting = false;

  Player({@required this.timeLeft});

  /*Stream<String> timerCounter() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      timeLeft = Duration(seconds: timeLeft.inSeconds - 1);
      String output = "${timeLeft.inMinutes} : ${timeLeft.inSeconds - timeLeft.inMinutes * 60}";
      yield output;
      if (timeLeft.inSeconds == 0) break;
    }
  }*/

  // subtracts time from this player
  removeASecond () {
    // todo:: convert to a method that removes a smaller amount of time say 1, 50 or 100ms
    // timeLeft = Duration(seconds: timeLeft.inSeconds - 1);
    timeLeft = timeLeft - Duration(seconds: 1);
  }

  String getTimeLeft() {
    int hours = timeLeft.inHours;
    int minutes = timeLeft.inMinutes - hours * 60;
    int seconds = timeLeft.inSeconds - minutes * 60;

    String timeAsString = "";

    if (hours > 0) {
      timeAsString += "$hours :";
    }

    timeAsString += "$minutes : ";
    timeAsString += "$seconds".padLeft(2, '0');

    return timeAsString;
  }
}
