import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/profile_controller.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/route_generator.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/services/lesson_loader.dart';
import 'package:geiger_edu/widgets/LoadingAnimation.dart';
import 'package:get/get.dart';

import 'controller/global_controller.dart';

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

class MyApp extends StatefulWidget{
  final globalController = Get.put(GlobalController());
  final settingsController = Get.put(SettingsController());
  final lessonController = Get.put(LessonController());
  final profileController = Get.put(ProfileController());

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  void initState(){
    super.initState();

    //** LOAD LESSON DATA **
    LessonLoader.loadLessonData(context);

    widget.lessonController.calculateCompletedLessons();

    Future.delayed(
        Duration(seconds: 5),
            (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
          width: MediaQuery
              .of(context)
              .size
              .width/2,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/img/splashscreen/splashscreen_logo.png", fit: BoxFit.fitWidth),
                SizedBox(height: 40),
                LoadingAnimation(width: 140)
              ])
          )
      )
    );
  }
}