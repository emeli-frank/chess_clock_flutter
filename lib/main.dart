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
    final timeControl = TimeControlProvider();
    final clock = ClockProvider(timeControl);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ClockProvider>(create: (_) => clock),
        ChangeNotifierProvider<TimeControlProvider>(create: (_) => timeControl),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // title: 'Chess clock',
        theme: ThemeData.light().copyWith(
          // primaryColor: Color(0xFF20A09C),
          primaryColor: Colors.cyan[800],
          accentColor: Colors.orange[900],
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            titleTextStyle: TextStyle(
              color: Colors.black87,
            ),
            textTheme: Theme.of(context).textTheme.copyWith(
              headline6: Theme.of(context).textTheme.headline6.copyWith(fontSize: 20.0),
            ),
            iconTheme: Theme.of(context).iconTheme,
          ),
          buttonTheme: ButtonThemeData(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          ),
        ),
        initialRoute: ClockScreen.routeName,
        routes: {
          ClockScreen.routeName: (context) => ClockScreen(),
          SettingScreen.routeName: (context) => SettingScreen(),
          TimeControlScreen.routeName: (context) => TimeControlScreen(),
        },
      ),
    );
  }
}
