import 'package:geiger_edu/providers/chat_api.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  //** LANGUAGE SETTING **
  String language = 'eng';

  //** APP VERSION **
  final appVersion = "0.4.210727";

  void switchDarkMode() {
    DB.editDefaultSetting(!DB.getDefaultSetting()!.darkmode, null);
  }

  void switchShowAlias() {
    DB.editDefaultUser(null, null, null, !DB.getDefaultUser()!.showAlias, null);
    ChatAPI.sendUpdatedUserData();
  }

  void switchShowScore() {
    DB.editDefaultUser(null, null, null, null, !DB.getDefaultUser()!.showScore);
    ChatAPI.sendUpdatedUserData();
  }

// TODO: use this function
  void changeLanguage() {
    DB.editDefaultSetting(null, null);
  }

  String getLanguage() {
    return language;
  }
}
