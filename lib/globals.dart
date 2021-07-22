library geiger_edu.globals;

import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/model/quiz/question.dart';

import 'model/difficultyLevelObj.dart';
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
//TODO: Fix currentLessonSlideIndex
String currentLessonPath = "assets/lesson/password/password_safety/eng";
int currentLessonSlideIndex = 0;
String lessonTitle ='';
Lesson currentLesson = Lesson(name: "Password Safety", completed: false, recommended: false, lastIndex: 0,maxIndex: 5, motivation: 'This is an easy beginner lesson', difficultyLevel: DifficultyLevel.beginner, lengthInMinutes: 5, apiUrl: '', path: "assets/lesson/password/password_safety/eng");


//** QUIZ STATE **
List<Question> answeredQuestions = [];