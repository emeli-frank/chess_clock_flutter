import 'package:chess_clock/models/time_control.dart';
import 'package:chess_clock/providers/time_control_provider.dart';
import 'package:chess_clock/screens/time_control_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  static String routeName = 'settings';

  @override
  Widget build(BuildContext context) {
    var timeControlProvider = Provider.of<TimeControlProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_time),
            onPressed: () async {
              final timeControl = await Navigator.pushNamed(context, TimeControlScreen.routeName);
              timeControlProvider.add(timeControl);
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              timeControlProvider.clearAll();
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: null,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<TimeControlProvider>(
                builder: (BuildContext context, TimeControlProvider model, Widget child) {
                  return FutureBuilder<List<TimeControl>>(
                    initialData: [],
                    future: model.timeControls(),
                    builder: (BuildContext context, AsyncSnapshot<List<TimeControl>>snapshot) {
                      var timeControls = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: timeControls.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Slidable(
                            actionPane: SlidableScrollActionPane(),
                            actionExtentRatio: 0.18,
                            actions: [
                              IconSlideAction(
                                iconWidget: Icon(
                                  Icons.edit,
                                  color: Colors.black87,
                                ),
                                onTap: () => null,
                              ),
                              IconSlideAction(
                                color: Colors.red.shade50,
                                iconWidget: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  timeControlProvider.delete(index);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Time control deleted')),
                                  );
                                },
                              )
                            ],
                            child: _buildControlTile(
                              name: timeControls[index].name,
                              time: timeControls[index].duration,
                              selected: false,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlTile({@required String name, @required Duration time, @required bool selected}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Radio<bool>(
              value: selected,
              groupValue: true,
              onChanged: (_) {},
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  'hh:mm:ss',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
