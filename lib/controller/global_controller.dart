import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/providers/internet_connectivity.dart';
import 'package:get/get.dart';

/// This class handles overarching business logic.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class GlobalController extends GetxController {
  static const txtColor = const Color(0xff2f4858);

  //current version of the application
  static const appVersion = "1.0.20210906";

  //base score rewards for completing lesson and correct answers on quiz
  static const int baseLessonScoreReward = 0;
  static const int baseQuizQuestionReward = 25;

  //** USER DATA **
  //Hive-listener Key
  String defaultUser = 'default';
  String defaultSetting = 'default';

  //** ICONS **
  String userImg = "assets/img/profile/user_icon.png";

  //** IMAGE FULLSCREEN VIEW **
  String selectedImage = "";

  //** CRON **
  final cron = Cron();
  final List<ScheduledTask> tasks = List.empty(growable: true);

  /// This method schedules a cron job.
  ///
  /// @param schedule Cron String
  /// @param function Function to be called by cron job
  ScheduledTask scheduleJob(String schedule, VoidCallback function) {
    final task = cron.schedule(Schedule.parse(schedule), () async {
      function();
    });
    tasks.add(task);
    return task;
  }

  /// This method calculates the responsive height between the elements in the homescreen.
  ///
  /// @param contect BuildContext of parent Widget
  double getResponsiveHeight(BuildContext context) {
    var temp = MediaQuery.of(context).size.height - 82 * 8;
    if (temp < 0) return 0;
    return temp;
  }

  /// This method cancels a cron job.
  ///
  /// @param task The cron task to be canceled.
  void cancelJob(ScheduledTask task) {
    tasks.remove(task);
    task.cancel();
  }

  //** INTERNET CONNECTIVITY **
  Map source = {ConnectivityResult.none: false}.obs;
  MyConnectivity _connectivity = MyConnectivity.instance;

  /// This method gets the connection mode of the device.
  void getConnectionMode() {
    _connectivity.initialise();
    _connectivity.myStream.listen((src) {
      source.assignAll(src);
    });
  }

  /// This method checks if a internet connection can be established.
  bool checkInternetConnection() {
    var conResult = source.keys.toList().first;
    if (conResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
