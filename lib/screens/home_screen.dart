import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/screens/profile_screen.dart';
import 'package:geiger_edu/screens/selection_screen.dart';
import 'package:geiger_edu/screens/settings_screen.dart';
import 'package:geiger_edu/services/lesson_loader.dart';
import 'package:geiger_edu/widgets/Indicator.dart';
import 'package:geiger_edu/widgets/NavigationContainer.dart';

import 'lesson_screen.dart';
import 'package:geiger_edu/globals.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/homescreen';

  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new Container(),
        title: Text("GEIGER Mobile Learning"),
        centerTitle: true,
        backgroundColor: bckColor,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Stack(children: [
              Align(alignment: Alignment.center,child: Indicator()),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 140, 0, 0),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(child: ElevatedButton(
                      child: Text("load lessons"),
                      onPressed: () {
                        // LessonLoader.test();
                        LessonLoader.loadLessons(context);
                      },
                    )),
                Container(
                    child: NavigationContainer(
                      imagePath: "assets/img/continue_lesson.png",
                      text: "Current Lesson",
                      passedRoute: LessonScreen.routeName,
                    )
                ),
                SizedBox(height: 10),
                Container(
                    child: NavigationContainer(
                      imagePath: "assets/img/select_lesson.png",
                      text: "Select Lesson",
                      passedRoute: SelectionScreen.routeName,
                    )
                ),
                Spacer(),
                Container(
                    child: NavigationContainer(
                      imagePath: "assets/img/profile/user_icon.png",
                      text: "Profile",
                      passedRoute: ProfileScreen.routeName,
                    )
                ),
                SizedBox(height: 10),
                Container(
                    child: NavigationContainer(
                      imagePath: "assets/img/settings_icon.png",
                      text: "Settings",
                      passedRoute: SettingsScreen.routeName,
                    )
                )
              ])
              )
            ])
        ),
      );
  }
}