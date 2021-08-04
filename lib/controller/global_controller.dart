import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class GlobalController extends GetxController {
  static const txtColor = const Color(0xff2f4858);
  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879
  static const borderColor = const Color(0xff0085ff);

  final appVersion = "0.4.210727"; //current version of the app

  bool appRunning = false;
  bool isOnline = false;



//** USER DATA **
//Hive-listener Key
  String defaultUser = 'default';
  String defaultSetting = 'default';

//** ICONS **
  String userImg = "assets/img/profile/user_icon.png";

}
