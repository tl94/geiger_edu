import 'package:flutter/material.dart';
import 'package:geiger_edu/screens/homescreen.dart';
import 'package:geiger_edu/screens/lessonscreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case HomeScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case LessonScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => LessonScreen());

      default:
        return MaterialPageRoute(builder: (context) => HomeScreen());
    }
  }
}