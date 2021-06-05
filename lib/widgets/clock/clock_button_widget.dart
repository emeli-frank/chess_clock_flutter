import 'package:chess_clock/providers/clock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClockButtonWidget extends StatelessWidget {
  final int playerIndex;

  ClockButtonWidget({@required this.playerIndex});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ClockProvider>(context);
    final hasTurn = provider.currentPlayerIndex == playerIndex;

    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: hasTurn ? Colors.cyan[800] : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextButton(
        child: Center(
          child: StreamProvider<String>( // stream of time as string
            initialData: '',
            create: (BuildContext context) {
              return playerIndex == 0 ? provider.clock1() : provider.clock2();
            },
            child: Consumer<String>(
              builder: (BuildContext context, String value, Widget child) {
                return Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 90.0,
                    fontWeight: FontWeight.normal,
                  ),
                );
              },
            ),
            /*builder: (BuildContext context, Widget child) {
              return Consumer<String>(
                builder: (BuildContext context, String value, Widget child) {
                  return Text(
                    value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 90.0
                    ),
                  );
                },
              );
            }*/
          ),
        ),
        onPressed: !hasTurn && !provider.isPaused ? null : () {
          provider.startTheOtherPlayerTime(playerIndex);
        },
      ),
    );
  }
}