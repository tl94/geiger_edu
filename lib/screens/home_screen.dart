import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/screens/profile_screen.dart';
import 'package:geiger_edu/widgets/NavigationContainer.dart';

import 'lesson_screen.dart';

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
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //simple navigation
            Container(
              child: NavigationContainer(
                imagePath: "assets/img/continue_lesson.png",
                text: "Current Lesson",
                passedRoute: LessonScreen.routeName,
              )
            ),
            Spacer(),
            Container(
                child: NavigationContainer(
                  imagePath: "assets/img/profile/user_icon.png",
                  text: "Profile",
                  passedRoute: ProfileScreen.routeName,
                )
            )

              ],
            ),

        ),
      );
  }
}