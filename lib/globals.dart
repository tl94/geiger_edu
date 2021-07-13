// TODO Implement this library.
library geiger_edu.globals;

import 'package:flutter/cupertino.dart';

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
String userName = "Clara Kavali";
String userImg = "assets/img/profile/user_icon.png";
//User score
int lessonScore = 225;
//User profile image
String currentImage = "assets/img/profile/default.png";