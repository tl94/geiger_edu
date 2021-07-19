// TODO Implement this library.
library geiger_edu.globals;

import 'package:flutter/cupertino.dart';

final txtColor = const Color(0xff2f4858);

bool appRunning = false;
bool isOnline = false;

// TODO: IMPLEMENT CURRENT LESSON PARAMS
int selectedPage = 1;
List<num> lessons = [];

//** USER DATA **
//Hive-listener Key
String defaultUser = 'default';

//** ICONS **
String userImg = "assets/img/profile/user_icon.png";