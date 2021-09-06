import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/labeled_switch.dart';
import 'package:get/get.dart';
import 'package:hive_listener/hive_listener.dart';

/// SettingsScreen Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  final GlobalController globalController = Get.find();
  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    var defaultSetting = globalController.defaultSetting;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("SettingsTitle".tr),
        centerTitle: true,
      ),
      body: Container(
          child: Column(children: [
        Expanded(
          child: SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        HiveListener(
                          box: DB.getSettingBox(),
                          keys: [
                            defaultSetting
                          ], // keys is optional to specify listening value changes
                          builder: (box) {
                            return LabeledSwitch(
                              label: "SettingsDarkMode".tr,
                              isSelected: DB.getDefaultSetting()!.darkmode,
                              onChanged: settingsController.switchDarkMode,
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        Text("SettingsLessons".tr,
                            style: TextStyle(fontSize: 20)),
                        HiveListener(
                          box: DB.getUserBox(),
                          builder: (box) {
                            return LabeledSwitch(
                              label: "SettingsSetDisplayAnonymous".tr,
                              isSelected: DB.getDefaultUser()!.showAlias,
                              onChanged: settingsController.switchShowAlias,
                            );
                          },
                        ),
                        HiveListener(
                          box: DB.getUserBox(),
                          builder: (box) {
                            return LabeledSwitch(
                              label: "SettingsSetDisplayScore".tr,
                              isSelected: DB.getDefaultUser()!.showScore,
                              onChanged: settingsController.switchShowScore,
                            );
                          },
                        ),
                      ]))),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Text("Mobile Learning v" + GlobalController.appVersion,
              style: TextStyle(fontSize: 20, color: Colors.grey)),
        )
      ])),
    );
  }
}
