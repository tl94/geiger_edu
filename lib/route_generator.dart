import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/globals.dart' as globals;
import 'package:geiger_edu/screens/comments_screen.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/screens/lesson_screen.dart';
import 'package:geiger_edu/screens/lesson_selection_screen.dart';
import 'package:geiger_edu/screens/profile_screen.dart';
import 'package:geiger_edu/screens/quiz_results_screen.dart';
import 'package:geiger_edu/widgets/lesson/quiz_slide.dart';
import 'package:geiger_edu/screens/selection_screen.dart';
import 'package:geiger_edu/screens/settings_screen.dart';
import 'package:get/get.dart';

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

    final LessonController lessonController = Get.find();

    switch (settings.name) {

      case HomeScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case LessonScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => LessonScreen());

      case LessonCompleteScreen.routeName:
      // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => LessonCompleteScreen());

      case ProfileScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => ProfileScreen());

      case SelectionScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => SelectionScreen());

      case SettingsScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => SettingsScreen());

      case CommentsScreen.routeName:
      // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => CommentsScreen());

      case LessonSelectionScreen.routeName:
      // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => LessonSelectionScreen(categoryTitle: lessonController.categoryTitle, lessons: lessonController.getLessons()));

      default:
        return MaterialPageRoute(builder: (context) => HomeScreen());
    }
  }
}