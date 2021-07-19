import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/widgets/LabledSwitch.dart';

import 'home_screen.dart';
class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879
  static const borderColor = const Color(0xff0085ff);

  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{

  static const bckColor = const Color(0xFF5dbcd2);

  bool isSwitched = false; //0xFFedb879



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, HomeScreen.routeName),
          ),
        title: Text("Settings"),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            LabeledSwitch(
                label: "Darkmode",
                isSelected: false,
                ),
            SizedBox(height: 20),
            Text("Lessons", style: TextStyle(fontSize: 20)),
            LabeledSwitch(
              label: "Show Alias when commenting",
              isSelected: false,
            ),
            LabeledSwitch(
              label: "Show Score when commenting",
              isSelected: false,
            ),
            Spacer(),
            Text("Mobile Learning v0.2.210719", style: TextStyle(fontSize: 20, color: Colors.grey))
              ],
            ),

        ),
      );
  }
}