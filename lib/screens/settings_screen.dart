import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/LabledSwitch.dart';
import 'package:hive_listener/hive_listener.dart';

import '../globals.dart';
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

  switchDarkmode(){
    DB.editDefaultSetting(!DB.getDefaultSetting()!.darkmode, null, null, null);
  }

  switchShowAlias(){
    DB.editDefaultSetting(null, !DB.getDefaultSetting()!.showAlias, null, null);
  }

  switchShowScore(){
    DB.editDefaultSetting(null, null, !DB.getDefaultSetting()!.showScore, null);
  }

  // TODO: use this function
  changeLanguage(){
    DB.editDefaultSetting(null, null, null, null);
  }

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
            HiveListener(
              box: DB.getSettingBox(),
              keys: [ defaultSetting ], // keys is optional to specify listening value changes
              builder: (box) {
                return LabeledSwitch(
                  label: "Darkmode",
                  isSelected: DB.getDefaultSetting()!.darkmode,
                  onChanged: switchDarkmode,
                );
              },
            ),

            SizedBox(height: 20),
            Text("Lessons", style: TextStyle(fontSize: 20)),

            HiveListener(
              box: DB.getSettingBox(),
              keys: [ defaultSetting ], // keys is optional to specify listening value changes
              builder: (box) {
                return LabeledSwitch(
                  label: "Show Alias when commenting",
                  isSelected: DB.getDefaultSetting()!.showAlias,
                  onChanged: switchShowAlias,
                );
              },
            ),

            HiveListener(
              box: DB.getSettingBox(),
              keys: [ defaultSetting ], // keys is optional to specify listening value changes
              builder: (box) {
                return LabeledSwitch(
                  label: "Show Score when commenting",
                  isSelected: DB.getDefaultSetting()!.showScore,
                  onChanged: switchShowScore,
                );
              },
            ),
            Spacer(),
            Text("Mobile Learning v0.2.210719", style: TextStyle(fontSize: 20, color: Colors.grey))
              ],
            ),

        ),
      );
  }
}