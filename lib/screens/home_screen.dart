import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/screens/profile_screen.dart';
import 'package:geiger_edu/screens/selection_screen.dart';
import 'package:geiger_edu/screens/settings_screen.dart';
import 'package:geiger_edu/services/lesson_loader.dart';
import 'package:geiger_edu/widgets/Indicator.dart';
import 'package:geiger_edu/widgets/LoadingAnimation.dart';
import 'package:geiger_edu/widgets/NavigationContainer.dart';

import 'comments_screen.dart';
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
      body:
      Container(
          child: SingleChildScrollView(
            child:Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Stack(children: [
                        Align(alignment: Alignment.center,child: Indicator(height: 120)),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 120, 0, 0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  NavigationContainer(
                                        imagePath: "assets/img/continue_lesson.png",
                                        text: "Current Lesson",
                                        passedRoute: LessonScreen.routeName
                                  ),
                                  NavigationContainer(
                                        imagePath: "assets/img/select_lesson.png",
                                        text: "Select Lesson",
                                        passedRoute: SelectionScreen.routeName
                                  ),
                                  NavigationContainer(
                                      imagePath: "assets/img/my_comments.png",
                                      text: "My Comments",
                                      passedRoute: CommentsScreen.routeName
                                  ),
                                  SizedBox(height: 50),
                                  NavigationContainer(
                                        imagePath: "assets/img/profile/user_icon.png",
                                        text: "Profile",
                                        passedRoute: ProfileScreen.routeName
                                  ),
                                  NavigationContainer(
                                        imagePath: "assets/img/settings_icon.png",
                                        text: "Settings",
                                        passedRoute: SettingsScreen.routeName
                                      )
                                  ])
                        )
                      ]),
                    ])
            )
          )
      ),
      );
  }
}