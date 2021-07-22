library geiger_edu.globals;

import 'package:flutter/cupertino.dart';

import 'model/lessonObj.dart';

final txtColor = const Color(0xff2f4858);

bool appRunning = false;
bool isOnline = false;

//** USER DATA **
//Hive-listener Key
String defaultUser = 'default';
String defaultSetting = 'default';

//** ICONS **
String userImg = "assets/img/profile/user_icon.png";

//** LESSON SELECTION **
List<Lesson> lessons = [];
String lessonTitle='';