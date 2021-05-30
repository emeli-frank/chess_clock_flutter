import 'package:chess_clock/models/time_control.dart';
import 'package:chess_clock/providers/clock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  static String routeName = 'settings';

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ClockProvider>(context);
    List<TimeControl> timeControls = provider.timeControls;
    var tiles = List.generate(timeControls.length, (index) {
      return ListTile(
        leading: Icon(Icons.favorite),
        title: Text('favorite'),
      );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        textTheme: TextTheme(

        ),
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: null,
          ),
        ],
      ),
      body: ListView(),
    );
  }
}
