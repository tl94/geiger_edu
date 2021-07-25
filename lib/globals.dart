library geiger_edu.globals;

import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/model/quiz/question.dart';

import 'model/difficultyObj.dart';
import 'model/lessonObj.dart';

final txtColor = const Color(0xff2f4858);

bool appRunning = false;
bool isOnline = false;

//** GEIGER INDICATOR **
int completedLessons = 0;
int maxLessons = 0;

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
String categoryTitle = '';
Lesson currentLesson = Lesson(
    lessonId: "LPW001",
    lessonCategoryId: '',
    title: {"eng": "Password Safety", "ger": "Passwortsicherheit"},
    completed: true,
    recommended: false,
    lastIndex: 0,
    maxIndex: 5,
    motivation: {
      "eng": "Improve your password security!",
      "ger": "Verbessere deine Passwortsicherheit!"
    },
    difficulty: Difficulty.beginner,
    duration: 5,
    apiUrl: '',
    path: 'assets/lesson/password/password_safety/eng',
    hasQuiz: true);

//** QUIZ STATE **
List<Question> answeredQuestions = [];

//** LANGUAGE SETTING **
String language = 'eng';