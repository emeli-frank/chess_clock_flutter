import 'package:chess_clock/widgets/clock/clock_button_widget.dart';
import 'package:chess_clock/widgets/clock/clock_actions_widget.dart';
import 'package:flutter/material.dart';

class ClockScreen extends StatelessWidget {
  static String routeName = 'clock_screen';

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      backgroundColor: Color(0xff404040),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: ClockButtonWidget(playerIndex: 0,),
                ),
              ),
              Expanded (
                flex: 1,
                child: ClockActionsWidget(),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: ClockButtonWidget(playerIndex: 1,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
