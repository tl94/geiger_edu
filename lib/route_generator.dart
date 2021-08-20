import 'package:flutter/material.dart';
import 'package:geiger_edu/screens/chat_screen.dart';
import 'package:geiger_edu/screens/comments_screen.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/screens/lesson_screen.dart';
import 'package:geiger_edu/screens/lesson_selection_screen.dart';
import 'package:geiger_edu/screens/profile_screen.dart';
import 'package:geiger_edu/screens/lesson_category_selection_screen.dart';
import 'package:geiger_edu/screens/settings_screen.dart';

/// This class handles the application routing.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class RouteGenerator {

  static Route<dynamic> generateRoute(RouteSettings settings) {

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

      case LessonCategorySelectionScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => LessonCategorySelectionScreen());

      case SettingsScreen.routeName:
        // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => SettingsScreen());

      case CommentsScreen.routeName:
      // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => CommentsScreen());

      case LessonSelectionScreen.routeName:
      // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => LessonSelectionScreen());

      case ChatScreen.routeName:
      // MaterialPageRoute transitions to the new route using a platform specific animation.
        return MaterialPageRoute(builder: (context) => ChatScreen());

      default:
        return MaterialPageRoute(builder: (context) => HomeScreen());
    }
  }
}