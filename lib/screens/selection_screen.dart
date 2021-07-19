import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/profile_screen.dart';
import 'package:geiger_edu/widgets/NavigationContainer.dart';

import 'lesson_screen.dart';
import 'package:geiger_edu/globals.dart';

class SelectionScreen extends StatelessWidget {
  static const routeName = '/selection';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                child: NavigationContainer(
                  imagePath: "assets/img/password_icon.png",
                  text: "Passwords",
                  passedRoute: HomeScreen.routeName,
                  currentValue: 1,
                  maxValue: 2,
                )
            )

              ],
            ),

        ),
      );
  }
}