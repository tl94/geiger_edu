import 'dart:convert';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/services/internet_connectivity.dart';
import 'package:get/get.dart';

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

  //** INTERNET CONNECTIVITY **
  Map source = {ConnectivityResult.none: false}.obs;
  MyConnectivity _connectivity = MyConnectivity.instance;

  void getConnectionMode() {
    //online offline check
    //print("ENTER::");
    _connectivity.initialise();
    _connectivity.myStream.listen((src) {
      //_source = source;
      source.assignAll(src);
      //print("MATRIX CHANGED:: " + source.keys.toList()[0].toString());
    });
  }

  bool checkInternetConnection() {
    var conResult = source.keys.toList().first;
    if (conResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  //** IMAGE FULLSCREEN VIEW **
  String selectedImage = "";
}
