import 'package:chess_clock/providers/clock_provider.dart';
import 'package:chess_clock/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClockActionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ClockProvider>(context, listen: false);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            iconSize: 48,
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              provider.restartWithCurrentControl();
            },
          ),
          SizedBox(width: 24.0,),
          IconButton(
            iconSize: 48,
            icon: Icon(
              Icons.pause,
              color: Colors.white,
            ),
            onPressed: () {
              provider.pause();
            },
          ),
          SizedBox(width: 24.0,),
          IconButton(
            iconSize: 48,
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              provider.pause();
              Navigator.pushNamed(context, SettingScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}