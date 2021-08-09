import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/providers/chat_api.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {

  final GlobalController globalController = Get.find();

  RxBool isVisible = false.obs;

  final List<String> imagePaths = [
    "assets/img/profile/default.png",
    "assets/img/profile/user-01.png",
    "assets/img/profile/user-02.png",
    "assets/img/profile/user-03.png",
    "assets/img/profile/user-05.png",
    "assets/img/profile/user-06.png",
    "assets/img/profile/user-07.png",
    "assets/img/profile/user-08.png",
    "assets/img/profile/user-09.png",
    "assets/img/profile/user-04.png",
    "assets/img/profile/user-10.png"
  ];

  /// sets isVisible
  void displayImageSelector() {
    isVisible(!isVisible.value);
  }

  void saveNewProfileImage(String? s) {
    if (s != null && DB.getDefaultUser()!.userImagePath != s) {
      DB.editDefaultUser(null, s, null, null, null);
      // TODO: check for internet connection
      if (globalController.checkInternetConnection()) {
        ChatAPI.sendUpdatedUserData();
      }
    }
  }

  void saveNewUserName(String name) {
    DB.editDefaultUser(name, null, null, null, null);
    if (globalController.checkInternetConnection()) {
      ChatAPI.sendUpdatedUserData();
    }
  }

  /// returns list of widgets with images that can be selected via tap
  List<Widget> getImageSelection() {
    List<Widget> gst = <Widget>[];
    for (var i in imagePaths) {
      GestureDetector g = new GestureDetector(
          onTap: () {
            displayImageSelector();
            saveNewProfileImage(i);
          },
          child: Image.asset(i));
      gst.add(g);
    }
    return gst;
  }
}
