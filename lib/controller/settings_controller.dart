import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/services/chat_api.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';

/// This class handles the business logic of the quiz.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class SettingsController extends GetxController {
  final GlobalController globalController = Get.find();
  String language = 'eng';

  /// This method sets the darkmode value in the db to the opposite value.
  void switchDarkMode() {
    DB.editDefaultSetting(!DB.getDefaultSetting()!.darkmode, null);
  }

  /// This method sets the showAlias value in the db to the opposite value.
  void switchShowAlias() {
    DB.editDefaultUser(null, null, null, !DB.getDefaultUser()!.showAlias, null);
    if (globalController.checkInternetConnection()) {
      ChatAPI.sendUpdatedUserData();
    }
  }

  /// This method sets the showScore value in the db to the opposite value.
  void switchShowScore() {
    DB.editDefaultUser(null, null, null, null, !DB.getDefaultUser()!.showScore);
    if (globalController.checkInternetConnection()) {
      ChatAPI.sendUpdatedUserData();
    }
  }

  /// This method persists the language to the db.
  ///
  /// @param language New language to be set
  void changeLanguage(String language) {
    DB.editDefaultSetting(null, language);
  }

  /// This method gets the system language.
  String getLanguage() {
    return language;
  }

  /// This method sets the lesson language according to the device locale.
  void setLessonLanguageForLocale() {
    var locale = Get.locale;
    if (locale.toString().startsWith('en')) {
      language = 'eng';
    }
    if (locale.toString().startsWith('de')) {
      language = 'ger';
    }
    changeLanguage(language);
  }
}
