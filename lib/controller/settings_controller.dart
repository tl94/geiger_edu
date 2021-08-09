import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/providers/chat_api.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {

  final GlobalController globalController = Get.find();

  //** LANGUAGE SETTING **
  String language = 'eng';

  //** APP VERSION **
  final appVersion = "0.4.210727";

  void switchDarkMode() {
    DB.editDefaultSetting(!DB.getDefaultSetting()!.darkmode, null);
  }

  void switchShowAlias() {
    DB.editDefaultUser(null, null, null, !DB.getDefaultUser()!.showAlias, null);
    if (globalController.checkInternetConnection()) {
      ChatAPI.sendUpdatedUserData();
    }
  }

  void switchShowScore() {
    DB.editDefaultUser(null, null, null, null, !DB.getDefaultUser()!.showScore);
    if (globalController.checkInternetConnection()) {
      ChatAPI.sendUpdatedUserData();
    }
  }

// TODO: use this function
  void changeLanguage(String language) {
    DB.editDefaultSetting(null, null);
  }

  String getLanguage() {
    return language;
  }

  void setLessonLanguageForLocale() {
    var locale = Get.locale;
    if (locale.toString().startsWith('en')) {
      language = 'eng';
    }
    if (locale.toString().startsWith('de')) {
      language = 'ger';
    }
  }
}
