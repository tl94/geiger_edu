import 'package:flutter/material.dart';
import 'package:geiger_edu/globals.dart' as globals;
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/screens/lesson_screen.dart';
import 'package:geiger_edu/screens/lesson_selection_screen.dart';
import 'package:geiger_edu/screens/profile_screen.dart';
import 'package:geiger_edu/screens/quiz_results_screen.dart';
import 'package:geiger_edu/widgets/lesson/quiz_slide.dart';
import 'package:geiger_edu/screens/selection_screen.dart';
import 'package:geiger_edu/screens/settings_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case HomeScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case LessonScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => LessonScreen(lesson: globals.currentLesson, initialPage: globals.currentLessonSlideIndex));

      case LessonCompleteScreen.routeName:
      // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => LessonCompleteScreen(lesson: globals.currentLesson, answeredQuestions: globals.answeredQuestions));

      case ProfileScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => ProfileScreen());

      case SelectionScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => SelectionScreen());

      case SettingsScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => SettingsScreen());

      case LessonSelectionScreen.routeName:
      // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => LessonSelectionScreen(categoryTitle: globals.categoryTitle, lessons: globals.lessons));

      default:
        return MaterialPageRoute(builder: (context) => HomeScreen());
    }
  }
}