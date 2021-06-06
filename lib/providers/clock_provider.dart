import 'dart:async';

import 'package:chess_clock/providers/time_control_provider.dart';
import 'package:flutter/foundation.dart';

class ClockProvider with ChangeNotifier {
  final Duration emitInterval = Duration(milliseconds: 100);
  final List<Timer> timers = [null, null];
  final List<StreamController<String>> controllers = [null, null];
  final List<Player> players = [null, null];
  final TimeControlProvider timeControlProvider;
  int currentPlayerIndex = 1;

  bool get isPaused => timers[0] == null && timers[1] == null;

  ClockProvider(this.timeControlProvider) {
    for (int i = 0; i < 2; i++) {
      // create stream controllers for each player
      controllers[i] = StreamController<String>(
        onPause: () { _stopTimer(i); },
        onResume: () { _startTimer(i); },
        onCancel: () { _stopTimer(i); },
      );
    }

    reset();
  }

  reset({bool shouldNotifyListeners = false}) async {
    // 2 iterations for each buttons
    for (int i = 0; i < 2; i++) {
      // emit initial output string
      (int index) {
        timeControlProvider.selected.then((control) {
          controllers[index].add(control.asFormattedString);
        });
      }(i);

      final timeControl = await timeControlProvider.selected;
      players[i] = Player(timeLeft: timeControl.duration);
    }

    currentPlayerIndex = 1;

    // notifying listeners is necessary for the UI to highlight button with turn
    if (shouldNotifyListeners) {
      notifyListeners();
    }
  }

  /// starts time for player whose index was passed in and removed a fixed
  /// amount of time at interval while emitting their remaining time until
  /// the timer is cancelled
  void _startTimer(int index) {
    timers[index] = Timer.periodic(emitInterval, (_) {
      // if either player has exhausted their time, delete their timer
      if (players[0].timeLeft.inMilliseconds == 0 || players[1].timeLeft.inMilliseconds == 0) {
        if (timers[index] != null) {
          timers[index].cancel();
        }
      }

      // remove time from current player
      players[currentPlayerIndex].removeTime(emitInterval);

      // emit remaining time left for current player
      controllers[currentPlayerIndex].add(players[currentPlayerIndex].getTimeLeft());
    });
  }

  /// cancels and deletes timer for player whose index was passed in
  void _stopTimer(int index) {
    if (timers[index] != null) {
      timers[index].cancel();
      timers[index] = null;
    }
  }

  // emit remaining time for player 1
  Stream<String> clock1() {
    const index = 0;

    return controllers[index].stream;
  }

  // emit remaining time for player 2
  Stream<String> clock2() {
    const index = 1;

    return controllers[index].stream;
  }

  startTheOtherPlayerTime(index) {
    // stop current player's timer
    _startTimer((index + 1) % 2);

    // starts the other player's timer
    _stopTimer(index);

    // toggle turn
    currentPlayerIndex = (index + 1) % 2;

    notifyListeners();
  }

  pause() {
    _stopTimer(0);
    _stopTimer(1);

    // Notifying listeners here may seem wasteful but it is not.
    // it helps the clock buttons disable or enable themselves under certain
    // conditions.
    // When the timer is paused, if it does not trigger a clock button
    // UI update a clock which do not have turn may not be clickable event though
    // it should and can be used to restart opponent's time.
    notifyListeners();
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
