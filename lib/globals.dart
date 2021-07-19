// TODO Implement this library.
library geiger_edu.globals;

import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/model/userObj.dart';
import 'package:geiger_edu/providers/boxes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


final txtColor = const Color(0xff2f4858);

bool appRunning = false;
bool isOnline = false;

// TODO: IMPLEMENT CURRENT LESSON PARAMS
int selectedPage = 1;
List<num> lessons = [];


// TODO: GEIGER API CONNECTION
String apiKey = '6b4c7cac60be10eddc8890c63817e773';

//** USER DATA **
//TODO: Put it inside the local DB
//TODO: Make a USER Class in model
String userImg = "assets/img/profile/user_icon.png";
//User score
int lessonScore = 225;
//User profile image
String currentImage = "assets/img/profile/default.png";