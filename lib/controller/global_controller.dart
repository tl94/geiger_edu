import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geiger_edu/model/difficultyObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class GlobalController extends GetxController {
  final txtColor = const Color(0xff2f4858);

  final appVersion = "0.4.210727"; //current version of the app

  bool appRunning = false;
  bool isOnline = false;



//** USER DATA **
//Hive-listener Key
  String defaultUser = 'default';
  String defaultSetting = 'default';

//** ICONS **
  String userImg = "assets/img/profile/user_icon.png";



//TODO: Fix currentLessonSlideIndex


}
