import 'package:flutter/material.dart';
import 'package:geiger_edu/globals.dart' as globals;
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/lesson_screen.dart';
import 'package:geiger_edu/screens/lesson_selection_screen.dart';
import 'package:geiger_edu/screens/profile_screen.dart';
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
        // TODO use dynamic lesson path
        return MaterialPageRoute(builder: (context) => LessonScreen(lessonPath: "assets/lesson/password/password_safety/eng"));

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
        return MaterialPageRoute(builder: (context) => LessonSelectionScreen(title:globals.lessonTitle, lessons: globals.lessons));

      default:
        return MaterialPageRoute(builder: (context) => HomeScreen());
    }
  }
}