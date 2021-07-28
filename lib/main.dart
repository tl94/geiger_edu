import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/profile_controller.dart';
import 'package:geiger_edu/controller/quiz_controller.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/route_generator.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/controller/io_controller.dart';
import 'package:geiger_edu/widgets/loading_animation.dart';
import 'package:get/get.dart';

import 'controller/global_controller.dart';
import 'controller/lesson_category_selection_controller.dart';
import 'controller/lesson_complete_controller.dart';
import 'controller/lesson_selection_controller.dart';

InAppLocalhostServer localhostServer = new InAppLocalhostServer();

void main() async {
  //** INITIALISE DATABASE **
  await DB.init();

  //** LESSON-SERVER **
  await localhostServer.start();

  runApp(GetMaterialApp(
    title: 'GEIGER mobile learning',
    theme: ThemeData(primaryColor: Color(0xFF5dbcd2)),
    home: MyApp(),
    onGenerateRoute: RouteGenerator.generateRoute,
  ));
}

class MyApp extends StatefulWidget {
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

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    //** LOAD LESSON DATA **
    widget.ioController.loadLessonData(context);

    Future.delayed(Duration(seconds: 5), () {
      widget.lessonController.getLessonNumbers();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
