import 'dart:async';

import 'package:chess_clock/models/time_control.dart';
import 'package:flutter/foundation.dart';

class ClockProvider with ChangeNotifier {
  Duration playerOneTime = Duration(seconds: 1 * 60); // todo:: should be supplied dynamically
  Duration playerTwoTime = Duration(seconds: 1 * 60); // todo:: should be supplied dynamically
  int currentPlayerIndex = 1;
  bool paused = true;
  final Duration emitInterval = Duration(milliseconds: 1000);

  List<Player> players = [];
  List<TimeControl> timeControls = [];

  ClockProvider() {
    players.add(Player(timeLeft: playerOneTime));
    players.add(Player(timeLeft: playerTwoTime));
  }

  Stream<String> clock1() async* {
    const index = 0;
    while (true) {
      await Future.delayed(emitInterval);

      // exit loop if not player's turn
      if (currentPlayerIndex != index || paused == true) {
        continue;
      }

      // remove time from player with turn
      players[index].removeTime(emitInterval);

      // emit player's remaining time
      yield players[index].getTimeLeft();

      // break loop if player's time has ran out
      if (players[index].timeLeft.inMilliseconds == 0) {
        break;
      }
    }
  }

  Stream<String> clock2() async* {
    const index = 1;
    while (true) {
      await Future.delayed(emitInterval);

      // exit loop if not player's turn
      if (currentPlayerIndex != index || paused == true) {
        continue;
      }

      // remove time from player with turn
      players[index].removeTime(emitInterval);

      // emit player's remaining time
      yield players[index].getTimeLeft();

      // break loop if player's time has ran out
      if (players[index].timeLeft.inMilliseconds == 0) {
        break;
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

  // todo:: remove this method
  // subtracts time from this player
  removeASecond () {
    // todo:: convert to a method that removes a smaller amount of time say 1, 50 or 100ms
    // timeLeft = Duration(seconds: timeLeft.inSeconds - 1);
    timeLeft = timeLeft - Duration(seconds: 1);
  }

  removeTime(Duration d) {
    if (d > timeLeft) {
      d = timeLeft;
    }

    timeLeft = timeLeft - d;
  }

  // returns time as string in the format hh:mm:ss
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
