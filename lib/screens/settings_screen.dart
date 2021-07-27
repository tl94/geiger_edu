import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/LabledSwitch.dart';
import 'package:get/get.dart';
import 'package:hive_listener/hive_listener.dart';
import '../globals.dart' as globals;
import 'home_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  final SettingsController settingsController = Get.find();

  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879
  static const borderColor = const Color(0xff0085ff);

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
        child: Column(children: [
          Expanded(child:
          SingleChildScrollView(
              child:Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        HiveListener(
                          box: DB.getSettingBox(),
                          keys: [ globals.defaultSetting ], // keys is optional to specify listening value changes
                          builder: (box) {
                            return LabeledSwitch(
                              label: "Darkmode",
                              isSelected: DB.getDefaultSetting()!.darkmode,
                              onChanged: settingsController.switchDarkMode,
                            );
                          },
                        ),

                        SizedBox(height: 20),
                        Text("Lessons", style: TextStyle(fontSize: 20)),

                        HiveListener(
                          box: DB.getSettingBox(),
                          keys: [ globals.defaultSetting ], // keys is optional to specify listening value changes
                          builder: (box) {
                            return LabeledSwitch(
                              label: "Display your alias on the discussion platform",
                              isSelected: DB.getDefaultSetting()!.showAlias,
                              onChanged: settingsController.switchShowAlias,
                            );
                          },
                        ),

                        HiveListener(
                          box: DB.getSettingBox(),
                          keys: [ globals.defaultSetting ], // keys is optional to specify listening value changes
                          builder: (box) {
                            return LabeledSwitch(
                              label: "Display your own score on the discussion platform",
                              isSelected: DB.getDefaultSetting()!.showScore,
                              onChanged: settingsController.switchShowScore,
                            );
                          },
                        ),
                      ])
              )
          ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Text("Mobile Learning v" + settingsController.appVersion, style: TextStyle(fontSize: 20, color: Colors.grey)),
          )
        ])
        ),
      );
  }
}