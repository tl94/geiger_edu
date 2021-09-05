import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geiger_edu/controller/chat_controller.dart';
import 'package:geiger_edu/controller/io_controller.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/profile_controller.dart';
import 'package:geiger_edu/controller/quiz_controller.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/providers/app_translations.dart';
import 'package:geiger_edu/route_generator.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/loading_animation.dart';
import 'package:get/get.dart';

import 'controller/comments_controller.dart';
import 'controller/global_controller.dart';
import 'controller/lesson_category_selection_controller.dart';
import 'controller/lesson_complete_controller.dart';
import 'controller/lesson_selection_controller.dart';

/// Entry point of the application.
///
/// @author Felix Mayer
/// @author Turan Ledermann

// local server to run the lessons on
InAppLocalhostServer localhostServer = new InAppLocalhostServer();

void main() async {
  //** INITIALISE DATABASE **
  await DB.init();

  //** LESSON-SERVER **
  await localhostServer.start();

  runApp(GetMaterialApp(
    title: 'GEIGER Mobile Learning',
    theme: ThemeData(primaryColor: Color(0xff3ac279)),
    //Old Theme color: Color(0xFF5dbcd2);
    locale: Get.deviceLocale,
    translationsKeys: AppTranslations.translationsKeys,
    fallbackLocale: Locale('en'),
    home: MyApp(),
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}

/// This class functions as the initialisation point.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    //** INITIALISE CONTROLLERS **
    final globalController = Get.put(GlobalController());
    final settingsController = Get.put(SettingsController());
    final ioController = Get.put(IOController());
    final lessonController = Get.put(LessonController());
    final lessonCategorySelectionController =
        Get.put(LessonCategorySelectionController());
    final lessonSelectionController = Get.put(LessonSelectionController());
    final quizController = Get.put(QuizController());
    final lessonCompleteController = Get.put(LessonCompleteController());
    final profileController = Get.put(ProfileController());
    final chatController = Get.put(ChatController());
    final commentsController = Get.put(CommentsController());

    //** load lesson data **
    ioController.loadLessonData(context);

    //** start internet connection check **
    globalController.getConnectionMode();

    //** set lesson language **
    settingsController.setLessonLanguageForLocale();

    /// Application splashscreen.
    Future.delayed(Duration(seconds: 3), () {
      lessonController.setLessonNumbers();
      lessonController.updateIndicator();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen())); //HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          "assets/img/splashscreen/splashscreen_logo.png",
                          fit: BoxFit.fitWidth),
                      SizedBox(height: 40),
                      LoadingAnimation(width: 140)
                    ]))));
  }
}
