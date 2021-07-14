import 'package:flutter/material.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/lesson_screen.dart';
import 'package:geiger_edu/screens/profile_screen.dart';

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

      default:
        return MaterialPageRoute(builder: (context) => HomeScreen());
    }
  }
}