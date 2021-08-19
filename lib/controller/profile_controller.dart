import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/providers/chat_api.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';

/// This class handles the business logic of the user profile.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class ProfileController extends GetxController {

  final GlobalController globalController = Get.find();
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
  RxBool isVisible = false.obs;

  /// This method changes the image selector visibility.
  void displayImageSelector() {
    isVisible(!isVisible.value);
  }

  /// This method saves the new profile image.
  ///
  /// @param imagePath The path of the new profile image
  void saveNewProfileImage(String? imagePath) {
    if (imagePath != null && DB.getDefaultUser()!.userImagePath != imagePath) {
      DB.editDefaultUser(null, imagePath, null, null, null);
      if (globalController.checkInternetConnection()) {
        ChatAPI.sendUpdatedUserData();
      }
    }
  }

  /// This method saves a given username.
  ///
  /// @param name New username to be set
  void saveNewUserName(String name) {
    DB.editDefaultUser(name, null, null, null, null);
    if (globalController.checkInternetConnection()) {
      ChatAPI.sendUpdatedUserData();
    }
  }

  /// This method returns a list of widgets containing all the possible user
  /// images that can be selected by a tap gesture.
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
