import 'package:chess_clock/models/time_control.dart';
import 'package:chess_clock/providers/clock_provider.dart';
import 'package:chess_clock/providers/time_control_provider.dart';
import 'package:chess_clock/screens/time_control_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  static String routeName = 'settings';

  @override
  Widget build(BuildContext context) {
    var timeControlProvider = Provider.of<TimeControlProvider>(context, listen: false);
    var clockProvider = Provider.of<ClockProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_time),
            onPressed: () async {
              final timeControl = await Navigator.pushNamed(context, TimeControlScreen.routeName);
              if (timeControl != null) {
                timeControlProvider.add(timeControl);
              }
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
                    initialData: null,
                    future: model.timeControls(),
                    builder: (BuildContext context, AsyncSnapshot<List<TimeControl>>snapshot) {
                      if (snapshot.hasData) {
                        final timeControls = snapshot.data;

                        if (timeControls.length < 1) {
                          timeControlProvider.createDefaultTimeControls();
                          print('array: $timeControls, loading default control');
                          return Center(
                            child: Text('data length is zero'),
                            // child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: timeControls.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () { timeControlProvider.select(index); },
                              child: Slidable(
                                actionPane: SlidableScrollActionPane(),
                                actionExtentRatio: 0.18,
                                actions: [
                                  IconSlideAction(
                                    color: Colors.transparent,
                                    iconWidget: Icon(
                                      Icons.edit,
                                      color: Colors.black87,
                                    ),
                                    onTap: () async {
                                      final timeControl = await Navigator.pushNamed(
                                        context,
                                        TimeControlScreen.routeName,
                                        arguments: {"control": timeControls[index]},
                                      );
                                      if (timeControl != null) {
                                        timeControlProvider.update(index, timeControl);
                                      }
                                    },
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
                                  ),
                                ],
                                child: FutureBuilder<int>(
                                  initialData: null,
                                  future: timeControlProvider.selectedIndex,
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    return _buildControlTile(
                                      context: context,
                                      name: timeControls[index].name,
                                      time: timeControls[index].asFormattedString,
                                      selected: index == snapshot.data,
                                      isLastChild: index == timeControls.length,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Container(
                              height: 1.0,
                              color: Colors.black12,
                              margin: EdgeInsets.only(left: 60.0, right: 24.0),
                            );
                          },
                        );
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                margin: EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: MaterialButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      clockProvider.reset2();
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text('Start'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlTile({
    @required BuildContext context,
    @required String name,
    @required String time,
    @required bool selected,
    @required bool isLastChild}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Center(
              child: Radio<bool>(
                value: selected,
                groupValue: true,
                activeColor: Theme.of(context).accentColor,
                onChanged: (_) {},
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 24.0, right: 16.0),
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
                    time,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}
