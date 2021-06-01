import 'package:chess_clock/models/time_control.dart';
import 'package:chess_clock/providers/clock_provider.dart';
import 'package:chess_clock/providers/time_control_provider.dart';
import 'package:chess_clock/screens/clock_screen.dart';
import 'package:chess_clock/screens/settings_screen.dart';
import 'package:chess_clock/screens/time_control_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ClockProvider>(create: (_) => ClockProvider()),
        ChangeNotifierProvider<TimeControlProvider>(create: (_) => TimeControlProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // title: 'Chess clock',
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.grey,
            ),
            titleTextStyle: TextStyle(
              color: Colors.black54,
            ),
          ),
          buttonTheme: ButtonThemeData(
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
          ),
        ),
        initialRoute: ClockScreen.routeName,
        // initialRoute: TimeControlScreen.routeName,
        routes: {
          ClockScreen.routeName: (context) => ClockScreen(),
          SettingScreen.routeName: (context) => SettingScreen(),
          TimeControlScreen.routeName: (context) => TimeControlScreen(),
        },
      ),
    );
  }
}
