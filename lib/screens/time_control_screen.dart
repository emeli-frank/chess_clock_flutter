import 'package:chess_clock/models/time_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeControlScreen extends StatefulWidget {

  static const routeName = 'time_control';
  const TimeControlScreen({Key key}) : super(key: key);

  @override
  _TimeControlScreenState createState() => _TimeControlScreenState();
}

class _TimeControlScreenState extends State<TimeControlScreen> {
  final nameTextController = TextEditingController();
  Duration duration;

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TimeControl timeControl;
    final  Map<String, Object>data = ModalRoute.of(context).settings.arguments;
    
    if (data != null) {
      timeControl = data['control'] as TimeControl;
      nameTextController.text = timeControl.name;
      duration = timeControl.duration;
    } else {
      duration = Duration(minutes: 10);
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Time control'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan[800], width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan[800], width: 2.0),
                ),
                labelStyle: TextStyle(
                  color: Colors.cyan[800],
                ),
                border: OutlineInputBorder(),
                labelText: 'Time control name',
                helperText: 'E.g. Rapid | 10min',
              ),
              controller: nameTextController,
            ),
            CupertinoTimerPicker(
              onTimerDurationChanged: (Duration value) {
                duration = value;
              },
              initialTimerDuration: duration,
            ),
            SizedBox(height: 72.0,),
            MaterialButton(
              child: Text(timeControl == null ? 'Create' : 'Update'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                timeControl = TimeControl(name: nameTextController.text, duration: duration);
                Navigator.pop(context, timeControl);
              },
            ),
          ],
        ),
      ),
    );
  }
}
