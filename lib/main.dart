import 'package:chess_clock/providers/clock_provider.dart';
import 'package:chess_clock/screens/clock_screen.dart';
import 'package:chess_clock/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ClockProvider>(create: (_) => ClockProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // title: 'Chess clock',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: ClockScreen.routeName,
        routes: {
          ClockScreen.routeName: (context) => ClockScreen(),
          SettingScreen.routeName: (context) => SettingScreen(),
        },
      ),
    );
  }
}
