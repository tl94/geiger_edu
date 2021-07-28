import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
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
      DB.editDefaultUser(null, s, null);
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
