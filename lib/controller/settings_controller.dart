import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  //** LANGUAGE SETTING **
  String language = 'eng';

  //** APP VERSION **
  final appVersion = "0.4.210727";

  void switchDarkMode() {
    DB.editDefaultSetting(!DB.getDefaultSettings()!.darkmode, null, null, null);
  }

  void switchShowAlias() {
    DB.editDefaultSetting(null, !DB.getDefaultSettings()!.showAlias, null, null);
  }

  void switchShowScore() {
    DB.editDefaultSetting(null, null, !DB.getDefaultSettings()!.showScore, null);
  }

// TODO: use this function
  void changeLanguage() {
    DB.editDefaultSetting(null, null, null, null);
  }

  String getLanguage() {
    return language;
  }
}
