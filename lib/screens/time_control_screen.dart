import 'package:chess_clock/models/time_control.dart';
import 'package:flutter/material.dart';

class TimeControlScreen extends StatefulWidget {

  static const routeName = 'time_control';
  const TimeControlScreen({Key key}) : super(key: key);

  @override
  _TimeControlScreenState createState() => _TimeControlScreenState();
}

class _TimeControlScreenState extends State<TimeControlScreen> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Time control name',
                helperText: 'E.g. Rapid | 10min',
              ),
              controller: nameController,
            ),
            SizedBox(height: 72.0,),
            MaterialButton(
              child: Text('Create'),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                TimeControl timeControl = TimeControl(name: nameController.text, duration: Duration(seconds: 60));
                Navigator.pop(context, timeControl);
              },
            ),
          ],
        ),
      ),
    );
  }
}
