import 'package:chess_clock/providers/clock_provider.dart';
import 'package:chess_clock/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                child: Clock(playerIndex: 0,),
              ),
              Expanded (
                flex: 1,
                child: ClockActions(),
              ),
              Expanded(
                flex: 3,
                child: Clock(playerIndex: 1,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Clock extends StatelessWidget {
  final int playerIndex;

  Clock({@required this.playerIndex});

  /*@override
  Widget build(BuildContext context) {
    var provider = Provider.of<ClockProvider>(context);

    return StreamProvider<String>(
      initialData: provider.players[playerIndex].getTimeLeft(),
      create: (BuildContext context) {
        return playerIndex == 0 ? provider.clock1() : provider.clock2();
      },
      child: Consumer<String>(
        builder: (BuildContext context, String value, Widget child) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: InkWell(
              child: Container(
                // margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    color: provider.currentPlayerIndex == playerIndex ? Color(0xFF20A09C) : Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular( 8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular( 8.0),
                    )
                ),
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 90.0
                    ),
                  ),
                ),
              ),
              onTap: () => provider.startTheOtherPlayerTime(playerIndex),
            ),
          );
        },
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ClockProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: InkWell(
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              color: provider.currentPlayerIndex == playerIndex ? Color(0xFF20A09C) : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular( 8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular( 8.0),
              )
          ),
          child: Center(
            child: StreamProvider<String>(
              initialData: provider.players[playerIndex].getTimeLeft(),
              create: (BuildContext context) {
                return playerIndex == 0 ? provider.clock1() : provider.clock2();
              },
              child: Consumer<String>(
                builder: (BuildContext context, String value, Widget child) {
                  return Text(
                    value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 90.0
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        onTap: () => provider.startTheOtherPlayerTime(playerIndex),
      ),
    );
  }
}

class ClockActions extends StatelessWidget {
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
            onPressed: null,
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
              Navigator.pushNamed(context, SettingScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}